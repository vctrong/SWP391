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
public class BookingSummary {

    private long bookingID;
    private Date reqDate;
    private Time reqTime;
    private Date bookingTime;
    private String status;
    private String serviceName;
    private String petName;

    public BookingSummary() {
    }

    public BookingSummary(long bookingID, Date reqDate, Time reqTime, Date bookingTime, String status, String serviceName, String petName) {
        this.bookingID = bookingID;
        this.reqDate = reqDate;
        this.reqTime = reqTime;
        this.bookingTime = bookingTime;
        this.status = status;
        this.serviceName = serviceName;
        this.petName = petName;
    }

    public long getBookingID() {
        return bookingID;
    }

    public void setBookingID(long bookingID) {
        this.bookingID = bookingID;
    }

    public Date getReqDate() {
        return reqDate;
    }

    public void setReqDate(Date reqDate) {
        this.reqDate = reqDate;
    }

    public Time getReqTime() {
        return reqTime;
    }

    public void setReqTime(Time reqTime) {
        this.reqTime = reqTime;
    }

    public Date getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Date bookingTime) {
        this.bookingTime = bookingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

}
