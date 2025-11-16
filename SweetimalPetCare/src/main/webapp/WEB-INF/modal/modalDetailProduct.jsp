<%-- 
    Document   : modalDetailProduct
    Created on : Nov 15, 2025, 11:48:20 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="detailModal" class="hidden fixed inset-0 z-50 overflow-y-auto">
    <div id="modalBackdrop" class="fixed inset-0 bg-black/50 transition-opacity"></div>

    <div class="relative flex min-h-full items-center justify-center p-4">

        <div id="modalContainer" class="relative bg-white rounded-lg shadow-xl w-full max-w-4xl transition-all transform scale-95 opacity-0">
            <div class="flex items-center justify-between p-4 border-b">
                <h3 class="text-xl font-semibold text-gray-900">
                    Product Details
                </h3>
                <button type="button" id="closeModalBtn" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 flex items-center justify-center">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <div class="p-6 space-y-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <div class="space-y-4">
                        <div id="modalMainImage" class="aspect-square bg-gray-100 rounded-lg flex items-center justify-center">
                        </div>
                        <div id="modalThumbnails" class="grid grid-cols-5 gap-2">
                        </div>
                    </div>

                    <div class="space-y-4">
                        <div class="flex justify-between items-start">
                            <h2 id="modalProductName" class="text-3xl font-bold text-gray-900">
                            </h2>
                            <span id="modalStatus" class="px-2 py-1 text-xs font-semibold rounded-full">
                            </span>
                        </div>

                        <div class="grid grid-cols-2 gap-2 text-sm text-gray-600">
                            <div><strong>Brand:</strong> <span id="modalBrandName"></span></div>
                            <div><strong>Category:</strong> <span id="modalCategoryName"></span></div>
                            <div><strong>Product Code:</strong> <span id="modalProductCode"></span></div>
                        </div>

                        <div>
                            <h4 class="font-semibold mb-1">Description</h4>
                            <div id="modalDescription" class="text-sm text-gray-700 max-h-32 overflow-y-auto prose">
                            </div>
                        </div>

                        <div class="pt-4">
                            <h4 class="font-semibold mb-2">Available Variants</h4>
                            <div class="overflow-x-auto border rounded-lg max-h-64">
                                <table class="w-full text-sm">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-3 py-2 text-left">SKU</th>
                                            <th class="px-3 py-2 text-left">Attributes</th>
                                            <th class="px-3 py-2 text-right">Price</th>
                                            <th class="px-3 py-2 text-center">Stock</th>
                                        </tr>
                                    </thead>
                                    <tbody id="modalVariantsTableBody" class="divide-y">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="flex items-center justify-end p-4 border-t border-gray-200 rounded-b">
                <button type="button" id="footerCloseBtn" 
                        class="text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10">
                    Close
                </button>
            </div>
        </div>
    </div>
</div>
