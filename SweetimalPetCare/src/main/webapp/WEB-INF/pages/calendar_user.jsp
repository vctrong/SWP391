<%--
    Document   : calendar_user
    Created on : Oct 7, 2025, 3:18:23 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đặt lịch hẹn</title>
    <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="container mx-auto min-h-screen flex items-center justify-center py-10">
            <div class="w-full max-w-2xl px-4">
                <h2 class="text-2xl font-bold text-blue-700 mb-6 text-center">Đặt lịch dịch vụ cho thú cưng</h2>

                <!-- Popup for booking success -->
                <c:if test="${not empty bookingSuccess}">
                  <div id="bookingSuccessPopup" class="fixed inset-0 flex items-center justify-center z-50">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-6 py-4 rounded shadow-lg">
                      <strong>Đặt lịch thành công!</strong>
                      <button onclick="document.getElementById('bookingSuccessPopup').style.display='none'" class="ml-4 text-green-900 font-bold">Đóng</button>
                    </div>
                  </div>
                  <script>setTimeout(function(){ document.getElementById('bookingSuccessPopup').style.display='none'; }, 3000);</script>
                </c:if>

                <!-- Error message display -->
                <c:if test="${not empty errorMessage}">
                  <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-2 rounded mb-4">
                    ${errorMessage}
                  </div>
                </c:if>

                <form action="booking" method="post" class="bg-white shadow rounded-lg p-6 space-y-5 w-full mx-auto max-w-xl">
                <!-- Chọn thú cưng -->
                <div>
                    <label class="block font-semibold mb-1">Chọn thú cưng</label>
                    <select name="petId" class="w-full border rounded px-3 py-2" required>
                        <c:forEach var="p" items="${pets}">
                            <option value="${p.id}">${p.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Chọn dịch vụ -->
                <div>
                    <label class="block font-semibold mb-1">Chọn dịch vụ</label>
                    <select name="serviceId" class="w-full border rounded px-3 py-2" required>
                        <c:forEach var="s" items="${services}">
                            <option value="${s.id}" <c:if test="${not empty selectedServiceId and selectedServiceId == s.id}">selected</c:if>>${s.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Chọn khung giờ -->
                <div>
                    <label class="block font-semibold mb-1">Chọn khung giờ</label>
                    <select name="slotId" class="w-full border rounded px-3 py-2" required>
                        <c:forEach var="s" items="${availableSlots}">
                            <option value="${s.id}">
                                ${s.roomName} —
                                <fmt:formatDate value="${s.startTime}" pattern="yyyy-MM-dd HH:mm" /> →
                                <fmt:formatDate value="${s.endTime}" pattern="HH:mm" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Ghi chú -->
                <div>
                    <label class="block font-semibold mb-1">Ghi chú</label>
                    <textarea name="notes" class="w-full border rounded px-3 py-2" placeholder="Ghi chú thêm..."></textarea>
                </div>

                <button type="submit"
                        class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">
                    Xác nhận đặt lịch
                </button>
                </form>
            </div>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
