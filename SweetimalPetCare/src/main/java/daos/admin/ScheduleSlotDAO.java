/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ScheduleSlotDAO extends db.DBContext {

    public boolean isSlotBusy(long staffId, Timestamp newStart, Timestamp newEnd) {
        // FIX: Chuyển sang dùng PreparedStatement chuẩn để an toàn và tối ưu cho Postgres
        String sql = "SELECT 1 FROM ScheduleSlot "
                + "WHERE staff_id = ? "
                + "AND (start_time < ? AND end_time > ?) " // Logic overlap chuẩn
                + "LIMIT 1"; // Postgres dùng LIMIT 1 thay vì TOP 1 để check tồn tại nhanh hơn

        try ( Connection conn = this.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, staffId);
            ps.setTimestamp(2, newStart);
            ps.setTimestamp(3, newEnd);

            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có kết quả -> Bận
            }
        } catch (SQLException ex) {
            // FIX LỖI LOGGER
            Logger.getLogger(ScheduleSlotDAO.class.getName()).log(Level.SEVERE, "Lỗi isSlotBusy: " + ex.getMessage(), ex);
        }
        return false;
    }

    public int generateSlots(long staffId, Date startDate, Date endDate,
            int startHour, int endHour, int durationMin, boolean skipLunch, String roomName) {

        int count = 0;
        String sql = "INSERT INTO ScheduleSlot (staff_id, start_time, end_time, status, room_name) VALUES (?, ?, ?, 'OPEN', ?)";
        long currentTimeMillis = System.currentTimeMillis();

        // Giữ nguyên this.openNewConnection() theo yêu cầu
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.setTime(startDate);

            // Vòng lặp NGÀY
            while (!cal.getTime().after(endDate)) {

                java.util.Calendar timePointer = (java.util.Calendar) cal.clone();
                timePointer.set(java.util.Calendar.HOUR_OF_DAY, startHour);
                timePointer.set(java.util.Calendar.MINUTE, 0);
                timePointer.set(java.util.Calendar.SECOND, 0);
                timePointer.set(java.util.Calendar.MILLISECOND, 0); // Reset mili giây cho sạch

                // Vòng lặp GIỜ (SLOT)
                while (timePointer.get(java.util.Calendar.HOUR_OF_DAY) < endHour) {

                    // 1. Tính toán khung giờ dự kiến tạo
                    Timestamp slotStart = new Timestamp(timePointer.getTimeInMillis());

                    timePointer.add(java.util.Calendar.MINUTE, durationMin); // Tăng thời gian lên
                    Timestamp slotEnd = new Timestamp(timePointer.getTimeInMillis());

                    // Kiểm tra nếu slotEnd vượt quá giờ kết thúc làm việc thì bỏ qua (để tránh slot bị cắt lửng)
                    if (timePointer.get(java.util.Calendar.HOUR_OF_DAY) > endHour
                            || (timePointer.get(java.util.Calendar.HOUR_OF_DAY) == endHour && timePointer.get(java.util.Calendar.MINUTE) > 0)) {
                        break;
                    }

                    // Không tạo slot trong quá khứ
                    if (slotStart.getTime() < currentTimeMillis) {
                        continue;
                    }

                    // 2. Check nghỉ trưa
                    int currentHour = slotStart.toLocalDateTime().getHour();
                    if (skipLunch && (currentHour >= 12 && currentHour < 13)) {
                        continue;
                    }

                    // 3. CHECK TRÙNG LỊCH
                    if (isSlotBusy(staffId, slotStart, slotEnd)) {
                        // System.out.println("Bỏ qua slot: " + slotStart + " vì nhân viên bận.");
                        continue;
                    }

                    // 4. Thêm vào batch
                    ps.setLong(1, staffId);
                    ps.setTimestamp(2, slotStart);
                    ps.setTimestamp(3, slotEnd);

                    // FIX LỖI HARDCODE: Dùng biến roomName truyền vào thay vì "Phòng khám 1"
                    ps.setString(4, (roomName != null && !roomName.isEmpty()) ? roomName : "Phòng khám chung");

                    ps.addBatch();
                    count++;
                }

                cal.add(java.util.Calendar.DATE, 1); // Sang ngày hôm sau
            }

            if (count > 0) {
                ps.executeBatch(); // Thực thi hàng loạt
            }

        } catch (Exception e) {
            // FIX LOGGER cho đồng bộ
            Logger.getLogger(ScheduleSlotDAO.class.getName()).log(Level.SEVERE, "Lỗi generateSlots: " + e.getMessage(), e);
            return -1;
        }
        return count;
    }
}
