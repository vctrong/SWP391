/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class BookingHistoryDTO {

    private long bookingId;
    private String bookingCodeDisplay;    // Mã hiển thị (ví dụ: #BK1)
    private String serviceName;           // Tên dịch vụ hoặc gói
    private String serviceDescription;    // Mô tả (ví dụ: "Cho: Tên_Pet")
    private Date appointmentDate;
    private Time appointmentTime;
    private double price;
    private String statusDisplay;

    public BookingHistoryDTO() {
    }

    public BookingHistoryDTO(long bookingId, String bookingCodeDisplay, String serviceName, String serviceDescription, Date appointmentDate, Time appointmentTime, double price, String statusDisplay) {
        this.bookingId = bookingId;
        this.bookingCodeDisplay = bookingCodeDisplay;
        this.serviceName = serviceName;
        this.serviceDescription = serviceDescription;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.price = price;
        this.statusDisplay = statusDisplay;
    }

    public long getBookingId() {
        return bookingId;
    }

    public void setBookingId(long bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingCodeDisplay() {
        return bookingCodeDisplay;
    }

    public void setBookingCodeDisplay(String bookingCodeDisplay) {
        this.bookingCodeDisplay = bookingCodeDisplay;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceDescription() {
        return serviceDescription;
    }

    public void setServiceDescription(String serviceDescription) {
        this.serviceDescription = serviceDescription;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatusDisplay() {
        return statusDisplay;
    }

    public void setStatusDisplay(String statusDisplay) {
        this.statusDisplay = statusDisplay;
    }

}
