/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import db.DBContext;
import model.Pet;
import java.sql.*;
import java.time.LocalDate;
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
            Date sqlDate = rs.getDate("birthdate");
            LocalDate birthDate = (sqlDate != null) ? sqlDate.toLocalDate() : null;

            Pet p = new Pet(
                    rs.getInt("pet_id"),
                    rs.getInt("owner_id"),
                    rs.getString("name"),
                    rs.getInt("species_id"),
                    rs.getInt("breed_id"),
                    rs.getString("gender"),
                    rs.getDate("birthdate") != null ? rs.getDate("birthdate").toLocalDate() : null,
                    rs.getBigDecimal("weight_kg") != null ? rs.getBigDecimal("weight_kg").doubleValue() : null,
                    rs.getString("color"),
                    rs.getString("notes")
            );
            pets.add(p);
        }

        return pets;
    }

    public Pet getPetByIdAndOwner(long petId, long ownerId) throws SQLException {
        String sql = "SELECT * FROM Pets WHERE pet_id=? AND owner_id=?";
        try ( PreparedStatement ps = db.getConnection().prepareStatement(sql)) {
            ps.setLong(1, petId);
            ps.setLong(2, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Pet(
                        rs.getInt("pet_id"),
                        rs.getInt("owner_id"),
                        rs.getString("name"),
                        rs.getInt("species_id"),
                        (Integer) rs.getObject("breed_id"),
                        rs.getString("gender"),
                        rs.getDate("birthdate") != null ? rs.getDate("birthdate").toLocalDate() : null,
                        rs.getBigDecimal("weight_kg") != null ? rs.getBigDecimal("weight_kg").doubleValue() : null,
                        rs.getString("color"),
                        rs.getString("notes")
                );
            }
        }
        return null;
    }

    // Thêm thú cưng mới
    public void addPet(Pet pet) {
        String sql = "INSERT INTO Pets(owner_id, name, species_id, breed_id, gender, birthdate, weight_kg, color, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try ( PreparedStatement ps = db.getConnection().prepareStatement(sql)) {
            ps.setLong(1, pet.getOwnerId());
            ps.setString(2, pet.getName());
            ps.setInt(3, pet.getSpeciesId());

            if (pet.getBreedId() == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, pet.getBreedId());
            }

            ps.setString(5, pet.getGender());

            if (pet.getBirthDate() != null) {
                ps.setDate(6, java.sql.Date.valueOf(pet.getBirthDate()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            if (pet.getWeightKg() != null) {
                ps.setDouble(7, pet.getWeightKg());
            } else {
                ps.setNull(7, Types.DOUBLE);
            }

            ps.setString(8, pet.getColor());
            ps.setString(9, pet.getNotes());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

// Cập nhật pet
    public void updatePet(Pet p) {
        String sql = "UPDATE Pets SET name=?, species_id=?, breed_id=?, gender=?, birthdate=?, weight_kg=?, color=?, notes=? WHERE pet_id=? AND owner_id=?";
        try ( PreparedStatement ps = db.getConnection().prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setInt(2, p.getSpeciesId());

            if (p.getBreedId() == null) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, p.getBreedId());
            }

            ps.setString(4, p.getGender());

            if (p.getBirthDate() != null) {
                ps.setDate(5, java.sql.Date.valueOf(p.getBirthDate()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            if (p.getWeightKg() != null) {
                ps.setDouble(6, p.getWeightKg());
            } else {
                ps.setNull(6, Types.DOUBLE);
            }

            ps.setString(7, p.getColor());
            ps.setString(8, p.getNotes());
            ps.setLong(9, p.getId());
            ps.setLong(10, p.getOwnerId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xóa pet
    public void deletePet(long petId, long ownerId) {
        String sql = "DELETE FROM Pets WHERE pet_id=? AND owner_id=?";
        try ( PreparedStatement ps = db.getConnection().prepareStatement(sql)) {
            ps.setLong(1, petId);
            ps.setLong(2, ownerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
