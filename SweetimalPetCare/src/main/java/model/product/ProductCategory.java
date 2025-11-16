/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ProductCategory {

    private Long productCategoryId;
    private String categoryName;
    private Integer parentId;

    public ProductCategory() {
    }

    public ProductCategory(Long productCategoryId, String categoryName, Integer parentId) {
        this.productCategoryId = productCategoryId;
        this.categoryName = categoryName;
        this.parentId = parentId;
    }

    public Long getProductCategoryId() {
        return productCategoryId;
    }

    public void setProductCategoryId(Long productCategoryId) {
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

}
