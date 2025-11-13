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

    private static String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pid = req.getParameter("productId");
        if (pid == null) {
            resp.sendRedirect(req.getContextPath() + "/shop");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product?id=" + URLEncoder.encode(pid, "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"));

        HttpSession session = req.getSession(false);

        Integer userId = null;
        Users sessionUser = null;
        if (session != null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof Users) {
                sessionUser = (Users) userObj;
                userId = sessionUser.getId();
            }
        }

        if (userId == null) {
            String message = "Bạn cần đăng nhập để gửi đánh giá.";
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\",\"login\":true}");
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

            if ("replyCreate".equalsIgnoreCase(action) || "replyUpdate".equalsIgnoreCase(action) || "replyDelete".equalsIgnoreCase(action)) {
                String reviewIdStr = req.getParameter("reviewId");
                final long reviewId;
                try {
                    reviewId = Long.parseLong(reviewIdStr);
                } catch (Exception e) {
                    String message = "reviewId không hợp lệ.";
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

                int role = -1;
                try {
                    role = (sessionUser != null) ? sessionUser.getRole() : -1;
                } catch (Exception ex) {
                    role = -1;
                }

                // Only staff/admin/vet (role != 1) can manage replies
                if (sessionUser == null || role == 1) {
                    String message = "Bạn không có quyền quản lý phản hồi.";
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

                if ("replyDelete".equalsIgnoreCase(action)) {
                    boolean ok = reviewDao.deleteReply(reviewId);
                    String message = ok ? "Đã xóa phản hồi." : "Không thể xóa phản hồi.";
                    if (isAjax) {
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.setStatus(HttpServletResponse.SC_OK);
                        resp.getWriter().write("{\"success\":" + (ok ? "true" : "false") + ",\"message\":\"" + jsonEscape(message) + "\"}");
                    } else {
                        if (session != null) {
                            if (ok) session.setAttribute("reviewSuccess", message); else session.setAttribute("reviewError", message);
                        }
                        resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                    }
                    return;
                } else {
                    String content = (req.getParameter("replyContent") != null) ? req.getParameter("replyContent").trim() : "";
                    if (content.isEmpty()) {
                        String message = "Nội dung phản hồi không được trống.";
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
                    if (content.length() > 1000) {
                        String message = "Phản hồi không quá 1000 ký tự.";
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

                    boolean ok;
                    Integer staffIdObj = sessionUser.getId();
                    long staffId = (staffIdObj != null) ? staffIdObj.longValue() : -1L;
                    if ("replyCreate".equalsIgnoreCase(action)) {
                        ok = reviewDao.createReply(reviewId, staffId, content);
                    } else {
                        ok = reviewDao.updateReply(reviewId, staffId, content);
                    }
                    String message = ok ? ( "replyCreate".equalsIgnoreCase(action) ? "Đã thêm phản hồi." : "Đã cập nhật phản hồi.") : "Không thể lưu phản hồi.";
                    if (isAjax) {
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.setStatus(HttpServletResponse.SC_OK);
                        resp.getWriter().write("{\"success\":" + (ok ? "true" : "false") + ",\"message\":\"" + jsonEscape(message) + "\"}");
                    } else {
                        if (session != null) {
                            if (ok) session.setAttribute("reviewSuccess", message); else session.setAttribute("reviewError", message);
                        }
                        resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                    }
                    return;
                }
            }

            // rest of review create/edit code unchanged (kept as in your original)
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
            if (comment.trim().length() < 20) {
                String message = "Nội dung đánh giá phải có ít nhất 20 ký tự.";
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
            Logger.getLogger(productReviewServlet.class.getName()).log(Level.SEVERE, "SQL error while handling review", ex);
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
            Logger.getLogger(productReviewServlet.class.getName()).log(Level.SEVERE, "Unexpected error while handling review", ex);
            throw new ServletException("Lỗi khi xử lý đánh giá.", ex);
        }
    }
}