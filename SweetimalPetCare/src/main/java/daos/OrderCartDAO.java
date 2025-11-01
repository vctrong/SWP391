package daos;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.OrderItem;

/**
 * OrderCartDAO - simplified student version using getConnection().prepareStatement(...) directly.
 *
 * WARNING: This implementation calls getConnection() multiple times inside a method.
 * Ensure DBContext.getConnection() returns the same Connection within a method invocation,
 * otherwise transactions (setAutoCommit/commit/rollback) will not work correctly.
 */
public class OrderCartDAO extends DBContext {

    // Find or create a draft order for customer
    private long getOrCreateDraftOrderId(long customerId) throws SQLException {
        String sqlFind = "SELECT order_id FROM Orders WHERE customer_id = ? AND order_code LIKE ? AND order_status = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sqlFind)) {
            ps.setLong(1, customerId);
            ps.setString(2, "CART-" + customerId + "-%");
            ps.setString(3, "PENDING");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong("order_id");
            }
        }

        String sqlInsert = "INSERT INTO Orders(order_code, customer_id, order_status, payment_status, subtotal_amount, shipping_fee, total_amount, created_at) VALUES (?, ?, ?, ?, 0, 0, 0, SYSUTCDATETIME())";
        String orderCode = "CART-" + customerId + "-" + System.currentTimeMillis();
        try (PreparedStatement ps = getConnection().prepareStatement(sqlInsert, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, orderCode);
            ps.setLong(2, customerId);
            ps.setString(3, "PENDING");
            ps.setString(4, "PENDING");
            ps.executeUpdate();
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getLong(1);
            }
        }

        // fallback (rare)
        try (PreparedStatement ps = getConnection().prepareStatement("SELECT SCOPE_IDENTITY() AS id");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong("id");
        }

        throw new SQLException("Unable to create draft order for customer " + customerId);
    }

    // Recalculate subtotal and total for an order (single SQL statement)
    private void recalcAndUpdateOrderTotals(long orderId) throws SQLException {
        String sql =
            "UPDATE Orders SET subtotal_amount = ISNULL(t.sub,0), total_amount = ISNULL(t.sub,0) + ISNULL(shipping_fee,0), updated_at = SYSUTCDATETIME() " +
            "FROM Orders o LEFT JOIN (SELECT order_id, SUM(unit_price * quantity) AS sub FROM OrderItems WHERE order_id = ? GROUP BY order_id) t ON t.order_id = o.order_id " +
            "WHERE o.order_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, orderId);
            ps.executeUpdate();
        }
    }

    // Add variant into customer's draft order
    public void addToCart(long customerId, long variantId, int qty) throws SQLException {
        if (qty <= 0) qty = 1;

        // begin transaction on connection returned by getConnection()
        getConnection().setAutoCommit(false);
        try {
            // Validate variant
            String sqlVar = "SELECT price, stock_quantity FROM ProductVariant WHERE variant_id = ?";
            double price;
            int stock;
            try (PreparedStatement ps = getConnection().prepareStatement(sqlVar)) {
                ps.setLong(1, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("Variant not found: " + variantId);
                    price = rs.getBigDecimal("price") != null ? rs.getBigDecimal("price").doubleValue() : 0.0;
                    stock = rs.getInt("stock_quantity");
                }
            }

            if (stock < qty) throw new SQLException("Insufficient stock");

            long orderId = getOrCreateDraftOrderId(customerId);

            // Check existing OrderItem
            Long itemId = null;
            int existingQty = 0;
            String sqlCheck = "SELECT order_item_id, quantity FROM OrderItems WHERE order_id = ? AND variant_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlCheck)) {
                ps.setLong(1, orderId);
                ps.setLong(2, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        itemId = rs.getLong("order_item_id");
                        existingQty = rs.getInt("quantity");
                    }
                }
            }

            if (itemId != null) {
                int newQty = existingQty + qty;
                if (newQty > stock) newQty = stock;
                String sqlUpd = "UPDATE OrderItems SET quantity = ? WHERE order_item_id = ?";
                try (PreparedStatement ps = getConnection().prepareStatement(sqlUpd)) {
                    ps.setInt(1, newQty);
                    ps.setLong(2, itemId);
                    ps.executeUpdate();
                }
            } else {
                String sqlIns = "INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = getConnection().prepareStatement(sqlIns)) {
                    ps.setLong(1, orderId);
                    ps.setLong(2, variantId);
                    ps.setDouble(3, price);
                    ps.setInt(4, qty);
                    ps.executeUpdate();
                }
            }

            // Recalc totals
            recalcAndUpdateOrderTotals(orderId);

            // commit
            getConnection().commit();
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            throw ex;
        }
        // note: not resetting autocommit/closing connection per request
    }

    // List draft order items for a customer
    public List<OrderItem> listCartItemsByUser(long customerId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();

        Long orderId = null;
        String sqlFind = "SELECT order_id FROM Orders WHERE customer_id = ? AND order_code LIKE ? AND order_status = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sqlFind)) {
            ps.setLong(1, customerId);
            ps.setString(2, "CART-" + customerId + "-%");
            ps.setString(3, "PENDING");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) orderId = rs.getLong("order_id");
            }
        }
        if (orderId == null) return list;

        String sql = "SELECT oi.order_item_id, oi.order_id, oi.variant_id, oi.unit_price, oi.quantity, p.product_name, v.image_url " +
                     "FROM OrderItems oi JOIN ProductVariant v ON oi.variant_id = v.variant_id JOIN Product p ON v.product_id = p.product_id " +
                     "WHERE oi.order_id = ? ORDER BY oi.order_item_id DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem it = new OrderItem();
                    it.setOrderItemId(rs.getLong("order_item_id"));
                    it.setOrderId(rs.getLong("order_id"));
                    it.setVariantId(rs.getLong("variant_id"));
                    it.setUnitPrice(rs.getDouble("unit_price"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setProductName(rs.getString("product_name"));
                    it.setImageUrl(rs.getString("image_url"));
                    list.add(it);
                }
            }
        }
        return list;
    }

    // Update quantity for an order item
    public boolean updateOrderItemQuantity(long orderItemId, int newQty) throws SQLException {
        if (newQty <= 0) return false;

        getConnection().setAutoCommit(false);
        try {
            long orderId;
            long variantId;
            String sqlFind = "SELECT order_id, variant_id FROM OrderItems WHERE order_item_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlFind)) {
                ps.setLong(1, orderItemId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) { getConnection().rollback(); return false; }
                    orderId = rs.getLong("order_id");
                    variantId = rs.getLong("variant_id");
                }
            }

            String sqlStock = "SELECT stock_quantity FROM ProductVariant WHERE variant_id = ?";
            int stock;
            try (PreparedStatement ps = getConnection().prepareStatement(sqlStock)) {
                ps.setLong(1, variantId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) { getConnection().rollback(); return false; }
                    stock = rs.getInt("stock_quantity");
                }
            }

            if (newQty > stock) newQty = stock;

            String sqlUpd = "UPDATE OrderItems SET quantity = ? WHERE order_item_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlUpd)) {
                ps.setInt(1, newQty);
                ps.setLong(2, orderItemId);
                ps.executeUpdate();
            }

            recalcAndUpdateOrderTotals(orderId);
            getConnection().commit();
            return true;
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            throw ex;
        }
    }

    // Remove an order item
    public boolean removeOrderItem(long orderItemId) throws SQLException {
        getConnection().setAutoCommit(false);
        try {
            Long orderId = null;
            String sqlFind = "SELECT order_id FROM OrderItems WHERE order_item_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlFind)) {
                ps.setLong(1, orderItemId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) orderId = rs.getLong("order_id");
                }
            }

            String sqlDel = "DELETE FROM OrderItems WHERE order_item_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlDel)) {
                ps.setLong(1, orderItemId);
                ps.executeUpdate();
            }

            if (orderId != null) recalcAndUpdateOrderTotals(orderId);
            getConnection().commit();
            return true;
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            throw ex;
        }
    }
}