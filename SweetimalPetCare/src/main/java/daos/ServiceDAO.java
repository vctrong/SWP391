package daos;

import db.DBContext;
import java.sql.*;
import java.util.*;
import model.Service;

public class ServiceDAO extends DBContext {

    // Lấy tất cả dịch vụ đang ACTIVE kèm giá mới nhất
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        // New schema: Services.current_price contains the current price
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_duration_min, s.current_price "
                + "FROM Services s "
                + "WHERE s.status = 'ACTIVE'";

        try (ResultSet rs = executeSelectQuery(sql, null)) {
            while (rs.next()) {
                java.math.BigDecimal price = rs.getBigDecimal("current_price");
                if (price == null) price = java.math.BigDecimal.ZERO;
                list.add(new Service(
                        rs.getLong("service_id"),
                        rs.getString("service_name"),
                        rs.getString("description"),
                        rs.getInt("base_duration_min"),
                        price
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Service getServiceById(long serviceId) {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_duration_min, s.current_price "
                + "FROM Services s "
                + "WHERE s.service_id = ?";
        try (ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            if (rs.next()) {
                java.math.BigDecimal price = rs.getBigDecimal("current_price");
                if (price == null) price = java.math.BigDecimal.ZERO;
                return new Service(
                        rs.getLong("service_id"),
                        rs.getString("service_name"),
                        rs.getString("description"),
                        rs.getInt("base_duration_min"),
                        price
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create a new service and initial price history. Returns new service_id or -1 on failure.
     * Assumption: serviceCategoryId should exist; default to 1 if not provided.
     */
    public long createService(String serviceCode, String name, String description, int baseDurationMin, java.math.BigDecimal price, Integer serviceCategoryId) throws SQLException {
        int catId = (serviceCategoryId != null) ? serviceCategoryId : 1;
        String insert = "INSERT INTO Services (service_category_id, service_code, service_name, description, base_duration_min, current_price, status, created_at) VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE', GETDATE())";
        long serviceId = executeInsertAndReturnId(insert, new Object[]{catId, serviceCode, name, description, baseDurationMin, price});
        return serviceId > 0 ? serviceId : -1L;
    }

    /**
     * Update service metadata and append a new price history entry.
     */
    public boolean updateService(long serviceId, String name, String description, int baseDurationMin, java.math.BigDecimal price) throws SQLException {
        String up = "UPDATE Services SET service_name = ?, description = ?, base_duration_min = ?, current_price = ?, updated_at = SYSUTCDATETIME() WHERE service_id = ?";
        int r = executeQuery(up, new Object[]{name, description, baseDurationMin, price, serviceId});
        return r > 0;
    }

    /**
     * Soft-delete service by marking status INACTIVE.
     */
    public boolean inactivateService(int serviceId) throws SQLException {
        String sql = "UPDATE Services SET status = 'INACTIVE', updated_at = SYSUTCDATETIME() WHERE service_id = ?";
        int r = executeQuery(sql, new Object[]{serviceId});
        return r > 0;
    }
}
