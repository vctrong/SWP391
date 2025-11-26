/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ProductImg;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductImgDAO extends db.DBContext {

    /**
     * Find product images for a given productId. Uses ProductImage (joined with
     * ProductVariant) to get images belonging to any variant of the product.
     *
     * @param productId product id
     * @return list of ProductImg (may be empty)
     * @throws SQLException on DB error
     */
    public List<ProductImg> findByProductId(int productId) throws SQLException {
        List<ProductImg> list = new ArrayList<>();

        // Query chuẩn SQL, chạy tốt trên cả SQL Server và PostgreSQL
        String sql = "SELECT pi.image_id, pv.product_id, pi.image_url, pi.alt_text, pi.display_order, pi.created_at "
                + "FROM ProductImage pi "
                + "JOIN ProductVariant pv ON pi.variant_id = pv.variant_id "
                + "WHERE pv.product_id = ? "
                + "ORDER BY pi.display_order ASC, pi.image_id ASC";

        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductImg pi = new ProductImg();

                    long tmpLong = rs.getLong("image_id");
                    if (rs.wasNull()) {
                        pi.setImageId(null);
                    } else {
                        pi.setImageId(tmpLong);
                    }

                    tmpLong = rs.getLong("product_id");
                    if (rs.wasNull()) {
                        pi.setProductId(null);
                    } else {
                        pi.setProductId(tmpLong);
                    }

                    pi.setImageUrl(rs.getString("image_url"));

                    // alt_text maps to caption in model
                    pi.setCaption(rs.getString("alt_text"));

                    int tmpInt = rs.getInt("display_order");
                    if (rs.wasNull()) {
                        pi.setDisplayOrder(null);
                    } else {
                        pi.setDisplayOrder(tmpInt);
                    }

                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        pi.setUploadedAt(new Date(ts.getTime()));
                    } else {
                        pi.setUploadedAt(null);
                    }

                    list.add(pi);
                }
            }
        } catch (SQLException ex) {
            // Log with context and rethrow to let caller decide handling
            Logger.getLogger(ProductImgDAO.class.getName()).log(Level.SEVERE,
                    "Error querying ProductImage for productId=" + productId, ex);
            throw ex;
        }

        return list;
    }
}
