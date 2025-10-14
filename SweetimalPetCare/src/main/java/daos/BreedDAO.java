/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.PetBreed;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class BreedDAO extends db.DBContext {

    // lấy tất cả breed theo species
    public List<PetBreed> getBreedsBySpecies(int speciesId) throws SQLException {
        List<PetBreed> list = new ArrayList<>();
        String sql = "SELECT breed_id, species_id, breed_name FROM PetBreed WHERE species_id=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, speciesId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new PetBreed(
                        rs.getInt("breed_id"),
                        rs.getInt("species_id"),
                        rs.getString("breed_name") // mapping đúng cột breed_name
                ));
            }
        }
        return list;
    }

    public int insertUserBreed(String breedName, int speciesId, long userId) throws SQLException {
        // Check if it already exists
        String checkSql = "SELECT breed_id FROM PetBreed WHERE species_id=? AND breed_name=?";
        try ( PreparedStatement ps = getConnection().prepareStatement(checkSql)) {
            ps.setInt(1, speciesId);
            ps.setString(2, breedName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("breed_id");
            }
        }
        // Insert new if not exists
        String sql = "INSERT INTO PetBreed (species_id, breed_name, description, user_submitted, submitted_by) VALUES (?, ?, ?, 1, ?)";
        try ( PreparedStatement ps = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, speciesId);
            ps.setString(2, breedName);
            ps.setString(3, "Người dùng tự nhập");
            ps.setLong(4, userId);
            ps.executeUpdate();
            ResultSet genKeys = ps.getGeneratedKeys();
            if (genKeys.next()) {
                return genKeys.getInt(1);
            }
        }
        throw new SQLException("Could not insert custom breed");
    }
}
