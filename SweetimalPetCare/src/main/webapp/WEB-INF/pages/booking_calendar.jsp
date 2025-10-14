<%--
    Document   : booking_calendar
    Created on : Oct 7, 2025, 3:01:02 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body>
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>
        <%@include file="/WEB-INF/toast/loginOk.jsp" %>
        <h2 class="text-2xl font-bold mb-4">Chọn lịch hẹn</h2>
        <table class="w-full border">
            <thead><tr><th>Bác sĩ</th><th>Phòng</th><th>Thời gian</th><th>Đặt lịch</th></tr></thead>
            <tbody>
                <c:forEach var="s" items="${availableSlots}">
                    <tr>
                        <td>${s.staffId}</td>
                        <td>${s.roomName}</td>
                        <td>${s.startTime} - ${s.endTime}</td>
                        <td>
                            <form method="post">
                                <input type="hidden" name="slotId" value="${s.id}">
                                <input type="hidden" name="serviceId" value="1">
                                <select name="petId" required>
                                    <c:forEach var="p" items="${pets}">
                                        <option value="${p.id}">${p.name}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="bg-green-600 text-white px-3 py-1 rounded">Đặt</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
