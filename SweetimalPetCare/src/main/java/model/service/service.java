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

    private long serviceId;
    private long serviceCateId;
    private String serviceCode;
    private String serviceName;
    private String description;
    private int baseDurationMin;
    private BigDecimal currentPrice;
    private String status;
    private Date createdAt;
    private String serviceCateName;

    public service() {
    }

    public service(long serviceId, long serviceCateId, String serviceCode,
            String serviceName, String description, int baseDurationMin,
            BigDecimal currentPrice, String status, Date createdAt, String serviceCateName) {
        this.serviceId = serviceId;
        this.serviceCateId = serviceCateId;
        this.serviceCode = serviceCode;
        this.serviceName = serviceName;
        this.description = description;
        this.baseDurationMin = baseDurationMin;
        this.currentPrice = currentPrice;
        this.status = status;
        this.createdAt = createdAt;
        this.serviceCateName = serviceCateName;
    }

    public String getServiceCateName() {
        return serviceCateName;
    }

    public void setServiceCateName(String serviceCateName) {
        this.serviceCateName = serviceCateName;
    }

    public long getServiceId() {
        return serviceId;
    }

    public void setServiceId(long serviceId) {
        this.serviceId = serviceId;
    }

    public long getServiceCateId() {
        return serviceCateId;
    }

    public void setServiceCateId(long serviceCateId) {
        this.serviceCateId = serviceCateId;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
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

    public BigDecimal getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(BigDecimal currentPrice) {
        this.currentPrice = currentPrice;
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

}
