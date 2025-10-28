package controller;

import daos.CartDAO;
import daos.UserAddressDAO;
import daos.OrderDAO;
import java.io.IOException;
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
 * checkoutServlet - safer error handling: compute totals server-side and forward to JSP.
 * - Does NOT write to response before forwarding.
 * - Logs errors and avoids forwarding after response is committed.
 */
@WebServlet(name = "checkoutServlet", urlPatterns = {"/checkout"})
public class checkoutServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(checkoutServlet.class.getName());

    private Integer idFromUserObject(Object userObj) {
        if (userObj == null) return null;
        try {
            if (userObj instanceof Users) {
                return ((Users) userObj).getId();
            }
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
        if (o instanceof Number) return ((Number) o).intValue();
        if (o instanceof String) {
            try { return Integer.parseInt((String) o); } catch (NumberFormatException ex) {}
        }

        // last resort: scan attributes for integer-like value
        java.util.Enumeration<String> names = session.getAttributeNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            Object val = session.getAttribute(name);
            if (val instanceof Number) {
                int v = ((Number) val).intValue();
                if (v > 0) {
                    session.setAttribute("userId", v);
                    return v;
                }
            }
            if (val instanceof String) {
                try {
                    int v = Integer.parseInt((String) val);
                    if (v > 0) {
                        session.setAttribute("userId", v);
                        return v;
                    }
                } catch (NumberFormatException ex) {}
            }
        }

        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = resolveUserIdFromSession(session);

        if (userId == null) {
            String returnTo = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        try {
            UserAddressDAO addrDao = new UserAddressDAO();
            CartDAO cartDao = new CartDAO();

            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);
            List<CartItem> cartItems = cartDao.getCartItemsByUser(userId);

            double subtotal = 0.0;
            if (cartItems != null) {
                for (CartItem it : cartItems) {
                    try {
                        subtotal += it.getLineTotal();
                    } catch (Throwable t) {
                        LOG.log(Level.WARNING, "Failed to compute line total for cart item", t);
                    }
                }
            }

            // shippingFee may come from request param (when returning from failed place order),
            // otherwise use default 30000
            double shippingFee = 30000.0;
            String shippingFeeParam = request.getParameter("shippingFee");
            if (shippingFeeParam == null) {
                Object sfAttr = request.getAttribute("shippingFee");
                if (sfAttr instanceof Number) shippingFee = ((Number) sfAttr).doubleValue();
                else if (sfAttr instanceof String) {
                    try { shippingFee = Double.parseDouble((String) sfAttr); } catch (Exception ignore) {}
                }
            } else {
                try { shippingFee = Double.parseDouble(shippingFeeParam); } catch (Exception ignore) {}
            }

            double tax = 0.0;
            Object taxAttr = request.getAttribute("tax");
            if (taxAttr instanceof Number) tax = ((Number) taxAttr).doubleValue();
            else if (taxAttr instanceof String) {
                try { tax = Double.parseDouble((String) taxAttr); } catch (Exception ignore) {}
            }

            double total = subtotal + shippingFee + tax;

            // set attributes for JSP
            request.setAttribute("addresses", addresses);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("tax", tax);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Error processing checkout", ex);

            if (response.isCommitted()) {
                LOG.severe("Response already committed, cannot forward to checkout.jsp");
                return;
            }

            request.setAttribute("checkoutError", "Có lỗi khi tải dữ liệu thanh toán. Vui lòng thử lại hoặc liên hệ quản trị.");
            try {
                request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);
            } catch (IllegalStateException ise) {
                LOG.log(Level.SEVERE, "Forward failed after exception; attempting redirect to /error", ise);
                try {
                    response.sendRedirect(request.getContextPath() + "/error");
                } catch (Exception redirectEx) {
                    LOG.log(Level.SEVERE, "Redirect also failed", redirectEx);
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = resolveUserIdFromSession(session);
        if (userId == null) {
            String returnTo = request.getRequestURI();
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        String shippingAddressIdParam = request.getParameter("shippingAddressId");
        String paymentMethod = request.getParameter("paymentMethod");
        String shippingFeeParam = request.getParameter("shippingFee");
        int shippingAddressId = 0;
        double shippingFee = 30000.0;

        try {
            if (shippingAddressIdParam != null && !shippingAddressIdParam.isEmpty()) {
                shippingAddressId = Integer.parseInt(shippingAddressIdParam);
            }
            if (shippingFeeParam != null && !shippingFeeParam.isEmpty()) {
                shippingFee = Double.parseDouble(shippingFeeParam);
            }
        } catch (NumberFormatException ignore) {}

        OrderDAO orderDao = new OrderDAO();
        try {
            int orderId = orderDao.placeOrderFromCart(userId, shippingAddressId, paymentMethod, shippingFee);
            response.sendRedirect(request.getContextPath() + "/order-confirmation?orderId=" + orderId);
        } catch (SQLException sqe) {
            LOG.log(Level.SEVERE, "Order creation failed", sqe);
            request.setAttribute("checkoutError", "Không thể tạo đơn hàng: " + sqe.getMessage());
            if (!response.isCommitted()) {
                // reload page showing error
                try {
                    doGet(request, response);
                } catch (Exception e) {
                    LOG.log(Level.SEVERE, "Failed to reload checkout page after order failure", e);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().println("Order creation failed and could not reload page.");
                }
            } else {
                LOG.severe("Response already committed while handling order creation failure");
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "Unexpected error creating order", ex);
            request.setAttribute("checkoutError", "Lỗi hệ thống khi tạo đơn hàng.");
            if (!response.isCommitted()) {
                try {
                    doGet(request, response);
                } catch (Exception e) {
                    LOG.log(Level.SEVERE, "Failed to reload checkout page after unexpected error", e);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().println("Unexpected error and reload failed.");
                }
            } else {
                LOG.severe("Response already committed while handling unexpected order creation error");
            }
        }
    }
}