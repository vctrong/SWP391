package controller;

import daos.CartDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 * addToCartServlet - simplified logging for student project (no Supplier lambdas)
 */
@WebServlet(name = "addToCartServlet", urlPatterns = {"/cart/add"})
public class addToCartServlet extends HttpServlet {
    private static final Logger LOG = Logger.getLogger(addToCartServlet.class.getName());

    private Integer idFromUserObject(Object userObj) {
        if (userObj == null) return null;
        try {
            if (userObj instanceof Users) return ((Users) userObj).getId();
        } catch (Throwable ignore) {}
        String[] methodNames = new String[] {"getId", "getUserId"};
        for (String mName : methodNames) {
            try {
                java.lang.reflect.Method m = userObj.getClass().getMethod(mName);
                Object val = m.invoke(userObj);
                if (val instanceof Number) return ((Number) val).intValue();
                if (val instanceof String) {
                    try { return Integer.parseInt((String) val); } catch (NumberFormatException ex) {}
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    private Integer resolveUserIdFromSession(HttpSession session) {
        if (session == null) return null;
        Object userObj = session.getAttribute("user");
        Integer uid = idFromUserObject(userObj);
        if (uid != null) return uid;
        Object o = session.getAttribute("userId");
        if (o instanceof Number) return ((Number)o).intValue();
        if (o instanceof String) {
            try { return Integer.parseInt((String)o); } catch (NumberFormatException ex) {}
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        System.out.println("[addToCart] session=" + (session==null?"null":session.getId()));

        String variantParam = request.getParameter("variantId");
        String qtyParam = request.getParameter("quantity");

        System.out.println("[addToCart] received variantId=" + variantParam + " quantity=" + qtyParam);

        Integer userId = resolveUserIdFromSession(session);
        if (userId == null) {
            String referer = request.getHeader("Referer");
            String returnTo = (referer != null) ? URLEncoder.encode(referer, "UTF-8") : "/";
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + returnTo);
            return;
        }

        if (variantParam == null || variantParam.trim().isEmpty()) {
            String referer = request.getHeader("Referer");
            String refer = (referer != null) ? referer : request.getContextPath() + "/shop";
            response.sendRedirect(refer + (refer.contains("?") ? "&" : "?") + "addError=" + URLEncoder.encode("Vui lòng chọn biến thể.", "UTF-8"));
            return;
        }

        int variantId;
        int qty = 1;
        try {
            variantId = Integer.parseInt(variantParam);
            if (qtyParam != null && !qtyParam.isEmpty()) qty = Integer.parseInt(qtyParam);
            if (qty < 1) qty = 1;
        } catch (NumberFormatException ex) {
            String referer = request.getHeader("Referer");
            String refer = (referer != null) ? referer : request.getContextPath() + "/shop";
            response.sendRedirect(refer + (refer.contains("?") ? "&" : "?") + "addError=" + URLEncoder.encode("Số lượng không hợp lệ.", "UTF-8"));
            return;
        }

        CartDAO cartDao = new CartDAO();
        try {
            cartDao.addToCart(userId, variantId, qty);
            if (LOG.isLoggable(Level.INFO)) {
                LOG.info("[addToCart] added variant=" + variantId + " qty=" + qty + " for user=" + userId);
            }
            response.sendRedirect(request.getContextPath() + "/cart?added=1");
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "Failed to add to cart", ex);
            String referer = request.getHeader("Referer");
            String refer = (referer != null) ? referer : request.getContextPath() + "/shop";
            response.sendRedirect(refer + (refer.contains("?") ? "&" : "?") + "addError=" + URLEncoder.encode("Không thể thêm vào giỏ.", "UTF-8"));
        }
    }
}