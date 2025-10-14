<%@page import="java.util.List, model.Booking, model.Service, model.Pet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Lịch sử đặt lịch</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="max-w-4xl mx-auto mt-10 bg-white p-6 rounded-lg shadow">
            <h2 class="text-2xl font-bold text-blue-700 mb-4">Lịch sử đặt lịch</h2>
            <p class="text-sm text-gray-600 mb-4">Hiển thị tối đa 50 bản ghi gần nhất.</p>

            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-blue-600 text-white">
                        <tr>
                            <th class="px-4 py-2 text-left">Mã</th>
                            <th class="px-4 py-2 text-left">Ngày yêu cầu</th>
                            <th class="px-4 py-2 text-left">Giờ bắt đầu</th>
                            <th class="px-4 py-2 text-left">Dịch vụ</th>
                            <th class="px-4 py-2 text-left">Tổng tiền</th>
                            <th class="px-4 py-2 text-left">Trạng thái</th>
                            <th class="px-4 py-2 text-left">Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="px-4 py-2">${b.id}</td>
                                <td class="px-4 py-2">${b.requestedDate}</td>
                                <td class="px-4 py-2">${b.requestedStart}</td>
                                <td class="px-4 py-2"><c:out value="${serviceMap[b.serviceId]}" default="-"/></td>
                                <td class="px-4 py-2">${b.totalPrice}</td>
                                <td class="px-4 py-2">
                                    <c:choose>
                                        <c:when test="${b.currentStatus == 'Pending'}">
                                            <span class="px-2 py-1 bg-yellow-200 text-yellow-800 rounded">PENDING</span>
                                        </c:when>
                                        <c:when test="${b.currentStatus == 'Confirmed' || b.currentStatus == 'CONFIRMED'}">
                                            <span class="px-2 py-1 bg-green-200 text-green-800 rounded">CONFIRMED</span>
                                        </c:when>
                                        <c:when test="${b.currentStatus == 'Complete' || b.currentStatus == 'COMPLETE'}">
                                            <span class="px-2 py-1 bg-gray-200 text-gray-800 rounded">COMPLETE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2 py-1 bg-blue-200 text-blue-800 rounded">${b.currentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-2">${b.notes}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
