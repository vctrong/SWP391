/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.PetSpecies;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class SpeciesDAO extends db.DBContext {

// Lấy toàn bộ species từ bảng PetSpecies
    public List<PetSpecies> getAllSpecies() throws SQLException {
        List<PetSpecies> list = new ArrayList<>();
        String sql = "SELECT species_id, species_name FROM PetSpecies";
        ResultSet rs = executeSelectQuery(sql, null);
        while (rs.next()) {
            PetSpecies s = new PetSpecies(
                    rs.getInt("species_id"),
                    rs.getString("species_name")
            );
            list.add(s);
        }
        return list;
    }
}
