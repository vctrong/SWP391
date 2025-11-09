/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;
import java.util.Objects;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class CartItem {

    private long cartItemId;   // 0 means not set
    private long userId;       // NOT NULL in schema, safe as primitive
    private long variantId;    // NOT NULL in schema, safe as primitive
    private int quantity;      // default 0 (should be >0 in DB)
    private Date addedAt;

    public CartItem() {
        // defaults: ids = 0, quantity = 0, addedAt = null
    }

    public CartItem(long cartItemId, long userId, long variantId, int quantity, Date addedAt) {
        this.cartItemId = cartItemId;
        this.userId = userId;
        this.variantId = variantId;
        this.quantity = quantity;
        setAddedAt(addedAt);
    }

    // --- Getters (primitive) ---
    public long getCartItemId() {
        return cartItemId;
    }

    public long getUserId() {
        return userId;
    }

    public long getVariantId() {
        return variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public Date getAddedAt() {
        return addedAt == null ? null : new Date(addedAt.getTime());
    }

    // --- Setters (primitive) ---
    public void setCartItemId(long cartItemId) {
        this.cartItemId = cartItemId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public void setVariantId(long variantId) {
        this.variantId = variantId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = (addedAt == null) ? null : new Date(addedAt.getTime());
    }

    // --- Boxed overloads for compatibility (DAO/reflection may call these) ---
    public void setCartItemId(Long cartItemId) {
        if (cartItemId != null) {
            this.cartItemId = cartItemId.longValue();
        }
    }

    public void setUserId(Long userId) {
        if (userId != null) {
            this.userId = userId.longValue();
        }
    }

    public void setVariantId(Long variantId) {
        if (variantId != null) {
            this.variantId = variantId.longValue();
        }
    }

    public void setQuantity(Integer quantity) {
        if (quantity != null) {
            this.quantity = quantity.intValue();
        }
    }

    // --- Alternative setter names for student projects compatibility ---
    public void setCart_item_id(long id) {
        setCartItemId(id);
    }

    public void setCart_item_id(Long id) {
        if (id != null) {
            setCartItemId(id.longValue());
        }
    }

    public void setId(long id) {
        setCartItemId(id);
    }

    public void setId(Long id) {
        if (id != null) {
            setCartItemId(id.longValue());
        }
    }

    public void setCustomerId(long id) {
        setUserId(id);
    }

    public void setCustomer_id(Long id) {
        if (id != null) {
            setUserId(id.longValue());
        }
    }

    public void setVariant_id(long id) {
        setVariantId(id);
    }

    public void setQty(int q) {
        setQuantity(q);
    }

    public void setQty(Integer q) {
        if (q != null) {
            setQuantity(q.intValue());
        }
    }

    // --- equals / hashCode / toString ---
    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof CartItem)) {
            return false;
        }
        CartItem that = (CartItem) o;
        return cartItemId == that.cartItemId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(cartItemId);
    }

    @Override
    public String toString() {
        return "CartItem{"
                + "cartItemId=" + cartItemId
                + ", userId=" + userId
                + ", variantId=" + variantId
                + ", quantity=" + quantity
                + ", addedAt=" + (addedAt == null ? null : new Date(addedAt.getTime()))
                + '}';

    }
}
