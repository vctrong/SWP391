<%-- 
    Document   : addServiceCate
    Created on : Nov 3, 2025, 8:23:20 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="addCategoryModal" class="hidden fixed inset-0 z-50 overflow-hidden flex justify-end" aria-labelledby="modal-title" role="dialog" aria-modal="true">

    <!-- Overlay -->
    <div data-modal-overlay
         class="overlay fixed inset-0 bg-black bg-opacity-50 transition-opacity duration-300 ease-in-out opacity-0"
         data-modal-close="addCategoryModal"
         aria-hidden="true"></div>

    <!-- Panel -->
    <div class="panel relative bg-white rounded-2xl shadow-2xl w-full max-w-md transform translate-x-full
         transition-transform duration-300 ease-in-out mr-6 my-10 flex flex-col max-h-[90vh]">

        <!-- Header -->
        <div class="flex items-center justify-between px-6 py-4 border-b">
            <h3 class="text-lg font-semibold text-sky-700">📁 Add New Service Category</h3>
            <button type="button" data-modal-close="addCategoryModal" class="text-gray-400 hover:text-gray-600 text-2xl">&times;</button>
        </div>

        <!-- Body -->
        <form action="your-add-category-servlet" method="post" class="flex-1 overflow-y-auto">
            <div class="p-6 space-y-4">

                <!-- Category Name -->
                <div>
                    <label for="category_name" class="block text-sm font-medium text-gray-700">Category Name <span class="text-red-500">*</span></label>
                    <input type="text" id="category_name" name="category_name" required maxlength="100"
                           class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                           focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200" />
                </div>

                <!-- Description -->
                <div>
                    <label for="category_description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="category_description" name="description" rows="4" maxlength="255"
                              class="mt-1 w-full border border-gray-300 rounded-md px-3 py-2 text-sm
                              focus:outline-none focus:ring-2 focus:ring-sky-400 focus:border-transparent transition-all duration-200"></textarea>
                </div>

            </div>

            <!-- Footer -->
            <div class="px-6 py-4 bg-gray-50 border-t flex justify-end gap-3 rounded-b-2xl">
                <button type="button" data-modal-close="addCategoryModal"
                        class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md text-sm hover:bg-gray-300 transition-colors">
                    Cancel
                </button>
                <button type="submit"
                        class="bg-sky-600 hover:bg-sky-700 text-white px-4 py-2 rounded-md text-sm font-medium transition-all duration-200">
                    Save Category
                </button>
            </div>
        </form>
    </div>
</div>


