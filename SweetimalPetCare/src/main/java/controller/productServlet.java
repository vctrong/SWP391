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
import model.ReviewReply;
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
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);

            // 1. Load product (ProductDAO is authoritative for product detail)
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // 2. Variants (all active variants for detail page)
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            request.setAttribute("variants", variants);

            // 3. Product images (robust: don't let missing table break page)
            ProductImgDAO productImgDAO = new ProductImgDAO();
            List<ProductImg> productImages;
            try {
                productImages = productImgDAO.findByProductId(productId);
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Error loading product images for product " + productId, ex);
                productImages = java.util.Collections.emptyList();
            }
            request.setAttribute("productImages", productImages);

            // 4. Brand name: use BrandDAO.getBrandById (no fallback)
            try {
                BrandDAO brandDAO = new BrandDAO();
                if (product.getBrandId() != null) {
                    Brand b = brandDAO.getBrandById(product.getBrandId());
                    if (b != null) {
                        product.setBrandName(b.getBrandName());
                    } else {
                        LOGGER.log(Level.FINE, "Brand not found for id {0}", product.getBrandId());
                    }
                }
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Unable to resolve brand name for product " + productId, ex);
            }

            // 5. Reviews and average rating
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByProduct(productId);
            double avgRating = reviewDAO.getAverageRatingByProduct(productId);

            // Build replies map for product reviews (so JSP can show reply content)
            Map<Long, ReviewReply> repliesMap = new HashMap<>();
            if (reviews != null) {
                for (Review r : reviews) {
                    Integer ridObj = r.getReviewId();
                    if (ridObj == null) continue;
                    long rid = ridObj.longValue();
                    try {
                        ReviewReply rep = reviewDAO.getReplyByReviewId(rid);
                        if (rep != null) repliesMap.put(rid, rep);
                    } catch (Exception ex) {
                        LOGGER.log(Level.FINER, "Error fetching reply for review id " + rid, ex);
                    }
                }
            }

            // 6. Related products (ProductDAO.getRelatedProductsByCategory)
            List<Product> relatedProducts;
            try {
                int categoryId = product.getProductCategoryId();
                relatedProducts = productDAO.getRelatedProductsByCategory(categoryId, productId, 6);
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Cannot load related products for product " + productId, ex);
                relatedProducts = java.util.Collections.emptyList();
            }

            // 7. User from session only (do not read customerId from request)
            HttpSession session = request.getSession(false);
            Integer userId = null;
            Users sessionUser = null;
            if (session != null) {
                Object userObj = session.getAttribute("user");
                if (userObj instanceof Users) {
                    sessionUser = (Users) userObj;
                    userId = sessionUser.getId();
                    // REQUEST attribute "user" so EL ${user} works like service pages
                    request.setAttribute("user", sessionUser);
                    request.setAttribute("userId", sessionUser.getId());
                    request.setAttribute("customerId", sessionUser.getId());
                }
            }

            // 8. Check purchase/review status if user logged in
            boolean userHasPurchased = false;
            boolean userHasReviewed = false;
            if (userId != null) {
                try {
                    OrderDAO orderDao = new OrderDAO();
                    userHasPurchased = orderDao.hasCustomerPurchasedProduct(userId, productId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Error checking purchase status for user " + userId, ex);
                    userHasPurchased = false;
                }

                try {
                    userHasReviewed = reviewDAO.userHasReviewedProduct(userId, productId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Error checking reviewed status for user " + userId, ex);
                    userHasReviewed = false;
                }
            }

            // 9. Set attributes and forward to JSP
            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("userHasPurchased", Boolean.valueOf(userHasPurchased));
            request.setAttribute("userHasReviewed", Boolean.valueOf(userHasReviewed));
            request.setAttribute("repliesMap", repliesMap);

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
        // POST: add review (use session user only)
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object userObj = session.getAttribute("user");
        if (!(userObj instanceof Users)) {
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

            if (rating < 1 || rating > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5");
                return;
            }

            ReviewDAO reviewDAO = new ReviewDAO();
            reviewDAO.addReview(productId, customerId, rating, comment);

            // PRG: redirect to GET product page
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
        return "Product detail controller with variants, images, reviews and related products";
    }
}