/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.scheduleSlotAdmin;

import java.sql.Timestamp;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ScheduleSlot {

    private long slotId;
    private long staffId;
    private String staffName; // Field phụ để hiển thị tên
    private String roomName;
    private Timestamp startTime;
    private Timestamp endTime;
    private String status;

    public ScheduleSlot() {
    }

    public ScheduleSlot(long slotId, long staffId, String staffName, String roomName, Timestamp startTime, Timestamp endTime, String status) {
        this.slotId = slotId;
        this.staffId = staffId;
        this.staffName = staffName;
        this.roomName = roomName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    public long getSlotId() {
        return slotId;
    }

    public void setSlotId(long slotId) {
        this.slotId = slotId;
    }

    public long getStaffId() {
        return staffId;
    }

    public void setStaffId(long staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
