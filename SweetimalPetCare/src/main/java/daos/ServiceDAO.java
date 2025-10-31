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

    public Service getServiceById(int serviceId) {
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_duration_min, sph.price "
                + "FROM Services s "
                + "LEFT JOIN (SELECT service_id, MAX(effective_from) AS latest FROM ServicePriceHistory GROUP BY service_id) ph ON s.service_id = ph.service_id "
                + "LEFT JOIN ServicePriceHistory sph ON sph.service_id = ph.service_id AND sph.effective_from = ph.latest "
                + "WHERE s.service_id = ?";
        try (ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            if (rs.next()) {
                return new Service(
                        (int) rs.getLong("service_id"),
                        rs.getString("service_name"),
                        rs.getString("description"),
                        rs.getInt("base_duration_min"),
                        rs.getBigDecimal("price")
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
    public int createService(String serviceCode, String name, String description, int baseDurationMin, java.math.BigDecimal price, Integer serviceCategoryId) throws SQLException {
        int catId = (serviceCategoryId != null) ? serviceCategoryId : 1;
        String insert = "INSERT INTO Services (service_category_id, service_code, service_name, description, base_duration_min, status, created_at) VALUES (?, ?, ?, ?, ?, 'ACTIVE', GETDATE())";
        int serviceId = executeInsertAndReturnId(insert, new Object[]{catId, serviceCode, name, description, baseDurationMin});
        if (serviceId > 0) {
            String ph = "INSERT INTO ServicePriceHistory(service_id, effective_from, price, created_at) VALUES (?, GETDATE(), ?, GETDATE())";
            executeQuery(ph, new Object[]{serviceId, price});
            return serviceId;
        }
        return -1;
    }

    /**
     * Update service metadata and append a new price history entry.
     */
    public boolean updateService(int serviceId, String name, String description, int baseDurationMin, java.math.BigDecimal price) throws SQLException {
        String up = "UPDATE Services SET service_name = ?, description = ?, base_duration_min = ? WHERE service_id = ?";
        int r = executeQuery(up, new Object[]{name, description, baseDurationMin, serviceId});
        // append new price history
        String ph = "INSERT INTO ServicePriceHistory(service_id, effective_from, price, created_at) VALUES (?, GETDATE(), ?, GETDATE())";
        executeQuery(ph, new Object[]{serviceId, price});
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
