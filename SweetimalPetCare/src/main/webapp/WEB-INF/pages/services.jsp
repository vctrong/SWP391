<%--
    Document   : services
    Created on : Sep 29, 2025, 2:10:52 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dịch vụ</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <section class="py-16 px-6 max-w-6xl mx-auto">
            <h2 class="text-3xl font-bold mb-8 text-center">Danh sách dịch vụ</h2>
            <div class="grid md:grid-cols-3 gap-6">
                <c:forEach var="s" items="${services}">
                    <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                        <h3 class="font-semibold text-lg text-blue-700">${s.name}</h3>
                        <p class="text-gray-500 text-sm mb-4">${s.description}</p>
                        <p class="text-pink-600 font-bold mb-2">${s.price} đ</p>
                        <a href="/booking?serviceId=${s.id}"
                           class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                            Đặt ngay
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
