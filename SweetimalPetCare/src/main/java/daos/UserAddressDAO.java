/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.UserAddress;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class UserAddressDAO extends db.DBContext {

    public List<UserAddress> getAddressesByUser(int userId) {
        List<UserAddress> list = new ArrayList<>();
        try {
            // Query chuẩn, chạy tốt trên PostgreSQL
            // Postgres: Boolean TRUE > FALSE, nên ORDER BY ... DESC sẽ đưa địa chỉ mặc định lên đầu.
            String sql = "SELECT address_id, user_id, label, recipient_name, phone, address_line1, ward, district, city, is_default, created_at "
                    + "FROM UserAddress WHERE user_id = ? ORDER BY is_default DESC, address_id ASC";

            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserAddress a = new UserAddress();

                a.setAddressId(rs.getLong("address_id"));
                a.setUserId(rs.getLong("user_id"));

                a.setLabel(rs.getString("label"));
                a.setRecipientName(rs.getString("recipient_name"));
                a.setPhone(rs.getString("phone"));

                // map address_line1 -> model.addressLine
                a.setAddressLine(rs.getString("address_line1"));

                a.setWard(rs.getString("ward"));
                a.setDistrict(rs.getString("district"));
                a.setCity(rs.getString("city"));

                // Logic này an toàn cho cả SQL Server (BIT) và Postgres (BOOLEAN)
                boolean isDef = false;
                try {
                    Object isDefObj = rs.getObject("is_default");
                    if (isDefObj != null) {
                        if (isDefObj instanceof Number) {
                            isDef = ((Number) isDefObj).intValue() != 0;
                        } else {
                            // Postgres JDBC trả về Boolean object, toString() sẽ ra "true"/"false"
                            String s = isDefObj.toString();
                            isDef = "1".equals(s) || "true".equalsIgnoreCase(s);
                        }
                    }
                } catch (SQLException ignore) {
                }
                a.setIsDefault(isDef);

                // created_at -> java.util.Date (nếu cột tồn tại)
                try {
                    Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        a.setCreatedAt(new Date(ts.getTime()));
                    }
                } catch (SQLException ignore) {
                }

                list.add(a);
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserAddressDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}
