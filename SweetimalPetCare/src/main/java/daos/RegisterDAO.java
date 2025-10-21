package daos;

import db.DBContext;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class RegisterDAO extends DBContext{

    // Hàm mã hóa MD5 (giữ tương đồng với LoginDAO)
    private String hashMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi mã hóa MD5", e);
        }
    }

    // Kiểm tra username đã tồn tại hay chưa
    public boolean isUsernameExist(String username) throws Exception {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try ( Connection conn = new DBContext().getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Tạo tài khoản mới: trả về true nếu thành công
    // Lưu ý: dùng cột password_hash để nhất quán với LoginDAO
    public boolean createUser(String username, String rawPassword, String email,
                              String phone, String fullname, String gender, String birthday) throws Exception {
        String hashed = hashMd5(rawPassword);

        String insertSql = "INSERT INTO users (username, password_hash, email, phone, full_name, gender, birthday) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = new DBContext().getConnection();  PreparedStatement ps = conn.prepareStatement(insertSql)) {

            ps.setString(1, username);
            ps.setString(2, hashed);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, fullname);
            // Nếu DB gender là int (0/1), hãy truyền parseInt(gender)
            ps.setString(6, gender);
            ps.setString(7, birthday);
           

            int row = ps.executeUpdate();
            return row > 0;
        }
    }
}
