/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ScheduleSlotDAO extends db.DBContext {

    public boolean isSlotBusy(long staffId, java.sql.Timestamp newStart, java.sql.Timestamp newEnd) {
        try {
            // Logic: Kiểm tra xem có bất kỳ slot nào của nhân viên này
            // mà thời gian giao nhau với khung giờ mới không.
            String sql = "SELECT COUNT(*) FROM ScheduleSlot "
                    + "WHERE staff_id = ? "
                    + "AND (start_time < ? AND end_time > ?)"; // Công thức Overlap chuẩn
            Object[] params = {staffId, newStart, newEnd};
            return this.executeQuery(sql, params) > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ScheduleSlotDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public int generateSlots(long staffId, Date startDate, Date endDate,
            int startHour, int endHour, int durationMin, boolean skipLunch, String roomName) {
        int count = 0;
        String sql = "INSERT INTO ScheduleSlot (staff_id, start_time, end_time, status, room_name) VALUES (?, ?, ?, 'OPEN', ?)";
        long currentTimeMillis = System.currentTimeMillis();
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(startDate);

            // Vòng lặp NGÀY
            while (!cal.getTime().after(endDate)) {

                java.util.Calendar timePointer = (java.util.Calendar) cal.clone();
                timePointer.set(java.util.Calendar.HOUR_OF_DAY, startHour);
                timePointer.set(java.util.Calendar.MINUTE, 0);
                timePointer.set(java.util.Calendar.SECOND, 0);

                // Vòng lặp GIỜ (SLOT)
                while (timePointer.get(java.util.Calendar.HOUR_OF_DAY) < endHour) {

                    // 1. Tính toán khung giờ dự kiến tạo
                    java.sql.Timestamp slotStart = new java.sql.Timestamp(timePointer.getTimeInMillis());

                    timePointer.add(java.util.Calendar.MINUTE, durationMin); // Tăng thời gian lên
                    java.sql.Timestamp slotEnd = new java.sql.Timestamp(timePointer.getTimeInMillis());
                    if (slotStart.getTime() < currentTimeMillis) {
                        continue;
                    }
                    // 2. Check nghỉ trưa
                    int currentHour = slotStart.toLocalDateTime().getHour();
                    if (skipLunch && (currentHour >= 12 && currentHour < 13)) {
                        continue;
                    }

                    // 3. CHECK TRÙNG LỊCH (MỚI THÊM)
                    // Nếu giờ này bác sĩ đã có lịch (dù là OPEN hay BOOKED) thì BỎ QUA, không tạo đè.
                    if (isSlotBusy(staffId, slotStart, slotEnd)) {
                        System.out.println("Bỏ qua slot: " + slotStart + " vì nhân viên bận.");
                        continue; // Nhảy qua vòng lặp kế tiếp
                    }

                    // 4. Nếu rảnh thì thêm vào batch để Insert
                    ps.setLong(1, staffId);
                    ps.setTimestamp(2, slotStart);
                    ps.setTimestamp(3, slotEnd);
                    ps.setString(4, "Phòng khám 1");

                    ps.addBatch();
                    count++;
                }

                cal.add(java.util.Calendar.DATE, 1); // Sang ngày hôm sau
            }

            if (count > 0) {
                ps.executeBatch(); // Chỉ execute nếu có slot hợp lệ
            }

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
        return count;
    }
}
