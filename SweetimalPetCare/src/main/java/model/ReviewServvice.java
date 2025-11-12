package model;

import java.util.Date;

/**
 * Service ReviewServvice model
 */
public class ReviewServvice {
    private long reviewId;
    private long serviceId;
    private long customerId;
    private String customerName;
    private String avatarUrl;
    private int rating; // 1-5
    private String comment;
    private Date createdAt;

    public ReviewServvice() {}

    public ReviewServvice(long reviewId, long serviceId, long customerId, String customerName, String avatarUrl, int rating, String comment, Date createdAt) {
        this.reviewId = reviewId;
        this.serviceId = serviceId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.avatarUrl = avatarUrl;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public long getReviewId() { return reviewId; }
    public void setReviewId(long reviewId) { this.reviewId = reviewId; }

    public long getServiceId() { return serviceId; }
    public void setServiceId(long serviceId) { this.serviceId = serviceId; }

    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
