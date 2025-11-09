/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class CartItemsDAO extends db.DBContext{

    private static final Logger LOG = Logger.getLogger(CartItemsDAO.class.getName());

    /**
     * Chèn mới 1 cart item. Trả về true nếu chèn thành công.
     * Nếu đã tồn tại (unique constraint user_id+variant_id) DB sẽ ném lỗi; caller có thể kiểm tra existsCartItem trước.
     */
    public boolean insertCartItem(long userId, long variantId, int quantity) throws SQLException {
        if (quantity <= 0) throw new IllegalArgumentException("quantity must be > 0");
        String insertSql = "INSERT INTO CartItems (user_id, variant_id, quantity, added_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = getConnection().prepareStatement(insertSql)) {
            ps.setLong(1, userId);
            ps.setLong(2, variantId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Cập nhật số lượng cho 1 cart item. Nếu quantity <= 0 thì xóa dòng đó.
     * Trả về true nếu update (hoặc delete) thành công.
     */
    public boolean updateCartItemQuantity(long userId, long variantId, int quantity) throws SQLException {
        if (quantity <= 0) {
            return removeCartItem(userId, variantId);
        }
        String sql = "UPDATE CartItems SET quantity = ?, added_at = CURRENT_TIMESTAMP WHERE user_id = ? AND variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, userId);
            ps.setLong(3, variantId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Kiểm tra xem user đã có cart item cho variant này chưa.
     */
    public boolean existsCartItem(long userId, long variantId) {
        String sql = "SELECT 1 FROM CartItems WHERE user_id = ? AND variant_id = ?";
        try {
            ResultSet rs = this.executeSelectQuery(sql, new Object[]{userId, variantId});
            return rs != null && rs.next();
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "Error checking existsCartItem user=" + userId + " variant=" + variantId, ex);
            return false;
        }
    }

    /**
     * Lấy số lượng (quantity) hiện có cho user + variant.
     * Trả về 0 nếu không tồn tại.
     */
    public int getCartItemQuantity(long userId, long variantId) {
        String sql = "SELECT quantity FROM CartItems WHERE user_id = ? AND variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");
                }
            }
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "Error fetching cart item quantity for user=" + userId + " variant=" + variantId, ex);
        }
        return 0;
    }

    /**
     * Lấy ra danh sách CartItem của user
     * Trả về danh sách rỗng nếu có lỗi.
     */
    public List<CartItem> getCartItemsByUser(long userId) {
        String sql = "SELECT cart_item_id, user_id, variant_id, quantity, added_at FROM CartItems WHERE user_id = ? ORDER BY added_at";
        List<CartItem> out = new ArrayList<>();
        try {
            ResultSet rs = this.executeSelectQuery(sql, new Object[]{userId});
            while (rs != null && rs.next()) {
                CartItem ci = new CartItem();
                ci.setCartItemId(rs.getLong("cart_item_id"));
                ci.setUserId(rs.getLong("user_id"));
                ci.setVariantId(rs.getLong("variant_id"));
                ci.setQuantity(rs.getInt("quantity"));

                // sử dụng trực tiếp ResultSet.getDate(...) và defensive copy về java.util.Date
                Date ts = rs.getDate("added_at"); // java.sql.Date is a subclass of java.util.Date
                if (ts != null) {
                    ci.setAddedAt(new Date(ts.getTime()));
                } else {
                    ci.setAddedAt(null);
                }

                out.add(ci);
            }
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "Error fetching cart items for user " + userId, ex);
        }
        return out;
    }

    /**
     * Xóa cart item
     */
    public boolean removeCartItem(long userId, long variantId) throws SQLException {
        String sql = "DELETE FROM CartItems WHERE user_id = ? AND variant_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setLong(2, variantId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa tất cả cart items của user (dùng sau checkout nếu muốn)
     */
    public boolean clearCartForUser(long userId) throws SQLException {
        String sql = "DELETE FROM CartItems WHERE user_id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
            return true;
        }
    }
}