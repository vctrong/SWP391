package controller;

import daos.CartItemsDAO;
import daos.OrderCartDAO;
import daos.UserAddressDAO;
import daos.OrderDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAddress;
import model.Users;
import model.OrderItem;
import model.ProductVariant;
import model.CartItem;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name = "checkoutServlet", urlPatterns = {"/checkout"})
public class checkoutServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(checkoutServlet.class.getName());
    private static final double FIXED_SHIPPING_FEE = 30000.0; // 30.000₫ fixed shipping fee

    // helper: pretty print attribute JSON -> "Key: Value, ..."
    private String prettyAttributeFromJson(String raw) {
        if (raw == null) return null;
        String s = raw.trim();
        if (s.startsWith("{") && s.endsWith("}")) s = s.substring(1, s.length()-1);
        s = s.replaceAll("\"", "");
        if (s.isEmpty()) return "";
        String[] parts = s.split("\\s*,\\s*");
        List<String> out = new ArrayList<>();
        for (String p : parts) {
            String[] kv = p.split("\\s*[:=]\\s*", 2);
            if (kv.length == 2) {
                String key = kv[0].trim();
                String val = kv[1].trim();
                if (!key.isEmpty() && !val.isEmpty()) {
                    String label = key.substring(0,1).toUpperCase() + (key.length()>1 ? key.substring(1) : "");
                    out.add(label + ": " + val);
                }
            } else {
                if (!p.trim().isEmpty()) out.add(p.trim());
            }
        }
        return String.join(", ", out);
    }

    // GET: render checkout page reading cart from CartItems table
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Resolve user from session attribute "user" only (do not read session userId/customerId)
        HttpSession session = request.getSession(false);
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Integer userId = null;
        if (userObj instanceof Users) {
            try {
                userId = ((Users) userObj).getId();
            } catch (Exception ignore) {
                // if Users implementation differs, keep userId null -> redirect to login
            }
        }

        if (userId == null) {
            String returnTo = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        // Enforce only customers can access checkout
        if (userObj instanceof Users) {
            Users u = (Users) userObj;
            try {
                if (u.getRole() != 1) {
                    response.sendRedirect(request.getContextPath() + "/?error=" + URLEncoder.encode("Chỉ khách hàng mới được truy cập trang thanh toán.", "UTF-8"));
                    return;
                }
            } catch (Throwable ignore) {}
        }

        try {
            UserAddressDAO addrDao = new UserAddressDAO();
            OrderCartDAO cartDao = new OrderCartDAO();
            CartItemsDAO cartItemsDao = new CartItemsDAO();

            // Build cartItems from DB-backed cart (CartItems) and enrich
            List<CartItem> dbItems = cartItemsDao.getCartItemsByUser(userId.longValue());
            List<OrderItem> cartItems = new ArrayList<>();
            double subtotal = 0.0;

            if (dbItems != null && !dbItems.isEmpty()) {
                for (CartItem ci : dbItems) {
                    // METHOD B: call getters directly (CartItem has getVariantId() & getQuantity())
                    long variantId = ci.getVariantId();
                    int qty = ci.getQuantity();

                    OrderItem it = new OrderItem();
                    try { it.setVariantId(variantId); } catch (Exception ignore) {}
                    try { it.setQuantity(qty); } catch (Exception ignore) {}

                    // price lookup
                    try {
                        double price = cartDao.getVariantPriceAsDouble(variantId);
                        it.setUnitPrice(price);
                        it.setLineTotal(price * qty);
                        subtotal += price * qty;
                    } catch (SQLException ex) {
                        Logger.getLogger(checkoutServlet.class.getName()).log(Level.FINE, null, ex);
                        it.setUnitPrice(0.0);
                    }

                    // enrich metadata via DAO (same as before)
                    try {
                        Map<String,Object> meta = cartDao.getVariantMetadata(variantId);
                        if (meta != null && !meta.isEmpty()) {
                            Object pn = meta.get("productName");
                            if (pn instanceof String) it.setProductName((String) pn);
                            Object img = meta.get("imageUrl");
                            if (img instanceof String) it.setImageUrl((String) img);

                            // build ProductVariant to attach
                            ProductVariant pv = new ProductVariant();
                            Object vid = meta.get("variantId");
                            if (vid instanceof Number) pv.setVariantId(((Number)vid).longValue());
                            Object pid = meta.get("productId");
                            if (pid instanceof Number) pv.setProductId(((Number)pid).longValue());
                            Object sku = meta.get("sku");
                            if (sku instanceof String) pv.setSku((String) sku);
                            Object aJson = meta.get("attributeJson");
                            if (aJson instanceof String) pv.setAttributeJson((String) aJson);
                            Object priceM = meta.get("price");
                            if (priceM instanceof Number) pv.setPrice(((Number)priceM).doubleValue());
                            Object img2 = meta.get("imageUrl");
                            if (img2 instanceof String) pv.setImageUrl((String) img2);

                            it.setVariant(pv);
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(checkoutServlet.class.getName()).log(Level.FINE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(checkoutServlet.class.getName()).log(Level.FINER, null, ex);
                    }

                    cartItems.add(it);
                }
            }

            // load addresses for user (use UserAddress getters directly)
            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);

            double tax = 0.0;
            Object taxAttr = request.getAttribute("tax");
            if (taxAttr instanceof Number) tax = ((Number) taxAttr).doubleValue();
            else if (taxAttr instanceof String) {
                try { tax = Double.parseDouble((String) taxAttr); } catch (Exception ignore) {}
            }

            // shipping fee (fixed)
            double shippingFee = FIXED_SHIPPING_FEE;
            double total = subtotal + tax + shippingFee;

            // set attributes for JSP
            request.setAttribute("addresses", addresses);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, null, ex);

            if (response.isCommitted()) {
                LOG.severe("Response already committed, cannot forward to checkout.jsp");
                return;
            }

            request.setAttribute("checkoutError", "Có lỗi khi tải dữ liệu thanh toán. Vui lòng thử lại hoặc liên hệ quản trị.");
            try {
                request.getRequestDispatcher("/WEB-INF/pages/checkout.jsp").forward(request, response);
            } catch (IllegalStateException ise) {
                Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, null, ise);
                try {
                    response.sendRedirect(request.getContextPath() + "/error");
                } catch (Exception redirectEx) {
                    Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, null, redirectEx);
                }
            }
        }
    }

    // POST: perform checkout (persist order + order items) using CartItems table
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Resolve user from session attribute "user" only (do not read session userId/customerId)
        HttpSession session = request.getSession(false);
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        Integer userId = null;
        if (userObj instanceof Users) {
            try {
                userId = ((Users) userObj).getId();
            } catch (Exception ignore) {
                // leave as null -> redirect to login below
            }
        }

        if (userId == null) {
            String returnTo = request.getRequestURI();
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        // Enforce only customers can perform checkout (POST)
        if (userObj instanceof Users) {
            Users u = (Users) userObj;
            try {
                if (u.getRole() != 1) {
                    response.sendRedirect(request.getContextPath() + "/?error=" + URLEncoder.encode("Chỉ khách hàng mới được thực hiện thanh toán.", "UTF-8"));
                    return;
                }
            } catch (Throwable ignore) {}
        }

        String shippingAddressIdParam = request.getParameter("shippingAddressId");
        String paymentMethod = request.getParameter("paymentMethod");
        long shippingAddressId = 0L;

        // determine shippingAddressId param similarly as before
        if (shippingAddressIdParam != null && !shippingAddressIdParam.isEmpty()) {
            try {
                shippingAddressId = Long.parseLong(shippingAddressIdParam);
            } catch (NumberFormatException ex) {
                Logger.getLogger(checkoutServlet.class.getName()).log(Level.WARNING, null, ex);
            }
        } else {
            // fallback to user's default address if not provided
            try {
                List<UserAddress> addresses = new UserAddressDAO().getAddressesByUser(userId);
                if (addresses != null && !addresses.isEmpty()) {
                    long found = 0L;
                    for (UserAddress a : addresses) {
                        // Use the model's getter getIsDefault()
                        try {
                            if (a.getIsDefault()) {
                                found = a.getAddressId();
                                break;
                            }
                        } catch (Exception ignore) {
                            // ignore and continue
                        }
                    }
                    if (found == 0L) {
                        try {
                            found = addresses.get(0).getAddressId();
                        } catch (Exception ignore) {
                        }
                    }
                    if (found != 0L) shippingAddressId = found;
                }
            } catch (Exception ex) {
                Logger.getLogger(checkoutServlet.class.getName()).log(Level.FINER, null, ex);
            }
        }

        if (shippingAddressId == 0L) {
            request.setAttribute("checkoutError", "Vui lòng thêm hoặc chọn địa chỉ giao hàng trước khi đặt hàng.");
            doGet(request, response);
            return;
        }

        OrderDAO orderDao = new OrderDAO();
        CartItemsDAO cartItemsDao = new CartItemsDAO();

        // quick check cart not empty
        List<CartItem> dbItemsForCheckout = cartItemsDao.getCartItemsByUser(userId.longValue());
        if (dbItemsForCheckout == null || dbItemsForCheckout.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode("Giỏ hàng rỗng.", "UTF-8"));
            return;
        }

        try {
            // Persist order + OrderItems from CartItems table. OrderDAO will read CartItems and delete them.
            long orderId = orderDao.placeOrderFromCartItems(userId.intValue(), (int) shippingAddressId, paymentMethod);
            Logger.getLogger(checkoutServlet.class.getName()).info("[checkout] order created orderId=" + orderId + " user=" + userId);

            // No session cart to clear in DB-only mode; OrderDAO deletes CartItems entries.

            // branch by payment method (BANK -> QR, else confirmation)
            if (paymentMethod != null && "BANK".equalsIgnoreCase(paymentMethod.trim())) {
                String paymentUrl = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath())
                        + "/pay?orderId=" + orderId;
                String qrUrl = "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl="
                        + URLEncoder.encode(paymentUrl, "UTF-8");

                request.setAttribute("orderId", orderId);
                request.setAttribute("paymentUrl", paymentUrl);
                request.setAttribute("qrUrl", qrUrl);
                request.getRequestDispatcher("/WEB-INF/toast/paymentQr.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("/WEB-INF/toast/orderConfirmation.jsp").forward(request, response);
                return;
            }
        } catch (SQLException sqe) {
            Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, "Order creation failed", sqe);
            request.setAttribute("checkoutError", "Không thể tạo đơn hàng: " + sqe.getMessage());
            if (!response.isCommitted()) {
                try {
                    doGet(request, response);
                } catch (Exception e) {
                    Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, null, e);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().println("Order creation failed and could not reload page.");
                }
            } else {
                Logger.getLogger(checkoutServlet.class.getName()).severe("Response already committed while handling order creation failure");
            }
        } catch (Exception ex) {
            Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, "Unexpected error creating order", ex);
            request.setAttribute("checkoutError", "Lỗi hệ thống khi tạo đơn hàng.");
            if (!response.isCommitted()) {
                try {
                    doGet(request, response);
                } catch (Exception e) {
                    Logger.getLogger(checkoutServlet.class.getName()).log(Level.SEVERE, null, e);
                    response.setContentType("text/plain;charset=UTF-8");
                    response.getWriter().println("Unexpected error and reload failed.");
                }
            } else {
                Logger.getLogger(checkoutServlet.class.getName()).severe("Response already committed while handling unexpected order creation error");
            }
        }
    }
}