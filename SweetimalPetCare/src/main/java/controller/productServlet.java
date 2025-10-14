package controller;

import daos.BrandDAO;
import daos.ProductDAO;
import daos.ReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Brand;
import model.Product;
import model.ProductVariant;
import model.Review;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name = "productServlet", urlPatterns = {"/product"})
public class productServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 🟢 Lấy id từ query string: /product?id=5
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                // ⚙️ Nếu không có id thì quay lại trang shop
                response.sendRedirect("shop");
                return;
            }

            int productId = Integer.parseInt(idParam);

            // 🟢 Gọi DAO để lấy sản phẩm
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // 🟢 Lấy danh sách các biến thể (variants)
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            request.setAttribute("variants", variants);

            // 🟢 Lấy brandName gián tiếp qua BrandDAO
            BrandDAO brandDAO = new BrandDAO();
            List<Brand> brands = brandDAO.getAllBrands();

            Map<Integer, String> brandMap = new HashMap<>();
            for (Brand b : brands) {
                brandMap.put(b.getBrandId(), b.getBrandName());
            }

            if (product.getBrandId() != null) {
                product.setBrandName(brandMap.get(product.getBrandId()));
            }

            // 🟢 Lấy danh sách reviews + trung bình rating
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByProduct(productId);
            double avgRating = reviewDAO.getAverageRatingByProduct(productId);

            // 🟢 Gắn product, variants, reviews, avgRating vào request
            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);

            // 🟢 Forward sang trang product.jsp
            request.getRequestDispatcher("/WEB-INF/pages/product.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(productServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            Logger.getLogger(productServlet.class.getName()).log(Level.SEVERE, null, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            ReviewDAO reviewDAO = new ReviewDAO();
            reviewDAO.addReview(productId, customerId, rating, comment);

            // redirect về lại trang sản phẩm
            response.sendRedirect("product?id=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi thêm phản hồi");
        }
    }

    @Override
    public String getServletInfo() {
        return "Product detail controller with variants and reviews";
    }
}
