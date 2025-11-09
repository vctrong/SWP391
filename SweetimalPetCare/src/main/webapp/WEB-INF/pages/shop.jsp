<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.js"></script>
<%@include file="/WEB-INF/include/library.jsp" %>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Sweetimal Pet Care</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 font-sans">
        <%@include file="/WEB-INF/include/header.jsp" %>
        <main class="max-w-6xl mx-auto p-6 grid grid-cols-1 md:grid-cols-4 gap-6 mt-20">

            <!-- Sidebar -->
            <aside id="shopSidebar" class="bg-white p-4 rounded shadow h-fit space-y-4">

                <!-- Filter tags -->
                <c:if test="${not empty paramValues.category or not empty paramValues.brand or not empty paramValues.stock or not empty param.minPrice or not empty param.maxPrice}">
                    <div class="mb-3 border-b pb-3">
                        <div class="flex justify-between items-center">
                            <a href="shop" class="text-blue-600 text-sm font-medium hover:underline">Xóa tất cả</a>
                            <span class="text-gray-600 text-sm">
                                <c:choose>
                                    <c:when test="${empty products}">0</c:when>
                                    <c:otherwise>${fn:length(products)}</c:otherwise>
                                </c:choose> kết quả
                            </span>
                        </div>

                        <div class="flex flex-wrap gap-2 mt-2">
                            <!-- Category tags -->
                            <c:forEach var="c" items="${categories}">
                                <c:set var="isCategoryActive" value="${false}" />
                                <c:forEach var="cid" items="${paramValues.category}">
                                    <c:if test="${cid == c.productCategoryId}">
                                        <c:set var="isCategoryActive" value="${true}" />
                                    </c:if>
                                </c:forEach>

                                <c:if test="${isCategoryActive}">
                                    <c:url var="removeCategoryUrl" value="shop">
                                        <c:forEach var="existingCat" items="${paramValues.category}">
                                            <c:if test="${existingCat != c.productCategoryId}">
                                                <c:param name="category" value="${existingCat}"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:forEach var="existingBrand" items="${paramValues.brand}">
                                            <c:param name="brand" value="${existingBrand}"/>
                                        </c:forEach>
                                        <c:forEach var="existingStock" items="${paramValues.stock}">
                                            <c:param name="stock" value="${existingStock}"/>
                                        </c:forEach>
                                        <c:if test="${not empty param.minPrice}">
                                            <c:param name="minPrice" value="${param.minPrice}"/>
                                        </c:if>
                                        <c:if test="${not empty param.maxPrice}">
                                            <c:param name="maxPrice" value="${param.maxPrice}"/>
                                        </c:if>
                                        <c:param name="removeCategory" value="${c.productCategoryId}"/>
                                    </c:url>

                                    <a href="${removeCategoryUrl}"
                                       class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300">
                                        ${c.categoryName} <span class="text-gray-500 ml-1">×</span>
                                    </a>
                                </c:if>
                            </c:forEach>

                            <!-- Brand tags -->
                            <c:forEach var="b" items="${brands}">
                                <c:set var="isBrandActive" value="${false}" />
                                <c:forEach var="bid" items="${paramValues.brand}">
                                    <c:if test="${bid == b.brandId}">
                                        <c:set var="isBrandActive" value="${true}" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${isBrandActive}">
                                    <c:url var="removeBrandUrl" value="shop">
                                        <c:forEach var="existingCat" items="${paramValues.category}">
                                            <c:param name="category" value="${existingCat}"/>
                                        </c:forEach>
                                        <c:forEach var="existingBrand" items="${paramValues.brand}">
                                            <c:if test="${existingBrand != b.brandId}">
                                                <c:param name="brand" value="${existingBrand}"/>
                                            </c:if>
                                        </c:forEach>
                                        <c:forEach var="existingStock" items="${paramValues.stock}">
                                            <c:param name="stock" value="${existingStock}"/>
                                        </c:forEach>
                                        <c:if test="${not empty param.minPrice}">
                                            <c:param name="minPrice" value="${param.minPrice}"/>
                                        </c:if>
                                        <c:if test="${not empty param.maxPrice}">
                                            <c:param name="maxPrice" value="${param.maxPrice}"/>
                                        </c:if>
                                        <c:param name="removeBrand" value="${b.brandId}"/>
                                    </c:url>
                                    <a href="${removeBrandUrl}"
                                       class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300">
                                        ${b.brandName} <span class="text-gray-500 ml-1">×</span>
                                    </a>
                                </c:if>
                            </c:forEach>

                            <!-- Stock tags -->
                            <c:forEach var="s" items="${paramValues.stock}">
                                <c:url var="removeStockUrl" value="shop">
                                    <c:forEach var="existingCat" items="${paramValues.category}">
                                        <c:param name="category" value="${existingCat}"/>
                                    </c:forEach>
                                    <c:forEach var="existingBrand" items="${paramValues.brand}">
                                        <c:param name="brand" value="${existingBrand}"/>
                                    </c:forEach>
                                    <c:forEach var="existingStock" items="${paramValues.stock}">
                                        <c:if test="${existingStock != s}">
                                            <c:param name="stock" value="${existingStock}"/>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${not empty param.minPrice}">
                                        <c:param name="minPrice" value="${param.minPrice}"/>
                                    </c:if>
                                    <c:if test="${not empty param.maxPrice}">
                                        <c:param name="maxPrice" value="${param.maxPrice}"/>
                                    </c:if>
                                    <c:param name="removeStock" value="${s}"/>
                                </c:url>
                                <a href="${removeStockUrl}" class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300">
                                    <c:choose>
                                        <c:when test="${s == 'inStock'}">Còn hàng</c:when>
                                        <c:otherwise>Hết hàng</c:otherwise>
                                    </c:choose>
                                    <span class="text-gray-500 ml-1">×</span>
                                </a>
                            </c:forEach>

                            <!-- Price tags -->
                            <c:if test="${not empty param.minPrice or not empty param.maxPrice}">
                                <c:url var="removePriceUrl" value="shop">
                                    <c:forEach var="existingCat" items="${paramValues.category}">
                                        <c:param name="category" value="${existingCat}"/>
                                    </c:forEach>
                                    <c:forEach var="existingBrand" items="${paramValues.brand}">
                                        <c:param name="brand" value="${existingBrand}"/>
                                    </c:forEach>
                                    <c:forEach var="existingStock" items="${paramValues.stock}">
                                        <c:param name="stock" value="${existingStock}"/>
                                    </c:forEach>
                                    <c:param name="removePrice" value="true"/>
                                </c:url>
                                <a href="${removePriceUrl}" class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300">
                                    Giá: ${param.minPrice}₫ - ${param.maxPrice}₫ <span class="text-gray-500 ml-1">×</span>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Filter Form -->
                <form id="filterForm" method="get" action="shop">
                    <!-- Category -->
                    <div>
                        <h2 class="font-semibold mb-2">Loại sản phẩm</h2>
                        <ul class="space-y-1 text-sm">
                            <c:forEach var="c" items="${categories}" varStatus="status">
                                <c:set var="isCheckedCat" value="${false}" />
                                <c:forEach var="existingCat" items="${paramValues.category}">
                                    <c:if test="${existingCat == c.productCategoryId}">
                                        <c:set var="isCheckedCat" value="${true}" />
                                    </c:if>
                                </c:forEach>

                                <li>
                                    <label class="flex items-center gap-2" for="cat-${status.index}">
                                        <input type="checkbox"
                                               id="cat-${status.index}"
                                               name="category"
                                               value="${c.productCategoryId}"
                                               <c:if test="${c.productCount == 0}">disabled</c:if>
                                               <c:if test="${isCheckedCat}">checked</c:if>
                                               />
                                        <c:if test="${c.productCount == 0}">
                                            <span class="text-gray-400">${c.categoryName} (${c.productCount})</span>
                                        </c:if>
                                        <c:if test="${c.productCount != 0}">
                                            <span>${c.categoryName} (${c.productCount})</span>
                                        </c:if>
                                    </label>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                    <!-- Brand -->
                    <div>
                        <h2 class="font-semibold mb-2 mt-3">Thương hiệu</h2>
                        <ul class="space-y-1 text-sm">
                            <c:forEach var="b" items="${brands}" varStatus="status">
                                <c:set var="isCheckedBrand" value="${false}" />
                                <c:forEach var="existingBrand" items="${paramValues.brand}">
                                    <c:if test="${existingBrand == b.brandId}">
                                        <c:set var="isCheckedBrand" value="${true}" />
                                    </c:if>
                                </c:forEach>
                                <li>
                                    <label class="flex items-center gap-2" for="brand-${status.index}">
                                        <input type="checkbox"
                                               id="brand-${status.index}"
                                               name="brand"
                                               value="${b.brandId}"
                                               <c:if test="${b.productCount == 0}">disabled</c:if>
                                               <c:if test="${isCheckedBrand}">checked</c:if>
                                               />
                                        <c:if test="${b.productCount == 0}">
                                            <span class="text-gray-400">${b.brandName} (${b.productCount})</span>
                                        </c:if>
                                        <c:if test="${b.productCount != 0}">
                                            <span>${b.brandName} (${b.productCount})</span>
                                        </c:if>
                                    </label>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                    <!-- Stock -->
                    <div>
                        <h2 class="font-semibold mb-2 mt-3">Tình trạng</h2>

                        <!-- Nhận counts từ servlet (variant-level). Mặc định 0 nếu không set -->
                        <c:set var="inStockCount" value="${empty inStockCount ? 0 : inStockCount}" />
                        <c:set var="outStockCount" value="${empty outStockCount ? 0 : outStockCount}" />

                        <ul class="space-y-1 text-sm">
                            <c:set var="isInStockChecked" value="${false}" />
                            <c:set var="isOutStockChecked" value="${false}" />
                            <c:forEach var="existingStock" items="${paramValues.stock}">
                                <c:if test="${existingStock == 'inStock'}"><c:set var="isInStockChecked" value="${true}" /></c:if>
                                <c:if test="${existingStock == 'outOfStock'}"><c:set var="isOutStockChecked" value="${true}" /></c:if>
                            </c:forEach>

                            <li>
                                <label class="flex items-center gap-2" for="stock-in">
                                    <input type="checkbox" id="stock-in" name="stock" value="inStock"
                                           <c:if test="${isInStockChecked}">checked</c:if>
                                           <c:if test="${inStockCount == 0}">disabled</c:if>
                                           />
                                           <span>
                                               Còn hàng
                                               <span class="text-gray-500 ml-1">(${inStockCount})</span>
                                    </span>
                                </label>
                            </li>
                            <li>
                                <label class="flex items-center gap-2" for="stock-out">
                                    <input type="checkbox" id="stock-out" name="stock" value="outOfStock"
                                           <c:if test="${isOutStockChecked}">checked</c:if>
                                           <c:if test="${outStockCount == 0}">disabled</c:if>
                                           />
                                           <span>
                                               Hết hàng
                                               <span class="text-gray-500 ml-1">(${outStockCount})</span>
                                    </span>
                                </label>
                            </li>
                        </ul>
                    </div>

                    <!-- Price -->
                    <div>
                        <h2 class="font-semibold mb-2 mt-3">Giá</h2>
                        <div class="px-2 space-y-3">
                            <!-- Thanh kéo 2 đầu -->
                            <div id="priceSlider"
                                 data-start-min="${empty param.minPrice ? 0 : param.minPrice}"
                                 data-start-max="${empty param.maxPrice ? (empty maxPriceInDb ? 1000000 : maxPriceInDb) : param.maxPrice}"
                                 data-min="0"
                                 data-max="${empty maxPriceInDb ? 1000000 : maxPriceInDb}"
                                 class="mt-2"></div>

                            <!-- Hai ô nhập giá -->
                            <div class="flex justify-between items-center">
                                <div class="flex items-center border rounded px-2 py-1 text-sm w-24">
                                    <input type="number" id="minPriceInput" name="minPrice"
                                           class="w-full text-center outline-none"
                                           min="0" step="1000"
                                           value="${empty param.minPrice ? 0 : param.minPrice}">₫
                                </div>
                                <span class="mx-2">—</span>
                                <div class="flex items-center border rounded px-2 py-1 text-sm w-24">
                                    <input type="number" id="maxPriceInput" name="maxPrice"
                                           class="w-full text-center outline-none"
                                           min="0" step="1000"
                                           value="${empty param.maxPrice ? (empty maxPriceInDb ? 1000000 : maxPriceInDb) : param.maxPrice}">₫
                                </div>
                            </div>

                            <button type="submit"
                                    class="w-full border border-gray-400 text-gray-800 font-medium rounded-lg mt-2 py-1 hover:bg-gray-100 transition">
                                Apply
                            </button>
                        </div>
                    </div>

                </form>

            </aside>

            <!-- Product grid -->
            <section id="productsSection" class="md:col-span-3">
