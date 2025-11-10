package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Review;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ReviewDAO extends db.DBContext {
public List<Review> getReviewsByProduct(int productId) throws SQLException {
        String sql = "SELECT r.review_id, r.service_id, r.product_id, r.staff_id, r.customer_id, "
                + "r.rating, r.comment, r.created_at, u.full_name "
                + "FROM Reviews r LEFT JOIN Users u ON r.customer_id = u.user_id "
                + "WHERE r.product_id = ? ORDER BY r.created_at DESC";
        List<Review> list = new ArrayList<>();
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    // review_id
                    int tmp = rs.getInt("review_id");
                    r.setReviewId(rs.wasNull() ? null : tmp);
                    // service_id
                    tmp = rs.getInt("service_id");
                    r.setServiceId(rs.wasNull() ? null : tmp);
                    // product_id
                    tmp = rs.getInt("product_id");
                    r.setProductId(rs.wasNull() ? null : tmp);
                    // staff_id
                    tmp = rs.getInt("staff_id");
                    r.setStaffId(rs.wasNull() ? null : tmp);
                    // customer_id (NOT NULL)
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    Timestamp ts = rs.getTimestamp("created_at");
                    r.setCreatedAt(ts);
                    try { r.setUserName(rs.getString("full_name")); } catch (Throwable ignored) {}
                    list.add(r);
                }
            }
        }
        return list;
    }

    public boolean addReview(int productId, int customerId, int rating, String comment) throws SQLException {
        String sql = "INSERT INTO Reviews (service_id, product_id, staff_id, customer_id, rating, comment, created_at) "
                + "VALUES (NULL, ?, NULL, ?, ?, ?, ?)";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public double getAverageRatingByProduct(int productId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating FROM Reviews WHERE product_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        }
        return 0.0;
    }

    public boolean userHasReviewedProduct(int customerId, int productId) throws SQLException {
        String sql = "SELECT TOP 1 1 FROM Reviews WHERE customer_id = ? AND product_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Insert review. finalComment = title + "\n\n" + comment (trim / truncated).
     * Throws SQLException on DB error.
     */
    public void insertReview(int productId, int customerId, int rating, String title, String comment) throws SQLException {
        String sql = "INSERT INTO Reviews (product_id, customer_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)";
        String finalComment = (title == null ? "" : title.trim()) + "\n\n" + (comment == null ? "" : comment.trim());
        if (finalComment.length() > 1000) finalComment = finalComment.substring(0, 1000);
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            ps.setInt(3, rating);
            ps.setString(4, finalComment);
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
        }
    }

    public boolean deleteReviewByUserProduct(int productId, int customerId) throws SQLException {
        String sql = "DELETE FROM Reviews WHERE product_id = ? AND customer_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public boolean updateReviewByUserProduct(int productId, int customerId, int rating, String title, String comment) throws SQLException {
        String sql = "UPDATE Reviews SET rating = ?, comment = ?, created_at = ? WHERE product_id = ? AND customer_id = ?";
        String finalComment = (title == null ? "" : title.trim()) + "\n\n" + (comment == null ? "" : comment.trim());
        if (finalComment.length() > 1000) finalComment = finalComment.substring(0, 1000);
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, finalComment);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ps.setInt(4, productId);
            ps.setInt(5, customerId);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public Review getReviewByUserProduct(int productId, int customerId) throws SQLException {
        String sql = "SELECT review_id, rating, comment, created_at FROM Reviews WHERE product_id = ? AND customer_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Review r = new Review();
                    int tmp = rs.getInt("review_id");
                    r.setReviewId(rs.wasNull() ? null : tmp);
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    return r;
                }
            }
        }
        return null;
    }
}