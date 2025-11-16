<%-- 
    Document   : modalAddProduct
    Created on : Nov 16, 2025, 2:20:42 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="addModal" class="hidden fixed inset-0 z-50 overflow-y-auto">
    <div id="addModalBackdrop" class="fixed inset-0 bg-black/50 transition-opacity"></div>

    <div class="relative flex min-h-full items-center justify-center p-4">

        <div id="addModalContainer" class="relative bg-white rounded-lg shadow-xl w-full max-w-4xl transition-all transform scale-95 opacity-0">

            <%-- 
              Form này sẽ được submit bằng JavaScript
              Chúng ta không đặt enctype ở đây vì JS sẽ dùng FormData
            --%>
            <form id="addProductForm">

                <div class="flex items-center justify-between p-4 border-b">
                    <h3 class="text-xl font-semibold text-gray-900">
                        Add New Product
                    </h3>
                    <button type="button" id="closeAddModalBtn" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 flex items-center justify-center">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="p-6 space-y-6 max-h-[80vh] overflow-y-auto">

                    <h4 class="text-lg font-semibold text-gray-800">Main Details</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label for="addProductName" class="form-label">Product Name</label>
                            <input type="text" id="addProductName" name="productName" class="input-field" required>
                        </div>
                        <div>
                            <label for="addProductCode" class="form-label">Product Code</label>
                            <input type="text" id="addProductCode" name="productCode" class="input-field" required>
                        </div>
                        <div>
                            <label for="addProductCategory" class="form-label">Category</label>
                            <select id="addProductCategory" name="categoryId" class="input-field">
                                <%-- JS sẽ tải Categories (từ APP_DATA) vào đây --%>
                            </select>
                        </div>
                        <div>
                            <label for="addProductBrand" class="form-label">Brand</label>
                            <select id="addProductBrand" name="brandId" class="input-field">
                                <%-- JS sẽ tải Brands (từ APP_DATA) vào đây --%>
                            </select>
                        </div>
                        <div class="md:col-span-2">
                            <label for="addProductDescription" class="form-label">Description</label>
                            <textarea id="addProductDescription" name="description" rows="4" class="input-field"></textarea>
                        </div>
                    </div>

                    <h4 class="text-lg font-semibold text-gray-800 pt-4">Product Images</h4>
                    <div id="imageUploadContainer" class="p-4 border-2 border-dashed rounded-lg text-center">
                        <input type="file" id="addProductImages" name="images" multiple 
                               class="hidden" accept="image/png, image/jpeg, image/webp">

                        <%-- Nút "chọn file" giả (để làm đẹp) --%>
                        <label for="addProductImages" 
                               class="cursor-pointer text-blue-500 hover:text-blue-700 font-medium">
                            <i class="fas fa-upload mr-2"></i>
                            Choose images to upload
                        </label>
                        <p class="text-xs text-gray-500 mt-1">PNG, JPG, WEBP. (Tối đa 5 ảnh)</p>

                        <%-- Vùng xem trước (Preview) "hiện đại" --%>
                        <div id="imagePreviewContainer" class="mt-4 grid grid-cols-3 sm:grid-cols-5 gap-3">
                            <%-- JS sẽ "vẽ" ảnh preview vào đây --%>
                        </div>
                    </div>


                    <h4 class="text-lg font-semibold text-gray-800 pt-4">Variants</h4>
                    <div id="addVariantsContainer" class="space-y-3">
                        <%-- JS sẽ "vẽ" các form con của Variant vào đây --%>
                        <%-- Sẽ có ít nhất 1 hàng được tạo tự động --%>
                    </div>

                    <%-- Nút ADD VARIANT (Style "XỊN" VÀ "HIỆN ĐẠI") --%>
                    <button type="button" id="addNewVariantBtn" 
                            class="w-full mt-4 p-3 border-2 border-dashed border-blue-400 text-blue-500 rounded-lg flex items-center justify-center gap-2 hover:bg-blue-50 transition">
                        <i class="fas fa-plus"></i>
                        Add Another Variant
                    </button>

                </div>

                <div class="flex items-center justify-end gap-3 p-4 border-t border-gray-200 rounded-b">
                    <button type="button" id="footerCancelAddBtn" 
                            class="text-gray-500 bg-white hover:bg-gray-100 border border-gray-200 text-sm font-medium px-5 py-2.5 rounded-lg">
                        Cancel
                    </button>
                    <button type="submit" id="saveAddProductBtn"
                            class="text-white bg-blue-600 hover:bg-blue-700 text-sm font-medium px-5 py-2.5 rounded-lg">
                        Save Product
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>