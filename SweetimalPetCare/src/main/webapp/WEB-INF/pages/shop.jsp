<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!doctype html>
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
            <aside class="bg-white p-4 rounded shadow h-fit space-y-4">

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
                <form method="get" action="shop" onsubmit="return validatePriceRange(this);">
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
                                                   onchange="this.form.submit()" />
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
                                                   onchange="this.form.submit()" />
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
                                               onchange="this.form.submit()" />
                                           <span>Còn hàng</span>
                                    </label>
                                </li>
                                <li>
                                    <label class="flex items-center gap-2" for="stock-out">
                                        <input type="checkbox" id="stock-out" name="stock" value="outOfStock"
                                        <c:if test="${isOutStockChecked}">checked</c:if>
                                            onchange="this.form.submit()" />
                                        <span>Hết hàng</span>
                                    </label>
                                </li>
                            </ul>
                        </div>

                        <!-- Price -->
                        <div>
                            <h2 class="font-semibold mb-2 mt-3">Giá</h2>
                            <div class="flex items-center gap-2">
                                <input type="number" name="minPrice" 
                                       value="${param.minPrice}" 
                                class="border rounded p-1 w-20 text-sm" placeholder="Từ" min="0" step="1000"
                                oninput="this.value = this.value.trim() === '' ? '' : this.value">
                            ₫
                            <input type="number" name="maxPrice" 
                                   value="${param.maxPrice}" 
                                   class="border rounded p-1 w-20 text-sm" placeholder="Đến" min="0" step="1000"
                                   oninput="this.value = this.value.trim() === '' ? '' : this.value">
                            ₫
                        </div>
                        <button type="submit" 
                                onclick="removeEmptyPrices(this.form)" 
                                class="bg-blue-500 text-white px-2 py-1 rounded text-sm mt-2">Áp dụng</button>
                    </div>

                    <script>
                        function removeEmptyPrices(form) {
                            if (!form.minPrice.value)
                                form.minPrice.removeAttribute("name");
                            if (!form.maxPrice.value)
                                form.maxPrice.removeAttribute("name");
                        }
                    </script>
                </form>

                <script>
                    function validatePriceRange(form) {
                        var minPrice = form.minPrice.value;
                        var maxPrice = form.maxPrice.value;
                        if (minPrice && maxPrice && parseInt(minPrice) > parseInt(maxPrice)) {
                            alert('Giá từ không được lớn hơn giá đến.');
                            return false;
                        }
                        if (minPrice && parseInt(minPrice) < 0) {
                            alert('Giá không được âm.');
                            return false;
                        }
                        return true;
                    }
                </script>
            </aside>

            <!-- Product grid -->
            <section class="md:col-span-3">
                <div class="flex items-center justify-between mb-4">
                    <h2 class="text-lg font-bold">Sản phẩm</h2>
                </div>

                <c:if test="${not empty products}">
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <c:forEach var="p" items="${products}">
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
                                <p class="text-xs text-gray-500">Thương hiệu: ${p.brandName}</p>
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
    </body>
</html>
