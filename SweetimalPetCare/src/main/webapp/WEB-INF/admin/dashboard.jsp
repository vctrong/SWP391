<%-- 
    Document   : dashboard.jsp
    Created on : Oct 22, 2025, 4:39:50 PM
    Author     : Vo Chi Trong - CE191062
--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard Admin | Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="includes/headAdmin.jsp" %>
    </head>

    <body class="font-inter bg-gray-50 text-gray-800">
        <div class="min-h-screen flex">

            <%@include file="../admin/includes/admin_sidebar.jsp" %>
            <%@include file="includes/mobileApp.jsp" %>
            <div class="flex-1 md:pl-72">
                <%@include file="includes/admin_header.jsp" %>
                <main class="p-4 md:p-8">
                    <section id="page-dashboard" class="page-section space-y-6">
                        <div class="grid grid-cols-1 sm:grid-cols-3 lg:grid-cols-5 gap-4">
                            <%-- KPI 1: Bookings Today (Dịch vụ) --%>
                            <div class="card p-4 bg-white rounded-lg shadow-sm">
                                <div class="text-sm text-gray-500">Bookings Today</div>
                                <div class="flex items-center justify-between mt-2">
                                    <div>
                                        <div id="kpiBookings" class="text-2xl font-bold">${bookingToday}</div>
                                        <div class="text-xs text-gray-400">Lượt đặt dịch vụ</div>
                                    </div>
                                    <div class="p-3 bg-emerald-50 rounded-md text-emerald-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

                            <%-- KPI 2: Orders Today (Bán hàng) - MỚI --%>
                            <div class="card p-4 bg-white rounded-lg shadow-sm">
                                <div class="text-sm text-gray-500">Orders Today</div>
                                <div class="flex items-center justify-between mt-2">
                                    <div>
                                        <div id="kpiOrders" class="text-2xl font-bold">${orderToday}</div>
                                        <div class="text-xs text-gray-400">Đơn hàng sản phẩm</div>
                                    </div>
                                    <div class="p-3 bg-blue-50 rounded-md text-blue-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

                            <%-- KPI 3: Revenue (This Month) (Tổng) --%>
                            <div class="card p-4 bg-white rounded-lg shadow-sm">
                                <div class="text-sm text-gray-500">Revenue (This Month)</div>
                                <div class="flex items-center justify-between mt-2">
                                    <div>
                                        <div id="kpiRevenue" class="text-2xl font-bold">
                                            <%-- Định dạng tiền tệ VNĐ --%>
                                            <fmt:formatNumber value="${revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </div>
                                        <div class="text-xs text-gray-400">Doanh thu tháng</div>
                                    </div>
                                    <div class="p-3 bg-sky-50 rounded-md text-sky-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

                            <%-- KPI 4: New Customers (Tổng) --%>
                            <div class="card p-4 bg-white rounded-lg shadow-sm">
                                <div class="text-sm text-gray-500">New Customers</div>
                                <div class="flex items-center justify-between mt-2">
                                    <div>
                                        <div id="kpiCustomers" class="text-2xl font-bold">${newCustomer}</div>
                                        <div class="text-xs text-gray-400">Khách hàng mới</div>
                                    </div>
                                    <div class="p-3 bg-yellow-50 rounded-md text-yellow-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.001M21 12a9 9 0 11-18 0 9 9 0 0118 0zM9.75 9.75c0-1.319 1.01-2.39 2.25-2.39s2.25 1.071 2.25 2.39c0 1.319-1.01 2.39-2.25 2.39s-2.25-1.071-2.25-2.39zM11.25 15.75c-3.204 0-5.83-1.372-6.524-3.238C4.688 12.26 4.5 12.623 4.5 13.003v.006c0 1.621 1.31 2.93 2.93 2.93h6.14c.482 0 .937-.09 1.359-.259A5.992 5.992 0 0111.25 15.75z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>

                            <%-- KPI 5: Pending Orders (Bán hàng) --%>
                            <div class="card p-4 bg-white rounded-lg shadow-sm">
                                <div class="text-sm text-gray-500">Pending Orders</div>
                                <div class="flex items-center justify-between mt-2">
                                    <div>
                                        <div id="kpiPending" class="text-2xl font-bold">${pending}</div>
                                        <div class="text-xs text-gray-400">Đơn hàng chờ xử lý</div>
                                    </div>
                                    <div class="p-3 bg-pink-50 rounded-md text-pink-600">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-4 gap-4">

                            <%-- Chart 1: Revenue (30 days) --%>
                            <div class="lg:col-span-2 bg-white rounded-lg p-4 shadow-sm">
                                <div class="flex items-center justify-between mb-3">
                                    <h3 class="font-semibold">Revenue (last 30 days)</h3>
                                    <div class="text-xs text-gray-500">Line chart</div>
                                </div>
                                <%-- Tăng chiều cao 1 chút cho cân đối --%>
                                <div style="max-height: 500px">
                                    <canvas id="revenueChart" height="500"></canvas>
                                </div>

                            </div>

                            <%-- Chart 2: Top Services --%>
                            <div class="lg:col-span-1 bg-white rounded-lg p-4 shadow-sm">
                                <div class="flex items-center justify-between mb-3">
                                    <h3 class="font-semibold">Top Services</h3>
                                    <div class="text-xs text-gray-500">Doughnut chart</div>
                                </div>
                                <c:if test="${isNullService}" >
                                    <div class="flex flex-col items-center justify-center h-[500px] text-gray-500">
                                        <%-- Icon (Biểu đồ bị gạch chéo) --%>
                                        <svg class="h-12 w-12" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 14.25v2.25m3-4.5v4.5m3-6.75v6.75m3-9v9M6 20.25h12A2.25 2.25 0 0 0 20.25 18V5.75A2.25 2.25 0 0 0 18 3.5H6A2.25 2.25 0 0 0 3.75 5.75v12.25A2.25 2.25 0 0 0 6 20.25Z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" d="m3.75 3.75 16.5 16.5" />
                                        </svg>

                                        <p class="mt-3 text-lg font-medium">Không có dữ liệu</p>
                                        <p class="text-sm">Chưa có dịch vụ nào được book trong tháng này.</p>
                                    </div>
                                </c:if>
                                <c:if test="${not isNullService}" >
                                    <div style="max-height: 500px">
                                        <canvas id="servicePie" height="500"></canvas>  
                                    </div>
                                </c:if>


                            </div>

                            <%-- Chart 3: Top Products - MỚI --%>
                            <div class="lg:col-span-1 bg-white rounded-lg p-4 shadow-sm">
                                <div class="flex items-center justify-between mb-3">
                                    <h3 class="font-semibold">Top Products</h3>
                                    <div class="text-xs text-gray-500">Doughnut chart</div>
                                </div>
                                <c:if test="${isNullProduct}">
                                    <div class="flex flex-col items-center justify-center h-[500px] text-gray-500">
                                        <%-- Icon (Biểu đồ bị gạch chéo) --%>
                                        <svg class="h-12 w-12" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 14.25v2.25m3-4.5v4.5m3-6.75v6.75m3-9v9M6 20.25h12A2.25 2.25 0 0 0 20.25 18V5.75A2.25 2.25 0 0 0 18 3.5H6A2.25 2.25 0 0 0 3.75 5.75v12.25A2.25 2.25 0 0 0 6 20.25Z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" d="m3.75 3.75 16.5 16.5" />
                                        </svg>

                                        <p class="mt-3 text-lg font-medium">Không có dữ liệu</p>
                                        <p class="text-sm">Chưa có sản phẩm nào được mua trong tháng này.</p>
                                    </div>
                                </c:if>
                                <c:if test="${not isNullProduct}">
                                    <div style="max-height: 500px">
                                        <canvas id="productPie" height="500"></canvas>
                                    </div>
                                </c:if>


                            </div>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">

                            <%-- List 1: Recent Bookings (ĐÃ THAY ĐỔI) --%>
                            <div class="lg:col-span-2 bg-white rounded-lg shadow-sm overflow-hidden">

                                <%-- 1. HEADER CỦA CARD --%>
                                <%-- Thêm padding và border-bottom để tách biệt rõ ràng --%>
                                <div class="flex items-center justify-between p-5 border-b border-gray-200">
                                    <h3 class="text-lg font-semibold text-gray-800">Recent Bookings</h3>
                                    <a href="${pageContext.request.contextPath}/admin/booking" class="text-sm text-sky-600 hover:text-sky-800 font-medium">
                                        View all Bookings
                                    </a>
                                </div>
                                <div class="p-4 sm:p-5">
                                    <ul id="recentBookingList" class="divide-y divide-gray-200">
                                        <c:if test="${empty recentBookings}">
                                            <li class="py-4 text-center text-gray-500">
                                                No recent bookings found.
                                            </li>
                                        </c:if>
                                        <c:forEach var="booking" items="${recentBookings}">
                                            <li class="py-4 flex items-center justify-between space-x-4">
                                                <div class="flex items-center space-x-4 min-w-0">
                                                    <div class="flex-shrink-0 h-10 w-10 flex items-center justify-center bg-sky-100 text-sky-700 rounded-full">
                                                        <%-- Heroicon: calendar --%>
                                                        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                                                        </svg>
                                                    </div>
                                                    <div class="flex-1 min-w-0">
                                                        <p class="text-sm font-semibold text-gray-900 truncate">
                                                            ${booking.customerName} (Pet: ${booking.petName})
                                                        </p>
                                                        <p class="text-sm text-gray-600 truncate">
                                                            Service: ${booking.serviceName}
                                                        </p>
                                                        <%-- HIỂN THỊ NGÀY VÀ GIỜ MỚI --%>
                                                        <p class="text-sm text-gray-500 mt-1">
                                                            <%-- Giả định 'requestedDate' là Date (Ngày) --%>
                                                            <fmt:formatDate value="${booking.requestedDate}" pattern="dd/MM/yyyy" />
                                                            <span class="text-gray-400 mx-1">·</span>
                                                            <%-- Giả định 'requestStart' là Time (Giờ) --%>
                                                            <fmt:formatDate value="${booking.requestedStart}" pattern="HH:mm" />
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="flex-shrink-0">
                                                    <c:set var="status" value="${booking.currentStatus}" />
                                                    <span class="px-2.5 py-0.5 text-xs font-medium rounded-full
                                                          <c:choose>
                                                              <c:when test='${status == "Chờ xác nhận"}'>bg-yellow-100 text-yellow-800</c:when>
                                                              <c:when test='${status == "Đã xác nhận"}'>bg-blue-100 text-blue-800</c:when>
                                                              <c:when test='${status == "Đang thực hiện"}'>bg-indigo-100 text-indigo-800</c:when>
                                                              <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                          </c:choose>
                                                          ">
                                                        ${booking.currentStatus}
                                                    </span>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>

                            <%-- List 2: Recent Orders --%>
                            <div class="lg:col-span-1 bg-white rounded-lg shadow-sm overflow-hidden">

                                <%-- 1. HEADER CỦA CARD --%>
                                <div class="flex items-center justify-between p-5 border-b border-gray-200">
                                    <h3 class="text-lg font-semibold text-gray-800">Recent Orders</h3>
                                    <a href="${pageContext.request.contextPath}/admin/order" class="text-sm text-sky-600 hover:text-sky-800 font-medium">
                                        View all Orders
                                    </a>
                                </div>

                                <%-- 2. PHẦN THÂN CARD (DANH SÁCH ORDER) --%>
                                <div class="p-4 sm:p-5">
                                    <ul id="orderList" class="divide-y divide-gray-200">
                                        <c:if test="${empty recentOrder}">
                                            <li class="py-4 text-center text-gray-500">
                                                No recent orders found.
                                            </li>
                                        </c:if>
                                        <c:forEach var="order" items="${recentOrder}">
                                            <li class="py-4 flex items-center justify-between space-x-4">
                                                <div class="flex items-center space-x-4 min-w-0">
                                                    <div class="flex-shrink-0 h-10 w-10 flex items-center justify-center bg-green-100 text-green-700 rounded-full">
                                                        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 10.5V6a3.75 3.75 0 1 0-7.5 0v4.5m11.356-1.993 1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 0 1-1.12-1.243l1.264-12A1.125 1.125 0 0 1 5.513 7.5h12.974c.576 0 1.059.435 1.119 1.007Z" />
                                                        </svg>
                                                    </div>
                                                    <div class="flex-1 min-w-0">
                                                        <p class="text-sm font-semibold text-gray-900 truncate">
                                                            ${order.customerName}
                                                        </p>
                                                        <p class="text-sm text-gray-500 truncate">
                                                            ${order.orderCode}
                                                        </p>
                                                    </div>
                                                </div>
                                                <div class="flex-shrink-0 text-right">
                                                    <p class="text-sm font-semibold text-gray-900">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                    </p>
                                                    <c:set var="status" value="${order.statusDescription}" />
                                                    <span class="mt-1 inline-block px-2.5 py-0.5 text-xs font-medium rounded-full
                                                          <c:choose>
                                                              <c:when test='${status == "Chờ xử lý"}'>bg-yellow-100 text-yellow-800</c:when>
                                                              <c:when test='${status == "Đã thanh toán"}'>bg-indigo-100 text-indigo-800</c:when>
                                                              <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                          </c:choose>
                                                          ">
                                                        ${order.statusDescription}
                                                    </span>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>      

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', () => {

                // SỬA 1: Dùng "empty" để kiểm tra
                // Nếu attribute bị null/empty, ta gán một mảng rỗng '[]'
                // để tránh lỗi cú pháp JavaScript.
                const revenueLabels = ${empty requestScope.labelRevenue ? '[]' : requestScope.labelRevenue};
                const revenueData = ${empty requestScope.dataRevenue ? '[]' : requestScope.dataRevenue};

                const serviceLabels = ${empty requestScope.labelService ? '[]' : requestScope.labelService};
                const serviceData = ${empty requestScope.dataService ? '[]' : requestScope.dataService};

                const productLabels = ${empty requestScope.labelProduct ? '[]' : requestScope.labelProduct};
                const productData = ${empty requestScope.dataProduct ? '[]' : requestScope.dataProduct};


                // SỬA 2: Truyền vào ID (chuỗi), KHÔNG truyền element
                if (revenueLabels.length > 0) {
                    initRevenueChart('revenueChart', revenueLabels, revenueData);
                }

                if (serviceLabels.length > 0) {
                    initDoughnutChart('servicePie', serviceLabels, serviceData);
                }

                if (productLabels.length > 0) {
                    initDoughnutChart('productPie', productLabels, productData);
                }
            });
        </script>
    </body>
</html>
