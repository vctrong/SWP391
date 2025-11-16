<%-- 
    Document   : orders
    Created on : Oct 31, 2025, 4:52:02 PM
    Author     : Vo Chi Trong - CE191062
--%>

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
                                <input id="orderSearch" placeholder="Search orders..." class="input-field" />
                                <select id="orderStatusFilter" class="input-field">
                                    <option value="">All</option>
                                    <option>Unpaid</option>
                                    <option>Paid</option>
                                    <option>Processing</option>
                                    <option>Delivered</option>
                                </select>
                            </div>
                        </div>
                        <!-- Order details modal -->
                        <div id="orderDetailModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black bg-opacity-50">
                            <div class="bg-white rounded-lg w-11/12 md:w-3/4 lg:w-1/2 p-4">
                                <div class="flex items-center justify-between mb-3">
                                    <h4 class="text-lg font-semibold">Order Details</h4>
                                    <button id="orderDetailClose" class="text-gray-600">Close</button>
                                </div>
                                <div id="orderDetailContent">
                                    <div class="mb-2"><strong>Order Code:</strong> <span id="od_code"></span></div>
                                    <div class="mb-2"><strong>Customer:</strong> <span id="od_customer"></span></div>
                                    <div class="mb-2"><strong>Created At:</strong> <span id="od_created"></span></div>
                                    <div class="mb-2"><strong>Total:</strong> <span id="od_total"></span></div>
                                    <div class="mb-2"><strong>Status:</strong>
                                        <select id="od_status" class="px-2 py-1 border rounded">
                                            <option>PENDING</option>
                                            <option>PROCESSING</option>
                                            <option>PAID</option>
                                            <option>DELIVERED</option>
                                            <option>CANCELLED</option>
                                        </select>
                                        <button id="od_save_status" class="ml-2 px-3 py-1 bg-blue-600 text-white rounded">Save</button>
                                    </div>
                                    <div class="mt-4">
                                        <table class="w-full text-sm">
                                            <thead>
                                                <tr>
                                                    <th>Product</th>
                                                    <th class="text-right">Unit</th>
                                                    <th class="text-right">Qty</th>
                                                    <th class="text-right">Line</th>
                                                </tr>
                                            </thead>
                                            <tbody id="od_items"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell">Order ID</th>
                                            <th class="table-header-cell">Customer</th>
                                            <th class="table-header-cell text-center">Date</th>
                                            <th class="table-header-cell text-right">Total</th>
                                            <th class="table-header-cell text-center">Payment</th>
                                            <th class="table-header-cell text-center">Shipping</th>
                                        </tr>
                                    </thead>
                                    <tbody id="ordersTableBody" class="text-sm divide-y divide-gray-200"></tbody>
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

        <script>
            // expose contextPath for client scripts
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminOrders.js"></script>
    </body>
</html>
