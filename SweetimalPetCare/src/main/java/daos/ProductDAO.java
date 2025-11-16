package daos;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;
import model.ProductVariant;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductDAO extends DBContext {
 // ----------------- Helper -----------------
    private void appendPlaceholders(StringBuilder sb, int count) {
        for (int i = 0; i < count; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
    }

    // 🟢 Lấy sản phẩm theo ID (product detail)
    public Product getProductById(int id) {
        try {
            String sql = "SELECT product_id, product_code, product_name, product_category_id, brand_id, "
                    + "description, is_active, created_at "
                    + "FROM Product WHERE product_id = ?";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductCode(rs.getString("product_code"));
                p.setProductName(rs.getString("product_name"));
                p.setProductCategoryId(rs.getInt("product_category_id"));
                p.setBrandId(rs.getInt("brand_id"));
                p.setDescription(rs.getString("description"));
                p.setActive(rs.getBoolean("is_active"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                rs.close();
                ps.close();
                return p;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy danh sách variant của 1 product theo product_id (product detail)
    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        try {
            String sql = "SELECT variant_id, product_id, sku, attribute_json, price, "
                    + "stock_quantity, image_url, is_active, created_at "
                    + "FROM ProductVariant WHERE product_id = ? AND is_active = 1";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant v = new ProductVariant(
                        rs.getLong("variant_id"),
                        rs.getLong("product_id"),
                        rs.getString("sku"),
                        rs.getString("attribute_json"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("created_at")
                );
                list.add(v);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Lấy các sản phẩm liên quan theo product_category_id (loại sản phẩm).
     * Loại trừ product có id excludeProductId.
     * Limit số kết quả bằng parameter limit.
     *
     * Thường dùng trong product detail: "Sản phẩm liên quan".
     */
    public List<Product> getRelatedProductsByCategory(int categoryId, int excludeProductId, int limit) {
        List<Product> list = new ArrayList<>();
        try {
            // dùng TOP n của SQL Server — limit là int do server truyền, an toàn
            String sql = "SELECT TOP " + limit + " p.product_id, p.product_code, p.product_name, p.product_category_id, "
                    + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                    + "v.variant_id, v.sku, v.attribute_json, v.price, "
                    + "v.stock_quantity, v.image_url, "
                    + "v.is_active AS variant_active, v.created_at AS variant_created "
                    + "FROM Product p "
                    + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                    + "OUTER APPLY ( "
                    + "    SELECT TOP 1 v2.variant_id, v2.sku, v2.attribute_json, v2.price, "
                    + "           v2.stock_quantity, v2.image_url, v2.is_active, v2.created_at "
                    + "    FROM ProductVariant v2 "
                    + "    WHERE v2.product_id = p.product_id AND v2.is_active = 1 "
                    + "    ORDER BY v2.price ASC "
                    + ") v "
                    + "WHERE p.is_active = 1 AND p.product_category_id = ? AND p.product_id <> ? "
                    + "ORDER BY p.created_at DESC";

            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeProductId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getLong("product_id"),
                        rs.getString("product_code"),
                        rs.getString("product_name"),
                        rs.getInt("product_category_id"),
                        rs.getObject("brand_id") != null ? rs.getInt("brand_id") : null,
                        rs.getString("description"),
                        rs.getBoolean("is_active"),
                        rs.getTimestamp("created_at")
                );
                p.setBrandName(rs.getString("brand_name"));

                // main variant (đã chọn trong OUTER APPLY)
                if (rs.getObject("variant_id") != null) {
                    ProductVariant v = new ProductVariant(
                            rs.getLong("variant_id"),
                            rs.getLong("product_id"),
                            rs.getString("sku"),
                            rs.getString("attribute_json"),
                            rs.getDouble("price"),
                            rs.getInt("stock_quantity"),
                            rs.getString("image_url"),
                            rs.getBoolean("variant_active"),
                            rs.getTimestamp("variant_created")
                    );
                    p.setMainVariant(v);
                } else {
                    p.setMainVariant(null);
                }
                list.add(p);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ProductDAO.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        return list;
    }
}