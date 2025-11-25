/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import dto.ProductForNewOrderDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.orderAdmin.order;
import model.orderAdmin.orderItem;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class OrderDAO extends db.DBContext {

    public List<order> getAllOrders() {
        List<order> list = new ArrayList<>();
        // Postgres dùng CONCAT tương tự SQL Server, OK
        String sql = "SELECT o.order_id, o.order_code, o.customer_id, o.shipping_address_id, "
                + "o.order_status, o.payment_method_code, o.payment_status, "
                + "o.subtotal_amount, o.shipping_fee, o.total_amount, "
                + "o.notes, o.created_at, o.updated_at, "
                + "u.full_name, "
                + "CONCAT(ua.address_line1, ', ', ua.ward, ', ', ua.district, ', ', ua.city) AS full_address "
                + "FROM Orders o "
                + "JOIN Users u ON o.customer_id = u.user_id "
                + "LEFT JOIN UserAddress ua ON o.shipping_address_id = ua.address_id "
                + "ORDER BY o.created_at DESC";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                order order = new order();

                // 1. Map các trường cơ bản từ bảng Orders
                order.setOrderId(rs.getLong("order_id"));
                order.setOrderCode(rs.getString("order_code"));
                order.setCustomerId(rs.getLong("customer_id"));

                // Xử lý shipping_address_id có thể null
                long shipId = rs.getLong("shipping_address_id");
                if (!rs.wasNull()) {
                    order.setShippingAddressId(shipId);
                }

                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethodCode(rs.getString("payment_method_code"));
                order.setPaymentStatus(rs.getString("payment_status"));

                order.setSubtotalAmount(rs.getDouble("subtotal_amount"));
                order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));

                order.setNotes(rs.getString("notes"));

                // Postgres trả về Timestamp chuẩn -> java.util.Date
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                // 2. Map các trường hiển thị (Joined columns)
                order.setCustomerName(rs.getString("full_name"));

                // Map địa chỉ đã nối chuỗi
                String address = rs.getString("full_address");
                // Nếu address null (do LEFT JOIN không tìm thấy), set giá trị mặc định
                order.setShippingAddressLine(address != null ? address : "Address not available");

                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ProductForNewOrderDTO> searchProducts(String keyword) {
        List<ProductForNewOrderDTO> list = new ArrayList<>();

        // FIX: Postgres dùng boolean (true/false) hoặc 1/0 nếu cột là smallint
        // Giả sử is_active của Product và Variant là BOOLEAN trong Postgres
        // Nếu là SMALLINT (như bảng users) thì dùng = 1
        // Code dưới đây dùng = true cho an toàn với Postgres boolean chuẩn
        // Nếu lỗi, đổi thành = 1
        String sql = "SELECT pv.variant_id, p.product_name, pv.sku, pv.attribute_json, "
                + "pv.price, pv.stock_quantity, pv.image_url "
                + "FROM ProductVariant pv "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE p.is_active IS TRUE AND pv.is_active IS TRUE " // Sửa = 1 thành IS TRUE
                + "AND (p.product_name LIKE ? OR pv.sku LIKE ? OR p.product_code LIKE ?)";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            // FIX: Postgres dùng setString thay vì setNString
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductForNewOrderDTO(
                            rs.getLong("variant_id"),
                            rs.getString("product_name"),
                            rs.getString("sku"),
                            rs.getString("attribute_json"),
                            rs.getBigDecimal("price"),
                            rs.getInt("stock_quantity"),
                            rs.getString("image_url")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public long insertOrder(order order) {
        long generatedOrderId = -1;
        String sqlOrder = "INSERT INTO Orders "
                + "(order_code, customer_id, shipping_address_id, order_status, "
                + "payment_method_code, payment_status, subtotal_amount, "
                + "shipping_fee, total_amount, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlItem = "INSERT INTO OrderItems (order_id, variant_id, unit_price, quantity) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rs = null;

        try {
            conn = this.openNewConnection();
            conn.setAutoCommit(false);

            // Postgres hỗ trợ RETURN_GENERATED_KEYS tốt
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);

            psOrder.setString(1, order.getOrderCode());
            psOrder.setLong(2, order.getCustomerId());

            // Xử lý null cho address_id nếu không có
            if (order.getShippingAddressId() > 0) {
                psOrder.setLong(3, order.getShippingAddressId());
            } else {
                psOrder.setNull(3, java.sql.Types.BIGINT);
            }

            psOrder.setString(4, order.getOrderStatus());
            psOrder.setString(5, order.getPaymentMethodCode());
            psOrder.setString(6, order.getPaymentStatus());

            // FIX: Nên dùng setBigDecimal cho tiền tệ
            psOrder.setBigDecimal(7, BigDecimal.valueOf(order.getSubtotalAmount()));
            psOrder.setBigDecimal(8, order.getShippingFee());
            psOrder.setBigDecimal(9, order.getTotalAmount());

            psOrder.setString(10, order.getNotes());

            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                generatedOrderId = rs.getLong(1);
                order.setOrderId(generatedOrderId);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }

            psItem = conn.prepareStatement(sqlItem);
            List<orderItem> items = order.getItems();
            if (items != null && !items.isEmpty()) {
                for (orderItem item : items) {
                    psItem.setLong(1, generatedOrderId);
                    psItem.setLong(2, item.getVariantId());
                    psItem.setBigDecimal(3, item.getUnitPrice());
                    psItem.setInt(4, item.getQuantity());

                    psItem.addBatch();
                }
                psItem.executeBatch();
            }
            conn.commit();
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (psOrder != null) {
                    psOrder.close();
                }
                if (psItem != null) {
                    psItem.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return generatedOrderId;
    }

    public BigDecimal getPriceVariantById(long variantId) {
        String sql = "select price from ProductVariant where variant_id = ?";
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, variantId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public order getOrderWithItemsById(long orderId) {
        order order = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = this.openNewConnection();

            // BƯỚC 1: Lấy thông tin chung
            String sqlOrder = "SELECT o.*, u.full_name, ua.phone, "
                    + "CONCAT(ua.address_line1, ', ', ua.ward, ', ', ua.district, ', ', ua.city) AS full_address "
                    + "FROM Orders o "
                    + "JOIN Users u ON o.customer_id = u.user_id "
                    + "LEFT JOIN UserAddress ua ON o.shipping_address_id = ua.address_id "
                    + "WHERE o.order_id = ?";

            ps = conn.prepareStatement(sqlOrder);
            ps.setLong(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                order = new order();
                order.setOrderId(rs.getLong("order_id"));
                order.setOrderCode(rs.getString("order_code"));
                order.setCustomerId(rs.getLong("customer_id"));

                // Check null cho ID
                long shipId = rs.getLong("shipping_address_id");
                if (!rs.wasNull()) {
                    order.setShippingAddressId(shipId);
                }

                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethodCode(rs.getString("payment_method_code"));
                order.setPaymentStatus(rs.getString("payment_status"));

                order.setSubtotalAmount(rs.getDouble("subtotal_amount"));
                order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));

                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                order.setCustomerName(rs.getString("full_name"));
                order.setCustomerPhone(rs.getString("phone"));
                String address = rs.getString("full_address");
                order.setShippingAddressLine(address != null ? address : "Nhận tại cửa hàng / Không có địa chỉ");
            }

            if (order == null) {
                return null;
            }

            // BƯỚC 2: Lấy danh sách sản phẩm
            String sqlItems = "SELECT oi.*, p.product_name, pv.sku, pv.image_url "
                    + "FROM OrderItems oi "
                    + "JOIN ProductVariant pv ON oi.variant_id = pv.variant_id "
                    + "JOIN Product p ON pv.product_id = p.product_id "
                    + "WHERE oi.order_id = ?";

            rs.close();
            ps.close();

            ps = conn.prepareStatement(sqlItems);
            ps.setLong(1, orderId);
            rs = ps.executeQuery();

            List<orderItem> items = new ArrayList<>();
            while (rs.next()) {
                orderItem item = new orderItem();
                item.setOrderItemId(rs.getLong("order_item_id"));
                item.setOrderId(rs.getLong("order_id"));
                item.setVariantId(rs.getLong("variant_id"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setQuantity(rs.getInt("quantity"));

                double lineTotal = item.getUnitPrice().doubleValue() * item.getQuantity();
                item.setLineTotal(lineTotal);

                item.setProductName(rs.getString("product_name"));
                item.setImageUrl(rs.getString("image_url"));

                items.add(item);
            }

            order.setItems(items);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return order;
    }

    public boolean updateOrderStatus(long orderId, String newStatus) {
        // FIX: SYSUTCDATETIME() -> CURRENT_TIMESTAMP
        String sql = "UPDATE Orders SET order_status = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setLong(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
