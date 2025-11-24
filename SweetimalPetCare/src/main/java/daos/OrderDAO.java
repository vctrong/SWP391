package daos;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;
import model.OrderItem;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class OrderDAO extends DBContext {
/**
     * Create an order from CartItems table (DB-backed cart).
     * Reads CartItems entries for the customer (user_id), inserts an Orders row and OrderItems rows.
     * The DB trigger on OrderItems should handle stock decrement and the DB computed column handles line_total.
     *
     * @param customerId the user id (customer)
     * @param shippingAddressId shipping address id (may be 0 if none)
    * @param paymentMethod payment method code (e.g., "CASH","BANK")
     * @return created order id
     * @throws SQLException on DB error or validation failure
     */
    public long placeOrderFromCartItems(int customerId, int shippingAddressId, String paymentMethod) throws SQLException {
        // Use inline logger calls to match project style
        java.util.logging.Logger.getLogger(OrderDAO.class.getName()).info("[order] placeOrderFromCartItems for user=" + customerId);

        getConnection().setAutoCommit(false);
        try {
            // Read cart items (variant + qty + price)
            String sqlCart = "SELECT ci.variant_id, ci.quantity, v.price FROM CartItems ci JOIN ProductVariant v ON ci.variant_id = v.variant_id WHERE ci.user_id = ?";
            List<Long> vids = new ArrayList<>();
            List<Integer> qtys = new ArrayList<>();
            List<Double> prices = new ArrayList<>();
            try (PreparedStatement ps = getConnection().prepareStatement(sqlCart)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        vids.add(rs.getLong("variant_id"));
                        qtys.add(rs.getInt("quantity"));
                        double p = 0.0;
                        try {
                            java.math.BigDecimal bd = rs.getBigDecimal("price");
                            if (bd != null) p = bd.doubleValue();
                            else p = rs.getDouble("price");
                        } catch (SQLException ignore) {
                            p = rs.getDouble("price");
                        }
                        prices.add(p);
                    }
                }
            }

            if (vids.isEmpty()) {
                throw new SQLException("Cart is empty");
            }

            // Validate stock for each variant (do not decrement here; trigger will handle actual decrement)
            String sqlCheck = "SELECT stock_quantity FROM ProductVariant WHERE variant_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlCheck)) {
                for (int i = 0; i < vids.size(); i++) {
                    long vid = vids.get(i);
                    int need = qtys.get(i);
                    ps.setLong(1, vid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SQLException("Variant missing " + vid);
                        int stock = rs.getInt("stock_quantity");
                        if (stock < need) throw new SQLException("Insufficient stock for variant " + vid);
                    }
                    ps.clearParameters();
                }
            }

            // compute subtotal and total (we'll update later from OrderItems to be consistent)
            double subtotal = 0.0;
            for (int i = 0; i < vids.size(); i++) {
                subtotal += prices.get(i) * qtys.get(i);
            }
            double total = subtotal;

            // Insert Orders row
            String orderCode = "ORD" + System.currentTimeMillis();
            String sqlInsOrder = "INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, payment_method_code, subtotal_amount, shipping_fee, total_amount, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME())";
            long orderId;
            try (PreparedStatement ps = getConnection().prepareStatement(sqlInsOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, orderCode);
                ps.setInt(2, customerId);
                ps.setInt(3, shippingAddressId);
                ps.setString(4, "PENDING");
                ps.setString(5, paymentMethod);
                ps.setDouble(6, subtotal);
                ps.setDouble(7, 0.0);
                ps.setDouble(8, total);
                ps.executeUpdate();
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (gk.next()) orderId = gk.getLong(1);
                    else throw new SQLException("No order id returned");
                }
            }

            // Insert OrderItems WITHOUT line_total (DB computes line_total)
            String sqlInsItem = "INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psi = getConnection().prepareStatement(sqlInsItem)) {
                for (int i = 0; i < vids.size(); i++) {
                    long vid = vids.get(i);
                    int q = qtys.get(i);
                    double p = prices.get(i);
                    psi.setLong(1, orderId);
                    psi.setLong(2, vid);
                    psi.setDouble(3, p);
                    psi.setInt(4, q);
                    psi.executeUpdate(); // trigger TRG_UpdateStockOnOrder (if present) will run here
                    psi.clearParameters();
                }
            }

            // Recalculate order totals from OrderItems (preferred to reflect DB-computed values)
            String sqlUpdateTotals =
                    "UPDATE Orders SET subtotal_amount = ISNULL(s.sub,0), total_amount = ISNULL(s.sub,0) + ISNULL(shipping_fee,0), updated_at = SYSUTCDATETIME() "
                    + "FROM Orders o LEFT JOIN (SELECT order_id, SUM(unit_price * quantity) AS sub FROM OrderItems WHERE order_id = ? GROUP BY order_id) s ON s.order_id = o.order_id "
                    + "WHERE o.order_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlUpdateTotals)) {
                ps.setLong(1, orderId);
                ps.setLong(2, orderId);
                ps.executeUpdate();
            }

            // delete CartItems for this user
            try (PreparedStatement ps = getConnection().prepareStatement("DELETE FROM CartItems WHERE user_id = ?")) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
            }

            // insert order status history (best-effort)
            try (PreparedStatement ps = getConnection().prepareStatement("INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, comment, created_at) VALUES (?, ?, ?, ?, SYSUTCDATETIME())")) {
                ps.setLong(1, orderId);
                ps.setString(2, "PENDING");
                ps.setLong(3, customerId);
                ps.setString(4, "Order placed from cart");
                ps.executeUpdate();
            } catch (SQLException ignore) {}

            getConnection().commit();
            try { getConnection().setAutoCommit(true); } catch (SQLException ignore) {}
            java.util.logging.Logger.getLogger(OrderDAO.class.getName()).info("[order] created orderId=" + orderId + " for user=" + customerId);
            return orderId;
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            try { getConnection().setAutoCommit(true); } catch (SQLException ignore) {}
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "placeOrderFromCartItems failed for customer " + customerId, ex);
            throw ex;
        }
    }

    /**
     * Read an order by id and map to model.Order.
     */
    public Order getOrderById(long orderId) throws SQLException {
        Order order = null;
        String sql = "SELECT order_id, order_code, customer_id, shipping_address_id, order_status, payment_method_code, payment_status, subtotal_amount, shipping_fee, total_amount, notes, created_at, updated_at FROM Orders WHERE order_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setOrderCode(rs.getString("order_code"));
                    order.setCustomerId(rs.getLong("customer_id"));
                    long shipId = rs.getLong("shipping_address_id");
                    if (!rs.wasNull()) order.setShippingAddressId(shipId);
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setPaymentMethodCode(rs.getString("payment_method_code"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setSubtotalAmount(rs.getDouble("subtotal_amount"));
                    order.setShippingFee(rs.getDouble("shipping_fee"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setNotes(rs.getString("notes"));
                    try {
                        Timestamp ts = rs.getTimestamp("created_at");
                        if (ts != null) order.setCreatedAt(new java.util.Date(ts.getTime()));
                    } catch (SQLException ignore) {}
                    try {
                        Timestamp ts2 = rs.getTimestamp("updated_at");
                        if (ts2 != null) order.setUpdatedAt(new java.util.Date(ts2.getTime()));
                    } catch (SQLException ignore) {}
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "getOrderById failed for orderId=" + orderId, ex);
            throw ex;
        }
        return order;
    }

    /**
     * Try several common queries to obtain a display name for a user/customer.
     */
    private String loadCustomerName(long customerId) throws SQLException {
        String[] queries = new String[]{
            "SELECT full_name AS customer_name FROM Users WHERE user_id = ?",
            "SELECT display_name AS customer_name FROM Users WHERE user_id = ?",
            "SELECT name AS customer_name FROM Users WHERE user_id = ?",
            "SELECT username AS customer_name FROM Users WHERE user_id = ?",
            "SELECT full_name AS customer_name FROM Customer WHERE customer_id = ?",
            "SELECT name AS customer_name FROM Account WHERE user_id = ?"
        };

        for (String q : queries) {
            try (PreparedStatement ps = getConnection().prepareStatement(q)) {
                ps.setLong(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String v = rs.getString("customer_name");
                        if (v != null && !v.trim().isEmpty()) return v.trim();
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(OrderDAO.class.getName()).log(Level.FINER, "loadCustomerName query failed: " + q, ex);
                continue;
            }
        }
        return null;
    }

    /**
     * List order items for a given order id (joins to product/variant for display fields).
     */
    public List<OrderItem> listOrderItems(long orderId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.order_item_id, oi.order_id, oi.variant_id, oi.unit_price, oi.quantity, oi.line_total, "
            + "pv.image_url AS image_url, p.product_name AS product_name, pv.attribute_json AS attribute_json "
                + "FROM OrderItems oi LEFT JOIN ProductVariant pv ON oi.variant_id = pv.variant_id LEFT JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE oi.order_id = ? ORDER BY oi.order_item_id ASC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem it = new OrderItem();
                    it.setOrderItemId(rs.getLong("order_item_id"));
                    it.setOrderId(rs.getLong("order_id"));
                    it.setVariantId(rs.getLong("variant_id"));
                    try {
                        java.math.BigDecimal bd = rs.getBigDecimal("unit_price");
                        if (bd != null) it.setUnitPrice(bd.doubleValue());
                        else it.setUnitPrice(rs.getDouble("unit_price"));
                    } catch (SQLException ignore) {
                        it.setUnitPrice(rs.getDouble("unit_price"));
                    }
                    it.setQuantity(rs.getInt("quantity"));
                    try {
                        java.math.BigDecimal bd2 = rs.getBigDecimal("line_total");
                        if (bd2 != null) it.setLineTotal(bd2.doubleValue());
                        else it.setLineTotal(rs.getDouble("line_total"));
                    } catch (SQLException ignore) {
                        it.setLineTotal(rs.getDouble("line_total"));
                    }
                    it.setImageUrl(rs.getString("image_url"));
                    // new: pass attribute JSON from variant to OrderItem for display in JSP
                    try { it.setAttributeJson(rs.getString("attribute_json")); } catch (SQLException ignore) {}
                    String prodName = null;
                    try {
                        prodName = rs.getString("product_name");
                    } catch (SQLException ignore) {}
                    it.setProductName(prodName != null ? prodName : "");
                    list.add(it);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "listOrderItems failed for orderId=" + orderId, ex);
            throw ex;
        }
        return list;
    }

    /**
     * Check whether the given customer has purchased the given product.
     */
    public boolean hasCustomerPurchasedProduct(long customerId, long productId) throws SQLException {
        try {
            String sql = "SELECT TOP 1 1 "
                    + "FROM Orders o "
                    + "JOIN OrderItems oi ON oi.order_id = o.order_id "
                    + "JOIN ProductVariant pv ON pv.variant_id = oi.variant_id "
                    + "WHERE o.customer_id = ? AND pv.product_id = ? "
                    + "  AND o.order_status IN ('PAID','COMPLETED','SHIPPED','PROCESSING')";

            PreparedStatement st = new DBContext().getConnection().prepareStatement(sql);
            st.setLong(1, customerId);
            st.setLong(2, productId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                rs.close();
                st.close();
                return true;
            }

            rs.close();
            st.close();
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, "hasCustomerPurchasedProduct failed for customer=" + customerId + " product=" + productId, ex);
            throw ex;
        }
        return false;
    }
}