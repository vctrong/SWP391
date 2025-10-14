/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class Review {

    private int reviewId;
    private String targetTypeCode;
    private int targetId;
    private int customerId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // thêm để hiển thị
    private String userName;
    private String youtubeUrl;

    public Review() {
    }

    public Review(int reviewId, String targetTypeCode, int targetId, int customerId,
            int rating, String comment, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.targetTypeCode = targetTypeCode;
        this.targetId = targetId;
        this.customerId = customerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // getters & setters
    public int getReviewId() {
        return reviewId;
    }

    public int getTargetId() {
        return targetId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getYoutubeUrl() {
        return youtubeUrl;
    }

    public void setYoutubeUrl(String youtubeUrl) {
        this.youtubeUrl = youtubeUrl;
    }
}
