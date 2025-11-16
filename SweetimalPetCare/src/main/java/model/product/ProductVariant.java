/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ProductVariant {

    private long variantId;
    private long productId;
    private String sku;
    private String attributeJson; // Vd: {"weight":"1kg", "flavor":"Beef"}
    private BigDecimal price;
    private int stockQuantity;
    private String imageUrl;
    private boolean isActive;
    private Date createdAt;

    public ProductVariant() {
    }

    public ProductVariant(long variantId, long productId, String sku, String attributeJson, BigDecimal price, int stockQuantity, String imageUrl, boolean isActive, Date createdAt) {
        this.variantId = variantId;
        this.productId = productId;
        this.sku = sku;
        this.attributeJson = attributeJson;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public long getVariantId() {
        return variantId;
    }

    public void setVariantId(long variantId) {
        this.variantId = variantId;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getAttributeJson() {
        return attributeJson;
    }

    public void setAttributeJson(String attributeJson) {
        this.attributeJson = attributeJson;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    

}
