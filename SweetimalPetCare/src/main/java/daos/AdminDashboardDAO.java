/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import db.DBContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AdminUserAction;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class AdminDashboardDAO {

    private final DBContext db = new DBContext();

    private int countTable(String table) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + table;
        try ( ResultSet rs = db.executeSelectQuery(sql, null)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getUserCount() throws SQLException {
        return countTable("Users");
    }

    public int getOrderCount() throws SQLException {
        return countTable("Orders");
    }

    public int getBookingCount() throws SQLException {
        return countTable("Booking");
    }

    public int getProductCount() throws SQLException {
        return countTable("Product");
    }

    // ✅ Fetch latest audit log entries
    public List<AdminUserAction> getRecentAuditLogs() throws SQLException {
        List<AdminUserAction> list = new ArrayList<>();
        String sql = "SELECT TOP 20 a.audit_id, u.full_name, u.email, a.action_code, a.entity_name, a.entity_id, a.detail_json, a.created_at FROM AuditLog a JOIN Users u ON a.user_id = u.user_id ORDER BY a.created_at DESC";

        try ( ResultSet rs = db.executeSelectQuery(sql, null)) {
            while (rs.next()) {
                AdminUserAction act = new AdminUserAction();
                act.setFullName(rs.getString("full_name"));
                act.setEmail(rs.getString("email"));
                act.setActionType(rs.getString("action_code"));
                act.setDescription(
                        rs.getString("entity_name") + " #" + rs.getInt("entity_id")
                        + (rs.getString("detail_json") != null ? " - " + rs.getString("detail_json") : "")
                );
                act.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                list.add(act);
            }
        }
        return list;
    }
}
