package controller;

import daos.BrandDAO;
import daos.ProductCategoryDAO;
import daos.ProductDAO;
import daos.ProductVariantDAO;
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
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name = "ShopServlet", urlPatterns = {"/shop"})
public class shopServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        ProductVariantDAO prvant = new ProductVariantDAO();
        BrandDAO brandDAO = new BrandDAO();
        ProductCategoryDAO categoryDAO = new ProductCategoryDAO();

        // --- NEW: lấy giá tối đa trong DB và đưa vào request ---
        Integer maxPriceInDb = prvant.getMaxPrice(); // implement method in DAO (see below)
        request.setAttribute("maxPriceInDb", maxPriceInDb);
        // -------------------------------------------------------

        // Lấy danh sách brand/category được chọn (nhiều checkbox)
        String[] brandIds = request.getParameterValues("brand");
        String[] categoryIds = request.getParameterValues("category");

        List<Integer> brandList = new ArrayList<>();
        List<Integer> categoryList = new ArrayList<>();

        if (brandIds != null) {
            for (String id : brandIds) {
                try { brandList.add(Integer.parseInt(id)); } catch (NumberFormatException ex) {}
            }
        }
        if (categoryIds != null) {
            for (String id : categoryIds) {
                try { categoryList.add(Integer.parseInt(id)); } catch (NumberFormatException ex) {}
            }
        }

        // Lấy min/max price
        Double minPrice = null, maxPrice = null;
        String minStr = request.getParameter("minPrice");
        String maxStr = request.getParameter("maxPrice");
        try {
            if (minStr != null && !minStr.isEmpty()) minPrice = Double.parseDouble(minStr);
            if (maxStr != null && !maxStr.isEmpty()) maxPrice = Double.parseDouble(maxStr);
        } catch (NumberFormatException ex) {
            // ignore
        }

        // Stock filter
        String[] stockArr = request.getParameterValues("stock");
        String stockFilter = null;
        if (stockArr != null && stockArr.length > 0) {
            boolean hasIn = false, hasOut = false;
            for (String s : stockArr) {
                if ("inStock".equals(s)) hasIn = true;
                if ("outOfStock".equals(s)) hasOut = true;
            }
            if (hasIn && !hasOut) stockFilter = "inStock";
            if (hasOut && !hasIn) stockFilter = "outOfStock";
        }

        // Sorting param (new)
        String sort = request.getParameter("sort"); // values: featured, best_selling, name_asc, name_desc, price_asc, price_desc, date_asc, date_desc

        // Lấy products để hiển thị (Áp stockFilter nếu user chọn) - truyền sort vào DAO
        List<Product> products = productDAO.getProductsWithFilter(categoryList, brandList, minPrice, maxPrice, stockFilter, sort);

        // Đếm variant-level in/out stock
        int inStockCount = productDAO.countVariantsInStock(categoryList, brandList, minPrice, maxPrice);
        int outStockCount = productDAO.countVariantsOutOfStock(categoryList, brandList, minPrice, maxPrice);

        List<Brand> brands = brandDAO.getBrandsWithCountFiltered(categoryList, minPrice, maxPrice, stockFilter);
        List<ProductCategory> categories = categoryDAO.getCategoriesWithCountFiltered(brandList, minPrice, maxPrice, stockFilter);

        request.setAttribute("products", products);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("outStockCount", outStockCount);

        // forward giữ param sort để select chọn đúng
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}