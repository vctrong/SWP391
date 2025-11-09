package controller;

import daos.CartItemsDAO;
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
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.OrderItem;
import model.UserAddress;
import model.Users;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name = "cartServlet", urlPatterns = {"/cart"})
public class cartServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(cartServlet.class.getName());

    /**
     * Lấy trực tiếp Users object từ session. Không dùng session attribute "userId".
     * Trả về null nếu không có user trong session.
     */
    private Users resolveUserFromSession(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object userObj = session.getAttribute("user");
        if (userObj instanceof Users) {
            return (Users) userObj;
        }
        return null;
    }

    private long safeParseLong(String s, long fallback) {
        if (s == null || s.trim().isEmpty()) {
            return fallback;
        }
        try {
            return Long.parseLong(s.trim());
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }

    private int safeParseInt(String s, int fallback) {
        if (s == null || s.trim().isEmpty()) {
            return fallback;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException ex) {
            return fallback;
        }
    }

    private boolean isAjax(HttpServletRequest req) {
        String hdr = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(hdr)) {
            return true;
        }
        String accept = req.getHeader("Accept");
        return accept != null && accept.contains("application/json");
    }

    private void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try ( PrintWriter out = resp.getWriter()) {
            out.print(json);
        }
    }

    // Helper to pretty-print attribute JSON -> "Key: Value, Key2: Value2"
    private String prettyAttributeFromJson(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim();
        if (s.startsWith("{") && s.endsWith("}")) {
            s = s.substring(1, s.length() - 1);
        }
        s = s.replaceAll("\"", "");
        String[] parts = s.split("\\s*,\\s*");
        List<String> out = new ArrayList<>();
        for (String p : parts) {
            String[] kv = p.split("\\s*[:=]\\s*", 2);
            if (kv.length == 2) {
                String key = kv[0].trim();
                String val = kv[1].trim();
                if (!key.isEmpty() && !val.isEmpty()) {
                    String label = key.substring(0, 1).toUpperCase() + (key.length() > 1 ? key.substring(1) : "");
                    out.add(label + ": " + val);
                }
            } else {
                if (!p.trim().isEmpty()) {
                    out.add(p.trim());
                }
            }
        }
        return String.join(", ", out);
    }

    // helper: find quantity for variant in list
    // Updated to work with model.CartItem that uses primitive getters (long/int).
    private int findQtyInList(List<CartItem> list, long variantId) {
        if (list == null) {
            return 0;
        }
        for (CartItem ci : list) {
            if (ci == null) {
                continue;
            }
            // assume getVariantId() returns primitive long
            if (ci.getVariantId() == variantId) {
                // assume getQuantity() returns primitive int
                return ci.getQuantity();
            }
        }
        return 0;
    }

    // GET: show cart (read from CartItems table)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = resolveUserFromSession(session);
        if (user == null) {
            String returnTo = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + URLEncoder.encode(returnTo, "UTF-8"));
            return;
        }

        int userId = user.getId();

        try {
            CartItemsDAO cartItemsDao = new CartItemsDAO();
            OrderCartDAO cartDao = new OrderCartDAO();
            UserAddressDAO addrDao = new UserAddressDAO();

            List<CartItem> dbItems = cartItemsDao.getCartItemsByUser((long) userId);
            List<OrderItem> displayItems = new ArrayList<>();
            double subtotal = 0.0;
            int totalQty = 0; // NEW: track total quantity

            for (CartItem ci : dbItems) {
                // model.CartItem uses primitive getters now
                long variantId = ci.getVariantId();
                int qty = ci.getQuantity();

                // accumulate quantity for cart-empty logic
                totalQty += Math.max(0, qty);

                OrderItem it = new OrderItem();
                try {
                    OrderItem.class.getMethod("setVariantId", Long.class).invoke(it, variantId);
                } catch (NoSuchMethodException ex) {
                    try {
                        OrderItem.class.getMethod("setVariantId", long.class).invoke(it, variantId);
                    } catch (Exception ignore) {
                    }
                } catch (Exception ignore) {
                }
                try {
                    OrderItem.class.getMethod("setQuantity", Integer.class).invoke(it, qty);
                } catch (NoSuchMethodException ns) {
                    try {
                        OrderItem.class.getMethod("setQuantity", int.class).invoke(it, qty);
                    } catch (Exception ignore) {
                    }
                } catch (Exception ignore) {
                }

                // price lookup
                try {
                    double price = cartDao.getVariantPriceAsDouble(variantId);
                    try {
                        OrderItem.class.getMethod("setUnitPrice", Double.class).invoke(it, price);
                    } catch (NoSuchMethodException ns) {
                        try {
                            OrderItem.class.getMethod("setUnitPrice", double.class).invoke(it, price);
                        } catch (Exception ignore) {
                        }
                    } catch (Exception ignore) {
                    }
                    try {
                        java.lang.reflect.Method m = OrderItem.class.getMethod("setLineTotal", double.class);
                        m.invoke(it, price * qty);
                    } catch (Exception ignore) {
                    }
                    subtotal += price * qty;
                } catch (SQLException ex) {
                    Logger.getLogger(cartServlet.class.getName()).log(Level.FINE, null, ex);
                    try {
                        OrderItem.class.getMethod("setUnitPrice", Double.class).invoke(it, 0.0);
                    } catch (Exception ignore) {
                    }
                }

                // metadata enrichment (same as before)
                try {
                    Map<String, Object> meta = cartDao.getVariantMetadata(variantId);
                    if (meta != null && !meta.isEmpty()) {
                        Object pn = meta.get("productName");
                        if (pn instanceof String && ((String) pn).trim().length() > 0) {
                            try {
                                OrderItem.class.getMethod("setProductName", String.class).invoke(it, (String) pn);
                            } catch (Exception ignore) {
                            }
                        }
                        Object img = meta.get("imageUrl");
                        if (img instanceof String && ((String) img).trim().length() > 0) {
                            try {
                                OrderItem.class.getMethod("setImageUrl", String.class).invoke(it, (String) img);
                            } catch (Exception ignore) {
                            }
                        }
                        Object aText = meta.get("attributeText");
                        if (aText instanceof String && ((String) aText).trim().length() > 0) {
                            try {
                                OrderItem.class.getMethod("setAttributeText", String.class).invoke(it, (String) aText);
                            } catch (Exception ex) {
                                try {
                                    OrderItem.class.getMethod("setAttributes", String.class).invoke(it, (String) aText);
                                } catch (Exception ignore) {
                                }
                            }
                        } else {
                            Object aJson = meta.get("attributeJson");
                            if (aJson instanceof String && ((String) aJson).trim().length() > 0) {
                                boolean setDone = false;
                                try {
                                    OrderItem.class.getMethod("setAttributeJson", String.class).invoke(it, (String) aJson);
                                    setDone = true;
                                } catch (NoSuchMethodException nsme) {
                                    String[] alt = {"setAttribute_json", "setAttributesJson", "setAttributes"};
                                    for (String sname : alt) {
                                        try {
                                            OrderItem.class.getMethod(sname, String.class).invoke(it, (String) aJson);
                                            setDone = true;
                                            break;
                                        } catch (NoSuchMethodException nm) {
                                            /*continue*/ }
                                    }
                                } catch (Exception ex) {
                                    Logger.getLogger(cartServlet.class.getName()).log(Level.FINER, null, ex);
                                }
                                if (!setDone) {
                                    String pretty = prettyAttributeFromJson((String) aJson);
                                    try {
                                        OrderItem.class.getMethod("setAttributeText", String.class).invoke(it, pretty);
                                    } catch (Exception ignore) {
                                    }
                                }
                            }
                        }

                        try {
                            model.ProductVariant pv = new model.ProductVariant();
                            Object sku = meta.get("sku");
                            if (sku instanceof String) try {
                                model.ProductVariant.class.getMethod("setSku", String.class).invoke(pv, (String) sku);
                            } catch (Exception ignore) {
                            }
                            Object aJson2 = meta.get("attributeJson");
                            if (aJson2 instanceof String) try {
                                model.ProductVariant.class.getMethod("setAttributeJson", String.class).invoke(pv, (String) aJson2);
                            } catch (Exception ignore) {
                            }
                            Object img2 = meta.get("imageUrl");
                            if (img2 instanceof String) try {
                                model.ProductVariant.class.getMethod("setImageUrl", String.class).invoke(pv, (String) img2);
                            } catch (Exception ignore) {
                            }
                            Object vid = meta.get("variantId");
                            if (vid instanceof Number) try {
                                model.ProductVariant.class.getMethod("setVariantId", Long.class).invoke(pv, ((Number) vid).longValue());
                            } catch (Exception ignore) {
                            }
                            try {
                                OrderItem.class.getMethod("setVariant", model.ProductVariant.class).invoke(it, pv);
                            } catch (NoSuchMethodException ignore) {
                            }
                        } catch (Throwable t) {
                            Logger.getLogger(cartServlet.class.getName()).log(Level.FINER, null, t);
                        }
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(cartServlet.class.getName()).log(Level.FINE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(cartServlet.class.getName()).log(Level.FINER, null, ex);
                }

                displayItems.add(it);
            }

            List<UserAddress> addresses = addrDao.getAddressesByUser(userId);

            // NEW: set cartEmpty flag for JSP (useful for disabling checkout button)
            boolean cartEmpty = displayItems.isEmpty() || totalQty <= 0 || subtotal <= 0.0;
            request.setAttribute("cartEmpty", cartEmpty);
            request.setAttribute("cartItems", displayItems);
            request.setAttribute("addresses", addresses);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", request.getAttribute("tax") != null ? request.getAttribute("tax") : 0.0);

            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(cartServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("checkoutError", "Có lỗi khi tải giỏ hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(request, response);
        }
    }

    // POST: add / update / remove / checkout (DB-only cart)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (LOG.isLoggable(Level.INFO)) {
            LOG.info("[cart] session=" + (session == null ? "null" : session.getId()));
        }

        Users user = resolveUserFromSession(session);
        if (user == null) {
            String referer = request.getHeader("Referer");
            String returnTo = (referer != null) ? URLEncoder.encode(referer, "UTF-8") : "/";
            response.sendRedirect(request.getContextPath() + "/login?returnTo=" + returnTo);
            return;
        }

        int userId = user.getId();

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "add";
        }

        OrderCartDAO cartDao = new OrderCartDAO();
        OrderDAO orderDao = new OrderDAO();
        CartItemsDAO cartItemsDao = new CartItemsDAO();

        try {
            switch (action.toLowerCase()) {
                // add -> lưu trực tiếp vào CartItems table (insert hoặc update)
                case "add": {
                    String variantParam = request.getParameter("variantId");
                    String qtyParam = request.getParameter("quantity");
                    if (variantParam == null || variantParam.trim().isEmpty()) {
                        String refer = request.getHeader("Referer");
                        String referUrl = (refer != null) ? refer : request.getContextPath() + "/shop";
                        response.sendRedirect(referUrl + (referUrl.contains("?") ? "&" : "?")
                                + "addError=" + URLEncoder.encode("Vui lòng chọn biến thể.", "UTF-8"));
                        return;
                    }
                    long variantId = safeParseLong(variantParam, -1L);
                    int qty = safeParseInt(qtyParam, 1);
                    if (variantId <= 0) {
                        String refer = request.getHeader("Referer");
                        String referUrl = (refer != null) ? refer : request.getContextPath() + "/shop";
                        response.sendRedirect(referUrl + (referUrl.contains("?") ? "&" : "?")
                                + "addError=" + URLEncoder.encode("Số lượng/ID không hợp lệ.", "UTF-8"));
                        return;
                    }

                    // kiểm tra tồn kho (read-only)
                    int stock = cartDao.getVariantStock(variantId);
                    if (stock <= 0) {
                        String refer = request.getHeader("Referer");
                        String referUrl = (refer != null) ? refer : request.getContextPath() + "/shop";
                        response.sendRedirect(referUrl + (referUrl.contains("?") ? "&" : "?")
                                + "addError=" + URLEncoder.encode("Sản phẩm tạm hết hàng.", "UTF-8"));
                        return;
                    }

                    // get current DB qty for this user+variant
                    List<CartItem> dbItems = cartItemsDao.getCartItemsByUser((long) userId);
                    int existing = findQtyInList(dbItems, variantId);
                    int newQty = existing + qty;
                    if (newQty > stock) {
                        newQty = stock;
                    }

                    try {
                        if (existing > 0) {
                            cartItemsDao.updateCartItemQuantity((long) userId, variantId, newQty);
                        } else {
                            cartItemsDao.insertCartItem((long) userId, variantId, newQty);
                        }
                    } catch (SQLException sqle) {
                        Logger.getLogger(cartServlet.class.getName()).log(Level.WARNING, "[cart] Failed to persist cart item to CartItems table (non-fatal)", sqle);
                    }

                    // Recalculate cartCount from DB
                    int cartCount = 0;
                    try {
                        List<CartItem> after = cartItemsDao.getCartItemsByUser((long) userId);
                        if (after != null) {
                            for (CartItem c : after) {
                                if (c == null) {
                                    continue;
                                }
                                cartCount += c.getQuantity(); // getQuantity() is primitive int
                            }
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(cartServlet.class.getName()).log(Level.FINER, null, ex);
                    }

                    if (isAjax(request)) {
                        writeJson(response, "{\"success\":true,\"message\":\"Đã thêm vào giỏ hàng.\",\"cartCount\":" + cartCount + "}");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart?added=1");
                    }
                    return;
                }

                // update: update quantity in CartItems (no session, no legacy orderItem fallback)
                case "update": {
                    String variantParam = request.getParameter("variantId");
                    String qtyParam = request.getParameter("quantity");
                    int qty = safeParseInt(qtyParam, 1);

                    if (variantParam != null && !variantParam.trim().isEmpty()) {
                        long variantId = safeParseLong(variantParam, -1L);
                        if (variantId <= 0) {
                            response.sendRedirect(request.getContextPath() + "/cart");
                            return;
                        }
                        int stock2 = cartDao.getVariantStock(variantId);
                        if (qty > stock2) {
                            qty = stock2;
                        }

                        try {
                            cartItemsDao.updateCartItemQuantity((long) userId, variantId, qty);
                        } catch (SQLException sqle) {
                            Logger.getLogger(cartServlet.class.getName()).log(Level.WARNING, "[cart] Failed to update CartItems on update action (non-fatal)", sqle);
                        }

                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    } else {
                        // no variant specified -> nothing to do in DB-only mode
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                }

                // remove: remove from CartItems (DB)
                case "remove": {
                    String variantParam = request.getParameter("variantId");

                    if (variantParam != null && !variantParam.trim().isEmpty()) {
                        long variantId = safeParseLong(variantParam, -1L);
                        if (variantId <= 0) {
                            response.sendRedirect(request.getContextPath() + "/cart");
                            return;
                        }

                        try {
                            cartItemsDao.removeCartItem((long) userId, variantId);
                        } catch (SQLException sqle) {
                            Logger.getLogger(cartServlet.class.getName()).log(Level.WARNING, "[cart] Failed to remove CartItems entry on remove action (non-fatal)", sqle);
                        }

                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                }

                // checkout: delegate to OrderDAO.placeOrderFromCartItems(userId, shippingAddressId, paymentMethod)
                case "checkout": {
                    String addrParam = request.getParameter("shippingAddressId");
                    String paymentMethod = request.getParameter("paymentMethod");
                    long shippingAddressId = safeParseLong(addrParam, 0L);

                    // đọc danh sách từ DB
                    List<CartItem> dbItemsForCheckout = cartItemsDao.getCartItemsByUser((long) userId);
                    if (dbItemsForCheckout == null || dbItemsForCheckout.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode("Giỏ hàng rỗng.", "UTF-8"));
                        return;
                    }

                    // đảm bảo có ít nhất 1 item với quantity > 0
                    int totalQty = 0;
                    for (CartItem ci : dbItemsForCheckout) {
                        if (ci == null) {
                            continue;
                        }
                        int q = ci.getQuantity();
                        if (q > 0) {
                            totalQty += q;
                        }
                    }
                    if (totalQty <= 0) {
                        response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode("Giỏ hàng rỗng.", "UTF-8"));
                        return;
                    }

                    // validate địa chỉ giao hàng
                    if (shippingAddressId <= 0) {
                        response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode("Vui lòng chọn địa chỉ giao hàng hợp lệ.", "UTF-8"));
                        return;
                    }

                    long orderId = orderDao.placeOrderFromCartItems(userId, (int) shippingAddressId, paymentMethod);
                    Logger.getLogger(cartServlet.class.getName()).info("[cart] checkout completed orderId=" + orderId + " user=" + userId);

                    response.sendRedirect(request.getContextPath() + "/order/confirmation?orderId=" + orderId);
                    return;
                }

                default:
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
            }
        } catch (SQLException ex) {
            Logger.getLogger(cartServlet.class.getName()).log(Level.SEVERE, "DB error in cart action", ex);
            String msg = ex.getMessage() != null ? ex.getMessage() : "Lỗi hệ thống.";
            response.sendRedirect(request.getContextPath() + "/cart?error=" + URLEncoder.encode(msg, "UTF-8"));
        } catch (NumberFormatException nfe) {
            Logger.getLogger(cartServlet.class.getName()).log(Level.WARNING, "Invalid numeric param in cart action", nfe);
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}