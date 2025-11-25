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
public class OrderItem {

    private long orderItemId;
    private long orderId;
    private long variantId;
    private double unitPrice;
    private int quantity;
    private double lineTotal;

    // Associated variant for display / price lookup
    private ProductVariant variant;

    // Convenience fields for JSP rendering
    private String productName;
    private String imageUrl;
    // JSON-like attribute string from ProductVariant (eg {"weight":"1kg","color":"Red"})
    private String attributeJson;

    public OrderItem() {
    }

    public OrderItem(long orderItemId, long orderId, long variantId, double unitPrice, int quantity, double lineTotal, ProductVariant variant, String productName, String imageUrl) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.variantId = variantId;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.lineTotal = lineTotal;
        this.variant = variant;
        this.productName = productName;
        this.imageUrl = imageUrl;
    }

    // Getters / setters
    public long getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(long orderItemId) {
        this.orderItemId = orderItemId;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public long getVariantId() {
        return variantId;
    }

    public void setVariantId(long variantId) {
        this.variantId = variantId;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    /**
     * Return image url: explicit imageUrl first, else variant image
     */
    public String getImageUrl() {
        if (imageUrl != null && !imageUrl.isEmpty()) {
            return imageUrl;
        }
        if (variant != null && variant.getImageUrl() != null && !variant.getImageUrl().isEmpty()) {
            return variant.getImageUrl();
        }
        return null;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getAttributeJson() {
        return attributeJson;
    }

    public void setAttributeJson(String attributeJson) {
        this.attributeJson = attributeJson;
    }

    public double getLineTotal() {
        // nếu lineTotal chưa được gán, tính tạm từ unitPrice * quantity
        if (lineTotal == 0) {
            return unitPrice * quantity;
        }
        return lineTotal;
    }

    public void setLineTotal(double lineTotal) {
        this.lineTotal = lineTotal;
    }

//    @Override
//    public String toString() {
//        return "OrderItem{"
//                + "orderItemId=" + orderItemId
//                + ", orderId=" + orderId
//                + ", variantId=" + variantId
//                + ", unitPrice=" + unitPrice
//                + ", quantity=" + quantity              
//                + '}';
//    }
}
