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
public class Product {

    private long productId;
    private String productCode;
    private String productName;
    private int productCategoryId;
    private Integer brandId;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;
    private String brandName;

    // Thêm variant chính để hiển thị (ví dụ variant đầu tiên)
    private ProductVariant mainVariant;

    public Product() {
    }

    public Product(long productId, String productCode, String productName, int productCategoryId,
            Integer brandId, String description, boolean isActive, Timestamp createdAt) {
        this.productId = productId;
        this.productCode = productCode;
        this.productName = productName;
        this.productCategoryId = productCategoryId;
        this.brandId = brandId;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // getter / setter
    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getProductCategoryId() {
        return productCategoryId;
    }

    public void setProductCategoryId(int productCategoryId) {
        this.productCategoryId = productCategoryId;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public ProductVariant getMainVariant() {
        return mainVariant;
    }

    public void setMainVariant(ProductVariant mainVariant) {
        this.mainVariant = mainVariant;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

}
