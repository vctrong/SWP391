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
 * Updated shopServlet: always forwards to /WEB-INF/pages/shop.jsp.
 * The JSP itself checks X-Requested-With and renders either full page or fragment.
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

        int totalProducts = productDAO.countProductsWithFilter(categoryList, brandList, minPrice, maxPrice, stockFilter, sort);
        if (totalProducts < 0) totalProducts = 0;

        int totalPages = (totalProducts + pageSize - 1) / pageSize;
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * pageSize;

        List<Product> products = productDAO.getProductsWithFilterPaged(categoryList, brandList, minPrice, maxPrice, stockFilter, sort, pageSize, offset);

        int inStockCount = productDAO.countVariantsInStock(categoryList, brandList, minPrice, maxPrice);
        int outStockCount = productDAO.countVariantsOutOfStock(categoryList, brandList, minPrice, maxPrice);

        List<Brand> brands = brandDAO.getBrandsWithCountFiltered(categoryList, minPrice, maxPrice, stockFilter);
        List<ProductCategory> categories = categoryDAO.getCategoriesWithCountFiltered(brandList, minPrice, maxPrice, stockFilter);

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

        // Always forward to the single JSP. The JSP will decide whether to render full page or fragment
        request.getRequestDispatcher("/WEB-INF/pages/shop.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}