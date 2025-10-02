/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDate;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
public class Pet {

    private int id;
    private int ownerId;
    private String name;
    private int speciesId;
    private Integer BreedId;
    private String gender;
    private LocalDate birthDate;
    private Double weightKg;
    private String color;
    private String notes;

    public Pet() {
    }

    public Pet(int id, int ownerId, String name, int speciesId, Integer BreedId, String gender, LocalDate birthDate, Double weightKg, String color, String notes) {
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

    public Integer getBreedId() {
        return BreedId;
    }

    public void setBreedId(Integer BreedId) {
        this.BreedId = BreedId;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public Double getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(Double weightKg) {
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
