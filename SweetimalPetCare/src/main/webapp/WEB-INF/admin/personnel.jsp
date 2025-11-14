<%-- 
    Document   : personnel
    Created on : Oct 31, 2025, 4:51:48 PM
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
                    <section id="page-personnel" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <div>
                                <h3 class="text-xl font-bold text-gray-800">Personnel Management</h3>
                                <p class="text-sm text-gray-500">Manage users, staff, and veterinarians accounts.</p>
                            </div>

                            <div class="flex items-center gap-2 w-full md:w-auto">
                                <div class="relative flex-1 md:w-64">
                                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"/></svg>
                                    </span>
                                    <input id="personSearch" type="text" placeholder="Search by name, email..." class="pl-10 pr-4 py-2 border border-gray-300 rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                                </div>

                                <button id="addPeopleBtn" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg shadow-sm flex items-center gap-2 transition-colors text-sm font-medium whitespace-nowrap">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                                    <span>Add Person</span>
                                </button>
                            </div>
                        </div>

                        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">

                            <div class="border-b border-gray-200 px-4">
                                <div class="flex gap-6">
                                    <button class="tabBtn py-4 text-blue-600 border-b-2 border-blue-600 font-medium text-sm transition-colors" data-role-id="1">Customers</button>
                                    <button class="tabBtn py-4 text-gray-500 hover:text-gray-700 border-b-2 border-transparent hover:border-gray-300 font-medium text-sm transition-colors" data-role-id="2">Staff</button>
                                    <button class="tabBtn py-4 text-gray-500 hover:text-gray-700 border-b-2 border-transparent hover:border-gray-300 font-medium text-sm transition-colors" data-role-id="3">Veterinarians</button>
                                </div>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full text-left border-collapse">
                                    <thead class="bg-gray-50 text-gray-600 text-xs uppercase font-semibold tracking-wider border-b border-gray-200">
                                        <tr>
                                            <th class="px-6 py-3 min-w-[200px]">User Info</th>
                                            <th class="px-6 py-3 min-w-[200px]">Contact</th>
                                            <th class="px-6 py-3 text-center">Role</th>
                                            <th class="px-6 py-3 text-center">Status</th>
                                            <th class="px-6 py-3 text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="peopleTableBody" class="divide-y divide-gray-200 text-sm text-gray-700 bg-white">
                                        <!-- JS SẼ RENDER DỮ LIỆU VÀO ĐÂY -->
                                    </tbody>
                                </table>
                            </div>

                            <div class="px-6 py-4 border-t border-gray-200 flex flex-col md:flex-row items-center justify-between bg-gray-50 gap-4">

                                <!-- 1. Bộ chọn Page Size (Trái) -->
                                <div class="flex items-center gap-2 text-sm text-gray-600">
                                    <span>Show</span>
                                    <select id="pageSizeSelect" class="px-2 py-1 border border-gray-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                        <option value="30">30</option>
                                        <option value="50">50</option>
                                    </select>
                                    <span>entries</span>
                                </div>

                                <!-- 2. Thông tin (Giữa) -->
                                <span id="pageInfo" class="text-sm text-gray-600">
                                    <!-- JS sẽ điền: Showing 1 to 10 of 50 entries -->
                                </span>

                                <!-- 3. Nút bấm (Phải) -->
                                <div id="paginationControls" class="flex items-center gap-1">
                                    <!-- JS sẽ render các nút bấm trang vào đây -->
                                </div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>
        <%@include file="/WEB-INF/modal/addUserModal.jsp" %>
        <%@include file="/WEB-INF/modal/GenScheduleSlotModal.jsp" %>
        <script>
            var contextPath = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPersonal.js"></script>
    </body>
</html>
