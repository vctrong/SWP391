<%-- 
    Document   : addServiceModal
    Created on : Nov 3, 2025, 8:18:29 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="addServiceModal" class="hidden fixed inset-0 z-50 overflow-hidden flex justify-end" aria-labelledby="modal-title" role="dialog" aria-modal="true">

    <!-- Overlay -->
    <div data-modal-overlay
         class="overlay fixed inset-0 bg-black bg-opacity-50 transition-opacity duration-300 ease-in-out opacity-0"
         data-modal-close="addServiceModal"
         aria-hidden="true"></div>

    <!-- Panel -->
    <div class="panel relative bg-white rounded-2xl shadow-2xl w-full max-w-lg transform translate-x-full
         transition-transform duration-300 ease-in-out mr-6 my-10 flex flex-col max-h-[90vh]">

        <!-- Header -->
        <div class="flex items-center justify-between px-6 py-4 border-b">
            <h3 class="text-lg font-semibold text-sky-700">🐾 Add New Service</h3>
            <button type="button" data-modal-close="addServiceModal" class="text-gray-400 hover:text-gray-600 text-2xl">&times;</button>
        </div>

        <!-- Body -->
        <form action="${pageContext.request.contextPath}/admin/service" method="post" class="flex-1 overflow-y-auto">
            <div class="p-6 space-y-4">

                <!-- Service Code & Name -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label for="service_code" class="block text-sm font-medium text-gray-700">
                            Service Code <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="service_code" name="service_code" required maxlength="50"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200" />
                    </div>

                    <div>
                        <label for="service_name" class="block text-sm font-medium text-gray-700">
                            Service Name <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="service_name" name="service_name" required maxlength="150"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200" />
                    </div>
                </div>

                <!-- Category -->
                <div>
                    <label for="service_category_id" class="block text-sm font-medium text-gray-700">
                        Category <span class="text-red-500">*</span>
                    </label>
                    <select id="service_category_id" name="service_category_id" required
                            class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                            focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent bg-white transition-all duration-200">
                        <option value="" disabled selected>-- Select a category --</option>
                        <c:forEach var="cat" items="${listCate}">
                            <option value="${cat.serviceCategoryId}">${cat.categoryName}</option>
                        </c:forEach>

                    </select>
                </div>

                <!-- Duration & Price -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label for="base_duration_min" class="block text-sm font-medium text-gray-700">
                            Duration (minutes) <span class="text-red-500">*</span>
                        </label>
                        <input type="number" id="base_duration_min" name="base_duration_min" required min="1"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200" />
                    </div>

                    <div>
                        <label for="current_price" class="block text-sm font-medium text-gray-700">
                            Price (₫) <span class="text-red-500">*</span>
                        </label>
                        <input type="number" id="current_price" name="current_price" required min="0" step="1000"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200" />
                    </div>
                </div>

                <!-- Status -->
                <div>
                    <label for="service_status" class="block text-sm font-medium text-gray-700">Status</label>
                    <select id="service_status" name="status"
                            class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                            focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent bg-white transition-all duration-200">
                        <option value="ACTIVE" selected>Active</option>
                        <option value="INACTIVE">Inactive</option>
                    </select>
                </div>

                <!-- Description -->
                <div>
                    <label for="service_description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="service_description" name="description" rows="4"
                              class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200"></textarea>
                </div>

            </div>

            <!-- Footer -->
            <div class="px-6 py-4 bg-gray-50 border-t flex justify-end gap-3 rounded-b-2xl">
                <button type="button" data-modal-close="addServiceModal"
                        class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md text-sm hover:bg-gray-300 transition-colors">
                    Cancel
                </button>
                <button type="submit"
                        class="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-all duration-200">
                    Save Service
                </button>
            </div>
        </form>
    </div>
</div>

