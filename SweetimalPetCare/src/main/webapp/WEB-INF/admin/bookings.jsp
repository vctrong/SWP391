<%-- 
    Document   : bookings
    Created on : Oct 31, 2025, 4:51:55 PM
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
                    <section id="page-bookings" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold">Booking Management</h3>

                            <div class="relative w-full md:w-64">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                </span>
                                <input id="bookingSearch" type="text" 
                                       onkeyup="handleSearch(event)" 
                                       placeholder="Search customer or phone..." 
                                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-sm" />
                            </div>
                        </div>

                        <input type="hidden" id="currentStatus" value="" />

                        <div class="border-b border-gray-200">
                            <nav class="-mb-px flex space-x-6 overflow-x-auto" aria-label="Tabs">
                                <button onclick="filterStatus(this, '')" 
                                        class="status-tab active-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-blue-600 border-blue-500">
                                    All Statuses
                                </button>

                                <button onclick="filterStatus(this, 'PENDING')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    Pending
                                </button>

                                <button onclick="filterStatus(this, 'CONFIRMED')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    Confirmed
                                </button>

                                <button onclick="filterStatus(this, 'IN_PROGRESS')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    In Progress
                                </button>

                                <button onclick="filterStatus(this, 'COMPLETED')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    Completed
                                </button>

                                <button onclick="filterStatus(this, 'CANCELLED')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    Cancelled
                                </button>
                                <button onclick="filterStatus(this, 'NO_SHOW')" 
                                        class="status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300">
                                    No Show
                                </button>
                            </nav>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
                            <div class="col-span-2 bg-white rounded-lg p-4 shadow-sm">
                                <div id="calendar"></div>
                            </div>

                            <div class="bg-white rounded-lg p-4 shadow-sm">
                                <div class="flex justify-between items-center mb-4 border-b pb-2">
                                    <h4 class="text-lg font-semibold text-gray-800">Bookings List</h4>

                                    <span id="totalBookingsBadge" class="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded">
                                        Loading...
                                    </span>
                                </div>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-sm text-left">
                                        <thead class="bg-gray-50 border-b">
                                            <tr>
                                                <th class="py-3 px-4">ID</th>
                                                <th class="py-3 px-4">Customer</th>
                                                <th class="py-3 px-4">Pet Info</th>
                                                <th class="py-3 px-4">Service / Package</th>
                                                <th class="py-3 px-4">Date & Time</th>
                                                <th class="py-3 px-4">Price</th>
                                                <th class="py-3 px-4">Status</th>
                                                <th class="py-3 px-4">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="bookingsTableBody" class="divide-y divide-gray-200">
                                            <tr><td colspan="8" class="text-center py-4">Loading...</td></tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div id="paginationControls" class="flex justify-end gap-2 mt-4 items-center"></div>
                            </div>

                        </div>
                    </section>
                </main>
            </div>
        </div>
        <%@include file="/WEB-INF/modal/modalDetailBooking.jsp" %>
        <%@include file="/WEB-INF/modal/modalVetVisit.jsp" %>
        <script>
            var contextPath = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminCalendar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bookingAdminPages.js"></script>
    </body>
</html>
