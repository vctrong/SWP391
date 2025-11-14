/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.service;

import dto.serviceDTO;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class servicePackage {

    private long id;
    private String code;
    private String name;
    private String description;
    private String status;
    private BigDecimal price;
    private Date createdAt;
    private ArrayList<serviceDTO> item;

    public servicePackage() {
    }

    public servicePackage(long packageId, String packageCode, String packageName, String description, String status, BigDecimal packagePrice, Date createdAt) {
        this.id = packageId;
        this.code = packageCode;
        this.name = packageName;
        this.description = description;
        this.status = status;
        this.price = packagePrice;
        this.createdAt = createdAt;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public ArrayList<serviceDTO> getItem() {
        return item;
    }

    public void setItem(ArrayList<serviceDTO> item) {
        this.item = item;
    }

}
