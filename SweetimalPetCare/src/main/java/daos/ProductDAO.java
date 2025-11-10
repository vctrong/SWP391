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

    // ----------------- Methods -----------------

    // 🟢 Lấy tất cả sản phẩm
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
                    + "WHERE p.is_active = 1 AND v.is_active = 1";

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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy sản phẩm theo ID
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

    // 🟢 Lấy sản phẩm theo Brand (đã JOIN đầy đủ)
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
                    + "WHERE p.is_active = 1 AND v.is_active = 1 AND p.brand_id = ?";

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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy sản phẩm theo Category (đã JOIN đầy đủ)
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
                    + "WHERE p.is_active = 1 AND v.is_active = 1 AND p.product_category_id = ?";

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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Replace the existing getProductsWithFilter method with this version
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
            // If database supports OUTER APPLY (SQL Server) original code used it; keep it but without cost/sold cols.
            sql.append("OUTER APPLY ( ");
            sql.append("    SELECT TOP 1 v.variant_id, v.sku, v.attribute_json, v.price, ");
            sql.append("           v.stock_quantity, v.image_url, v.is_active, v.created_at ");
            sql.append("    FROM ProductVariant v ");
            sql.append("    WHERE v.product_id = p.product_id AND v.is_active = 1 ");

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
            sql.append("WHERE p.is_active = 1 ");

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
                        // sold_quantity removed => fallback to newest products
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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Count total products matching given product-level filters.
     * Note: This counts products (Product table) matching is_active + category + brand.
     * It intentionally does not try to enforce variant-level price/stock filters here
     * to match the behavior where products with no matching mainVariant are still listed.
     */
    public int countProductsWithFilter(List<Integer> categoryIds, List<Integer> brandIds,
                                       Double minPrice, Double maxPrice, String stock, String sort) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM Product p WHERE p.is_active = 1 ");

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
            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer id : categoryIds) ps.setInt(idx++, id);
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                for (Integer id : brandIds) ps.setInt(idx++, id);
            }

            ResultSet rs = ps.executeQuery();
            int result = 0;
            if (rs.next()) result = rs.getInt(1);
            rs.close();
            ps.close();
            return result;
        } catch (SQLException ex) {
            ex.printStackTrace();
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Paged version of getProductsWithFilter. Uses SQL Server OFFSET/FETCH for pagination.
     * limit = pageSize, offset = (currentPage-1)*pageSize
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
            sql.append("WHERE p.is_active = 1 ");

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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy danh sách variant của 1 product theo product_id
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

    // --- Count variants in/out stock (in user's preferred style) ---

    public int countVariantsInStock(List<Integer> categoryIds, List<Integer> brandIds, Double minPrice, Double maxPrice) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM ProductVariant v JOIN Product p ON v.product_id = p.product_id ");
            sql.append("WHERE v.is_active = 1 AND v.stock_quantity > 0 ");

            if (minPrice != null) sql.append(" AND v.price >= ? ");
            if (maxPrice != null) sql.append(" AND v.price <= ? ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND p.product_category_id IN (");
                for (int i = 0; i < categoryIds.size(); i++) {
                    if (i > 0) sql.append(",");
                    sql.append("?");
                }
                sql.append(") ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append(" AND p.brand_id IN (");
                for (int i = 0; i < brandIds.size(); i++) {
                    if (i > 0) sql.append(",");
                    sql.append("?");
                }
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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int countVariantsOutOfStock(List<Integer> categoryIds, List<Integer> brandIds, Double minPrice, Double maxPrice) {
        try {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) FROM ProductVariant v JOIN Product p ON v.product_id = p.product_id ");
            sql.append("WHERE v.is_active = 1 AND v.stock_quantity = 0 ");

            if (minPrice != null) sql.append(" AND v.price >= ? ");
            if (maxPrice != null) sql.append(" AND v.price <= ? ");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                sql.append(" AND p.product_category_id IN (");
                for (int i = 0; i < categoryIds.size(); i++) {
                    if (i > 0) sql.append(",");
                    sql.append("?");
                }
                sql.append(") ");
            }
            if (brandIds != null && !brandIds.isEmpty()) {
                sql.append(" AND p.brand_id IN (");
                for (int i = 0; i < brandIds.size(); i++) {
                    if (i > 0) sql.append(",");
                    sql.append("?");
                }
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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Lấy các sản phẩm liên quan theo product_category_id (loại sản phẩm).
     * Loại trừ product có id excludeProductId.
     * Limit số kết quả bằng parameter limit.
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