<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/library.jsp" %>

<%
    // determine AJAX fragment request
    boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    request.setAttribute("isAjax", isAjax);
%>

<c:choose>
    <c:when test="${not isAjax}">
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <title>Sweetimal Pet Care</title>

            <!-- noUiSlider CSS -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.css">

            <!-- Tailwind -->
            <script src="https://cdn.tailwindcss.com"></script>
        </head>
        <body class="bg-gray-50 font-sans">
            
            <%@include file="/WEB-INF/include/header.jsp" %>
    </c:when>
</c:choose>

<main class="max-w-6xl mx-auto p-6 grid grid-cols-1 md:grid-cols-4 gap-6 mt-20">
    

    <!-- Sidebar -->
    <aside id="shopSidebar" class="bg-white p-4 rounded shadow h-fit space-y-4">

        <!-- Filter tags -->
        <c:if test="${not empty paramValues.category or not empty paramValues.brand or not empty paramValues.stock or not empty param.minPrice or not empty param.maxPrice}">
            <div class="mb-3 border-b pb-3">
                <div class="flex justify-between items-center">
                    <a href="shop" class="text-blue-600 text-sm font-medium hover:underline remove-filter-link">Xóa tất cả</a>
                    <span class="text-gray-600 text-sm">
                        <c:choose>
                            <c:when test="${not empty totalProducts}">${totalProducts}</c:when>
                            <c:when test="${empty totalProducts and empty products}">0</c:when>
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

                                <c:choose>
                                    <c:when test="${not empty param.pageSize}">
                                        <c:param name="pageSize" value="${param.pageSize}" />
                                    </c:when>
                                    <c:when test="${empty param.pageSize and not empty pageSize}">
                                        <c:param name="pageSize" value="${pageSize}" />
                                    </c:when>
                                </c:choose>

                                <c:param name="removeCategory" value="${c.productCategoryId}"/>
                            </c:url>

                            <a href="${removeCategoryUrl}"
                               class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300 remove-filter-link">
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

                                <c:choose>
                                    <c:when test="${not empty param.pageSize}">
                                        <c:param name="pageSize" value="${param.pageSize}" />
                                    </c:when>
                                    <c:when test="${empty param.pageSize and not empty pageSize}">
                                        <c:param name="pageSize" value="${pageSize}" />
                                    </c:when>
                                </c:choose>

                                <c:param name="removeBrand" value="${b.brandId}"/>
                            </c:url>
                            <a href="${removeBrandUrl}"
                               class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300 remove-filter-link">
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

                            <c:choose>
                                <c:when test="${not empty param.pageSize}">
                                    <c:param name="pageSize" value="${param.pageSize}" />
                                </c:when>
                                <c:when test="${empty param.pageSize and not empty pageSize}">
                                    <c:param name="pageSize" value="${pageSize}" />
                                </c:when>
                            </c:choose>

                            <c:param name="removeStock" value="${s}"/>
                        </c:url>
                        <a href="${removeStockUrl}" class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300 remove-filter-link">
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

                            <c:choose>
                                <c:when test="${not empty param.pageSize}">
                                    <c:param name="pageSize" value="${param.pageSize}" />
                                </c:when>
                                <c:when test="${empty param.pageSize and not empty pageSize}">
                                    <c:param name="pageSize" value="${pageSize}" />
                                </c:when>
                            </c:choose>

                            <c:param name="removePrice" value="true"/>
                        </c:url>
                        <a href="${removePriceUrl}" class="bg-gray-200 text-sm px-2 py-1 rounded flex items-center gap-1 hover:bg-gray-300 remove-filter-link">
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
                    <div id="priceSlider"
                         data-start-min="${empty param.minPrice ? 0 : param.minPrice}"
                         data-start-max="${empty param.maxPrice ? (empty maxPriceInDb ? 1000000 : maxPriceInDb) : param.maxPrice}"
                         data-min="0"
                         data-max="${empty maxPriceInDb ? 1000000 : maxPriceInDb}"
                         class="mt-2"></div>

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

                    <!-- Apply changed to button with id so JS can handle immediately -->
                    <button type="button" id="applyPriceBtn"
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
        <!-- Preserve sort if present (this is OK to keep as hidden) -->
        <c:if test="${not empty param.sort}">
            <input type="hidden" name="sort" value="${param.sort}" />
        </c:if>

        <!-- Page size select -->
        <c:set var="currentPageSize" value="${empty param.pageSize ? (empty pageSize ? 12 : pageSize) : param.pageSize}" />
        <label for="pageSizeSelect" class="text-sm text-gray-600 hidden md:inline">Hiển thị</label>
        <select id="pageSizeSelect" name="pageSize" class="border rounded px-2 py-1 text-sm bg-white">
            <option value="9"  <c:if test="${(currentPageSize + 0) == 9}">selected</c:if>>9</option>
            <option value="12" <c:if test="${(currentPageSize + 0) == 12}">selected</c:if>>12</option>
            <option value="18" <c:if test="${(currentPageSize + 0) == 18}">selected</c:if>>18</option>
            <option value="24" <c:if test="${(currentPageSize + 0) == 24}">selected</c:if>>24</option>
        </select>

        <div class="hidden md:flex items-baseline gap-2">
            <label class="text-sm font-medium text-gray-600">SẮP XẾP THEO:</label>
        </div>

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

        <!-- Non-JS fallback: render hidden inputs only for users without JS -->
        <noscript>
            <c:forEach var="c" items="${paramValues.category}">
                <input type="hidden" name="category" value="${c}" />
            </c:forEach>
            <c:forEach var="b" items="${paramValues.brand}">
                <input type="hidden" name="brand" value="${b}" />
            </c:forEach>
            <c:forEach var="s" items="${paramValues.stock}">
                <input type="hidden" name="stock" value="${s}" />
            </c:forEach>

            <c:if test="${not empty param.minPrice}">
                <input type="hidden" name="minPrice" value="${param.minPrice}" />
            </c:if>
            <c:if test="${not empty param.maxPrice}">
                <input type="hidden" name="maxPrice" value="${param.maxPrice}" />
            </c:if>
        </noscript>
    </form>
