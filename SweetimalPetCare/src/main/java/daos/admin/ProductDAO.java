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
            String qr = "select product_category_id, category_name, parent_id\n"
                    + "from ProductCategory";
            ArrayList<ProductCategory> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new ProductCategory(rs.getLong(1), rs.getString(2), rs.getInt(3)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<ProductVariant> getAllVariantsByProductId(long productId) {
        ArrayList<ProductVariant> variantList = new ArrayList<>();

        // Query đơn giản lấy tất cả variants
        String sql = "SELECT * FROM ProductVariant WHERE product_id = ? ORDER BY variant_id ASC;";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductVariant v = new ProductVariant();

                    // Ánh xạ (map) đầy đủ các cột
                    v.setVariantId(rs.getLong("variant_id"));
                    v.setProductId(rs.getLong("product_id"));
                    v.setSku(rs.getString("sku"));
                    v.setAttributeJson(rs.getString("attribute_json"));
                    v.setPrice(rs.getBigDecimal("price"));
                    v.setStockQuantity(rs.getInt("stock_quantity"));
                    v.setImageUrl(rs.getString("image_url"));
                    v.setIsActive(rs.getBoolean("is_active"));
                    v.setCreatedAt(rs.getDate("created_at")); // Giả định dùng Timestamp

                    variantList.add(v);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách variants: " + e.getMessage());
            e.printStackTrace();
        }
        return variantList;
    }

    public ArrayList<ProductImg> getAllImagesByProductId(long productId) {
        ArrayList<ProductImg> imageList = new ArrayList<>();
        // Lấy ảnh từ bảng ProductImage (schema mới) - liên kết qua variant_id -> ProductVariant để biết product_id
        String sql = "SELECT pi.image_id, pv.product_id, pi.image_url, pi.alt_text, pi.display_order, pi.created_at "
            + "FROM ProductImage pi JOIN ProductVariant pv ON pi.variant_id = pv.variant_id "
            + "WHERE pv.product_id = ? "
            + "ORDER BY pi.display_order ASC, pi.image_id ASC;";

        try (Connection conn = this.openNewConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductImg img = new ProductImg();

                    img.setImageId(rs.getLong("image_id"));
                    img.setProductId(rs.getLong("product_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setCaption(rs.getString("alt_text"));
                    img.setDisplayOrder(rs.getInt("display_order"));
                    // In ProductImage schema, display_order == 0 is the main/first image
                    img.setIsMain(img.getDisplayOrder() != null && img.getDisplayOrder() == 0);
                    img.setUploadedAt(rs.getTimestamp("created_at"));

                    imageList.add(img);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách ảnh: " + e.getMessage());
            e.printStackTrace();
        }
        return imageList;
    }

    public Product getProductForDetail(long productId) {
        Product product = null;

        // Câu query này JOIN để lấy tên Brand và Category
        String sql = "SELECT \n"
                + "    p.product_id, p.product_code, p.product_name, p.product_category_id, \n"
                + "    p.brand_id, p.description, p.is_active, p.created_at,\n"
                + "    b.brand_name,\n"
                + "    pc.category_name\n"
                + "FROM \n"
                + "    Product p\n"
                + "LEFT JOIN \n"
                + "    Brand b ON p.brand_id = b.brand_id\n"
                + "LEFT JOIN \n"
                + "    ProductCategory pc ON p.product_category_id = pc.product_category_id\n"
                + "WHERE \n"
                + "    p.product_id = ?;";

        try ( Connection conn = this.openNewConnection(); // Lấy connection
                  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, productId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = new Product();

                    // Gán dữ liệu vào đối tượng Product (DTO)
                    product.setProductId(rs.getLong("product_id"));
                    product.setProductCode(rs.getString("product_code"));
                    product.setProductName(rs.getString("product_name"));
                    product.setProductCategoryId(rs.getInt("product_category_id"));
                    product.setBrandId(rs.getObject("brand_id", Integer.class));
                    product.setDescription(rs.getString("description"));
                    product.setIsActive(rs.getBoolean("is_active"));
                    product.setCreatedAt(rs.getTimestamp("created_at"));

                    // Đây là 2 trường quan trọng từ JOIN
                    product.setBrandName(rs.getString("brand_name"));
                    product.setProductCategoryName(rs.getString("category_name"));

                    // (Không cần set mainVariant ở đây, vì chúng ta sẽ lấy 1 list riêng)
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy chi tiết sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    // Normalize image_url values from DB: remove leading '/images/' or leading '/' so
    // controllers/JSP can compose the final URL as contextPath + '/images/' + imageFileName
    private String normalizeImageUrl(String raw) {
        if (raw == null) return null;
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

        // Câu query đếm, giống hệt điều kiện WHERE của hàm getProductsList
        String sql = "SELECT COUNT(p.product_id) AS TotalCount\n"
                + "FROM Product p\n"
                + "WHERE\n"
                + "    (p.product_name LIKE ? OR p.product_code LIKE ?)\n"
                + "    AND (p.product_category_id = ? OR ? = 0);";

        // Xử lý tham số
        String searchPattern = "%" + searchTerm + "%";

        try ( Connection conn = this.openNewConnection(); // <-- Lấy connection từ DBContext
                  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set các tham số
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
            System.err.println("Lỗi khi đếm sản phẩm: " + e.getMessage());
        }
        return 0;
    }

    public ArrayList<Product> getProductsList(String searchTerm, int categoryId, int pageNumber, int pageSize) {

        ArrayList<Product> productList = new ArrayList<>();

        // Câu query chính với JOIN, APPLY, WHERE và Phân Trang
        String sql = "SELECT \n"
                + "    AllProducts.*\n"
                + "FROM (\n"
                + "    SELECT\n"
                + "        p.product_id,\n"
                + "        p.product_code,\n"
                + "        p.product_name,\n"
                + "        p.product_category_id,\n"
                + "        p.brand_id,\n"
                + "        p.description, \n"
                + // <-- Thêm description
                "        p.is_active,\n"
                + "        p.created_at,\n"
                + "        b.brand_name,\n"
                + "        pc.category_name,\n"
                + // <-- Thêm category_name
                "        mv.variant_id AS main_variant_id,\n"
                + "        mv.sku AS main_sku,\n"
                + "        mv.price AS main_price,\n"
                + "        mv.stock_quantity AS main_stock,\n"
                + "        mv.image_url AS main_image_url,\n"
                + "        mv.created_at AS main_variant_created_at, \n"
                + // <-- Thêm trường cho mainVariant
                "        mv.is_active AS main_variant_is_active \n"
                + // <-- Thêm trường cho mainVariant
                "    FROM \n"
                + "        Product p\n"
                + "    LEFT JOIN \n"
                + "        Brand b ON p.brand_id = b.brand_id\n"
                + "    LEFT JOIN \n"
                + "        ProductCategory pc ON p.product_category_id = pc.product_category_id\n"
                + "    OUTER APPLY (\n"
                + "        SELECT TOP 1 \n"
                + "            pv.variant_id, pv.sku, pv.price, pv.stock_quantity, pv.image_url, pv.created_at, pv.is_active\n"
                + "        FROM \n"
                + "            ProductVariant pv\n"
                + "        WHERE \n"
                + "            pv.product_id = p.product_id AND pv.is_active = 1\n"
                + "        ORDER BY \n"
                + "            pv.variant_id ASC \n"
                + "    ) AS mv\n"
                + ") AS AllProducts\n"
                + "WHERE\n"
                + "    (AllProducts.product_name LIKE ? OR AllProducts.product_code LIKE ?)\n"
                + "    AND (AllProducts.product_category_id = ? OR ? = 0)\n"
                + "ORDER BY \n"
                + "    AllProducts.created_at DESC\n"
                + "OFFSET ? ROWS\n"
                + "FETCH NEXT ? ROWS ONLY;";

        // Xử lý tham số
        String searchPattern = "%" + searchTerm + "%";
        int offset = (pageNumber - 1) * pageSize;

        try ( Connection conn = this.openNewConnection(); // <-- Lấy connection
                  PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set các tham số
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, categoryId);
            ps.setInt(4, categoryId);
            ps.setInt(5, offset);
            ps.setInt(6, pageSize);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // 1. Tạo đối tượng Product (DTO)
                    Product p = new Product();
                    p.setProductId(rs.getLong("product_id"));
                    p.setProductCode(rs.getString("product_code"));
                    p.setProductName(rs.getString("product_name"));
                    p.setProductCategoryId(rs.getInt("product_category_id"));
                    p.setBrandId(rs.getObject("brand_id", Integer.class)); // Xử lý brand_id có thể NULL
                    p.setDescription(rs.getString("description")); // Lấy description
                    p.setIsActive(rs.getBoolean("is_active"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    p.setBrandName(rs.getString("brand_name"));
                    p.setProductCategoryName(rs.getString("category_name")); // (Nếu bạn đã thêm trường này vào model Product)

                    // 2. Tạo đối tượng ProductVariant (mainVariant)
                    ProductVariant mv = new ProductVariant();
                    mv.setVariantId(rs.getLong("main_variant_id"));
                    mv.setProductId(p.getProductId()); // ID sản phẩm
                    mv.setSku(rs.getString("main_sku"));
                    mv.setPrice(rs.getBigDecimal("main_price"));
                    mv.setStockQuantity(rs.getInt("main_stock"));
                    mv.setImageUrl(normalizeImageUrl(rs.getString("main_image_url")));
                    mv.setIsActive(rs.getBoolean("main_variant_is_active"));
                    mv.setCreatedAt(rs.getDate("main_variant_created_at"));

                    // 3. Gắn mainVariant vào Product
                    p.setMainVariant(mv);

                    // 4. Thêm Product vào danh sách
                    productList.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách sản phẩm: " + e.getMessage());
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
            System.err.println("Lỗi khi lấy danh sách brands: " + e.getMessage());
            e.printStackTrace();
        }
        return brandList;
    }

    public boolean updateProductAndVariants(Product product, List<ProductVariant> variants) throws SQLException {

        Connection conn = null;
        // Biến cờ để theo dõi các ID variant gửi lên
        List<Long> updatedVariantIds = new ArrayList<>();

        try {
            conn = this.getConnection();
            // BẮT ĐẦU GIAO DỊCH
            conn.setAutoCommit(false);

            // ===== BƯỚC 1: CẬP NHẬT THÔNG TIN SẢN PHẨM CHÍNH =====
            String sqlUpdateProduct = "UPDATE Product SET "
                    + " product_name = ?, "
                    + " product_code = ?, "
                    + " product_category_id = ?, "
                    + " brand_id = ?, "
                    + " description = ?, "
                    + " is_active = ? "
                    + "WHERE product_id = ?;";

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

            // ===== BƯỚC 2: LẤY DANH SÁCH VARIANT HIỆN TẠI TRONG DB =====
            // (Để so sánh và tìm ra các variant cần XÓA)
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

            // ===== BƯỚC 3: LẶP QUA DANH SÁCH VARIANT GỬI LÊN (ĐỂ INSERT/UPDATE) =====
            String sqlUpdateVariant = "UPDATE ProductVariant SET sku = ?, attribute_json = ?, price = ?, stock_quantity = ? WHERE variant_id = ?;";
            String sqlInsertVariant = "INSERT INTO ProductVariant (product_id, sku, attribute_json, price, stock_quantity) VALUES (?, ?, ?, ?, ?);";

            for (ProductVariant variant : variants) {
                if (variant.getVariantId() == 0) {
                    // LÀ VARIANT MỚI (ID = 0) -> INSERT
                    try ( PreparedStatement psInsert = conn.prepareStatement(sqlInsertVariant)) {
                        psInsert.setLong(1, product.getProductId());
                        psInsert.setString(2, variant.getSku());
                        psInsert.setString(3, variant.getAttributeJson());
                        psInsert.setBigDecimal(4, variant.getPrice());
                        psInsert.setInt(5, variant.getStockQuantity());
                        psInsert.executeUpdate();
                    }
                } else {
                    // LÀ VARIANT CŨ (ID > 0) -> UPDATE
                    try ( PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateVariant)) {
                        psUpdate.setString(1, variant.getSku());
                        psUpdate.setString(2, variant.getAttributeJson());
                        psUpdate.setBigDecimal(3, variant.getPrice());
                        psUpdate.setInt(4, variant.getStockQuantity());
                        psUpdate.setLong(5, variant.getVariantId());
                        psUpdate.executeUpdate();
                    }
                    // Thêm ID này vào danh sách đã cập nhật
                    updatedVariantIds.add(variant.getVariantId());
                }
            }

            // ===== BƯỚC 4: TÌM VÀ XÓA CÁC VARIANT ĐÃ BỊ XÓA (LOGIC XỊN) =====
            // Lấy danh sách ID cũ (existingVariantIds)
            // Trừ đi danh sách ID vừa được cập nhật (updatedVariantIds)
            // Kết quả là danh sách ID cần xóa
            List<Long> idsToDelete = new ArrayList<>(existingVariantIds);
            idsToDelete.removeAll(updatedVariantIds); // Xóa những ID còn tồn tại

            if (!idsToDelete.isEmpty()) {
                String deleteIdsStr = idsToDelete.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining(","));
                String sqlDeleteVariants = "DELETE FROM ProductVariant WHERE variant_id IN (" + deleteIdsStr + ");";

                try ( PreparedStatement psDelete = conn.prepareStatement(sqlDeleteVariants)) {
                    psDelete.executeUpdate();
                }
            }

            // ===== BƯỚC 5: KẾT THÚC GIAO DỊCH (COMMIT) =====
            conn.commit();
            return true; // Thành công

        } catch (SQLException e) {
            // Nếu có lỗi, HỦY BỎ (ROLLBACK) mọi thay đổi
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // Ném lỗi ra ngoài để Servlet biết và báo lỗi
            throw new SQLException("Lỗi khi cập nhật sản phẩm: " + e.getMessage(), e);

        } finally {
            // Luôn luôn trả lại AutoCommit về true và đóng connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                conn.close();
            }
        }
    }

    public long addNewProductTransaction(Product product, List<ProductVariant> variants, List<ProductImg> images) throws SQLException {

        Connection conn = null;
        long newProductId = 0; // ID sản phẩm mới sẽ được trả về

        // SQL 1: Thêm Product và lấy ID tự tăng
        // (Chúng ta cần chỉ định rõ các cột cho RETURN_GENERATED_KEYS)
        String sqlInsertProduct = "INSERT INTO Product (product_code, product_name, product_category_id, brand_id, description, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?);";

        // SQL 2: Thêm các Variants (Dùng Batch)
        String sqlInsertVariant = "INSERT INTO ProductVariant (product_id, sku, attribute_json, price, stock_quantity, is_active) "
                + "VALUES (?, ?, ?, ?, ?, ?);";

        // SQL 3: Thêm các Ảnh (Dùng Batch) - insert into ProductImage (new schema)

        try {
            conn = this.openNewConnection();
            // BẮT ĐẦU GIAO DỊCH
            conn.setAutoCommit(false);

            // ===== BƯỚC 1: INSERT PRODUCT (Và lấy ID) =====
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
                psProduct.setBoolean(6, true); // Mặc định là Active khi tạo mới

                int rowsAffected = psProduct.executeUpdate();

                if (rowsAffected == 0) {
                    throw new SQLException("Tạo sản phẩm thất bại, không có dòng nào được thêm.");
                }

                // Lấy newProductId
                try ( ResultSet generatedKeys = psProduct.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newProductId = generatedKeys.getLong(1);
                    } else {
                        throw new SQLException("Tạo sản phẩm thất bại, không lấy được ID.");
                    }
                }
                System.out.println("[DAO DEBUG] Đã thêm Product, ID mới: " + newProductId);
            }

            // ===== BƯỚC 2: INSERT VARIANTS (Lấy generated keys) =====
            // (Chỉ thực hiện nếu có variant) - we need generated variant IDs to attach images to ProductImage.variant_id
            List<Long> insertedVariantIds = new ArrayList<>();
            if (variants != null && !variants.isEmpty()) {
                try (PreparedStatement psVariant = conn.prepareStatement(sqlInsertVariant, Statement.RETURN_GENERATED_KEYS)) {
                    for (ProductVariant variant : variants) {
                        psVariant.setLong(1, newProductId); // Dùng ID mới
                        psVariant.setString(2, variant.getSku());
                        psVariant.setString(3, variant.getAttributeJson());
                        psVariant.setBigDecimal(4, variant.getPrice());
                        psVariant.setInt(5, variant.getStockQuantity());
                        psVariant.setBoolean(6, true); // Mặc định Active

                        int rows = psVariant.executeUpdate();
                        if (rows > 0) {
                            try (ResultSet gk = psVariant.getGeneratedKeys()) {
                                if (gk.next()) {
                                    long vid = gk.getLong(1);
                                    insertedVariantIds.add(vid);
                                }
                            }
                        }
                    }
                }
                System.out.println("[DAO DEBUG] Đã thêm " + insertedVariantIds.size() + " variants.");
            }

            // ===== BƯỚC 3: INSERT IMAGES (Dùng Batch) =====
            // (Chỉ thực hiện nếu có ảnh)
            System.out.println("[DAO DEBUG] Chuẩn bị thêm " + (images != null ? images.size() : "0") + " ảnh.");
            if (images != null && !images.isEmpty()) {
                int sortOrder = 1;

                // Insert into ProductImage (new schema). We attach images to the first inserted variant if available; otherwise set variant_id = NULL
                String insertNew = "INSERT INTO ProductImage (variant_id, image_url, alt_text, display_order) VALUES (?, ?, ?, ?);";
                try (PreparedStatement psImageNew = conn.prepareStatement(insertNew)) {
                    Long attachVariantId = insertedVariantIds.isEmpty() ? null : insertedVariantIds.get(0);
                    for (ProductImg img : images) {
                        System.out.println("[DAO DEBUG] ProductImage insert: " + img.getImageUrl());
                        if (attachVariantId != null) {
                            psImageNew.setLong(1, attachVariantId);
                        } else {
                            psImageNew.setNull(1, java.sql.Types.BIGINT);
                        }
                        psImageNew.setString(2, img.getImageUrl());
                        psImageNew.setString(3, img.getCaption());
                        psImageNew.setInt(4, sortOrder++);
                        psImageNew.addBatch();
                    }
                    psImageNew.executeBatch();
                    System.out.println("[DAO DEBUG] ProductImage inserts OK.");
                }
            }

            // ===== BƯỚC 4: KẾT THÚC GIAO DỊCH (COMMIT) =====
            System.out.println("[DAO DEBUG] Đang Commit Transaction...");
            conn.commit();
            System.out.println("[DAO DEBUG] Commit THÀNH CÔNG.");
            return newProductId; // Trả về ID sản phẩm mới

        } catch (SQLException e) {
            // Nếu có lỗi, HỦY BỎ (ROLLBACK) mọi thay đổi
            System.out.println("[DAO DEBUG] !!! LỖI SQL !!! Đang Rollback...");
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // Ném lỗi ra ngoài để Servlet biết và báo lỗi
            throw new SQLException("Lỗi khi thêm sản phẩm mới (transaction rolled back): " + e.getMessage(), e);

        } finally {
            // Luôn luôn trả lại AutoCommit về true và đóng connection
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                conn.close();
            }
        }
    }

}
