package model;

import java.time.LocalDateTime;

/**
 * Model representing a consultation request submitted from the home page form.
 */
public class ConsultationRequest {

    private Long requestId;
    private String customerName;
    private String email;
    private String phone;
    private Integer consultationTypeId; 
    private String consultationTypeName; 
    private String requestMessage;
    private Long userId; 
    private String statusCode;
    private LocalDateTime createdAt;

    public ConsultationRequest() {
    }

    public ConsultationRequest(Long requestId, String customerName, String email, String phone,
            Integer consultationTypeId, String requestMessage, Long userId, String statusCode, LocalDateTime createdAt) {
        this.requestId = requestId;
        this.customerName = customerName;
        this.email = email;
        this.phone = phone;
        this.consultationTypeId = consultationTypeId;
        this.requestMessage = requestMessage;
        this.userId = userId;
        this.statusCode = statusCode;
        this.createdAt = createdAt;
    }

    public Long getRequestId() {
        return requestId;
    }

    public void setRequestId(Long requestId) {
        this.requestId = requestId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getConsultationTypeId() {
        return consultationTypeId;
    }

    public void setConsultationTypeId(Integer consultationTypeId) {
        this.consultationTypeId = consultationTypeId;
    }

    public String getConsultationTypeName() {
        return consultationTypeName;
    }

    public void setConsultationTypeName(String consultationTypeName) {
        this.consultationTypeName = consultationTypeName;
    }

    public String getRequestMessage() {
        return requestMessage;
    }

    public void setRequestMessage(String requestMessage) {
        this.requestMessage = requestMessage;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Convenience formatted date string for JSP (dd/MM/yyyy HH:mm)
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
