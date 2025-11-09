<%-- 
    Document   : bookings
    Created on : Oct 31, 2025, 4:51:55 PM
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
                    <section id="page-bookings" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold">Booking Management</h3>
                            <div class="flex items-center gap-2">
                                <input id="bookingSearch" placeholder="Search booking..." class="input-field" />
                                <select id="bookingStatusFilter" class="input-field">
                                    <option value="">All statuses</option>
                                    <option>Pending</option>
                                    <option>Confirmed</option>
                                    <option>Completed</option>
                                    <option>Cancelled</option>
                                </select>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                            <div class="col-span-2 bg-white rounded-lg p-4 shadow-sm">
                                <div id="calendar"></div>
                            </div>

                            <div class="bg-white rounded-lg p-4 shadow-sm">
                                <h4 class="font-semibold mb-3">Bookings Table</h4>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-sm">
                                        <thead class="bg-gray-50">
                                            <tr>
                                                <th class="table-header-cell">ID</th>
                                                <th class="table-header-cell">Customer</th>
                                                <th class="table-header-cell text-center">Service</th>
                                                <th class="table-header-cell text-center">Staff</th>
                                                <th class="table-header-cell text-center">Date</th>
                                                <th class="table-header-cell text-center">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="bookingsTableBody" class="divide-y divide-gray-200"></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
    </body>
</html>