</div>

    <c:if test="${not empty products}">
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
            <c:set var="isInFilter" value="${false}" />
            <c:set var="isOutFilter" value="${false}" />
            <c:forEach var="s" items="${paramValues.stock}">
                <c:if test="${s == 'inStock'}"><c:set var="isInFilter" value="${true}"/></c:if>
                <c:if test="${s == 'outOfStock'}"><c:set var="isOutFilter" value="${true}"/></c:if>
            </c:forEach>

            <c:forEach var="p" items="${products}">
                <!-- render product directly; filtering done on server (ShopDAO) -->
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

                    <c:set var="isThisBrandSelected" value="${false}" />
                    <c:forEach var="bid" items="${paramValues.brand}">
                        <c:if test="${bid == p.brandId}">
                            <c:set var="isThisBrandSelected" value="${true}" />
                        </c:if>
                    </c:forEach>

                    <c:url var="brandFilterUrl" value="shop">
                        <c:forEach var="existingCat" items="${paramValues.category}">
                            <c:param name="category" value="${existingCat}" />
                        </c:forEach>

                        <c:forEach var="existingBrand" items="${paramValues.brand}">
                            <c:if test="${existingBrand != p.brandId}">
                                <c:param name="brand" value="${existingBrand}" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${not isThisBrandSelected}">
                            <c:param name="brand" value="${p.brandId}" />
                        </c:if>

                        <c:forEach var="existingStock" items="${paramValues.stock}">
                            <c:param name="stock" value="${existingStock}" />
                        </c:forEach>

                        <c:if test="${not empty param.minPrice}">
                            <c:param name="minPrice" value="${param.minPrice}" />
                        </c:if>
                        <c:if test="${not empty param.maxPrice}">
                            <c:param name="maxPrice" value="${param.maxPrice}" />
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty param.pageSize}">
                                <c:param name="pageSize" value="${param.pageSize}" />
                            </c:when>
                            <c:when test="${empty param.pageSize and not empty pageSize}">
                                <c:param name="pageSize" value="${pageSize}" />
                            </c:when>
                        </c:choose>
                    </c:url>

                    <p class="text-xs text-gray-500">
                        Thương hiệu:
                        <span class="text-gray-700">${p.brandName}</span>
                    </p>

                    <c:if test="${not empty p.mainVariant and p.mainVariant.price ne 0}">
                        <p class="text-red-600 font-bold mt-1">
                            <fmt:formatNumber value="${p.mainVariant.price}" type="number" groupingUsed="true"/>₫
                        </p>
                    </c:if>

                    <a href="product?id=${p.productId}"
                       class="mt-2 bg-red-500 text-white text-sm py-1 rounded text-center hover:bg-red-600">
                        Xem chi tiết
                    </a>
                </div>
            </c:forEach>
        </div>

        <!-- PAGINATION -->
        <c:set var="cp" value="${empty param.page ? (empty currentPage ? 1 : currentPage) : param.page}" />
        <c:set var="tp" value="${empty totalPages ? 1 : totalPages}" />
        <c:set var="cp" value="${cp + 0}" />
        <c:set var="tp" value="${tp + 0}" />

        <c:set var="startPage" value="${cp - 2}" />
        <c:if test="${startPage < 1}">
            <c:set var="startPage" value="1" />
        </c:if>
        <c:set var="endPage" value="${startPage + 4}" />
        <c:if test="${endPage > tp}">
            <c:set var="endPage" value="${tp}" />
            <c:set var="startPage" value="${endPage - 4}" />
            <c:if test="${startPage < 1}">
                <c:set var="startPage" value="1" />
            </c:if>
        </c:if>

        <nav class="mt-6 flex items-center justify-between" aria-label="Pagination">
            <div class="hidden sm:block">
                <p class="text-sm text-gray-700">
                    Hiển thị trang
                    <span class="font-medium">${cp}</span>
                    / <span class="font-medium">${tp}</span>
                </p>
            </div>

            <div>
                <ul class="inline-flex items-center -space-x-px">
                    <li>
                        <c:choose>
                            <c:when test="${cp > 1}">
                                <c:url var="prevUrl" value="shop">
                                    <c:forEach var="existingCat" items="${paramValues.category}">
                                        <c:param name="category" value="${existingCat}" />
                                    </c:forEach>
                                    <c:forEach var="existingBrand" items="${paramValues.brand}">
                                        <c:param name="brand" value="${existingBrand}" />
                                    </c:forEach>
                                    <c:forEach var="existingStock" items="${paramValues.stock}">
                                        <c:param name="stock" value="${existingStock}" />
                                    </c:forEach>
                                    <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                    <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                    <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>

                                    <c:choose>
                                        <c:when test="${not empty param.pageSize}">
                                            <c:param name="pageSize" value="${param.pageSize}" />
                                        </c:when>
                                        <c:when test="${empty param.pageSize and not empty pageSize}">
                                            <c:param name="pageSize" value="${pageSize}" />
                                        </c:when>
                                    </c:choose>

                                    <c:param name="page" value="${cp - 1}" />
                                </c:url>
                                <a href="${prevUrl}" class="px-3 py-1 ml-0 leading-tight bg-white border border-gray-300 text-gray-500 rounded-l hover:bg-gray-100 ajax-shop-link">Prev</a>
                            </c:when>
                            <c:otherwise>
                                <span class="px-3 py-1 ml-0 leading-tight bg-gray-100 border border-gray-200 text-gray-300 rounded-l">Prev</span>
                            </c:otherwise>
                        </c:choose>
                    </li>

                    <c:if test="${startPage > 1}">
                        <li>
                            <c:url var="firstUrl" value="shop">
                                <c:forEach var="existingCat" items="${paramValues.category}">
                                    <c:param name="category" value="${existingCat}" />
                                </c:forEach>
                                <c:forEach var="existingBrand" items="${paramValues.brand}">
                                    <c:param name="brand" value="${existingBrand}" />
                                </c:forEach>
                                <c:forEach var="existingStock" items="${paramValues.stock}">
                                    <c:param name="stock" value="${existingStock}" />
                                </c:forEach>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>

                                <c:choose>
                                    <c:when test="${not empty param.pageSize}">
                                        <c:param name="pageSize" value="${param.pageSize}" />
                                    </c:when>
                                    <c:when test="${empty param.pageSize and not empty pageSize}">
                                        <c:param name="pageSize" value="${pageSize}" />
                                    </c:when>
                                </c:choose>

                                <c:param name="page" value="1" />
                            </c:url>
                            <a href="${firstUrl}" class="px-3 py-1 leading-tight bg-white border border-gray-300 text-gray-500 hover:bg-gray-100 ajax-shop-link">1</a>
                        </li>
                        <li><span class="px-2">…</span></li>
                    </c:if>

                    <c:forEach var="pg" begin="${startPage}" end="${endPage}">
                        <li>
                            <c:url var="pageUrl" value="shop">
                                <c:forEach var="existingCat" items="${paramValues.category}">
                                    <c:param name="category" value="${existingCat}" />
                                </c:forEach>
                                <c:forEach var="existingBrand" items="${paramValues.brand}">
                                    <c:param name="brand" value="${existingBrand}" />
                                </c:forEach>
                                <c:forEach var="existingStock" items="${paramValues.stock}">
                                    <c:param name="stock" value="${existingStock}" />
                                </c:forEach>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>

                                <c:choose>
                                    <c:when test="${not empty param.pageSize}">
                                        <c:param name="pageSize" value="${param.pageSize}" />
                                    </c:when>
                                    <c:when test="${empty param.pageSize and not empty pageSize}">
                                        <c:param name="pageSize" value="${pageSize}" />
                                    </c:when>
                                </c:choose>

                                <c:param name="page" value="${pg}" />
                            </c:url>

                            <c:choose>
                                <c:when test="${pg == cp}">
                                    <span class="px-3 py-1 leading-tight bg-red-500 text-white border border-red-500">${pg}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageUrl}" class="px-3 py-1 leading-tight bg-white border border-gray-300 text-gray-500 hover:bg-gray-100 ajax-shop-link">${pg}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>

                    <c:if test="${endPage < tp}">
                        <li><span class="px-2">…</span></li>
                        <li>
                            <c:url var="lastUrl" value="shop">
                                <c:forEach var="existingCat" items="${paramValues.category}">
                                    <c:param name="category" value="${existingCat}" />
                                </c:forEach>
                                <c:forEach var="existingBrand" items="${paramValues.brand}">
                                    <c:param name="brand" value="${existingBrand}" />
                                </c:forEach>
                                <c:forEach var="existingStock" items="${paramValues.stock}">
                                    <c:param name="stock" value="${existingStock}" />
                                </c:forEach>
                                <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>

                                <c:choose>
                                    <c:when test="${not empty param.pageSize}">
                                        <c:param name="pageSize" value="${param.pageSize}" />
                                    </c:when>
                                    <c:when test="${empty param.pageSize and not empty pageSize}">
                                        <c:param name="pageSize" value="${pageSize}" />
                                    </c:when>
                                </c:choose>

                                <c:param name="page" value="${tp}" />
                            </c:url>
                            <a href="${lastUrl}" class="px-3 py-1 leading-tight bg-white border border-gray-300 text-gray-500 hover:bg-gray-100 ajax-shop-link">${tp}</a>
                        </li>
                    </c:if>

                    <li>
                        <c:choose>
                            <c:when test="${cp < tp}">
                                <c:url var="nextUrl" value="shop">
                                    <c:forEach var="existingCat" items="${paramValues.category}">
                                        <c:param name="category" value="${existingCat}" />
                                    </c:forEach>
                                    <c:forEach var="existingBrand" items="${paramValues.brand}">
                                        <c:param name="brand" value="${existingBrand}" />
                                    </c:forEach>
                                    <c:forEach var="existingStock" items="${paramValues.stock}">
                                        <c:param name="stock" value="${existingStock}" />
                                    </c:forEach>
                                    <c:if test="${not empty param.minPrice}"><c:param name="minPrice" value="${param.minPrice}" /></c:if>
                                    <c:if test="${not empty param.maxPrice}"><c:param name="maxPrice" value="${param.maxPrice}" /></c:if>
                                    <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}" /></c:if>

                                    <c:choose>
                                        <c:when test="${not empty param.pageSize}">
                                            <c:param name="pageSize" value="${param.pageSize}" />
                                        </c:when>
                                        <c:when test="${empty param.pageSize and not empty pageSize}">
                                            <c:param name="pageSize" value="${pageSize}" />
                                        </c:when>
                                    </c:choose>

                                    <c:param name="page" value="${cp + 1}" />
                                </c:url>
                                <a href="${nextUrl}" class="px-3 py-1 leading-tight bg-white border border-gray-300 text-gray-500 rounded-r hover:bg-gray-100 ajax-shop-link">Next</a>
                            </c:when>
                            <c:otherwise>
                                <span class="px-3 py-1 leading-tight bg-gray-100 border border-gray-200 text-gray-300 rounded-r">Next</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </nav>
    </c:if>

    <c:if test="${empty products}">
        <div class="col-span-full text-center py-8">
            <p class="text-gray-500 text-lg">Không tìm thấy sản phẩm.</p>
        </div>
    </c:if>
    </section>
</main>

<c:choose>
    <c:when test="${not isAjax}">
        <%@include file="/WEB-INF/include/footer.jsp" %>

        <!-- expose context path for shop.js -->
        <script>
            window.CONTEXT_PATH = '${pageContext.request.contextPath}';
        </script>

        <!-- noUiSlider must be loaded before shop.js -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/noUiSlider/15.7.0/nouislider.min.js"></script>

        <!-- app script: adjust path if your static files live elsewhere -->
        <script src="${pageContext.request.contextPath}/assets/js/shop.js"></script>
        </body>
        </html>
    </c:when>
    <c:otherwise>
        <!-- AJAX fragment: only sidebar+products returned -->
    </c:otherwise>
</c:choose>