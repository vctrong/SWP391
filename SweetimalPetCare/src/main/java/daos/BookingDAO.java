/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class BookingDAO extends db.DBContext {

    public int createBooking(int customerId, int petId, int serviceId, Integer packageId,
            LocalDate requestedDate, LocalTime requestedStart, String notes, BigDecimal totalPrice) throws SQLException {

    // Ensure booking_time is set (DB requires non-null). Use server time for booking_time and created_at.
    String sql = "INSERT INTO Booking (customer_id, pet_id, service_id, package_id, requested_date, requested_start, notes, total_price, booking_time, current_status, created_at) "
        + "OUTPUT INSERTED.booking_id VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), 'Pending', GETDATE())";

        ResultSet rs = executeSelectQuery(sql, new Object[]{
            customerId, petId, serviceId, packageId,
            requestedDate, requestedStart, notes, totalPrice
        });

        if (rs.next()) {
            return rs.getInt("booking_id");
        }
        return 0;
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
}