<div class="flex items-center justify-between mb-4">
    <h2 class="text-lg font-bold">Sản phẩm</h2>

    <!-- Sort form: preserve existing filters -->
    <form id="sortForm" method="get" action="shop" class="flex items-center gap-3">
        <!-- preserve category filters -->
        <c:forEach var="c" items="${paramValues.category}">
            <input type="hidden" name="category" value="${c}" />
        </c:forEach>

        <!-- preserve brand filters -->
        <c:forEach var="b" items="${paramValues.brand}">
            <input type="hidden" name="brand" value="${b}" />
        </c:forEach>

        <!-- preserve stock filters -->
        <c:forEach var="s" items="${paramValues.stock}">
            <input type="hidden" name="stock" value="${s}" />
        </c:forEach>

        <!-- preserve price filters -->
        <c:if test="${not empty param.minPrice}">
            <input type="hidden" name="minPrice" value="${param.minPrice}" />
        </c:if>
        <c:if test="${not empty param.maxPrice}">
            <input type="hidden" name="maxPrice" value="${param.maxPrice}" />
        </c:if>

        <!-- show a small label indicating current sort -->
        <div class="hidden md:flex items-baseline gap-2">
            <label class="text-sm font-medium text-gray-600">SẮP XẾP THEO:</label>
        </div>

        <!-- Sort select -->
        <select name="sort" class="border rounded px-3 py-1 text-sm bg-white">
            <option value="">Mặc định</option>

            <option value="best_selling" <c:if test="${param.sort == 'best_selling'}">selected</c:if>>Bán chạy nhất</option>

            <option value="name_asc" <c:if test="${param.sort == 'name_asc'}">selected</c:if>>Thứ tự chữ cái (A-Z)</option>
            <option value="name_desc" <c:if test="${param.sort == 'name_desc'}">selected</c:if>>Thứ tự chữ cái (Z-A)</option>

            <option value="price_asc" <c:if test="${param.sort == 'price_asc'}">selected</c:if>>Giá (từ thấp đến cao)</option>
            <option value="price_desc" <c:if test="${param.sort == 'price_desc'}">selected</c:if>>Giá (từ cao xuống thấp)</option>

            <option value="date_asc" <c:if test="${param.sort == 'date_asc'}">selected</c:if>>Ngày (cũ → mới)</option>
            <option value="date_desc" <c:if test="${param.sort == 'date_desc'}">selected</c:if>>Ngày (mới → cũ)</option>
        </select>
    </form>
