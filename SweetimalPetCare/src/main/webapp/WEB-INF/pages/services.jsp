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
        <section class="py-16 px-4 max-w-6xl mx-auto bg-gradient-to-b from-sky-50 to-white">
            <div class="text-center mb-12">
                <h2 class="text-4xl font-bold text-gray-800 mb-3">
                    <i class="fa-solid fa-paw mr-2 text-sky-500"></i>Dịch vụ chăm sóc thú cưng
                </h2>
                <p class="text-gray-600 text-base">Chăm sóc tận tâm - Yêu thương trọn vẹn</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <c:forEach var="s" items="${services}">
                    <div class="relative flex flex-col justify-between bg-white rounded-2xl shadow hover:shadow-xl transition-all duration-300 p-6 group hover:-translate-y-1 border-2 border-sky-100 hover:border-sky-300">

                        <!-- Icon dịch vụ -->
                        <div class="flex items-start mb-4">
                            <div class="flex-shrink-0 w-14 h-14 rounded-2xl bg-gradient-to-br from-sky-100 to-cyan-100 flex items-center justify-center mr-4 shadow-sm group-hover:scale-110 transition-transform duration-300">
                                <i class="fa-solid fa-heart text-sky-500 text-2xl"></i>
                            </div>
                            <div class="flex-1">
                                <h3 class="font-bold text-lg text-gray-800 group-hover:text-sky-600 transition-colors duration-200 mb-1">
                                    ${s.name}
                                </h3>
                                <div class="flex items-center text-xs text-gray-500">
                                    <i class="fa-solid fa-clock mr-1"></i>
                                    <span>Đặt lịch dễ dàng</span>
                                </div>
                            </div>
                        </div>

                        <!-- Mô tả dịch vụ -->
                        <p class="text-gray-600 text-sm mb-6 line-clamp-3 min-h-[60px] leading-relaxed">
                            ${s.description}
                        </p>

                        <!-- Giá và đánh giá -->
                        <div class="flex items-center justify-between mb-5 pb-4 border-b border-gray-100">
                            <div>
                                <span class="text-sky-600 font-bold text-xl">${s.price} đ</span>
                                <p class="text-xs text-gray-400 mt-1">Giá ưu đãi</p>
                            </div>
                            <div class="flex items-center bg-cyan-50 text-cyan-600 px-3 py-1.5 rounded-full text-xs font-medium">
                                <i class="fa-solid fa-star mr-1"></i>
                                <span>Phổ biến</span>
                            </div>
                        </div>

                        <!-- Nút đặt lịch -->
                        <c:choose>
                            <c:when test="${empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/login?redirect=booking&serviceId=${s.id}"
                                   class="w-full block text-center bg-gradient-to-r from-sky-500 to-cyan-500 text-white px-5 py-3 rounded-xl font-semibold shadow-sm hover:shadow-lg focus:outline-none transition-all duration-300 hover:from-sky-600 hover:to-cyan-600">
                                    <i class="fa-solid fa-calendar-check mr-2"></i>Đặt lịch ngay
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${sessionScope.user.roleEnum == 'CUSTOMER'}">
                                    <a href="${pageContext.request.contextPath}/booking?serviceId=${s.id}"
                                       class="w-full block text-center bg-gradient-to-r from-sky-500 to-cyan-500 text-white px-5 py-3 rounded-xl font-semibold shadow-sm hover:shadow-lg focus:outline-none transition-all duration-300 hover:from-sky-600 hover:to-cyan-600">
                                        <i class="fa-solid fa-calendar-check mr-2"></i>Đặt lịch ngay
                                    </a>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

                        <!-- Link xem đánh giá -->
                        <div class="mt-3 text-center">
                            <a href="${pageContext.request.contextPath}/service-reviews?serviceId=${s.id}"
                               class="inline-flex items-center text-sky-600 hover:text-sky-800 text-sm font-medium">
                                <i class="fa-regular fa-star mr-1"></i> Xem đánh giá dịch vụ
                            </a>
                        </div>

                        <!-- Hiệu ứng glow -->
                        <div class="absolute inset-0 rounded-2xl pointer-events-none group-hover:ring-2 group-hover:ring-sky-300 group-hover:ring-opacity-50 transition-all duration-300"></div>
                    </div>
                </c:forEach>
            </div>

            <!-- Thông tin thêm -->
            <div class="mt-12 text-center">
                <div class="inline-flex items-center bg-white rounded-full shadow-sm px-6 py-3 text-sm text-gray-600">
                    <i class="fa-solid fa-shield-heart text-sky-500 mr-2"></i>
                    <span>Cam kết chất lượng dịch vụ hàng đầu</span>
                </div>
            </div>
        </section>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
