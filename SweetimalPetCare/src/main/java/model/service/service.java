/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.service;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class service {

    private long id;
    private long serviceCateId;
    private String code;
    private String name;
    private String description;
    private int baseDurationMin;
    private BigDecimal price;
    private String status;
    private Date createdAt;
    private String serviceCateName;
    private String type;

    public service() {
    }

    public service(long serviceId, long serviceCateId, String serviceCode,
            String serviceName, String description, int baseDurationMin,
            BigDecimal currentPrice, String status, Date createdAt, String serviceCateName, String type) {
        this.id = serviceId;
        this.serviceCateId = serviceCateId;
        this.code = serviceCode;
        this.name = serviceName;
        this.description = description;
        this.baseDurationMin = baseDurationMin;
        this.price = currentPrice;
        this.status = status;
        this.createdAt = createdAt;
        this.serviceCateName = serviceCateName;
        this.type = type;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getServiceCateId() {
        return serviceCateId;
    }

    public void setServiceCateId(long serviceCateId) {
        this.serviceCateId = serviceCateId;
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

    public int getBaseDurationMin() {
        return baseDurationMin;
    }

    public void setBaseDurationMin(int baseDurationMin) {
        this.baseDurationMin = baseDurationMin;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getServiceCateName() {
        return serviceCateName;
    }

    public void setServiceCateName(String serviceCateName) {
        this.serviceCateName = serviceCateName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

}
