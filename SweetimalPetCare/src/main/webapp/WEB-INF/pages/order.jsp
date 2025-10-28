<%-- 
    Document   : order
    Created on : Oct 19, 2025, 11:59:26 PM
    Author     : Pham Nguyen Xuan Mai - CE190106
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Xác nhận đơn hàng - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans pt-20">
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <div class="max-w-3xl mx-auto p-6">
        <div class="bg-white p-6 rounded shadow text-center">
            <h1 class="text-2xl font-bold mb-2">Cảm ơn bạn — đơn hàng đã được tạo</h1>

            <!-- Expect either request param orderId or request attribute orderId/orderCode/order -->
            <c:set var="oid" value="${param.orderId}" />
            <c:if test="${empty oid && not empty orderId}">
                <c:set var="oid" value="${orderId}" />
            </c:if>

            <c:choose>
                <c:when test="${not empty oid}">
                    <p class="text-gray-700 mb-2">Mã đơn hàng của bạn: <span class="font-semibold">${oid}</span></p>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-700 mb-2">Chúng tôi đã nhận đơn hàng của bạn.</p>
                </c:otherwise>
            </c:choose>

            <c:if test="${not empty orderCode}">
                <p class="text-gray-700 mb-2">Mã tham chiếu: <span class="font-semibold">${orderCode}</span></p>
            </c:if>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/orders?orderId=${oid}" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Xem chi tiết đơn hàng</a>
                <a href="${pageContext.request.contextPath}/shop" class="ml-3 text-gray-700 hover:underline">Tiếp tục mua sắm</a>
            </div>
        </div>

        <c:if test="${not empty order}">
            <div class="mt-6 bg-white p-4 rounded shadow">
                <h3 class="font-semibold mb-2">Tóm tắt đơn hàng</h3>
                <div class="space-y-2">
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Trạng thái</span>
                        <span>${order.orderStatus}</span>
                    </div>
                    <div class="flex justify-between text-sm text-gray-600">
                        <span>Tổng tiền</span>
                        <span class="font-medium text-red-600"><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>₫</span>
                    </div>
                </div>

                <div class="mt-3">
                    <h4 class="font-medium">Mặt hàng</h4>
                    <c:forEach var="it" items="${order.items}">
                        <div class="flex items-center justify-between py-2 border-b">
                            <div>
                                <div class="font-medium">${it.productName}</div>
                                <div class="text-sm text-gray-500">${it.sku} — x${it.quantity}</div>
                            </div>
                            <div class="font-semibold"><fmt:formatNumber value="${it.unitPrice * it.quantity}" type="number" groupingUsed="true"/>₫</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>