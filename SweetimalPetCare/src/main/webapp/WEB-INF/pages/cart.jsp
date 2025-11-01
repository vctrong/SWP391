<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@include file="/WEB-INF/include/library.jsp" %>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <title>Giỏ hàng - Sweetimal Pet Care</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
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
        </style>
        <!--<script src="${pageContext.request.contextPath}/assets/js/loading.js"></script>-->
    </head>
    <body class="bg-gray-50 font-sans pt-20">
        <%@ include file="/WEB-INF/include/header.jsp" %>

        <div class="max-w-6xl mx-auto p-6">
            <c:if test="${not empty checkoutError}">
                <div class="bg-red-100 text-red-800 border border-red-200 px-4 py-3 rounded mb-4">${checkoutError}</div>
            </c:if>

            <c:if test="${param.added == '1'}">
                <div class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded mb-4">Đã thêm sản phẩm vào giỏ hàng!</div>
            </c:if>

            <h1 class="text-3xl font-bold mb-6">Giỏ hàng của bạn</h1>

            <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <!-- LEFT: cart items (span 3) -->
                <div class="lg:col-span-3 bg-white p-4 rounded shadow">
                    <c:if test="${not empty cartItems}">
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
                                <c:forEach var="it" items="${cartItems}">
                                    <tr class="align-top border-b" data-order-item-id="${it.orderItemId}">
                                        <td class="py-4">
                                            <div class="flex items-center gap-4">
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${not empty it.imageUrl}">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(it.imageUrl, 'http')}">
                                                                    <img src="${it.imageUrl}" alt="${it.productName}" class="item-img" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'">
                                                                </c:when>
                                                                <c:when test="${fn:startsWith(it.imageUrl, '/')}">
                                                                    <img src="${pageContext.request.contextPath}${it.imageUrl}" alt="${it.productName}" class="item-img" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/${it.imageUrl}" alt="${it.productName}" class="item-img" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="no-image" class="item-img">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div>
                                                    <div class="font-semibold">${it.productName}</div>

                                                    <!-- inside the product cell -->
                                                    <div class="small-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty it.variant and not empty it.variant.attributeJson}">
                                                                <c:set var="raw" value="${it.variant.attributeJson}" />
                                                                <c:set var="pretty" value="${fn:replace(fn:replace(fn:replace(raw,'{\"',''),'\"}',''), '\"','')}" />
                                                                ${fn:replace(pretty, ',', ', ')}
                                                            </c:when>
                                                            <c:when test="${not empty it.variant and not empty it.variant.attributeText}">
                                                                ${it.variant.attributeText}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-gray-500">Không có thuộc tính</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- unit price and small computed display (updates with qty) -->
                                        <td class="py-4" data-unit="${it.unitPrice}">
                                            <div class="unit-price"><fmt:formatNumber value="${it.unitPrice}" type="number" groupingUsed="true"/>₫</div>
                                        </td>

                                        <!-- quantity form -->
                                        <td class="py-4">
                                            <form method="post" action="${pageContext.request.contextPath}/cart" class="inline-flex items-center update-qty-form" style="gap:.5rem" data-order-item-id="${it.orderItemId}">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="orderItemId" value="${it.orderItemId}">
                                                <input type="number" name="quantity" value="${it.quantity}" min="1" class="qty-input w-20 border rounded px-2 py-1" data-order-item-id="${it.orderItemId}">
                                            </form>
                                        </td>

                                        <!-- line total -->
                                        <td class="py-4 font-semibold">
                                            <span class="line-total"><fmt:formatNumber value="${it.lineTotal}" type="number" groupingUsed="true"/>₫</span>
                                        </td>

                                        <td class="py-4">
                                            <form method="post" action="${pageContext.request.contextPath}/cart" onsubmit="return confirm('Xác nhận xóa sản phẩm khỏi giỏ?');">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="orderItemId" value="${it.orderItemId}">
                                                <button type="submit" class="bg-red-50 text-red-600 px-3 py-1 rounded">Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <c:if test="${empty cartItems}">
                        <p class="text-gray-500">Giỏ hàng rỗng. <a href="${pageContext.request.contextPath}/shop" class="text-blue-600">Tiếp tục mua sắm</a></p>
                    </c:if>
                </div>

                <!-- RIGHT: summary -->
                <div class="lg:col-span-1 bg-white p-4 rounded shadow summary-box">
                    <h3 class="font-semibold mb-3">Tổng kết đơn hàng</h3>
                    <div class="flex justify-between mb-2">
                        <span class="muted">Tạm tính</span>
                        <span id="subtotal" class="font-medium"><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫</span>
                    </div>

                    <!-- Address selector (kept) -->
                    <c:if test="${not empty addresses}">
                        <div class="mb-3">
                            <label for="cartShippingAddress" class="muted block mb-1">Địa chỉ giao hàng</label>
                            <form id="cartCheckoutForm" method="get" action="${pageContext.request.contextPath}/checkout">
                                <select id="cartShippingAddress" name="shippingAddressId" class="w-full border rounded px-2 py-2">
                                    <c:forEach var="addr" items="${addresses}">
                                        <option value="${addr.addressId}">
                                            <c:out value="${addr.label != null ? addr.label : ''}"/>
                                            <c:if test="${not empty addr.recipientName}"> - ${addr.recipientName}</c:if>
                                            <c:if test="${not empty addr.addressLine}">, ${addr.addressLine}</c:if>
                                            <c:if test="${not empty addr.ward}">, ${addr.ward}</c:if>
                                            <c:if test="${not empty addr.district}">, ${addr.district}</c:if>
                                            <c:if test="${not empty addr.city}">, ${addr.city}</c:if>
                                            <c:if test="${addr.isDefault}"> (Mặc định)</c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${empty addresses}">
                        <div class="mb-3">
                            <div class="text-gray-600">Bạn chưa có địa chỉ giao hàng.</div>
                            <a href="${pageContext.request.contextPath}/account/addresses" class="text-blue-600 hover:underline">Thêm địa chỉ</a>
                        </div>
                    </c:if>

                    <!-- shipping removed because project does not charge shipping -->

                    <div class="border-t mt-3 pt-3 flex justify-between items-center text-lg font-bold">
                        <span>Tổng</span>
                        <span class="text-red-600" id="grandTotal"><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫</span>
                    </div>

                    <div class="mt-4 space-y-2">
                        <!-- Checkout button submits the small GET form above (if addresses exist) so checkout can prefill selected address.
                             If no addresses exist the button simply navigates to /checkout -->
                        <button type="button" id="checkoutBtn" class="w-full block bg-blue-600 text-white py-2 rounded">Thanh toán</button>

                        <a href="${pageContext.request.contextPath}/shop" class="block text-center bg-gray-100 text-gray-800 py-2 rounded border">Tiếp tục mua sắm</a>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/WEB-INF/include/footer.jsp" %>

        <script>
            // format number to VND like 1.234.567₫
            function formatVND(n) {
                if (!isFinite(n))
                    return '0₫';
                return Number(n).toLocaleString('vi-VN') + '₫';
            }

            function recalcTotals() {
                const rows = document.querySelectorAll('tr[data-order-item-id]');
                let subtotal = 0;
                rows.forEach(row => {
                    const unit = Number(row.querySelector('[data-unit]').getAttribute('data-unit')) || 0;
                    const qtyInput = row.querySelector('.qty-input');
                    const qty = qtyInput ? Math.max(1, Number(qtyInput.value) || 1) : 1;
                    const lineTotal = unit * qty;

                    const unitPriceEl = row.querySelector('.unit-price');
                    const lineEl = row.querySelector('.line-total');

                    if (unitPriceEl)
                        unitPriceEl.textContent = formatVND(unit);
                    if (lineEl)
                        lineEl.textContent = formatVND(lineTotal);

                    subtotal += lineTotal;
                });

                document.getElementById('subtotal').textContent = formatVND(subtotal);
                // Shipping is zero because project does not charge shipping
                const shipping = 0;
                document.getElementById('grandTotal').textContent = formatVND(subtotal + shipping);
            }

            // debounce helper
            function debounce(fn, ms) {
                let t;
                return function(...args) {
                    clearTimeout(t);
                    t = setTimeout(() => fn.apply(this, args), ms);
                };
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Attach handlers to update quantity inputs:
                document.querySelectorAll('.qty-input').forEach(input => {
                    // realtime client recalc
                    input.addEventListener('input', debounce(() => recalcTotals(), 120));
                    input.addEventListener('blur', function () {
                        recalcTotals();
                        // auto-submit parent form to persist quantity change
                        const form = this.closest('.update-qty-form');
                        if (form) {
                            // submit after short delay to allow blur->change stabilise
                            setTimeout(() => form.submit(), 150);
                        }
                    });
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            const form = this.closest('.update-qty-form');
                            if (form) form.submit();
                        }
                    });
                });

                // Checkout button behavior:
                const checkoutBtn = document.getElementById('checkoutBtn');
                if (checkoutBtn) {
                    checkoutBtn.addEventListener('click', function () {
                        const form = document.getElementById('cartCheckoutForm');
                        if (form) {
                            // if select exists, submit form (GET) to /checkout with shippingAddressId param
                            form.submit();
                        } else {
                            // fallback: go to checkout page
                            window.location.href = '${pageContext.request.contextPath}/checkout';
                        }
                    });
                }

                // initial totals calculation
                recalcTotals();
            });
        </script>
    </body>
</html>