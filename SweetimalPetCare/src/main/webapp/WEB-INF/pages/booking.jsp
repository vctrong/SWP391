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
    <body class="bg-gradient-to-br from-sky-50 via-cyan-50 to-white text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="relative min-h-screen flex items-center justify-center py-16 px-4 overflow-hidden">
            <!-- Decorative circles -->
            <div class="absolute top-0 right-0 w-72 h-72 bg-sky-200 rounded-full blur-3xl opacity-30 animate-pulse"></div>
            <div class="absolute bottom-0 left-0 w-64 h-64 bg-cyan-200 rounded-full blur-3xl opacity-20"></div>

            <div class="relative z-10 w-full max-w-2xl">
                <!-- Popup for booking success -->
                <c:if test="${not empty bookingSuccess}">
                  <div id="bookingSuccessPopup" class="fixed inset-0 flex items-center justify-center z-50">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-6 py-4 rounded-2xl shadow-lg flex items-center gap-4">
                      <i class="fa-solid fa-check-circle text-2xl"></i>
                      <div>
                        <strong class="font-bold">Đặt lịch thành công!</strong>
                        <p class="text-sm">Chúng tôi sẽ sớm liên hệ với bạn.</p>
                      </div>
                      <button onclick="document.getElementById('bookingSuccessPopup').style.display='none'" class="text-green-900 font-bold hover:text-green-700">&times;</button>
                    </div>
                  </div>
                  <script>setTimeout(function(){ document.getElementById('bookingSuccessPopup').style.display='none'; }, 4000);</script>
                </c:if>

                <!-- Error message display -->
                <c:if test="${not empty errorMessage}">
                  <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-xl mb-6 shadow">
                    <i class="fa-solid fa-exclamation-triangle mr-2"></i> ${errorMessage}
                  </div>
                </c:if>

                <div class="bg-white/70 backdrop-blur-sm rounded-3xl shadow-2xl p-8 md:p-12 border border-sky-100">
                    <div class="text-center mb-8">
                        <div class="inline-flex items-center bg-white rounded-full shadow-sm px-4 py-2 text-sm text-sky-600 font-medium mb-4">
                            <i class="fa-solid fa-calendar-check mr-2"></i>
                            <span>Đặt lịch hẹn</span>
                        </div>
                        <h2 class="text-3xl md:text-4xl font-bold text-gray-800">
                            Thông tin lịch hẹn
                        </h2>
                        <p class="text-gray-600 mt-2">Chỉ còn vài bước nữa để hoàn tất lịch hẹn cho bé cưng.</p>
                    </div>

                    <form action="booking" method="post" class="space-y-6">
                        <!-- Chọn thú cưng -->
                        <div>
                            <label class="block font-semibold mb-2 text-gray-700">Chọn thú cưng</label>
                            <select name="petId" class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-sky-500 focus:border-sky-500 transition p-3" required>
                                <c:forEach var="p" items="${pets}">
                                    <option value="${p.id}">${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- dịch vụ -->
                        <div>
                            <label class="block font-semibold mb-2 text-gray-700">Dịch vụ</label>
                            <select name="serviceId" class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-sky-500 focus:border-sky-500 transition p-3 bg-gray-100" required <c:if test="${not empty selectedServiceId}">disabled</c:if>>
                                <c:forEach var="s" items="${services}">
                                    <option value="${s.id}" <c:if test="${not empty selectedServiceId and selectedServiceId == s.id}">selected</c:if>>${s.name}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty selectedServiceId}">
                                <input type="hidden" name="serviceId" value="${selectedServiceId}" />
                            </c:if>
                        </div>

                        <!-- Chọn khung giờ -->
                        <div>
                            <label class="block font-semibold mb-2 text-gray-700">Chọn khung giờ</label>
                            <select name="slotId" class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-sky-500 focus:border-sky-500 transition p-3" required>
                                <c:forEach var="s" items="${availableSlots}">
                                    <option value="${s.id}">
                                        ${s.roomName} —
                                        <fmt:formatDate value="${s.startTime}" pattern="HH:mm, dd/MM/yyyy" /> →
                                        <fmt:formatDate value="${s.endTime}" pattern="HH:mm" />
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Ghi chú -->
                        <div>
                            <label class="block font-semibold mb-2 text-gray-700">Ghi chú</label>
                            <textarea name="notes" class="w-full border-gray-300 rounded-lg shadow-sm focus:ring-sky-500 focus:border-sky-500 transition p-3" rows="3" placeholder="Ví dụ: Bé sợ máy sấy, vui lòng sấy tay..."></textarea>
                        </div>

                        <button type="submit"
                                class="w-full inline-flex items-center justify-center px-6 py-3 bg-gradient-to-r from-sky-500 to-cyan-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl hover:-translate-y-0.5 transition-all duration-300">
                            <i class="fa-solid fa-check-circle mr-2"></i>Xác nhận đặt lịch
                        </button>
                    </form>
                </div>
            </div>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
