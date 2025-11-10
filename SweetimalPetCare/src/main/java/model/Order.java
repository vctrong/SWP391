/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class Order {
    private long orderId;
    private String orderCode;
    private long customerId;
    private Long shippingAddressId; // có thể null
    private String orderStatus;
    private String paymentMethodCode;
    private String paymentStatus;
    private double subtotalAmount;
    private double shippingFee;
    private double totalAmount;
    private String notes;
    private Date createdAt;
    private Date updatedAt;

    // liên kết: danh sách order items (không phải cột DB nhưng hữu ích cho view)
    private List<OrderItem> items;

    // MỚI: hiển thị địa chỉ đã format sẵn cho view
    private String shippingAddressLine;
    private String customerName;

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
    public double getShippingFee() {
        return shippingFee;
    }
    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }
    public double getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(double totalAmount) {
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
    public List<OrderItem> getItems() {
        return items;
    }
    public void setItems(List<OrderItem> items) {
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
