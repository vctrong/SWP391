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
            String base = "select u.user_id, u.username, u.full_name, u.email,\n"
                    + "phone, is_active, u.gender, avatar_url, role_id, birthday, u.created_at, COUNT(p.pet_id) as soluong\n"
                    + "from users u\n"
                    + "left join pets p on p.owner_id = u.user_id\n"
                    + "where username = ? and password_hash = ?\n"
                    + "group by u.user_id, u.full_name, u.username, u.email, u.phone, u.is_active, u.birthday, u.gender,\n"
                    + "u.is_active, u.avatar_url, u.role_id, u.created_at";
            // Authenticate only with MD5 hash
            ResultSet rs = this.executeSelectQuery(base, new Object[]{username, hashMd5(password)});
            if (rs.next()) {
                return new Users(rs.getInt(1), rs.getString(2), rs.getString(3),
                        rs.getString(4), rs.getString(5), rs.getInt(6), rs.getInt(7),
                        rs.getString(8), rs.getInt(9), rs.getDate(10), rs.getDate(11), rs.getInt(12));
            }
        } catch (SQLException ex) {
            Logger.getLogger(LoginDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void main(String[] args) {
        LoginDAO l = new LoginDAO();

        System.out.println("MD5 of password 123456: " + l.hashMd5("123456"));
        System.out.println("Login with admin1: " + l.login("admin1", "123456"));
    }
}
