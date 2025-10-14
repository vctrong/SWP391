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
import model.Review;

/**
 * @author Pham Nguyen Xuan Mai
 */
public class ReviewDAO extends db.DBContext {

    // Lấy danh sách review của 1 product (target_type_code = 'PRODUCT')
    public List<Review> getReviewsByProduct(int productId) {
        try {
            List<Review> list = new ArrayList<>();
            String qr = "SELECT r.review_id, r.target_type_code, r.target_id, r.customer_id, "
                    + "r.rating, r.comment, r.created_at, u.full_name "
                    + "FROM Reviews r "
                    + "JOIN Users u ON r.customer_id = u.user_id "
                    + "WHERE r.target_type_code = 'PRODUCT' AND r.target_id = ? "
                    + "ORDER BY r.created_at DESC";

            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review rTemp = new Review(
                        rs.getInt("review_id"),
                        rs.getString("target_type_code"),
                        rs.getInt("target_id"),
                        rs.getInt("customer_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at")
                );
                rTemp.setUserName(rs.getString("full_name"));
                list.add(rTemp);
            }

            return list;

        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Thêm review mới (có return boolean như ProductDAO)
    public boolean addReview(int productId, int customerId, int rating, String comment) {
        try {
            String qr = "INSERT INTO Reviews (target_type_code, target_id, customer_id, rating, comment) "
                    + "VALUES ('PRODUCT', ?, ?, ?, ?)";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Tính trung bình rating của sản phẩm
    public double getAverageRatingByProduct(int productId) {
        try {
            String qr = "SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating "
                    + "FROM Reviews WHERE target_type_code = 'PRODUCT' AND target_id = ?";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }

        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0.0;
    }
}
