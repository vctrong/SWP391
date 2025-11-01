<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="model.Product, model.ProductVariant, model.ProductImg, java.util.*, java.text.NumberFormat, java.util.Locale, java.net.URLEncoder"%>
<%--<%@include file="/WEB-INF/include/library.jsp" %>--%>
<script src="${pageContext.request.contextPath}/assets/js/loading.js"></script>

<%
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    List<ProductImg> productImages = (List<ProductImg>) request.getAttribute("productImages");
    List<?> reviews = (List<?>) request.getAttribute("reviews");

    // Determine login state (adjust to your app's session attribute if different)
    boolean loggedIn = (session.getAttribute("user") != null) || (request.getUserPrincipal() != null);

    // current URL to redirect back after login
    String currentUrl = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
    String encodedRedirect = "";
    try {
        encodedRedirect = URLEncoder.encode(currentUrl, "UTF-8");
    } catch (Exception e) {
        encodedRedirect = "/";
    }

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
    double defaultPrice = 0;

    if (product != null && product.getMainVariant() != null) {
        defaultPrice = product.getMainVariant().getPrice();
    }
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

    Map<String, String> initialSelected = new HashMap<>();
    if (minPriceVariant != null) {
        String attrJson = minPriceVariant.getAttributeJson();
        if (attrJson != null && !attrJson.trim().isEmpty()) {
            try {
                String cleaned = attrJson.replaceAll("[{}\"]", "");
                String[] parts = cleaned.split(":");
                if (parts.length == 2) {
                    String key = parts[0].trim();
                    String val = parts[1].trim();
                    initialSelected.put(key.toLowerCase(), val);
                }
            } catch (Exception e) {
                // ignore parse problems
            }
        }
    }
%>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <script src="https://cdn.tailwindcss.com"></script>
    <title><%= (product != null) ? product.getProductName() : "Sản phẩm" %></title>