</div>

                <c:if test="${not empty products}">
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <!-- compute filter flags from request params -->
                        <c:set var="isInFilter" value="${false}" />
                        <c:set var="isOutFilter" value="${false}" />
                        <c:forEach var="s" items="${paramValues.stock}">
                            <c:if test="${s == 'inStock'}"><c:set var="isInFilter" value="${true}"/></c:if>
                            <c:if test="${s == 'outOfStock'}"><c:set var="isOutFilter" value="${true}"/></c:if>
                        </c:forEach>

                        <c:forEach var="p" items="${products}">
                            <%-- Decide whether to show this product given the stock filter --%>
                            <c:set var="showProduct" value="${true}" />
                            <c:choose>
                                <%-- If only outOfStock is checked (and inStock not checked) => show only stockQuantity == 0 --%>
                                <c:when test="${isOutFilter and not isInFilter}">
                                    <c:choose>
                                        <c:when test="${not empty p.mainVariant}">
                                            <c:if test="${p.mainVariant.stockQuantity != 0}">
                                                <c:set var="showProduct" value="${false}" />
                                            </c:if>
                                        </c:when>
                                        <c:when test="${empty p.mainVariant}">
                                            <%-- If no variant info, hide by default in outOfStock filter --%>
                                            <c:set var="showProduct" value="${false}" />
                                        </c:when>
                                    </c:choose>
                                </c:when>

                                <%-- If only inStock is checked (and outOfStock not checked) => show only stockQuantity > 0 --%>
                                <c:when test="${isInFilter and not isOutFilter}">
                                    <c:choose>
                                        <c:when test="${not empty p.mainVariant}">
                                            <c:if test="${p.mainVariant.stockQuantity == 0}">
                                                <c:set var="showProduct" value="${false}" />
                                            </c:if>
                                        </c:when>
                                        <c:when test="${empty p.mainVariant}">
                                            <%-- If no variant info, hide by default in inStock filter --%>
                                            <c:set var="showProduct" value="${false}" />
                                        </c:when>
                                    </c:choose>
                                </c:when>

                                <%-- otherwise show all (both checked or none checked) --%>
                                <c:otherwise>
                                    <%-- leave showProduct true --%>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${showProduct}">
                                <div class="bg-white rounded-lg shadow hover:shadow-lg transition p-3 flex flex-col relative">
                                    <c:if test="${not empty p.mainVariant and not empty p.mainVariant.discount and p.mainVariant.discount > 0}">
                                        <span class="absolute top-2 left-2 bg-red-500 text-white text-xs px-2 py-1 rounded">Giảm giá</span>
                                    </c:if>
                                    <c:if test="${not empty p.mainVariant and p.mainVariant.stockQuantity == 0}">
                                        <span class="absolute top-2 left-2 bg-gray-300 text-xs px-2 py-1 rounded">Đã bán hết</span>
                                    </c:if>

                                    <div class="h-36 overflow-hidden rounded mb-3">
                                        <a href="product?id=${p.productId}">
                                            <c:choose>
                                                <c:when test="${not empty p.mainVariant and not empty p.mainVariant.imageUrl}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(p.mainVariant.imageUrl, 'http')}">
                                                            <img src="${p.mainVariant.imageUrl}"
                                                                 class="w-full h-full object-cover"
                                                                 alt="${p.productName} - Hình ảnh chính">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}${p.mainVariant.imageUrl}"
                                                                 class="w-full h-full object-cover"
                                                                 alt="${p.productName} - Hình ảnh chính">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>

                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/images/no-image.png"
                                                         class="w-full h-full object-cover"
                                                         alt="Không có hình ảnh cho ${p.productName}">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>


                                    <h3 class="text-sm font-semibold">${p.productName}</h3>                            
                                    <%-- Make brand clickable: build shop URL that preserves other filters.
                                         If the product's brand is already selected, clicking will remove it (toggle off).
                                         Otherwise clicking will add it to the current brand filters. --%>

                                    <c:set var="isThisBrandSelected" value="${false}" />
                                    <c:forEach var="bid" items="${paramValues.brand}">
                                        <c:if test="${bid == p.brandId}">
                                            <c:set var="isThisBrandSelected" value="${true}" />
                                        </c:if>
                                    </c:forEach>

                                    <c:url var="brandFilterUrl" value="shop">
                                        <!-- preserve categories -->
                                        <c:forEach var="existingCat" items="${paramValues.category}">
                                            <c:param name="category" value="${existingCat}" />
                                        </c:forEach>

                                        <!-- preserve other brands, but skip current brand if we want to remove it -->
                                        <c:forEach var="existingBrand" items="${paramValues.brand}">
                                            <c:if test="${existingBrand != p.brandId}">
                                                <c:param name="brand" value="${existingBrand}" />
                                            </c:if>
                                        </c:forEach>

                                        <!-- if current brand not selected, add it -->
                                        <c:if test="${not isThisBrandSelected}">
                                            <c:param name="brand" value="${p.brandId}" />
                                        </c:if>

                                        <!-- preserve stock filters -->
                                        <c:forEach var="existingStock" items="${paramValues.stock}">
                                            <c:param name="stock" value="${existingStock}" />
                                        </c:forEach>

                                        <!-- preserve price -->
                                        <c:if test="${not empty param.minPrice}">
                                            <c:param name="minPrice" value="${param.minPrice}" />
                                        </c:if>
                                        <c:if test="${not empty param.maxPrice}">
                                            <c:param name="maxPrice" value="${param.maxPrice}" />
                                        </c:if>
                                    </c:url>

                                    <p class="text-xs text-gray-500">
                                        Thương hiệu: 
                                        <a href="${brandFilterUrl}" class="text-blue-600 hover:underline">${p.brandName}</a>
                                    </p>

                                    <!-- ALWAYS show price if price available, even when out of stock -->
                                    <c:choose>
                                        <c:when test="${not empty p.mainVariant and p.mainVariant.price ne 0}">
                                            <p class="text-red-600 font-bold mt-1">
                                                <fmt:formatNumber value="${p.mainVariant.price}" type="number" groupingUsed="true"/>₫
                                            </p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-gray-500 italic mt-1">Liên hệ</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="product?id=${p.productId}" 
                                       class="mt-2 bg-red-500 text-white text-sm py-1 rounded text-center hover:bg-red-600">
                                        Xem chi tiết
                                    </a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${empty products}">
                    <div class="col-span-full text-center py-8">
                        <p class="text-gray-500 text-lg">Không tìm thấy sản phẩm.</p>
                    </div>
                </c:if>
            </section>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>

        <!-- Inlined AJAX + slider JS (fixed to use context path) -->
        <script>
        (function () {
            // CONTEXT_PATH is inserted by JSP so fetch targets correct servlet path
            const CONTEXT_PATH = '${pageContext.request.contextPath}';
            const sidebarSelector = '#shopSidebar';
            const productsSelector = '#productsSection';
            const filterFormSelector = '#filterForm';
            const sortFormSelector = '#sortForm';
            let debounceTimer = null;

            function buildUrlFromForms() {
                // build URL using context path so it points to correct servlet mapping
                const base = new URL(CONTEXT_PATH + '/shop', window.location.origin).toString();
                const url = new URL(base);
                const filterForm = document.querySelector(filterFormSelector);
                const sortForm = document.querySelector(sortFormSelector);
                const forms = [filterForm, sortForm].filter(Boolean);

                forms.forEach(form => {
                    const fd = new FormData(form);
                    // mimic previous behavior: don't include empty minPrice/maxPrice
                    if (fd.get('minPrice') === '') fd.delete('minPrice');
                    if (fd.get('maxPrice') === '') fd.delete('maxPrice');

                    for (const [k, v] of fd.entries()) {
                        url.searchParams.append(k, v);
                    }
                });

                return url.toString();
            }

            function resolveHref(href) {
                try {
                    return new URL(href, window.location.href).toString();
                } catch (e) {
                    return null;
                }
            }

            function isShopUrl(urlString) {
                try {
                    const u = new URL(urlString);
                    return u.pathname === (CONTEXT_PATH + '/shop') || u.pathname.endsWith('/shop');
                } catch (e) {
                    return false;
                }
            }

            function showLoading(show) {
                let el = document.getElementById('shop-ajax-loader');
                if (show) {
                    if (!el) {
                        el = document.createElement('div');
                        el.id = 'shop-ajax-loader';
                        el.style.position = 'fixed';
                        el.style.top = '12px';
                        el.style.right = '12px';
                        el.style.padding = '6px 10px';
                        el.style.background = 'rgba(0,0,0,0.7)';
                        el.style.color = '#fff';
                        el.style.borderRadius = '6px';
                        el.style.zIndex = '9999';
                        el.textContent = 'Đang tải...';
                        document.body.appendChild(el);
                    }
                } else {
                    if (el) el.remove();
                }
            }

            function parseAndReplace(htmlText, pushState = true, targetUrl = null) {
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');

                const newSidebar = doc.querySelector(sidebarSelector);
                const newProducts = doc.querySelector(productsSelector);

                const currentSidebar = document.querySelector(sidebarSelector);
                const currentProducts = document.querySelector(productsSelector);

                if (newSidebar && currentSidebar) currentSidebar.innerHTML = newSidebar.innerHTML;
                if (newProducts && currentProducts) currentProducts.innerHTML = newProducts.innerHTML;

                if (pushState) {
                    try {
                        const urlToPush = targetUrl || buildUrlFromForms();
                        history.pushState({}, '', urlToPush);
                    } catch (e) { /* ignore */ }
                }

                initShopAjax();
            }

            function fetchAndReplace(url, pushState = true) {
                showLoading(true);
                fetch(url, {
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    credentials: 'same-origin'
                })
                    .then(resp => {
                        if (!resp.ok) throw new Error('Network response was not ok');
                        return resp.text();
                    })
                    .then(html => parseAndReplace(html, pushState, url))
                    .catch(err => {
                        console.error('Fetch error:', err);
                        // fallback: full navigation
                        window.location.href = url;
                    })
                    .finally(() => showLoading(false));
            }

            function validatePriceRange(minVal, maxVal) {
                if (minVal && maxVal && parseInt(minVal) > parseInt(maxVal)) {
                    alert('Giá từ không được lớn hơn giá đến.');
                    return false;
                }
                if (minVal && parseInt(minVal) < 0) {
                    alert('Giá không được âm.');
                    return false;
                }
                return true;
            }

            function initPriceSlider() {
                const sliderEl = document.getElementById('priceSlider');
                if (!sliderEl || typeof noUiSlider === 'undefined') return;

                if (sliderEl.noUiSlider) sliderEl.noUiSlider.destroy();

                const min = parseInt(sliderEl.getAttribute('data-min') || '0', 10);
                const max = parseInt(sliderEl.getAttribute('data-max') || '1000000', 10);
                const startMin = parseInt(sliderEl.getAttribute('data-start-min') || min, 10);
                const startMax = parseInt(sliderEl.getAttribute('data-start-max') || max, 10);

                const minInput = document.getElementById('minPriceInput');
                const maxInput = document.getElementById('maxPriceInput');

                noUiSlider.create(sliderEl, {
                    start: [startMin, startMax],
                    connect: true,
                    step: 1000,
                    range: { 'min': min, 'max': max },
                    tooltips: [true, true],
                    format: {
                        to: value => Math.round(value).toLocaleString('vi-VN'),
                        from: value => Number(value.replace(/\./g, ''))
                    }
                });

                sliderEl.noUiSlider.on('update', (values) => {
                    const v0 = parseInt(values[0].replace(/\./g, ''), 10);
                    const v1 = parseInt(values[1].replace(/\./g, ''), 10);
                    if (minInput) minInput.value = isNaN(v0) ? '' : v0;
                    if (maxInput) maxInput.value = isNaN(v1) ? '' : v1;
                });

                if (minInput) minInput.addEventListener('change', () => sliderEl.noUiSlider.set([minInput.value || null, null]));
                if (maxInput) maxInput.addEventListener('change', () => sliderEl.noUiSlider.set([null, maxInput.value || null]));
            }

            function initShopAjax() {
                initPriceSlider();

                const sidebar = document.querySelector(sidebarSelector);
                const productsArea = document.querySelector(productsSelector);
                const filterForm = document.querySelector(filterFormSelector);
                const sortForm = document.querySelector(sortFormSelector);

                if (!sidebar || !filterForm) return;

                // checkboxes trigger AJAX (debounced)
                sidebar.querySelectorAll('input[type="checkbox"]').forEach(cb => {
                    cb.onchange = () => {
                        clearTimeout(debounceTimer);
                        debounceTimer = setTimeout(() => {
                            const url = buildUrlFromForms();
                            fetchAndReplace(url);
                        }, 200);
                    };
                });

                // price form submission (Apply)
                filterForm.onsubmit = (e) => {
                    e.preventDefault();
                    const minInput = filterForm.querySelector('input[name="minPrice"]');
                    const maxInput = filterForm.querySelector('input[name="maxPrice"]');
                    const minVal = minInput ? minInput.value : '';
                    const maxVal = maxInput ? maxInput.value : '';
                    if (!validatePriceRange(minVal, maxVal)) return;
                    if (minInput && minInput.value === '') minInput.removeAttribute('name');
                    if (maxInput && maxInput.value === '') maxInput.removeAttribute('name');
                    const url = buildUrlFromForms();
                    fetchAndReplace(url);
                };

                // sort select
                if (sortForm) {
                    const sortSelect = sortForm.querySelector('select[name="sort"]');
                    if (sortSelect) {
                        sortSelect.onchange = () => {
                            const url = buildUrlFromForms();
                            fetchAndReplace(url);
                        };
                    }
                    sortForm.onsubmit = (e) => {
                        e.preventDefault();
                        const url = buildUrlFromForms();
                        fetchAndReplace(url);
                    };
                }

                // intercept sidebar tag links (remove filters links)
                sidebar.onclick = (e) => {
                    const a = e.target.closest('a');
                    if (!a) return;
                    const resolved = resolveHref(a.getAttribute('href'));
                    if (!resolved) return;
                    if (isShopUrl(resolved)) {
                        e.preventDefault();
                        fetchAndReplace(resolved);
                    }
                };

                // intercept brand links in product cards that point to /shop
                if (productsArea) {
                    productsArea.onclick = (e) => {
                        const a = e.target.closest('a');
                        if (!a) return;
                        const resolved = resolveHref(a.getAttribute('href'));
                        if (!resolved) return;
                        if (isShopUrl(resolved)) {
                            e.preventDefault();
                            fetchAndReplace(resolved);
                        }
                    };
                }
            }

            window.addEventListener('popstate', () => {
                fetchAndReplace(window.location.href, false);
            });

            document.addEventListener('DOMContentLoaded', () => {
                initShopAjax();
            });
        })();
        </script>
    </body>
</html>