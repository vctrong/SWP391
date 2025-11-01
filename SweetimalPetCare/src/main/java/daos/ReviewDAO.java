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
 * DAO cho bảng Reviews theo schema:
 *  review_id, service_id, product_id, staff_id, customer_id, rating, comment, created_at
 *
 * @author Pham Nguyen Xuan Mai (adjusted)
 */
public class ReviewDAO extends db.DBContext {

    // Lấy danh sách review của 1 product
    public List<Review> getReviewsByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String qr = "SELECT r.review_id, r.service_id, r.product_id, r.staff_id, r.customer_id, "
                + "r.rating, r.comment, r.created_at, u.full_name "
                + "FROM Reviews r "
                + "LEFT JOIN Users u ON r.customer_id = u.user_id "
                + "WHERE r.product_id = ? "
                + "ORDER BY r.created_at DESC";

        try (PreparedStatement ps = getConnection().prepareStatement(qr)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review rTemp = new Review();
                    rTemp.setReviewId(rs.getInt("review_id"));
                    int svc = rs.getInt("service_id");
                    if (!rs.wasNull()) rTemp.setServiceId(svc);
                    int prod = rs.getInt("product_id");
                    if (!rs.wasNull()) rTemp.setProductId(prod);
                    int staff = rs.getInt("staff_id");
                    if (!rs.wasNull()) rTemp.setStaffId(staff);
                    rTemp.setCustomerId(rs.getInt("customer_id"));
                    rTemp.setRating(rs.getInt("rating"));
                    rTemp.setComment(rs.getString("comment"));
                    rTemp.setCreatedAt(rs.getTimestamp("created_at"));
                    // nếu model.Review có userName, set từ Users.full_name
                    try {
                        rTemp.setUserName(rs.getString("full_name"));
                    } catch (Throwable t) {
                        // nếu model không có field userName thì bỏ qua
                    }
                    list.add(rTemp);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Thêm review mới cho product (service_id và staff_id để NULL)
    public boolean addReview(int productId, int customerId, int rating, String comment) {
        String qr = "INSERT INTO Reviews (service_id, product_id, staff_id, customer_id, rating, comment) "
                + "VALUES (NULL, ?, NULL, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(qr)) {
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
        String qr = "SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating FROM Reviews WHERE product_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(qr)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0.0;
    }
}