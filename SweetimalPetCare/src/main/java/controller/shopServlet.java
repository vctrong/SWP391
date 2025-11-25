package controller;

import daos.BrandDAO;
import daos.ProductCategoryDAO;
import daos.ProductDAO;
import daos.ProductVariantDAO;
import daos.ShopDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

        ShopDAO shopDAO = new ShopDAO();
        ProductVariantDAO prvant = new ProductVariantDAO();
        BrandDAO brandDAO = new BrandDAO();
        ProductCategoryDAO categoryDAO = new ProductCategoryDAO();

        Integer maxPriceInDb = prvant.getMaxPrice();
        request.setAttribute("maxPriceInDb", maxPriceInDb);

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

        Double minPrice = null, maxPrice = null;
        String minStr = request.getParameter("minPrice");
        String maxStr = request.getParameter("maxPrice");
        try {
            if (minStr != null && !minStr.isEmpty()) minPrice = Double.parseDouble(minStr);
            if (maxStr != null && !maxStr.isEmpty()) maxPrice = Double.parseDouble(maxStr);
        } catch (NumberFormatException ex) {
            // ignore
        }

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

        String sort = request.getParameter("sort");

        int currentPage = 1;
        int pageSize = 12;
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        try {
            if (pageParam != null) currentPage = Math.max(1, Integer.parseInt(pageParam));
        } catch (NumberFormatException ignored) {}
        try {
            if (pageSizeParam != null) {
                int ps = Integer.parseInt(pageSizeParam);
                if (ps == 9 || ps == 12 || ps == 18 || ps == 24) pageSize = ps;
                else if (ps > 0) pageSize = ps;
            }
        } catch (NumberFormatException ignored) {}

        // Use ShopDAO (shop/listing responsibilities)
        // If this is a pagination-only AJAX request (pageOnly=1), skip expensive sidebar queries
        boolean pageOnly = request.getParameter("pageOnly") != null;

        int totalProducts = shopDAO.countProductsWithFilter(categoryList, brandList, minPrice, maxPrice, stockFilter);
        if (totalProducts < 0) totalProducts = 0;

        int totalPages = (totalProducts + pageSize - 1) / pageSize;
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * pageSize;

        List<Product> products = shopDAO.getProductsWithFilterPaged(categoryList, brandList, minPrice, maxPrice, stockFilter, sort, pageSize, offset);

        int inStockCount = 0;
        int outStockCount = 0;
        List<Brand> brands = null;
        List<ProductCategory> categories = null;
        if (!pageOnly) {
            inStockCount = shopDAO.countVariantsInStock(categoryList, brandList, minPrice, maxPrice);
            outStockCount = shopDAO.countVariantsOutOfStock(categoryList, brandList, minPrice, maxPrice);
            brands = brandDAO.getBrandsWithCountFiltered(categoryList, minPrice, maxPrice, stockFilter);
            categories = categoryDAO.getCategoriesWithCountFiltered(brandList, minPrice, maxPrice, stockFilter);
        }

        request.setAttribute("products", products);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("outStockCount", outStockCount);

        request.setAttribute("sort", sort);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("pageSize", pageSize);

        // Provide paramValues map expected by JSP (category/brand/stock arrays)
        Map<String, String[]> paramValues = new HashMap<>();
        paramValues.put("category", request.getParameterValues("category") == null ? new String[0] : request.getParameterValues("category"));
        paramValues.put("brand", request.getParameterValues("brand") == null ? new String[0] : request.getParameterValues("brand"));
        paramValues.put("stock", request.getParameterValues("stock") == null ? new String[0] : request.getParameterValues("stock"));
        request.setAttribute("paramValues", paramValues);

        // Always forward to the single JSP. The JSP will decide whether to render full page or fragment
        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}