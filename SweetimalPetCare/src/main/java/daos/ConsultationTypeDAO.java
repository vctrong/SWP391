package daos;

import db.DBContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ConsultationType;

public class ConsultationTypeDAO {
    private final DBContext db = new DBContext();

    public List<ConsultationType> listActive() throws SQLException {
        String sql = "SELECT type_id, type_name, description, is_active FROM ConsultationTypes WHERE is_active = 1 ORDER BY type_name";
        ResultSet rs = null;
        List<ConsultationType> list = new ArrayList<>();
        try {
            rs = db.executeSelectQuery(sql, null);
            while (rs.next()) {
                ConsultationType ct = new ConsultationType();
                ct.setTypeId(rs.getInt("type_id"));
                ct.setTypeName(rs.getNString("type_name"));
                ct.setDescription(rs.getNString("description"));
                ct.setActive(rs.getBoolean("is_active"));
                list.add(ct);
            }
        } finally {
            if (rs != null) try { rs.getStatement().close(); } catch (Exception ignore) {}
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        }
        return list;
    }

    public ConsultationType findById(int id) throws SQLException {
        String sql = "SELECT type_id, type_name, description, is_active FROM ConsultationTypes WHERE type_id = ?";
        ResultSet rs = null;
        try {
            rs = db.executeSelectQuery(sql, new Object[]{id});
            if (rs.next()) {
                ConsultationType ct = new ConsultationType();
                ct.setTypeId(rs.getInt("type_id"));
                ct.setTypeName(rs.getNString("type_name"));
                ct.setDescription(rs.getNString("description"));
                ct.setActive(rs.getBoolean("is_active"));
                return ct;
            }
            return null;
        } finally {
            if (rs != null) try { rs.getStatement().close(); } catch (Exception ignore) {}
            if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        }
    }
}