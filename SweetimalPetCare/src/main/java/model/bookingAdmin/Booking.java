/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.bookingAdmin;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class Booking {

    private long bookingID;
    private long customerID;
    private String fullName;
    private long petID;
    private String petName;
    private String item;
    private int duration;
    private String type;
    private Date bookTime;
    private Date reqDate;
    private Time reqStart;
    private String note;
    private String currentStatus;
    private BigDecimal price;
    private String paymentStatus;
    private Date createAt;
    private String phone;
    private boolean isVet;

    public Booking() {
    }

    public Booking(long bookingID, long customerID, String fullName, long petID,
            String petName, String item, String type, int duration, Date bookTime,
            Date reqDate, Time reqStart, String note, String currentStatus,
            BigDecimal price, String paymentStatus, Date createAt, String phone) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.fullName = fullName;
        this.petID = petID;
        this.petName = petName;
        this.item = item;
        this.duration = duration;
        this.type = type;
        this.bookTime = bookTime;
        this.reqDate = reqDate;
        this.reqStart = reqStart;
        this.note = note;
        this.currentStatus = currentStatus;
        this.price = price;
        this.paymentStatus = paymentStatus;
        this.createAt = createAt;
        this.phone = phone;

    }

    public boolean isVet() {
        return isVet;
    }

    public void setIsVet(boolean isVet) {
        this.isVet = isVet;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public long getBookingID() {
        return bookingID;
    }

    public void setBookingID(long bookingID) {
        this.bookingID = bookingID;
    }

    public long getCustomerID() {
        return customerID;
    }

    public void setCustomerID(long customerID) {
        this.customerID = customerID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public long getPetID() {
        return petID;
    }

    public void setPetID(long petID) {
        this.petID = petID;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

    public String getItem() {
        return item;
    }

    public void setItem(String item) {
        this.item = item;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getBookTime() {
        return bookTime;
    }

    public void setBookTime(Date bookTime) {
        this.bookTime = bookTime;
    }

    public Date getReqDate() {
        return reqDate;
    }

    public void setReqDate(Date reqDate) {
        this.reqDate = reqDate;
    }

    public Time getReqStart() {
        return reqStart;
    }

    public void setReqStart(Time reqStart) {
        this.reqStart = reqStart;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

}
