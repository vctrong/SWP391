package controller;

import daos.UserAddressDAO;
import daos.OrderDAO;
import daos.OrderCartDAO;
import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.UserAddress;
import model.Users;
import model.OrderItem;

/**
 * checkoutServlet - updated to redirect to different pages by payment method.
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

    // small reflection helpers to read common bean property names safely
    private Long readLongProperty(Object obj, String... names) {
        if (obj == null) return null;
        for (String n : names) {
            try {
                Method m = obj.getClass().getMethod(n);
                Object v = m.invoke(obj);
                if (v instanceof Number) return ((Number) v).longValue();
                if (v instanceof String) {
                    try { return Long.parseLong((String) v); } catch (NumberFormatException ex) {}
                }
            } catch (NoSuchMethodException ignore) {
            } catch (Exception ex) {
                LOG.log(Level.FINE, "readLongProperty error for " + n, ex);
            }
        }
        return null;
    }

    private Boolean readBooleanProperty(Object obj, String... names) {
        if (obj == null) return null;
        for (String n : names) {
            try {
                Method m = obj.getClass().getMethod(n);
                Object v = m.invoke(obj);
                if (v instanceof Boolean) return (Boolean) v;
                if (v instanceof Number) return ((Number) v).intValue() != 0;
                if (v instanceof String) {
                    String s = ((String) v).trim().toLowerCase();
                    if ("1".equals(s) || "true".equals(s) || "yes".equals(s)) return true;
                    if ("0".equals(s) || "false".equals(s) || "no".equals(s)) return false;
                }
            } catch (NoSuchMethodException ignore) {
            } catch (Exception ex) {
                LOG.log(Level.FINE, "readBooleanProperty error for " + n, ex);
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
            OrderCartDAO cartDao = new OrderCartDAO();

            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);
            List<OrderItem> cartItems = cartDao.listCartItemsByUser(userId.longValue());

            double subtotal = 0.0;
            if (cartItems != null) {
                for (OrderItem it : cartItems) {
                    try {
                        subtotal += it.getLineTotal();
                    } catch (Throwable t) {
                        LOG.log(Level.WARNING, "Failed to compute line total for order item", t);
                    }
                }
            }

            double tax = 0.0;
            Object taxAttr = request.getAttribute("tax");
            if (taxAttr instanceof Number) tax = ((Number) taxAttr).doubleValue();
            else if (taxAttr instanceof String) {
                try { tax = Double.parseDouble((String) taxAttr); } catch (Exception ignore) {}
            }

            // shipping is not charged -> do not expose shippingFee
            double total = subtotal + tax;

            // set attributes for JSP
            request.setAttribute("addresses", addresses);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
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
        long shippingAddressId = 0L;

        UserAddressDAO addrDao = new UserAddressDAO();

        // determine shippingAddressId:
        if (shippingAddressIdParam != null && !shippingAddressIdParam.isEmpty()) {
            try {
                shippingAddressId = Long.parseLong(shippingAddressIdParam);
            } catch (NumberFormatException ex) {
                LOG.log(Level.WARNING, "Invalid shippingAddressId param: " + shippingAddressIdParam, ex);
            }
        }

        try {
            // if client didn't provide an address, try to pick the default (or first) address
            if (shippingAddressId == 0L) {
                List<UserAddress> addresses = addrDao.getAddressesByUser(userId);
                if (addresses != null && !addresses.isEmpty()) {
                    // try to find default
                    Long found = null;
                    for (UserAddress a : addresses) {
                        Boolean isDef = readBooleanProperty(a, "isDefault", "getIsDefault", "getDefault", "is_default", "getIs_default");
                        if (isDef != null && isDef) {
                            found = readLongProperty(a, "getAddressId", "getAddress_id", "getId", "addressId", "address_id");
                            if (found != null) break;
                        }
                    }
                    if (found == null) {
                        // fallback to first address id
                        found = readLongProperty(addresses.get(0), "getAddressId", "getAddress_id", "getId", "addressId", "address_id");
                    }
                    if (found != null) shippingAddressId = found;
                }
            }

            // if still no address chosen, require user to add/select address
            if (shippingAddressId == 0L) {
                request.setAttribute("checkoutError", "Vui lòng thêm hoặc chọn địa chỉ giao hàng trước khi đặt hàng.");
                doGet(request, response); // reload page with error message
                return;
            }

            OrderDAO orderDao = new OrderDAO();

            // Create/finalize order (OrderDAO will validate & decrement stock)
            long orderId = orderDao.finalizeDraftOrder(userId.longValue(), shippingAddressId, paymentMethod);

            // Branch by payment method:
            if (paymentMethod != null && "EWALLET".equalsIgnoreCase(paymentMethod.trim())) {
                // For e-wallet: show QR code page. Build a payment URL for QR (replace with real payment link in production)
                String paymentUrl = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath()) 
                        + "/pay?orderId=" + orderId; // example payment endpoint
                String qrUrl = "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=" 
                        + java.net.URLEncoder.encode(paymentUrl, "UTF-8");

                request.setAttribute("orderId", orderId);
                request.setAttribute("paymentUrl", paymentUrl);
                request.setAttribute("qrUrl", qrUrl);
                request.getRequestDispatcher("/WEB-INF/toast/paymentQr.jsp").forward(request, response);
                return;
            } else {
                // Default / CASH: show simple confirmation page
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("/WEB-INF/toast/orderConfirmation.jsp").forward(request, response);
                return;
            }
        } catch (SQLException sqe) {
            LOG.log(Level.SEVERE, "Order creation failed", sqe);
            request.setAttribute("checkoutError", "Không thể tạo đơn hàng: " + sqe.getMessage());
            if (!response.isCommitted()) {
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