/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.product.Brand;
import model.product.Product;
import model.product.ProductCategory;
import model.product.ProductImg;
import model.product.ProductVariant;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ProductDAO extends db.DBContext {

    public ArrayList<ProductCategory> getAllCate() {
        try {
            String qr = "select product_category_id, category_name, parent_id from ProductCategory";
            ArrayList<ProductCategory> temp = new ArrayList<>();
            // Sử dụng executeSelectQuery nếu class cha hỗ trợ, hoặc dùng chuẩn JDBC dưới đây cho an toàn
            try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(qr);  ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    temp.add(new ProductCategory(rs.getLong(1), rs.getString(2), rs.getInt(3)));
                }
            }
            return temp;
        } catch (SQLException ex) {
            // FIX LOGGER
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getAllCate: " + ex.getMessage(), ex);
        }
        return null;
    }

    public ArrayList<ProductVariant> getAllVariantsByProductId(long productId) {
        ArrayList<ProductVariant> variantList = new ArrayList<>();
        String sql = "SELECT * FROM ProductVariant WHERE product_id = ? ORDER BY variant_id ASC;";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductVariant v = new ProductVariant();
                    v.setVariantId(rs.getLong("variant_id"));
                    v.setProductId(rs.getLong("product_id"));
                    v.setSku(rs.getString("sku"));
                    v.setAttributeJson(rs.getString("attribute_json"));
                    v.setPrice(rs.getBigDecimal("price"));
                    v.setStockQuantity(rs.getInt("stock_quantity"));
                    v.setImageUrl(rs.getString("image_url"));
                    v.setIsActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getDate("created_at"));
                    variantList.add(v);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getAllVariantsByProductId: " + e.getMessage(), e);
        }
        return variantList;
    }

    public ArrayList<ProductImg> getAllImagesByProductId(long productId) {
        ArrayList<ProductImg> imageList = new ArrayList<>();
        // Postgres OK
        String sql = "SELECT * FROM ProductImg WHERE product_id = ? ORDER BY is_main DESC, sort_order ASC, product_img_id ASC;";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductImg img = new ProductImg();
                    img.setImageId(rs.getLong("product_img_id"));
                    img.setProductId(rs.getLong("product_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setCaption(rs.getString("caption"));
                    img.setDisplayOrder(rs.getInt("sort_order"));
                    img.setIsMain(rs.getBoolean("is_main"));
                    img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    imageList.add(img);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getAllImagesByProductId: " + e.getMessage(), e);
        }
        return imageList;
    }

    public Product getProductForDetail(long productId) {
        Product product = null;
        String sql = "SELECT "
                + "    p.product_id, p.product_code, p.product_name, p.product_category_id, "
                + "    p.brand_id, p.description, p.is_active, p.created_at,"
                + "    b.brand_name,"
                + "    pc.category_name "
                + "FROM Product p "
                + "LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                + "LEFT JOIN ProductCategory pc ON p.product_category_id = pc.product_category_id "
                + "WHERE p.product_id = ?;";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getLong("product_id"));
                    product.setProductCode(rs.getString("product_code"));
                    product.setProductName(rs.getString("product_name"));
                    product.setProductCategoryId(rs.getInt("product_category_id"));

                    // Xử lý Integer null an toàn
                    int brandId = rs.getInt("brand_id");
                    if (!rs.wasNull()) {
                        product.setBrandId(brandId);
                    }

                    product.setDescription(rs.getString("description"));
                    product.setIsActive(rs.getBoolean("is_active"));
                    product.setCreatedAt(rs.getTimestamp("created_at"));
                    product.setBrandName(rs.getString("brand_name"));
                    product.setProductCategoryName(rs.getString("category_name"));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getProductForDetail: " + e.getMessage(), e);
        }
        return product;
    }

    // Normalize image_url values from DB: remove leading '/images/' or leading '/' so
    // controllers/JSP can compose the final URL as contextPath + '/images/' + imageFileName
    private String normalizeImageUrl(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim();
        if (s.startsWith("/images/")) {
            s = s.substring("/images/".length());
        }
        if (s.startsWith("/")) {
            s = s.substring(1);
        }
        return s;
    }

    public int getTotalProductCount(String searchTerm, int categoryId) {
        String sql = "SELECT COUNT(p.product_id) AS TotalCount "
                + "FROM Product p "
                + "WHERE "
                + "    (p.product_name LIKE ? OR p.product_code LIKE ?) "
                + "    AND (p.product_category_id = ? OR ? = 0);";

        String searchPattern = "%" + searchTerm + "%";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, categoryId);
            ps.setInt(4, categoryId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalCount");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getTotalProductCount: " + e.getMessage(), e);
        }
        return 0;
    }

    public ArrayList<Product> getProductsList(String searchTerm, int categoryId, int pageNumber, int pageSize) {
        ArrayList<Product> productList = new ArrayList<>();

        // === CÂU QUERY QUAN TRỌNG ĐÃ SỬA CHO POSTGRESQL ===
        // 1. Dùng LEFT JOIN LATERAL thay vì OUTER APPLY
        // 2. Dùng LIMIT 1 thay vì TOP 1
        // 3. Dùng LIMIT OFFSET thay vì OFFSET FETCH
        // 4. Sửa pv.is_active = 1 thành pv.is_active IS TRUE (Postgres strict boolean)
        String sql = "SELECT AllProducts.* FROM ("
                + "    SELECT "
                + "        p.product_id, p.product_code, p.product_name, p.product_category_id, "
                + "        p.brand_id, p.description, p.is_active, p.created_at, "
                + "        b.brand_name, "
                + "        pc.category_name, "
                + "        mv.variant_id AS main_variant_id, "
                + "        mv.sku AS main_sku, "
                + "        mv.price AS main_price, "
                + "        mv.stock_quantity AS main_stock, "
                + "        mv.image_url AS main_image_url, "
                + "        mv.created_at AS main_variant_created_at, "
                + "        mv.is_active AS main_variant_is_active "
                + "    FROM Product p "
                + "    LEFT JOIN Brand b ON p.brand_id = b.brand_id "
                + "    LEFT JOIN ProductCategory pc ON p.product_category_id = pc.product_category_id "
                + "    LEFT JOIN LATERAL ( " // <-- THAY OUTER APPLY
                + "        SELECT "
                + "            pv.variant_id, pv.sku, pv.price, pv.stock_quantity, pv.image_url, pv.created_at, pv.is_active "
                + "        FROM ProductVariant pv "
                + "        WHERE pv.product_id = p.product_id AND pv.is_active IS TRUE " // <-- Fix Boolean comparison
                + "        ORDER BY pv.variant_id ASC "
                + "        LIMIT 1 " // <-- THAY TOP 1
                + "    ) AS mv ON true " // <-- LATERAL bắt buộc có ON condition
                + ") AS AllProducts "
                + "WHERE "
                + "    (AllProducts.product_name LIKE ? OR AllProducts.product_code LIKE ?) "
                + "    AND (AllProducts.product_category_id = ? OR ? = 0) "
                + "ORDER BY AllProducts.created_at DESC "
                + "LIMIT ? OFFSET ?;"; // <-- CÚ PHÁP PHÂN TRANG POSTGRES

        String searchPattern = "%" + searchTerm + "%";
        int offset = (pageNumber - 1) * pageSize;

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, categoryId);
            ps.setInt(4, categoryId);

            // LƯU Ý: Postgres LIMIT trước, OFFSET sau
            ps.setInt(5, pageSize); // LIMIT
            ps.setInt(6, offset);   // OFFSET

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getLong("product_id"));
                    p.setProductCode(rs.getString("product_code"));
                    p.setProductName(rs.getString("product_name"));
                    p.setProductCategoryId(rs.getInt("product_category_id"));

                    int brandId = rs.getInt("brand_id");
                    if (!rs.wasNull()) {
                        p.setBrandId(brandId);
                    }

                    p.setDescription(rs.getString("description"));
                    p.setIsActive(rs.getBoolean("is_active"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setBrandName(rs.getString("brand_name"));
                    p.setProductCategoryName(rs.getString("category_name"));

                    // Main Variant
                    ProductVariant mv = new ProductVariant();
                    mv.setVariantId(rs.getLong("main_variant_id"));
                    // Nếu main_variant_id = 0 tức là ko có variant nào active
                    if (mv.getVariantId() > 0) {
                        mv.setProductId(p.getProductId());
                        mv.setSku(rs.getString("main_sku"));
                        mv.setPrice(rs.getBigDecimal("main_price"));
                        mv.setStockQuantity(rs.getInt("main_stock"));
                        mv.setImageUrl(rs.getString("main_image_url"));
                        mv.setIsActive(rs.getBoolean("main_variant_is_active"));
                        mv.setCreatedAt(rs.getDate("main_variant_created_at"));
                        p.setMainVariant(mv);
                    }
                    productList.add(p);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getProductsList: " + e.getMessage(), e);
        }
        return productList;
    }

    public ArrayList<Brand> getAllBrands() {
        ArrayList<Brand> brandList = new ArrayList<>();
        String sql = "SELECT * FROM Brand ORDER BY brand_name ASC;";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandId(rs.getInt("brand_id"));
                brand.setBrandName(rs.getString("brand_name"));
                brandList.add(brand);
            }
        } catch (SQLException e) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Lỗi getAllBrands: " + e.getMessage(), e);
        }
        return brandList;
    }

    // Các hàm Update/Insert Transaction dùng chuẩn JDBC nên thường tương thích tốt
    // Chỉ cần lưu ý setNull cho đúng
    public boolean updateProductAndVariants(Product product, List<ProductVariant> variants) throws SQLException {
        Connection conn = null;
        List<Long> updatedVariantIds = new ArrayList<>();

        try {
            conn = this.getConnection();
            conn.setAutoCommit(false);

            String sqlUpdateProduct = "UPDATE Product SET product_name=?, product_code=?, product_category_id=?, brand_id=?, description=?, is_active=? WHERE product_id=?";

            try ( PreparedStatement psProduct = conn.prepareStatement(sqlUpdateProduct)) {
                psProduct.setString(1, product.getProductName());
                psProduct.setString(2, product.getProductCode());
                psProduct.setInt(3, product.getProductCategoryId());
                if (product.getBrandId() != null && product.getBrandId() > 0) {
                    psProduct.setInt(4, product.getBrandId());
                } else {
                    psProduct.setNull(4, java.sql.Types.INTEGER);
                }
                psProduct.setString(5, product.getDescription());
                psProduct.setBoolean(6, product.isIsActive());
                psProduct.setLong(7, product.getProductId());
                psProduct.executeUpdate();
            }

            // ... (Logic tìm variant cũ giữ nguyên)
            List<Long> existingVariantIds = new ArrayList<>();
            String sqlFindVariants = "SELECT variant_id FROM ProductVariant WHERE product_id = ?";
            try ( PreparedStatement psFind = conn.prepareStatement(sqlFindVariants)) {
                psFind.setLong(1, product.getProductId());
                try ( ResultSet rs = psFind.executeQuery()) {
                    while (rs.next()) {
                        existingVariantIds.add(rs.getLong("variant_id"));
                    }
                }
            }

            String sqlUpdateVariant = "UPDATE ProductVariant SET sku=?, attribute_json=?, price=?, stock_quantity=? WHERE variant_id=?";
            String sqlInsertVariant = "INSERT INTO ProductVariant (product_id, sku, attribute_json, price, stock_quantity) VALUES (?, ?, ?, ?, ?)";

            for (ProductVariant variant : variants) {
                if (variant.getVariantId() == 0) {
                    try ( PreparedStatement psInsert = conn.prepareStatement(sqlInsertVariant)) {
                        psInsert.setLong(1, product.getProductId());
                        psInsert.setString(2, variant.getSku());
                        psInsert.setString(3, variant.getAttributeJson());
                        psInsert.setBigDecimal(4, variant.getPrice());
                        psInsert.setInt(5, variant.getStockQuantity());
                        psInsert.executeUpdate();
                    }
                } else {
                    try ( PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateVariant)) {
                        psUpdate.setString(1, variant.getSku());
                        psUpdate.setString(2, variant.getAttributeJson());
                        psUpdate.setBigDecimal(3, variant.getPrice());
                        psUpdate.setInt(4, variant.getStockQuantity());
                        psUpdate.setLong(5, variant.getVariantId());
                        psUpdate.executeUpdate();
                    }
                    updatedVariantIds.add(variant.getVariantId());
                }
            }

            List<Long> idsToDelete = new ArrayList<>(existingVariantIds);
            idsToDelete.removeAll(updatedVariantIds);

            if (!idsToDelete.isEmpty()) {
                String deleteIdsStr = idsToDelete.stream().map(String::valueOf).collect(Collectors.joining(","));
                String sqlDeleteVariants = "DELETE FROM ProductVariant WHERE variant_id IN (" + deleteIdsStr + ")";
                try ( PreparedStatement psDelete = conn.prepareStatement(sqlDeleteVariants)) {
                    psDelete.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new SQLException("Lỗi updateProductAndVariants: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public long addNewProductTransaction(Product product, List<ProductVariant> variants, List<ProductImg> images) throws SQLException {
        Connection conn = null;
        long newProductId = 0;
        String sqlInsertProduct = "INSERT INTO Product (product_code, product_name, product_category_id, brand_id, description, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlInsertVariant = "INSERT INTO ProductVariant (product_id, sku, attribute_json, price, stock_quantity, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlInsertImage = "INSERT INTO ProductImg (product_id, image_url, caption, sort_order, is_main) VALUES (?, ?, ?, ?, ?)";
        try {
            conn = this.getConnection();
            conn.setAutoCommit(false);

            try ( PreparedStatement psProduct = conn.prepareStatement(sqlInsertProduct, Statement.RETURN_GENERATED_KEYS)) {
                psProduct.setString(1, product.getProductCode());
                psProduct.setString(2, product.getProductName());
                psProduct.setInt(3, product.getProductCategoryId());
                if (product.getBrandId() != null && product.getBrandId() > 0) {
                    psProduct.setInt(4, product.getBrandId());
                } else {
                    psProduct.setNull(4, java.sql.Types.INTEGER);
                }
                psProduct.setString(5, product.getDescription());
                psProduct.setBoolean(6, true);

                int rowsAffected = psProduct.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Tạo sản phẩm thất bại.");
                }

                try ( ResultSet generatedKeys = psProduct.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newProductId = generatedKeys.getLong(1);
                    } else {
                        throw new SQLException("Tạo sản phẩm thất bại, không lấy được ID.");
                    }
                }
            }
            if (variants != null && !variants.isEmpty()) {
                try ( PreparedStatement psVariant = conn.prepareStatement(sqlInsertVariant, Statement.RETURN_GENERATED_KEYS)) {
                    for (ProductVariant variant : variants) {
                        psVariant.setLong(1, newProductId);
                        psVariant.setString(2, variant.getSku());
                        psVariant.setString(3, variant.getAttributeJson());
                        psVariant.setBigDecimal(4, variant.getPrice());
                        psVariant.setInt(5, variant.getStockQuantity());
                        psVariant.setBoolean(6, true);
                        psVariant.addBatch();
                    }
                    psVariant.executeBatch();
                }
            }
            if (images != null && !images.isEmpty()) {
                try ( PreparedStatement psImage = conn.prepareStatement(sqlInsertImage)) {
                    int sortOrder = 1;
                    boolean isFirstImage = true;
                    for (ProductImg img : images) {
                        psImage.setLong(1, newProductId);
                        psImage.setString(2, img.getImageUrl());
                        psImage.setString(3, img.getCaption());
                        psImage.setInt(4, sortOrder++);
                        psImage.setBoolean(5, isFirstImage);
                        isFirstImage = false;
                        psImage.addBatch();
                    }
                    psImage.executeBatch();
                }
            }

            conn.commit();
            return newProductId;
        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw new SQLException("Lỗi addNewProductTransaction: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

}
