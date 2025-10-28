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
import model.UserAddress;
/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class UserAddressDAO extends db.DBContext{
    public List<UserAddress> getAddressesByUser(int userId) {
        List<UserAddress> list = new ArrayList<>();
        try {
            String sql = "SELECT address_id, label, recipient_name, phone, address_line1, ward, district, city, province, is_default " +
                         "FROM UserAddress WHERE user_id = ? ORDER BY is_default DESC, address_id ASC";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserAddress a = new UserAddress();
                a.setAddressId(rs.getInt("address_id"));
                a.setLabel(rs.getString("label"));
                a.setRecipientName(rs.getString("recipient_name"));
                a.setPhone(rs.getString("phone"));
                a.setAddressLine(rs.getString("address_line1"));
                a.setWard(rs.getString("ward"));
                a.setDistrict(rs.getString("district"));
                a.setCity(rs.getString("city"));
                a.setProvince(rs.getString("province"));
                a.setIsDefault(rs.getInt("is_default"));
                list.add(a);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(UserAddressDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

}
