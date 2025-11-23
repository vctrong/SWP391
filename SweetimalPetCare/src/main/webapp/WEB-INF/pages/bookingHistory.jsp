<%@page import="java.util.List, model.Booking, model.Service, model.Pet, enums.BookingStatusColor"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Lịch sử đặt lịch</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <!-- Main -->      
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
                            <th class="px-4 py-2 text-left">Hành động</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">

                        <!-- Show all booking for that user -->
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td class="px-4 py-2">${b.id}</td>
                                <td class="px-4 py-2">${b.requestedDate}</td>
                                <td class="px-4 py-2">${b.requestedStart}</td>
                                <td class="px-4 py-2"><c:out value="${serviceMap[b.serviceId]}" default="-"/></td> <!-- Get Service name from ServiceId -->
                                <td class="px-4 py-2">${b.totalPrice}</td>
                                <td class="px-4 py-2 text-center">
                                    <%
                                        // Scriptlet: Gets status color/style from BookingStatusColor enum based on booking status
                                        Booking __b = (Booking) pageContext.getAttribute("b");
                                        BookingStatusColor st = BookingStatusColor.fromString(__b != null ? __b.getCurrentStatus() : null);
                                    %>
                                    <span class="inline-block px-2 py-1 <%= st.getBgClass() %> <%= st.getTextClass() %> rounded"><%= st.getLabel() %></span>
                                </td>
                                <td class="px-4 py-2">${b.notes}</td>
                                <td class="px-4 py-2">
                                    <c:choose>
                                        <c:when test="${b.currentStatus == 'PENDING' || b.currentStatus == 'Pending' || b.currentStatus == 'CONFIRMED' || b.currentStatus == 'Confirmed'}">
                                            
                                        <!-- Cancel button: Only shown for pending/confirmed bookings; submits to cancel-booking servlet -->
                                           
                                        <form method="post" action="${pageContext.request.contextPath}/cancel-booking">
                                                <input type="hidden" name="bookingId" value="${b.id}" />
                                                <button type="button" onclick="if (confirm('Bạn có chắc muốn hủy đặt lịch này?')) this.form.submit();" class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">Hủy yêu cầu</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-sm text-gray-500">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
