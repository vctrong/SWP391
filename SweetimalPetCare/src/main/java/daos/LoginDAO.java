/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class LoginDAO extends db.DBContext {

    private String hashMd5(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] mess = md.digest(raw.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : mess) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    public Users login(String username, String password) {
        try {
            String qr = "select user_id, username, full_name, email,\n"
                    + "phone, is_active, gender, avatar_url, role_id, birthday\n"
                    + "from users\n"
                    + "where username  = ? and password_hash  = ?";
            Object[] params = {username, hashMd5(password)};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return new Users(rs.getInt(1), rs.getString(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getInt(7),
                        rs.getString(8), rs.getInt(9), rs.getDate(10));
            }
        } catch (SQLException ex) {
            Logger.getLogger(LoginDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void main(String[] args) {
        LoginDAO l = new LoginDAO();

        System.out.println("Dya la pass: " + l.hashMd5("123456"));
        System.out.println("day la user: " + l.login("admin1", "123456"));
    }
}
