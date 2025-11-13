/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;


/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class Review {
    private Integer reviewId;     // PK
    private Integer serviceId;    // nullable
    private Integer productId;    // nullable
    private Integer staffId;      // nullable
    private Integer customerId;   // not null
    private Integer rating;       // 1..5
    private String comment;
    private Date createdAt;

    // optional display name (from Users.full_name) — không phải cột trong Reviews nhưng thuận tiện khi join
    private String userName;

    public Review() {
    }

    public Review(Integer reviewId, Integer serviceId, Integer productId, Integer staffId, Integer customerId, Integer rating, String comment, Date createdAt, String userName) {
        this.reviewId = reviewId;
        this.serviceId = serviceId;
        this.productId = productId;
        this.staffId = staffId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.userName = userName;
    }

    // Convenience constructor for creating a new product review
    public Review(Integer productId, Integer customerId, Integer rating, String comment) {
        this.productId = productId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
    }

    // getters / setters
    public Integer getReviewId() {
        return reviewId;
    }

    public void setReviewId(Integer reviewId) {
        this.reviewId = reviewId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // optional display name
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}