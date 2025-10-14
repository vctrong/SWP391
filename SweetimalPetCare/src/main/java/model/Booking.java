package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

public class Booking {
    private int id;
    private int customerId;
    private int petId;
    private int serviceId;
    private Integer packageId;
    private LocalDate requestedDate;
    private LocalTime requestedStart;
    private String notes;
    private String currentStatus;
    private BigDecimal totalPrice;
    private LocalDateTime bookingTime;
    private LocalDateTime createdAt;

    public Booking() {}

    public Booking(int id, int customerId, int petId, int serviceId, Integer packageId,
            LocalDate requestedDate, LocalTime requestedStart, String notes, String currentStatus,
            BigDecimal totalPrice, LocalDateTime bookingTime, LocalDateTime createdAt) {
        this.id = id;
        this.customerId = customerId;
        this.petId = petId;
        this.serviceId = serviceId;
        this.packageId = packageId;
        this.requestedDate = requestedDate;
        this.requestedStart = requestedStart;
        this.notes = notes;
        this.currentStatus = currentStatus;
        this.totalPrice = totalPrice;
        this.bookingTime = bookingTime;
        this.createdAt = createdAt;
    }

    // getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getPetId() { return petId; }
    public void setPetId(int petId) { this.petId = petId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public Integer getPackageId() { return packageId; }
    public void setPackageId(Integer packageId) { this.packageId = packageId; }
    public LocalDate getRequestedDate() { return requestedDate; }
    public void setRequestedDate(LocalDate requestedDate) { this.requestedDate = requestedDate; }
    public LocalTime getRequestedStart() { return requestedStart; }
    public void setRequestedStart(LocalTime requestedStart) { this.requestedStart = requestedStart; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public String getCurrentStatus() { return currentStatus; }
    public void setCurrentStatus(String currentStatus) { this.currentStatus = currentStatus; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public LocalDateTime getBookingTime() { return bookingTime; }
    public void setBookingTime(LocalDateTime bookingTime) { this.bookingTime = bookingTime; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
