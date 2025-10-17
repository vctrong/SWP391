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
public class ProductImg {
    private long productImgId;
    private long productId;
    private String imageUrl;
    private String caption;
    private int sortOrder;
    private boolean isMain;
    private Timestamp uploadedAt;

    public ProductImg() {}

    public ProductImg(long productImgId, long productId, String imageUrl, String caption, int sortOrder, boolean isMain, Timestamp uploadedAt) {
        this.productImgId = productImgId;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.caption = caption;
        this.sortOrder = sortOrder;
        this.isMain = isMain;
        this.uploadedAt = uploadedAt;
    }

    public long getProductImgId() {
        return productImgId;
    }

    public void setProductImgId(long productImgId) {
        this.productImgId = productImgId;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public boolean isMain() {
        return isMain;
    }

    public void setMain(boolean main) {
        isMain = main;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}