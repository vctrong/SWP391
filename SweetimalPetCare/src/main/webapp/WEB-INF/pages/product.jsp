<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="model.Product, model.ProductVariant, model.ProductImg, model.Review, java.util.*, java.text.NumberFormat, java.util.Locale, java.net.URLEncoder"%>
<%@include file="/WEB-INF/include/library.jsp" %>

<%!
    // Simple HTML escaper
    private String escapeHtml(String s) {
        if (s == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '&':
                    sb.append("&amp;");
                    break;
                case '<':
                    sb.append("&lt;");
                    break;
                case '>':
                    sb.append("&gt;");
                    break;
                case '"':
                    sb.append("&quot;");
                    break;
                case '\'':
                    sb.append("&#x27;");
                    break;
                default:
                    sb.append(c);
            }
        }
        return sb.toString();
    }

    // Normalize comment: convert CRLF/CR to LF, collapse multiple blank lines, trim ends
    private String normalizeComment(String s) {
        if (s == null) {
            return "";
        }
        s = s.replaceAll("\\r\\n?", "\n");
        s = s.replaceAll("\\n\\s*\\n+", "\n\n");
        s = s.replaceAll("^[\\s\\u00A0]+", "");
        s = s.replaceAll("[\\s\\u00A0]+$", "");
        return s;
    }

    // Pretty-print simple JSON-like attribute strings: {"weight":"1kg","color":"Red"}
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
        java.util.List<String> out = new java.util.ArrayList<>();
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

    // Extract a single attribute value by key (case-insensitive) from JSON-like string
    private String extractAttrValue(String raw, String key) {
        if (raw == null || key == null) {
            return null;
        }
        String s = raw.trim();
        if (s.startsWith("{") && s.endsWith("}")) {
            s = s.substring(1, s.length() - 1);
        }
        s = s.replaceAll("\"", "");
        String[] parts = s.split("\\s*,\\s*");
        for (String p : parts) {
            String[] kv = p.split("\\s*[:=]\\s*", 2);
            if (kv.length == 2) {
                String k = kv[0].trim();
                String v = kv[1].trim();
                if (k.equalsIgnoreCase(key)) {
                    return v;
                }
            }
        }
        return null;
    }

    // Escape a string for safe insertion into a JS double-quoted string literal
    private String jsEscape(String s) {
        if (s == null) {
            return "";
        }
        String out = s;
        out = out.replace("\\", "\\\\");
        out = out.replace("\"", "\\\"");
        out = out.replace("'", "\\'");
        out = out.replace("\n", "\\n").replace("\r", "\\r");
        return out;
    }
%>

<%
    // --- server-side data ---
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    List<ProductImg> productImages = (List<ProductImg>) request.getAttribute("productImages");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Boolean userHasPurchasedAttr = (Boolean) request.getAttribute("userHasPurchased");
    Boolean userHasReviewedAttr = (Boolean) request.getAttribute("userHasReviewed");
    boolean userHasPurchased = userHasPurchasedAttr != null ? userHasPurchasedAttr.booleanValue() : false;
    boolean userHasReviewed = userHasReviewedAttr != null ? userHasReviewedAttr.booleanValue() : false;

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
    double defaultPrice = 0;
    if (product != null && product.getMainVariant() != null) {
        defaultPrice = product.getMainVariant().getPrice();
    }

    // For client-side initial selection
    double minPrice = defaultPrice;
    ProductVariant minPriceVariant = null;
    if (variants != null && !variants.isEmpty()) {
        minPrice = Double.MAX_VALUE;
        for (ProductVariant v : variants) {
            if (v.getPrice() < minPrice) {
                minPrice = v.getPrice();
                minPriceVariant = v;
            }
        }
        defaultPrice = minPrice;
    }

    boolean loggedIn = (session.getAttribute("user") != null)
            || (request.getUserPrincipal() != null);
    request.setAttribute("loggedIn", Boolean.valueOf(loggedIn));

    String currentUrl = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
    String encodedRedirect = "/";
    try {
        encodedRedirect = URLEncoder.encode(currentUrl, "UTF-8");
    } catch (Exception e) {
        encodedRedirect = "/";
    }
    request.setAttribute("encodedRedirect", encodedRedirect);
%>

<%-- Use sessionScope.user as the single source of truth --%>
<c:set var="effectiveUser" value="${sessionScope.user}" />
<c:set var="isLoggedIn" value="${not empty effectiveUser}" />
<c:if test="${isLoggedIn}">
    <c:set var="currentUserId" value="${effectiveUser.id}" />
    <c:set var="isCustomer" value="${effectiveUser.role == 1}" />
    <c:set var="isStaff" value="${effectiveUser.role != 1}" />
