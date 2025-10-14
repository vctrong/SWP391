/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.BrandDAO;
import daos.ProductCategoryDAO;
import daos.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Product;
import model.ProductCategory;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ShopServlet", urlPatterns = {"/shop"})
public class shopServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        BrandDAO brandDAO = new BrandDAO();
        ProductCategoryDAO categoryDAO = new ProductCategoryDAO();

        // 🧩 Lấy danh sách brand/category được chọn (nhiều checkbox)
        String[] brandIds = request.getParameterValues("brand");
        String[] categoryIds = request.getParameterValues("category");

        List<Integer> brandList = new ArrayList<>();
        List<Integer> categoryList = new ArrayList<>();

        if (brandIds != null) {
            for (String id : brandIds) {
                brandList.add(Integer.parseInt(id));
            }
        }

        if (categoryIds != null) {
            for (String id : categoryIds) {
                categoryList.add(Integer.parseInt(id));
            }
        }

        // 🧩 Lấy min/max price
        Double minPrice = null, maxPrice = null;
        String minStr = request.getParameter("minPrice");
        String maxStr = request.getParameter("maxPrice");

        try {
            if (minStr != null && !minStr.isEmpty()) minPrice = Double.parseDouble(minStr);
            if (maxStr != null && !maxStr.isEmpty()) maxPrice = Double.parseDouble(maxStr);
        } catch (NumberFormatException e) {
            // Bỏ qua nếu lỗi parse
        }

        // 🧩 Lấy tình trạng hàng
        String stock = null;
        String[] stockArr = request.getParameterValues("stock");
        if (stockArr != null && stockArr.length > 0) {
            stock = stockArr[0]; // chỉ lấy 1 giá trị (inStock hoặc outOfStock)
        }

        // 🧩 Lấy sản phẩm theo filter
List<Product> products = productDAO.getProductsWithFilter(categoryList, brandList, minPrice, maxPrice, stock);

// 🧩 Lấy danh sách brand + category (phản ánh filter hiện tại)
List<Brand> brands = brandDAO.getBrandsWithCountFiltered(categoryList, minPrice, maxPrice, stock);
List<ProductCategory> categories = categoryDAO.getCategoriesWithCountFiltered(brandList, minPrice, maxPrice, stock);


        // 🧩 Gửi dữ liệu sang JSP
        request.setAttribute("products", products);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
