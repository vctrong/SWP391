package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class BookingSummary {
    private int id;
    private String customerName;
    private String petName;
    private String serviceName;
    private LocalDate requestedDate;
    private LocalTime requestedStart;
    private String currentStatus;
    private BigDecimal totalPrice;

    public BookingSummary() {}

    // getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public LocalDate getRequestedDate() { return requestedDate; }
    public void setRequestedDate(LocalDate requestedDate) { this.requestedDate = requestedDate; }
    public LocalTime getRequestedStart() { return requestedStart; }
    public void setRequestedStart(LocalTime requestedStart) { this.requestedStart = requestedStart; }
    public String getCurrentStatus() { return currentStatus; }
    public void setCurrentStatus(String currentStatus) { this.currentStatus = currentStatus; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
}
