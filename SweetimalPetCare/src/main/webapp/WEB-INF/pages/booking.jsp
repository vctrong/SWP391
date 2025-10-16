<%--
    Document   : booking
    Created on : Sep 30, 2025, 8:51:07 AM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page import="java.util.List, model.Service, model.Pet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Service> services = (List<Service>) request.getAttribute("services");
%>

<!DOCTYPE html>
<html>
    <head>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <title>Đặt lịch dịch vụ cho thú cưng</title>
    </head>
    <body class="bg-gray-100 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <div class="max-w-2xl mx-auto mt-10 bg-white p-6 rounded-lg shadow">
            <h2 class="text-2xl font-bold text-blue-700 mb-6 text-center">Đặt lịch dịch vụ</h2>

            <form action="booking" method="post" class="space-y-4">
                <!-- Pet -->
                <label class="block font-semibold">Chọn thú cưng</label>
                <select name="petId" class="w-full border rounded px-3 py-2" required>
                    <c:forEach var="p" items="${pets}">
                        <option value="${p.id}">${p.name}</option>
                    </c:forEach>
                </select>

                <!-- Service -->
                <label class="block font-semibold">Chọn dịch vụ</label>
                <select name="serviceId" class="w-full border rounded px-3 py-2" required>
                    <c:forEach var="s" items="${services}">
                        <option value="${s.id}" <c:if test="${not empty selectedServiceId and selectedServiceId == s.id}">selected</c:if>>${s.name}</option>
                    </c:forEach>
                </select>

                <!-- Slot -->
                <label class="block font-semibold">Chọn khung giờ</label>
                <select name="slotId" class="w-full border rounded px-3 py-2" required>
                    <c:forEach var="s" items="${availableSlots}">
                        <option value="${s.id}">
                            ${s.roomName} —
                            <fmt:formatDate value="${s.startTime}" pattern="yyyy-MM-dd HH:mm"/> →
                            <fmt:formatDate value="${s.endTime}" pattern="HH:mm"/>
                        </option>
                    </c:forEach>
                </select>

                <!-- Notes -->
                <textarea name="notes" placeholder="Ghi chú thêm..."
                          class="w-full border rounded px-3 py-2"></textarea>

                <button type="submit"
                        class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700">
                    Xác nhận đặt lịch
                </button>
            </form>
        </div>
        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
        
    </body>
</html>
