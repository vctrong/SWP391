package daos;

import db.DBContext;
import java.sql.*;
import java.util.*;
import model.Service;

public class ServiceDAO extends DBContext {

    // Lấy tất cả dịch vụ đang ACTIVE kèm giá mới nhất
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();

        // SQL join với ServicePriceHistory để lấy giá mới nhất
        String sql = "SELECT s.service_id, s.service_name, s.description, "
                + "       s.base_duration_min, sph.price "
                + "FROM Services s "
                + "JOIN (SELECT service_id, MAX(effective_from) AS latest "
                + "      FROM ServicePriceHistory "
                + "      GROUP BY service_id) ph ON s.service_id = ph.service_id "
                + "JOIN ServicePriceHistory sph ON sph.service_id = ph.service_id AND sph.effective_from = ph.latest "
                + "WHERE s.status = 'ACTIVE'";
        try ( ResultSet rs = executeSelectQuery(sql, null)) {
            while (rs.next()) {
                list.add(new Service(
                        (int) rs.getLong("service_id"),
                        rs.getString("service_name"),
                        rs.getString("description"),
                        rs.getInt("base_duration_min"),
                        rs.getBigDecimal("price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
