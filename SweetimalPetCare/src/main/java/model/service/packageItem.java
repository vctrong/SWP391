/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.service;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class packageItem {

    private long packageId;
    private long serviceId;
    private int quantity;

    public packageItem() {
    }

    public packageItem(long packageId, long serviceId, int quantity) {
        this.packageId = packageId;
        this.serviceId = serviceId;
        this.quantity = quantity;
    }

    public long getPackageId() {
        return packageId;
    }

    public void setPackageId(long packageId) {
        this.packageId = packageId;
    }

    public long getServiceId() {
        return serviceId;
    }

    public void setServiceId(long serviceId) {
        this.serviceId = serviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}
