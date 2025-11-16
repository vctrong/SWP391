package controller;

import daos.OrderDAO;
import daos.ReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 * productReviewServlet - handles create/edit/delete reviews and replies
 * Returns JSON for AJAX requests, redirects for non-AJAX (PRG).
 */
@WebServlet(name = "productReviewServlet", urlPatterns = {"/product/review"})
public class productReviewServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(productReviewServlet.class.getName());

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
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || (req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json"));

        HttpSession session = req.getSession(false);

        Integer userId = null;
        Users sessionUser = null;
        if (session != null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof Users) {
                sessionUser = (Users) userObj;
                try {
                    Object idVal = sessionUser.getId();
                    if (idVal instanceof Number) {
                        userId = ((Number) idVal).intValue();
                    } else if (idVal != null) {
                        userId = Integer.parseInt(idVal.toString());
                    }
                } catch (Throwable t) {
                    LOGGER.log(Level.FINER, "Unable to read user id from sessionUser", t);
                    userId = null;
                }
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
                if (referer != null && !referer.isEmpty()) {
                    loginUrl += "?redirect=" + URLEncoder.encode(referer, "UTF-8");
                }
                if (session != null) {
                    session.setAttribute("reviewError", message);
                }
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
            // delete review by customer
            if ("delete".equalsIgnoreCase(action)) {
                boolean ok = reviewDao.deleteReviewByUserProduct(productId, userId);
                String message = ok ? "Đã xóa đánh giá." : "Không tìm thấy đánh giá để xóa.";
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

            // replies handling
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

                // get role safely
                Integer roleObj = null;
                try {
                    Object rVal = sessionUser.getRole();
                    if (rVal instanceof Number) {
                        roleObj = Integer.valueOf(((Number) rVal).intValue());
                    } else if (rVal != null) {
                        roleObj = Integer.valueOf(Integer.parseInt(rVal.toString()));
                    }
                } catch (Throwable t) {
                    roleObj = null;
                }
                int roleInt = (roleObj != null) ? roleObj.intValue() : -1;

                // staff only
                if (sessionUser == null || roleInt == 1) {
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

                // logging
                String previewContent = (req.getParameter("replyContent") != null) ? req.getParameter("replyContent") : "<null>";
                LOGGER.log(Level.INFO, "productReviewServlet: action={0} userId={1} role={2} productId={3} reviewId={4} replyLen={5}",
                        new Object[]{action, userId, roleInt, productId, reviewId, previewContent.length()});

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

                    long staffId = -1L;
                    try {
                        Object idVal = sessionUser.getId();
                        if (idVal instanceof Number) staffId = ((Number) idVal).longValue();
                        else if (idVal != null) staffId = Long.parseLong(idVal.toString());
                    } catch (Throwable t) {
                        LOGGER.log(Level.FINER, "Unable to read user id from sessionUser", t);
                        staffId = -1L;
                    }

                    boolean ok = false;
                    try {
                        if ("replyCreate".equalsIgnoreCase(action)) ok = reviewDao.createReply(reviewId, staffId, content);
                        else ok = reviewDao.updateReply(reviewId, staffId, content);
                    } catch (SQLException sqle) {
                        StringWriter sw = new StringWriter();
                        sqle.printStackTrace(new PrintWriter(sw));
                        LOGGER.log(Level.SEVERE, "SQL error when saving reply for reviewId=" + reviewId + ": " + sw.toString());
                        String message = "Lỗi cơ sở dữ liệu khi lưu phản hồi.";
                        if (isAjax) {
                            resp.setContentType("application/json;charset=UTF-8");
                            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                            resp.getWriter().write("{\"success\":false,\"message\":\"" + jsonEscape(message) + "\"}");
                        } else {
                            if (session != null) session.setAttribute("reviewError", message);
                            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
                        }
                        return;
                    }

                    String message = ok ? ("replyCreate".equalsIgnoreCase(action) ? "Đã thêm phản hồi." : "Đã cập nhật phản hồi.") : "Không thể lưu phản hồi.";
                    if (isAjax) {
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.setStatus(ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
            }

            // -------- review create / edit (customer) ----------
            String ratingStr = req.getParameter("rating");
            int rating = 0;
            try { rating = Integer.parseInt(ratingStr); } catch (Exception ignored) {}
            String reviewTitle = req.getParameter("reviewTitle");
            String comment = req.getParameter("comment");
            if (reviewTitle == null) reviewTitle = "";
            if (comment == null) comment = "";

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
            LOGGER.log(Level.SEVERE, "SQL error while handling review", ex);
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
            LOGGER.log(Level.SEVERE, "Unexpected error while handling review", ex);
            throw new ServletException("Lỗi khi xử lý đánh giá.", ex);
        }
    }
}