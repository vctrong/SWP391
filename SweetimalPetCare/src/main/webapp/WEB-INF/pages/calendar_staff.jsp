<%--
    Document   : calendar_staff
    Created on : Oct 7, 2025, 3:14:35 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch làm việc</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    </head>
    <body>
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>
        <%@include file="/WEB-INF/toast/loginOk.jsp" %>
        <main class="container mx-auto py-10">
            <h2 class="text-2xl font-bold text-blue-700 mb-6">Lịch làm việc của bạn</h2>

            <table class="min-w-full bg-white shadow rounded-lg">
                <thead class="bg-blue-100 text-blue-800">
                    <tr>
                        <th class="py-2 px-4 text-left">Phòng</th>
                        <th class="py-2 px-4 text-left">Bắt đầu</th>
                        <th class="py-2 px-4 text-left">Kết thúc</th>
                        <th class="py-2 px-4 text-left">Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="slot" items="${staffSlots}">
                        <tr class="border-t hover:bg-gray-50">
                            <td class="py-2 px-4">${slot.roomName}</td>
                            <td class="py-2 px-4">
                                <fmt:formatDate value="${slot.startTime}" pattern="yyyy-MM-dd HH:mm" />
                            </td>
                            <td class="py-2 px-4">
                                <fmt:formatDate value="${slot.endTime}" pattern="yyyy-MM-dd HH:mm" />
                            </td>

                            <td class="py-2 px-4">${slot.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>
        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
