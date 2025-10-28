package controller;

import daos.CartDAO;
import daos.UserAddressDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;
import model.UserAddress;
import model.Users;

/**
 * cartServlet - hiển thị giỏ hàng (GET /cart) và xử lý hành động giỏ hàng (POST /cart)
 * POST expects parameter "action" with values: add | update | remove
 */
@WebServlet(name = "cartServlet", urlPatterns = {"/cart"})
public class cartServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(cartServlet.class.getName());

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

    // GET: show cart page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = resolveUserIdFromSession(session);

        if (userId == null) {
            String returnTo = request.getRequestURI();
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        try {
            CartDAO cartDao = new CartDAO();
            UserAddressDAO addrDao = new UserAddressDAO();

            List<CartItem> cartItems = cartDao.getCartItemsByUser(userId);
            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);

            double subtotal = 0.0;
            if (cartItems != null) {
                for (CartItem it : cartItems) {
                    try { subtotal += it.getLineTotal(); } catch (Exception ex) { LOG.log(Level.WARNING, "line total error", ex); }
                }
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("addresses", addresses);
            request.setAttribute("subtotal", subtotal);
            // default shippingFee if not set
            request.setAttribute("shippingFee", request.getAttribute("shippingFee") != null ? request.getAttribute("shippingFee") : 30000.0);
            request.setAttribute("tax", request.getAttribute("tax") != null ? request.getAttribute("tax") : 0.0);
            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Error loading cart", ex);
            request.setAttribute("checkoutError", "Có lỗi khi tải giỏ hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        }
    }

    // POST: handle add/update/remove
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (LOG.isLoggable(Level.INFO)) LOG.info("[cart] session=" + (session == null ? "null" : session.getId()));

        Integer userId = resolveUserIdFromSession(session);
        if (userId == null) {
            // not logged in -> redirect to login
            String referer = request.getHeader("Referer");
            String returnTo = (referer != null) ? URLEncoder.encode(referer, "UTF-8") : "/";
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + returnTo);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "add"; // default for compatibility

        CartDAO cartDao = new CartDAO();
        try {
            switch (action.toLowerCase()) {
                case "add": {
                    String variantParam = request.getParameter("variantId");
                    String qtyParam = request.getParameter("quantity");
                    if (variantParam == null || variantParam.trim().isEmpty()) {
                        String refer = request.getHeader("Referer");
                        response.sendRedirect((refer != null ? refer : request.getContextPath() + "/shop") + (refer != null && refer.contains("?") ? "&" : "?") + "addError=" + URLEncoder.encode("Vui lòng chọn biến thể.", "UTF-8"));
                        return;
                    }
                    int variantId = Integer.parseInt(variantParam);
                    int qty = 1;
                    if (qtyParam != null && !qtyParam.isEmpty()) {
                        try { qty = Integer.parseInt(qtyParam); if (qty < 1) qty = 1; } catch (NumberFormatException ex) { qty = 1; }
                    }
                    cartDao.addToCart(userId, variantId, qty);
                    if (LOG.isLoggable(Level.INFO)) LOG.info("[cart] added variant=" + variantId + " qty=" + qty + " user=" + userId);
                    response.sendRedirect(request.getContextPath() + "/cart?added=1");
                    return;
                }
                case "update": {
                    String cartItemIdParam = request.getParameter("cartItemId");
                    String qtyParam = request.getParameter("quantity");
                    if (cartItemIdParam == null) { response.sendRedirect(request.getContextPath() + "/cart"); return; }
                    int cartItemId = Integer.parseInt(cartItemIdParam);
                    int qty = 1;
                    try { qty = Integer.parseInt(qtyParam); if (qty < 1) qty = 1; } catch (Exception ex) { qty = 1; }
                    boolean ok = cartDao.updateCartItemQuantity(cartItemId, qty);
                    if (!ok) LOG.warning("[cart] update failed cartItemId=" + cartItemId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                case "remove": {
                    String cartItemIdParam = request.getParameter("cartItemId");
                    if (cartItemIdParam == null) { response.sendRedirect(request.getContextPath() + "/cart"); return; }
                    int cartItemId = Integer.parseInt(cartItemIdParam);
                    boolean ok = cartDao.removeCartItem(cartItemId);
                    if (!ok) LOG.warning("[cart] remove failed cartItemId=" + cartItemId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                default: {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "DB error in cart action", ex);
            response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode("Lỗi hệ thống.", "UTF-8"));
        } catch (NumberFormatException nfe) {
            LOG.log(Level.WARNING, "Invalid numeric param in cart action", nfe);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}