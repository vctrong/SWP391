<%-- 
    Document   : product
    Created on : Oct 2, 2025, 10:19:22 AM
    Author     : Pham Nguyen Xuan Mai - CE190106
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="model.Product, model.ProductVariant, model.ProductImg, java.util.*, java.text.NumberFormat, java.util.Locale"%>

<%
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    // productImages được set trong servlet
    List<ProductImg> productImages = (List<ProductImg>) request.getAttribute("productImages");

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

    // Prepare initial selected attributes based on the variant that has the minimum price.
    // We'll extract its attribute JSON (if present) into a map for initial highlighting.
    Map<String, String> initialSelected = new HashMap<>();
    if (minPriceVariant != null) {
        String attrJson = minPriceVariant.getAttributeJson();
        if (attrJson != null && !attrJson.trim().isEmpty()) {
            try {
                // simple parse like before: {"size":"M"} -> size:M
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
        <title><%= (product != null) ? product.getProductName() : "Sản phẩm"%></title>
    </head>
    <body class="bg-gray-50 font-sans pt-20">
        <%@ include file="/WEB-INF/include/header.jsp" %>
        <div class="max-w-6xl mx-auto p-6">

            <!-- breadcrumb -->
            <div class="text-sm text-gray-500 mb-6 font-medium">
                <a href="${pageContext.request.contextPath}/shop" class="hover:text-red-500 transition">🏠 Trang Chủ</a> ›
                <span class="text-gray-700"><%= (product != null) ? product.getProductName() : "Không tìm thấy"%></span>
            </div>

            <!-- grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-start">

                <!-- 🖼️ GALLERY -->
                <div class="flex flex-col items-center">
                    <div class="relative w-full h-96 bg-white rounded-2xl shadow-lg overflow-hidden">
                        <img id="mainImg"
                             src="<%= request.getContextPath() + ((productImages != null && !productImages.isEmpty())
                                     ? productImages.get(0).getImageUrl()
                                     : "/assets/img/no-image.png")%>"
                             alt="<%= (product != null) ? product.getProductName() : "Không có hình ảnh"%>"
                             class="w-full h-full object-contain transition-all duration-500 ease-in-out opacity-100">

                        <!-- Nút trái/phải -->
                        <button type="button"
                                class="absolute left-2 top-1/2 -translate-y-1/2 bg-white/70 hover:bg-white text-gray-800 rounded-full w-8 h-8 flex items-center justify-center shadow-md"
                                onclick="prevImage()">&#10094;</button>

                        <button type="button"
                                class="absolute right-2 top-1/2 -translate-y-1/2 bg-white/70 hover:bg-white text-gray-800 rounded-full w-8 h-8 flex items-center justify-center shadow-md"
                                onclick="nextImage()">&#10095;</button>
                    </div>

                    <!-- Thumbnails nhỏ -->
                    <c:if test="${not empty productImages}">
                        <div class="flex gap-2 mt-3 justify-center flex-wrap">
                            <c:forEach var="img" items="${productImages}" varStatus="loop">
                                <img src="${pageContext.request.contextPath}${img.imageUrl}"
                                     alt="${img.caption}"
                                     class="thumb w-16 h-16 object-cover rounded-lg cursor-pointer border-2
                                     <c:if test='${loop.index == 0}'>border-red-500</c:if>
                                     <c:if test='${loop.index != 0}'>border-gray-200</c:if>
                                         hover:border-red-400 transition duration-300"
                                         onclick="showImage(${loop.index})">
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <script>
                    let currentIndex = 0;
                    const mainImg = document.getElementById('mainImg');
                    const thumbs = document.querySelectorAll('.thumb');
                    const images = [
                    <% if (productImages != null) {
                            for (int i = 0; i < productImages.size(); i++) {
                                String url = productImages.get(i).getImageUrl();
                                out.print("'" + request.getContextPath() + url + "'");
                                if (i < productImages.size() - 1) {
                                    out.print(",");
                                }
                            }
                        }%>
                    ];

                    function showImage(index) {
                        if (index < 0 || index >= images.length)
                            return;
                        mainImg.style.opacity = 0;
                        setTimeout(() => {
                            mainImg.src = images[index];
                            mainImg.style.opacity = 1;
                        }, 200);
                        thumbs.forEach((t, i) => {
                            t.classList.toggle('border-red-500', i === index);
                            t.classList.toggle('border-gray-200', i !== index);
                        });
                        currentIndex = index;
                    }

                    function nextImage() {
                        showImage((currentIndex + 1) % images.length);
                    }

                    function prevImage() {
                        showImage((currentIndex - 1 + images.length) % images.length);
                    }
                </script>
                <!-- info -->
                <div class="bg-white p-8 rounded-2xl shadow-lg border border-gray-100">
                    <h1 class="text-3xl font-bold text-gray-900 leading-tight">
                        <%= (product != null) ? product.getProductName() : "Không có sản phẩm"%>
                    </h1>

                    <!-- rating -->
                    <%
                        double avgRating = (request.getAttribute("avgRating") != null) ? (double) request.getAttribute("avgRating") : 0;
                        int fullStars = (int) avgRating;
                        boolean halfStar = (avgRating - fullStars) >= 0.5;
                    %>
                    <div class="flex items-center mt-2">
                        <span class="text-yellow-500 text-lg">
                            <% for (int i = 0; i < fullStars; i++) { %>★<% } %>
                            <% if (halfStar) { %>☆<% } %>
                            <% for (int i = fullStars + (halfStar ? 1 : 0); i < 5; i++) { %>☆<% }%>
                        </span>
                        <span class="ml-2 text-gray-600"><%= String.format("%.1f", avgRating)%>/5</span>
                    </div>

                    <p class="text-gray-600 mt-2 text-lg">
                        Thương hiệu: <%= (product != null && product.getBrandName() != null) ? product.getBrandName() : "N/A"%>
                    </p>

                    <!-- attributes + price -->
                    <%
                        if (variants != null && !variants.isEmpty()) {
                            Map<String, List<String>> attrMap = new LinkedHashMap<>();
                            Map<String, Double> priceMap = new HashMap<>();
                            Map<String, Integer> stockMap = new HashMap<>();

                            // Chuyển JSON {"weight":"3kg"} thành map key:value gọn gàng
                            for (ProductVariant v : variants) {
                                String attrStr = v.getAttributeJson();
                                int qty = v.getStockQuantity();
                                double price = v.getPrice();

                                if (attrStr != null && !attrStr.isEmpty()) {
                                    try {
                                        attrStr = attrStr.replaceAll("[{}\"]", ""); // -> weight:3kg
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
                            // initial selected value from minPriceVariant if available
                            String initSelectedVal = initialSelected.getOrDefault(attrKeyLower, null);
                    %>
                    <div class="mb-4">
                        <p class="font-semibold text-gray-700 text-lg mb-2">
                            <%= attrName%>: 
                            <span id="selected-<%= attrKeyLower%>" class="text-red-500 font-medium"><%= (initSelectedVal != null) ? initSelectedVal : values.get(0)%></span>
                        </p>

                        <div class="flex flex-wrap gap-3">
                            <% for (String val : values) {
                                    String key = attrName + ":" + val;
                                    boolean outOfStock = stockMap.getOrDefault(key, 1) <= 0;
                                    double priceForVal = priceMap.getOrDefault(key, minPrice);
                                    // determine if this button should be initially selected (red)
                                    boolean isInitiallySelected = false;
                                    if (initSelectedVal != null) {
                                        if (val.equals(initSelectedVal)) isInitiallySelected = true;
                                    } else {
                                        // fallback: if no min-price variant provided this attr, do not auto-select any
                                        isInitiallySelected = false;
                                    }
                            %>
<%
    String safeAttrName = attrKeyLower.replace("'", "\\'");
    String safeVal = val.replace("'", "\\'");
%>

<button type="button"
        class="attr-btn relative border rounded-lg px-4 py-2 hover:bg-gray-100 transition select-none
        <% if (outOfStock) { %> opacity-50 border-gray-300 cursor-not-allowed out-of-stock <% } %>
        <% if (isInitiallySelected) { %> border-red-500 text-red-600 <% }%>"
        data-attr-name="<%= safeAttrName %>"
        data-attr-value="<%= safeVal %>"
        data-price="<%= priceForVal%>"
        onclick="selectAttr(event, '<%= safeAttrName %>', '<%= safeVal %>', <%= priceForVal%>)"
        <%= outOfStock ? "disabled" : ""%>>
    <%= val %>
</button>

                            <% } %>
                        </div>
                    </div>
                    <% }%>

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

                    <!-- hiển thị giá -->
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(minPrice)%>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>

                    <% } else {%>
                    <!-- Nếu không có variants: hiển thị giá mặc định -->
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(defaultPrice)%>₫
                        </div>
                        <div id="stockInfo" class="text-sm text-gray-500 mt-1"></div>
                    </div>
                    <% }%>


                    <!-- quantity -->
                    <div class="mt-6 space-y-4">
                        <div class="flex items-center gap-4">
                            <p class="font-semibold text-gray-700">Số lượng:</p>
                            <div id="qtyWrap" class="flex items-center border-2 border-gray-200 rounded-xl overflow-hidden">
    <button id="btnDec" data-action="dec" class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" type="button">−</button>
    <input id="qty" type="text" value="1"
           class="w-16 text-center font-bold text-lg border-0 focus:outline-none"
           oninput="handleQtyInput(event)">
    <button id="btnInc" data-action="inc" class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" type="button">+</button>
</div>
<!-- thông báo ngắn khi đạt giới hạn -->
<div id="qtyAlert" class="text-sm text-red-500 ml-3 hidden"></div>

                        </div>

                        <div class="text-lg font-semibold text-gray-800">
                            Tổng số tiền:
                            <span id="totalPrice" class="text-red-500"><%= currencyFormat.format(defaultPrice)%>₫</span>
                        </div>
                    </div>

                    <div class="mt-8">
                        <button id="buyBtn" class="w-full bg-blue-600 text-white py-4 rounded-full font-bold text-lg shadow-md hover:shadow-lg hover:bg-blue-700 transition">
                            Đặt Hàng
                        </button>
                    </div>
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
                        <%= (product != null && product.getDescription() != null) ? product.getDescription() : "Chưa có mô tả cho sản phẩm này."%>
                    </p>
                </div>

                <!-- phản hồi -->
                <div id="tab-reviews" class="tab-content hidden">
                    <h3 class="text-lg font-bold mb-3">Khách hàng đánh giá</h3>
                    <c:if test="${not empty reviews}">
                        <c:forEach var="r" items="${reviews}">
                            <div class="border-b py-3">
                                <p class="font-semibold">
                                    <span class="mr-2">${r.userName}</span>
                                    <span class="text-yellow-500"><c:forEach begin="1" end="${r.rating}">★</c:forEach></span>
                                    </p>
                                    <p class="text-gray-700">${r.comment}</p>
                                <p class="text-xs text-gray-400">${r.createdAt}</p>
                                <c:if test="${not empty r.youtubeUrl}">
                                    <div class="mt-2"><a href="${r.youtubeUrl}" target="_blank" class="text-blue-500 hover:underline">📺 Xem video</a></div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty reviews}">
                        <p class="text-gray-500">Chưa có phản hồi nào.</p>
                    </c:if>

                    <button id="toggleReviewForm" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 mt-4">✍️ Viết đánh giá</button>

                    <!-- form -->
                    <div id="reviewForm" class="hidden bg-gray-50 p-4 rounded-lg border mt-4">
                        <form action="product" method="post" class="space-y-4">
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
                                <label class="block font-semibold mb-1">Tiêu đề đánh giá</label>
                                <input type="text" name="reviewTitle" required class="w-full border p-2 rounded">
                            </div>

                            <div>
                                <label class="block font-semibold mb-1">Nội dung đánh giá</label>
                                <textarea name="comment" required class="w-full border p-2 rounded"></textarea>
                            </div>

                            <div>
                                <label class="block font-semibold mb-1">Video YouTube (tùy chọn)</label>
                                <input type="url" name="youtubeUrl" placeholder="Dán link YouTube vào đây" class="w-full border p-2 rounded">
                            </div>

                            <button type="submit" class="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 transition">
                                Gửi đánh giá
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                // Danh sách variant (attribute_json + price + image + stock)
                const variantsData = [
                <% if (variants != null) {
                        for (int i = 0; i < variants.size(); i++) {
                            ProductVariant v = variants.get(i);
                            String attr = v.getAttributeJson();
                            double price = v.getPrice();
                            String img = v.getImageUrl();
                            int stock = v.getStockQuantity();
                            if (img == null || img.isEmpty()) {
                                img = "/assets/img/no-image.png";
                            }
                %>
                {
                attr: '<%= attr != null ? attr.replaceAll("'", "\\\\'") : ""%>',
                        price: <%= price%>,
                        img: '<%= request.getContextPath() + img%>',
                        stock: <%= stock %>
                }<%= (i < variants.size() - 1) ? "," : ""%>
                <% }
                    }%>
                ];

   document.addEventListener("DOMContentLoaded", () => {
    const mainImg = document.getElementById('mainImg');
    const priceDisplay = document.getElementById('priceDisplay');
    const totalPrice = document.getElementById('totalPrice');
    const qtyEl = document.getElementById('qty');
    const btnInc = document.getElementById('btnInc');
    const btnDec = document.getElementById('btnDec');
    const buyBtn = document.getElementById('buyBtn');
    const stockInfo = document.getElementById('stockInfo');
    const qtyAlert = document.getElementById('qtyAlert');

    let currentUnitPrice = <%= Double.toString(defaultPrice)%>;
    let maxQty = 99;
    const selectedAttrs = {};

    // flags để tránh double-call khi mousedown + click
    let ignoreClickInc = false;
    let ignoreClickDec = false;

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

    // Cập nhật nút +/- (disable nếu cần)
    function updateButtonsState() {
        let qty = parseInt(qtyEl.value, 10);
        if (isNaN(qty)) qty = 0; // allow empty input
        if (qty > maxQty) qty = maxQty;
        qtyEl.value = (qty === 0 && maxQty !== 0) ? "" : qty; // keep empty if user deleted and not out of stock

        btnDec.disabled = qty <= 1;
        btnInc.disabled = (maxQty === 0) || (qty >= maxQty);

        if (btnDec.disabled) btnDec.classList.add('opacity-50', 'cursor-not-allowed'); else btnDec.classList.remove('opacity-50', 'cursor-not-allowed');
        if (btnInc.disabled) btnInc.classList.add('opacity-50', 'cursor-not-allowed'); else btnInc.classList.remove('opacity-50', 'cursor-not-allowed');
    }

    // Cập nhật tổng tiền hiển thị dựa trên giá hiện tại và qty.value
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

    // changeQty: nếu input rỗng thì coi là 0, nhấn + => thành 1
    window.changeQty = function(n) {
        let qty = parseInt(qtyEl.value, 10);
        if (isNaN(qty)) qty = 0; // allow increase from 0 -> 1
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

    window.handleQtyInput = function(event) {
        const input = event.target;
        const digits = input.value.replace(/\D/g, "");
        input.value = digits;

        const val = parseInt(digits, 10);
        if (!isNaN(val) && val > maxQty) {
            showQtyAlert("Bạn đã đạt giới hạn: " + maxQty);
        }

        updateTotalFromInput(false);

        if (event.key === "Enter") {
            input.blur();
        }
    };

    // Long-press support
    let holdTimer = null;
    let holdInterval = null;
    const HOLD_DELAY = 350;
    const HOLD_INTERVAL = 120;

    function startHold(increment, btn) {
        if (btn === btnInc) ignoreClickInc = true;
        if (btn === btnDec) ignoreClickDec = true;

        changeQty(increment);

        holdTimer = setTimeout(() => {
            holdInterval = setInterval(() => {
                changeQty(increment);
            }, HOLD_INTERVAL);
        }, HOLD_DELAY);
    }

    function stopHold() {
        if (holdTimer) { clearTimeout(holdTimer); holdTimer = null; }
        if (holdInterval) { clearInterval(holdInterval); holdInterval = null; }
    }

    if (btnInc) {
        btnInc.addEventListener('click', (e) => {
            if (ignoreClickInc) { ignoreClickInc = false; return; }
            changeQty(1);
        });
        btnInc.addEventListener('mousedown', (e) => startHold(1, btnInc));
        btnInc.addEventListener('touchstart', (e) => startHold(1, btnInc), {passive:true});
        btnInc.addEventListener('mouseup', stopHold);
        btnInc.addEventListener('mouseleave', stopHold);
        btnInc.addEventListener('touchend', stopHold);
    }

    if (btnDec) {
        btnDec.addEventListener('click', (e) => {
            if (ignoreClickDec) { ignoreClickDec = false; return; }
            changeQty(-1);
        });
        btnDec.addEventListener('mousedown', (e) => startHold(-1, btnDec));
        btnDec.addEventListener('touchstart', (e) => startHold(-1, btnDec), {passive:true});
        btnDec.addEventListener('mouseup', stopHold);
        btnDec.addEventListener('mouseleave', stopHold);
        btnDec.addEventListener('touchend', stopHold);
    }

    if (qtyEl) {
        qtyEl.addEventListener('blur', () => {
            let val = parseInt(qtyEl.value, 10);
            if (isNaN(val) || val < 1) {
                if (maxQty === 0) {
                    qtyEl.value = 0;
                    totalPrice.textContent = formatVND(0);
                } else {
                    qtyEl.value = 1;
                }
            } else if (val > maxQty) {
                qtyEl.value = maxQty;
                showQtyAlert("Bạn đã đạt giới hạn: " + maxQty);
            }
            updateTotalFromInput();
        });

        qtyEl.addEventListener('input', handleQtyInput);
        qtyEl.addEventListener('keydown', function(e){
            if (e.key === "Enter") { qtyEl.blur(); }
        });
    }

    /* -------- selectAttr: dùng data-* để reset/hi-light và tìm variant -------- */
    window.selectAttr = function (event, name, value, price) {
        if (!event || !event.target) return;

        const key = name.toLowerCase();

        // cập nhật lựa chọn nội bộ
        selectedAttrs[key] = value;
        const label = document.getElementById('selected-' + key);
        if (label) label.textContent = value;

        // Reset style cho các nút cùng nhóm (dựa vào data-attr-name)
        document.querySelectorAll(`.attr-btn[data-attr-name="${key}"]`).forEach(btn => {
            btn.classList.remove("border-red-500", "text-red-600");
        });
        // highlight nút vừa chọn
        event.target.classList.add("border-red-500", "text-red-600");

        // tìm variant khớp với mọi thuộc tính đã chọn
        let matchedVariant = null;
        for (const v of variantsData) {
            try {
                const obj = v.attr ? JSON.parse(v.attr) : {};
                let match = true;
                for (const selKey in selectedAttrs) {
                    const want = String(selectedAttrs[selKey]);
                    // tìm giá trị trong obj, so sánh lowercase keys
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
                // ignore JSON parse errors
            }
        }

        if (matchedVariant) {
            currentUnitPrice = matchedVariant.price;
            priceDisplay.textContent = formatVND(currentUnitPrice);

            maxQty = (typeof matchedVariant.stock === 'number' && matchedVariant.stock >= 0) ? matchedVariant.stock : 99;

            if (maxQty <= 0) {
                stockInfo.textContent = "Tạm thời hết hàng";
                buyBtn.disabled = true;
                buyBtn.classList.add('opacity-50','cursor-not-allowed');
                qtyEl.value = 0;
                updateTotalFromInput();
                updateButtonsState();
            } else {
                stockInfo.textContent = "Còn " + maxQty + " sản phẩm";
                buyBtn.disabled = false;
                buyBtn.classList.remove('opacity-50','cursor-not-allowed');
                let q = parseInt(qtyEl.value, 10);
                if (!isNaN(q) && q > maxQty) qtyEl.value = maxQty;
                updateTotalFromInput();
            }

            if (matchedVariant.img) {
                mainImg.style.opacity = 0;
                setTimeout(() => { mainImg.src = matchedVariant.img; mainImg.style.opacity = 1; }, 200);
            }
        } else {
            // chưa đủ lựa chọn -> chỉ hiển thị price param (tạm)
            currentUnitPrice = price;
            priceDisplay.textContent = formatVND(price);
            maxQty = 99;
            stockInfo.textContent = "";
            buyBtn.disabled = false;
            buyBtn.classList.remove('opacity-50','cursor-not-allowed');
            updateTotalFromInput();
        }
    };

    /* -------- initialize: highlight only attributes from min-price variant (if exists), then call selectAttr for them -------- */
    function initializeSelectedAttributes() {
        // find attr buttons that were server-marked as selected (we added border-red class server-side)
        const preselectedBtns = document.querySelectorAll('.attr-btn.border-red-500, .attr-btn.text-red-600');
        let applied = false;
        preselectedBtns.forEach(btn => {
            // prefer dataset if available
            const name = btn.dataset && btn.dataset.attrName;
            const value = btn.dataset && btn.dataset.attrValue;
            const price = btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : undefined;
            if (name && value) {
                // call selectAttr with a fake event target to ensure consistency
                selectAttr({ target: btn }, name, value, price);
                applied = true;
            }
        });

        // fallback: if nothing preselected but variantsData exists, use first variant's attributes to set UI
        if (!applied && Array.isArray(variantsData) && variantsData.length > 0) {
            const v = variantsData[0];
            // try parse v.attr and apply
            if (v.attr) {
                try {
                    const obj = JSON.parse(v.attr);
                    for (const k in obj) {
                        if (!obj.hasOwnProperty(k)) continue;
                        const normKey = k.toLowerCase();
                        const normVal = String(obj[k]);
                        // find button that matches data-attr-name and data-attr-value
                        const btn = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
                        if (btn) {
                            selectAttr({ target: btn }, normKey, normVal, btn.dataset && btn.dataset.price ? Number(btn.dataset.price) : v.price);
                        }
                    }
                } catch (e) {
                    // ignore
                }
            } else {
                // set price & stock fallback
                currentUnitPrice = v.price;
                priceDisplay.textContent = formatVND(currentUnitPrice);
                maxQty = (typeof v.stock === 'number' && v.stock >= 0) ? v.stock : 99;
                if (maxQty <= 0) {
                    stockInfo.textContent = "Tạm thời hết hàng";
                    buyBtn.disabled = true;
                    buyBtn.classList.add('opacity-50','cursor-not-allowed');
                    qtyEl.value = 0;
                } else {
                    stockInfo.textContent = "Còn " + maxQty + " sản phẩm";
                    buyBtn.disabled = false;
                    buyBtn.classList.remove('opacity-50','cursor-not-allowed');
                }
                if (v.img) {
                    mainImg.style.opacity = 0;
                    setTimeout(() => { mainImg.src = v.img; mainImg.style.opacity = 1; }, 200);
                }
            }
        }

        updateButtonsState();
        updateTotalFromInput();
    }

    // call init
    initializeSelectedAttributes();

    // 👉 Tabs (Mô tả - Phản hồi)
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('text-red-500', 'border-red-500'));
            tabContents.forEach(c => c.classList.add('hidden'));
            btn.classList.add('text-red-500', 'border-red-500');
            document.getElementById('tab-' + btn.dataset.tab).classList.remove('hidden');
        });
    });

    // 👉 Xếp hạng sao
    const stars = document.querySelectorAll("#starRating .star");
    const ratingInput = document.getElementById("ratingInput");
    if (stars.length > 0) {
        stars.forEach(star => {
            star.addEventListener("mouseover", () => {
                resetStars();
                highlight(star.dataset.value);
            });
            star.addEventListener("click", () => {
                ratingInput.value = star.dataset.value;
            });
            star.addEventListener("mouseout", () => {
                resetStars();
                highlight(ratingInput.value);
            });
        });

        function highlight(count) {
            for (let i = 0; i < count; i++) {
                stars[i].textContent = "★";
                stars[i].classList.add("text-yellow-400");
            }
        }

        function resetStars() {
            stars.forEach(s => {
                s.textContent = "☆";
                s.classList.remove("text-yellow-400");
            });
        }
    }

    // 👉 Toggle form phản hồi
    const toggleBtn = document.getElementById("toggleReviewForm");
    if (toggleBtn)
        toggleBtn.addEventListener("click", () => {
            document.getElementById("reviewForm").classList.toggle('hidden');
        });
});
            </script>


        </div>
        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>