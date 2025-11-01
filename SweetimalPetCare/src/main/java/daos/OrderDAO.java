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
 * OrderDAO - finalize (checkout) a draft order and helpers to read orders.
 *
 * Notes:
 * - Persists shipping_fee = 0.0 because Orders.shipping_fee is NOT NULL in schema.
 * - Finalize logic chooses an order_status that exists in OrderStatus table to avoid FK errors.
 * - For EWALLET: order_status = PENDING (awaiting payment), payment_status = PENDING.
 * - For CASH/COD: order_status = PROCESSING (handling), payment_status = PENDING.
 * - Stock is decremented when finalizing/placeOrderFromCartItems (reserve behavior).
 */
public class OrderDAO extends DBContext {

    private static final Logger LOG = Logger.getLogger(OrderDAO.class.getName());

    /**
     * Finalize draft order (no shippingFee passed in; we persist shipping_fee = 0.00).
     * Looks up the latest draft order (order_code like CART-{customerId}-% and order_status = PENDING),
     * validates & decrements stock, chooses a valid order_status, updates order and totals, writes history.
     *
     * @param customerId
     * @param shippingAddressId
     * @param paymentMethod (e.g. "CASH" or "EWALLET")
     * @return finalized orderId
     * @throws SQLException
     */
    public long finalizeDraftOrder(long customerId, long shippingAddressId, String paymentMethod) throws SQLException {
        getConnection().setAutoCommit(false);
        try {
            Long orderId = null;
            // Find the latest draft cart order for this customer (PENDING draft).
            String sqlFind = "SELECT TOP 1 order_id, order_code FROM Orders WHERE customer_id = ? AND order_code LIKE ? AND order_status = ? ORDER BY created_at DESC";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlFind)) {
                ps.setLong(1, customerId);
                ps.setString(2, "CART-" + customerId + "-%");
                ps.setString(3, "PENDING");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) orderId = rs.getLong("order_id");
                    else throw new SQLException("No draft cart found");
                }
            }

            // gather items
            List<Long> vids = new ArrayList<>();
            List<Integer> qtys = new ArrayList<>();
            String sqlItems = "SELECT variant_id, unit_price, quantity FROM OrderItems WHERE order_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlItems)) {
                ps.setLong(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        vids.add(rs.getLong("variant_id"));
                        qtys.add(rs.getInt("quantity"));
                    }
                }
            }
            if (vids.isEmpty()) throw new SQLException("Cart is empty");

            // validate & decrement stock
            String sqlCheck = "SELECT stock_quantity FROM ProductVariant WHERE variant_id = ?";
            String sqlDec = "UPDATE ProductVariant SET stock_quantity = stock_quantity - ? WHERE variant_id = ? AND stock_quantity >= ?";
            for (int i = 0; i < vids.size(); i++) {
                long vid = vids.get(i);
                int need = qtys.get(i);
                try (PreparedStatement ps = getConnection().prepareStatement(sqlCheck)) {
                    ps.setLong(1, vid);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SQLException("Variant missing " + vid);
                        int stock = rs.getInt("stock_quantity");
                        if (stock < need) throw new SQLException("Insufficient stock for variant " + vid);
                    }
                }
                try (PreparedStatement ps = getConnection().prepareStatement(sqlDec)) {
                    ps.setInt(1, need);
                    ps.setLong(2, vid);
                    ps.setInt(3, need);
                    int rows = ps.executeUpdate();
                    if (rows == 0) throw new SQLException("Failed to decrement stock for " + vid);
                }
            }

            // determine desired order status + payment status based on paymentMethod
            String desiredStatus;
            String paymentStatus = "PENDING";

            if (paymentMethod != null && "EWALLET".equalsIgnoreCase(paymentMethod.trim())) {
                desiredStatus = "PENDING";
                paymentStatus = "PENDING";
            } else if (paymentMethod != null && ("CASH".equalsIgnoreCase(paymentMethod.trim()) || "COD".equalsIgnoreCase(paymentMethod.trim()))) {
                desiredStatus = "PROCESSING";
                paymentStatus = "PENDING";
            } else {
                desiredStatus = "PENDING";
                paymentStatus = "PENDING";
            }

            // verify desiredStatus exists in OrderStatus table; fallback to PENDING or first available
            boolean statusExists = false;
            try (PreparedStatement ps = getConnection().prepareStatement("SELECT 1 FROM OrderStatus WHERE order_status_code = ?")) {
                ps.setString(1, desiredStatus);
                try (ResultSet rs = ps.executeQuery()) {
                    statusExists = rs.next();
                }
            }
            if (!statusExists) {
                try (PreparedStatement ps = getConnection().prepareStatement("SELECT 1 FROM OrderStatus WHERE order_status_code = ?")) {
                    ps.setString(1, "PENDING");
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            desiredStatus = "PENDING";
                            statusExists = true;
                        }
                    }
                }
            }
            if (!statusExists) {
                try (PreparedStatement ps = getConnection().prepareStatement("SELECT TOP 1 order_status_code FROM OrderStatus")) {
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            desiredStatus = rs.getString("order_status_code");
                            statusExists = true;
                        }
                    }
                }
            }
            if (!statusExists) {
                throw new SQLException("No valid order_status codes present in OrderStatus table");
            }

            // update order: set shipping_address_id, shipping_fee=0, order_status, payment_method_code, payment_status
            String sqlUpdate = "UPDATE Orders SET shipping_address_id = ?, shipping_fee = ?, order_status = ?, payment_method_code = ?, payment_status = ?, updated_at = SYSUTCDATETIME() WHERE order_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlUpdate)) {
                ps.setLong(1, shippingAddressId);
                ps.setDouble(2, 0.0);
                ps.setString(3, desiredStatus);
                ps.setString(4, paymentMethod);
                ps.setString(5, paymentStatus);
                ps.setLong(6, orderId);
                ps.executeUpdate();
            }

            // recalc totals (include shipping_fee which is 0.0)
            String sqlRecalc = "UPDATE Orders SET subtotal_amount = ISNULL(s.sub,0), total_amount = ISNULL(s.sub,0)+ISNULL(shipping_fee,0) "
                    + "FROM Orders o LEFT JOIN (SELECT order_id, SUM(unit_price*quantity) sub FROM OrderItems WHERE order_id = ? GROUP BY order_id) s ON s.order_id = o.order_id WHERE o.order_id = ?";
            try (PreparedStatement ps = getConnection().prepareStatement(sqlRecalc)) {
                ps.setLong(1, orderId);
                ps.setLong(2, orderId);
                ps.executeUpdate();
            }

            // insert order status history (best-effort)
            try (PreparedStatement ps = getConnection().prepareStatement("INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, comment, created_at) VALUES (?, ?, ?, ?, SYSUTCDATETIME())")) {
                ps.setLong(1, orderId);
                ps.setString(2, desiredStatus);
                ps.setLong(3, customerId);
                ps.setString(4, "Order finalized");
                ps.executeUpdate();
            } catch (SQLException ignore) {}

            getConnection().commit();
            return orderId;
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            LOG.log(Level.SEVERE, "Order creation failed", ex);
            throw ex;
        }
    }

    /**
     * Create a full order from CartItem table WITHOUT charging shipping (persist shipping_fee = 0.0).
     */
    public long placeOrderFromCartItems(int customerId, int shippingAddressId, String paymentMethod) throws SQLException {
        getConnection().setAutoCommit(false);
        try {
            String sqlCart = "SELECT ci.variant_id, ci.quantity, v.price, v.stock_quantity, v.product_id FROM CartItem ci JOIN ProductVariant v ON ci.variant_id = v.variant_id WHERE ci.customer_id = ?";
            List<Long> vids = new ArrayList<>();
            List<Integer> qtys = new ArrayList<>();
            List<Double> prices = new ArrayList<>();
            try (PreparedStatement ps = getConnection().prepareStatement(sqlCart)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        vids.add(rs.getLong("variant_id"));
                        qtys.add(rs.getInt("quantity"));
                        // price may be numeric/decimal
                        double price = 0.0;
                        try {
                            java.math.BigDecimal bd = rs.getBigDecimal("price");
                            if (bd != null) price = bd.doubleValue();
                            else price = rs.getDouble("price");
                        } catch (SQLException ignore) {
                            price = rs.getDouble("price");
                        }
                        prices.add(price);
                    }
                }
            }
            if (vids.isEmpty()) throw new SQLException("Cart is empty");

            double subtotal = 0.0;
            for (int i = 0; i < vids.size(); i++) subtotal += prices.get(i) * qtys.get(i);
            double total = subtotal; // no shipping

            // insert Orders - include shipping_fee column and persist 0.0
            String orderCode = "ORD" + System.currentTimeMillis();
            String sqlInsOrder = "INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, subtotal_amount, shipping_fee, total_amount, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME())";
            long orderId;
            try (PreparedStatement ps = getConnection().prepareStatement(sqlInsOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, orderCode);
                ps.setInt(2, customerId);
                ps.setInt(3, shippingAddressId);
                ps.setString(4, "PENDING");
                ps.setDouble(5, subtotal);
                ps.setDouble(6, 0.0);
                ps.setDouble(7, total);
                ps.executeUpdate();
                try (ResultSet gk = ps.getGeneratedKeys()) {
                    if (gk.next()) orderId = gk.getLong(1);
                    else throw new SQLException("No order id returned");
                }
            }

            // insert order items and decrement stock
            String sqlInsItem = "INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity, line_total) VALUES (?, ?, ?, ?, ?)";
            String sqlDec = "UPDATE ProductVariant SET stock_quantity = stock_quantity - ? WHERE variant_id = ? AND stock_quantity >= ?";
            for (int i = 0; i < vids.size(); i++) {
                long vid = vids.get(i);
                int q = qtys.get(i);
                double p = prices.get(i);
                try (PreparedStatement psi = getConnection().prepareStatement(sqlInsItem)) {
                    psi.setLong(1, orderId);
                    psi.setLong(2, vid);
                    psi.setDouble(3, p);
                    psi.setInt(4, q);
                    psi.setDouble(5, p * q);
                    psi.executeUpdate();
                }
                try (PreparedStatement psd = getConnection().prepareStatement(sqlDec)) {
                    psd.setInt(1, q);
                    psd.setLong(2, vid);
                    psd.setInt(3, q);
                    int rows = psd.executeUpdate();
                    if (rows == 0) throw new SQLException("Insufficient stock for variant " + vid);
                }
            }

            // delete cart items for user
            try (PreparedStatement ps = getConnection().prepareStatement("DELETE FROM CartItem WHERE customer_id = ?")) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
            }

            getConnection().commit();
            return orderId;
        } catch (SQLException ex) {
            try { getConnection().rollback(); } catch (SQLException ignore) {}
            LOG.log(Level.SEVERE, "placeOrderFromCartItems failed", ex);
            throw ex;
        }
    }

    /**
     * Read an order by id and map to model.Order, including a formatted shippingAddressLine
     * and attempt to load customer display name into order.customerName.
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
            LOG.log(Level.SEVERE, "getOrderById failed for orderId=" + orderId, ex);
            throw ex;
        }

        if (order == null) return null;

        // Load shipping address line (if shippingAddressId present)
        if (order.getShippingAddressId() != null) {
            String addrSql = "SELECT label, recipient_name, address_line1, ward, district, city FROM UserAddress WHERE address_id = ?";
            try (PreparedStatement ps2 = getConnection().prepareStatement(addrSql)) {
                ps2.setLong(1, order.getShippingAddressId());
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        StringBuilder sb = new StringBuilder();
                        String label = rs2.getString("label");
                        String recipient = rs2.getString("recipient_name");
                        String line = rs2.getString("address_line1");
                        String ward = rs2.getString("ward");
                        String district = rs2.getString("district");
                        String city = rs2.getString("city");

                        if (label != null && !label.trim().isEmpty()) {
                            sb.append(label);
                        }
                        if (recipient != null && !recipient.trim().isEmpty()) {
                            if (sb.length() > 0) sb.append(" - ");
                            sb.append(recipient);
                        }
                        String comma = (sb.length() > 0) ? ", " : "";
                        if (line != null && !line.trim().isEmpty()) {
                            sb.append(comma).append(line);
                            comma = ", ";
                        }
                        if (ward != null && !ward.trim().isEmpty()) {
                            sb.append(comma).append(ward);
                            comma = ", ";
                        }
                        if (district != null && !district.trim().isEmpty()) {
                            sb.append(comma).append(district);
                            comma = ", ";
                        }
                        if (city != null && !city.trim().isEmpty()) {
                            sb.append(comma).append(city);
                        }

                        order.setShippingAddressLine(sb.toString());
                    }
                }
            } catch (SQLException ex) {
                // don't break order reading if address lookup fails
                LOG.log(Level.FINE, "Failed to load shipping address for order " + orderId, ex);
            }
        }

        // Load customer display name into order.customerName (try multiple common columns/tables)
        try {
            String cname = loadCustomerName(order.getCustomerId());
            if (cname != null && !cname.trim().isEmpty()) {
                order.setCustomerName(cname);
            }
        } catch (SQLException ex) {
            LOG.log(Level.FINE, "Failed to load customer name for order " + orderId, ex);
        }

        return order;
    }

    /**
     * Try several common queries to obtain a display name for a user/customer.
     * If a query fails (table/column not present) we catch and continue to next option.
     */
    private String loadCustomerName(long customerId) throws SQLException {
        String[] queries = new String[] {
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
                // ignore and try next query (table/column might not exist)
                LOG.log(Level.FINER, "loadCustomerName query failed: " + q, ex);
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
                   + "pv.image_url AS image_url, p.product_name AS product_name "
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
                    String prodName = null;
                    try { prodName = rs.getString("product_name"); } catch (SQLException ignore) {}
                    it.setProductName(prodName != null ? prodName : "");
                    list.add(it);
                }
            }
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "listOrderItems failed for orderId=" + orderId, ex);
            throw ex;
        }
        return list;
    }

    // other helper methods can be added here (e.g., listOrdersForUser, updateOrderStatus, etc.)
}