<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.NumberFormat, java.util.Locale, java.lang.reflect.Method" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@include file="/WEB-INF/include/library.jsp" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%!
    // reflection helpers (unchanged)
    private Object tryGet(Object bean, String... methodNames) {
        if (bean == null) return null;
        Class<?> cls = bean.getClass();
        for (String mname : methodNames) {
            // try variants of method name
            String[] candidates = new String[] {
                "get" + Character.toUpperCase(mname.charAt(0)) + mname.substring(1),
                "get" + mname,
                "is" + Character.toUpperCase(mname.charAt(0)) + mname.substring(1),
                mname
            };
            for (String mm : candidates) {
                try {
                    Method m = cls.getMethod(mm);
                    if (m != null) {
                        Object val = m.invoke(bean);
                        if (val != null) return val;
                    }
                } catch (NoSuchMethodException nsme) {
                    // ignore
                } catch (Exception e) {
                    // ignore other reflection exceptions
                }
            }
        }
        return null;
    }

    private String safeString(Object bean, String... methodNames) {
        Object v = tryGet(bean, methodNames);
        return (v != null) ? String.valueOf(v) : null;
    }

    private Integer safeInteger(Object bean, String... methodNames) {
        Object v = tryGet(bean, methodNames);
        if (v == null) return null;
        if (v instanceof Number) return ((Number)v).intValue();
        try { return Integer.parseInt(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    private Long safeLong(Object bean, String... methodNames) {
        Object v = tryGet(bean, methodNames);
        if (v == null) return null;
        if (v instanceof Number) return ((Number)v).longValue();
        try { return Long.parseLong(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    private Double safeDouble(Object bean, String... methodNames) {
        Object v = tryGet(bean, methodNames);
        if (v == null) return null;
        if (v instanceof Number) return ((Number)v).doubleValue();
        try { return Double.parseDouble(String.valueOf(v)); } catch (Exception e) { return null; }
    }

    // Pretty-print simple JSON-like attribute strings: {"weight":"1kg","color":"Red"}
    private String prettyAttributeFromJson(String raw) {
        if (raw == null) return null;
        String s = raw.trim();
        if (s.startsWith("{") && s.endsWith("}")) {
            s = s.substring(1, s.length()-1);
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
                    String label = key.substring(0,1).toUpperCase() + (key.length()>1 ? key.substring(1) : "");
                    out.add(label + ": " + val);
                }
            } else {
                if (!p.trim().isEmpty()) out.add(p.trim());
            }
        }
        return String.join(", ", out);
    }

    // Simple HTML escape to avoid injecting raw JSON into page
    private String escapeHtml(String s) {
        if (s == null) return null;
        StringBuilder sb = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&': sb.append("&amp;"); break;
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#x27;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }

    private String formatVNDServer(Double v) {
        if (v == null) return "0₫";
        NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
        return nf.format(v) + "₫";
    }
%>

<% 
    boolean debug = request.getParameter("debug") != null;
%>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Giỏ hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .item-img { width: 72px; height: 72px; object-fit: cover; border-radius: 6px; }
        .muted { color: #6b7280; }
        .summary-box { position: sticky; top: 20px; }
        .small-muted { font-size: .9rem; color: #6b7280; display:block; margin-top:4px; }
        pre.debug { background:#f8f9fa; border:1px solid #e9ecef; padding:12px; overflow:auto; max-height:300px; }
    </style>
</head>
<body>
    

    <div class="max-w-6xl mx-auto p-6">
        <h1 class="text-3xl font-bold mb-6">Giỏ hàng của bạn</h1>

        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            <div class="lg:col-span-3 bg-white p-4 rounded shadow">
                <%
                    Object rawCart = request.getAttribute("cartItems");
                    if (rawCart == null) {
                %>
                    <p class="text-gray-500">Giỏ hàng rỗng. <a href="<%= request.getContextPath() %>/shop" class="text-blue-600">Tiếp tục mua sắm</a></p>
                <%
                    } else {
                        List<?> cartList = null;
                        if (rawCart instanceof List) cartList = (List<?>) rawCart;
                        else if (rawCart instanceof Collection) cartList = new ArrayList<>((Collection<?>)rawCart);
                        else if (rawCart.getClass().isArray()) cartList = Arrays.asList((Object[]) rawCart);

                        if (cartList == null || cartList.isEmpty()) {
                %>
                    <p class="text-gray-500">Giỏ hàng rỗng. <a href="<%= request.getContextPath() %>/shop" class="text-blue-600">Tiếp tục mua sắm</a></p>
                <%
                        } else {
                %>
                    <table class="w-full">
                        <thead>
                            <tr class="text-left text-sm text-gray-600 border-b">
                                <th class="py-2">Sản phẩm</th>
                                <th class="py-2">Giá</th>
                                <th class="py-2">Số lượng</th>
                                <th class="py-2">Tổng</th>
                                <th class="py-2">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                <%
                            int idx=0;
                            StringBuilder pageDebug = new StringBuilder();
                            for (Object it : cartList) {
                                idx++;
                                Class<?> cls = (it==null)?null:it.getClass();
                                String className = (cls!=null)?cls.getName():"null";
                                StringBuilder methodsSb = new StringBuilder();
                                if (cls != null) {
                                    for (Method m : cls.getMethods()) {
                                        String mn = m.getName();
                                        if ((mn.startsWith("get") || mn.startsWith("is")) && m.getParameterCount()==0) {
                                            methodsSb.append(mn).append(", ");
                                        }
                                    }
                                }
                                String pname = safeString(it, "productName","product_name","title","product", "productTitle");
                                String simpleName = safeString(it, "name","itemName");
                                String img = safeString(it, "imageUrl","image_url","thumbnailUrl","thumbnail");
                                String qty = safeString(it, "quantity","qty");
                                String unitPrice = safeString(it, "unitPrice","price");
                                Object variantObj = tryGet(it, "variant", "productVariant", "getVariant", "getProductVariant");
                                String variantSku = (variantObj!=null)?safeString(variantObj, "sku","SKU","code"):null;
                                String attrJson = (variantObj!=null)?safeString(variantObj, "attributeJson","attribute_json","attributejson"):null;

                                // NEW: get variantId from item (preferred) or from variantObj
                                Long variantIdLong = safeLong(it, "variantId", "variant_id", "getVariantId");
                                if (variantIdLong == null && variantObj != null) {
                                    variantIdLong = safeLong(variantObj, "variantId", "variant_id", "getVariantId");
                                }
                                String variantIdStr = (variantIdLong != null) ? variantIdLong.toString() : "";

                                String debugLine = String.format("cartItems[%d] class=%s; getters=[%s]; pname=%s; simpleName=%s; qty=%s; unitPrice=%s; variantSku=%s; attrJson=%s; variantId=%s",
                                        idx, className, methodsSb.toString(), pname, simpleName, qty, unitPrice, variantSku, attrJson, variantIdStr);
                                System.out.println("[CART-DEBUG] " + debugLine);
                                if (debug) pageDebug.append(debugLine).append("\n");

                                String displayName = (pname!=null && pname.trim().length()>0) ? pname
                                        : (simpleName!=null && simpleName.trim().length()>0) ? simpleName
                                        : (variantSku!=null && variantSku.trim().length()>0) ? variantSku
                                        : "[Tên sản phẩm không xác định]";

                                String imgSrc = request.getContextPath() + "/assets/img/no-image.png";
                                if (img != null && img.trim().length() > 0) {
                                    if (img.startsWith("http")) {
                                        imgSrc = img;
                                    } else if (img.startsWith("/")) {
                                        imgSrc = request.getContextPath() + img; // img already contains leading '/'
                                    } else {
                                        // common stored filename like 'ganadorchickern.jpg' -> serve via /images/* servlet
                                        imgSrc = request.getContextPath() + "/images/" + img;
                                    }
                                }
                                double unit = 0;
                                try { unit = (unitPrice!=null)?Double.parseDouble(unitPrice):0; } catch(Exception e){}
                                int q = 1;
                                try { q = (qty!=null)?Integer.parseInt(qty):1; } catch(Exception e){}
                                double lineTotal = unit * q;
                %>
                            <tr class="align-top border-b" data-variant-id="<%= variantIdStr.isEmpty()? "idx-" + idx : variantIdStr %>">
                                <td class="py-4">
                                    <div class="flex items-center gap-4">
                                        <div>
                                            <img src="<%= imgSrc %>" alt="<%= escapeHtml(displayName) %>" class="item-img" onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/assets/img/no-image.png'"/>
                                        </div>
                                        <div>
                                            <div class="font-semibold"><%= escapeHtml(displayName) %></div>
                                            <% if (attrJson != null && attrJson.trim().length()>0) { %>
                                                <div class="small-muted"><%= escapeHtml(prettyAttributeFromJson(attrJson)) %></div>
                                            <% } %>
                                        </div>
                                    </div>
                                </td>

                                <td class="py-4" data-unit="<%= unit %>">
                                    <div class="unit-price"><%= (unit>0? new java.text.DecimalFormat("#,###").format(unit) + "₫" : "0₫") %></div>
                                </td>

                                <td class="py-4">
                                    <form method="post" action="<%= request.getContextPath() %>/cart" class="inline-flex items-center update-qty-form" style="gap:.5rem" data-variant-id="<%= variantIdStr.isEmpty()? "idx-" + idx : variantIdStr %>">
                                        <input type="hidden" name="action" value="update"/>
                                        <%-- send variantId (preferred) so servlet updates DB CartItems --%>
                                        <input type="hidden" name="variantId" value="<%= variantIdStr %>"/>
                                        <%-- fallback (legacy) keep orderItemId too but with idx so legacy code can still use --%>
                                        <input type="hidden" name="orderItemId" value="<%= idx %>"/>
                                        <input type="number" name="quantity" value="<%= q %>" min="1" class="qty-input w-20 border rounded px-2 py-1" data-variant-id="<%= variantIdStr.isEmpty()? "idx-" + idx : variantIdStr %>"/>
                                    </form>
                                </td>

                                <td class="py-4 font-semibold">
                                    <span class="line-total"><%= new java.text.DecimalFormat("#,###").format(lineTotal) %>₫</span>
                                </td>

                                <td class="py-4">
                                    <form method="post" action="<%= request.getContextPath() %>/cart">
                                        <input type="hidden" name="action" value="remove"/>
                                        <input type="hidden" name="variantId" value="<%= variantIdStr %>"/>
                                        <button type="button" onclick="if (confirm('Xác nhận xóa sản phẩm khỏi giỏ?')) this.form.submit();" class="bg-red-50 text-red-600 px-3 py-1 rounded">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                <%
                            } // end for
                            if (debug) {
                %>
                        </tbody>
                    </table>

                    <h3 class="mt-6">Debug output (also logged to catalina.out with prefix [CART-DEBUG])</h3>
                    <pre class="debug"><%= pageDebug.toString() %></pre>
                <%
                            } else {
                %>
                        </tbody>
                    </table>
                <%
                            } // end debug conditional
                        } // end cart not empty
                    } // end rawCart null check
                %>
            </div>

            <div class="lg:col-span-1 bg-white p-4 rounded shadow summary-box">
                <h3 class="font-semibold mb-3">Tổng kết đơn hàng</h3>

                <!-- Simplified checkout area: no address inputs here, direct user to /checkout to select / enter address -->
                <c:choose>
                    <c:when test="${cartEmpty}">
                        <div class="flex justify-between mb-2">
                            <span class="muted">Tạm tính</span>
                            <span id="subtotal" class="font-medium">
                                <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫
                            </span>
                        </div>

                        <div class="flex justify-between mb-2">
                            <span class="muted">Phí vận chuyển</span>
                            <span id="shippingCost" class="font-medium text-gray-700">
                                <fmt:formatNumber value="30000" type="number" groupingUsed="true"/>₫
                            </span>
                        </div>

                        <div class="border-t mt-3 pt-3 flex justify-between items-center text-lg font-bold">
                            <span>Tổng</span>
                            <span class="text-red-600" id="grandTotal">
                                <fmt:formatNumber value="${subtotal + 30000}" type="number" groupingUsed="true"/>₫
                            </span>
                        </div>

                        <div class="mt-4 space-y-2">
                            <button type="button" id="checkoutBtn" class="w-full block bg-gray-300 text-white py-2 rounded" disabled>Thanh toán</button>
                            <div class="text-sm text-gray-600 text-center pt-2">Giỏ hàng rỗng — vui lòng thêm sản phẩm trước khi thanh toán.</div>
                            <a href="${pageContext.request.contextPath}/shop" class="block text-center bg-gray-100 text-gray-800 py-2 rounded border">Tiếp tục mua sắm</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form id="cartCheckoutForm" method="get" action="${pageContext.request.contextPath}/checkout">

                            <div class="flex justify-between mb-2">
                                <span class="muted">Tạm tính</span>
                                <span id="subtotal" class="font-medium">
                                    <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>

                            <div class="flex justify-between mb-2">
                                <span class="muted">Phí vận chuyển</span>
                                <span id="shippingCost" class="font-medium text-gray-700">
                                    <fmt:formatNumber value="30000" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>

                            <div class="border-t mt-3 pt-3 flex justify-between items-center text-lg font-bold">
                                <span>Tổng</span>
                                <span class="text-red-600" id="grandTotal">
                                    <fmt:formatNumber value="${subtotal + 30000}" type="number" groupingUsed="true"/>₫
                                </span>
                            </div>

                            <input type="hidden" name="shipping" value="30000"/>
                            <div class="mt-4 space-y-2">
                                <button type="submit" id="checkoutBtn" class="w-full block bg-blue-600 text-white py-2 rounded">Thanh toán</button>
                                <a href="${pageContext.request.contextPath}/shop" class="block text-center bg-gray-100 text-gray-800 py-2 rounded border">Tiếp tục mua sắm</a>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>

    <script>
        const SHIPPING = 30000;

        function formatVND(n) {
            if (!isFinite(n)) return '0₫';
            return Number(n).toLocaleString('vi-VN') + '₫';
        }

        function recalcTotals() {
            const rows = document.querySelectorAll('tr[data-variant-id]');
            let subtotal = 0;
            rows.forEach(row => {
                const unit = Number(row.querySelector('[data-unit]')?.getAttribute('data-unit')) || 0;
                const qtyInput = row.querySelector('.qty-input');
                const qty = qtyInput ? Math.max(1, Number(qtyInput.value) || 1) : 1;
                const lineTotal = unit * qty;

                const unitPriceEl = row.querySelector('.unit-price');
                const lineEl = row.querySelector('.line-total');

                if (unitPriceEl) unitPriceEl.textContent = formatVND(unit);
                if (lineEl) lineEl.textContent = formatVND(lineTotal);

                subtotal += lineTotal;
            });

            const subtotalEl = document.getElementById('subtotal');
            const grandEl = document.getElementById('grandTotal');
            const shippingEl = document.getElementById('shippingCost');

            if (subtotalEl) subtotalEl.textContent = formatVND(subtotal);
            if (shippingEl) shippingEl.textContent = formatVND(SHIPPING);
            if (grandEl) grandEl.textContent = formatVND(subtotal + SHIPPING);
        }

        function debounce(fn, ms) {
            let t;
            return function() {
                clearTimeout(t);
                t = setTimeout(() => fn.apply(this, arguments), ms);
            };
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.qty-input').forEach(input => {
                input.addEventListener('input', debounce(() => recalcTotals(), 120));
                input.addEventListener('blur', function () {
                    recalcTotals();
                    const form = this.closest('.update-qty-form');
                    if (form) setTimeout(() => form.submit(), 150);
                });
                input.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        const form = this.closest('.update-qty-form');
                        if (form) form.submit();
                    }
                });
            });

            recalcTotals();
        });
    </script>
</body>
</html>