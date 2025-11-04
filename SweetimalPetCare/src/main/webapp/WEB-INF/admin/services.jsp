<%-- 
    Document   : services
    Created on : Oct 31, 2025, 4:51:26 PM
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
                    <section id="page-services" class="page-section space-y-6">
                        <!-- Header -->
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold text-sky-700">🐾 Service Management</h3>
                            <div class="flex items-center gap-2">
                                <input id="serviceSearch" placeholder="Search by name or code..."
                                       class="input-field w-64 border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-sky-400" />
                                <div class="relative inline-block text-left">
                                    <div>
                                        <button type="button" id="addMenuBtn" 
                                                class="inline-flex w-full justify-center items-center gap-2 rounded-md bg-sky-600 px-4 py-2 text-sm font-medium text-white hover:bg-sky-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                                            + Add New
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
                                            </svg>
                                        </button>
                                    </div>
                                    <div id="addMenuDropdown"
                                         class="hidden absolute right-0 mt-2 w-56 origin-top-right divide-y divide-gray-100 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none z-40">
                                        <div class="px-1 py-1">
                                            <button data-modal-target="addServiceModal"
                                                    class="text-gray-900 group flex w-full items-center rounded-md px-2 py-2 text-sm hover:bg-sky-500 hover:text-white">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826 3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                </svg>
                                                Add Service
                                            </button>
                                            <button data-modal-target="addPackageModal"
                                                    class="text-gray-900 group flex w-full items-center rounded-md px-2 py-2 text-sm hover:bg-sky-500 hover:text-white">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                                                </svg>
                                                Add Service Package
                                            </button>
                                        </div>
                                        <div class="px-1 py-1">
                                            <button data-modal-target="addCategoryModal"
                                                    class="text-gray-900 group flex w-full items-center rounded-md px-2 py-2 text-sm hover:bg-sky-500 hover:text-white">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                                                </svg>
                                                Add Service Category
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Table -->
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-200">
                            <div class="overflow-x-auto">
                                <table class="w-full table-auto text-sm">
                                    <thead class="bg-gray-100 text-gray-700">
                                        <tr>
                                            <th class="table-header-cell text-left px-4 py-3">ID</th>
                                            <th class="table-header-cell text-left px-4 py-3">Code</th>
                                            <th class="table-header-cell text-left px-4 py-3">Name</th>
                                            <th class="table-header-cell text-left px-4 py-3">Category</th>
                                            <th class="table-header-cell text-center px-4 py-3">Duration (min)</th>
                                            <th class="table-header-cell text-right px-4 py-3">Price (₫)</th>
                                            <th class="table-header-cell text-center px-4 py-3">Status</th>
                                            <th class="table-header-cell text-center px-4 py-3">Created At</th>
                                            <th class="table-header-cell text-center px-4 py-3">Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody id="servicesTableBody" class="divide-y divide-gray-200 text-gray-700">
                                        <c:forEach var="service" items="${listService}" >
                                            <tr class="hover:bg-gray-50 transition">
                                                <td class="px-4 py-2">${service.serviceId}</td>
                                                <td class="px-4 py-2 font-medium text-sky-600">${service.serviceCode}</td>
                                                <td class="px-4 py-2">${service.serviceName}</td>
                                                <td class="px-4 py-2">${service.serviceCateName}</td>
                                                <td class="px-4 py-2 text-center">${service.baseDurationMin}</td>
                                                <td class="px-4 py-2 text-right"> <fmt:formatNumber value="${service.currentPrice}" groupingUsed="true" /> </td>
                                                <td class="px-4 py-2 text-center">
                                                    <span class="px-2 py-1 text-xs font-semibold rounded-full
                                                          ${service.status == "ACTIVE" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"}  ">
                                                        ${service.status}
                                                    </span>
                                                </td>
                                                <td class="px-4 py-2 text-center"> <fmt:formatDate value="${service.createdAt}" pattern="dd/MM/yyyy" /> </td>
                                                <td class="px-4 py-2 text-center">
                                                    <div class="flex justify-center gap-2">
                                                        <form action="service-detail" method="get">
                                                            <input type="hidden" name="id" value="6"/>
                                                            <button type="submit"
                                                                    class="px-3 py-1 bg-sky-500 hover:bg-sky-600 text-white text-xs rounded-md">Detail</button>
                                                        </form>
                                                        <form action="service-edit" method="get">
                                                            <input type="hidden" name="id" value="7"/>
                                                            <button type="submit"
                                                                    class="px-3 py-1 bg-amber-500 hover:bg-amber-600 text-white text-xs rounded-md">Edit</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="0=0">
                                            <tr>
                                                <td colspan="9" class="text-center py-4 text-gray-500">No services found.</td>
                                            </tr> 
                                        </c:if>


                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>
        <%@include file="/WEB-INF/modal/addServiceCate.jsp" %>
        <%@include file="/WEB-INF/modal/addServiceModal.jsp" %>
        <%@include file="/WEB-INF/modal/addPackageService.jsp" %>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/modalHandle_admin.js"></script>

    </body>
</html>
