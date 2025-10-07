/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserDAO extends db.DBContext {

    public void updateUserStatus(long userId, boolean isActive) throws SQLException {
        String sql = "UPDATE Users SET is_active=? WHERE user_id=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }

    public void deleteUser(long userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }
    }
}
