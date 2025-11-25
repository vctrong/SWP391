/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.orderAdmin;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class order {

    private long orderId;
    private String orderCode;
    private long customerId;
    private Long shippingAddressId; // có thể null
    private String orderStatus;
    private String paymentMethodCode;
    private String paymentStatus;
    private double subtotalAmount;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount;
    private String notes;
    private Date createdAt;
    private Date updatedAt;

    // liên kết: danh sách order items (không phải cột DB nhưng hữu ích cho view)
    private List<orderItem> items;

    // MỚI: hiển thị địa chỉ đã format sẵn cho view
    private String shippingAddressLine;
    private String customerName;
    private String customerPhone;

    public order() {
    }

    public order(long orderId, String orderCode, long customerId, Long shippingAddressId, String orderStatus, String paymentMethodCode, String paymentStatus, double subtotalAmount, BigDecimal shippingFee, BigDecimal totalAmount, String notes, Date createdAt, Date updatedAt, List<orderItem> items, String shippingAddressLine, String customerName) {
        this.orderId = orderId;
        this.orderCode = orderCode;
        this.customerId = customerId;
        this.shippingAddressId = shippingAddressId;
        this.orderStatus = orderStatus;
        this.paymentMethodCode = paymentMethodCode;
        this.paymentStatus = paymentStatus;
        this.subtotalAmount = subtotalAmount;
        this.shippingFee = shippingFee;
        this.totalAmount = totalAmount;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.items = items;
        this.shippingAddressLine = shippingAddressLine;
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public Long getShippingAddressId() {
        return shippingAddressId;
    }

    public void setShippingAddressId(Long shippingAddressId) {
        this.shippingAddressId = shippingAddressId;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getPaymentMethodCode() {
        return paymentMethodCode;
    }

    public void setPaymentMethodCode(String paymentMethodCode) {
        this.paymentMethodCode = paymentMethodCode;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public double getSubtotalAmount() {
        return subtotalAmount;
    }

    public void setSubtotalAmount(double subtotalAmount) {
        this.subtotalAmount = subtotalAmount;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<orderItem> getItems() {
        return items;
    }

    public void setItems(List<orderItem> items) {
        this.items = items;
    }

    public String getShippingAddressLine() {
        return shippingAddressLine;
    }

    public void setShippingAddressLine(String shippingAddressLine) {
        this.shippingAddressLine = shippingAddressLine;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

}
