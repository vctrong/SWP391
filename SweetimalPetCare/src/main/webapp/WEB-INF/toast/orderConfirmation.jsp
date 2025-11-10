<%-- 
    Document   : orderConfirmation
    Created on : Nov 1, 2025, 2:44:14 PM
    Author     : Pham Nguyen Xuan Mai - CE190106
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Đặt hàng thành công - Sweetimal Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <%@ include file="/WEB-INF/include/library.jsp" %>
</head>
<body class="bg-gray-50 font-sans pt-20">
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <div class="max-w-3xl mx-auto p-6">
        <div class="bg-white p-6 rounded shadow text-center">
            <h1 class="text-2xl font-bold text-green-600 mb-4">Đặt hàng thành công!</h1>
            <p class="mb-4">Cám ơn bạn đã đặt hàng. Đơn hàng của bạn đã được ghi nhận.</p>
            <c:if test="${not empty orderId}">
                <p class="mb-4">Mã đơn hàng: <span class="font-semibold">${orderId}</span></p>
            </c:if>
            <a href="${pageContext.request.contextPath}/orders/${orderId}" class="inline-block bg-blue-600 text-white px-4 py-2 rounded">Xem chi tiết đơn hàng</a>
            <a href="${pageContext.request.contextPath}/shop" class="inline-block ml-3 text-gray-700 px-4 py-2 rounded border">Tiếp tục mua sắm</a>
        </div>
    </div>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>