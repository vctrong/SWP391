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
public class servicePackage {

    private long packageId;
    private String packageCode;
    private String packageName;
    private String description;
    private String status;
    private BigDecimal packagePrice;
    private Date createdAt;

    public servicePackage() {
    }

    public servicePackage(long packageId, String packageCode, String packageName, String description, String status, BigDecimal packagePrice, Date createdAt) {
        this.packageId = packageId;
        this.packageCode = packageCode;
        this.packageName = packageName;
        this.description = description;
        this.status = status;
        this.packagePrice = packagePrice;
        this.createdAt = createdAt;
    }

    public long getPackageId() {
        return packageId;
    }

    public void setPackageId(long packageId) {
        this.packageId = packageId;
    }

    public String getPackageCode() {
        return packageCode;
    }

    public void setPackageCode(String packageCode) {
        this.packageCode = packageCode;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
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

    public BigDecimal getPackagePrice() {
        return packagePrice;
    }

    public void setPackagePrice(BigDecimal packagePrice) {
        this.packagePrice = packagePrice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

}
