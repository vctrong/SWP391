<%-- 
    Document   : history
    Created on : Nov 16, 2025, 5:48:26 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <link rel="stylesheet" href="assets/css/profile.css"/>
    </head>
    <body class="bg-gray-100">
        <%@include file="/WEB-INF/include/headerProfileUser.jsp" %>


        <!-- ====== BODY: SIDEBAR + NỘI DUNG ====== -->
        <div class="max-w-7xl mx-auto py-8 px-4 lg:flex lg:gap-6">

            <!-- SIDEBAR -->
            <%@include file="/WEB-INF/include/sidebarProfileUser.jsp" %>

            <main class="w-full lg:w-3/4">
                <div class="space-y-6">

                    <!-- Page title / quick summary -->
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                        <div>
                            <h3 class="text-lg font-semibold text-sky-600 mb-1">Lịch sử mua hàng & Dịch vụ</h3>
                            <p class="text-sm text-slate-500">Xem lại đơn hàng, lịch sử booking và quản lý các thao tác liên quan.</p>
                        </div>

                        <!-- Quick KPIs -->
                        <div class="flex items-center gap-3">
                            <div class="hidden sm:flex items-center gap-3 bg-white rounded-xl p-3 shadow">
                                <div class="text-sm text-slate-500">Tổng đơn</div>
                                <%-- Truy cập biến "kpis" đã set từ Servlet --%>
                                <div class="text-lg font-semibold text-slate-800">${kpis.totalOrdersAndBookings}</div>
                            </div>
                            <div class="hidden sm:flex items-center gap-3 bg-white rounded-xl p-3 shadow">
                                <div class="text-sm text-slate-500">Đang xử lý</div>
                                <div class="text-lg font-semibold text-amber-600">${kpis.processingItems}</div>
                            </div>
                            <div class="hidden sm:flex items-center gap-3 bg-white rounded-xl p-3 shadow">
                                <div class="text-sm text-slate-500">Tổng chi</div>
                                <%-- Định dạng tiền tệ --%>
                                <fmt:setLocale value="vi_VN"/>
                                <div class="text-lg font-semibold text-slate-800">
                                    <fmt:formatNumber value="${kpis.totalSpent}" type="currency" currencySymbol="đ"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Toolbar: search, filters, export -->
                    <div class="bg-white rounded-2xl p-4 flex flex-col md:flex-row md:items-center md:justify-between gap-3 shadow-sm">
                        <form id="historyFilters" class="flex items-center gap-3 flex-1" role="search" onsubmit="return false;">
                            <!-- Search -->
                            <div class="flex items-center bg-slate-50 border border-slate-100 rounded-full px-3 py-2 w-full md:w-2/3">
                                <i class="fa-solid fa-magnifying-glass text-slate-400 mr-3"></i>
                                <input id="historySearch" type="search" placeholder="Tìm mã đơn, tên sản phẩm hoặc mã booking..." aria-label="Tìm kiếm lịch sử" class="bg-transparent outline-none text-sm w-full" />
                                <button id="clearSearchBtn" type="button" class="ml-3 text-xs text-slate-500 hover:underline hidden">Xóa</button>
                            </div>

                            <!-- Status filter -->
                            <select id="statusFilter" class="bg-white border border-slate-200 rounded-lg px-3 py-2 text-sm">
                                <option value="">Tất cả trạng thái</option>
                                <option value="PENDING">Chờ xác nhận</option>
                                <option value="PROCESSING">Đang xử lý</option>
                                <option value="PAID">Đã thanh toán</option>
                                <option value="SHIPPED">Đã gửi</option>
                                <option value="COMPLETED">Hoàn tất</option>
                                <option value="CANCELLED">Đã hủy</option>
                            </select>

                            <!-- Date range (simple inputs; you can replace with datepicker) -->
                            <div class="flex items-center gap-2">
                                <input id="dateFrom" type="date" class="text-sm border border-slate-100 rounded-lg px-2 py-2" />
                                <span class="text-slate-400 text-sm">→</span>
                                <input id="dateTo" type="date" class="text-sm border border-slate-100 rounded-lg px-2 py-2" />
                            </div>
                        </form>
                    </div>

                    <!-- Orders table -->
                    <section class="bg-white rounded-2xl shadow-md p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-lg font-semibold text-slate-800">Lịch sử mua hàng</h4>
                            <div class="text-sm text-slate-500">Hiển thị 1–10 trong 12 kết quả</div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-left" role="table" aria-label="Lịch sử mua hàng">
                                <thead class="border-b">
                                    <tr class="text-slate-600 text-sm">
                                        <th scope="col" class="pb-3 pr-4">Mã đơn</th>
                                        <th scope="col" class="pb-3 pr-4">Sản phẩm</th>
                                        <th scope="col" class="pb-3 pr-4">Ngày mua</th>
                                        <th scope="col" class="pb-3 pr-4 text-right">Tổng tiền</th>
                                        <th scope="col" class="pb-3 pr-4">Trạng thái</th>
                                        <th scope="col" class="pb-3 pr-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody class="text-slate-700 text-sm divide-y">
                                    <c:forEach var="order" items="${orderList}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="py-4 pr-4 align-top">${order.orderCode}</td>
                                            <td class="py-4 pr-4 align-top min-w-[220px]">
                                                <div class="font-medium truncate">${order.primaryProductName}</div>
                                                <div class="text-xs text-slate-500 truncate">${order.primaryProductDescription}</div>
                                            </td>
                                            <td class="py-4 pr-4 align-top">
                                                <fmt:formatDate value="${order.purchaseDate}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td class="py-4 pr-4 align-top text-right font-semibold">
                                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="py-4 pr-4 align-top">
                                                <%-- Tùy chỉnh màu sắc dựa trên trạng thái (nếu muốn) --%>
                                                <span class="inline-block px-2 py-1 bg-slate-100 text-slate-700 rounded-lg text-xs font-medium">
                                                    ${order.statusDisplay}
                                                </span>
                                            </td>
                                            <td class="py-4 pr-4 align-top">
                                                <div class="flex items-center gap-2">
                                                    <a href="/orders/${order.orderId}" class="text-sky-600 text-xs hover:underline">Xem</a>
                                                    <button type="button" class="text-xs text-slate-600 hover:underline">Mua lại</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orderList}">
                                        <tr>
                                            <td colspan="6" class="py-4 text-center text-slate-500">Bạn chưa có đơn hàng nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination (static demo) -->
                        <div class="mt-4 flex items-center justify-between">
                            <div class="text-sm text-slate-500">Hiển thị 1–3 trong 12 kết quả</div>
                            <div class="flex items-center gap-2">
                                <button type="button" class="px-3 py-1 rounded-lg border text-sm bg-white hover:shadow">← Trước</button>
                                <button type="button" class="px-3 py-1 rounded-lg border text-sm bg-white hover:shadow">Tiếp →</button>
                            </div>
                        </div>
                    </section>

                    <!-- Booking history -->
                    <section class="bg-white rounded-2xl shadow-md p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-lg font-semibold text-slate-800">Lịch sử booking dịch vụ</h4>
                            <div class="text-sm text-slate-500">Hiển thị 1–5 trong 8 kết quả</div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-left" role="table" aria-label="Lịch sử booking dịch vụ">
                                <thead class="border-b">
                                    <tr class="text-slate-600 text-sm">
                                        <th scope="col" class="pb-3 pr-4">Mã booking</th>
                                        <th scope="col" class="pb-3 pr-4">Dịch vụ</th>
                                        <th scope="col" class="pb-3 pr-4">Ngày hẹn</th>
                                        <th scope="col" class="pb-3 pr-4 text-right">Giá dịch vụ</th>
                                        <th scope="col" class="pb-3 pr-4">Trạng thái</th>
                                        <th scope="col" class="pb-3 pr-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody class="text-slate-700 text-sm divide-y">

                                    <%-- VÒNG LẶP JSTL ĐỂ HIỂN THỊ BOOKING --%>
                                    <%-- Dùng biến 'bookingList' từ request.setAttribute("bookingList", ...) --%>
                                    <c:forEach var="booking" items="${bookingList}">
                                        <tr class="hover:bg-slate-50 transition-colors">
                                            <td class="py-4 pr-4">${booking.getBookingCodeDisplay()}</td>
                                            <td class="py-4 pr-4 min-w-[220px]">
                                                <div class="font-medium">${booking.serviceName}</div>
                                                <div class="text-xs text-slate-500">${booking.serviceDescription}</div>
                                            </td>
                                            <td class="py-4 pr-4">
                                                <div><fmt:formatDate value="${booking.appointmentDate}" pattern="dd/MM/yyyy" /></div>
                                                <%-- LocalTime.toString() sẽ ra định dạng HH:mm --%>
                                                <div class="text-xs text-slate-500">${booking.appointmentTime}</div>
                                            </td>
                                            <td class="py-4 pr-4 text-right font-semibold">
                                                <fmt:formatNumber value="${booking.price}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="py-4 pr-4">
                                                <span class="inline-block px-2 py-1 bg-blue-100 text-blue-700 rounded-lg text-xs font-medium">
                                                    ${booking.statusDisplay}
                                                </span>
                                            </td>
                                            <td class="py-4 pr-4">
                                                <div class="flex items-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/booking?id=${booking.bookingId}" class="text-sky-600 text-xs hover:underline">Xem</a>
                                                    <button type="button" class="text-xs text-slate-600 hover:underline" onclick="alert('Demo: Đặt lại')">Đặt lại</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <%-- Hiển thị nếu danh sách rỗng --%>
                                    <c:if test="${empty bookingList}">
                                        <tr>
                                            <td colspan="6" class="py-4 text-center text-slate-500">Bạn chưa có lịch hẹn dịch vụ nào.</td>
                                        </tr>
                                    </c:if>

                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="mt-4 flex items-center justify-between">
                            <div class="text-sm text-slate-500">Hiển thị 1–3 trong 8 kết quả</div>
                            <div class="flex items-center gap-2">
                                <button type="button" class="px-3 py-1 rounded-lg border text-sm bg-white hover:shadow">← Trước</button>
                                <button type="button" class="px-3 py-1 rounded-lg border text-sm bg-white hover:shadow">Tiếp →</button>
                            </div>
                        </div>
                    </section>
                </div>
            </main>
        </div>
    </body>
</html>