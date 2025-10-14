<%--
    Document   : schedule
    Created on : Oct 7, 2025, 2:58:30 PM
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
        <h2 class="text-2xl font-bold mb-4">Lịch làm việc của bạn</h2>
        <table class="table-auto w-full border">
            <thead><tr><th>Phòng</th><th>Ngày</th><th>Giờ bắt đầu</th><th>Giờ kết thúc</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="s" items="${slots}">
                <tr>
                    <td>${s.roomName}</td>
                    <td>${s.startTime.toLocalDate()}</td>
                    <td>${s.startTime.toLocalTime()}</td>
                    <td>${s.endTime.toLocalTime()}</td>
                    <td>${s.status}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <form method="post" class="mt-6 space-x-2">
        <input type="text" name="room" placeholder="Phòng" required>
        <input type="date" name="date" required>
        <input type="time" name="start" required>
        <input type="time" name="end" required>
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Thêm Ca</button>
    </form>
    <!-- Footer -->
    <%@include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>
