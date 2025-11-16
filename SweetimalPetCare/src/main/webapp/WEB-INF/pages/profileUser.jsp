<%-- 
    Document   : profileUser
    Created on : Oct 8, 2025, 3:20:56 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Pages</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <link rel="stylesheet" href="assets/css/profile.css"/>

    </head>
    <body class="bg-gray-100">

        <%@include file="/WEB-INF/include/headerProfileUser.jsp" %>


        <!-- ====== BODY: SIDEBAR + NỘI DUNG ====== -->
        <div class="max-w-7xl mx-auto py-8 px-4 flex flex-col lg:flex-row gap-6">

            <!-- SIDEBAR -->
            <%@include file="/WEB-INF/include/sidebarProfileUser.jsp" %>


            <!-- CONTENT -->
            <section class="w-full lg:w-3/4 space-y-6">

                <!-- TAB: TỔNG QUAN -->
                <div id="overview" class="tab-content active">
                    <!-- Greeting / Hero -->
                    <div class="bg-white rounded-2xl shadow-md p-6 mb-6 flex flex-col sm:flex-row sm:items-center gap-4">
                        <div class="flex-1">
                            <h3 class="text-2xl sm:text-3xl font-extrabold text-slate-800">Chào mừng trở lại, <span class="text-sky-600">${user.fullName}</span> 👋</h3>
                            <p class="mt-2 text-sm text-slate-500">Xem nhanh tài khoản của bạn, quản lý thú cưng, kiểm tra lịch hẹn và đơn hàng.</p>
                        </div>

                        <div class="flex items-center gap-3">
                            <a href="${pageContext.request.contextPath}/services" class="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-sky-500 to-sky-600 text-white rounded-lg shadow-sm text-sm hover:from-sky-600 hover:to-sky-700">
                                <i class="fa-solid fa-calendar-plus w-4"></i>
                                <span>Đặt lịch</span>
                            </a>

                            <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">
                                <i class="fa-solid fa-shop w-4 text-slate-700"></i>
                                <span>Mua sắm</span>
                            </a>
                        </div>
                    </div>

                    <!-- Key stats -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <div class="bg-gradient-to-br from-indigo-500 to-indigo-600 text-white rounded-2xl p-5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="flex items-center justify-between mb-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                        <i class="fa-solid fa-box text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs opacity-90">Đơn hàng</p>
                                        <p class="text-2xl font-bold">${countOrder}</p>
                                    </div>
                                </div>
                                <div class="text-sm opacity-80">tổng</div>
                            </div>
                            <p class="text-xs opacity-90">Tổng đơn hàng đã mua</p>
                        </div>

                        <div class="bg-gradient-to-br from-emerald-500 to-emerald-600 text-white rounded-2xl p-5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="flex items-center justify-between mb-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                        <i class="fa-solid fa-stethoscope text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs opacity-90">Dịch vụ</p>
                                        <p class="text-2xl font-bold">${countBooking}</p>
                                    </div>
                                </div>
                                <div class="text-sm opacity-80">tổng cộng</div>
                            </div>
                            <p class="text-xs opacity-90">Dịch vụ đã sử dụng</p>
                        </div>

                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 text-white rounded-2xl p-5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="flex items-center justify-between mb-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                        <i class="fa-solid fa-coins text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs opacity-90">Điểm</p>
                                        <p class="text-2xl font-bold">1,200</p>
                                    </div>
                                </div>
                                <div class="text-sm opacity-80">Tổng cộng</div>
                            </div>
                            <p class="text-xs opacity-90">Điểm tích lũy</p>
                        </div>

                        <div class="bg-white rounded-2xl p-5 border border-slate-100">
                            <div class="flex items-center justify-between mb-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-12 h-12 bg-emerald-50 text-emerald-700 rounded-lg flex items-center justify-center">
                                        <i class="fa-solid fa-paw text-xl"></i>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-500">Thú cưng</p>
                                        <p class="text-2xl font-bold text-slate-800">${user.nop}</p>
                                    </div>
                                </div>
                                <div class="text-xs text-slate-500">Quản lý</div>
                            </div>
                            <p class="text-xs text-slate-500">Bạn có 2 thú cưng đang đăng ký</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Recent orders (wide) -->
                        <div class="lg:col-span-2 bg-white rounded-2xl shadow-lg p-6">
                            <div class="flex items-center justify-between mb-4">
                                <h4 class="text-lg font-semibold text-slate-800">Đơn hàng gần đây</h4>
                                <a href="/orders" class="text-sky-600 text-sm font-medium hover:underline">Xem tất cả →</a>
                            </div>

                            <div class="space-y-4">
                                <!-- Order item -->
                                <c:choose>
                                    <c:when test="${empty recent}">
                                        <div class="py-12 text-center text-slate-500">
                                            Chưa có hoạt động gần đây.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="space-y-3">
                                            <c:forEach var="act" items="${recent}">
                                                <div class="flex items-center p-4 bg-slate-50 rounded-xl hover:bg-slate-100 transition-colors">
                                                    <!-- Icon -->
                                                    <div class="w-12 h-12 flex items-center justify-center rounded-lg mr-4 bg-white border">
                                                        <c:choose>
                                                            <c:when test="${act.type eq 'ORDER'}">
                                                                <svg class="w-6 h-6 text-sky-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                                                                <path d="M3 3h2l.4 2M7 13h10l4-8H5.4" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                                                <circle cx="10" cy="20" r="1" fill="currentColor"></circle>
                                                                <circle cx="18" cy="20" r="1" fill="currentColor"></circle>
                                                                </svg>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <svg class="w-6 h-6 text-emerald-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                                                                <path d="M20 4v6a4 4 0 0 1-8 0V8" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                                                <path d="M6 14v3a3 3 0 0 0 6 0v-3" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                                                </svg>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Title + meta -->
                                                    <div class="flex-1 min-w-0">
                                                        <div class="flex items-center justify-between gap-4">
                                                            <div class="min-w-0">
                                                                <div class="font-medium text-slate-800 truncate">
                                                                    <c:out value="${act.title}" />
                                                                </div>
                                                                <div class="text-xs text-slate-500 truncate mt-1">
                                                                    <c:out value="${act.meta}" />
                                                                </div>
                                                            </div>

                                                            <!-- Amount (orders) -->
                                                            <div class="text-right ml-4">
                                                                <c:if test="${not empty act.amount}">
                                                                    <div class="font-semibold text-slate-800">
                                                                        <fmt:formatNumber value="${act.amount}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                                                                        đ
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Status badge & actions -->
                                                    <div class="ml-4 flex items-center gap-3">
                                                        <c:choose>
                                                            <c:when test="${act.status eq 'COMPLETED' or act.status eq 'PAID'}">
                                                                <span class="inline-block px-2 py-1 bg-emerald-100 text-emerald-700 rounded-lg text-xs font-medium">Hoàn tất</span>
                                                            </c:when>
                                                            <c:when test="${act.status eq 'SHIPPED'}">
                                                                <span class="inline-block px-2 py-1 bg-emerald-50 text-emerald-700 rounded-lg text-xs font-medium">Đã gửi</span>
                                                            </c:when>
                                                            <c:when test="${act.status eq 'PROCESSING' or act.status eq 'IN_PROGRESS'}">
                                                                <span class="inline-block px-2 py-1 bg-amber-100 text-amber-700 rounded-lg text-xs font-medium">Đang xử lý</span>
                                                            </c:when>
                                                            <c:when test="${act.status eq 'PENDING'}">
                                                                <span class="inline-block px-2 py-1 bg-slate-100 text-slate-700 rounded-lg text-xs font-medium">Chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${act.status eq 'CANCELLED'}">
                                                                <span class="inline-block px-2 py-1 bg-red-100 text-red-700 rounded-lg text-xs font-medium">Đã hủy</span>
                                                            </c:when>
                                                            <c:when test="${act.type eq 'BOOKING' and (act.status eq 'CONFIRMED' or act.status eq 'COMPLETED')}">
                                                                <span class="inline-block px-2 py-1 bg-sky-50 text-sky-700 rounded-lg text-xs font-medium"><c:out value="${act.status}"/></span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-block px-2 py-1 bg-slate-100 text-slate-700 rounded-lg text-xs font-medium"><c:out value="${act.status}"/></span>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <c:choose>
                                                            <c:when test="${act.type eq 'ORDER'}">
                                                                <a href="${pageContext.request.contextPath}/orders/${act.id}" class="text-sky-600 text-xs hover:underline">Xem</a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/booking/${act.id}" class="text-sky-600 text-xs hover:underline">Chi tiết</a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:otherwise>
                                </c:choose>



                            </div>
                        </div>

                        <!-- Right column: upcoming booking, promotions, quick actions -->
                        <div class="space-y-6">
                            <!-- Upcoming booking -->
                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                <h4 class="font-semibold text-slate-800 mb-3 flex items-center">
                                    <span class="w-2 h-2 bg-sky-500 rounded-full mr-2"></span> Lịch hẹn sắp tới
                                </h4>

                                <!-- If no upcoming booking, show CTA -->
                                <!-- Hardcoded sample booking -->
                                <div class="flex items-start gap-4">
                                    <div class="w-12 h-12 bg-sky-50 text-sky-600 rounded-lg flex items-center justify-center">
                                        <i class="fa-solid fa-scalpel"></i>
                                    </div>
                                    <div class="flex-1">
                                        <p class="font-medium text-slate-800">${bookingNext.serviceName}</p>
                                        <p class="text-sm text-slate-500">${bookingNext.reqDate} • ${bookingNext.reqTime} • ${bookingNext.petName}</p>
                                        <div class="mt-3 flex items-center gap-2">
                                            <a href="${pageContext.request.contextPath}/booking-history" class="text-sm text-sky-600 hover:underline">Xem chi tiết</a>
                                            <!--<button class="text-sm text-red-600 hover:underline" onclick="alert('Demo: Hủy lịch (chưa có API)')">Hủy</button>-->
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Promotions -->
                            <div class="bg-gradient-to-br from-orange-400 to-pink-500 rounded-2xl p-4 text-white relative overflow-hidden">
                                <div class="relative z-10">
                                    <h5 class="font-bold text-lg">Ưu đãi đặc biệt</h5>
                                    <p class="text-sm opacity-90 mt-1">Giảm 30% cho gói Grooming VIP</p>
                                    <a href="/offers" class="mt-3 inline-block px-4 py-2 bg-white text-orange-500 rounded-lg text-sm font-medium hover:bg-gray-100">Khám phá</a>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="bg-white rounded-2xl shadow-lg p-4">
                                <h4 class="font-semibold text-slate-800 mb-3">Thao tác nhanh</h4>
                                <div class="grid grid-cols-2 gap-3">
                                    <a href="/shop" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                        <i class="fa-solid fa-cart-shopping text-sky-600 w-5"></i>
                                        <div>
                                            <p class="text-sm font-medium">Mua sắm</p>
                                            <p class="text-xs text-slate-500">Sản phẩm phổ biến</p>
                                        </div>
                                    </a>

                                    <a href="/booking" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                        <i class="fa-solid fa-calendar-plus text-emerald-600 w-5"></i>
                                        <div>
                                            <p class="text-sm font-medium">Đặt lịch</p>
                                            <p class="text-xs text-slate-500">Chọn thời gian thuận tiện</p>
                                        </div>
                                    </a>

                                    <a href="/pets" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                        <i class="fa-solid fa-paw text-yellow-600 w-5"></i>
                                        <div>
                                            <p class="text-sm font-medium">Quản lý thú cưng</p>
                                            <p class="text-xs text-slate-500">Cập nhật hồ sơ</p>
                                        </div>
                                    </a>

                                    <a href="/support" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                        <i class="fa-solid fa-headset text-purple-600 w-5"></i>
                                        <div>
                                            <p class="text-sm font-medium">Hỗ trợ</p>
                                            <p class="text-xs text-slate-500">Gửi yêu cầu</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <%@include file="/WEB-INF/include/footer.jsp" %>
        <script src="assets/js/profile.js"></script>
    </body>
</html>