</head>
<body class="bg-gray-50 font-sans pt-20">
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <div class="max-w-6xl mx-auto p-6">
        <!-- breadcrumb -->
        <div class="text-sm text-gray-500 mb-6 font-medium">
            <a href="${pageContext.request.contextPath}/shop" class="hover:text-red-500 transition">🏠 Trang Chủ</a> ›
            <span class="text-gray-700"><%= (product != null) ? product.getProductName() : "Không tìm thấy" %></span>
        </div>

        <!-- grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-start">

            <!-- gallery -->
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
                            <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="${img.caption}"
                                 class="thumb w-16 h-16 object-cover rounded-lg cursor-pointer border-2
                                 <c:if test='${loop.index == 0}'>border-red-500</c:if>
                                 <c:if test='${loop.index != 0}'>border-gray-200</c:if>
                                 hover:border-red-400 transition duration-300"
                                 onclick="showImage(${loop.index})">
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- info -->
            <div class="bg-white p-8 rounded-2xl shadow-lg border border-gray-100">
                <h1 class="text-3xl font-bold text-gray-900 leading-tight">
                    <%= (product != null) ? product.getProductName() : "Không có sản phẩm" %>
                </h1>

                <!-- rating summary -->
                <%
                    double avgRating = (request.getAttribute("avgRating") != null) ? (double) request.getAttribute("avgRating") : 0;
                    int fullStars = (int) avgRating;
                    boolean halfStar = (avgRating - fullStars) >= 0.5;
                %>
                <div class="flex items-center mt-2">
                    <span class="text-yellow-500 text-lg">
                        <% for (int i = 0; i < fullStars; i++) { %>★<% } %>
                        <% if (halfStar) { %>☆<% } %>
                        <% for (int i = fullStars + (halfStar ? 1 : 0); i < 5; i++) { %>☆<% } %>
                    </span>
                    <span class="ml-2 text-gray-600"><%= String.format("%.1f", avgRating) %>/5</span>
                </div>

                <p class="text-gray-600 mt-2 text-lg">
                    Thương hiệu: <%= (product != null && product.getBrandName() != null) ? product.getBrandName() : "N/A" %>
                </p>

                <!-- attributes + price -->
                <%
                    if (variants != null && !variants.isEmpty()) {
                        Map<String, List<String>> attrMap = new LinkedHashMap<>();
                        Map<String, Double> priceMap = new HashMap<>();
                        Map<String, Integer> stockMap = new HashMap<>();

                        for (ProductVariant v : variants) {
                            String attrStr = v.getAttributeJson();
                            int qty = v.getStockQuantity();
                            double price = v.getPrice();

                            if (attrStr != null && !attrStr.isEmpty()) {
                                try {
                                    attrStr = attrStr.replaceAll("[{}\"]", "");
                                    String[] parts = attrStr.split(":");
                                    if (parts.length == 2) {
                                        String key = parts[0].trim();
                                        String val = parts[1].trim();

                                        String displayKey = key.substring(0, 1).toUpperCase() + key.substring(1).toLowerCase();

                                        if (!attrMap.containsKey(displayKey)) {
                                            attrMap.put(displayKey, new ArrayList<String>());
                                        }

                                        if (!attrMap.get(displayKey).contains(val)) {
                                            attrMap.get(displayKey).add(val);
                                            stockMap.put(displayKey + ":" + val, qty);
                                            priceMap.put(displayKey + ":" + val, price);
                                        }
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                %>

                <% for (Map.Entry<String, List<String>> entry : attrMap.entrySet()) {
                        String attrName = entry.getKey();
                        List<String> values = entry.getValue();
                        String attrKeyLower = attrName.toLowerCase();
                        String initSelectedVal = initialSelected.getOrDefault(attrKeyLower, null);
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
                                class="attr-btn relative border rounded-lg px-4 py-2 hover:bg-gray-100 transition select-none <% if (outOfStock) { %> opacity-50 border-gray-300 out-of-stock <% } %>"
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

                <style>
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
                </style>

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

                <!-- quantity -->
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

                <!-- ADD TO CART FORM -->
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

        <!-- mô tả & phản hồi -->
        <div class="mt-12 bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
            <div class="flex gap-6 border-b mb-4">
                <button class="tab-btn font-semibold pb-2 border-b-2 border-red-500 text-red-500" data-tab="desc">📝 Mô tả</button>
                <button class="tab-btn font-semibold pb-2 text-gray-500 hover:text-red-500" data-tab="reviews">⭐ Phản hồi</button>
            </div>

            <!-- mô tả -->
            <div id="tab-desc" class="tab-content">
                <p class="text-gray-700 leading-relaxed text-lg">
                    <%= (product != null && product.getDescription() != null) ? product.getDescription() : "Chưa có mô tả cho sản phẩm này." %>
                </p>
            </div>

            <!-- phản hồi -->
            <div id="tab-reviews" class="tab-content hidden">
                <h3 class="text-lg font-bold mb-3">Khách hàng đánh giá</h3>

                <!-- existing reviews always visible -->
                <c:if test="${not empty reviews}">
                    <c:forEach var="r" items="${reviews}">
                        <div class="border-b py-3">
                            <p class="font-semibold">
                                <span class="mr-2">${r.userName}</span>
                                <span class="text-yellow-500"><c:forEach begin="1" end="${r.rating}">★</c:forEach></span>
                            </p>
                            <p class="text-gray-700">${r.comment}</p>
                            <p class="text-xs text-gray-400">${r.createdAt}</p>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty reviews}">
                    <p class="text-gray-500">Chưa có phản hồi nào.</p>
                </c:if>

                <!-- Review action area:
                     - If logged in show toggle button and render the form (hidden by default)
                     - If not logged in show login CTA (no form, no toggle)
                -->
                <div class="mt-4">
                    <% if (loggedIn) { %>
                        <button id="toggleReviewForm" type="button" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 mt-4">✍️ Viết đánh giá</button>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/login?redirect=<%= encodedRedirect %>" class="inline-block bg-yellow-400 text-white px-4 py-2 rounded hover:bg-yellow-500 mt-4">🔐 Đăng nhập để viết đánh giá</a>
                        <p class="text-sm text-gray-500 mt-2">Bạn cần đăng nhập để gửi đánh giá.</p>
                    <% } %>
                </div>

                <% if (loggedIn) { %>
                    <div id="reviewForm" class="hidden bg-gray-50 p-4 rounded-lg border mt-4">
                        <form action="<%= request.getContextPath() %>/product/review" method="post" class="space-y-4">
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
                                <label class="block font-semibold mb-1">Tiêu đề đánh giá</label>
                                <input type="text" name="reviewTitle" required class="w-full border p-2 rounded">
                            </div>

                            <div>
                                <label class="block font-semibold mb-1">Nội dung đánh giá</label>
                                <textarea name="comment" required class="w-full border p-2 rounded"></textarea>
                            </div>

                            <button id="submitReviewBtn" type="submit" class="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 transition">Gửi đánh giá</button>
                        </form>
                    </div>
                <% } %>

            </div>
        </div>

        <!-- related products -->
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

            // Initialize selections silently (visual = false)
            function initializeSelectedAttributes() {
                const preselectedBtns = document.querySelectorAll('.attr-btn.border-red-500, .attr-btn.text-red-600');
                let applied = false;
                preselectedBtns.forEach(btn => {
                    const name = btn.dataset && btn.dataset.attrName;
                    const value = btn.dataset && btn.dataset.attrValue;
                    const price = btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : undefined;
                    if (name && value) {
                        selectAttr(btn, name, value, price, false);
                        applied = true;
                    }
                });

                if (!applied && Array.isArray(variantsData) && variantsData.length > 0) {
                    const v = variantsData[0];
                    if (v.attr) {
                        try {
                            const obj = JSON.parse(v.attr);
                            for (const k in obj) {
                                if (!obj.hasOwnProperty(k)) continue;
                                const normKey = k.toLowerCase();
                                const normVal = String(obj[k]);
                                const btn = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
                                if (btn) selectAttr(btn, normKey, normVal, btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : v.price, false);
                            }
                        } catch (e) { /* ignore */ }
                    } else {
                        currentUnitPrice = v.price;
                        if (priceDisplay) priceDisplay.textContent = formatVND(currentUnitPrice);
                        maxQty = (typeof v.stock === 'number' && v.stock >= 0) ? v.stock : 99;
                        if (maxQty <= 0) {
                            if (stockInfo) stockInfo.textContent = "Tạm thời hết hàng";
                            if (buyBtn) { buyBtn.disabled = true; buyBtn.classList.add('opacity-50', 'cursor-not-allowed'); }
                            qtyEl.value = 0;
                        } else {
                            if (stockInfo) stockInfo.textContent = "Còn " + maxQty + " sản phẩm";
                            if (buyBtn) { buyBtn.disabled = false; buyBtn.classList.remove('opacity-50', 'cursor-not-allowed'); }
                            if (isNaN(parseInt(qtyEl.value, 10)) || parseInt(qtyEl.value, 10) <= 0) qtyEl.value = 1;
                        }
                        if (v.img && mainImg) { mainImg.style.opacity = 0; setTimeout(() => { mainImg.src = v.img; mainImg.style.opacity = 1; }, 200); }
                        window.selectedVariantId = v.id;
                        window.selectedVariantStock = v.stock;
                        if (hiddenVariantInput) hiddenVariantInput.value = String(v.id);
                    }
                }

                // If there are no variants, set hiddenVariantId to mainVariant if present
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

            // Hook form submit
            const addForm = document.getElementById('addToCartForm');
            if (addForm) {
                addForm.addEventListener('submit', function (e) {
                    const qtyVal = parseInt(qtyEl.value, 10);
                    const q = isNaN(qtyVal) || qtyVal < 1 ? 1 : qtyVal;
                    const hiddenQty = document.getElementById('hiddenQuantity');
                    if (hiddenQty) hiddenQty.value = q;

                    if (Array.isArray(variantsData) && variantsData.length > 0) {
                        if (!window.selectedVariantId) {
                            e.preventDefault();
                            alert('Vui lòng chọn đầy đủ thuộc tính sản phẩm (kích thước, màu, ...).');
                            return false;
                        }
                        if (typeof window.selectedVariantStock === 'number' && window.selectedVariantStock <= 0) { 
                            e.preventDefault();
                            alert('Sản phẩm tạm thời hết hàng, không thể đặt hàng.');
                            return false;
                        }
                    } else {
                        // fallback: if product.mainVariant exists, set hiddenVariantId (server rendered)
                        <% if (product != null && product.getMainVariant() != null) { %>
                            const hiddenVariant = document.getElementById('hiddenVariantId');
                            if (hiddenVariant && !hiddenVariant.value) hiddenVariant.value = '<%= product.getMainVariant().getVariantId() %>';
                        <% } %>
                    }

                    if (window.selectedVariantId) {
                        const hiddenVariant = document.getElementById('hiddenVariantId');
                        if (hiddenVariant) hiddenVariant.value = window.selectedVariantId;
                    }
                });
            }

            // Tab switching
            const tabBtns = document.querySelectorAll('.tab-btn');
            const tabContents = document.querySelectorAll('.tab-content');
            tabBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    tabBtns.forEach(b => b.classList.remove('text-red-500', 'border-red-500'));
                    tabContents.forEach(c => c.classList.add('hidden'));
                    btn.classList.add('text-red-500', 'border-red-500');
                    const tab = btn.dataset && btn.dataset.tab;
                    if (tab) {
                        const el = document.getElementById('tab-' + tab);
                        if (el) el.classList.remove('hidden');
                    }
                });
            });

            // REVIEW: attach toggle only if exists (loggedIn path)
            const toggleBtn = document.getElementById('toggleReviewForm');
            if (toggleBtn) {
                toggleBtn.addEventListener('click', () => {
                    const rf = document.getElementById('reviewForm');
                    if (rf) rf.classList.toggle('hidden');
                });
            }

            // Star rating listeners only if review form exists and ratingInput present
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
                    if (i < productImages.size() - 1) out.print(",");
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
    </script>
</body>
</html>