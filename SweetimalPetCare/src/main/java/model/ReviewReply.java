package model;

import java.util.Date;

/**
 * Staff/Admin/Vet reply for a customer review
 */
public class ReviewReply {
    private long replyId;
    private long reviewId;
    private long repliedByStaffId;
    private String replyContent;
    private Date createdAt;

    public long getReplyId() { return replyId; }
    public void setReplyId(long replyId) { this.replyId = replyId; }

    public long getReviewId() { return reviewId; }
    public void setReviewId(long reviewId) { this.reviewId = reviewId; }

    public long getRepliedByStaffId() { return repliedByStaffId; }
    public void setRepliedByStaffId(long repliedByStaffId) { this.repliedByStaffId = repliedByStaffId; }

    public String getReplyContent() { return replyContent; }
    public void setReplyContent(String replyContent) { this.replyContent = replyContent; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
