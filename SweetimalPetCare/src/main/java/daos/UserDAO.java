/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserDAO extends db.DBContext {

    /**
     * Return true if the user has any Booking rows referencing them. This is
     * used to prevent hard delete when related booking data exists.
     */
    public boolean hasBookings(long userId) throws SQLException {
        // Query chuẩn, chạy tốt trên Postgres
        String sql = "SELECT COUNT(*) AS c FROM Booking WHERE customer_id = ?";
        try ( java.sql.PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            try ( java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("c") > 0;
                }
            }
        }
        return false;
    }

    public void updateUserStatus(long userId, boolean isActive) throws SQLException {
        // Query chuẩn. Postgres hỗ trợ setBoolean cho cột BOOLEAN rất tốt.
        String sql = "UPDATE Users SET is_active=? WHERE user_id=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }

    public void deleteUser(long userId) throws SQLException {
        // Query chuẩn
        String sql = "DELETE FROM Users WHERE user_id=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }
    }

    public Users findByEmail(String email) {
        try {
            // Query chuẩn
            String sql = "select user_id, username, full_name, email, phone, is_active, gender, avatar_url, role_id, birthday, created_at, 0 as nop from users where email = ?";
            ResultSet rs = this.executeSelectQuery(sql, new Object[]{email});
            if (rs.next()) {
                Users u = new Users();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));

                // ĐÃ SỬA: Postgres không cho phép getInt trên cột Boolean.
                // Phải dùng getBoolean rồi chuyển về int (1: active, 0: inactive)
                u.setActive(rs.getBoolean("is_active") ? 1 : 0);

                u.setGender(rs.getInt("gender"));
                u.setUrlImg(rs.getString("avatar_url"));
                u.setRole(rs.getInt("role_id"));
                u.setBirthday(rs.getDate("birthday"));
                u.setCreate(rs.getDate("created_at"));
                u.setNop(rs.getInt("nop"));
                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String rawNewPassword) {
        try {
            String hash = hashMd5(rawNewPassword);
            // Query chuẩn
            String sql = "update users set password_hash = ? where email = ?";
            int n = this.executeQuery(sql, new Object[]{hash, email});
            return n > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static String hashMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
}
