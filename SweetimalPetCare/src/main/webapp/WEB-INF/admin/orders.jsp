<%-- 
    Document   : orders
    Created on : Oct 31, 2025, 4:52:02 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Services Admin | Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="includes/headAdmin.jsp" %>
    </head>
    <body  class="font-inter bg-gray-50 text-gray-800">
        <div class="min-h-screen flex">
            <%@include file="../admin/includes/admin_sidebar.jsp" %>
            <%@include file="includes/mobileApp.jsp" %>
            <div class="flex-1 md:pl-72">
                <%@include file="includes/admin_header.jsp" %>
                <main class="p-4 md:p-8">
                    <section id="page-orders" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold">Order Management</h3>
                            <div class="flex items-center gap-2">
                                <input id="orderSearch" onkeyup="filterOrders()" 
                                       placeholder="Search code, customer..." 
                                       class="input-field border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />

                                <select id="orderStatusFilter" onchange="filterOrders()" 
                                        class="input-field border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                                    <option value="">All Status</option>
                                    <option value="PENDING">PENDING</option>
                                    <option value="PAID">PAID</option>
                                    <option value="PROCESSING">PROCESSING</option>
                                    <option value="SHIPPED">SHIPPED</option>
                                    <option value="DELIVERED">DELIVERED</option> <%-- Bạn thiếu cái này --%>
                                    <option value="COMPLETED">COMPLETED</option>
                                    <option value="CANCELLED">CANCELLED</option>
                                </select>
                                <button onclick="document.getElementById('createOrderModal').classList.remove('hidden'); document.getElementById('createOrderModal').classList.add('flex');" 
                                        class="flex items-center gap-1 bg-blue-600 hover:bg-blue-700 text-white px-3 py-2 rounded-md text-sm font-medium transition-colors shadow-sm whitespace-nowrap">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                    </svg>
                                    Create Order
                                </button>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell text-left p-4 font-semibold">Order ID</th>
                                            <th class="table-header-cell text-left p-4 font-semibold">Code</th>
                                            <th class="table-header-cell text-left p-4 font-semibold">Customer</th>
                                            <th class="table-header-cell text-center p-4 font-semibold">Date</th>
                                            <th class="table-header-cell text-right p-4 font-semibold">Total</th>
                                            <th class="table-header-cell text-center p-4 font-semibold">Payment</th>
                                            <th class="table-header-cell text-center p-4 font-semibold">Status</th>
                                            <th class="table-header-cell text-center p-4 font-semibold">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody  id="ordersTableBody" class="text-sm divide-y divide-gray-200">
                                        <c:forEach items="${orderList}" var="o">
                                            <tr class="hover:bg-gray-50 transition-colors">
                                                <td class="p-4">#${o.orderId}</td>
                                                <td class="p-4 font-mono text-blue-600 font-medium">${o.orderCode}</td>
                                                <td class="p-4">
                                                    <div class="font-medium text-gray-900">${o.customerName}</div>
                                                </td>
                                                <td class="p-4 text-center">
                                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td class="p-4 text-right font-medium">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td class="p-4 text-center">
                                                    <span class="px-2 py-1 text-xs font-semibold rounded-full">
                                                        ${o.paymentMethodCode}
                                                    </span>
                                                </td>
                                                <td class="p-4 text-center">
                                                    <c:choose>         
                                                        <c:when test="${o.orderStatus == 'CANCELLED'}">
                                                            <c:set var="statusColor" value="bg-red-100 text-red-800" />
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 'PENDING'}">
                                                            <c:set var="statusColor" value="bg-yellow-100 text-yellow-800" />
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 'PAID'}">
                                                            <c:set var="statusColor" value="bg-teal-100 text-teal-800" />
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 'PROCESSING'}">
                                                            <c:set var="statusColor" value="bg-blue-100 text-blue-800" />
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 'SHIPPED'}">
                                                            <c:set var="statusColor" value="bg-purple-100 text-purple-800" />
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 'COMPLETED'}">
                                                            <c:set var="statusColor" value="bg-green-100 text-green-800" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="statusColor" value="bg-gray-100 text-gray-800" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="px-2 py-1 text-xs font-semibold rounded-full ${statusColor}">
                                                        ${o.orderStatus}
                                                    </span>
                                                </td>
                                                <td class="p-4 text-center">
                                                    <button type="button" 
                                                            data-order-id="${o.orderId}" 
                                                            class="btn-view-order text-blue-600 hover:text-blue-900 font-medium hover:underline">
                                                        Detail
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty orderList}">
                                            <tr>
                                                <td colspan="8" class="text-center p-8 text-gray-500">No orders found.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                            <div class="px-6 py-4 border-t border-gray-200 flex flex-col md:flex-row items-center justify-between bg-gray-50 gap-4">

                                <!-- Page size selector -->
                                <div class="flex items-center gap-2 text-sm text-gray-600">
                                    <span>Show</span>
                                    <select id="ordersPageSize" class="px-2 py-1 border border-gray-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                        <option value="50">50</option>
                                    </select>
                                    <span>entries</span>
                                </div>

                                <!-- Page info -->
                                <span id="ordersPageInfo" class="text-sm text-gray-600">Showing 0 to 0 of 0 entries</span>

                                <!-- Pagination controls -->
                                <div id="ordersPaginationControls" class="flex items-center gap-1"></div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <%@include file="/WEB-INF/modal/CreateNewOrderModal.jsp" %>
        <%@include file="/WEB-INF/modal/DetailOrderModal.jsp" %>
        <c:if test="${not empty sessionScope.notifiType}">
            <script>
                Swal.fire({
                    title: '${sessionScope.notifiType == "success" ? "Thành công!" : "Lỗi!"}',
                    text: '${sessionScope.notifiMsg}',
                    icon: '${sessionScope.notifiType}', // success, error, warning, info
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: 'OK',
                    timer: 3000, // Tự tắt sau 3 giây
                    timerProgressBar: true
                });
            </script>

            <%-- Quan trọng: Xóa thông báo khỏi session ngay sau khi đã render ra HTML --%>
            <%-- Để khi F5 lại trang nó không hiện lại nữa --%>
            <c:remove var="notifiType" scope="session" />
            <c:remove var="notifiMsg" scope="session" />
        </c:if>
        <script>
            // expose contextPath for client scripts
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
        <script>
            const url = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminOrders.js"></script>
    </body>
</html>
