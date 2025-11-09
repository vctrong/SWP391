package controller;

import daos.BrandDAO;
import daos.ProductDAO;
import daos.ProductImgDAO;
import daos.ReviewDAO;
import daos.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
import model.Users;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name = "productServlet", urlPatterns = {"/product"})
public class productServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(productServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // All page-loading logic is in doGet (no external helper methods)
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);

            // 1. Load product
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // 2. Variants
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            request.setAttribute("variants", variants);

            // 3. Product images
            ProductImgDAO productImgDAO = new ProductImgDAO();
            List<ProductImg> productImages = productImgDAO.findByProductId(productId);
            request.setAttribute("productImages", productImages);

            // 4. Brand name mapping
            BrandDAO brandDAO = new BrandDAO();
            List<Brand> brands = brandDAO.getAllBrands();
            Map<Integer, String> brandMap = new HashMap<>();
            for (Brand b : brands) brandMap.put(b.getBrandId(), b.getBrandName());
            if (product.getBrandId() != null) {
                product.setBrandName(brandMap.get(product.getBrandId()));
            }

            // 5. Reviews and average rating
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByProduct(productId);
            double avgRating = reviewDAO.getAverageRatingByProduct(productId);

            // 6. Related products
            List<Product> relatedProducts;
            try {
                int categoryId = product.getProductCategoryId();
                relatedProducts = productDAO.getRelatedProductsByCategory(categoryId, productId, 6);
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Cannot load related products", ex);
                relatedProducts = java.util.Collections.emptyList();
            }

            // 7. User from session only (do not read customerId from request)
            HttpSession session = request.getSession(false);
            Integer userId = null;
            if (session != null) {
                Object userObj = session.getAttribute("user");
                if (userObj instanceof Users) {
                    userId = ((Users) userObj).getId();
                }
                // if your application stores a different user type, you can add handling here,
                // but per request we only use session attribute "user".
            }

            // 8. Check purchase/review status if user logged in
            boolean userHasPurchased = false;
            boolean userHasReviewed = false;
            if (userId != null) {
                try {
                    OrderDAO orderDao = new OrderDAO();
                    userHasPurchased = orderDao.hasCustomerPurchasedProduct(userId, productId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Error checking purchase status", ex);
                    userHasPurchased = false;
                }

                try {
                    userHasReviewed = reviewDAO.userHasReviewedProduct(userId, productId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Error checking reviewed status", ex);
                    userHasReviewed = false;
                }
            }

            // 9. Set attributes and forward
            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("userHasPurchased", Boolean.valueOf(userHasPurchased));
            request.setAttribute("userHasReviewed", Boolean.valueOf(userHasReviewed));

            request.getRequestDispatcher("/WEB-INF/pages/product.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid product ID", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Server error loading product page", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // All POST logic inside doPost; use session 'user' only to determine reviewer identity
        HttpSession session = request.getSession(false);
        if (session == null) {
            // not logged in -> redirect to login (adjust path if needed)
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof Users)) {
            // user not valid -> redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users user = (Users) userObj;
        Integer customerId = user.getId();
        if (customerId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID not available in session");
            return;
        }

        try {
            String productIdParam = request.getParameter("productId");
            String ratingParam = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (productIdParam == null || ratingParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
                return;
            }

            int productId = Integer.parseInt(productIdParam);
            int rating = Integer.parseInt(ratingParam);

            // Optional: validate rating range (1..5)
            if (rating < 1 || rating > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5");
                return;
            }

            // Insert review using ReviewDAO
            ReviewDAO reviewDAO = new ReviewDAO();
            reviewDAO.addReview(productId, customerId, rating, comment);

            // PRG: redirect to GET product page to avoid re-post on refresh
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);

        } catch (NumberFormatException ex) {
            LOGGER.log(Level.SEVERE, "Invalid numeric parameter in review POST", ex);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric parameter");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error while adding review", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi thêm phản hồi");
        }
    }

    @Override
    public String getServletInfo() {
        return "Product detail controller with variants and reviews and related products (doGet/doPost only)";
    }
}