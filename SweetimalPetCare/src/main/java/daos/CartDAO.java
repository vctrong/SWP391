/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.ProductVariant;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class CartDAO extends db.DBContext {

    /**
     * Get cart items for a user. Each CartItem.variant will be populated
     * (basic fields needed: price, sku, image_url, stock_quantity).
     * Also populates CartItem.productName and imageUrl (product main image if exists).
     */
    public List<CartItem> getCartItemsByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT ci.cart_item_id, ci.variant_id, ci.quantity, ci.customer_id, ci.added_at, " +
                         "v.sku, v.price, v.stock_quantity, v.image_url AS variant_image, v.attribute_json, " +
                         "p.product_id, p.product_name, pi.image_url AS product_image " +
                         "FROM CartItem ci " +
                         "JOIN ProductVariant v ON ci.variant_id = v.variant_id " +
                         "JOIN Product p ON v.product_id = p.product_id " +
                         "LEFT JOIN (SELECT product_id, image_url FROM ProductImg WHERE is_main = 1) pi ON pi.product_id = p.product_id " +
                         "WHERE ci.customer_id = ?";

            ps = getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                CartItem it = new CartItem();
                it.setCartItemId(rs.getInt("cart_item_id"));
                it.setCustomerId(rs.getInt("customer_id"));
                it.setVariantId(rs.getInt("variant_id"));
                it.setQuantity(rs.getInt("quantity"));
                // added_at may be null depending on schema
                try {
                    java.sql.Timestamp ts = rs.getTimestamp("added_at");
                    if (ts != null) it.setAddedAt(new java.util.Date(ts.getTime()));
                } catch (Exception ignore) {}

                // product info
                it.setProductName(rs.getString("product_name"));

                // variant object
                ProductVariant v = new ProductVariant();
                v.setVariantId(rs.getLong("variant_id"));
                // product_id not present on ProductVariant model setter here, but if available you can set
                v.setSku(rs.getString("sku"));
                v.setPrice(rs.getDouble("price"));
                v.setStockQuantity(rs.getInt("stock_quantity"));

                // read attribute JSON (if DB column exists) and set into variant
                try {
                    String attrJson = rs.getString("attribute_json");
                    if (attrJson != null && !attrJson.isEmpty()) {
                        // assume ProductVariant has setAttributeJson(...)
                        v.setAttributeJson(attrJson);
                    }
                } catch (Exception ignore) {
                    // ignore if column not present or setter not available
                }

                String variantImage = rs.getString("variant_image");
                String productImage = rs.getString("product_image");
                if (productImage != null && !productImage.isEmpty()) {
                    it.setImageUrl(productImage);
                } else if (variantImage != null && !variantImage.isEmpty()) {
                    it.setImageUrl(variantImage);
                } else {
                    it.setImageUrl(null);
                }
                v.setImageUrl(it.getImageUrl());

                it.setVariant(v);

                list.add(it);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
        return list;
    }

    /**
     * Convenience: compute subtotal for a user's cart (sum unitPrice * qty).
     * Uses getCartItemsByUser implementation.
     */
    public double computeSubtotalByUser(int userId) {
        double subtotal = 0.0;
        List<CartItem> items = getCartItemsByUser(userId);
        for (CartItem it : items) {
            subtotal += it.getLineTotal();
        }
        return subtotal;
    }
    
    /**
     * Add variant to cart. If an entry for (userId, variantId) exists, increase quantity.
     */
    public void addToCart(int userId, int variantId, int qty) throws SQLException {
        // check existing
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String sqlCheck = "SELECT cart_item_id, quantity FROM CartItem WHERE customer_id = ? AND variant_id = ?";
            ps = getConnection().prepareStatement(sqlCheck);
            ps.setInt(1, userId);
            ps.setInt(2, variantId);
            rs = ps.executeQuery();
            if (rs.next()) {
                int cartItemId = rs.getInt("cart_item_id");
                int existingQty = rs.getInt("quantity");
                rs.close();
                ps.close();
                // update quantity
                String sqlUpdate = "UPDATE CartItem SET quantity = ? WHERE cart_item_id = ?";
                ps = getConnection().prepareStatement(sqlUpdate);
                ps.setInt(1, existingQty + qty);
                ps.setInt(2, cartItemId);
                ps.executeUpdate();
                ps.close();
            } else {
                rs.close();
                ps.close();
                // insert new
                String sqlInsert = "INSERT INTO CartItem(customer_id, variant_id, quantity, added_at) VALUES (?, ?, ?, ?)";
                ps = getConnection().prepareStatement(sqlInsert);
                ps.setInt(1, userId);
                ps.setInt(2, variantId);
                ps.setInt(3, qty);
                ps.setTimestamp(4, new java.sql.Timestamp(new java.util.Date().getTime()));
                ps.executeUpdate();
                ps.close();
            }
        } catch (SQLException ex) {
            // rethrow so servlet can show message
            throw ex;
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    }
    
    // Update quantity for a cart item (by cart_item_id)
    public boolean updateCartItemQuantity(int cartItemId, int newQty) {
        PreparedStatement ps = null;
        try {
            String sql = "UPDATE CartItem SET quantity = ? WHERE cart_item_id = ?";
            ps = getConnection().prepareStatement(sql);
            ps.setInt(1, newQty);
            ps.setInt(2, cartItemId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            return false;
        }
    }

    // Remove a cart item
    public boolean removeCartItem(int cartItemId) {
        PreparedStatement ps = null;
        try {
            String sql = "DELETE FROM CartItem WHERE cart_item_id = ?";
            ps = getConnection().prepareStatement(sql);
            ps.setInt(1, cartItemId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            return false;
        }
    }

}