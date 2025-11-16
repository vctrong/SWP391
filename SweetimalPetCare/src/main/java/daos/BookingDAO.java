/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class BookingDAO extends db.DBContext {

    public int createBooking(int customerId, int petId, int serviceId, Integer packageId,
            LocalDate requestedDate, LocalTime requestedStart, String notes, BigDecimal totalPrice) throws SQLException {

    // Đảm bảo trường booking_time được thiết lập (DB yêu cầu không NULL). Dùng thời gian máy chủ cho booking_time và created_at.
    String sql = "INSERT INTO Booking (customer_id, pet_id, service_id, package_id, requested_date, requested_start, notes, total_price, booking_time, current_status, created_at) "
    + "OUTPUT INSERTED.booking_id VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), 'PENDING', GETDATE())";

        ResultSet rs = executeSelectQuery(sql, new Object[]{
            customerId, petId, serviceId, packageId,
            requestedDate, requestedStart, notes, totalPrice
        });

        if (rs.next()) {
            return rs.getInt("booking_id");
        }
        return 0;
    }

    /**
     * Tạo một booking và gán nguyên tử (atomically) vào khung thời gian (slot) tương ứng.
     * Sử dụng kết nối DB riêng và giao dịch với khoá cập nhật trên hàng ScheduleSlot
     * để ngăn các thao tác đồng thời (tránh đặt đôi — double-booking).
     *
     * Giá trị trả về:
     *  - booking_id (>0) khi thành công
     *  - -1 nếu slot không tồn tại
     *  - -2 nếu slot đã bị gán hoặc không ở trạng thái OPEN
     *  - -3 nếu thời gian bắt đầu slot nằm trong quá khứ
     *  - 0 cho các lỗi khác
     */
    public int createBookingAndAssignSlot(int customerId, int petId, int serviceId, Integer packageId,
            LocalDate requestedDate, LocalTime requestedStart, String notes, BigDecimal totalPrice, int slotId) throws SQLException {

        Connection conn = null;
        try {
            conn = openNewConnection();
            conn.setAutoCommit(false);

            // Khóa hàng của slot để cập nhật, ngăn việc gán cùng một slot đồng thời
            String lockSql = "SELECT slot_id, booking_id, status, start_time FROM ScheduleSlot WITH (UPDLOCK, ROWLOCK) WHERE slot_id = ?";
            try (PreparedStatement psLock = conn.prepareStatement(lockSql)) {
                psLock.setInt(1, slotId);
                try (ResultSet rs = psLock.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return -1; // slot không tồn tại
                    }
                    Object existingBooking = rs.getObject("booking_id");
                    String status = rs.getString("status");
                    Timestamp ts = rs.getTimestamp("start_time");
                    if (existingBooking != null || status == null || !"OPEN".equalsIgnoreCase(status)) {
                        conn.rollback();
                        return -2; // đã có booking hoặc không ở trạng thái OPEN
                    }
                    if (ts != null) {
                        LocalDateTime slotStart = ts.toLocalDateTime();
                        if (slotStart.isBefore(LocalDateTime.now())) {
                            conn.rollback();
                            return -3; // slot nằm trong quá khứ
                        }
                    }
                }
            }

            // Chèn booking và lấy id sinh ra bằng OUTPUT
            String insertSql = "INSERT INTO Booking (customer_id, pet_id, service_id, package_id, requested_date, requested_start, notes, total_price, booking_time, current_status, created_at) "
                    + "OUTPUT INSERTED.booking_id VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), 'PENDING', GETDATE())";
            int bookingId = 0;
            try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                psIns.setInt(1, customerId);
                psIns.setInt(2, petId);
                psIns.setInt(3, serviceId);
                if (packageId != null) {
                    psIns.setInt(4, packageId);
                } else {
                    psIns.setNull(4, java.sql.Types.INTEGER);
                }
                if (requestedDate != null) {
                    psIns.setDate(5, java.sql.Date.valueOf(requestedDate));
                } else {
                    psIns.setNull(5, java.sql.Types.DATE);
                }
                if (requestedStart != null) {
                    psIns.setTime(6, java.sql.Time.valueOf(requestedStart));
                } else {
                    psIns.setNull(6, java.sql.Types.TIME);
                }
                psIns.setString(7, notes);
                psIns.setBigDecimal(8, totalPrice);

                try (ResultSet rs = psIns.executeQuery()) {
                    if (rs.next()) {
                        bookingId = rs.getInt("booking_id");
                    } else {
                        conn.rollback();
                        return 0;
                    }
                }
            }

            // Gán booking vào slot
            String upd = "UPDATE ScheduleSlot SET booking_id = ?, status = 'BOOKED' WHERE slot_id = ?";
            try (PreparedStatement psUpd = conn.prepareStatement(upd)) {
                psUpd.setInt(1, bookingId);
                psUpd.setInt(2, slotId);
                int updated = psUpd.executeUpdate();
                if (updated != 1) {
                    conn.rollback();
                    return 0;
                }
            }

            conn.commit();
            return bookingId;

        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException e) {}
            }
            throw ex;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) {}
            }
        }
    }

    public java.util.List<model.Booking> getBookingsByCustomer(int customerId, int limit) throws SQLException {
        java.util.List<model.Booking> list = new java.util.ArrayList<>();
        String sql = "SELECT TOP (?) booking_id, customer_id, pet_id, service_id, package_id, requested_date, requested_start, notes, current_status, total_price, booking_time, created_at "
                + "FROM Booking WHERE customer_id = ? ORDER BY created_at DESC";
        java.sql.ResultSet rs = executeSelectQuery(sql, new Object[]{limit, customerId});
        while (rs.next()) {
            java.time.LocalDate rd = rs.getDate("requested_date") != null ? rs.getDate("requested_date").toLocalDate() : null;
            java.time.LocalTime rsTime = rs.getTime("requested_start") != null ? rs.getTime("requested_start").toLocalTime() : null;
            java.time.LocalDateTime bookingTime = rs.getTimestamp("booking_time") != null ? rs.getTimestamp("booking_time").toLocalDateTime() : null;
            java.time.LocalDateTime createdAt = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
            model.Booking b = new model.Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("customer_id"),
                    rs.getInt("pet_id"),
                    rs.getInt("service_id"),
                    rs.getObject("package_id") != null ? rs.getInt("package_id") : null,
                    rd,
                    rsTime,
                    rs.getString("notes"),
                    rs.getString("current_status"),
                    rs.getBigDecimal("total_price"),
                    bookingTime,
                    createdAt
            );
            list.add(b);
        }
        return list;
    }

    public void updateBookingStatus(int bookingId, String status, Integer changedBy) throws SQLException {
        // Update booking status and insert a history record
    String up = "UPDATE Booking SET current_status = ?, updated_at = SYSUTCDATETIME() WHERE booking_id = ?";
    executeQuery(up, new Object[]{status, bookingId});

    String ins = "INSERT INTO BookingStatusHistory(booking_id, status_code, changed_by, comment) VALUES (?, ?, ?, ?)";
    executeQuery(ins, new Object[]{bookingId, status, changedBy, "Status changed by admin"});
    }

    public model.Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT booking_id, customer_id, pet_id, service_id, package_id, requested_date, requested_start, notes, current_status, total_price, booking_time, created_at "
                + "FROM Booking WHERE booking_id = ?";
        ResultSet rs = executeSelectQuery(sql, new Object[]{bookingId});
        if (rs.next()) {
            java.time.LocalDate rd = rs.getDate("requested_date") != null ? rs.getDate("requested_date").toLocalDate() : null;
            java.time.LocalTime rsTime = rs.getTime("requested_start") != null ? rs.getTime("requested_start").toLocalTime() : null;
            java.time.LocalDateTime bookingTime = rs.getTimestamp("booking_time") != null ? rs.getTimestamp("booking_time").toLocalDateTime() : null;
            java.time.LocalDateTime createdAt = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
            return new model.Booking(
                    rs.getInt("booking_id"),
                    rs.getInt("customer_id"),
                    rs.getInt("pet_id"),
                    rs.getInt("service_id"),
                    rs.getObject("package_id") != null ? rs.getInt("package_id") : null,
                    rd,
                    rsTime,
                    rs.getString("notes"),
                    rs.getString("current_status"),
                    rs.getBigDecimal("total_price"),
                    bookingTime,
                    createdAt
            );
        }
        return null;
    }
}
