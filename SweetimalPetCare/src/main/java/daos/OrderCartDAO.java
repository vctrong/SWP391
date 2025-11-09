package daos;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.OrderItem;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class OrderCartDAO extends DBContext {

    /**
     * Return price as double for a variant, or 0.0 if not found.
     */
    public double getVariantPriceAsDouble(long variantId) throws SQLException {
        String sql = "SELECT price FROM ProductVariant WHERE variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.math.BigDecimal bd = null;
                    try { bd = rs.getBigDecimal("price"); } catch (SQLException ignore) {}
                    if (bd != null) return bd.doubleValue();
                    return rs.getDouble("price");
                }
            }
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(OrderCartDAO.class.getName()).log(java.util.logging.Level.FINER, null, ex);
            throw ex;
        }
        return 0.0;
    }

    /**
     * Return stock quantity for variant (0 if not found).
     */
    public int getVariantStock(long variantId) throws SQLException {
        String sql = "SELECT stock_quantity FROM ProductVariant WHERE variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("stock_quantity");
                }
            }
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(OrderCartDAO.class.getName()).log(java.util.logging.Level.FINER, null, ex);
            throw ex;
        }
        return 0;
    }

    /**
     * Return variant metadata used for display/enrichment.
     * Keys: variantId, productId, sku, attributeJson, price, stockQuantity, imageUrl, productName
     * Returns empty map if not found.
     */
    public Map<String, Object> getVariantMetadata(long variantId) throws SQLException {
        String sql = "SELECT pv.variant_id, pv.product_id, pv.sku, pv.attribute_json, pv.price, pv.stock_quantity, pv.image_url, p.product_name " +
                     "FROM ProductVariant pv LEFT JOIN Product p ON pv.product_id = p.product_id " +
                     "WHERE pv.variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> meta = new HashMap<>();
                    meta.put("variantId", rs.getLong("variant_id"));
                    long pid = rs.getLong("product_id");
                    if (!rs.wasNull()) meta.put("productId", pid);
                    String sku = rs.getString("sku"); if (sku != null) meta.put("sku", sku);
                    String attrJson = rs.getString("attribute_json"); if (attrJson != null) meta.put("attributeJson", attrJson);
                    java.math.BigDecimal bd = null;
                    try { bd = rs.getBigDecimal("price"); } catch (SQLException ignore) {}
                    if (bd != null) meta.put("price", bd.doubleValue());
                    else {
                        try {
                            double p = rs.getDouble("price");
                            if (!rs.wasNull()) meta.put("price", p);
                        } catch (SQLException ignore) {}
                    }
                    int stock = rs.getInt("stock_quantity"); if (!rs.wasNull()) meta.put("stockQuantity", stock);
                    String img = rs.getString("image_url"); if (img != null) meta.put("imageUrl", img);
                    String pname = rs.getString("product_name"); if (pname != null) meta.put("productName", pname);
                    return meta;
                }
            }
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(OrderCartDAO.class.getName()).log(java.util.logging.Level.FINER, null, ex);
            throw ex;
        }
        return Collections.emptyMap();
    }

    /**
     * Legacy helper: list order items from a draft Orders row for the customer.
     * Kept read-only for backward compatibility with older code paths.
     *
     * If you have migrated to CartItems table, prefer using CartItemsDAO.getCartItemsByUser instead.
     */
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
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(OrderCartDAO.class.getName()).log(java.util.logging.Level.FINER, null, ex);
            throw ex;
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
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(OrderCartDAO.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
            throw ex;
        }
        return list;
    }
}