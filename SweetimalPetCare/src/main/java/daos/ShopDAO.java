/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

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
public class ShopDAO extends db.DBContext{

    // ----------------- Helper -----------------
    private void appendPlaceholders(StringBuilder sb, int count) {
        for (int i = 0; i < count; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
    }

    // 🟢 Lấy tất cả sản phẩm (dùng khi cần, hiếm dùng cho listing lớn)
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                    + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                    + "v.variant_id, v.sku, v.attribute_json, v.price, "
                    + "v.stock_quantity, v.image_url, "
                    + "v.is_active AS variant_active, v.created_at AS variant_created "
                    + "FROM Product p "
                    + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                    + "JOIN ProductVariant v ON p.product_id = v.product_id "
                    + "WHERE p.is_active = 1 AND v.is_active = 1 AND v.price > 0";

            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
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
                list.add(p);
            }
            rs.close();
            st.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy sản phẩm theo Brand (dùng cho listing filtered by brand)
    public List<Product> getProductsByBrand(int brandId) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                    + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                    + "v.variant_id, v.sku, v.attribute_json, v.price, "
                    + "v.stock_quantity, v.image_url, "
                    + "v.is_active AS variant_active, v.created_at AS variant_created "
                    + "FROM Product p "
                    + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                    + "JOIN ProductVariant v ON p.product_id = v.product_id "
                    + "WHERE p.is_active = 1 AND v.is_active = 1 AND v.price > 0 AND p.brand_id = ?";

            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, brandId);
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
                list.add(p);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy sản phẩm theo Category (dùng cho listing filtered by category)
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                    + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                    + "v.variant_id, v.sku, v.attribute_json, v.price, "
                    + "v.stock_quantity, v.image_url, "
                    + "v.is_active AS variant_active, v.created_at AS variant_created "
                    + "FROM Product p "
                    + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                    + "JOIN ProductVariant v ON p.product_id = v.product_id "
                    + "WHERE p.is_active = 1 AND v.is_active = 1 AND v.price > 0 AND p.product_category_id = ?";

            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, categoryId);
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
                list.add(p);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Lấy products với filter (không phân trang) - giữ OUTER APPLY logic để chọn mainVariant phù hợp.
     * ALWAYS require v.price > 0 so products without a priced mainVariant are excluded.
     * Also require v.variant_id IS NOT NULL so products with no matching variant are excluded.
     */
    public List<Product> getProductsWithFilter(List<Integer> categoryIds, List<Integer> brandIds,
                                               Double minPrice, Double maxPrice, String stock, String sort) {
        List<Product> list = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder();

            sql.append("SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, ");
            sql.append("p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, ");
            sql.append("v.variant_id, v.sku, v.attribute_json, v.price, ");
            sql.append("v.stock_quantity, v.image_url, ");
            sql.append("v.is_active AS variant_active, v.created_at AS variant_created ");
            sql.append("FROM Product p ");
            sql.append("LEFT JOIN Brand b ON p.brand_id = b.brand_id ");
            sql.append("OUTER APPLY ( ");
            sql.append("    SELECT TOP 1 v.variant_id, v.sku, v.attribute_json, v.price, ");
            sql.append("           v.stock_quantity, v.image_url, v.is_active, v.created_at ");
            sql.append("    FROM ProductVariant v ");
            sql.append("    WHERE v.product_id = p.product_id AND v.is_active = 1 ");
            // require priced variant
            sql.append("    AND v.price > 0 ");

            // price & stock filter inside OUTER APPLY (so mainVariant respects price filter)
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

            sql.append("    ORDER BY v.price ASC ");
            sql.append(") v ");
            // require that OUTER APPLY returned a variant (exclude products with no priced/main variant)
            sql.append("WHERE p.is_active = 1 AND v.variant_id IS NOT NULL ");

            // category / brand filters on product level
            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append("AND p.product_category_id IN (");
                appendPlaceholders(sql, categoryIds.size());
                sql.append(") ");
            }

            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append("AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
            }

            // Build ORDER BY clause (SQL Server compatible)
            String orderClause = " ORDER BY p.product_name ASC"; // default

            if (sort != null) {
                switch (sort) {
                    case "name_asc":
                        orderClause = " ORDER BY p.product_name ASC";
                        break;
                    case "name_desc":
                        orderClause = " ORDER BY p.product_name DESC";
                        break;
                    case "price_asc":
                        orderClause = " ORDER BY CASE WHEN v.price IS NULL THEN 1 ELSE 0 END, v.price ASC";
                        break;
                    case "price_desc":
                        orderClause = " ORDER BY CASE WHEN v.price IS NULL THEN 1 ELSE 0 END, v.price DESC";
                        break;
                    case "date_asc":
                        orderClause = " ORDER BY p.created_at ASC";
                        break;
                    case "date_desc":
                        orderClause = " ORDER BY p.created_at DESC";
                        break;
                    case "best_selling":
                        orderClause = " ORDER BY p.created_at DESC";
                        break;
                    default:
                        // keep default
                        break;
                }
            }

            sql.append(orderClause);

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int index = 1;
            // bind price filters first (used in OUTER APPLY)
            if (minPrice != null) ps.setDouble(index++, minPrice);
            if (maxPrice != null) ps.setDouble(index++, maxPrice);

            // bind category ids
            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (int id : categoryIds) {
                    ps.setInt(index++, id);
                }
            }

            // bind brand ids
            if (brandIds != null && !brandIds.isEmpty()) {
                for (int id : brandIds) {
                    ps.setInt(index++, id);
                }
            }

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

                // tạo mainVariant nếu variant_id không null
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
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Paged version of getProductsWithFilter. Uses SQL Server OFFSET/FETCH for pagination.
     * limit = pageSize, offset = (currentPage-1)*pageSize
     * Ensures main variant has price > 0 and respects min/max price and stock.
     * Also excludes products where OUTER APPLY returned no variant (v.variant_id IS NOT NULL).
     */
    public List<Product> getProductsWithFilterPaged(List<Integer> categoryIds, List<Integer> brandIds,
                                                    Double minPrice, Double maxPrice, String stock, String sort,
                                                    int limit, int offset) {
        List<Product> list = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder();

            sql.append("SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, ");
            sql.append("p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, ");
            sql.append("v.variant_id, v.sku, v.attribute_json, v.price, ");
            sql.append("v.stock_quantity, v.image_url, ");
            sql.append("v.is_active AS variant_active, v.created_at AS variant_created ");
            sql.append("FROM Product p ");
            sql.append("LEFT JOIN Brand b ON p.brand_id = b.brand_id ");
            sql.append("OUTER APPLY ( ");
            sql.append("    SELECT TOP 1 v.variant_id, v.sku, v.attribute_json, v.price, ");
            sql.append("           v.stock_quantity, v.image_url, v.is_active, v.created_at ");
            sql.append("    FROM ProductVariant v ");
            sql.append("    WHERE v.product_id = p.product_id AND v.is_active = 1 ");
            // require priced variant
            sql.append("    AND v.price > 0 ");

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

            sql.append("    ORDER BY v.price ASC ");
            sql.append(") v ");
            // require that OUTER APPLY returned a variant (exclude products with no priced/main variant)
            sql.append("WHERE p.is_active = 1 AND v.variant_id IS NOT NULL ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append("AND p.product_category_id IN (");
                appendPlaceholders(sql, categoryIds.size());
                sql.append(") ");
            }

            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append("AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
            }

            // ORDER BY
            String orderClause = " ORDER BY p.product_name ASC"; // default
            if (sort != null) {
                switch (sort) {
                    case "name_asc":
                        orderClause = " ORDER BY p.product_name ASC";
                        break;
                    case "name_desc":
                        orderClause = " ORDER BY p.product_name DESC";
                        break;
                    case "price_asc":
                        orderClause = " ORDER BY CASE WHEN v.price IS NULL THEN 1 ELSE 0 END, v.price ASC";
                        break;
                    case "price_desc":
                        orderClause = " ORDER BY CASE WHEN v.price IS NULL THEN 1 ELSE 0 END, v.price DESC";
                        break;
                    case "date_asc":
                        orderClause = " ORDER BY p.created_at ASC";
                        break;
                    case "date_desc":
                        orderClause = " ORDER BY p.created_at DESC";
                        break;
                    case "best_selling":
                        orderClause = " ORDER BY p.created_at DESC";
                        break;
                    default:
                        break;
                }
            }
            sql.append(orderClause);

            // Append pagination (SQL Server OFFSET/FETCH)
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int index = 1;
            if (minPrice != null) ps.setDouble(index++, minPrice);
            if (maxPrice != null) ps.setDouble(index++, maxPrice);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (int id : categoryIds) {
                    ps.setInt(index++, id);
                }
            }

            if (brandIds != null && !brandIds.isEmpty()) {
                for (int id : brandIds) {
                    ps.setInt(index++, id);
                }
            }

            // bind pagination params (offset then limit)
            ps.setInt(index++, offset);
            ps.setInt(index++, limit);

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
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * COUNT products matching filters.
     * IMPORTANT: this count enforces that the product has at least one active variant
     * with price > 0 and that satisfies optional min/max price and stock filters.
     */
    public int countProductsWithFilter(List<Integer> categoryIds, List<Integer> brandIds,
                                       Double minPrice, Double maxPrice, String stock) {
        try {
            StringBuilder sql = new StringBuilder();
            List<Object> params = new ArrayList<>();

            sql.append("SELECT COUNT(*) FROM Product p WHERE p.is_active = 1 ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND p.product_category_id IN (");
                appendPlaceholders(sql, categoryIds.size());
                sql.append(") ");
                for (Integer id : categoryIds) params.add(id);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append(" AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
                for (Integer id : brandIds) params.add(id);
            }

            // enforce existence of at least one variant matching variant-level filters (and priced)
            sql.append(" AND EXISTS (SELECT 1 FROM ProductVariant v WHERE v.product_id = p.product_id AND v.is_active = 1 AND v.price > 0 ");
            if (minPrice != null) {
                sql.append(" AND v.price >= ? ");
                params.add(minPrice);
            }
            if (maxPrice != null) {
                sql.append(" AND v.price <= ? ");
                params.add(maxPrice);
            }
            if (stock != null && !stock.isEmpty()) {
                if (stock.equals("inStock")) {
                    sql.append(" AND v.stock_quantity > 0 ");
                } else if (stock.equals("outOfStock")) {
                    sql.append(" AND v.stock_quantity = 0 ");
                }
            }
            sql.append(")");

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int idx = 1;
            for (Object o : params) {
                if (o instanceof Integer) ps.setInt(idx++, (Integer) o);
                else if (o instanceof Double) ps.setDouble(idx++, (Double) o);
                else if (o instanceof Long) ps.setLong(idx++, (Long) o);
                else ps.setObject(idx++, o);
            }

            ResultSet rs = ps.executeQuery();
            int result = 0;
            if (rs.next()) result = rs.getInt(1);
            rs.close();
            ps.close();
            return result;
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // --- Count variants in/out stock (dùng hiển thị số lượng in/out trên sidebar) ---
    public int countVariantsInStock(List<Integer> categoryIds, List<Integer> brandIds, Double minPrice, Double maxPrice) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM ProductVariant v JOIN Product p ON v.product_id = p.product_id ");
            sql.append("WHERE v.is_active = 1 AND v.stock_quantity > 0 AND v.price > 0 ");

            if (minPrice != null) sql.append(" AND v.price >= ? ");
            if (maxPrice != null) sql.append(" AND v.price <= ? ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND p.product_category_id IN (");
                appendPlaceholders(sql, categoryIds.size());
                sql.append(") ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append(" AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
            }

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int idx = 1;
            if (minPrice != null) ps.setDouble(idx++, minPrice);
            if (maxPrice != null) ps.setDouble(idx++, maxPrice);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer id : categoryIds) ps.setInt(idx++, id);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                for (Integer id : brandIds) ps.setInt(idx++, id);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int result = rs.getInt(1);
                rs.close();
                ps.close();
                return result;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int countVariantsOutOfStock(List<Integer> categoryIds, List<Integer> brandIds, Double minPrice, Double maxPrice) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM ProductVariant v JOIN Product p ON v.product_id = p.product_id ");
            sql.append("WHERE v.is_active = 1 AND v.stock_quantity = 0 AND v.price > 0 ");

            if (minPrice != null) sql.append(" AND v.price >= ? ");
            if (maxPrice != null) sql.append(" AND v.price <= ? ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND p.product_category_id IN (");
                appendPlaceholders(sql, categoryIds.size());
                sql.append(") ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append(" AND p.brand_id IN (");
                appendPlaceholders(sql, brandIds.size());
                sql.append(") ");
            }

            PreparedStatement ps = getConnection().prepareStatement(sql.toString());

            int idx = 1;
            if (minPrice != null) ps.setDouble(idx++, minPrice);
            if (maxPrice != null) ps.setDouble(idx++, maxPrice);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer id : categoryIds) ps.setInt(idx++, id);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                for (Integer id : brandIds) ps.setInt(idx++, id);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int result = rs.getInt(1);
                rs.close();
                ps.close();
                return result;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ShopDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // NOTE: getRelatedProductsByCategory left in ProductDAO as it's used by product detail
}