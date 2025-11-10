package model;

import java.sql.Timestamp;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductVariant {

    private long variantId;
    private long productId;
    private String sku;
    private String attributeJson;
    private double price;
    private int stockQuantity;
    private String imageUrl;
    private boolean isActive;
    private Timestamp createdAt;
    private double discount;

    public ProductVariant() {
    }

    public ProductVariant(long variantId, long productId, String sku, String attributeJson,
            double price, int stockQuantity, String imageUrl, boolean isActive, Timestamp createdAt) {
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

    // getter / setter
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
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

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }
    
    public String getAttributeText() {
        if (attributeJson == null || attributeJson.trim().isEmpty()) return null;
        // naive conversion: remove braces and quotes
        String pretty = attributeJson.replaceAll("\\{\\s*","")
                                     .replaceAll("\\s*\\}","")
                                     .replaceAll("\"","")
                                     .trim();
        // replace commas without space
        pretty = pretty.replaceAll("\\s*,\\s*", ", ");
        return pretty;
    }

    // toString (optional)
    @Override
    public String toString() {
        return "ProductVariant{id=" + variantId + ", sku=" + sku + ", price=" + price + ", attr=" + attributeJson + "}";
    }
    
}