</c:if>
<c:if test="${not isLoggedIn}">
    <c:set var="currentUserId" value="${null}" />
    <c:set var="isCustomer" value="false" />
    <c:set var="isStaff" value="false" />
</c:if>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <title><%= (product != null) ? product.getProductName() : "Sản phẩm"%></title>

        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .rating-stars i {
                font-size: 20px;
                margin-right: 6px;
                vertical-align: middle;
            }
            .rating-value {
                margin-left: 8px;
                color: #4b5563;
            }
            .item-img {
                width: 72px;
                height: 72px;
                object-fit: cover;
                border-radius: 6px;
            }
            .muted {
                color: #6b7280;
            }
            .summary-box {
                position: sticky;
                top: 20px;
            }
            .small-muted {
                font-size: .9rem;
                color: #6b7280;
                display:block;
                margin-top:4px;
            }
            .out-of-stock::after {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: red;
                transform: rotate(-20deg);
            }
            .reply-actions button {
                margin-right: 8px;
            }
            .reply-box {
                background:#fbfbfb;
                border:1px solid #e6e6e6;
                padding:16px;
                border-radius:6px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/include/header.jsp" %>
        <c:if test="${not empty param.addError}">
            <script>
                document.addEventListener('DOMContentLoaded', function(){
            var msg = '<c:out value="${param.addError}" escapeXml="true"/>';
                if (msg && msg.trim().length > 0) {
                var id = 'serverFlashAddError';
                var el = document.getElementById(id);
                if (!el) {
                el = document.createElement('div');
                el.id = id;
                el.style.position = 'fixed';
                el.style.top = '84px';
                el.style.right = '20px';
                el.style.zIndex = 99999;
                el.style.padding = '10px 14px';
                el.style.borderRadius = '6px';
                el.style.color = '#fff';
                el.style.maxWidth = '380px';
                el.style.boxShadow = '0 6px 20px rgba(0,0,0,.12)';
                el.style.background = '#ef4444';
                document.body.appendChild(el);
                }
                el.textContent = msg.replace(/\+/g, ' ');
                setTimeout(function(){ try{ el.style.opacity = '0'; setTimeout(function(){ el.remove(); }, 400); } catch (e){} }, 4200);
                }
                });
            </script>
        </c:if>
        <div class="max-w-6xl mx-auto p-6">
            <div class="text-sm text-gray-500 mb-6 font-medium">
                <a href="${pageContext.request.contextPath}/shop" class="hover:text-red-500 transition">🏠 Trang Chủ</a> ›
                <span class="text-gray-700"><%= (product != null) ? product.getProductName() : "Không tìm thấy"%></span>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-start">

                <div class="flex flex-col items-center">
                    <div class="relative w-full h-96 bg-white rounded-2xl shadow-lg overflow-hidden">
                        <%
                            String mainSrc = request.getContextPath() + "/assets/img/no-image.png";
                            if (productImages != null && !productImages.isEmpty()) {
                                String first = productImages.get(0).getImageUrl();
                                if (first != null && !first.trim().isEmpty()) {
                                    if (first.startsWith("/")) {
                                        mainSrc = request.getContextPath() + first;
                                    } else {
                                        mainSrc = request.getContextPath() + "/images/" + first;
                                    }
                                }
                            }
                        %>
                        <img id="mainImg"
                             src="<%= mainSrc%>"
                             alt="<%= (product != null) ? product.getProductName() : "Không có hình ảnh"%>"
                             class="w-full h-full object-contain transition-all duration-500 ease-in-out opacity-100">
                        <button type="button" class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/70 hover:bg-white text-gray-800 rounded-full w-8 h-8 flex items-center justify-center shadow-md" onclick="prevImage()">&#10094;</button>
                        <button type="button" class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/70 hover:bg-white text-gray-800 rounded-full w-8 h-8 flex items-center justify-center shadow-md" onclick="nextImage()">&#10095;</button>
                    </div>

                    <c:if test="${not empty productImages}">
                        <div class="flex gap-2 mt-3 justify-center flex-wrap">
                            <c:forEach var="img" items="${productImages}" varStatus="loop">
                                <c:choose>
                                    <c:when test="${loop.index == 0}">
                                        <c:set var="thumbBorder" value="border-red-500" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="thumbBorder" value="border-gray-200" />
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${fn:startsWith(img.imageUrl, '/')}">
                                        <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="${img.caption}"
                                             class="thumb w-16 h-16 object-cover rounded-lg cursor-pointer border-2 ${thumbBorder} hover:border-red-400 transition duration-300"
                                             data-index="${loop.index}" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/${img.imageUrl}" alt="${img.caption}"
                                             class="thumb w-16 h-16 object-cover rounded-lg cursor-pointer border-2 ${thumbBorder} hover:border-red-400 transition duration-300"
                                             data-index="${loop.index}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <div class="bg-white p-8 rounded-2xl shadow-lg border border-gray-100">
                    <h1 id="productTitle" class="text-3xl font-bold text-gray-900 leading-tight">
                        <%= (product != null) ? product.getProductName() : "Không có sản phẩm"%>
                    </h1>

                    <%
                        Number avgAttr = null;
                        Object rawAvg = request.getAttribute("avgRating");
                        if (rawAvg instanceof Number) {
                            avgAttr = (Number) rawAvg;
                        }
                        double avgRating = avgAttr != null ? avgAttr.doubleValue() : 0.0;
                        if (avgRating < 0) {
                            avgRating = 0.0;
                        }
                        if (avgRating > 5)
                            avgRating = 5.0;
                    %>

                    <div class="flex items-center mt-2">
                        <span class="rating-stars" role="img" aria-label="<%= String.format(Locale.forLanguageTag("vi-VN"), "%.1f/5", avgRating)%>">
                            <%
                                for (int i = 1; i <= 5; i++) {
                                    if (avgRating >= i) {
                            %>
                            <i class="fa-solid fa-star" style="color:#f59e0b" aria-hidden="true"></i>
                            <%
                            } else if (avgRating >= i - 0.5) {
                            %>
                            <i class="fa-solid fa-star-half-stroke" style="color:#f59e0b" aria-hidden="true"></i>
                            <%
                            } else {
                            %>
                            <i class="fa-regular fa-star" style="color:#e5e7eb" aria-hidden="true"></i>
                            <%
                                    }
                                }
                            %>
                        </span>

                        <span class="rating-value"><%= String.format(Locale.forLanguageTag("vi-VN"), "%.1f", avgRating)%>/5</span>
                    </div>

                    <p class="text-gray-600 mt-2 text-lg">
                        Thương hiệu: <%= (product != null && product.getBrandName() != null) ? product.getBrandName() : "N/A"%>
                    </p>

                    <%-- Show simple attribute summary (same style as cart) --%>
                    <%
                        String primaryAttrJson = null;
                        if (minPriceVariant != null && minPriceVariant.getAttributeJson() != null && !minPriceVariant.getAttributeJson().trim().isEmpty()) {
                            primaryAttrJson = minPriceVariant.getAttributeJson();
                        } else if (product != null && product.getMainVariant() != null && product.getMainVariant().getAttributeJson() != null) {
                            primaryAttrJson = product.getMainVariant().getAttributeJson();
                        }
                    %>
                    <%-- small attribute summary removed per request --%>

                    <%-- Attributes, price, add to cart, etc. --%>
                    <% if (variants != null && !variants.isEmpty()) { %>
                    <%-- Build attribute groups and price/stock maps server-side as before --%>
                    <%
                        Map<String, List<String>> attrMap = new LinkedHashMap<>();
                        Map<String, Double> priceMap = new HashMap<>();
                        Map<String, Integer> stockMap = new HashMap<>();
                        for (ProductVariant v : variants) {
                            String attrStr = v.getAttributeJson();
                            int qty = v.getStockQuantity();
                            double price = v.getPrice();
                            if (attrStr != null && !attrStr.isEmpty()) {
                                try {
                                    String cleaned = attrStr.replaceAll("[{}\"]", "");
                                    String[] pairs = cleaned.split("\\s*,\\s*");
                                    for (String p : pairs) {
                                        String[] kv = p.split("\\s*[:=]\\s*", 2);
                                        if (kv.length == 2) {
                                            String key = kv[0].trim();
                                            String val = kv[1].trim();
                                            if (key.isEmpty() || val.isEmpty()) {
                                                continue;
                                            }
                                            String displayKey = key.substring(0, 1).toUpperCase() + (key.length() > 1 ? key.substring(1).toLowerCase() : "");
                                            if (!attrMap.containsKey(displayKey)) {
                                                attrMap.put(displayKey, new ArrayList<String>());
                                            }
                                            if (!attrMap.get(displayKey).contains(val)) {
                                                attrMap.get(displayKey).add(val);
                                            }
                                            stockMap.put(displayKey + ":" + val, qty);
                                            priceMap.put(displayKey + ":" + val, price);
                                        }
                                    }
                                } catch (Exception e) {
                                    // ignore parsing errors
                                }
                            }
                        }
                    %>

                    <% for (Map.Entry<String, List<String>> entry : attrMap.entrySet()) {
                            String attrName = entry.getKey();
                            List<String> values = entry.getValue();
                            // normalized key used for ids and data attributes: lowercase, non-alphanum -> '-'
                            String attrKeyLower = attrName.toLowerCase();
                            String safeKey = attrKeyLower.replaceAll("[^A-Za-z0-9]+", "-");
                            String initSelectedVal = (minPriceVariant != null && minPriceVariant.getAttributeJson() != null) ? extractAttrValue(minPriceVariant.getAttributeJson(), attrKeyLower) : null;
                    %>
                    <div class="mb-4">
                        <p class="font-semibold text-gray-700 text-lg mb-2">
                            <%= attrName%>:
                            <span id="selected-<%= safeKey%>" class="text-red-500 font-medium"><%= (initSelectedVal != null) ? initSelectedVal : values.get(0)%></span>
                        </p>

                        <div class="flex flex-wrap gap-3">
                            <% for (String val : values) {
                                    String key = attrName + ":" + val;
                                    boolean outOfStock = stockMap.getOrDefault(key, 1) <= 0;
                                    double priceForVal = priceMap.getOrDefault(key, minPrice);
                                    String safeAttrName = safeKey.replace("'", "\\'");
                                    String safeVal = val.replace("'", "\\'");
                            %>
                            <button type="button"
                                    class="attr-btn relative border rounded-lg px-4 py-2 hover:bg-gray-100 transition select-none <%= outOfStock ? "opacity-50 border-gray-300 out-of-stock" : ""%>"
                                    data-attr-name="<%= safeAttrName%>"
                                    data-attr-value="<%= safeVal%>"
                                    data-price="<%= priceForVal%>">
                                <%= val%>
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <% }%>

                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(minPrice)%>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>
                    <% } else {%>
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(defaultPrice)%>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>
                    <% }%>

                    <%-- Quantity and add to cart (same as before) --%>
                    <div class="mt-6 space-y-4">
                        <div class="flex items-center gap-4">
                            <p class="font-semibold text-gray-700">Số lượng:</p>
                            <div id="qtyWrap" class="flex items-center border-2 border-gray-200 rounded-xl overflow-hidden relative z-10">
                                <button id="btnDec" data-action="dec" class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" type="button">−</button>
                                <input id="qty" type="text" value="1" class="w-16 text-center font-bold text-lg border-0 focus:outline-none" oninput="handleQtyInput(event)">
                                <button id="btnInc" data-action="inc" class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" type="button">+</button>
                            </div>
                            <div id="qtyAlert" class="text-sm text-red-500 ml-3 hidden"></div>
                        </div>

                        <div class="text-lg font-semibold text-gray-800">
                            Tổng số tiền:
                            <span id="totalPrice" class="text-red-500"><%= currencyFormat.format(defaultPrice)%>₫</span>
                        </div>
                    </div>

                    <!-- Add-to-cart form (non-AJAX fallback) shown only to customers -->
                    <c:choose>
                        <c:when test="${isCustomer}">
                            <form id="addToCartForm" method="post" action="<%= request.getContextPath()%>/cart" class="mt-8">
                                <input type="hidden" name="action" value="add" />
                                <input type="hidden" id="hiddenVariantId" name="variantId" value="<%= (minPriceVariant != null ? minPriceVariant.getVariantId() : (product != null && product.getMainVariant() != null ? product.getMainVariant().getVariantId() : 0))%>" />
                                <input type="hidden" id="hiddenQuantity" name="quantity" value="1" />
                                <button id="addToCartBtn" type="button" onclick="addToCartAjax();" class="w-full bg-red-500 text-white py-3 rounded-lg font-semibold hover:bg-red-600 transition">Thêm vào giỏ hàng</button>
                            </form>
                        </c:when>
                        <c:when test="${isLoggedIn and not isCustomer}">
                            <div class="mt-8">
                                <button class="w-full bg-gray-300 text-gray-700 py-3 rounded-lg font-semibold" disabled>Thêm vào giỏ hàng</button>
                                <p class="text-sm text-gray-500 mt-2">Tính năng mua hàng chỉ dành cho khách hàng. Vui lòng sử dụng tài khoản khách hàng để mua hàng.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mt-8">
                                <a href="${pageContext.request.contextPath}/login?redirect=${encodedRedirect}" class="w-full inline-block text-center bg-yellow-400 text-white py-3 rounded-lg font-semibold hover:bg-yellow-500">🔐 Đăng nhập để mua hàng</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Description & Reviews -->
            <div class="mt-12 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <div class="flex gap-6 border-b mb-4">
                    <button class="tab-btn font-semibold pb-2 border-b-2 border-red-500 text-red-500" data-tab="desc">📝 Mô tả</button>
                    <button class="tab-btn font-semibold pb-2 text-gray-500 hover:text-red-500" data-tab="reviews">⭐ Phản hồi</button>
                </div>

                <div id="tab-desc" class="tab-content">
                    <p class="text-gray-700 leading-relaxed text-lg">
                        <%= (product != null && product.getDescription() != null) ? product.getDescription() : "Chưa có mô tả cho sản phẩm này."%>
                    </p>
                </div>

                <div id="tab-reviews" class="tab-content hidden">
                    <h3 class="text-lg font-bold mb-3">Khách hàng đánh giá</h3>

                    <!-- show server messages if any -->
                    <c:if test="${not empty sessionScope.reviewSuccess}">
                        <div class="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 rounded">
                            ${sessionScope.reviewSuccess}
                        </div>
                        <c:remove var="reviewSuccess" scope="session" />
                    </c:if>

                    <c:if test="${not empty sessionScope.reviewError}">
                        <div class="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded">
                            ${sessionScope.reviewError}
                        </div>
                        <c:remove var="reviewError" scope="session" />
                    </c:if>

                    <div id="reviewsList">
                        <c:if test="${not empty reviews}">
                            <c:forEach var="r" items="${reviews}">
                                <div class="border-b py-6" id="review-block-${r.reviewId}">
                                    <div class="flex justify-between items-start">
                                        <div>
                                            <div class="font-semibold text-lg">${fn:escapeXml(r.userName)}</div>
                                            <div class="text-yellow-500 mt-1"><c:forEach begin="1" end="${r.rating}">★</c:forEach></div>
                                            </div>
                                            <div class="text-xs text-gray-400"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </div>

                                    <%
                                        // Use pageContext to access the current 'r' object safely inside scriptlet
                                        Object rObj = pageContext.getAttribute("r");
                                        String rawComment = "";
                                        if (rObj != null) {
                                            try {
                                                rawComment = ((model.Review) rObj).getComment();
                                            } catch (Exception ex) {
                                                rawComment = String.valueOf(rObj);
                                            }
                                        }
                                        String safe = normalizeComment(rawComment);
                                    %>
                                    <p class="text-gray-700 mt-4 whitespace-pre-wrap"><%= escapeHtml(safe)%></p>

                                    <!-- ===== Product review: reply section ===== -->
                                    <c:set var="reply" value="${(not empty repliesMap) ? repliesMap[r.reviewId] : null}" />
                                    <c:choose>
                                        <c:when test="${empty reply}">
                                            <!-- SHOW reply form only to STAFF/ADMIN/VET (non-customer) -->
                                            <c:if test="${isStaff}">
                                                <div class="mt-6 reply-box">
                                                    <form method="post" action="${pageContext.request.contextPath}/product/review" class="space-y-3" id="reply-create-form-${r.reviewId}">
                                                        <input type="hidden" name="productId" value="${product.productId}" />
                                                        <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                        <input type="hidden" name="action" value="replyCreate" />
                                                        <label class="text-sm text-gray-600 font-medium mb-1">Phản hồi từ nhân viên</label>
                                                        <textarea name="replyContent" rows="4" maxlength="1000" class="w-full border rounded p-2" placeholder="Nhập phản hồi..."></textarea>
                                                        <div class="flex items-center gap-3">
                                                            <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded shadow-sm">Gửi phản hồi</button>
                                                            <button type="button" onclick="document.getElementById('reply-create-form-${r.reviewId}').querySelector('textarea').value = '';" class="px-4 py-2 bg-gray-200 rounded">Hủy</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="mt-6 reply-box" id="reply-container-${r.reviewId}">
                                                <div class="text-sm text-gray-600 font-medium mb-2">Phản hồi từ nhân viên</div>
                                                <div id="reply-view-${r.reviewId}" class="whitespace-pre-wrap text-gray-800">${fn:escapeXml(reply.replyContent)}</div>
                                                <div class="text-xs text-gray-400 mt-2"><fmt:formatDate value="${reply.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>

                                                <div class="mt-3 reply-actions">
                                                    <c:if test="${isStaff}">
                                                        <button type="button" class="px-4 py-2 bg-green-500 text-white rounded" onclick="startEditReply(${r.reviewId});">Cập nhật</button>

                                                        <form method="post" action="${pageContext.request.contextPath}/product/review" style="display:inline">
                                                            <input type="hidden" name="action" value="replyDelete" />
                                                            <input type="hidden" name="productId" value="${product.productId}" />
                                                            <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                            <button type="button" onclick="if (confirm('Xóa phản hồi này?')) this.form.submit();" class="px-4 py-2 bg-red-600 text-white rounded">Xóa</button>
                                                        </form>
                                                    </c:if>
                                                </div>

                                                <!-- Edit form (hidden by default) -->
                                                <form method="post" action="${pageContext.request.contextPath}/product/review" class="mt-3 hidden" id="reply-edit-form-${r.reviewId}">
                                                    <input type="hidden" name="productId" value="${product.productId}" />
                                                    <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                    <input type="hidden" name="action" value="replyUpdate" />
                                                    <textarea name="replyContent" rows="4" maxlength="1000" class="w-full border rounded p-2" id="reply-edit-text-${r.reviewId}">${fn:escapeXml(reply.replyContent)}</textarea>
                                                    <div class="mt-3 flex items-center gap-3">
                                                        <button type="button" class="px-4 py-2 bg-green-600 text-white rounded" onclick="submitEditReply(${r.reviewId});">Cập nhật</button>
                                                        <button type="button" class="px-4 py-2 bg-gray-200 rounded" onclick="cancelEditReply(${r.reviewId});">Hủy</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <!-- ===== end reply section ===== -->

                                    <!-- Customer owner actions: edit / delete review -->
                                    <c:if test="${isCustomer and effectiveUser.id == r.customerId}">
                                        <div class="mt-3 flex gap-3">
                                            <button type="button" class="px-4 py-2 bg-blue-600 text-white rounded" onclick="document.getElementById('edit-review-${r.reviewId}').classList.toggle('hidden')">Sửa</button>
                                            <form method="post" action="${pageContext.request.contextPath}/product/review" style="display:inline">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="productId" value="${product.productId}" />
                                                <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                <button type="button" onclick="if (confirm('Xóa đánh giá này?')) this.form.submit();" class="px-4 py-2 bg-red-600 text-white rounded">Xóa</button>
                                            </form>
                                        </div>
                                    </c:if>

                                    <div id="edit-review-${r.reviewId}" class="hidden mt-3 p-3 bg-gray-50 border rounded">
                                        <form method="post" action="${pageContext.request.contextPath}/product/review" class="space-y-3">
                                            <input type="hidden" name="productId" value="${r.productId}" />
                                            <input type="hidden" name="action" value="edit" />
                                            <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                            <div>
                                                <label class="block text-sm font-semibold mt-2">Nội dung</label>
                                                <textarea name="comment" class="w-full border p-2 rounded" rows="4">${fn:escapeXml(r.comment)}</textarea>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-semibold mt-2">Số sao</label>
                                                <select name="rating" class="border rounded p-1">
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <option value="${i}" ${i == r.rating ? 'selected' : ''}>${i}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="flex gap-3">
                                                <button type="submit" class="bg-blue-600 text-white px-4 py-1 rounded">Lưu</button>
                                                <button type="button" onclick="document.getElementById('edit-review-${r.reviewId}').classList.add('hidden')" class="ml-2 text-gray-600">Hủy</button>
                                            </div>
                                        </form>
                                    </div>

                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <c:if test="${empty reviews}">
                        <p class="text-gray-500">Chưa có phản hồi nào.</p>
                    </c:if>

                    <div class="mt-4">
                        <c:choose>
                            <c:when test="${isCustomer}">
                                <button id="toggleReviewForm" type="button" data-product-id="${product.productId}" data-has-purchased="${userHasPurchased}" data-has-reviewed="${userHasReviewed}" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 mt-4">✍️ Viết đánh giá</button>
                                <span id="purchaseNotice" class="ml-3 text-sm text-red-500 hidden"></span>
                            </c:when>
                            <c:when test="${isLoggedIn and not isCustomer}">
                                <div class="mt-4 text-sm text-gray-500">Bạn đang đăng nhập với tư cách <strong><c:out value="${effectiveUser.roleEnum != null ? effectiveUser.roleEnum : effectiveUser.role}"/></strong>.</div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login?redirect=${encodedRedirect}" class="inline-block bg-yellow-400 text-white px-4 py-2 rounded hover:bg-yellow-500 mt-4">🔐 Đăng nhập để viết đánh giá</a>
                                <p class="text-sm text-gray-500 mt-2">Bạn cần đăng nhập để gửi đánh giá.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${isCustomer}">
                        <div id="reviewForm" class="hidden bg-gray-50 p-4 rounded-lg border mt-4">
                            <!-- NOTE: id="reviewFormInner" used by AJAX script below -->
                            <form action="${pageContext.request.contextPath}/product/review" method="post" class="space-y-4" id="reviewFormInner">
                                <input type="hidden" name="productId" value="<%= (product != null) ? product.getProductId() : 0%>">
                                <div>
                                    <label class="block font-semibold mb-2">Xếp hạng của bạn:</label>
                                    <div id="starRating" class="flex space-x-1 text-3xl cursor-pointer">
                                        <span data-value="1" class="star">☆</span>
                                        <span data-value="2" class="star">☆</span>
                                        <span data-value="3" class="star">☆</span>
                                        <span data-value="4" class="star">☆</span>
                                        <span data-value="5" class="star">☆</span>
                                    </div>
                                    <input type="hidden" id="ratingInput" name="rating" value="0" required>
                                    <p id="ratingError" class="text-red-500 text-sm hidden">Vui lòng chọn số sao đánh giá.</p>
                                </div>

                                <div>
                                    <label class="block font-semibold mb-1">Nội dung đánh giá</label>
                                    <textarea name="comment" required class="w-full border p-2 rounded" id="reviewComment"></textarea>
                                    <p id="commentError" class="text-red-500 text-sm hidden">Nội dung không được trống.</p>
                                </div>

                                <button id="submitReviewBtn" type="submit" class="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 transition">Gửi đánh giá</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- RELATED PRODUCTS (unchanged) -->
            <div class="mt-8 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                <h3 class="text-xl font-bold mb-4">Sản phẩm liên quan</h3>

                <c:if test="${not empty relatedProducts}">
                    <div class="relative">
                        <div class="overflow-x-auto overflow-y-hidden">
                            <div id="relatedTrack" class="flex gap-4 transition-transform duration-300">
                                <c:forEach var="rp" items="${relatedProducts}">
                                    <div class="flex-shrink-0 w-1/2 md:w-1/4">
                                        <div class="bg-white rounded-lg shadow hover:shadow-lg transition p-3 flex flex-col h-full">
                                            <a href="product?id=${rp.productId}" class="block h-28 mb-3">
                                                <c:choose>
                                                    <c:when test="${not empty rp.mainVariant and not empty rp.mainVariant.imageUrl}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(rp.mainVariant.imageUrl, 'http')}">
                                                                <img src="${rp.mainVariant.imageUrl}" alt="${rp.productName}" class="w-full h-full object-cover rounded" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/images/${rp.mainVariant.imageUrl}" alt="${rp.productName}" class="w-full h-full object-cover rounded" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/images/no-image.png" alt="${rp.productName}" class="w-full h-full object-cover rounded" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>

                                            <div class="flex-1">
                                                <a href="product?id=${rp.productId}" class="text-sm font-semibold hover:text-red-500 block mb-1">${rp.productName}</a>
                                                <p class="text-xs text-gray-500">Thương hiệu: ${rp.brandName}</p>
                                                <div class="mt-2">
                                                    <c:choose>
                                                        <c:when test="${not empty rp.mainVariant and rp.mainVariant.price ne 0}">
                                                            <p class="text-red-600 font-bold text-sm">
                                                                <fmt:formatNumber value="${rp.mainVariant.price}" type="number" groupingUsed="true"/>₫
                                                            </p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="text-gray-500 italic text-sm">Liên hệ</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Controls -->
                        <button id="relPrev" type="button" class="absolute left-0 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-700 rounded-full w-9 h-9 flex items-center justify-center shadow-md" aria-label="Previous related">
                            &#10094;
                        </button>
                        <button id="relNext" type="button" class="absolute right-0 top-1/2 -translate-y-1/2 bg-white/80 hover:bg-white text-gray-700 rounded-full w-9 h-9 flex items-center justify-center shadow-md" aria-label="Next related">
                            &#10095;
                        </button>
                    </div>
                </c:if>

                <c:if test="${empty relatedProducts}">
                    <p class="text-gray-500">Không có sản phẩm liên quan.</p>
                </c:if>
            </div>

        </div>

        <%@ include file="/WEB-INF/include/footer.jsp" %>

        <script>
            function startEditReply(reviewId) {
            var view = document.getElementById('reply-view-' + reviewId);
            var form = document.getElementById('reply-edit-form-' + reviewId);
            if (!view || !form) return;
            view.classList.add('hidden');
            form.classList.remove('hidden');
            var ta = document.getElementById('reply-edit-text-' + reviewId);
            if (ta) ta.focus();
            }
            function cancelEditReply(reviewId) {
            var view = document.getElementById('reply-view-' + reviewId);
            var form = document.getElementById('reply-edit-form-' + reviewId);
            if (!view || !form) return;
            form.classList.add('hidden');
            view.classList.remove('hidden');
            }
            async function submitEditReply(reviewId) {
            var form = document.getElementById('reply-edit-form-' + reviewId);
            if (!form) return;
            var textarea = document.getElementById('reply-edit-text-' + reviewId);
            var content = textarea ? textarea.value.trim() : '';
            if (!content) {
            alert('Nội dung phản hồi không được trống.');
            if (textarea) textarea.focus();
            return;
            }
            var fd = new FormData();
            fd.append('productId', form.querySelector('input[name="productId"]').value);
            fd.append('reviewId', form.querySelector('input[name="reviewId"]').value);
            fd.append('action', 'replyUpdate');
            fd.append('replyContent', content);
            try {
            var resp = await fetch(form.action, {
            method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'Accept': 'application/json' },
                    body: fd
            });
            var json = await resp.json();
            if (resp.ok && json.success) {
            var view = document.getElementById('reply-view-' + reviewId);
            if (view) view.innerText = content;
            cancelEditReply(reviewId);
            var top = document.querySelector('#tab-reviews');
            if (top) {
            var msg = document.createElement('div');
            msg.className = 'mb-4 p-3 bg-green-50 border border-green-200 text-green-700 rounded';
            msg.innerText = json.message || 'Đã cập nhật phản hồi.';
            top.insertBefore(msg, top.firstChild);
            setTimeout(function(){ try{ msg.remove(); } catch (e){} }, 3500);
            }
            } else {
            var err = (json && json.message) ? json.message : 'Không thể cập nhật phản hồi.';
            alert(err);
            }
            } catch (e) {
            form.submit();
            }
            }
        </script>

        <script type="text/javascript">
            window.PRODUCT_CONFIG = {
        contextPath: '<%= request.getContextPath()%>',
                    productId: <%= (product != null ? product.getProductId() : 0)%>,
                    loggedIn: <%= loggedIn ? "true" : "false"%>,
                    userHasPurchased: <%= userHasPurchased ? "true" : "false"%>,
                    userHasReviewed: <%= userHasReviewed ? "true" : "false"%>,
                    defaultPrice: <%= Double.toString(defaultPrice)%>,
                    variantsData: [
            <% if (variants != null) {
                            for (int i = 0; i < variants.size(); i++) {
                                ProductVariant v = variants.get(i);
                                String attr = v.getAttributeJson();
                                double price = v.getPrice();
                                String img = v.getImageUrl();
                                int stock = v.getStockQuantity();
                                long vid = v.getVariantId();
                                if (img == null || img.isEmpty()) {
                                    img = "/assets/img/no-image.png";
                                } else {
                                    if (img.startsWith("/")) {
                                        // already a path like /images/...
                                        // keep as-is
                                    } else if (img.startsWith("http")) {
                                        // external URL, keep
                                    } else {
                                        img = "/images/" + img;
                                    }
                                }
            %>
                    {
                id: <%= vid%>,
                            attr: '<%= attr != null ? attr.replace("'", "\\'") : ""%>',
                            price: <%= price%>,
                            img: '<%= request.getContextPath() + img%>',
                            stock: <%= stock%>
                    }<%= (i < variants.size() - 1) ? "," : ""%>
            <% }
                        } %>
                    ],
                    images: [
            <% if (productImages != null) {
                            for (int i = 0; i < productImages.size(); i++) {
                                ProductImg pi = productImages.get(i);
                                String url = pi.getImageUrl();
                                String full = "/assets/img/no-image.png";
                                if (url != null && !url.isEmpty()) {
                                    if (url.startsWith("/")) {
                                        full = request.getContextPath() + url;
                                    } else {
                                        full = request.getContextPath() + "/images/" + url;
                                    }
                                } else {
                                    full = request.getContextPath() + "/assets/img/no-image.png";
                                }
                                out.print('\'' + full + '\'');
                                if (i < productImages.size() - 1) {
                                out.print(",");
                                }
                            }
                        }%>
                    ]
            };
        </script>

        <script src="${pageContext.request.contextPath}/assets/js/loading.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/product.js"></script>
        <script>
            // Related products carousel: show 4 per view, scroll by container width
            document.addEventListener('DOMContentLoaded', function(){
            var track = document.getElementById('relatedTrack');
            if (!track) return;
            // container is the scrollable wrapper
            var container = track.parentElement;
            var prev = document.getElementById('relPrev');
            var next = document.getElementById('relNext');
            function updateButtons(){
            try{
            var atStart = container.scrollLeft <= 1;
            var atEnd = (container.scrollLeft + container.clientWidth) >= (track.scrollWidth - 1);
            if (prev) { prev.disabled = atStart; prev.classList.toggle('opacity-50', atStart); }
            if (next) { next.disabled = atEnd; next.classList.toggle('opacity-50', atEnd); }
            } catch (e){ /* suppressed error in production */ }
            }

            if (prev) prev.addEventListener('click', function(){ container.scrollBy({ left: - container.clientWidth, behavior: 'smooth' }); setTimeout(updateButtons, 420); });
            if (next) next.addEventListener('click', function(){ container.scrollBy({ left: container.clientWidth, behavior: 'smooth' }); setTimeout(updateButtons, 420); });
            // allow wrapper to be scrolled by drag/wheel on desktop
            container.addEventListener('scroll', function(){ updateButtons(); });
            window.addEventListener('resize', function(){ updateButtons(); });
            // initial
            setTimeout(updateButtons, 50);
            });
        </script>
    </body>
</html>