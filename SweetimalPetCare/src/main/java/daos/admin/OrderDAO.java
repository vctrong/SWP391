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
        // Sửa lại tên cột trong hàm CONCAT cho khớp với bảng UserAddress của bạn
        String sql = "SELECT o.order_id, o.order_code, o.customer_id, o.shipping_address_id, "
                + "o.order_status, o.payment_method_code, o.payment_status, "
                + "o.subtotal_amount, o.shipping_fee, o.total_amount, "
                + "o.notes, o.created_at, o.updated_at, "
                + "u.full_name, " // Giả định cột tên là full_name
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

                // SQL Server trả về DATETIME2 -> Timestamp -> java.util.Date
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
        // SQL Server dùng TOP thay vì LIMIT
        String sql = "SELECT pv.variant_id, p.product_name, pv.sku, pv.attribute_json, "
                + "pv.price, pv.stock_quantity, pv.image_url "
                + "FROM ProductVariant pv "
                + "JOIN Product p ON pv.product_id = p.product_id "
                + "WHERE p.is_active = 1 AND pv.is_active = 1 "
                + "AND (p.product_name LIKE ? OR pv.sku LIKE ? OR p.product_code LIKE ?)";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setNString(1, searchPattern); // product_name (NVARCHAR)
            ps.setNString(2, searchPattern); // sku
            ps.setNString(3, searchPattern); // product_code

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

        // 2. Câu SQL Insert bảng OrderItems
        // Lưu ý: Không insert cột line_total vì trong DB nó là cột tự tính (AS unit * qty)
        String sqlItem = "INSERT INTO OrderItems (order_id, variant_id, unit_price, quantity) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rs = null;

        try {
            conn = this.openNewConnection();
            conn.setAutoCommit(false);
            psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getOrderCode());
            psOrder.setLong(2, order.getCustomerId());
            psOrder.setLong(3, order.getShippingAddressId());
            psOrder.setString(4, order.getOrderStatus());      // Thường là 'PENDING'
            psOrder.setString(5, order.getPaymentMethodCode());
            psOrder.setString(6, order.getPaymentStatus());    // Thường là 'PENDING'
            psOrder.setDouble(7, order.getSubtotalAmount());
            psOrder.setBigDecimal(8, order.getShippingFee());
            psOrder.setBigDecimal(9, order.getTotalAmount());
            psOrder.setString(10, order.getNotes());
            int affectedRows = psOrder.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }
            rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                generatedOrderId = rs.getLong(1); // Đây là order_id
                order.setOrderId(generatedOrderId); // Set ngược lại vào object để dùng nếu cần
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }

            psItem = conn.prepareStatement(sqlItem);
            List<orderItem> items = order.getItems();
            if (items != null && !items.isEmpty()) {
                for (orderItem item : items) {
                    psItem.setLong(1, generatedOrderId); // Dùng ID vừa lấy ở trên
                    psItem.setLong(2, item.getVariantId());
                    psItem.setBigDecimal(3, item.getUnitPrice());
                    psItem.setInt(4, item.getQuantity());

                    psItem.addBatch(); // Thêm vào hàng đợi
                }
                // Chạy một lần hết danh sách
                psItem.executeBatch();
            }
            conn.commit();
        } catch (Exception e) {
            // Nếu có lỗi, ROLLBACK (Hoàn tác) lại toàn bộ, không lưu dòng nào cả
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1; // Trả về -1 báo hiệu lỗi
        } finally {
            // Đóng kết nối
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
                    conn.setAutoCommit(true); // Bật lại auto commit cho các lệnh khác
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return generatedOrderId;
    }

    public BigDecimal getPriceVariantById(long variantId) {
        String sql = "select price from ProductVariant\n"
                + "where variant_id = ?";
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

            // BƯỚC 1: Lấy thông tin chung (Header) của đơn hàng
            // Join bảng Users để lấy tên khách, UserAddress để lấy địa chỉ full
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
                // Map các cột DB vào Model Order
                order.setOrderId(rs.getLong("order_id"));
                order.setOrderCode(rs.getString("order_code"));
                order.setCustomerId(rs.getLong("customer_id"));
                order.setShippingAddressId(rs.getLong("shipping_address_id"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setPaymentMethodCode(rs.getString("payment_method_code"));
                order.setPaymentStatus(rs.getString("payment_status"));

                // Lưu ý: DB là Decimal, Model là double
                order.setSubtotalAmount(rs.getDouble("subtotal_amount"));
                order.setShippingFee(rs.getBigDecimal("shipping_fee"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));

                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Các trường hiển thị (Joined columns)
                order.setCustomerName(rs.getString("full_name"));
                order.setCustomerPhone(rs.getString("phone"));
                String address = rs.getString("full_address");
                order.setShippingAddressLine(address != null ? address : "Nhận tại cửa hàng / Không có địa chỉ");
            }

            // Nếu không tìm thấy order thì return null luôn
            if (order == null) {
                return null;
            }

            // BƯỚC 2: Lấy danh sách sản phẩm (Items) của đơn hàng đó
            // Join ProductVariant và Product để lấy tên và ảnh hiển thị lên Modal
            String sqlItems = "SELECT oi.*, p.product_name, pv.sku, pv.image_url "
                    + "FROM OrderItems oi "
                    + "JOIN ProductVariant pv ON oi.variant_id = pv.variant_id "
                    + "JOIN Product p ON pv.product_id = p.product_id "
                    + "WHERE oi.order_id = ?";

            // Đóng ResultSet/Statement cũ để dùng cái mới
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
                item.setUnitPrice(rs.getBigDecimal("unit_price")); // Model bạn dùng BigDecimal
                item.setQuantity(rs.getInt("quantity"));

                // Tính lineTotal: Trong DB không có cột này, tự tính hoặc lấy từ AS nếu có
                // Ở đây mình tự tính cho chắc: unit * qty
                double lineTotal = item.getUnitPrice().doubleValue() * item.getQuantity();
                item.setLineTotal(lineTotal);

                // Map các trường hiển thị bổ sung
                item.setProductName(rs.getString("product_name"));
                item.setImageUrl(rs.getString("image_url"));

                items.add(item);
            }

            // Gán danh sách items vào Order
            order.setItems(items);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Đóng kết nối
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
        String sql = "UPDATE Orders SET order_status = ?, updated_at = SYSUTCDATETIME() WHERE order_id = ?";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setLong(2, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu update thành công

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
