package controller;

import daos.OrderCartDAO;
import daos.OrderDAO;
import daos.UserAddressDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.OrderItem;
import model.UserAddress;
import model.Users;

/**
 * cartServlet - quản lý giỏ hàng (add / update / remove / checkout)
 *
 * Phiên bản này giữ phần quản lý địa chỉ người dùng (UserAddress) nhưng
 * loại bỏ hoàn toàn mọi khai báo/điều phối "shippingFee".
 * Khi checkout, controller chỉ truyền shippingAddressId và paymentMethod
 * tới OrderDAO.finalizeDraftOrder(...) mà KHÔNG truyền shippingFee.
 */
@WebServlet(name = "cartServlet", urlPatterns = {"/cart"})
public class cartServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(cartServlet.class.getName());

    private Integer idFromUserObject(Object userObj) {
        if (userObj == null) return null;
        try {
            if (userObj instanceof Users) return ((Users) userObj).getId();
        } catch (Throwable ignore) {}
        String[] methodNames = new String[] {"getId", "getUserId", "getCustomerId"};
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
        if (o instanceof Number) return ((Number) o).intValue();
        if (o instanceof String) {
            try { return Integer.parseInt((String) o); } catch (NumberFormatException ex) {}
        }
        Object c = session.getAttribute("customerId");
        if (c instanceof Number) return ((Number) c).intValue();
        if (c instanceof String) {
            try { return Integer.parseInt((String) c); } catch (NumberFormatException ex) {}
        }
        return null;
    }

    // GET: show cart
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = resolveUserIdFromSession(session);
        if (userId == null) {
            String returnTo = request.getRequestURI();
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        try {
            OrderCartDAO cartDao = new OrderCartDAO();
            UserAddressDAO addrDao = new UserAddressDAO();

            List<OrderItem> cartItems = cartDao.listCartItemsByUser(userId.longValue());
            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);

            double subtotal = 0.0;
            for (OrderItem it : cartItems) {
                try {
                    subtotal += it.getLineTotal();
                } catch (Exception ex) {
                    LOG.log(Level.WARNING, "line total error", ex);
                }
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("addresses", addresses); // keep addresses available to the view
            request.setAttribute("subtotal", subtotal);

            // Completely remove shippingFee exposure: DO NOT set shippingFee attribute here.

            request.setAttribute("tax", request.getAttribute("tax") != null ? request.getAttribute("tax") : 0.0);
            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Error loading cart", ex);
            request.setAttribute("checkoutError", "Có lỗi khi tải giỏ hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        }
    }

    // POST: handle add/update/remove/checkout (all via /cart)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (LOG.isLoggable(Level.INFO)) LOG.info("[cart] session=" + (session == null ? "null" : session.getId()));

        Integer userId = resolveUserIdFromSession(session);
        if (userId == null) {
            String referer = request.getHeader("Referer");
            String returnTo = (referer != null) ? URLEncoder.encode(referer, "UTF-8") : "/";
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + returnTo);
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) action = "add"; // default

        OrderCartDAO cartDao = new OrderCartDAO();
        OrderDAO orderDao = new OrderDAO();

        try {
            switch (action.toLowerCase()) {
                case "add": {
                    String variantParam = request.getParameter("variantId");
                    String qtyParam = request.getParameter("quantity");
                    if (variantParam == null || variantParam.trim().isEmpty()) {
                        String refer = request.getHeader("Referer");
                        response.sendRedirect((refer != null ? refer : request.getContextPath() + "/shop")
                                + (refer != null && refer.contains("?") ? "&" : "?")
                                + "addError=" + URLEncoder.encode("Vui lòng chọn biến thể.", "UTF-8"));
                        return;
                    }
                    long variantId;
                    int qty = 1;
                    try {
                        variantId = Long.parseLong(variantParam);
                        if (qtyParam != null && !qtyParam.isEmpty()) {
                            qty = Integer.parseInt(qtyParam);
                            if (qty < 1) qty = 1;
                        }
                    } catch (NumberFormatException ex) {
                        String refer = request.getHeader("Referer");
                        String referUrl = (refer != null) ? refer : request.getContextPath() + "/shop";
                        response.sendRedirect(referUrl + (referUrl.contains("?") ? "&" : "?")
                                + "addError=" + URLEncoder.encode("Số lượng/ID không hợp lệ.", "UTF-8"));
                        return;
                    }

                    cartDao.addToCart(userId.longValue(), variantId, qty);
                    if (LOG.isLoggable(Level.INFO)) LOG.info("[cart] added variant=" + variantId + " qty=" + qty + " user=" + userId);
                    response.sendRedirect(request.getContextPath() + "/cart?added=1");
                    return;
                }

                case "update": {
                    String orderItemIdParam = request.getParameter("orderItemId");
                    String qtyParam = request.getParameter("quantity");
                    if (orderItemIdParam == null) {
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    long orderItemId;
                    int qty = 1;
                    try {
                        orderItemId = Long.parseLong(orderItemIdParam);
                        if (qtyParam != null && !qtyParam.isEmpty()) {
                            qty = Integer.parseInt(qtyParam);
                            if (qty < 1) qty = 1;
                        }
                    } catch (NumberFormatException ex) {
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    boolean ok = cartDao.updateOrderItemQuantity(orderItemId, qty);
                    if (!ok) LOG.warning("[cart] update failed orderItemId=" + orderItemId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                case "remove": {
                    String orderItemIdParam = request.getParameter("orderItemId");
                    if (orderItemIdParam == null) {
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    long orderItemId = Long.parseLong(orderItemIdParam);
                    boolean ok = cartDao.removeOrderItem(orderItemId);
                    if (!ok) LOG.warning("[cart] remove failed orderItemId=" + orderItemId);
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                case "checkout": {
                    // Keep shippingAddress usage, but DO NOT use or declare any shippingFee.
                    String addrParam = request.getParameter("shippingAddressId");
                    String paymentMethod = request.getParameter("paymentMethod");
                    long shippingAddressId = 0L;
                    try {
                        if (addrParam != null && !addrParam.isEmpty()) shippingAddressId = Long.parseLong(addrParam);
                    } catch (NumberFormatException ex) {
                        LOG.log(Level.WARNING, "Invalid address id in checkout param", ex);
                    }

                    // IMPORTANT: Do NOT set or pass shippingFee anywhere.
                    // Call OrderDAO.finalizeDraftOrder that accepts (userId, shippingAddressId, paymentMethod)
                    long orderId = orderDao.finalizeDraftOrder(userId.longValue(), shippingAddressId, paymentMethod);
                    LOG.info("[cart] checkout completed orderId=" + orderId + " user=" + userId);
                    response.sendRedirect(request.getContextPath() + "/order/confirmation?orderId=" + orderId);
                    return;
                }

                default: {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            }
        } catch (SQLException ex) {
            LOG.log(Level.SEVERE, "DB error in cart action", ex);
            String msg = ex.getMessage() != null ? ex.getMessage() : "Lỗi hệ thống.";
            response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode(msg, "UTF-8"));
        } catch (NumberFormatException nfe) {
            LOG.log(Level.WARNING, "Invalid numeric param in cart action", nfe);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}