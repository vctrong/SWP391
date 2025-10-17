package controller;

import daos.BrandDAO;
import daos.ProductDAO;
import daos.ProductImgDAO;
import daos.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Brand;
import model.Product;
import model.ProductImg;
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
            // 🟢 1. Lấy productId từ query string (VD: /product?id=3)
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect("shop");
                return;
            }

            int productId = Integer.parseInt(idParam);

            // 🟢 2. Lấy thông tin sản phẩm chính
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // 🟢 3. Lấy danh sách biến thể (variants)
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            request.setAttribute("variants", variants);

            // 🟢 4. Lấy danh sách ảnh phụ (gallery) từ ProductImg
            ProductImgDAO productImgDAO = new ProductImgDAO();
            List<ProductImg> productImages = productImgDAO.findByProductId(productId);
            request.setAttribute("productImages", productImages);

            // 🟢 5. Lấy tên thương hiệu (Brand) cho sản phẩm
            BrandDAO brandDAO = new BrandDAO();
            List<Brand> brands = brandDAO.getAllBrands();

            Map<Integer, String> brandMap = new HashMap<>();
            for (Brand b : brands) {
                brandMap.put(b.getBrandId(), b.getBrandName());
            }

            if (product.getBrandId() != null) {
                product.setBrandName(brandMap.get(product.getBrandId()));
            }

            // 🟢 6. Lấy danh sách review + điểm trung bình đánh giá
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByProduct(productId);
            double avgRating = reviewDAO.getAverageRatingByProduct(productId);

            // 🟢 7. Gắn các thuộc tính cần thiết lên request
            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);

            // 🟢 8. Forward sang JSP hiển thị
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
