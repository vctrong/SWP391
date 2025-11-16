/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import daos.LoginDAO;
import dto.StaffDTO;
import dto.UserDTO;
import dto.VetDTO;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserDAO extends db.DBContext {

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
            Logger.getLogger(daos.UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    private UserDTO mapRowToDTO(ResultSet rs, int roleId) throws SQLException {
        // 1. Lấy thông tin cơ bản
        long id = rs.getLong("user_id");
        String username = rs.getString("username");
        String email = rs.getString("email");
        String phone = rs.getString("phone");
        String fullName = rs.getString("full_name");
        int gender = rs.getInt("gender");
        Date birthday = rs.getDate("birthday");
        boolean isActive = rs.getBoolean("is_active");
        String avatar = rs.getString("avatar_url");
        String roleName = rs.getString("role_name");

        // 2. Quyết định tạo Object nào dựa trên Role ID
        switch (roleId) {
            case 3: {
                // --- TRƯỜNG HỢP VET (BÁC SĨ) ---
                String pos = rs.getString("position_title");
                Date hire = rs.getDate("hire_date");
                String spec = rs.getString("specialty");
                String license = rs.getString("license_number");
                double rating = rs.getDouble("rating_average");

                return new VetDTO(id, username, email, phone, fullName, gender, birthday,
                        isActive, avatar, roleId, roleName, pos, hire, spec, license, rating);
            }
            case 2: {
                // --- TRƯỜNG HỢP STAFF ---
                String pos = rs.getString("position_title");
                Date hire = rs.getDate("hire_date");

                return new StaffDTO(id, username, email, phone, fullName, gender, birthday,
                        isActive, avatar, roleId, roleName, pos, hire);
            }
            default:
                // --- TRƯỜNG HỢP CUSTOMER ---
                return new UserDTO(id, username, email, phone, fullName, gender, birthday,
                        isActive, avatar, roleId, roleName);
        }
    }

    public List<UserDTO> getAllUsersByRole(int roleId) {
        List<UserDTO> list = new ArrayList<>();
        // Join bảng Roles để lấy tên Role
        String sql = "SELECT u.*, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.role_id = ?";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Gọi hàm mapper helper bên dưới để chuyển row thành object tương ứng
                    list.add(mapRowToDTO(rs, roleId));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addUser(UserDTO user, String passRaw) {
        String sql = "INSERT INTO Users ("
                + "username, password_hash, email, phone, full_name, "
                + "gender, role_id, is_active, avatar_url, "
                + "position_title, hire_date, " // Trường của Staff
                + "specialty, license_number, is_veterinarian" // Trường của Vet
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            // --- SET CÁC TRƯỜNG CHUNG (UserDTO) ---
            ps.setString(1, user.getUsername());
            ps.setString(2, hashMd5(passRaw)); // Mặc định pass, sau này hash sau
            ps.setString(3, user.getEmail());
            ps.setString(4, (user.getPhone() == null || user.getPhone().isEmpty()) ? null : user.getPhone());
            ps.setString(5, user.getFullName());
            ps.setInt(6, user.getGender());
            ps.setInt(7, user.getRoleId());
            ps.setBoolean(8, user.isIsActive());
            ps.setString(9, (user.getAvatarUrl() == null || user.getAvatarUrl().isEmpty()) ? null : user.getAvatarUrl());

            // --- XỬ LÝ STAFF FIELDS (Nếu user là StaffDTO hoặc VetDTO) ---
            if (user instanceof StaffDTO) {
                StaffDTO staff = (StaffDTO) user;
                ps.setString(10, staff.getPositionTitle());
                ps.setDate(11, staff.getHireDate());
            } else {
                // Nếu là Customer -> Set NULL
                ps.setNull(10, Types.NVARCHAR);
                ps.setNull(11, Types.DATE);
            }

            // --- XỬ LÝ VET FIELDS (Nếu user là VetDTO) ---
            if (user instanceof VetDTO) {
                VetDTO vet = (VetDTO) user;
                ps.setString(12, vet.getSpecialty());
                ps.setString(13, vet.getLicenseNumber());
                ps.setBoolean(14, true); // is_veterinarian = 1
            } else {
                ps.setNull(12, Types.NVARCHAR);
                ps.setNull(13, Types.NVARCHAR);
                ps.setBoolean(14, false);
            }

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUser(UserDTO user) {
        String sql = "UPDATE Users SET "
                + "full_name=?, email=?, phone=?, gender=?, is_active=?, role_id=?, "
                + "position_title=?, specialty=?, license_number=? " // Chỉ update các trường chính
                + "WHERE user_id=?";

        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getGender());
            ps.setBoolean(5, user.isIsActive());
            ps.setInt(6, user.getRoleId());

            // LOGIC QUAN TRỌNG: DỌN DẸP DỮ LIỆU KHI ĐỔI ROLE
            // Nếu role là Customer (1), ép buộc set NULL các trường chuyên môn
            if (user.getRoleId() == 1) {
                ps.setNull(7, Types.NVARCHAR);
                ps.setNull(8, Types.NVARCHAR);
                ps.setNull(9, Types.NVARCHAR);
            } else {
                // Nếu là Staff/Vet thì lấy dữ liệu từ object (nếu có)
                if (user instanceof StaffDTO) {
                    ps.setString(7, ((StaffDTO) user).getPositionTitle());
                } else {
                    ps.setNull(7, Types.NVARCHAR);
                }

                if (user instanceof VetDTO) {
                    ps.setString(8, ((VetDTO) user).getSpecialty());
                    ps.setString(9, ((VetDTO) user).getLicenseNumber());
                } else {
                    ps.setNull(8, Types.NVARCHAR);
                    ps.setNull(9, Types.NVARCHAR);
                }
            }

            ps.setLong(10, user.getUserId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleUserStatus(long userId, boolean newStatus) {
        String sql = "UPDATE Users SET is_active = ? WHERE user_id = ?";
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, newStatus);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}
