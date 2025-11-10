/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ProductImg;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductImgDAO extends db.DBContext{
    // Lấy tất cả ảnh theo productId (ưu tiên sort_order)
    public List<ProductImg> findByProductId(long productId) {
        List<ProductImg> list = new ArrayList<>();
        String sql = "SELECT product_img_id, product_id, image_url, caption, sort_order, is_main, uploaded_at "
                   + "FROM ProductImg WHERE product_id = ? ORDER BY sort_order ASC";

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {

            ps.setLong(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ProductImg img = new ProductImg();
                img.setProductImgId(rs.getLong("product_img_id"));
                img.setProductId(rs.getLong("product_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setCaption(rs.getString("caption"));
                img.setSortOrder(rs.getInt("sort_order"));
                img.setMain(rs.getBoolean("is_main"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(img);
            }

        } catch (Exception ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }
}
