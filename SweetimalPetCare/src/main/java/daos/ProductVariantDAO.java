package daos;

import db.DBContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ProductVariant;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductVariantDAO extends DBContext {

    // Lấy tất cả variant của 1 product
    public List<ProductVariant> getVariantsByProductId(long productId) {
        List<ProductVariant> list = new ArrayList<>();
        try {
            String sql = "SELECT variant_id, product_id, sku, attribute_json, price, cost, "
                    + "stock_quantity, sold_quantity, image_url, is_active, created_at "
                    + "FROM ProductVariant WHERE product_id = ?";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant v = mapRowToVariant(rs);
                list.add(v);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy 1 variant "chính" (ví dụ TOP 1 theo created_at hoặc theo is_active)
    public ProductVariant getMainVariantByProductId(long productId) {
        try {
            String sql = "SELECT TOP 1 variant_id, product_id, sku, attribute_json, price, cost, "
                    + "stock_quantity, sold_quantity, image_url, is_active, created_at "
                    + "FROM ProductVariant "
                    + "WHERE product_id = ? AND is_active = 1 "
                    + "ORDER BY created_at ASC";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductVariant v = mapRowToVariant(rs);
                rs.close();
                ps.close();
                return v;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductVariantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Map ResultSet -> ProductVariant (tách ra cho gọn)
    private ProductVariant mapRowToVariant(ResultSet rs) throws SQLException {
        ProductVariant v = new ProductVariant();
        v.setVariantId(rs.getLong("variant_id"));
        v.setProductId(rs.getLong("product_id"));
        v.setSku(rs.getString("sku"));
        v.setAttributeJson(rs.getString("attribute_json"));

        // Lấy price (DB kiểu decimal/number) an toàn:
        BigDecimal priceBd = rs.getBigDecimal("price");
        if (priceBd != null) {
            v.setPrice(priceBd.doubleValue()); // model dùng double
        } else {
            v.setPrice(0.0);
        }

        // Lấy cost (có thể NULL) -> model dùng Double
        BigDecimal costBd = rs.getBigDecimal("cost");
        if (costBd != null) {
            v.setCost(costBd.doubleValue());
        } else {
            v.setCost(null);
        }

        // Nếu cột có thể NULL và bạn muốn phân biệt NULL với 0, bạn có thể kiểm tra rs.wasNull() sau getInt.
        v.setStockQuantity(rs.getInt("stock_quantity"));
        v.setSoldQuantity(rs.getInt("sold_quantity"));
        v.setImageUrl(rs.getString("image_url"));
        v.setActive(rs.getBoolean("is_active"));
        v.setCreatedAt(rs.getTimestamp("created_at"));

        return v;
    }
}