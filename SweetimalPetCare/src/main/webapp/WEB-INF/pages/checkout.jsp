<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Thanh toán - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
                                    <div class="font-medium">${it.productName}</div>
                                    <div class="text-sm muted">Số lượng: ${it.quantity}</div>
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

            <h3 class="font-semibold mt-4 mb-2">Địa chỉ giao hàng</h3>
            <c:if test="${not empty addresses}">
                <div class="p-3 border rounded mb-4">
                    <c:forEach var="addr" items="${addresses}">
                        <div>
                            <div class="font-medium">${addr.label} <span class="text-sm muted">- ${addr.recipientName}</span></div>
                            <div class="text-sm muted">${addr.addressLine}, ${addr.city}</div>
                        </div>
                        <c:if test="${addr.isDefault == 1}"><div class="text-xs text-green-600 mt-1">Mặc định</div></c:if>
                    </c:forEach>
                </div>
            </c:if>

            <h3 class="font-semibold mt-4 mb-2">Phương thức thanh toán</h3>
            <form method="post" action="${pageContext.request.contextPath}/checkout">
                <div class="space-y-2">
                    <label><input type="radio" name="paymentMethod" value="CASH" checked> Thanh toán khi nhận hàng (Tiền mặt)</label>
                    <label><input type="radio" name="paymentMethod" value="EWALLET"> Ví điện tử</label>
                    <label><input type="radio" name="paymentMethod" value="CARD"> Thẻ tín dụng / ATM</label>
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