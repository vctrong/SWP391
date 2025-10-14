/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.ScheduleSlot;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class ScheduleDAO extends db.DBContext {

    public List<ScheduleSlot> getSlotsByStaff(int staffId) throws SQLException {
        List<ScheduleSlot> slots = new ArrayList<>();
        String sql = "SELECT * FROM ScheduleSlot WHERE staff_id = ? ORDER BY start_time";
        ResultSet rs = executeSelectQuery(sql, new Object[]{staffId});
        while (rs.next()) {
            slots.add(new ScheduleSlot(
                    rs.getInt("slot_id"),
                    rs.getInt("staff_id"),
                    rs.getInt("booking_id"),
                    rs.getString("room_name"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getString("status")
            ));
        }
        return slots;
    }

    public List<ScheduleSlot> getAvailableSlots() throws SQLException {
        List<ScheduleSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ScheduleSlot WHERE booking_id IS NULL AND status = 'OPEN' ORDER BY start_time";
        ResultSet rs = executeSelectQuery(sql, null);
        while (rs.next()) {
            list.add(new ScheduleSlot(
                    rs.getInt("slot_id"),
                    rs.getInt("staff_id"),
                    rs.getInt("booking_id"),
                    rs.getString("room_name"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getString("status")
            ));
        }
        return list;
    }

    public void addSlot(int staffId, String roomName, LocalDateTime start, LocalDateTime end) throws SQLException {
        String sql = "INSERT INTO ScheduleSlot (staff_id, room_name, start_time, end_time, status, created_at) VALUES (?, ?, ?, ?, 'OPEN', GETDATE())";
        executeQuery(sql, new Object[]{staffId, roomName, Timestamp.valueOf(start), Timestamp.valueOf(end)});
    }

    public void assignBookingToSlot(int slotId, int bookingId) throws SQLException {
        String sql = "UPDATE ScheduleSlot SET booking_id = ?, status = 'BOOKED' WHERE slot_id = ?";
        executeQuery(sql, new Object[]{bookingId, slotId});
    }

    public ScheduleSlot getSlotById(int slotId) throws SQLException {
        String sql = "SELECT * FROM ScheduleSlot WHERE slot_id = ?";
        ResultSet rs = executeSelectQuery(sql, new Object[]{slotId});
        if (rs.next()) {
            return new ScheduleSlot(
                    rs.getInt("slot_id"),
                    rs.getObject("booking_id") != null ? rs.getInt("booking_id") : null,
                    rs.getInt("staff_id"),
                    rs.getString("room_name"),
                    rs.getTimestamp("start_time"),
                    rs.getTimestamp("end_time"),
                    rs.getString("status")
            );
        }
        return null;
    }
}
