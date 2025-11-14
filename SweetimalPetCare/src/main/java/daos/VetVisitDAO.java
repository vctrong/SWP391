package daos;

import db.DBContext;
import model.VetVisit;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VetVisitDAO extends DBContext {

    public List<VetVisit> listAll() throws SQLException {
        String sql = "SELECT v.visit_id, v.booking_id, v.pet_id, v.owner_id, v.vet_staff_id, " +
            "v.visit_type_code, t.description AS type_desc, p.name AS pet_name, vet.full_name AS vet_name, v.visit_date, v.weight_kg, v.temperature_c, " +
                "v.symptoms, v.diagnosis_summary, v.treatment_notes, v.follow_up_date, v.created_at " +
            "FROM VetVisit v JOIN VetVisitType t ON v.visit_type_code = t.visit_type_code " +
            "JOIN Pets p ON p.pet_id = v.pet_id " +
            "JOIN Users vet ON vet.user_id = v.vet_staff_id " +
                "ORDER BY v.visit_date DESC, v.visit_id DESC";

        ResultSet rs = executeSelectQuery(sql, null);
        return mapResultSet(rs);
    }

    public List<VetVisit> listByOwner(long ownerIdFilter) throws SQLException {
        String sql = "SELECT v.visit_id, v.booking_id, v.pet_id, v.owner_id, v.vet_staff_id, " +
            "v.visit_type_code, t.description AS type_desc, p.name AS pet_name, vet.full_name AS vet_name, v.visit_date, v.weight_kg, v.temperature_c, " +
                "v.symptoms, v.diagnosis_summary, v.treatment_notes, v.follow_up_date, v.created_at " +
            "FROM VetVisit v JOIN VetVisitType t ON v.visit_type_code = t.visit_type_code " +
            "JOIN Pets p ON p.pet_id = v.pet_id AND p.owner_id = v.owner_id " +
            "JOIN Users vet ON vet.user_id = v.vet_staff_id " +
                "WHERE v.owner_id = ? " +
                "ORDER BY v.visit_date DESC, v.visit_id DESC";

        ResultSet rs = executeSelectQuery(sql, new Object[]{ownerIdFilter});
        return mapResultSet(rs);
    }

    // Pagination support
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM VetVisit";
        ResultSet rs = executeSelectQuery(sql, null);
        return rs.next() ? rs.getInt("total") : 0;
    }

    public int countByOwner(long ownerId) throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM VetVisit WHERE owner_id = ?";
        ResultSet rs = executeSelectQuery(sql, new Object[]{ownerId});
        return rs.next() ? rs.getInt("total") : 0;
    }

    public List<VetVisit> listAllPaged(int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT v.visit_id, v.booking_id, v.pet_id, v.owner_id, v.vet_staff_id, " +
                "v.visit_type_code, t.description AS type_desc, p.name AS pet_name, vet.full_name AS vet_name, v.visit_date, v.weight_kg, v.temperature_c, " +
                "v.symptoms, v.diagnosis_summary, v.treatment_notes, v.follow_up_date, v.created_at " +
                "FROM VetVisit v JOIN VetVisitType t ON v.visit_type_code = t.visit_type_code " +
                "JOIN Pets p ON p.pet_id = v.pet_id " +
                "JOIN Users vet ON vet.user_id = v.vet_staff_id " +
                "ORDER BY v.visit_date DESC, v.visit_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        ResultSet rs = executeSelectQuery(sql, new Object[]{offset, pageSize});
        return mapResultSet(rs);
    }

    public List<VetVisit> listByOwnerPaged(long ownerId, int page, int pageSize) throws SQLException {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT v.visit_id, v.booking_id, v.pet_id, v.owner_id, v.vet_staff_id, " +
                "v.visit_type_code, t.description AS type_desc, p.name AS pet_name, vet.full_name AS vet_name, v.visit_date, v.weight_kg, v.temperature_c, " +
                "v.symptoms, v.diagnosis_summary, v.treatment_notes, v.follow_up_date, v.created_at " +
                "FROM VetVisit v JOIN VetVisitType t ON v.visit_type_code = t.visit_type_code " +
                "JOIN Pets p ON p.pet_id = v.pet_id AND p.owner_id = v.owner_id " +
                "JOIN Users vet ON vet.user_id = v.vet_staff_id " +
                "WHERE v.owner_id = ? ORDER BY v.visit_date DESC, v.visit_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        ResultSet rs = executeSelectQuery(sql, new Object[]{ownerId, offset, pageSize});
        return mapResultSet(rs);
    }

    private List<VetVisit> mapResultSet(ResultSet rs) throws SQLException {
        List<VetVisit> list = new ArrayList<>();
        while (rs.next()) {
            long visitId = rs.getLong("visit_id");
            Long bookingId = rs.getObject("booking_id") == null ? null : rs.getLong("booking_id");
            long petId = rs.getLong("pet_id");
            long ownerId = rs.getLong("owner_id");
            long vetStaffId = rs.getLong("vet_staff_id");
            String typeCode = rs.getString("visit_type_code");
            String typeDesc = rs.getString("type_desc");
            String petName = rs.getString("pet_name");
            String vetName = rs.getString("vet_name");
            LocalDateTime visitDate = rs.getTimestamp("visit_date").toLocalDateTime();
            BigDecimal weight = rs.getBigDecimal("weight_kg");
            BigDecimal temp = rs.getBigDecimal("temperature_c");
            String symptoms = rs.getString("symptoms");
            String diagnosis = rs.getString("diagnosis_summary");
            String treatment = rs.getString("treatment_notes");
            LocalDate followUp = rs.getDate("follow_up_date") == null ? null : rs.getDate("follow_up_date").toLocalDate();
            LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();

                list.add(new VetVisit(visitId, bookingId, petId, ownerId, vetStaffId,
                    typeCode, typeDesc, petName, vetName, visitDate, weight, temp, symptoms,
                    diagnosis, treatment, followUp, createdAt));
        }
        return list;
    }
}
