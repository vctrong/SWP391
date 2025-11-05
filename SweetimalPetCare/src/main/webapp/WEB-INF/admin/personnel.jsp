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
                            <h3 class="text-lg font-semibold">Personnel Management</h3>
                            <div class="flex items-center gap-2">
                                <input id="personSearch" placeholder="Search..." class="input-field" />
                                <select id="roleFilter" class="input-field">
                                    <option value="">All roles</option>
                                    <option value="customer">Customer</option>
                                    <option value="staff">Staff</option>
                                    <option value="doctor">Doctor</option>
                                </select>
                                <button id="addPeopleBtn" class="btn-primary">Add Person</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm">
                            <div class="border-b border-gray-200">
                                <div class="flex gap-4 px-4">
                                    <button class="tabBtn px-3 py-3 text-gray-500 hover:text-gray-700" data-tab="users">Customers</button>
                                    <button class="tabBtn px-3 py-3 text-gray-500 hover:text-gray-700" data-tab="staff">Staff</button>
                                    <button class="tabBtn px-3 py-3 text-gray-500 hover:text-gray-700" data-tab="doctors">Doctors</button>
                                </div>
                            </div>

                            <div class="p-4 overflow-x-auto">
                                <table class="w-full table-auto">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell">Full name</th>
                                            <th class="table-header-cell">Email</th>
                                            <th class="table-header-cell">Phone</th>
                                            <th class="table-header-cell text-center">Role</th>
                                            <th class="table-header-cell text-center">Status</th>
                                            <th class="table-header-cell text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="peopleTableBody" class="text-sm divide-y divide-gray-200"></tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
    </body>
</html>
