<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Thanh toán - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <%@include file="/WEB-INF/include/library.jsp" %>
</head>
<body class="bg-gray-50 font-sans pt-20">
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
                    <ul class="mb-4">
                        <c:forEach var="it" items="${cartItems}">
                            <li class="flex justify-between py-2 border-b">
                                <div>
                                    <div class="font-medium"><c:out value="${it.productName}"/></div>
                                    <div class="text-sm muted">Số lượng: <c:out value="${it.quantity}"/></div>
                                </div>
                                <div class="font-semibold"><fmt:formatNumber value="${it.lineTotal}" type="number" groupingUsed="true"/>₫</div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-500">Giỏ hàng rỗng.</p>
                </c:otherwise>
            </c:choose>

            <div class="flex justify-between items-center mb-4">
                <span class="muted">Tạm tính</span>
                <span class="font-semibold"><fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/>₫</span>
            </div>

            <h3 class="font-semibold mt-4 mb-2">Địa chỉ giao hàng</h3>

            <form method="post" action="${pageContext.request.contextPath}/checkout" id="checkoutForm">
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
                <div class="space-y-2">
                    <label><input type="radio" name="paymentMethod" value="CASH" checked> Thanh toán khi nhận hàng (Tiền mặt)</label>
                    <label><input type="radio" name="paymentMethod" value="EWALLET"> Ví điện tử</label>
                </div>

                <div class="mt-6 flex justify-between items-center">
                    <a href="${pageContext.request.contextPath}/cart" class="text-gray-600 hover:underline">Quay lại giỏ hàng</a>
                    <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded">Đặt hàng</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>