<%-- 
    Document   : addPackageService
    Created on : Nov 4, 2025, 11:07:05 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Add Package Modal -->
<div id="addPackageModal"
     class="hidden fixed inset-0 z-50 overflow-hidden"
     aria-labelledby="modal-title" role="dialog" aria-modal="true">

    <!-- Overlay -->
    <div data-modal-overlay
         class="overlay fixed inset-0 bg-black bg-opacity-50 transition-opacity duration-300 ease-in-out opacity-0"
         data-modal-close="addPackageModal" aria-hidden="true"></div>

    <!-- Panel -->
    <div
        class="panel absolute top-4 right-4 bottom-4 w-full max-w-lg bg-white rounded-2xl shadow-2xl border border-gray-100
        flex flex-col transition-transform duration-300 ease-in-out transform translate-x-full">

        <!-- Header -->
        <div class="flex items-center justify-between px-6 py-4 border-b">
            <h3 class="text-lg font-semibold text-sky-700">📦 Add New Service Package</h3>
            <button type="button" data-modal-close="addPackageModal"
                    class="text-gray-400 hover:text-gray-600 text-2xl">&times;</button>
        </div>

        <!-- Body -->
        <form action="your-add-package-servlet" method="post" class="flex-1 overflow-y-auto">
            <div class="p-6 space-y-4">

                <div class="grid grid-cols-2 gap-4">
                    <!-- Package Code -->
                    <div>
                        <label for="package_code" class="block text-sm font-medium text-gray-700">
                            Package Code <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="package_code" name="package_code" required maxlength="50"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400" />
                    </div>

                    <!-- Package Name -->
                    <div>
                        <label for="package_name" class="block text-sm font-medium text-gray-700">
                            Package Name <span class="text-red-500">*</span>
                        </label>
                        <input type="text" id="package_name" name="package_name" required maxlength="150"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400" />
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <!-- Package Price -->
                    <div>
                        <label for="package_price" class="block text-sm font-medium text-gray-700">
                            Package Price (₫) <span class="text-red-500">*</span>
                        </label>
                        <input type="number" id="package_price" name="package_price" required min="0" step="1000"
                               class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                               focus:outline-none focus:ring-2 focus:ring-sky-400" />
                    </div>

                    <!-- Status -->
                    <div>
                        <label for="package_status" class="block text-sm font-medium text-gray-700">Status</label>
                        <select id="package_status" name="status"
                                class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                                focus:outline-none focus:ring-2 focus:ring-sky-400 bg-white">
                            <option value="ACTIVE" selected>Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label for="package_description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="package_description" name="description" rows="4" maxlength="500"
                              class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-sky-400"></textarea>
                </div>

                <div class="p-3 bg-blue-50 border border-blue-200 rounded-md text-sm text-blue-700">
                    <strong>💡 Lưu ý:</strong> Bạn có thể thêm các dịch vụ chi tiết (services)
                    vào gói này ở màn hình “Chỉnh sửa” sau khi gói đã được tạo.
                </div>

            </div>

            <!-- Footer -->
            <div class="px-6 py-4 bg-gray-50 border-t flex justify-end gap-3">
                <button type="button" data-modal-close="addPackageModal"
                        class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md text-sm hover:bg-gray-300">
                    Cancel
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-sky-600 hover:bg-sky-700 text-white rounded-md text-sm font-medium">
                    Save Package
                </button>
            </div>
        </form>
    </div>
</div>

