/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.product;

import java.util.List;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ProductUpdatePayload {

    private Product product;
    private List<ProductVariant> variants;

    public ProductUpdatePayload() {
    }

    public ProductUpdatePayload(Product product, List<ProductVariant> variants) {
        this.product = product;
        this.variants = variants;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariant> variants) {
        this.variants = variants;
    }

}
