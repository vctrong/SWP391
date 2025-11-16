/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class PasswordUtils {

    public static String hashPassword(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] mess = md.digest(raw.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : mess) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            // Sử dụng Logger.getLogger thay vì UserDAO.class.getName()
            Logger.getLogger(PasswordUtils.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    /**
     * Kiểm tra xem mật khẩu gốc có khớp với mật khẩu đã hash hay không.
     *
     * @param plainPassword Mật khẩu người dùng nhập (ví dụ: "123456")
     * @param hashedPassword Mật khẩu đã hash trong CSDL (ví dụ:
     * "e10adc3949ba59abbe56e057f20f883e")
     * @return true nếu khớp, false nếu không
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        // 1. Hash cái mật khẩu người dùng vừa nhập
        String hashOfPlainPassword = hashPassword(plainPassword);

        // 2. So sánh nó với cái hash có trong CSDL
        return hashOfPlainPassword.equals(hashedPassword);
    }
}
