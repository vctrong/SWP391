/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import db.DBContext;
import model.Pet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class PetDAO {

    private DBContext db = new DBContext();

    // Lấy danh sách thú cưng của 1 user (owner)
    public List<Pet> getPetsByOwner(long ownerId) throws SQLException {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT pet_id, owner_id, name, species_id, breed_id, gender, birthdate, weight_kg, color, notes "
                + "FROM Pets WHERE owner_id = ?";
        ResultSet rs = db.executeSelectQuery(sql, new Object[]{ownerId});
        while (rs.next()) {
            Pet p = new Pet(
                    (int) rs.getLong("pet_id"),
                    (int) rs.getLong("owner_id"),
                    rs.getString("name"),
                    rs.getInt("species_id"),
                    rs.getInt("breed_id"),
                    rs.getString("gender"),
                    rs.getDate("birthdate"),
                    rs.getDouble("weight_kg"),
                    rs.getString("color"),
                    rs.getString("notes")
            );
            pets.add(p);
        }
        return pets;
    }

    // Thêm thú cưng mới
    public void addPet(Pet pet) throws SQLException {
        String sql = "INSERT INTO Pets(owner_id, name, species_id, breed_id, gender, birthdate, weight_kg, color, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        db.executeQuery(sql, new Object[]{
            pet.getOwnerId(), pet.getName(), pet.getSpeciesId(), pet.getBreedId(),
            pet.getGender(), pet.getBirthDate(), pet.getWeightKg(), pet.getColor(), pet.getNotes()
        });
    }
}
