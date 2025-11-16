package model;

import java.util.Date;


public class ProductImg {
    private Long imageId;
    private Long productId;
    private String imageUrl;
    private String caption;
    private Integer displayOrder; 
    private boolean isMain;
    private Date uploadedAt;

    public ProductImg() {}

    public ProductImg(Long imageId, Long productId, String imageUrl, String caption, Integer displayOrder, Date uploadedAt) {
        this.imageId = imageId;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.displayOrder = displayOrder;
        this.isMain = (displayOrder != null && displayOrder == 0);
        this.uploadedAt = uploadedAt;
    }

    // id
    public Long getImageId() {
        return imageId;
    }

    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }

    // product id
    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    // url
    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // caption / alt_text
    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    // display order
    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
        this.isMain = (displayOrder != null && displayOrder == 0);
    }

    // convenience: main image if displayOrder == 0
    public boolean isMain() {
        return isMain;
    }

    public void setMain(boolean main) {
        this.isMain = main;
        // If caller forces isMain, keep displayOrder in sync when possible
        if (main) {
            if (this.displayOrder == null || this.displayOrder != 0) this.displayOrder = 0;
        }
    }

    // uploaded at as java.util.Date (converted from SQL Timestamp in DAO)
    public Date getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Date uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}