/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

// Lớp Service ánh xạ với bảng Services
public class Service {

    private int id;             // id dịch vụ
    private String name;         // tên dịch vụ
    private String description;  // mô tả dịch vụ
    private int durationMin;     // thời lượng (phút)
    private BigDecimal price;    // giá hiện tại

    public Service(int id, String name, String description, int durationMin, BigDecimal price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.durationMin = durationMin;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDurationMin() {
        return durationMin;
    }

    public void setDurationMin(int durationMin) {
        this.durationMin = durationMin;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

}
