package model;

import java.util.Date;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class CartItem {

    private int cartItemId;
    private int customerId;
    private int variantId;
    private int quantity;
    private Date addedAt;

    private ProductVariant variant; // để join hiển thị chi tiết

    // Convenience fields for JSP rendering (populated by DAO)
    private String productName;
    private String imageUrl;

    public CartItem() {
        // no-arg
    }

    public CartItem(int cartItemId, int customerId, int variantId, int quantity, Date addedAt) {
        this.cartItemId = cartItemId;
        this.customerId = customerId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.addedAt = addedAt;
    }

    // Getters & Setters
    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
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

    public String getImageUrl() {
        // prefer explicit imageUrl, else variant image
        if (imageUrl != null && !imageUrl.isEmpty()) return imageUrl;
        if (variant != null && variant.getImageUrl() != null && !variant.getImageUrl().isEmpty())
            return variant.getImageUrl();
        return null;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // Convenience helpers

    /**
     * Trả giá đơn vị của variant (nếu variant null thì trả 0)
     */
    public double getUnitPrice() {
        return (variant != null) ? variant.getPrice() : 0.0;
    }

    /**
     * Tổng tiền của dòng: unitPrice * quantity
     */
    public double getLineTotal() {
        return getUnitPrice() * quantity;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "cartItemId=" + cartItemId +
                ", customerId=" + customerId +
                ", variantId=" + variantId +
                ", quantity=" + quantity +
                ", addedAt=" + addedAt +
                '}';
    }
}