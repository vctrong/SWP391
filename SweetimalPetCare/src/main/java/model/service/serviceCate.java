/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.service;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class serviceCate {

    private long serviceCategoryId;
    private String categoryName;
    private String description;

    public serviceCate() {
    }

    public serviceCate(long serviceCategoryId, String categoryName, String description) {
        this.serviceCategoryId = serviceCategoryId;
        this.categoryName = categoryName;
        this.description = description;
    }

    public long getServiceCategoryId() {
        return serviceCategoryId;
    }

    public void setServiceCategoryId(long serviceCategoryId) {
        this.serviceCategoryId = serviceCategoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}
