package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

public class BookingSummary {

    private int id;
    private String customerName;
    private String petName;
    private String serviceName;
    private Date requestedDate;
    private Time requestedStart;
    private String currentStatus;
    private BigDecimal totalPrice;

    public BookingSummary() {
    }

    public BookingSummary(int id, String customerName, String petName, String serviceName, Date requestedDate, Time requestedStart, String currentStatus) {
        this.id = id;
        this.customerName = customerName;
        this.petName = petName;
        this.serviceName = serviceName;
        this.requestedDate = requestedDate;
        this.requestedStart = requestedStart;
        this.currentStatus = currentStatus;
    }

    // getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Date getRequestedDate() {
        return requestedDate;
    }

    public void setRequestedDate(Date requestedDate) {
        this.requestedDate = requestedDate;
    }

    public Time getRequestedStart() {
        return requestedStart;
    }

    public void setRequestedStart(Time requestedStart) {
        this.requestedStart = requestedStart;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}
