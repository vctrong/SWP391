package controller;

import daos.ReviewDAO;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.Enumeration;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name="productReviewServlet", urlPatterns={"/product/review"})
public class productReviewServlet extends HttpServlet {

    private static final String[] SESSION_USER_KEYS = new String[] {
        "customerId", "customer", "user", "account", "authUser"
    };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Redirect GET back to shop or product page
        response.sendRedirect(request.getContextPath() + "/shop");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ReviewDAO reviewDAO = new ReviewDAO();

        // --- Debug: print session/cookie info to help diagnose why server thinks user is not logged in ---
        HttpSession session = req.getSession(false);
        System.out.println("[productReviewServlet] POST " + req.getRequestURL() + (req.getQueryString() != null ? "?" + req.getQueryString() : ""));
        System.out.println("[productReviewServlet] session = " + session);
        if (session != null) {
            System.out.println("[productReviewServlet] sessionId = " + session.getId());
            Enumeration<String> names = session.getAttributeNames();
            while (names.hasMoreElements()) {
                String n = names.nextElement();
                System.out.println("[productReviewServlet] session.attr: " + n + " = " + session.getAttribute(n));
            }
        }
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                System.out.println("[productReviewServlet] cookie: " + c.getName() + "=" + c.getValue()
                        + " path=" + c.getPath() + " domain=" + c.getDomain() + " secure=" + c.getSecure());
            }
        } else {
            System.out.println("[productReviewServlet] no cookies");
        }

        // --- Resolve customerId from session (be flexible) ---
        Long customerId = resolveCustomerId(session);
        if (customerId == null) {
            // Not authenticated -> redirect to login with redirect back to referer/product page
            String referer = req.getHeader("Referer");
            String loginUrl = req.getContextPath() + "/login";
            if (referer != null && !referer.isEmpty()) {
                loginUrl += "?redirect=" + URLEncoder.encode(referer, "UTF-8");
            } else {
                // fallback to product page if productId present
                String pid = req.getParameter("productId");
                if (pid != null && !pid.isEmpty()) {
                    String current = req.getContextPath() + "/product?id=" + URLEncoder.encode(pid, "UTF-8");
                    loginUrl += "?redirect=" + URLEncoder.encode(current, "UTF-8");
                }
            }
            System.out.println("[productReviewServlet] No authenticated user found -> redirect to " + loginUrl);
            resp.sendRedirect(loginUrl);
            return;
        }

        // Parse form
        String productIdStr = req.getParameter("productId");
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");
        String reviewTitle = req.getParameter("reviewTitle");

        long productId;
        int rating;
        try {
            productId = Long.parseLong(productIdStr);
        } catch (Exception ex) {
            if (session != null) session.setAttribute("reviewError", "Product ID không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/product?id=" + (productIdStr != null ? productIdStr : ""));
            return;
        }

        try {
            rating = Integer.parseInt(ratingStr);
        } catch (Exception ex) {
            rating = 0;
        }
        if (rating < 1 || rating > 5) {
            if (session != null) session.setAttribute("reviewError", "Vui lòng chọn từ 1 đến 5 sao.");
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
            return;
        }

        if (comment == null) comment = "";
        comment = comment.trim();
        if (comment.length() > 2000) comment = comment.substring(0, 2000);
        if (reviewTitle == null) reviewTitle = "";

        // Save review (convert ids to int if your DAO expects int)
        boolean ok = reviewDAO.addReview((int) productId, customerId.intValue(), rating, comment);
        if (ok) {
            if (session != null) session.setAttribute("reviewSuccess", "Cảm ơn bạn đã gửi đánh giá.");
            System.out.println("[productReviewServlet] Review saved: productId=" + productId + " customerId=" + customerId + " rating=" + rating);
        } else {
            if (session != null) session.setAttribute("reviewError", "Có lỗi khi lưu đánh giá. Vui lòng thử lại.");
            System.out.println("[productReviewServlet] Review save failed: productId=" + productId + " customerId=" + customerId);
        }

        resp.sendRedirect(req.getContextPath() + "/product?id=" + productId);
    }

    /**
     * Try to resolve numeric customer id from session using common keys and reflection.
     * Returns null if not found.
     */
    private Long resolveCustomerId(HttpSession session) {
        if (session == null) return null;

        // 1) explicit numeric attribute (customerId)
        Object v = session.getAttribute("customerId");
        if (v != null) {
            Long id = toLong(v);
            if (id != null) return id;
        }

        // 2) try several common attribute names
        for (String key : SESSION_USER_KEYS) {
            Object obj = session.getAttribute(key);
            if (obj == null) continue;
            // if it's a number or string
            Long id = toLong(obj);
            if (id != null) return id;
            // if it's a user object, try reflection to find id getters
            id = extractIdFromUserObject(obj);
            if (id != null) return id;
        }

        // 3) no id found
        return null;
    }

    private Long toLong(Object o) {
        if (o == null) return null;
        if (o instanceof Number) return ((Number) o).longValue();
        try {
            String s = String.valueOf(o);
            if (s == null || s.trim().isEmpty()) return null;
            return Long.parseLong(s);
        } catch (Exception ex) {
            return null;
        }
    }

    private Long extractIdFromUserObject(Object obj) {
        if (obj == null) return null;
        String[] methodNames = new String[] { "getCustomerId", "getId", "getUserId", "getIdUser", "getAccountId", "getUserID" };
        for (String mName : methodNames) {
            try {
                Method m = obj.getClass().getMethod(mName);
                Object res = m.invoke(obj);
                Long id = toLong(res);
                if (id != null) return id;
            } catch (NoSuchMethodException nsme) {
                // ignore, try next
            } catch (Exception ex) {
                // other reflection error, ignore and continue
            }
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Handle product review submissions (robust auth check & debug logging)";
    }
}