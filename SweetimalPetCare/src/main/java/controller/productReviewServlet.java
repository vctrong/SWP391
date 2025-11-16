package controller;

import daos.OrderDAO;
import daos.ReviewDAO;
import java.io.IOException;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 * productReviewServlet - trả JSON khi là AJAX, redirect khi non-AJAX
 *
 * Logging: gọi trực tiếp Logger.getLogger(...).log(...) trong các catch (không khai báo biến logger ở lớp hay phương thức)
 */
@WebServlet(name="productReviewServlet", urlPatterns={"/product/review"})
public class productReviewServlet extends HttpServlet {

    // nhỏ gọn helper để escape JSON string (utility nhỏ)
    private static String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu người dùng GET tới /product/review => redirect về product page
        String pid = req.getParameter("productId");
        if (pid == null) {
            resp.sendRedirect(req.getContextPath() + "/shop");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product?id=" + URLEncoder.encode(pid, "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Detect AJAX (fetch/XHR)
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"));

        HttpSession session = req.getSession(false);

        // Chỉ lấy user từ session (không đọc id từ request)
        Integer userId = null;
        if (session != null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof Users) {
                Users u = (Users) userObj;
                userId = u.getId();
            }
        }

        if (userId == null) {
            String message = "Bạn cần đăng nhập để gửi đánh giá.";
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                String json = "{\"success\":false,\"message\":\"" + jsonEscape(message) + "\",\"login\":true}";
                resp.getWriter().write(json);
            } else {
                String referer = req.getHeader("Referer");
                String loginUrl = req.getContextPath() + "/login";
                if (referer != null && !referer.isEmpty()) loginUrl += "?redirect=" + URLEncoder.encode(referer, "UTF-8");
                if (session != null) session.setAttribute("reviewError", message);
                resp.sendRedirect(loginUrl);
            }
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "create";

        String productIdStr = req.getParameter("productId");
        final int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (Exception ex) {
            String message = "Product ID không hợp lệ.";
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
            } else {
                if (session != null) session.setAttribute("reviewError", message);
                resp.sendRedirect(req.getContextPath() + "/product?id=" + (productIdStr != null ? URLEncoder.encode(productIdStr, "UTF-8") : ""));
            }
            return;
        }

        ReviewDAO reviewDao = new ReviewDAO();
        OrderDAO orderDao = new OrderDAO();

        try {
            if ("delete".equalsIgnoreCase(action)) {
                boolean ok = reviewDao.deleteReviewByUserProduct(productId, userId);
                String message = ok ? "Đã xóa đánh giá." : "Không tìm thấy đánh giá để xóa.";
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"success\":" + (ok ? "true" : "false") + ",\"message\":\"" + jsonEscape(message) + "\"}");
                } else {
                    if (session != null) {
                        if (ok) session.setAttribute("reviewSuccess", message);
                        else session.setAttribute("reviewError", message);
                    }
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
                return;
            }

            // read rating/title/comment
            String ratingStr = req.getParameter("rating");
            int rating = 0;
            try { rating = Integer.parseInt(ratingStr); } catch (Exception ignored) {}
            String reviewTitle = req.getParameter("reviewTitle");
            String comment = req.getParameter("comment");
            if (reviewTitle == null) reviewTitle = "";
            if (comment == null) comment = "";

            // validate for create/edit
            if (rating < 1 || rating > 5) {
                String message = "Vui lòng chọn số sao hợp lệ (1-5).";
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
                } else {
                    if (session != null) session.setAttribute("reviewError", message);
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
                return;
            }
            // No minimum-length validation for comments anymore; only non-empty is required by the HTML 'required' attribute.

            if ("edit".equalsIgnoreCase(action)) {
                boolean updated = reviewDao.updateReviewByUserProduct(productId, userId, rating, reviewTitle, comment);
                String message = updated ? "Đã cập nhật đánh giá." : "Không tìm thấy đánh giá để cập nhật.";
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.setStatus(HttpServletResponse.SC_OK);
                    resp.getWriter().write("{\"success\":" + (updated ? "true" : "false") + ",\"message\":\"" + jsonEscape(message) + "\"}");
                } else {
                    if (session != null) {
                        if (updated) session.setAttribute("reviewSuccess", message);
                        else session.setAttribute("reviewError", message);
                    }
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
                return;
            }

            // default: create
            boolean purchased = orderDao.hasCustomerPurchasedProduct(userId, productId);
            if (!purchased) {
                String message = "Bạn chỉ có thể đánh giá sản phẩm sau khi mua.";
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
                } else {
                    if (session != null) session.setAttribute("reviewError", message);
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
                return;
            }
            boolean already = reviewDao.userHasReviewedProduct(userId, productId);
            if (already) {
                String message = "Bạn đã gửi đánh giá cho sản phẩm này. Bạn có thể chỉnh sửa hoặc xóa.";
                if (isAjax) {
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.setStatus(HttpServletResponse.SC_CONFLICT);
                    resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
                } else {
                    if (session != null) session.setAttribute("reviewError", message);
                    resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                }
                return;
            }

            // insert review (may throw SQLException)
            reviewDao.insertReview(productId, userId, rating, reviewTitle, comment);

            String successMsg = "Cảm ơn! Đánh giá của bạn đã được gửi.";
            if (isAjax) {
                // optionally you can return new average rating or new review HTML fragment
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_OK);
                String json = "{\"success\":true,\"message\":\"" + jsonEscape(successMsg) + "\",\"redirect\":\"" + jsonEscape(req.getContextPath() + "/product?id=" + productId) + "\"}";
                resp.getWriter().write(json);
            } else {
                if (session != null) session.setAttribute("reviewSuccess", successMsg);
                resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
            }
            return;

        } catch (SQLException ex) {
            // Log directly without a stored logger variable
            Logger.getLogger(productReviewServlet.class.getName())
                  .log(Level.SEVERE, "SQL error while handling review", ex);
            String message = "Có lỗi khi lưu đánh giá, vui lòng thử lại sau.";
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
            } else {
                if (session != null) session.setAttribute("reviewError", message);
                resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
            }
            return;
        } catch (Exception ex) {
            // Log directly without a stored logger variable
            Logger.getLogger(productReviewServlet.class.getName())
                  .log(Level.SEVERE, "Unexpected error while handling review", ex);
            throw new ServletException("Lỗi khi xử lý đánh giá.", ex);
        }
    }
}