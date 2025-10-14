<%-- 
    Document   : product
    Created on : Oct 2, 2025, 10:19:22 AM
    Author     : Pham Nguyen Xuan Mai - CE190106
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="model.Product, model.ProductVariant, java.util.*, java.text.NumberFormat, java.util.Locale"%>

<%
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
    double defaultPrice = 0;

    // nếu product có mainVariant lấy giá đó làm mặc định
    if (product != null && product.getMainVariant() != null) {
        defaultPrice = product.getMainVariant().getPrice();
    }

    // khai báo minPrice ban đầu bằng defaultPrice để dùng an toàn
    double minPrice = defaultPrice;

    if (variants != null && !variants.isEmpty()) {
        // tính minPrice từ variants
        minPrice = Double.MAX_VALUE;
        for (ProductVariant v : variants) {
            if (v.getPrice() < minPrice) {
                minPrice = v.getPrice();
            }
        }
        // gán defaultPrice thành minPrice để đồng nhất
        defaultPrice = minPrice;
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <title><%= (product != null) ? product.getProductName() : "Sản phẩm"%></title>
    </head>

    <%@ include file="/WEB-INF/include/header.jsp" %>

    <body class="bg-gray-50 font-sans pt-20">
        <div class="max-w-6xl mx-auto p-6">

            <!-- breadcrumb -->
            <div class="text-sm text-gray-500 mb-6 font-medium">
                <a href="/WEB-INF/pages/shop.jsp" class="hover:text-red-500 transition">🏠 Trang Chủ</a> ›
                <span class="text-gray-700"><%= (product != null) ? product.getProductName() : "Không tìm thấy"%></span>
            </div>

            <!-- grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                <!-- gallery -->
                <div>
                    <img id="mainImg"
                         src="<%= (product != null && product.getMainVariant() != null) ? product.getMainVariant().getImageUrl() : "https://via.placeholder.com/300"%>"
                         class="w-full h-96 object-contain bg-white p-6 mb-4 rounded-2xl shadow-lg transition-transform duration-300 hover:scale-105">
                </div>

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
                    %>
                    <div class="mb-4">
                        <p class="font-semibold text-gray-700 text-lg mb-2">
                            <%= attrName%>: 
                            <span id="selected-<%= attrName.toLowerCase()%>" class="text-red-500 font-medium"><%= values.get(0)%></span>
                        </p>

                        <div class="flex flex-wrap gap-3">
                            <% for (String val : values) {
                                    String key = attrName + ":" + val;
                                    boolean outOfStock = stockMap.getOrDefault(key, 1) <= 0;
                                    double priceForVal = priceMap.getOrDefault(key, minPrice);
                            %>
                            <button type="button"
                                    class="attr-btn relative border rounded-lg px-4 py-2 hover:bg-gray-100 transition select-none
                                    <% if (outOfStock) { %> opacity-50 line-through border-gray-300 cursor-not-allowed out-of-stock <% } %>
                                    <% if (val.equals(values.get(0))) { %> border-red-500 text-red-600 <% }%>"
                                    onclick="selectAttr('<%= attrName.toLowerCase()%>', '<%= val%>', <%= priceForVal%>)"
                                    <%= outOfStock ? "disabled" : ""%>>
                                <%= val%>
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <% }%>

                    <style>
                        .out-of-stock::after { 
                            content: ""; position: absolute; top: 50%; left: 0;  right: 0;
                            height: 1px; background: red; transform: rotate(-20deg);
                        }
                    </style>

                    <!-- hiển thị giá -->
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(minPrice)%>₫
                        </div>
                    </div>

                    <script>
                        let currentUnitPrice = <%= Double.toString(defaultPrice)%>;

                        function formatVND(n) {
                            return n.toLocaleString('vi-VN') + "₫";
                        }

                        function selectAttr(name, value, price) {
                            const label = document.getElementById('selected-' + name);
                            if (label)
                                label.textContent = value;

                            currentUnitPrice = price;
                            document.getElementById('priceDisplay').textContent = formatVND(price);

                            const qty = parseInt(document.getElementById('qty').textContent) || 1;
                            document.getElementById('totalPrice').textContent = formatVND(price * qty);

                            // reset màu cho nút khác cùng nhóm
                            document.querySelectorAll(`.attr-btn[onclick*="'${name}'"]`).forEach(btn => {
                                btn.classList.remove("border-red-500", "text-red-600");
                            });
                            // tô màu cho nút được chọn
                            event.target.classList.add("border-red-500", "text-red-600");
                        }

                        function changeQty(n) {
                            const qtyEl = document.getElementById('qty');
                            let qty = parseInt(qtyEl.textContent) || 1;
                            qty = Math.max(1, qty + n);
                            qtyEl.textContent = qty;

                            const totalEl = document.getElementById('totalPrice');
                            totalEl.textContent = formatVND(currentUnitPrice * qty);
                        }
                    </script>

                    <% } else {%>
                    <!-- Nếu không có variants: hiển thị giá mặc định -->
                    <div class="mt-4 pb-4 border-b border-gray-200">
                        <div id="priceDisplay" class="text-red-500 text-4xl font-extrabold mt-1">
                            <%= currencyFormat.format(defaultPrice)%>₫
                        </div>
                    </div>
                    <% }%>


                    <!-- quantity -->
                    <div class="mt-6 space-y-4">
                        <div class="flex items-center gap-4">
                            <p class="font-semibold text-gray-700">Số lượng:</p>
                            <div class="flex items-center border-2 border-gray-200 rounded-xl overflow-hidden">
                                <button class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" onclick="changeQty(-1)">−</button>
                                <div id="qty" class="px-6 py-2 font-bold text-lg">1</div>
                                <button class="px-4 py-2 font-bold hover:bg-gray-100 hover:text-red-500" onclick="changeQty(1)">+</button>
                            </div>
                        </div>

                        <div class="text-lg font-semibold text-gray-800">
                            Tổng số tiền:
                            <span id="totalPrice" class="text-red-500"><%= currencyFormat.format(defaultPrice)%>₫</span>
                        </div>
                    </div>

                    <div class="mt-8">
                        <button class="w-full bg-blue-600 text-white py-4 rounded-full font-bold text-lg shadow-md hover:shadow-lg hover:bg-blue-700 transition">
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

            <!-- script tab -->
            <script>
                document.addEventListener("DOMContentLoaded", () => {
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

                    // rating
                    const stars = document.querySelectorAll("#starRating .star");
                    const ratingInput = document.getElementById("ratingInput");
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

                    // toggle form
                    const toggleBtn = document.getElementById("toggleReviewForm");
                    if (toggleBtn)
                        toggleBtn.addEventListener("click", () => document.getElementById("reviewForm").classList.toggle("hidden"));
                });

                // Hàm chỉnh số lượng - dùng currentUnitPrice trên client (được khởi tạo trong đoạn script khi có variants)
                function changeQty(n) {
                    let qtyEl = document.getElementById('qty');
                    let qty = parseInt(qtyEl.textContent) || 1;
                    qty = Math.max(1, qty + n);
                    qtyEl.textContent = qty;

                    // cố gắng lấy currentUnitPrice từ script (nếu đã định nghĩa)
                    if (typeof currentUnitPrice !== 'undefined') {
                        document.getElementById('totalPrice').textContent = (currentUnitPrice * qty).toLocaleString('vi-VN') + '₫';
                    } else {
                        // fallback: dùng giá server gán vào (defaultPrice)
                        const unitPrice = parseFloat("<%= Double.toString(defaultPrice)%>");
                        document.getElementById('totalPrice').textContent = (unitPrice * qty).toLocaleString('vi-VN') + '₫';
                    }
                }
            </script>           
        </div>
        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
