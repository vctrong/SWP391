<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Thanh toán - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <%@include file="/WEB-INF/include/library.jsp" %>
    <c:set var="effectiveUser" value="${sessionScope.user}" />
    <c:set var="isLoggedIn" value="${not empty effectiveUser}" />
    <c:if test="${isLoggedIn}">
        <c:set var="isCustomer" value="${effectiveUser.role == 1}" />
    </c:if>
    <style>
        .item-img { width: 56px; height: 56px; object-fit: cover; border-radius: 6px; }
        .muted { color: #6b7280; }
        .small-muted { font-size: .95rem; color: #6b7280; display:block; margin-top:4px; }
        .order-line { display:flex; gap:12px; align-items:center; }
        .summary-row { display:flex; justify-content:space-between; padding:6px 0; }
        .summary-total { font-weight:700; color:#e11d48; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <div class="max-w-4xl mx-auto p-6">
        <h1 class="text-3xl font-bold mb-6">Thanh toán</h1>

        <c:if test="${not empty checkoutError}">
            <div class="bg-red-100 text-red-800 border border-red-200 px-4 py-3 rounded mb-4">${checkoutError}</div>
        </c:if>

        <div class="bg-white p-6 rounded shadow">
            <h2 class="font-semibold mb-3">Đơn hàng của bạn</h2>

            <c:choose>
                <c:when test="${not empty cartItems}">
                    <ul class="mb-4 divide-y">
                        <c:forEach var="it" items="${cartItems}">
                            <li class="py-4">
                                <div class="order-line justify-between">
                                    <div class="flex items-start gap-4">
                                        <div>
                                            <c:choose>
                                                <c:when test="${not empty it.imageUrl}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(it.imageUrl,'http')}">
                                                            <img src="${it.imageUrl}" alt="${it.productName}" class="item-img" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}${it.imageUrl}" alt="${it.productName}" class="item-img" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/no-image.png'"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="no-image" class="item-img"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div>
                                            <div class="font-medium">${it.productName}</div>
                                            <div class="text-sm muted">Số lượng: <c:out value="${it.quantity}"/></div>

                                            <!-- Attributes: prefer variant.attributeText, fallback to variant.attributeJson (client-side render) -->
                                            <c:if test="${not empty it.variant and not empty it.variant.attributeText}">
                                                <div class="small-muted">${it.variant.attributeText}</div>
                                            </c:if>

                                            <c:if test="${not empty it.variant and empty it.variant.attributeText and not empty it.variant.attributeJson}">
                                                <div class="small-muted">
                                                    <span class="attr-json" data-json='<c:out value="${it.variant.attributeJson}" escapeXml="true"/>'></span>
                                                </div>
                                            </c:if>

                                            <!-- Additional fallbacks -->
                                            <c:if test="${not empty it.variant and empty it.variant.attributeText and empty it.variant.attributeJson and not empty it.variant.attributes}">
                                                <div class="small-muted">${it.variant.attributes}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="text-right">
                                        <div class="font-semibold"><fmt:formatNumber value="${it.lineTotal != 0 ? it.lineTotal : it.unitPrice * it.quantity}" type="number" groupingUsed="true"/>₫</div>
                                        <div class="text-sm muted" style="margin-top:.25rem">
                                            <fmt:formatNumber value="${it.unitPrice}" type="number" groupingUsed="true"/>₫ / cái
                                        </div>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>

                <c:otherwise>
                    <p class="text-gray-500">Giỏ hàng rỗng.</p>
                </c:otherwise>
            </c:choose>

            <div class="mt-4 border-t pt-4">
                <div class="summary-row"><span class="muted">Tạm tính</span><span><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫</span></div>
                <div class="summary-row"><span class="muted">Phí giao hàng</span><span><fmt:formatNumber value="${shippingFee}" type="number" groupingUsed="true"/>₫</span></div>
                <div class="summary-row summary-total"><span>Tổng</span><span><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>₫</span></div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm">
                <h3 class="font-semibold mt-6 mb-2">Địa chỉ giao hàng</h3>

                <c:if test="${not empty addresses}">
                    <div class="space-y-3 mb-4">
                        <c:forEach var="addr" items="${addresses}">
                            <label class="block p-3 border rounded cursor-pointer">
                                <input type="radio" name="shippingAddressId" value="${addr.addressId}" class="mr-2"
                                    <c:if test="${not empty param.shippingAddressId and param.shippingAddressId == addr.addressId}">checked</c:if>
                                    <c:if test="${empty param.shippingAddressId and addr.isDefault}">checked</c:if> />
                                <span class="font-medium">
                                    <c:out value="${addr.label != null ? addr.label : ''}"/>
                                    <c:if test="${not empty addr.recipientName}"> - <c:out value="${addr.recipientName}"/></c:if>
                                </span>
                                <div class="text-sm muted mt-1">
                                    <c:if test="${not empty addr.addressLine}"><c:out value="${addr.addressLine}"/></c:if>
                                    <c:if test="${not empty addr.ward}">, <c:out value="${addr.ward}"/></c:if>
                                    <c:if test="${not empty addr.district}">, <c:out value="${addr.district}"/></c:if>
                                    <c:if test="${not empty addr.city}">, <c:out value="${addr.city}"/></c:if>
                                </div>
                                <c:if test="${addr.isDefault}">
                                    <div class="text-xs text-green-600 mt-1">Mặc định</div>
                                </c:if>
                            </label>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${empty addresses}">
                    <div class="mb-4">
                        <p class="text-gray-600">Bạn chưa có địa chỉ giao hàng.</p>
                        <a href="${pageContext.request.contextPath}/account/addresses" class="text-blue-600 hover:underline">Thêm địa chỉ</a>
                    </div>
                </c:if>

                <h3 class="font-semibold mt-4 mb-2">Phương thức thanh toán</h3>
                <div class="space-y-2 mb-6">
                    <label><input type="radio" name="paymentMethod" value="CASH" checked> Thanh toán khi nhận hàng (Tiền mặt)</label>
                    <label><input type="radio" name="paymentMethod" value="BANK"> Thanh toán bằng ngân hàng</label>
                </div>

                <div class="mt-6 flex justify-between items-center">
                    <div class="flex gap-3 items-center">
                        <a href="${pageContext.request.contextPath}/shop" class="inline-block bg-gray-100 text-gray-800 px-3 py-2 rounded border hover:bg-gray-200">Tiếp tục mua sắm</a>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${isCustomer}">
                                <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded">Đặt hàng</button>
                            </c:when>
                            <c:when test="${isLoggedIn and not isCustomer}">
                                <button type="button" disabled class="bg-gray-300 text-gray-700 px-4 py-2 rounded">Đặt hàng</button>
                                <div class="text-sm text-gray-500 mt-1">Tính năng thanh toán chỉ dành cho khách hàng.</div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="bg-yellow-400 text-white px-4 py-2 rounded">🔐 Đăng nhập để thanh toán</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>

    <script>
        // Render attribute JSON (same logic as cart.jsp)
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.attr-json').forEach(function (el) {
                const raw = el.getAttribute('data-json');
                if (!raw) { el.textContent = ''; return; }
                try {
                    const obj = JSON.parse(raw);
                    const parts = [];
                    for (const k in obj) {
                        if (!Object.prototype.hasOwnProperty.call(obj, k)) continue;
                        parts.push((k.charAt(0).toUpperCase() + k.slice(1)) + ': ' + obj[k]);
                    }
                    el.textContent = parts.join(', ');
                } catch (e) {
                    el.textContent = raw.replace(/^[\s{]+|[\s}]+$/g,'').replace(/"/g,'').replace(/:/g, ': ').replace(/,/g, ', ');
                }
            });
        });
    </script>
</body>
</html>