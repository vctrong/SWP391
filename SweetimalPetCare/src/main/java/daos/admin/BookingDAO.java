/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import dto.CalendarEventDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.bookingAdmin.Booking;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class BookingDAO extends db.DBContext {

    public int countBookings(String search, String status) {
        int count = 0;
        List<Object> params = new ArrayList<>();

        // Câu SQL gốc
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Booking b ");
        sql.append("JOIN Users u ON b.customer_id = u.user_id "); // Join để tìm theo tên/sđt khách
        sql.append("WHERE 1=1 "); // Mẹo dùng 1=1 để dễ nối chuỗi AND

        // Logic tìm kiếm (Search)
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.phone LIKE ?) ");
            String keyword = "%" + search.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        // Logic lọc trạng thái (Filter)
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND b.current_status = ? ");
            params.add(status);
        }

        // Thực thi Query
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Gán các tham số vào dấu ?
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;
    }

    public List<Booking> getBookingsByPage(String search, String status, int pageIndex, int pageSize) {
        List<Booking> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // Xây dựng câu SELECT lấy đầy đủ thông tin (như bạn đã làm trước đây)
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.booking_id, b.customer_id, u.full_name, ");
        sql.append("       b.pet_id, p.name AS pet_name, ");
        sql.append("       (SELECT TOP 1 st.is_veterinarian ");
        sql.append("        FROM ScheduleSlot ss ");
        sql.append("        JOIN Users st ON ss.staff_id = st.user_id ");
        sql.append("        WHERE ss.booking_id = b.booking_id) AS is_vet, ");
        // Xử lý tên Item (Service hoặc Package)
        sql.append("       CASE WHEN b.service_id IS NOT NULL THEN s.service_name ");
        sql.append("            WHEN b.package_id IS NOT NULL THEN pk.package_name ");
        sql.append("       END AS item, ");

        // Xử lý loại (Type)
        sql.append("       CASE WHEN b.service_id IS NOT NULL THEN 'Service' ");
        sql.append("            WHEN b.package_id IS NOT NULL THEN 'Package' ");
        sql.append("       END AS type, ");

        // Xử lý thời lượng (Duration)
        sql.append("       CASE WHEN b.service_id IS NOT NULL THEN s.base_duration_min ELSE 0 END AS duration, ");

        sql.append("       b.booking_time, b.requested_date, b.requested_start, ");
        sql.append("       b.notes, b.current_status, b.total_price, b.payment_status, b.created_at, u.phone ");

        sql.append("FROM Booking b ");
        sql.append("JOIN Users u ON b.customer_id = u.user_id ");
        sql.append("JOIN Pets p ON b.pet_id = p.pet_id ");
        sql.append("LEFT JOIN Services s ON b.service_id = s.service_id ");
        sql.append("LEFT JOIN ServicePackage pk ON b.package_id = pk.package_id ");
        sql.append("WHERE 1=1 ");

        // --- XỬ LÝ SEARCH (Giống hàm count) ---
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.phone LIKE ?) ");
            String keyword = "%" + search.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        // --- XỬ LÝ FILTER (Giống hàm count) ---
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND b.current_status = ? ");
            params.add(status);
        }

        // --- XỬ LÝ PHÂN TRANG (Pagination) ---
        // SQL Server bắt buộc phải có ORDER BY trước khi dùng OFFSET
        sql.append("ORDER BY b.booking_id DESC "); // Sắp xếp mới nhất lên đầu
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        // Tính toán vị trí cắt dữ liệu
        int offset = (pageIndex - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        // Thực thi Query
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Gán tham số
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Map dữ liệu vào Model Booking
                    // (Đảm bảo Constructor của Booking khớp với thứ tự này)
                    Booking b = new Booking(
                            rs.getLong("booking_id"),
                            rs.getLong("customer_id"),
                            rs.getString("full_name"),
                            rs.getLong("pet_id"),
                            rs.getString("pet_name"),
                            rs.getString("item"), // Lấy theo alias 'item'
                            rs.getString("type"), // Lấy theo alias 'type'
                            rs.getInt("duration"), // Lấy theo alias 'duration'

                            rs.getDate("booking_time"),
                            rs.getDate("requested_date"),
                            rs.getTime("requested_start"),
                            rs.getString("notes"),
                            rs.getString("current_status"),
                            rs.getBigDecimal("total_price"),
                            rs.getString("payment_status"),
                            rs.getDate("created_at"),
                            rs.getString("phone")
                    );
                    b.setIsVet(rs.getBoolean("is_vet"));
                    list.add(b);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public ArrayList<CalendarEventDTO> getBookingForCalendar(Date startDate, Date endDate) {
        ArrayList<CalendarEventDTO> events = new ArrayList<>();

        String sql = "SELECT b.booking_id, b.requested_date, b.requested_start, "
                + "       b.current_status, b.total_price, b.payment_status, b.notes, "
                + "       u.full_name, u.phone, u.email, "
                + "       p.name AS pet_name, ps.species_name AS pet_type, "
                + "       s.service_name, s.base_duration_min, "
                + "       pk.package_name "
                + "FROM Booking b "
                + "JOIN Users u ON b.customer_id = u.user_id "
                + "JOIN Pets p ON b.pet_id = p.pet_id "
                + "JOIN PetSpecies ps ON p.species_id = ps.species_id "
                + "LEFT JOIN Services s ON b.service_id = s.service_id "
                + "LEFT JOIN ServicePackage pk ON b.package_id = pk.package_id "
                + "WHERE b.requested_date BETWEEN ? AND ?";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, startDate);
            ps.setDate(2, endDate);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String id = String.valueOf(rs.getLong("booking_id"));

                    // --- XỬ LÝ NGÀY GIỜ VÀ ITEM NAME ---
                    Date date = rs.getDate("requested_date");
                    Time startTime = rs.getTime("requested_start");
                    String startISO = date.toString() + "T" + startTime.toString(); // "2025-11-12T09:00:00"

                    String endISO = null; // Mặc định là NULL (Dành cho Package)
                    String itemName;

                    // Kiểm tra xem đây là Service hay Package?
                    String serviceName = rs.getString("service_name");

                    if (serviceName != null) {
                        // === TRƯỜNG HỢP 1: LÀ SERVICE (CÓ DURATION) ===
                        itemName = serviceName;

                        // Lấy duration (phút)
                        int durationMin = rs.getInt("base_duration_min");
                        if (durationMin == 0) {
                            durationMin = 60; // Fallback nếu quên nhập DB
                        }
                        // Tính End Time = Start + Duration
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(startTime);
                        cal.add(java.util.Calendar.MINUTE, durationMin);
                        Time endTime = new Time(cal.getTimeInMillis());

                        endISO = date.toString() + "T" + endTime.toString(); // Set giá trị end

                    } else {
                        // === TRƯỜNG HỢP 2: LÀ PACKAGE (KHÔNG CÓ END) ===
                        itemName = rs.getString("package_name");
                        // endISO vẫn giữ nguyên là null -> FullCalendar tự xử
                    }

                    String title = itemName + " - " + rs.getString("full_name");

                    // --- XỬ LÝ MÀU SẮC (Giữ nguyên) ---
                    String status = rs.getString("current_status");
                    String color = "#3788d8"; // Mặc định xanh dương

                    if (status != null) {
                        switch (status) {
                            case "PENDING":
                                color = "#f59e0b"; // Vàng cam (Amber) - Cần chú ý
                                break;
                            case "CONFIRMED":
                                color = "#10b981"; // Xanh lá (Emerald) - Đã chốt
                                break;
                            case "IN_PROGRESS":
                                color = "#3b82f6"; // Xanh dương (Blue) - Đang làm
                                break;
                            case "COMPLETED":
                                color = "#6b7280"; // Xám (Gray) - Đã xong
                                break;
                            case "CANCELLED":
                                color = "#ef4444"; // Đỏ (Red) - Đã hủy
                                break;
                            case "NO_SHOW":
                                color = "#991b1b"; // Đỏ đậm (Dark Red) - Khách không đến
                                break;
                        }
                    }

                    // --- TẠO DTO ---
                    CalendarEventDTO.ExtendedProps props = new CalendarEventDTO.ExtendedProps(
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("pet_name"),
                            rs.getString("pet_type"),
                            itemName,
                            rs.getDouble("total_price"),
                            rs.getString("payment_status"),
                            rs.getString("notes"),
                            status
                    );

                    // Truyền endISO (có thể là chuỗi hoặc null) vào DTO
                    CalendarEventDTO dto = new CalendarEventDTO(id, title, startISO, endISO, color);
                    dto.setExtendedProps(props);

                    events.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    public Booking getBookingByID(long id) {
        try {
            String qr = "SELECT b.booking_id, b.customer_id, u.full_name, "
                    + "       b.pet_id, p.name AS pet_name, "
                    + "       CASE WHEN b.service_id IS NOT NULL THEN s.service_name "
                    + "            WHEN b.package_id IS NOT NULL THEN pk.package_name "
                    + "       END AS item, "
                    + "       CASE WHEN b.service_id IS NOT NULL THEN 'Service' "
                    + "            WHEN b.package_id IS NOT NULL THEN 'Package' "
                    + "       END AS type, "
                    + "       CASE WHEN b.service_id IS NOT NULL THEN s.base_duration_min ELSE 0 END AS duration, "
                    + "       b.booking_time, b.requested_date, b.requested_start, "
                    + "       b.notes, b.current_status, b.total_price, b.payment_status, b.created_at "
                    + "       , u.phone "
                    + "FROM Booking b "
                    + "JOIN Users u ON b.customer_id = u.user_id "
                    + "JOIN Pets p ON b.pet_id = p.pet_id "
                    + "LEFT JOIN Services s ON b.service_id = s.service_id "
                    + "LEFT JOIN ServicePackage pk ON b.package_id = pk.package_id "
                    + "WHERE b.booking_id = ?";
            Object[] params = {id};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return new Booking(
                        rs.getLong(1), rs.getLong(2), rs.getString(3), rs.getLong(4),
                        rs.getString(5), rs.getString(6), rs.getString(7), rs.getInt(8),
                        rs.getDate(9), rs.getDate(10), rs.getTime(11),
                        rs.getString(12), rs.getString(13), rs.getBigDecimal(14),
                        rs.getString(15), rs.getDate(16), rs.getString(17));
            }
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updateBookingStatus(long id, String newStatus) {
        try {
            String sql = "UPDATE Booking SET current_status = ?, updated_at = GETDATE() WHERE booking_id = ?";

            Object[] params = {newStatus, id};
            return this.executeQuery(sql, params) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(BookingDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean insertVetVisit(long bookingId, long petId, long ownerId, long vetStaffId,
            String visitType, Timestamp visitDate,
            BigDecimal weight, BigDecimal temperature,
            String symptoms, String diagnosis, String treatment,
            Date followUpDate) {

        String sql = "INSERT INTO VetVisit "
                + "(booking_id, pet_id, owner_id, vet_staff_id, visit_type_code, visit_date, "
                + " weight_kg, temperature_c, symptoms, diagnosis_summary, treatment_notes, follow_up_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, bookingId);
            ps.setLong(2, petId);
            ps.setLong(3, ownerId);
            ps.setLong(4, vetStaffId);
            ps.setString(5, visitType);
            ps.setTimestamp(6, visitDate);

            // Xử lý số thực (có thể null)
            ps.setBigDecimal(7, weight);
            ps.setBigDecimal(8, temperature);

            // Xử lý chuỗi (có thể null/empty)
            ps.setString(9, symptoms);
            ps.setString(10, diagnosis);
            ps.setString(11, treatment);

            // Xử lý ngày tái khám (có thể null)
            ps.setDate(12, followUpDate);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
