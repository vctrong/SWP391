package daos;

import db.DBContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.ConsultationRequest;

public class ConsultationRequestDAO {

    private final DBContext db = new DBContext();

    public long create(ConsultationRequest cr) throws SQLException {
        String sql = "INSERT INTO ConsultationRequests(customer_name, email, phone, consultation_type_id, request_message, user_id, status_code, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = new Object[]{
            cr.getCustomerName(),
            cr.getEmail(),
            cr.getPhone(),
            cr.getConsultationTypeId(),
            cr.getRequestMessage(),
            cr.getUserId(),
            cr.getStatusCode(),
            Timestamp.valueOf(cr.getCreatedAt())
        };
        return db.executeInsertAndReturnId(sql, params);
    }

    public List<ConsultationRequest> listLatest(int limit) throws SQLException {
        String sql = "SELECT cr.request_id, cr.customer_name, cr.email, cr.phone, cr.consultation_type_id, ct.type_name AS consultation_type_name, cr.request_message, cr.user_id, cr.status_code, cr.created_at "
            + "FROM ConsultationRequests cr LEFT JOIN ConsultationTypes ct ON cr.consultation_type_id = ct.type_id "
            + "ORDER BY cr.created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        ResultSet rs = null;
        List<ConsultationRequest> list = new ArrayList<>();
        try {
            rs = db.executeSelectQuery(sql, new Object[]{limit});
            while (rs.next()) {
                ConsultationRequest cr = new ConsultationRequest();
                cr.setRequestId(rs.getLong("request_id"));
                cr.setCustomerName(rs.getString("customer_name"));
                cr.setEmail(rs.getString("email"));
                cr.setPhone(rs.getString("phone"));
                cr.setConsultationTypeId((Integer) rs.getObject("consultation_type_id"));
                cr.setConsultationTypeName(rs.getNString("consultation_type_name"));
                cr.setRequestMessage(rs.getString("request_message"));
                Object uid = rs.getObject("user_id");
                cr.setUserId(uid == null ? null : ((Number) uid).longValue());
                cr.setStatusCode(rs.getString("status_code"));
                Timestamp ts = rs.getTimestamp("created_at");
                cr.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                list.add(cr);
            }
        } finally {
            if (rs != null) try { rs.getStatement().close(); } catch (Exception ignore) {}
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        }
        return list;
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM ConsultationRequests";
        ResultSet rs = null;
        try {
            rs = db.executeSelectQuery(sql, null);
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } finally {
            if (rs != null) try { rs.getStatement().close(); } catch (Exception ignore) {}
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        }
    }

    public List<ConsultationRequest> listPaged(int offset, int limit) throws SQLException {
        String sql = "SELECT cr.request_id, cr.customer_name, cr.email, cr.phone, cr.consultation_type_id, ct.type_name AS consultation_type_name, cr.request_message, cr.user_id, cr.status_code, cr.created_at "
            + "FROM ConsultationRequests cr LEFT JOIN ConsultationTypes ct ON cr.consultation_type_id = ct.type_id "
            + "ORDER BY cr.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        ResultSet rs = null;
        List<ConsultationRequest> list = new ArrayList<>();
        try {
            rs = db.executeSelectQuery(sql, new Object[]{offset, limit});
            while (rs.next()) {
                ConsultationRequest cr = new ConsultationRequest();
                cr.setRequestId(rs.getLong("request_id"));
                cr.setCustomerName(rs.getString("customer_name"));
                cr.setEmail(rs.getString("email"));
                cr.setPhone(rs.getString("phone"));
                cr.setConsultationTypeId((Integer) rs.getObject("consultation_type_id"));
                cr.setConsultationTypeName(rs.getNString("consultation_type_name"));
                cr.setRequestMessage(rs.getString("request_message"));
                Object uid = rs.getObject("user_id");
                cr.setUserId(uid == null ? null : ((Number) uid).longValue());
                cr.setStatusCode(rs.getString("status_code"));
                Timestamp ts = rs.getTimestamp("created_at");
                cr.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                list.add(cr);
            }
        } finally {
            if (rs != null) try { rs.getStatement().close(); } catch (Exception ignore) {}
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        }
        return list;
    }

    

    public boolean updateStatus(long requestId, String statusCode) throws SQLException {
        String sql = "UPDATE ConsultationRequests SET status_code = ? WHERE request_id = ?";
        int updated = db.executeQuery(sql, new Object[]{statusCode, requestId});
        return updated > 0;
    }

    public boolean deleteById(long requestId) throws SQLException {
        String sql = "DELETE FROM ConsultationRequests WHERE request_id = ?";
        int deleted = db.executeQuery(sql, new Object[]{requestId});
        return deleted > 0;
    }
}
