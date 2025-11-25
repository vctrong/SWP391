<%-- 
    Document   : paymentQr
    Created on : Nov 1, 2025, 2:43:40 PM
    Author     : Pham Nguyen Xuan Mai - CE190106
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Thanh toán bằng ngân hàng - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <%@ include file="/WEB-INF/include/library.jsp" %>
</head>
<body>
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <div class="max-w-md mx-auto p-6">
        <div class="bg-white p-6 rounded shadow text-center">
            <h1 class="text-2xl font-bold mb-4">Thanh toán bằng ngân hàng</h1>
            <p class="mb-4">Quét mã QR bên dưới để thanh toán cho đơn hàng.</p>

            <c:if test="${not empty qrUrl}">
                <img src="${qrUrl}" alt="QR code for payment" class="mx-auto mb-4" style="width:300px;height:300px;">
            </c:if>

            <c:if test="${not empty paymentUrl}">
                <p class="text-sm text-gray-600 break-all mb-4">${paymentUrl}</p>
            </c:if>

            <c:if test="${not empty orderId}">
                <p class="mb-2">Mã đơn: <span class="font-semibold">${orderId}</span></p>
            </c:if>

            <div class="space-x-2">
                <a href="${pageContext.request.contextPath}/orders/${orderId}" class="inline-block bg-gray-200 px-4 py-2 rounded">Xem đơn hàng</a>
                <a href="${pageContext.request.contextPath}/shop" class="inline-block bg-blue-600 text-white px-4 py-2 rounded">Tiếp tục mua sắm</a>
            </div>

            <p class="mt-4 text-sm text-gray-500">Lưu ý: đây là ví dụ QR tĩnh cho thanh toán bằng ngân hàng. Tích hợp cổng thanh toán thực tế cần endpoint tạo paymentUrl và webhook xác nhận thanh toán để cập nhật trạng thái đơn.</p>
        </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>
