package controller;

import daos.BrandDAO;
import daos.ProductDAO;
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
 * Product detail controller (GET only).
 * POST related to reviews/replies is handled by productReviewServlet.
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

            // 3. Product images (use admin ProductDAO -> ProductImage table)
            List<ProductImg> productImages;
            try {
                daos.admin.ProductDAO adminDao = new daos.admin.ProductDAO();
                java.util.ArrayList<model.product.ProductImg> imgs = adminDao.getAllImagesByProductId(productId);
                productImages = new java.util.ArrayList<>();
                if (imgs != null) {
                    for (model.product.ProductImg pi : imgs) {
                        model.ProductImg m = new model.ProductImg();
                        m.setImageId(pi.getImageId());
                        m.setProductId(pi.getProductId());
                        m.setImageUrl(pi.getImageUrl());
                        m.setCaption(pi.getCaption());
                        m.setDisplayOrder(pi.getDisplayOrder());
                        m.setMain(pi.isIsMain());
                        m.setUploadedAt(pi.getUploadedAt());
                        productImages.add(m);
                    }
                }
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Error loading product images for product " + productId, ex);
                productImages = java.util.Collections.emptyList();
            }
            request.setAttribute("productImages", productImages);

            // 4. Brand
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

            // Build replies map keyed by Integer reviewId (so JSP can lookup by r.reviewId)
            Map<Integer, ReviewReply> repliesMap = new HashMap<>();
            if (reviews != null) {
                for (Review r : reviews) {
                    Integer ridObj = r.getReviewId(); // assume model.Review.getReviewId() returns Integer
                    if (ridObj == null) continue;
                    try {
                        ReviewReply rep = reviewDAO.getReplyByReviewId(ridObj.longValue());
                        if (rep != null) {
                            repliesMap.put(ridObj, rep);
                        }
                    } catch (Exception ex) {
                        LOGGER.log(Level.FINER, "Error fetching reply for review id " + ridObj, ex);
                    }
                }
            }

            // 6. Related products
            List<Product> relatedProducts;
            try {
                int categoryId = product.getProductCategoryId();
                // Show up to 8 related products (server-side limit)
                relatedProducts = productDAO.getRelatedProductsByCategory(categoryId, productId, 8);
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Cannot load related products for product " + productId, ex);
                relatedProducts = java.util.Collections.emptyList();
            }

            // 7. User from session
            HttpSession session = request.getSession(false);
            Integer userId = null;
            Users sessionUser = null;
            if (session != null) {
                Object userObj = session.getAttribute("user");
                if (userObj instanceof Users) {
                    sessionUser = (Users) userObj;
                    // normalize id to Integer if possible
                    try {
                        Object idVal = sessionUser.getId();
                        if (idVal instanceof Number) {
                            userId = ((Number) idVal).intValue();
                        } else if (idVal != null) {
                            userId = Integer.parseInt(idVal.toString());
                        }
                    } catch (Exception ex) {
                        userId = null;
                    }
                    // expose request-scoped user for JSP that expects ${user}
                    request.setAttribute("user", sessionUser);
                    request.setAttribute("userId", userId);
                    request.setAttribute("customerId", userId);
                }
            }

            // 8. Check purchase/review status
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

            // 9. Set attributes and forward
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
    public String getServletInfo() {
        return "Product detail controller with variants, images, reviews and related products";
    }
}