/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class Pet {

    private int id;
    private int ownerId;
    private String name;
    private int speciesId;
    private int BreedId;
    private String gender;
    private Date birthDate;
    private double weightKg;
    private String color;
    private String notes;

    public Pet() {
    }

    public Pet(int id, int ownerId, String name, int speciesId, int BreedId, String gender, Date birthDate, double weightKg, String color, String notes) {
        this.id = id;
        this.ownerId = ownerId;
        this.name = name;
        this.speciesId = speciesId;
        this.BreedId = BreedId;
        this.gender = gender;
        this.birthDate = birthDate;
        this.weightKg = weightKg;
        this.color = color;
        this.notes = notes;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSpeciesId() {
        return speciesId;
    }

    public void setSpeciesId(int speciesId) {
        this.speciesId = speciesId;
    }

    public int getBreedId() {
        return BreedId;
    }

    public void setBreedId(int BreedId) {
        this.BreedId = BreedId;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(double weightKg) {
        this.weightKg = weightKg;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

}
