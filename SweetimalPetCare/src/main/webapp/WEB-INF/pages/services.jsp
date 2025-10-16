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

        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>
        <section class="py-16 px-6 max-w-6xl mx-auto">
            <h2 class="text-3xl font-bold mb-8 text-center">Danh sách dịch vụ</h2>
            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="s" items="${services}">
                    <div class="bg-white rounded-2xl shadow hover:shadow-lg transition-shadow duration-200 overflow-hidden">
                        <div class="p-6 flex items-start space-x-4">
                            <div class="w-16 h-16 flex items-center justify-center rounded-lg bg-indigo-50 text-indigo-600">
                                <i class="fa-solid fa-scissors fa-lg"></i>
                            </div>
                            <div class="flex-1">
                                <h3 class="font-semibold text-lg text-gray-800">${s.name}</h3>
                                <p class="text-gray-500 text-sm mt-1 line-clamp-3">${s.description}</p>
                            </div>
                        </div>
                        <div class="px-6 pb-6 flex items-center justify-between">
                            <div>
                                <div class="text-sm text-gray-500">Giá từ</div>
                                <div class="text-xl font-bold text-pink-600">${s.price} đ</div>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${empty sessionScope.user}">
                                        <a href="${pageContext.request.contextPath}/login?redirect=booking&serviceId=${s.id}" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                            <i class="fa-solid fa-calendar-plus mr-2"></i>Đặt ngay
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/booking?serviceId=${s.id}" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                            <i class="fa-solid fa-calendar-plus mr-2"></i>Đặt ngay
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
