package controller;

import daos.ServiceDAO;
import daos.ServiceReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ReviewServvice;
import model.Service;
import model.Users;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet(name = "ServiceReviewServlet", urlPatterns = {"/service-reviews"})
public class ServiceReviewServlet extends HttpServlet {

    private final ServiceReviewDAO reviewDAO = new ServiceReviewDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sid = request.getParameter("serviceId");
        if (sid == null || sid.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing serviceId");
            return;
        }
        long serviceId;
        try { serviceId = Long.parseLong(sid); } catch (NumberFormatException ex) { response.sendError(400, "Invalid serviceId"); return; }

        Service svc = serviceDAO.getServiceById(serviceId);
        if (svc == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found");
            return;
        }

    List<ReviewServvice> reviews = reviewDAO.getReviewsByServiceId(serviceId);
    double avgRating = reviewDAO.getAverageRating(serviceId);
    int avgRounded = (int) Math.round(avgRating);
    String avgText = String.format(java.util.Locale.US, "%.1f", avgRating);
    Map<Integer, Integer> ratingCounts = reviewDAO.getRatingCounts(serviceId);

        // API mode (optional): return JSON when format=json
        String format = request.getParameter("format");
        if ("json".equalsIgnoreCase(format)) {
            response.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(toJsonResponse(reviews, avgRating, ratingCounts));
            }
            return;
        }

        // eligibility flags
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        model.Users u = (session != null) ? (model.Users) session.getAttribute("user") : null;
        boolean hasUsed = false;
        if (u != null) {
            hasUsed = reviewDAO.hasCustomerUsedService(u.getId(), serviceId);
        }

        // Build replies map reviewId -> ReviewReply
        java.util.Map<Long, model.ReviewReply> repliesMap = new java.util.HashMap<>();
        for (ReviewServvice r : reviews) {
            model.ReviewReply rep = reviewDAO.getReplyByReviewId(r.getReviewId());
            if (rep != null) repliesMap.put(r.getReviewId(), rep);
        }

        request.setAttribute("service", svc);
        request.setAttribute("reviews", reviews);
        request.setAttribute("repliesMap", repliesMap);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("avgRounded", avgRounded);
        request.setAttribute("avgText", avgText);
        request.setAttribute("ratingCounts", ratingCounts);
        request.setAttribute("hasUsedService", hasUsed);
        // expose user (for JSP includes) and editId if any
        request.setAttribute("user", u);
        String editId = request.getParameter("editId");
        if (editId != null && !editId.isEmpty()) {
            request.setAttribute("editId", editId);
            try {
                request.setAttribute("editIdLong", Long.parseLong(editId));
            } catch (NumberFormatException ignore) {}
        }
        // Reply edit toggle (by reviewId)
        String replyEditReviewId = request.getParameter("replyEditReviewId");
        if (replyEditReviewId != null && !replyEditReviewId.isEmpty()) {
            try {
                request.setAttribute("replyEditReviewIdLong", Long.parseLong(replyEditReviewId));
            } catch (NumberFormatException ignore) {}
        }
        // No longer set alreadyReviewed, always allow review if hasUsedService is true
        request.setAttribute("eligibleToReview", hasUsed);
        request.getRequestDispatcher("/WEB-INF/pages/service-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
    String sid = request.getParameter("serviceId");
    String action = Optional.ofNullable(request.getParameter("action")).orElse("create");
    String ratingStr = request.getParameter("rating");
    String comment = request.getParameter("comment");
        String reviewIdStr = request.getParameter("reviewId");

        long serviceId;
        int rating;
        try { serviceId = Long.parseLong(sid); } catch (Exception e) { response.sendError(400, "Invalid serviceId"); return; }
        try { rating = Integer.parseInt(ratingStr); } catch (Exception e) { rating = 0; }

        // Validation
        List<String> errors = new ArrayList<>();
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            errors.add("Vui lòng đăng nhập để đánh giá.");
        }
        if (!"delete".equalsIgnoreCase(action)) {
            if (rating < 1 || rating > 5) {
                errors.add("Số sao phải từ 1 đến 5.");
            }
            String cmt = comment == null ? "" : comment.trim();
            if (cmt.isEmpty()) {
                errors.add("Vui lòng nhập nội dung đánh giá.");
            }
            if (comment != null && comment.length() > 1000) {
                errors.add("Nội dung không quá 1000 ký tự.");
            }
        }

        // Only check service usage if no field validation errors
        if (errors.isEmpty() && user != null && "create".equalsIgnoreCase(action)) {
            long customerId = user.getId();
            if (!reviewDAO.hasCustomerUsedService(customerId, serviceId)) {
                errors.add("Bạn chỉ có thể đánh giá khi đã hoàn tất dịch vụ này.");
            }
        }

        boolean ok = false;
        String flashSuccess = null;
        String flashError = null;
        if ("replyCreate".equalsIgnoreCase(action) || "replyUpdate".equalsIgnoreCase(action) || "replyDelete".equalsIgnoreCase(action)) {
            // Staff/Admin/Vet reply management
            long reviewId;
            try { reviewId = Long.parseLong(reviewIdStr); } catch (Exception e) { response.sendError(400, "Invalid reviewId"); return; }
            if (user == null || user.getRole() == 1) {
                response.sendRedirect(request.getContextPath() + "/service-reviews?serviceId=" + serviceId);
                return;
            }
            if ("replyDelete".equalsIgnoreCase(action)) {
                ok = reviewDAO.deleteReply(reviewId);
                flashSuccess = ok ? "Đã xóa phản hồi." : "Không thể xóa phản hồi.";
            } else {
                String content = Optional.ofNullable(request.getParameter("replyContent")).orElse("").trim();
                if (content.isEmpty()) {
                    request.getSession().setAttribute("flashError", "Nội dung phản hồi không được trống.");
                    response.sendRedirect(request.getContextPath() + "/service-reviews?serviceId=" + serviceId);
                    return;
                }
                if (content.length() > 1000) {
                    request.getSession().setAttribute("flashError", "Phản hồi không quá 1000 ký tự.");
                    response.sendRedirect(request.getContextPath() + "/service-reviews?serviceId=" + serviceId);
                    return;
                }
                if ("replyCreate".equalsIgnoreCase(action)) {
                    ok = reviewDAO.createReply(reviewId, user.getId(), content);
                    flashSuccess = ok ? "Đã thêm phản hồi." : "Không thể thêm phản hồi.";
                } else {
                    ok = reviewDAO.updateReply(reviewId, user.getId(), content);
                    flashSuccess = ok ? "Đã cập nhật phản hồi." : "Không thể cập nhật phản hồi.";
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            long reviewId;
            try { reviewId = Long.parseLong(reviewIdStr); } catch (Exception e) { response.sendError(400, "Invalid reviewId"); return; }
            // Admin/Staff/Vet can delete any review; Customer can delete own only
            if (user != null && user.getRole() != 1) {
                ok = reviewDAO.adminDeleteReview(reviewId);
            } else {
                ok = reviewDAO.deleteReview(reviewId, user != null ? user.getId() : -1);
            }
            if (ok) flashSuccess = "Đã xóa đánh giá."; else flashError = "Không thể xóa đánh giá.";
        } else if ("update".equalsIgnoreCase(action)) {
            long reviewId;
            try { reviewId = Long.parseLong(reviewIdStr); } catch (Exception e) { response.sendError(400, "Invalid reviewId"); return; }
            ok = reviewDAO.updateReview(reviewId, user != null ? user.getId() : -1, rating, comment);
            if (ok) flashSuccess = "Đã cập nhật đánh giá."; else flashError = "Không thể cập nhật đánh giá.";
        } else {
            if (!errors.isEmpty()) {
                // Reload page with errors and keep the form visible with previous input
                List<ReviewServvice> reviews = reviewDAO.getReviewsByServiceId(serviceId);
                double avgRating = reviewDAO.getAverageRating(serviceId);
                int avgRounded = (int) Math.round(avgRating);
                String avgText = String.format(java.util.Locale.US, "%.1f", avgRating);
                Map<Integer, Integer> ratingCounts = reviewDAO.getRatingCounts(serviceId);
                request.setAttribute("service", serviceDAO.getServiceById(serviceId));
                request.setAttribute("reviews", reviews);
                request.setAttribute("avgRating", avgRating);
                request.setAttribute("avgRounded", avgRounded);
                request.setAttribute("avgText", avgText);
                request.setAttribute("ratingCounts", ratingCounts);
                request.setAttribute("errors", errors);
                // force show form and preserve input
                request.setAttribute("hasUsedService", true);
                request.setAttribute("eligibleToReview", true);
                request.setAttribute("user", user);
                request.setAttribute("prevRating", rating);
                request.setAttribute("prevComment", comment);
                request.getRequestDispatcher("/WEB-INF/pages/service-reviews.jsp").forward(request, response);
                return;
            }

            // Create
            ReviewServvice rv = new ReviewServvice();
            rv.setServiceId(serviceId);
            rv.setCustomerId(((Users) request.getSession().getAttribute("user")).getId());
            rv.setRating(rating);
            rv.setComment(comment);
            ok = reviewDAO.addReview(rv);
            if (ok) flashSuccess = "Cảm ơn bạn đã đánh giá!"; else flashError = "Không thể lưu đánh giá. Vui lòng thử lại.";
        }

        // flash via session to survive redirect
        if (flashSuccess != null) request.getSession().setAttribute("flashSuccess", flashSuccess);
        if (flashError != null) request.getSession().setAttribute("flashError", flashError);
        response.sendRedirect(request.getContextPath() + "/service-reviews?serviceId=" + serviceId);
    }

    private String toJsonResponse(List<ReviewServvice> reviews, double avg, Map<Integer, Integer> counts) {
        StringBuilder sb = new StringBuilder();
        sb.append('{');
        sb.append("\"average\":").append(String.format(java.util.Locale.US, "%.2f", avg)).append(',');
        // counts
        sb.append("\"counts\":{");
        for (int i = 1; i <= 5; i++) {
            sb.append('"').append(i).append('"').append(':').append(counts.getOrDefault(i, 0));
            if (i < 5) sb.append(',');
        }
        sb.append("},");
        // reviews
        sb.append("\"reviews\":[");
        for (int i = 0; i < reviews.size(); i++) {
            ReviewServvice r = reviews.get(i);
            sb.append('{')
                    .append("\"customerName\":").append(json(r.getCustomerName())).append(',')
                    .append("\"avatarUrl\":").append(json(r.getAvatarUrl())).append(',')
                    .append("\"rating\":").append(r.getRating()).append(',')
                    .append("\"comment\":").append(json(r.getComment())).append(',')
                    .append("\"createdAt\":").append(json(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getCreatedAt())))
                    .append('}');
            if (i < reviews.size() - 1) sb.append(',');
        }
        sb.append("]}");
        return sb.toString();
    }

    private String json(String s) {
        if (s == null) return "null";
        return '"' + s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r") + '"';
    }
}
