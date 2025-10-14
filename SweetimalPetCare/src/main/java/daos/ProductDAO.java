/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

    // 🟢 Lấy tất cả sản phẩm
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                + "v.variant_id, v.sku, v.attribute_json, v.price, v.cost, "
                + "v.stock_quantity, v.sold_quantity, v.image_url, "
                + "v.is_active AS variant_active, v.created_at AS variant_created "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                + "JOIN ProductVariant v ON p.product_id = v.product_id "
                + "WHERE p.is_active = 1 AND v.is_active = 1";

        try ( PreparedStatement st = getConnection().prepareStatement(sql);  ResultSet rs = st.executeQuery()) {
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
                        rs.getObject("cost") != null ? rs.getDouble("cost") : null,
                        rs.getInt("stock_quantity"),
                        rs.getInt("sold_quantity"),
                        rs.getString("image_url"),
                        rs.getBoolean("variant_active"),
                        rs.getTimestamp("variant_created")
                );

                p.setMainVariant(v);
                list.add(p);
            }
        } catch (SQLException ex) {
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
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy sản phẩm theo Brand (đã JOIN đầy đủ)
    public List<Product> getProductsByBrand(int brandId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                + "v.variant_id, v.sku, v.attribute_json, v.price, v.cost, "
                + "v.stock_quantity, v.sold_quantity, v.image_url, "
                + "v.is_active AS variant_active, v.created_at AS variant_created "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                + "JOIN ProductVariant v ON p.product_id = v.product_id "
                + "WHERE p.is_active = 1 AND v.is_active = 1 AND p.brand_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
                        rs.getObject("cost") != null ? rs.getDouble("cost") : null,
                        rs.getInt("stock_quantity"),
                        rs.getInt("sold_quantity"),
                        rs.getString("image_url"),
                        rs.getBoolean("variant_active"),
                        rs.getTimestamp("variant_created")
                );
                p.setMainVariant(v);
                list.add(p);
            }
            rs.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lấy sản phẩm theo Category (đã JOIN đầy đủ)
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, "
                + "p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, "
                + "v.variant_id, v.sku, v.attribute_json, v.price, v.cost, "
                + "v.stock_quantity, v.sold_quantity, v.image_url, "
                + "v.is_active AS variant_active, v.created_at AS variant_created "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                + "JOIN ProductVariant v ON p.product_id = v.product_id "
                + "WHERE p.is_active = 1 AND v.is_active = 1 AND p.product_category_id = ?";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
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
                        rs.getObject("cost") != null ? rs.getDouble("cost") : null,
                        rs.getInt("stock_quantity"),
                        rs.getInt("sold_quantity"),
                        rs.getString("image_url"),
                        rs.getBoolean("variant_active"),
                        rs.getTimestamp("variant_created")
                );
                p.setMainVariant(v);
                list.add(p);
            }
            rs.close();
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 🟢 Lọc sản phẩm theo danh sách category, brand, giá và tình trạng hàng
public List<Product> getProductsWithFilter(List<Integer> categoryIds, List<Integer> brandIds,
                                           Double minPrice, Double maxPrice, String stock) {
    List<Product> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder();

    sql.append("SELECT p.product_id, p.product_code, p.product_name, p.product_category_id, ");
    sql.append("p.brand_id, b.brand_name, p.description, p.is_active, p.created_at, ");
    sql.append("v.variant_id, v.sku, v.attribute_json, v.price, v.cost, ");
    sql.append("v.stock_quantity, v.sold_quantity, v.image_url, ");
    sql.append("v.is_active AS variant_active, v.created_at AS variant_created ");
    sql.append("FROM Product p ");
    sql.append("LEFT JOIN Brand b ON p.brand_id = b.brand_id ");
    sql.append("OUTER APPLY ( ");
    sql.append("    SELECT TOP 1 v.variant_id, v.sku, v.attribute_json, v.price, v.cost, ");
    sql.append("           v.stock_quantity, v.sold_quantity, v.image_url, ");
    sql.append("           v.is_active, v.created_at ");
    sql.append("    FROM ProductVariant v ");
    sql.append("    WHERE v.product_id = p.product_id AND v.is_active = 1 ");

    // 🧩 Giữ chỗ cho điều kiện giá và stock (sẽ bind sau)
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

    sql.append("    ORDER BY v.price ASC "); // chọn variant rẻ nhất làm đại diện
    sql.append(") v ");
    sql.append("WHERE p.is_active = 1 ");

    // 🧩 Lọc theo Category
    if (categoryIds != null && !categoryIds.isEmpty()) {
        sql.append("AND p.product_category_id IN (");
        for (int i = 0; i < categoryIds.size(); i++) {
            sql.append("?");
            if (i < categoryIds.size() - 1) sql.append(",");
        }
        sql.append(") ");
    }

    // 🧩 Lọc theo Brand
    if (brandIds != null && !brandIds.isEmpty()) {
        sql.append("AND p.brand_id IN (");
        for (int i = 0; i < brandIds.size(); i++) {
            sql.append("?");
            if (i < brandIds.size() - 1) sql.append(",");
        }
        sql.append(") ");
    }

    try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
        int index = 1;

        // ⚙️ Set tham số cho subquery (minPrice, maxPrice)
        if (minPrice != null) ps.setDouble(index++, minPrice);
        if (maxPrice != null) ps.setDouble(index++, maxPrice);

        // ⚙️ Set tham số cho category
        if (categoryIds != null && !categoryIds.isEmpty()) {
            for (int id : categoryIds) {
                ps.setInt(index++, id);
            }
        }

        // ⚙️ Set tham số cho brand
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

            // 🧩 Variant đại diện (mainVariant)
            ProductVariant v = new ProductVariant(
                    rs.getLong("variant_id"),
                    rs.getLong("product_id"),
                    rs.getString("sku"),
                    rs.getString("attribute_json"),
                    rs.getDouble("price"),
                    rs.getObject("cost") != null ? rs.getDouble("cost") : null,
                    rs.getInt("stock_quantity"),
                    rs.getInt("sold_quantity"),
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
        Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
    }

    return list;
}

// 🟢 Lấy danh sách variant của 1 product theo product_id
public List<ProductVariant> getVariantsByProductId(int productId) {
    List<ProductVariant> list = new ArrayList<>();
    try {
        String sql = "SELECT variant_id, product_id, sku, attribute_json, price, cost, "
                   + "stock_quantity, sold_quantity, image_url, is_active, created_at "
                   + "FROM ProductVariant WHERE product_id = ? AND is_active = 1";
        PreparedStatement ps = getConnection().prepareStatement(sql);
        ps.setInt(1, productId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            ProductVariant v = new ProductVariant();
            v.setVariantId(rs.getLong("variant_id"));
            v.setProductId(rs.getLong("product_id"));
            v.setSku(rs.getString("sku"));
            v.setAttributeJson(rs.getString("attribute_json"));
            v.setPrice(rs.getDouble("price"));
            v.setCost(rs.getObject("cost") != null ? rs.getDouble("cost") : null);
            v.setStockQuantity(rs.getInt("stock_quantity"));
            v.setSoldQuantity(rs.getInt("sold_quantity"));
            v.setImageUrl(rs.getString("image_url"));
            v.setActive(rs.getBoolean("is_active"));
            v.setCreatedAt(rs.getTimestamp("created_at"));
            // nếu DB có cột discount, bạn có thể thêm: v.setDiscount(rs.getDouble("discount"));
            list.add(v);
        }
        rs.close();
        ps.close();
    } catch (SQLException ex) {
        Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
    }
    return list;
}

}
