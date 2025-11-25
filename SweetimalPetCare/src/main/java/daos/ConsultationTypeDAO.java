package daos;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ConsultationType;

public class ConsultationTypeDAO extends db.DBContext {

    public List<ConsultationType> listActive() {
        List<ConsultationType> list = new ArrayList<>();

        // FIX: Postgres dùng 'IS TRUE' hoặc '= true' cho cột boolean
        String sql = "SELECT type_id, type_name, description, is_active FROM ConsultationTypes WHERE is_active IS TRUE ORDER BY type_name";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ConsultationType ct = new ConsultationType();
                ct.setTypeId(rs.getInt("type_id"));

                // FIX: Postgres dùng getString thay vì getNString
                ct.setTypeName(rs.getString("type_name"));
                ct.setDescription(rs.getString("description"));

                ct.setActive(rs.getBoolean("is_active"));
                list.add(ct);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationTypeDAO.class.getName()).log(Level.ALL.SEVERE, "Lỗi listActive: " + ex.getMessage(), ex);
        }
        return list;
    }

    public ConsultationType findById(int id) {
        String sql = "SELECT type_id, type_name, description, is_active FROM ConsultationTypes WHERE type_id = ?";

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ConsultationType ct = new ConsultationType();
                    ct.setTypeId(rs.getInt("type_id"));

                    // FIX: Postgres dùng getString
                    ct.setTypeName(rs.getString("type_name"));
                    ct.setDescription(rs.getString("description"));

                    ct.setActive(rs.getBoolean("is_active"));
                    return ct;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ConsultationTypeDAO.class.getName()).log(Level.SEVERE, "Lỗi findById: " + ex.getMessage(), ex);
        }
        return null;
    }
}
