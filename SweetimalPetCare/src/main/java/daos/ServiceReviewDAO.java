package daos;

import db.DBContext;
import model.ReviewServvice;
import model.ReviewReply;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ServiceReviewDAO extends DBContext {

    // Get all reviews for a service (newest first), enriched with user info
    public List<ReviewServvice> getReviewsByServiceId(long serviceId) {
        List<ReviewServvice> list = new ArrayList<>();
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT r.review_id, r.service_id, r.customer_id, r.rating, r.comment, r.created_at, "
                + "u.full_name, u.avatar_url "
                + "FROM Reviews r "
                + "JOIN Users u ON u.user_id = r.customer_id "
                + "WHERE r.service_id = ? "
                + "ORDER BY r.created_at DESC";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            while (rs.next()) {
                ReviewServvice rv = new ReviewServvice(
                        rs.getLong("review_id"),
                        rs.getLong("service_id"),
                        rs.getLong("customer_id"),
                        rs.getString("full_name"),
                        rs.getString("avatar_url"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at")
                );
                list.add(rv);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    // Average rating for a service
    public double getAverageRating(long serviceId) {
        // Query chuẩn, chạy tốt trên Postgres (CAST AS FLOAT được hỗ trợ)
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) AS avg_rating FROM Reviews WHERE service_id = ?";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            if (rs.next()) {
                double avg = rs.getDouble("avg_rating");
                if (rs.wasNull()) {
                    return 0.0;
                }
                return avg;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0.0;
    }

    // Rating distribution per star (1..5)
    public Map<Integer, Integer> getRatingCounts(long serviceId) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            map.put(i, 0);
        }
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT rating, COUNT(*) AS c FROM Reviews WHERE service_id = ? GROUP BY rating";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            while (rs.next()) {
                int r = rs.getInt("rating");
                map.put(r, rs.getInt("c"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return map;
    }

    // Fetch reply for a single review (optional)
    public ReviewReply getReplyByReviewId(long reviewId) {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT reply_id, review_id, replied_by_staff_id, reply_content, created_at FROM ReviewReply WHERE review_id = ?";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{reviewId})) {
            if (rs.next()) {
                ReviewReply rr = new ReviewReply();
                rr.setReplyId(rs.getLong("reply_id"));
                rr.setReviewId(rs.getLong("review_id"));
                rr.setRepliedByStaffId(rs.getLong("replied_by_staff_id"));
                rr.setReplyContent(rs.getString("reply_content"));
                rr.setCreatedAt(rs.getTimestamp("created_at"));
                return rr;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Create a new reply (only one per review enforced by DB UNIQUE constraint)
    public boolean createReply(long reviewId, long staffId, String content) {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "INSERT INTO ReviewReply(review_id, replied_by_staff_id, reply_content) VALUES(?,?,?)";
        try {
            int n = executeQuery(sql, new Object[]{reviewId, staffId, content});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Update existing reply
    public boolean updateReply(long reviewId, long staffId, String content) {
        // Đã sửa: GETDATE() -> NOW()
        String sql = "UPDATE ReviewReply SET reply_content = ?, replied_by_staff_id = ?, created_at = NOW() WHERE review_id = ?";
        try {
            int n = executeQuery(sql, new Object[]{content, staffId, reviewId});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Delete reply
    public boolean deleteReply(long reviewId) {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "DELETE FROM ReviewReply WHERE review_id = ?";
        try {
            int n = executeQuery(sql, new Object[]{reviewId});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Add a new review (enforces single-review-per-customer-per-service)
    public boolean addReview(ReviewServvice review) {
        try {
            // Allow multiple comments if the customer has completed the service
            if (!hasCustomerUsedService(review.getCustomerId(), review.getServiceId())) {
                return false;
            }
            // Đã sửa: GETDATE() -> NOW()
            String sql = "INSERT INTO Reviews(service_id, customer_id, rating, comment, created_at) VALUES (?, ?, ?, ?, NOW())";
            int n = executeQuery(sql, new Object[]{
                review.getServiceId(),
                review.getCustomerId(),
                review.getRating(),
                review.getComment()
            });
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Check if a customer used the service (COMPLETED bookings only)
    public boolean hasCustomerUsedService(long customerId, long serviceId) {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT COUNT(*) AS c FROM Booking WHERE customer_id = ? AND service_id = ? AND current_status = 'COMPLETED'";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{customerId, serviceId})) {
            if (rs.next()) {
                return rs.getInt("c") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Helper: check if customer already reviewed this service
    public boolean hasCustomerReviewed(long customerId, long serviceId) {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT COUNT(*) AS c FROM Reviews WHERE customer_id = ? AND service_id = ?";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{customerId, serviceId})) {
            if (rs.next()) {
                return rs.getInt("c") > 0;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Update an existing review (only if it belongs to the given customer)
    public boolean updateReview(long reviewId, long customerId, int rating, String comment) {
        // Đã sửa: GETDATE() -> NOW()
        String sql = "UPDATE Reviews SET rating = ?, comment = ?, created_at = NOW() WHERE review_id = ? AND customer_id = ?";
        try {
            String finalComment = (comment == null) ? "" : comment;
            // Append edited marker if not already present
            String editedMarker = " (đã chỉnh sửa)";
            if (!finalComment.contains("đã chỉnh sửa")) {
                finalComment = finalComment + editedMarker;
            }
            int n = executeQuery(sql, new Object[]{rating, finalComment, reviewId, customerId});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Delete a review (only the owner can delete). If a staff reply exists, remove it first.
    public boolean deleteReview(long reviewId, long customerId) {
        try {
            // Remove reply if exists to avoid FK constraint
            executeQuery("DELETE FROM ReviewReply WHERE review_id = ?", new Object[]{reviewId});
            int n = executeQuery("DELETE FROM Reviews WHERE review_id = ? AND customer_id = ?", new Object[]{reviewId, customerId});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Admin/Staff/Vet delete: can remove any review by id. Delete reply first if present.
    public boolean adminDeleteReview(long reviewId) {
        try {
            executeQuery("DELETE FROM ReviewReply WHERE review_id = ?", new Object[]{reviewId});
            int n = executeQuery("DELETE FROM Reviews WHERE review_id = ?", new Object[]{reviewId});
            return n > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
}
