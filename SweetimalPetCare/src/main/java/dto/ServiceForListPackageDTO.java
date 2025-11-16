/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import java.sql.Date;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ServiceForListPackageDTO {

    private long id;
    private long cateId;
    private String code;
    private String name;
    private String description;
    private int duration;
    private BigDecimal price;
    private String status;
    private Date create_at;

    public ServiceForListPackageDTO() {
    }

    public ServiceForListPackageDTO(long id, long cateId, String code, String name, String description, int duration, BigDecimal price, String status, Date create_at) {
        this.id = id;
        this.cateId = cateId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.duration = duration;
        this.price = price;
        this.status = status;
        this.create_at = create_at;
    }

    public ServiceForListPackageDTO(long id, long cateId, String code, String name, String description, int duration, BigDecimal price, String status) {
        this.id = id;
        this.cateId = cateId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.duration = duration;
        this.price = price;
        this.status = status;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getCateId() {
        return cateId;
    }

    public void setCateId(long cateId) {
        this.cateId = cateId;
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

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
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

    public Date getCreate_at() {
        return create_at;
    }

    public void setCreate_at(Date create_at) {
        this.create_at = create_at;
    }

}
