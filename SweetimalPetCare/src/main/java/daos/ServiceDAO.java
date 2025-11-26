package daos;

import db.DBContext;
import java.sql.*;
import java.util.*;
import model.Service;

public class ServiceDAO extends DBContext {

    // Lấy tất cả dịch vụ đang ACTIVE kèm giá mới nhất
    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_duration_min, s.current_price "
                + "FROM Services s "
                + "WHERE s.status = 'ACTIVE'";

        try ( ResultSet rs = executeSelectQuery(sql, null)) {
            while (rs.next()) {
                java.math.BigDecimal price = rs.getBigDecimal("current_price");
                if (price == null) {
                    price = java.math.BigDecimal.ZERO;
                }
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
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT s.service_id, s.service_name, s.description, s.base_duration_min, s.current_price "
                + "FROM Services s "
                + "WHERE s.service_id = ? AND s.status = 'ACTIVE'";
        try ( ResultSet rs = executeSelectQuery(sql, new Object[]{serviceId})) {
            if (rs.next()) {
                java.math.BigDecimal price = rs.getBigDecimal("current_price");
                if (price == null) {
                    price = java.math.BigDecimal.ZERO;
                }
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
     * Tạo dịch vụ mới và thêm mục lịch sử giá ban đầu. Trả về service_id mới
     * hoặc -1 nếu thất bại. Giả định: serviceCategoryId tồn tại; nếu không cung
     * cấp thì mặc định = 1.
     */
    public long createService(String serviceCode, String name, String description, int baseDurationMin, java.math.BigDecimal price, Integer serviceCategoryId) throws SQLException {
        int catId = (serviceCategoryId != null) ? serviceCategoryId : 1;
        // Đã sửa: GETDATE() -> NOW()
        String insert = "INSERT INTO Services (service_category_id, service_code, service_name, description, base_duration_min, current_price, status, created_at) VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE', NOW())";
        long serviceId = executeInsertAndReturnId(insert, new Object[]{catId, serviceCode, name, description, baseDurationMin, price});
        return serviceId > 0 ? serviceId : -1L;
    }

    /**
     * Cập nhật metadata của dịch vụ và thêm mục lịch sử giá mới.
     */
    public boolean updateService(long serviceId, String name, String description, int baseDurationMin, java.math.BigDecimal price) throws SQLException {
        // Đã sửa: SYSUTCDATETIME() -> NOW()
        String up = "UPDATE Services SET service_name = ?, description = ?, base_duration_min = ?, current_price = ?, updated_at = NOW() WHERE service_id = ?";
        int r = executeQuery(up, new Object[]{name, description, baseDurationMin, price, serviceId});
        return r > 0;
    }

    /**
     * Vô hiệu hóa (soft-delete) dịch vụ bằng cách đánh dấu trạng thái là
     * INACTIVE.
     */
    public boolean inactivateService(int serviceId) throws SQLException {
        // Đã sửa: SYSUTCDATETIME() -> NOW()
        String sql = "UPDATE Services SET status = 'INACTIVE', updated_at = NOW() WHERE service_id = ?";
        int r = executeQuery(sql, new Object[]{serviceId});
        return r > 0;
    }
}
