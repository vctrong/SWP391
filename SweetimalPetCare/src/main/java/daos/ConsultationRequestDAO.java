package daos;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ConsultationRequest;

public class ConsultationRequestDAO extends DBContext {

    public long create(ConsultationRequest cr) {
        String sql = "INSERT INTO ConsultationRequests(customer_name, email, phone, consultation_type_id, request_message, user_id, status_code, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, cr.getCustomerName());
            ps.setString(2, cr.getEmail());
            ps.setString(3, cr.getPhone());
            ps.setInt(4, cr.getConsultationTypeId());
            ps.setString(5, cr.getRequestMessage());

            if (cr.getUserId() != null && cr.getUserId() > 0) {
                ps.setLong(6, cr.getUserId());
            } else {
                ps.setNull(6, java.sql.Types.BIGINT);
            }

            ps.setString(7, cr.getStatusCode());
            ps.setTimestamp(8, Timestamp.valueOf(cr.getCreatedAt()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try ( ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getLong(1);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi create ConsultationRequest: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public List<ConsultationRequest> listLatest(int limit) {
        // Postgres: LIMIT
        String sql = "SELECT cr.request_id, cr.customer_name, cr.email, cr.phone, cr.consultation_type_id, ct.type_name AS consultation_type_name, cr.request_message, cr.user_id, cr.status_code, cr.created_at "
                + "FROM ConsultationRequests cr LEFT JOIN ConsultationTypes ct ON cr.consultation_type_id = ct.type_id "
                + "ORDER BY cr.created_at DESC LIMIT ?";

        List<ConsultationRequest> list = new ArrayList<>();

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ConsultationRequest cr = new ConsultationRequest();
                    cr.setRequestId(rs.getLong("request_id"));
                    cr.setCustomerName(rs.getString("customer_name"));
                    cr.setEmail(rs.getString("email"));
                    cr.setPhone(rs.getString("phone"));
                    cr.setConsultationTypeId(rs.getInt("consultation_type_id"));
                    cr.setConsultationTypeName(rs.getString("consultation_type_name")); // Postgres dùng getString
                    cr.setRequestMessage(rs.getString("request_message"));

                    long uid = rs.getLong("user_id");
                    if (!rs.wasNull()) {
                        cr.setUserId(uid);
                    }

                    cr.setStatusCode(rs.getString("status_code"));

                    Timestamp ts = rs.getTimestamp("created_at");
                    cr.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

                    list.add(cr);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi listLatest: " + ex.getMessage(), ex);
        }
        return list;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) AS total FROM ConsultationRequests";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi countAll: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public List<ConsultationRequest> listPaged(int offset, int limit) {
        // FIX: OFFSET ... FETCH -> LIMIT ... OFFSET
        String sql = "SELECT cr.request_id, cr.customer_name, cr.email, cr.phone, cr.consultation_type_id, ct.type_name AS consultation_type_name, cr.request_message, cr.user_id, cr.status_code, cr.created_at "
                + "FROM ConsultationRequests cr LEFT JOIN ConsultationTypes ct ON cr.consultation_type_id = ct.type_id "
                + "ORDER BY cr.created_at DESC LIMIT ? OFFSET ?";

        List<ConsultationRequest> list = new ArrayList<>();

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // QUAN TRỌNG: Postgres LIMIT trước, OFFSET sau
            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ConsultationRequest cr = new ConsultationRequest();
                    cr.setRequestId(rs.getLong("request_id"));
                    cr.setCustomerName(rs.getString("customer_name"));
                    cr.setEmail(rs.getString("email"));
                    cr.setPhone(rs.getString("phone"));
                    cr.setConsultationTypeId(rs.getInt("consultation_type_id"));
                    cr.setConsultationTypeName(rs.getString("consultation_type_name"));
                    cr.setRequestMessage(rs.getString("request_message"));

                    long uid = rs.getLong("user_id");
                    if (!rs.wasNull()) {
                        cr.setUserId(uid);
                    }

                    cr.setStatusCode(rs.getString("status_code"));

                    Timestamp ts = rs.getTimestamp("created_at");
                    cr.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);

                    list.add(cr);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi listPaged: " + ex.getMessage(), ex);
        }
        return list;
    }

    public boolean updateStatus(long requestId, String statusCode) {
        String sql = "UPDATE ConsultationRequests SET status_code = ? WHERE request_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, statusCode);
            ps.setLong(2, requestId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi updateStatus: " + ex.getMessage(), ex);
        }
        return false;
    }

    public boolean deleteById(long requestId) {
        String sql = "DELETE FROM ConsultationRequests WHERE request_id = ?";
        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, requestId);

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationRequestDAO.class.getName()).log(Level.SEVERE, "Lỗi deleteById: " + ex.getMessage(), ex);
        }
        return false;
    }
}
