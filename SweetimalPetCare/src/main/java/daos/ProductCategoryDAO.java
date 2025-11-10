package daos;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ProductCategory;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductCategoryDAO extends DBContext {

    // helper to generate "?, ?, ?" placeholders for IN clauses
    private void appendPlaceholders(StringBuilder sb, int count) {
        for (int i = 0; i < count; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
    }

    // 🟢 Lấy tất cả danh mục
    public List<ProductCategory> getAllCategories() {
        List<ProductCategory> list = new ArrayList<>();
        try {
            String qr = "SELECT product_category_id, category_name, parent_id, description FROM ProductCategory";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductCategory c = new ProductCategory();
                c.setProductCategoryId(rs.getInt("product_category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setParentId(rs.getInt("parent_id"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
            rs.close();
            ps.close();
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(ProductCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy danh mục kèm số lượng sản phẩm
    public List<ProductCategory> getCategoriesWithCount() {
        List<ProductCategory> list = new ArrayList<>();
        try {
            String qr = "SELECT c.product_category_id, c.category_name, c.parent_id, c.description, "
                    + "COUNT(DISTINCT p.product_id) AS product_count "
                    + "FROM ProductCategory c "
                    + "LEFT JOIN Product p ON c.product_category_id = p.product_category_id "
                    + "GROUP BY c.product_category_id, c.category_name, c.parent_id, c.description "
                    + "ORDER BY c.category_name";

            PreparedStatement ps = getConnection().prepareStatement(qr);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductCategory c = new ProductCategory();
                c.setProductCategoryId(rs.getInt("product_category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setParentId(rs.getInt("parent_id"));
                c.setDescription(rs.getString("description"));
                c.setProductCount(rs.getInt("product_count"));
                list.add(c);
            }
            rs.close();
            ps.close();
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(ProductCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy danh mục theo ID
    public ProductCategory getCategoryById(int id) {
        try {
            String qr = "SELECT product_category_id, category_name, parent_id, description "
                    + "FROM ProductCategory WHERE product_category_id = ?";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductCategory c = new ProductCategory();
                c.setProductCategoryId(rs.getInt("product_category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setParentId(rs.getInt("parent_id"));
                c.setDescription(rs.getString("description"));
                rs.close();
                ps.close();
                return c;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy danh mục và đếm số sản phẩm còn lại sau khi lọc (chuẩn xác)
    // Filters: brandIds, minPrice, maxPrice, stock (stock can be "inStock" or "outOfStock")
    public List<ProductCategory> getCategoriesWithCountFiltered(List<Integer> brandIds, Double minPrice, Double maxPrice, String stock) {
        List<ProductCategory> list = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT c.product_category_id, c.category_name, c.parent_id, c.description, ");
            sql.append("COUNT(DISTINCT filtered.product_id) AS product_count ");
            sql.append("FROM ProductCategory c ");
            sql.append("LEFT JOIN ( ");
            sql.append("    SELECT DISTINCT p.product_id, p.product_category_id ");
            sql.append("    FROM Product p ");
            sql.append("    JOIN ProductVariant v ON p.product_id = v.product_id ");
            sql.append("    WHERE p.is_active = 1 AND v.is_active = 1 ");

            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append("AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
            }

            if (minPrice != null) {
                sql.append("AND v.price >= ? ");
            }
            if (maxPrice != null) {
                sql.append("AND v.price <= ? ");
            }

            if (stock != null && !stock.isEmpty()) {
                if (stock.equals("inStock")) {
                    sql.append("AND v.stock_quantity > 0 ");
                } else if (stock.equals("outOfStock")) {
                    sql.append("AND v.stock_quantity = 0 ");
                }
            }

            sql.append(") AS filtered ON c.product_category_id = filtered.product_category_id ");
            sql.append("GROUP BY c.product_category_id, c.category_name, c.parent_id, c.description ");
            sql.append("ORDER BY c.category_name");

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int index = 1;
            if (brandIds != null && !brandIds.isEmpty()) {
                for (Integer id : brandIds) {
                    ps.setInt(index++, id);
                }
            }
            if (minPrice != null) {
                ps.setDouble(index++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(index++, maxPrice);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductCategory c = new ProductCategory();
                c.setProductCategoryId(rs.getInt("product_category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setParentId(rs.getInt("parent_id"));
                c.setDescription(rs.getString("description"));
                c.setProductCount(rs.getInt("product_count"));
                list.add(c);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

}