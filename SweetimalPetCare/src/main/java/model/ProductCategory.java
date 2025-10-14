/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class ProductCategory {

    private int productCategoryId;
    private String categoryName;
    private Integer parentId; // có thể null
    private String description;
    private int productCount;

    public ProductCategory() {
    }

    public ProductCategory(int productCategoryId, String categoryName, Integer parentId, String description) {
        this.productCategoryId = productCategoryId;
        this.categoryName = categoryName;
        this.parentId = parentId;
        this.description = description;
    }

    public int getProductCategoryId() {
        return productCategoryId;
    }

    public void setProductCategoryId(int productCategoryId) {
        this.productCategoryId = productCategoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getProductCount() {
        return productCount;
    }

    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
}
