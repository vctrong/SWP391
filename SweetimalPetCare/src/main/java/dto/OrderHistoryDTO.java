/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Date;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class OrderHistoryDTO {

    private long orderId;
    private String orderCode;                 // Mã đơn (ví dụ: #DH001)
    private String primaryProductName;        // Tên sản phẩm chính
    private String primaryProductDescription; // Mô tả (lấy từ attribute_json)
    private Date purchaseDate;
    private double totalPrice;
    private String statusDisplay;

    public OrderHistoryDTO() {
    }

    public OrderHistoryDTO(long orderId, String orderCode, String primaryProductName, String primaryProductDescription, Date purchaseDate, double totalPrice, String statusDisplay) {
        this.orderId = orderId;
        this.orderCode = orderCode;
        this.primaryProductName = primaryProductName;
        this.primaryProductDescription = primaryProductDescription;
        this.purchaseDate = purchaseDate;
        this.totalPrice = totalPrice;
        this.statusDisplay = statusDisplay;
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

    public String getPrimaryProductName() {
        return primaryProductName;
    }

    public void setPrimaryProductName(String primaryProductName) {
        this.primaryProductName = primaryProductName;
    }

    public String getPrimaryProductDescription() {
        return primaryProductDescription;
    }

    public void setPrimaryProductDescription(String primaryProductDescription) {
        this.primaryProductDescription = primaryProductDescription;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getStatusDisplay() {
        return statusDisplay;
    }

    public void setStatusDisplay(String statusDisplay) {
        this.statusDisplay = statusDisplay;
    }

}
