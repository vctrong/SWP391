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
        String sql = "INSERT INTO ConsultationRequests(customer_name, email, phone, subject, request_message, user_id, status_code, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Object[] params = new Object[]{
            cr.getCustomerName(),
            cr.getEmail(),
            cr.getPhone(),
            cr.getSubject(),
            cr.getRequestMessage(),
            cr.getUserId(),
            cr.getStatusCode(),
            Timestamp.valueOf(cr.getCreatedAt())
        };
        return db.executeInsertAndReturnId(sql, params);
    }

    public List<ConsultationRequest> listLatest(int limit) throws SQLException {
        String sql = "SELECT request_id, customer_name, email, phone, subject, request_message, user_id, status_code, created_at "
                + "FROM ConsultationRequests ORDER BY created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
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
                cr.setSubject(rs.getString("subject"));
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
        String sql = "SELECT request_id, customer_name, email, phone, subject, request_message, user_id, status_code, created_at "
                + "FROM ConsultationRequests ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
                cr.setSubject(rs.getString("subject"));
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

    public String validate(ConsultationRequest cr) {
        if (cr.getCustomerName() == null || cr.getCustomerName().trim().isEmpty()) return "Vui lòng nhập họ tên.";
        if (cr.getEmail() == null || cr.getEmail().trim().isEmpty()) return "Vui lòng nhập email.";
        if (cr.getSubject() == null || cr.getSubject().trim().isEmpty()) return "Vui lòng chọn chủ đề.";
        if (cr.getRequestMessage() == null || cr.getRequestMessage().trim().isEmpty()) return "Vui lòng nhập nội dung.";
        if (cr.getCustomerName().length() > 120) return "Tên quá dài.";
        if (cr.getEmail().length() > 150) return "Email quá dài.";
        if (cr.getPhone() != null && cr.getPhone().length() > 20) return "Số điện thoại quá dài.";
        if (cr.getSubject().length() > 255) return "Chủ đề quá dài.";
        return null;
    }
}
