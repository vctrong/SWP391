/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Brand;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class BrandDAO extends db.DBContext {

    // 🟢 Lấy tất cả thương hiệu
    public List<Brand> getAllBrands() {
        try {
            List<Brand> list = new ArrayList<>();
            String qr = "SELECT brand_id, brand_name, description FROM Brand";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setBrandName(rs.getString("brand_name"));
                b.setDescription(rs.getString("description"));
                list.add(b);
            }
            rs.close();
            ps.close();
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(BrandDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy thương hiệu kèm số lượng sản phẩm
    public List<Brand> getBrandsWithCount() {
        try {
            List<Brand> list = new ArrayList<>();
            String qr = "SELECT b.brand_id, b.brand_name, b.description, "
                    + "COUNT(DISTINCT p.product_id) AS product_count "
                    + "FROM Brand b "
                    + "LEFT JOIN Product p ON b.brand_id = p.brand_id "
                    + "GROUP BY b.brand_id, b.brand_name, b.description "
                    + "ORDER BY b.brand_name";

            PreparedStatement ps = getConnection().prepareStatement(qr);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setBrandName(rs.getString("brand_name"));
                b.setDescription(rs.getString("description"));
                b.setProductCount(rs.getInt("product_count"));
                list.add(b);
            }
            rs.close();
            ps.close();
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(BrandDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 🟢 Lấy chi tiết thương hiệu theo ID
    public Brand getBrandById(int id) {
        try {
            String qr = "SELECT brand_id, brand_name, description FROM Brand WHERE brand_id = ?";
            PreparedStatement ps = getConnection().prepareStatement(qr);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Brand b = new Brand();
                b.setBrandId(rs.getInt("brand_id"));
                b.setBrandName(rs.getString("brand_name"));
                b.setDescription(rs.getString("description"));
                rs.close();
                ps.close();
                return b;
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(BrandDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

 // 🟢 Lấy danh sách thương hiệu và đếm số sản phẩm còn lại sau khi lọc (chuẩn xác)
public List<Brand> getBrandsWithCountFiltered(List<Integer> categoryIds, Double minPrice, Double maxPrice, String stock) {
    List<Brand> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT b.brand_id, b.brand_name, b.description, ");
    sql.append("COUNT(DISTINCT filtered.product_id) AS product_count ");
    sql.append("FROM Brand b ");
    sql.append("LEFT JOIN ( ");
    sql.append("    SELECT DISTINCT p.product_id, p.brand_id ");
    sql.append("    FROM Product p ");
    sql.append("    JOIN ProductVariant v ON p.product_id = v.product_id ");
    sql.append("    WHERE p.is_active = 1 AND v.is_active = 1 ");

    if (categoryIds != null && !categoryIds.isEmpty()) {
        sql.append("AND p.product_category_id IN (");
        for (int i = 0; i < categoryIds.size(); i++) {
            sql.append("?");
            if (i < categoryIds.size() - 1) sql.append(",");
        }
        sql.append(") ");
    }

    if (minPrice != null) {
        sql.append("AND v.price >= ? ");
    }
    if (maxPrice != null) {
        sql.append("AND v.price <= ? ");
    }

    if (stock != null && !stock.isEmpty()) {
        if (stock.equals("inStock")) {
            sql.append("AND v.stock_quantity > 0 ");
        } else if (stock.equals("outOfStock")) {
            sql.append("AND v.stock_quantity = 0 ");
        }
    }

    sql.append(") AS filtered ON b.brand_id = filtered.brand_id ");
    sql.append("GROUP BY b.brand_id, b.brand_name, b.description ");
    sql.append("ORDER BY b.brand_name");

    try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
        int index = 1;
        if (categoryIds != null && !categoryIds.isEmpty()) {
            for (int id : categoryIds) ps.setInt(index++, id);
        }
        if (minPrice != null) ps.setDouble(index++, minPrice);
        if (maxPrice != null) ps.setDouble(index++, maxPrice);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Brand b = new Brand();
            b.setBrandId(rs.getInt("brand_id"));
            b.setBrandName(rs.getString("brand_name"));
            b.setDescription(rs.getString("description"));
            b.setProductCount(rs.getInt("product_count"));
            list.add(b);
        }
        rs.close();
        ps.close();
    } catch (SQLException ex) {
        Logger.getLogger(BrandDAO.class.getName()).log(Level.SEVERE, null, ex);
    }
    return list;
}

}
