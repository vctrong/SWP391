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
public class CartItem {

    private int cartItemId;
    private int customerId;
    private int variantId;
    private int quantity;
    private Date addedAt;

    private ProductVariant variant; // để join hiển thị chi tiết

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
}
