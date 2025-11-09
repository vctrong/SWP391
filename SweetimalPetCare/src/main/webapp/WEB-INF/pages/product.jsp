<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="model.Product, model.ProductVariant, model.ProductImg, model.Review, java.util.*, java.text.NumberFormat, java.util.Locale, java.net.URLEncoder"%>
<script src="${pageContext.request.contextPath}/assets/js/loading.js"></script>

<%!
    // Simple HTML escaper
    private String escapeHtml(String s) {
        if (s == null) return "";
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

    // Normalize comment: convert CRLF/CR to LF, collapse multiple blank lines, trim ends
    private String normalizeComment(String s) {
        if (s == null) return "";
        s = s.replaceAll("\\r\\n?", "\n");
        s = s.replaceAll("\\n\\s*\\n+", "\n\n");
        s = s.replaceAll("^[\\s\\u00A0]+", "");
        s = s.replaceAll("[\\s\\u00A0]+$", "");
        return s;
    }
%>

<%
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
    if (product != null && product.getMainVariant() != null) defaultPrice = product.getMainVariant().getPrice();

    // For client-side initial selection
    double minPrice = defaultPrice;
    ProductVariant minPriceVariant = null;
    if (variants != null && !variants.isEmpty()) {
        minPrice = Double.MAX_VALUE;
        for (ProductVariant v : variants) {
            if (v.getPrice() < minPrice) { minPrice = v.getPrice(); minPriceVariant = v; }
        }
        defaultPrice = minPrice;
    }

    // Expose loggedIn flag for JSTL/EL
    boolean loggedIn = (session.getAttribute("user") != null)
            || (session.getAttribute("userId") != null)
            || (session.getAttribute("customerId") != null)
            || (request.getUserPrincipal() != null);
    request.setAttribute("loggedIn", Boolean.valueOf(loggedIn));

    // currentUrl for redirect when not logged in
    String currentUrl = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
    String encodedRedirect = "/";
    try {
        encodedRedirect = URLEncoder.encode(currentUrl, "UTF-8");
    } catch (Exception e) {
        encodedRedirect = "/";
    }
    request.setAttribute("encodedRedirect", encodedRedirect);
%>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title><%= (product != null) ? product.getProductName() : "Sản phẩm" %></title>

    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        .rating-stars i { font-size: 20px; margin-right: 6px; vertical-align: middle; }
        .rating-value { margin-left: 8px; color: #4b5563; }
        .item-img { width: 72px; height: 72px; object-fit: cover; border-radius: 6px; }
        .muted { color: #6b7280; }
        .summary-box { position: sticky; top: 20px; }
        .small-muted { font-size: .9rem; color: #6b7280; display:block; margin-top:4px; }
        pre.debug { background:#f8f9fa; border:1px solid #e9ecef; padding:12px; overflow:auto; max-height:300px; }
        .out-of-stock::after { content: ""; position: absolute; top: 50%; left: 0; right: 0; height: 1px; background: red; transform: rotate(-20deg); }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/include/header.jsp" %>
    <div class="max-w-6xl mx-auto p-6">
        <div class="text-sm text-gray-500 mb-6 font-medium">
            <a href="${pageContext.request.contextPath}/shop" class="hover:text-red-500 transition">🏠 Trang Chủ</a> ›
            <span class="text-gray-700"><%= (product != null) ? product.getProductName() : "Không tìm thấy" %></span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-start">

            <div class="flex flex-col items-center">
                <div class="relative w-full h-96 bg-white rounded-2xl shadow-lg overflow-hidden">
                    <img id="mainImg"
                         src="<%= request.getContextPath() + ((productImages != null && !productImages.isEmpty()) ? productImages.get(0).getImageUrl() : "/assets/img/no-image.png") %>"
                         alt="<%= (product != null) ? product.getProductName() : "Không có hình ảnh" %>"
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

                            <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="${img.caption}"
                                 class="thumb w-16 h-16 object-cover rounded-lg cursor-pointer border-2 ${thumbBorder} hover:border-red-400 transition duration-300"
                                 onclick="showImage(${loop.index})" />
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <div class="bg-white p-8 rounded-2xl shadow-lg border border-gray-100">
                <h1 class="text-3xl font-bold text-gray-900 leading-tight">
                    <%= (product != null) ? product.getProductName() : "Không có sản phẩm" %>
                </h1>

                <% 
                    Number avgAttr = null;
                    Object rawAvg = request.getAttribute("avgRating");
                    if (rawAvg instanceof Number) avgAttr = (Number) rawAvg;
                    double avgRating = avgAttr != null ? avgAttr.doubleValue() : 0.0;
                    if (avgRating < 0) avgRating = 0.0;
                    if (avgRating > 5) avgRating = 5.0;
                %>

                <div class="flex items-center mt-2">
                    <span class="rating-stars" role="img" aria-label="<%= String.format(Locale.forLanguageTag("vi-VN"), "%.1f/5", avgRating) %>">
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

                    <span class="rating-value"><%= String.format(Locale.forLanguageTag("vi-VN"), "%.1f", avgRating) %>/5</span>
                </div>

                <p class="text-gray-600 mt-2 text-lg">
                    Thương hiệu: <%= (product != null && product.getBrandName() != null) ? product.getBrandName() : "N/A" %>
                </p>

                <%-- Attributes, price, add to cart, etc. (kept same as before) --%>
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
                                    String[] parts = cleaned.split(":");
                                    if (parts.length == 2) {
                                        String key = parts[0].trim();
                                        String val = parts[1].trim();
                                        String displayKey = key.substring(0, 1).toUpperCase() + key.substring(1).toLowerCase();
                                        if (!attrMap.containsKey(displayKey)) attrMap.put(displayKey, new ArrayList<String>());
                                        if (!attrMap.get(displayKey).contains(val)) {
                                            attrMap.get(displayKey).add(val);
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
                        String attrKeyLower = attrName.toLowerCase();
                        String initSelectedVal = (minPriceVariant != null) ? (minPriceVariant.getAttributeJson() != null ? minPriceVariant.getAttributeJson().replaceAll("[{}\"]", "").split(":")[1].trim() : null) : null;
                    %>
                    <div class="mb-4">
                        <p class="font-semibold text-gray-700 text-lg mb-2">
                            <%= attrName %>:
                            <span id="selected-<%= attrKeyLower %>" class="text-red-500 font-medium"><%= (initSelectedVal != null) ? initSelectedVal : values.get(0) %></span>
                        </p>

                        <div class="flex flex-wrap gap-3">
                            <% for (String val : values) {
                                String key = attrName + ":" + val;
                                boolean outOfStock = stockMap.getOrDefault(key, 1) <= 0;
                                double priceForVal = priceMap.getOrDefault(key, minPrice);
                                String safeAttrName = attrKeyLower.replace("'", "\\'");
                                String safeVal = val.replace("'", "\\'");
                            %>
                                <button type="button"
                                        class="attr-btn relative border rounded-lg px-4 py-2 hover:bg-gray-100 transition select-none <%= outOfStock ? "opacity-50 border-gray-300 out-of-stock" : "" %>"
                                        data-attr-name="<%= safeAttrName %>"
                                        data-attr-value="<%= safeVal %>"
                                        data-price="<%= priceForVal %>"
                                        onclick="selectAttr(this, '<%= safeAttrName %>', '<%= safeVal %>', <%= priceForVal %>)">
                                    <%= val %>
                                </button>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(minPrice) %>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>
                <% } else { %>
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(defaultPrice) %>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>
                <% } %>

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
                        <span id="totalPrice" class="text-red-500"><%= currencyFormat.format(defaultPrice) %>₫</span>
                    </div>
                </div>

                <form id="addToCartForm" method="post" action="<%= request.getContextPath() %>/cart">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= (product != null) ? product.getProductId() : 0 %>">
                    <input type="hidden" name="variantId" id="hiddenVariantId" value="">
                    <input type="hidden" name="quantity" id="hiddenQuantity" value="1">
                    <div class="mt-8">
                        <button id="buyBtn" type="submit" class="w-full bg-blue-600 text-white py-4 rounded-full font-bold text-lg shadow-md hover:shadow-lg hover:bg-blue-700 transition">Đặt Hàng</button>
                    </div>
                </form>
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
                    <%= (product != null && product.getDescription() != null) ? product.getDescription() : "Chưa có mô tả cho sản phẩm này." %>
                </p>
            </div>

            <div id="tab-reviews" class="tab-content hidden">
                <h3 class="text-lg font-bold mb-3">Khách hàng đánh giá</h3>

                <c:set var="currentUserId" value="${null}" />
                <c:choose>
                    <c:when test="${not empty sessionScope.customerId}">
                        <c:set var="currentUserId" value="${sessionScope.customerId}" />
                    </c:when>
                    <c:when test="${not empty sessionScope.userId}">
                        <c:set var="currentUserId" value="${sessionScope.userId}" />
                    </c:when>
                    <c:when test="${not empty sessionScope.user}">
                        <c:set var="currentUserId" value="${sessionScope.user.id}" />
                    </c:when>
                </c:choose>

                <div id="reviewsList">
                <c:if test="${not empty reviews}">
                    <c:forEach var="r" items="${reviews}">
                        <div class="border-b py-3" id="review-block-${r.reviewId}">
                            <p class="font-semibold flex items-center justify-between">
                                <span class="flex items-center">
                                    <span class="mr-3 font-medium text-gray-800">${fn:escapeXml(r.userName)}</span>
                                    <span class="text-yellow-500">
                                        <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                    </span>
                                </span>

                                <span class="flex items-center gap-2">
                                    <c:if test="${not empty currentUserId and r.customerId == currentUserId}">
                                        <form method="post" action="${pageContext.request.contextPath}/product/review" class="inline">
                                            <input type="hidden" name="productId" value="${r.productId}" />
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                            <button type="submit" onclick="return confirm('Bạn có chắc muốn xóa đánh giá này?');"
                                                    class="text-sm text-red-600 hover:underline ml-2">Xóa</button>
                                        </form>

                                        <button type="button" onclick="document.getElementById('edit-review-${r.reviewId}').classList.toggle('hidden')"
                                                class="text-sm text-blue-600 hover:underline ml-2">Sửa</button>
                                    </c:if>
                                </span>
                            </p>

                            <% 
                                Object rObj = pageContext.getAttribute("r");
                                String rawComment = "";
                                if (rObj != null) {
                                    try { rawComment = ((model.Review) rObj).getComment(); } catch (Exception ex) { rawComment = String.valueOf(rObj); }
                                }
                                String safe = normalizeComment(rawComment);
                            %>
                            <p class="text-gray-700 mt-3 whitespace-pre-wrap"><%= escapeHtml(safe) %></p>
                            <p class="text-xs text-gray-400 mt-2">${r.createdAt}</p>

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
                        <c:when test="${loggedIn}">
                            <button id="toggleReviewForm" type="button" data-product-id="${product.productId}" data-has-purchased="${userHasPurchased}" data-has-reviewed="${userHasReviewed}" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 mt-4">✍️ Viết đánh giá</button>
                            <span id="purchaseNotice" class="ml-3 text-sm text-red-500 hidden"></span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login?redirect=${encodedRedirect}" class="inline-block bg-yellow-400 text-white px-4 py-2 rounded hover:bg-yellow-500 mt-4">🔐 Đăng nhập để viết đánh giá</a>
                            <p class="text-sm text-gray-500 mt-2">Bạn cần đăng nhập để gửi đánh giá.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${loggedIn}">
                    <div id="reviewForm" class="hidden bg-gray-50 p-4 rounded-lg border mt-4">
                        <!-- NOTE: id="reviewFormInner" used by AJAX script below -->
                        <form action="${pageContext.request.contextPath}/product/review" method="post" class="space-y-4" id="reviewFormInner">
                            <input type="hidden" name="productId" value="<%= (product != null) ? product.getProductId() : 0 %>">
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
                                <p id="commentError" class="text-red-500 text-sm hidden">Nội dung phải có ít nhất 20 ký tự.</p>
                            </div>

                            <button id="submitReviewBtn" type="submit" class="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 transition">Gửi đánh giá</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- RELATED PRODUCTS: restored block -->
        <div class="mt-8 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <h3 class="text-xl font-bold mb-4">Sản phẩm liên quan</h3>

            <c:if test="${not empty relatedProducts}">
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <c:forEach var="rp" items="${relatedProducts}">
                        <div class="bg-white rounded-lg shadow hover:shadow-lg transition p-3 flex flex-col">
                            <a href="product?id=${rp.productId}" class="block h-28 mb-3">
                                <c:choose>
                                    <c:when test="${not empty rp.mainVariant and not empty rp.mainVariant.imageUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(rp.mainVariant.imageUrl, 'http')}">
                                                <img src="${rp.mainVariant.imageUrl}" alt="${rp.productName}" class="w-full h-full object-cover rounded" />
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}${rp.mainVariant.imageUrl}" alt="${rp.productName}" class="w-full h-full object-cover rounded" />
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
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty relatedProducts}">
                <p class="text-gray-500">Không có sản phẩm liên quan.</p>
            </c:if>
        </div>

    </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>

    <script>
        // Build variantsData array
        const variantsData = [
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
                    }
            %>
            {
                id: <%= vid %>,
                attr: '<%= attr != null ? attr.replaceAll("'", "\\\\'") : "" %>',
                price: <%= price %>,
                img: '<%= request.getContextPath() + img %>',
                stock: <%= stock %>
            }<%= (i < variants.size() - 1) ? "," : "" %>
            <% }
            } %>
        ];

        // Globals
        window.selectedVariantId = null;
        window.selectedVariantStock = undefined;

        document.addEventListener('DOMContentLoaded', () => {
            const mainImg = document.getElementById('mainImg');
            const priceDisplay = document.getElementById('priceDisplay');
            const totalPrice = document.getElementById('totalPrice');
            const qtyEl = document.getElementById('qty');
            const btnInc = document.getElementById('btnInc');
            const btnDec = document.getElementById('btnDec');
            const buyBtn = document.getElementById('buyBtn');
            const stockInfo = document.getElementById('stockInfo');
            const qtyAlert = document.getElementById('qtyAlert');
            const hiddenVariantInput = document.getElementById('hiddenVariantId');

            let currentUnitPrice = <%= Double.toString(defaultPrice) %>;
            let maxQty = 99;
            const selectedAttrs = {};

            function formatVND(n) {
                const num = Number(n) || 0;
                return num.toLocaleString('vi-VN') + "₫";
            }

            function showQtyAlert(msg) {
                if (!qtyAlert) return;
                qtyAlert.textContent = msg;
                qtyAlert.classList.remove('hidden');
                qtyAlert.style.opacity = 1;
                clearTimeout(qtyAlert._hideTimer);
                qtyAlert._hideTimer = setTimeout(() => {
                    qtyAlert.style.transition = 'opacity 240ms';
                    qtyAlert.style.opacity = 0;
                    setTimeout(() => {
                        qtyAlert.classList.add('hidden');
                        qtyAlert.style.transition = '';
                    }, 250);
                }, 1400);
            }

            function updateButtonsState() {
                let qty = parseInt(qtyEl.value, 10);
                if (isNaN(qty)) qty = 0;
                if (qty > maxQty) qty = maxQty;
                qtyEl.value = (qty === 0 && maxQty !== 0) ? "" : qty;

                if (btnDec) btnDec.disabled = qty <= 1;
                if (btnInc) btnInc.disabled = (maxQty === 0) || (qty >= maxQty);

                if (btnDec) {
                    if (btnDec.disabled) btnDec.classList.add('opacity-50', 'cursor-not-allowed');
                    else btnDec.classList.remove('opacity-50', 'cursor-not-allowed');
                }
                if (btnInc) {
                    if (btnInc.disabled) btnInc.classList.add('opacity-50', 'cursor-not-allowed');
                    else btnInc.classList.remove('opacity-50', 'cursor-not-allowed');
                }
            }

            function updateTotalFromInput(animate = true) {
                let qty = parseInt(qtyEl.value, 10);
                if (isNaN(qty) || qty === 0) {
                    totalPrice.textContent = formatVND(0);
                } else {
                    if (qty < 1) qty = 1;
                    if (qty > maxQty) qty = maxQty;
                    totalPrice.textContent = formatVND(currentUnitPrice * qty);
                }

                if (animate && !isNaN(parseInt(qtyEl.value, 10))) {
                    totalPrice.style.transition = "transform 0.08s";
                    totalPrice.style.transform = "scale(1.05)";
                    setTimeout(() => totalPrice.style.transform = "scale(1)", 90);
                }

                updateButtonsState();
            }

            window.changeQty = function (n) {
                let qty = parseInt(qtyEl.value, 10);
                if (isNaN(qty)) qty = 0;
                let target = qty + n;

                if (target < 1) {
                    target = 1;
                    showQtyAlert("Số lượng tối thiểu là 1");
                }
                if (target > maxQty) {
                    if (maxQty === 0) {
                        showQtyAlert("Sản phẩm tạm hết hàng");
                        qtyEl.value = maxQty;
                        updateTotalFromInput();
                        return;
                    } else {
                        showQtyAlert("Bạn đã đạt giới hạn: " + maxQty);
                        target = maxQty;
                    }
                }

                qtyEl.value = target;
                updateTotalFromInput();
            };

            window.handleQtyInput = function (event) {
                const input = event.target;
                const digits = input.value.replace(/\D/g, "");
                input.value = digits;

                const val = parseInt(digits, 10);
                if (!isNaN(val) && val > maxQty) {
                    showQtyAlert("Bạn đã đạt giới hạn: " + maxQty);
                }

                updateTotalFromInput(false);
                if (event instanceof KeyboardEvent && event.key === "Enter") input.blur();
            };

            if (btnInc) {
                btnInc.addEventListener('click', (ev) => { ev.preventDefault(); ev.stopPropagation(); changeQty(1); });
            }
            if (btnDec) {
                btnDec.addEventListener('click', (ev) => { ev.preventDefault(); ev.stopPropagation(); changeQty(-1); });
            }

            // selectAttr(btn, name, value, price, visual)
            window.selectAttr = function (btn, name, value, price, visual) {
                if (visual === undefined) visual = true;
                const key = name.toLowerCase();

                selectedAttrs[key] = value;
                const label = document.getElementById('selected-' + key);
                if (label) label.textContent = value;

                // Remove highlight from all attribute buttons
                document.querySelectorAll('.attr-btn').forEach(b => {
                    b.classList.remove("border-red-500", "text-red-600", "shadow-md", "z-10");
                });

                // Find matched variant
                let matchedVariant = null;
                for (const v of variantsData) {
                    try {
                        const obj = v.attr ? JSON.parse(v.attr) : {};
                        let match = true;
                        for (const selKey in selectedAttrs) {
                            const want = String(selectedAttrs[selKey]);
                            let found = false;
                            for (const k in obj) {
                                if (k.toLowerCase() === selKey) {
                                    if (String(obj[k]) === want) found = true;
                                }
                            }
                            if (!found) { match = false; break; }
                        }
                        if (match) { matchedVariant = v; break; }
                    } catch (e) {
                        // ignore parse problems
                    }
                }

                if (matchedVariant) {
                    // highlight buttons corresponding to matchedVariant
                    try {
                        const obj = matchedVariant.attr ? JSON.parse(matchedVariant.attr) : {};
                        for (const k in obj) {
                            if (!obj.hasOwnProperty(k)) continue;
                            const normKey = k.toLowerCase();
                            const normVal = String(obj[k]);
                            const b = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
                            if (b) b.classList.add("border-red-500", "text-red-600", "shadow-md", "z-10");
                        }
                    } catch (e) { /* ignore */ }

                    window.selectedVariantId = matchedVariant.id;
                    window.selectedVariantStock = matchedVariant.stock;

                    // update hidden input for form
                    if (hiddenVariantInput) hiddenVariantInput.value = String(matchedVariant.id);

                    currentUnitPrice = matchedVariant.price;
                    if (priceDisplay) priceDisplay.textContent = formatVND(currentUnitPrice);

                    maxQty = (typeof matchedVariant.stock === 'number' && matchedVariant.stock >= 0) ? matchedVariant.stock : 99;

                    if (maxQty <= 0) {
                        if (stockInfo) stockInfo.textContent = "Tạm thời hết hàng";
                        if (buyBtn) { buyBtn.disabled = true; buyBtn.classList.add('opacity-50', 'cursor-not-allowed'); }
                        qtyEl.value = 0;
                        updateTotalFromInput();
                        updateButtonsState();
                    } else {
                        if (stockInfo) stockInfo.textContent = "Còn " + maxQty + " sản phẩm";
                        if (buyBtn) { buyBtn.disabled = false; buyBtn.classList.remove('opacity-50', 'cursor-not-allowed'); }
                        let q = parseInt(qtyEl.value, 10);
                        if (isNaN(q) || q <= 0) qtyEl.value = 1;
                        if (!isNaN(q) && q > maxQty) qtyEl.value = maxQty;
                        updateTotalFromInput();
                    }

                    if (matchedVariant.img && mainImg) {
                        mainImg.style.opacity = 0;
                        setTimeout(() => { mainImg.src = matchedVariant.img; mainImg.style.opacity = 1; }, 200);
                    }
                } else {
                    // No full match yet. If visual and btn provided, highlight only clicked button for feedback
                    if (visual && btn) btn.classList.add("border-red-500", "text-red-600", "shadow-md", "z-10");

                    // Do not leave selectedVariantId null if there's a reasonable fallback – keep product purchasable
                    window.selectedVariantId = null;
                    window.selectedVariantStock = undefined;

                    currentUnitPrice = price;
                    if (priceDisplay) priceDisplay.textContent = formatVND(price);
                    maxQty = 99;
                    if (stockInfo) stockInfo.textContent = "";
                    if (buyBtn) buyBtn.disabled = false, buyBtn.classList.remove('opacity-50', 'cursor-not-allowed');

                    let q0 = parseInt(qtyEl.value, 10);
                    if (isNaN(q0) || q0 <= 0) qtyEl.value = 1;
                    updateTotalFromInput();
                }
            };

            // Initialize selections: ensure there's always a selected variant (or fallback to first variant)
            function initializeSelectedAttributes() {
                // Try to detect existing visually-marked buttons (server-side) first
                const preselectedBtns = document.querySelectorAll('.attr-btn.border-red-500, .attr-btn.text-red-600');
                let applied = false;
                preselectedBtns.forEach(btn => {
                    const name = btn.dataset && btn.dataset.attrName;
                    const value = btn.dataset && btn.dataset.attrValue;
                    const price = btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : undefined;
                    if (name && value) {
                        // visual=true so user sees selected option
                        selectAttr(btn, name, value, price, true);
                        applied = true;
                    }
                });

                // If nothing preselected, choose a sensible default:
                // - Prefer variant with minimum price (cheapest) that exists in variantsData
                // - Otherwise, select first available option for each attribute group
                if (!applied) {
                    // find cheapest variant
                    let defaultVariant = null;
                    if (Array.isArray(variantsData) && variantsData.length > 0) {
                        defaultVariant = variantsData.reduce((acc, v) => {
                            if (!acc) return v;
                            return (v.price < acc.price) ? v : acc;
                        }, null);
                    }

                    if (defaultVariant && defaultVariant.attr) {
                        // try to select attribute buttons that match this variant (visual highlight)
                        try {
                            const obj = JSON.parse(defaultVariant.attr);
                            for (const k in obj) {
                                if (!obj.hasOwnProperty(k)) continue;
                                const normKey = k.toLowerCase();
                                const normVal = String(obj[k]);
                                const btn = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
                                if (btn) {
                                    // use visual highlight for better UX
                                    selectAttr(btn, normKey, normVal, btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : defaultVariant.price, true);
                                } else {
                                    // if matching button not found (parsing mismatch), fall back later
                                }
                            }
                            applied = true;
                        } catch (e) {
                            // parsing error – ignore and fall back to per-group first option
                        }
                    }

                    if (!applied) {
                        // Select the first non-out-of-stock button in each attribute group
                        const attrBtns = Array.from(document.querySelectorAll('.attr-btn'));
                        const groups = {};
                        attrBtns.forEach(b => {
                            const name = b.dataset && b.dataset.attrName;
                            if (!name) return;
                            if (!groups[name]) groups[name] = [];
                            groups[name].push(b);
                        });

                        Object.keys(groups).forEach(name => {
                            const buttons = groups[name];
                            // pick first not out-of-stock; else pick first
                            let pick = buttons.find(x => !x.classList.contains('out-of-stock'));
                            if (!pick) pick = buttons[0];
                            if (pick) {
                                const value = pick.dataset && pick.dataset.attrValue;
                                const price = pick.dataset && pick.dataset.price ? Number(pick.dataset.price) : undefined;
                                selectAttr(pick, name, value, price, true);
                            }
                        });
                    }

                    // After selecting per-group, if still no matched variant (selectedVariantId null), fallback to first variant in variantsData
                    if ((!window.selectedVariantId || window.selectedVariantId === null) && Array.isArray(variantsData) && variantsData.length > 0) {
                        // prefer a variant with stock > 0, otherwise just first
                        let fallback = variantsData.find(v => typeof v.stock === 'number' && v.stock > 0) || variantsData[0];
                        // apply fallback: set hidden input and UI price/stock
                        window.selectedVariantId = fallback.id;
                        window.selectedVariantStock = fallback.stock;
                        if (hiddenVariantInput) hiddenVariantInput.value = String(fallback.id);
                        currentUnitPrice = fallback.price;
                        if (priceDisplay) priceDisplay.textContent = formatVND(currentUnitPrice);
                        maxQty = (typeof fallback.stock === 'number' && fallback.stock >= 0) ? fallback.stock : 99;
                        if (maxQty <= 0) {
                            if (stockInfo) stockInfo.textContent = "Tạm thời hết hàng";
                            if (buyBtn) { buyBtn.disabled = true; buyBtn.classList.add('opacity-50', 'cursor-not-allowed'); }
                            qtyEl.value = 0;
                        } else {
                            if (stockInfo) stockInfo.textContent = "Còn " + maxQty + " sản phẩm";
                            if (buyBtn) { buyBtn.disabled = false; buyBtn.classList.remove('opacity-50', 'cursor-not-allowed'); }
                            if (isNaN(parseInt(qtyEl.value, 10)) || parseInt(qtyEl.value, 10) <= 0) qtyEl.value = 1;
                        }
                        if (fallback.img && mainImg) { mainImg.style.opacity = 0; setTimeout(() => { mainImg.src = fallback.img; mainImg.style.opacity = 1; }, 200); }

                        // Try to highlight attribute buttons that correspond to this fallback variant, if possible
                        if (fallback.attr) {
                            try {
                                const obj = JSON.parse(fallback.attr);
                                for (const k in obj) {
                                    if (!obj.hasOwnProperty(k)) continue;
                                    const normKey = k.toLowerCase();
                                    const normVal = String(obj[k]);
                                    const b = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
                                    if (b) b.classList.add("border-red-500", "text-red-600", "shadow-md", "z-10");
                                }
                            } catch (e) { /* ignore */ }
                        }
                    }
                }

                // If there are no variants, set hiddenVariantId to mainVariant if present (server-side case)
                <% if ((variants == null || variants.isEmpty()) && product != null && product.getMainVariant() != null) { %>
                    if (hiddenVariantInput) hiddenVariantInput.value = '<%= product.getMainVariant().getVariantId() %>';
                    window.selectedVariantId = <%= product.getMainVariant().getVariantId() %>;
                    window.selectedVariantStock = <%= product.getMainVariant().getStockQuantity() %>;
                <% } %>

                if ((isNaN(parseInt(qtyEl.value, 10)) || parseInt(qtyEl.value, 10) <= 0) && maxQty > 0) qtyEl.value = 1;

                updateButtonsState();
                updateTotalFromInput();
            }

            initializeSelectedAttributes();

            // Hook form submit (ensure variantId is always set; if not, set fallback)
const addForm = document.getElementById('addToCartForm');
if (addForm) {
  addForm.addEventListener('submit', function (e) {
    // validate and set hidden fields, then allow submit
    const hiddenVariant = document.getElementById('hiddenVariantId');
    const hiddenQuantity = document.getElementById('hiddenQuantity');
    const qtyEl = document.getElementById('qty');

    // determine variant
    let variantId = (hiddenVariant && hiddenVariant.value) ? hiddenVariant.value.trim() : '';
    if (!variantId && window.selectedVariantId) variantId = String(window.selectedVariantId);

    // Final fallback: if still no variantId but variantsData available, pick first available variant
    if (!variantId && Array.isArray(variantsData) && variantsData.length > 0) {
      const fallback = variantsData.find(v => typeof v.stock === 'number' && v.stock > 0) || variantsData[0];
      if (fallback) variantId = String(fallback.id);
      if (hiddenVariant) hiddenVariant.value = variantId;
    }

    if (!variantId) {
      e.preventDefault();
      alert('Vui lòng chọn biến thể sản phẩm trước khi đặt hàng.');
      return;
    }

    // normalize qty
    let q = 1;
    if (qtyEl && qtyEl.value) {
      const qi = parseInt(qtyEl.value.replace(/\D/g, ''), 10);
      if (!isNaN(qi) && qi > 0) q = qi;
    }
    if (hiddenVariant) hiddenVariant.value = variantId;
    if (hiddenQuantity) hiddenQuantity.value = String(q);

    // do not call e.preventDefault() -> form will submit to action attribute
    // optionally disable submit button briefly to avoid double-submit
    const submitBtn = addForm.querySelector('button[type="submit"], #buyBtn');
    if (submitBtn) { submitBtn.disabled = true; setTimeout(() => submitBtn.disabled = false, 1500); }
  });
}

            // Tab switching
            const tabBtns = document.querySelectorAll('.tab-btn');
            tabBtns.forEach(btn => btn.addEventListener('click', function(){
                tabBtns.forEach(b => b.classList.remove('text-red-500','border-b-2','border-red-500'));
                document.getElementById('tab-desc').classList.add('hidden');
                document.getElementById('tab-reviews').classList.add('hidden');
                this.classList.add('text-red-500','border-b-2','border-red-500');
                const tab = this.dataset.tab;
                if(tab === 'desc') document.getElementById('tab-desc').classList.remove('hidden');
                if(tab === 'reviews') document.getElementById('tab-reviews').classList.remove('hidden');
            }));

            // REVIEW: attach toggle only if exists (loggedIn path)
            const toggleBtn = document.getElementById('toggleReviewForm');
            const purchaseNotice = document.getElementById('purchaseNotice');
            if (toggleBtn) {
                toggleBtn.addEventListener('click', () => {
                    // priority: if user already reviewed -> show message about single review and do not open form
                    const hasReviewed = String(toggleBtn.dataset.hasReviewed) === 'true';
                    if (hasReviewed) {
                        if (purchaseNotice) {
                            purchaseNotice.textContent = "Bạn chỉ có thể gửi 1 phản hồi. Vui lòng xóa hoặc chỉnh sửa đánh giá hiện có nếu muốn thay đổi.";
                            purchaseNotice.classList.remove('hidden');
                        }
                        const rf = document.getElementById('reviewForm');
                        if (rf && !rf.classList.contains('hidden')) rf.classList.add('hidden');
                        return;
                    }

                    // second check: must have purchased to write a review
                    const hasPurchased = String(toggleBtn.dataset.hasPurchased) === 'true';
                    const rf = document.getElementById('reviewForm');

                    if (!hasPurchased) {
                        if (purchaseNotice) {
                            purchaseNotice.textContent = "Bạn phải mua sản phẩm mới được viết đánh giá.";
                            purchaseNotice.classList.remove('hidden');
                        }
                        if (rf && !rf.classList.contains('hidden')) rf.classList.add('hidden');
                        return;
                    }

                    // user has not reviewed and has purchased -> toggle form and clear notice
                    if (purchaseNotice) {
                        purchaseNotice.textContent = "";
                        purchaseNotice.classList.add('hidden');
                    }
                    if (rf) rf.classList.toggle('hidden');
                });
            }

            // Star rating listeners...
            const ratingInput = document.getElementById('ratingInput');
            const stars = document.querySelectorAll('#starRating .star');
            if (ratingInput && stars && stars.length > 0) {
                stars.forEach(star => {
                    star.addEventListener('mouseover', () => {
                        stars.forEach(s => { s.textContent = "☆"; s.classList.remove("text-yellow-400"); });
                        const v = parseInt(star.dataset.value, 10) || 0;
                        for (let i = 0; i < v; i++) {
                            stars[i].textContent = "★";
                            stars[i].classList.add("text-yellow-400");
                        }
                    });
                    star.addEventListener('click', () => { ratingInput.value = star.dataset.value; });
                    star.addEventListener('mouseout', () => {
                        const sel = parseInt(ratingInput.value, 10) || 0;
                        stars.forEach((s, idx) => {
                            s.textContent = (idx < sel) ? "★" : "☆";
                            if (idx < sel) s.classList.add("text-yellow-400"); else s.classList.remove("text-yellow-400");
                        });
                    });
                });
            }

            // Add client-side validation for the review form...
            const reviewFormInner = document.getElementById('reviewFormInner');
            if (reviewFormInner) {
                reviewFormInner.addEventListener('submit', function(e) {
                    let ok = true;
                    const ratingVal = parseInt(ratingInput.value, 10) || 0;
                    const ratingErrorEl = document.getElementById('ratingError');

                    const commentEl = document.getElementById('reviewComment');
                    const commentErrorEl = document.getElementById('commentError');

                    // Client-side validation
                    if (ratingVal < 1) { ratingErrorEl.classList.remove('hidden'); ok = false; } else { ratingErrorEl.classList.add('hidden'); }
                    if (!commentEl.value || commentEl.value.trim().length < 20) { commentErrorEl.classList.remove('hidden'); ok = false; } else { commentErrorEl.classList.add('hidden'); }

                    if (!ok) { e.preventDefault(); const firstErr = document.querySelector('.text-red-500:not(.hidden)'); if (firstErr) firstErr.scrollIntoView({behavior: 'smooth', block: 'center'}); return false; }

                    // If reached here, submit via AJAX (prevent default)
                    e.preventDefault();
                    submitReviewAjax(reviewFormInner);
                });
            }

            // safe image thumbnail handlers
            const thumbEls = document.querySelectorAll('.thumb');
            thumbEls.forEach((t, i) => t.addEventListener('click', () => showImage(i)));
        });

        // Image helpers outside DOMContentLoaded for use by inline onclick
        let currentIndex = 0;
        const images = [
            <% if (productImages != null) {
                for (int i = 0; i < productImages.size(); i++) {
                    String url = productImages.get(i).getImageUrl();
                    out.print("'" + request.getContextPath() + url + "'");
                    if (i < productImages.size() - 1) {
                        out.print(",");
                    }
                }
            } %>
        ];
        function showImage(index) {
            if (!images || index < 0 || index >= images.length) return;
            const mainImgEl = document.getElementById('mainImg');
            if (!mainImgEl) return;
            mainImgEl.style.opacity = 0;
            setTimeout(() => {
                mainImgEl.src = images[index];
                mainImgEl.style.opacity = 1;
            }, 200);
            document.querySelectorAll('.thumb').forEach((t, i) => {
                t.classList.toggle('border-red-500', i === index);
                t.classList.toggle('border-gray-200', i !== index);
            });
            currentIndex = index;
        }
        function nextImage() { showImage((currentIndex + 1) % images.length); }
        function prevImage() { showImage((currentIndex - 1 + images.length) % images.length); }

        /* ---------------------
           AJAX submit for review
           - sends X-Requested-With and Accept: application/json
           - expects JSON { success: bool, message: string, redirect?: string, login?: true }
           - on success: follow redirect if present, otherwise show success and optionally inject new review
           --------------------- */
        function showMessage(type, text) {
            // simple floating message
            let id = 'ajaxReviewFlash';
            let el = document.getElementById(id);
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
                document.body.appendChild(el);
            }
            el.textContent = text;
            el.style.background = (type === 'success') ? '#16a34a' : '#ef4444';
            el.style.display = 'block';
            clearTimeout(el._timer);
            el._timer = setTimeout(() => { el.style.display = 'none'; }, 4000);
        }

        function submitReviewAjax(form) {
            const submitBtn = form.querySelector('button[type="submit"], #submitReviewBtn');
            if (submitBtn) submitBtn.disabled = true;

            // prepare body
            const body = new URLSearchParams(new FormData(form)).toString();

            fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: body,
                credentials: 'same-origin'
            })
            .then(async resp => {
                const text = await resp.text();
                let json = null;
                try { json = text ? JSON.parse(text) : null; } catch (err) { console.error('Invalid JSON', text); }

                if (!resp.ok) {
                    if (json && json.message) {
                        showMessage('error', json.message);
                    } else {
                        showMessage('error', 'Lỗi server. Vui lòng thử lại.');
                    }
                    // if unauthorized and server suggests login, redirect user
                    if (json && json.login) {
                        const ctx = '<%= request.getContextPath() %>';
                        const redirectTo = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
                        window.location.href = redirectTo;
                    }
                    throw new Error('HTTP ' + resp.status);
                }

                if (json) {
                    if (json.success) {
                        if (json.redirect) {
                            // prefer server-suggested redirect (PRG)
                            window.location.href = json.redirect;
                            return;
                        }
                        // success without redirect: show message and optionally append new review HTML if server provided it
                        showMessage('success', json.message || 'Gửi đánh giá thành công');
                        // Optionally: reload reviews list or reload page (here we reload to reflect new review)
                        setTimeout(() => window.location.reload(), 900);
                    } else {
                        showMessage('error', json.message || 'Không thể gửi đánh giá');
                        if (json.login) {
                            const ctx = '<%= request.getContextPath() %>';
                            window.location.href = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
                        }
                    }
                } else {
                    // no json -> reload as fallback
                    window.location.reload();
                }
            })
            .catch(err => {
                console.error('Review submit error:', err);
            })
            .finally(() => {
                if (submitBtn) submitBtn.disabled = false;
            });
        }
    </script>
</body>
</html>