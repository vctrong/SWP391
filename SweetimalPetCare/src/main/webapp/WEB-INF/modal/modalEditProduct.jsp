<%-- 
    Document   : modalEditProduct
    Created on : Nov 16, 2025, 1:13:14 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="editModal" class="hidden fixed inset-0 z-50 overflow-y-auto">
    <div id="editModalBackdrop" class="fixed inset-0 bg-black/50 transition-opacity"></div>

    <div class="relative flex min-h-full items-center justify-center p-4">

        <div id="editModalContainer" class="relative bg-white rounded-lg shadow-xl w-full max-w-4xl transition-all transform scale-95 opacity-0">

            <%-- Đây là FORM. Chúng ta sẽ submit nó bằng AJAX --%>
            <form id="editProductForm">

                <div class="flex items-center justify-between p-4 border-b">
                    <h3 class="text-xl font-semibold text-gray-900">
                        Edit Product
                    </h3>
                    <button type="button" id="closeEditModalBtn" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 flex items-center justify-center">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <%-- 
                  Body (Scrolling) 
                  'max-h-[80vh]' cho phép body cuộn nếu nội dung quá dài
                --%>
                <div class="p-6 space-y-6 max-h-[80vh] overflow-y-auto">

                    <%-- Input ẩn để lưu ID sản phẩm --%>
                    <input type="hidden" id="editProductId" name="productId">

                    <h4 class="text-lg font-semibold text-gray-800">Main Details</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label for="editProductName" class="form-label">Product Name</label>
                            <input type="text" id="editProductName" name="productName" class="input-field" required>
                        </div>
                        <div>
                            <label for="editProductCode" class="form-label">Product Code</label>
                            <input type="text" id="editProductCode" name="productCode" class="input-field" required>
                        </div>
                        <div>
                            <label for="editProductCategory" class="form-label">Category</label>
                            <select id="editProductCategory" name="categoryId" class="input-field">
                                <%-- JS sẽ tải Categories vào đây --%>
                            </select>
                        </div>
                        <div>
                            <label for="editProductBrand" class="form-label">Brand</label>
                            <select id="editProductBrand" name="brandId" class="input-field">
                                <%-- JS sẽ tải Brands vào đây --%>
                            </select>
                        </div>
                        <div class="md:col-span-2">
                            <label for="editProductDescription" class="form-label">Description</label>
                            <textarea id="editProductDescription" name="description" rows="4" class="input-field"></textarea>
                        </div>
                        <div>
                            <label for="editProductStatus" class="form-label">Status</label>
                            <select id="editProductStatus" name="isActive" class="input-field">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                        </div>
                    </div>

                    <h4 class="text-lg font-semibold text-gray-800 pt-4">Variants</h4>

                    <%-- 
                      Nơi JS "vẽ" các form con của Variant.
                      Mỗi variant sẽ là một "card" có thể sửa.
                    --%>
                    <div id="variantsContainer" class="space-y-3">
                        <%-- JS SẼ ĐIỀN VÀO ĐÂY --%>
                        <%-- Mẫu 1 card Variant (để bạn hình dung):
                        <div class="variant-form-row p-3 border rounded-lg space-y-2">
                             <input type="hidden" name="variantId" value="123">
                             <div class="grid grid-cols-1 md:grid-cols-4 gap-2">
                                 <input name="sku" placeholder="SKU" class="input-field-sm">
                                 <input name="attributes" placeholder="{"size":"L"}" class="input-field-sm">
                                 <input name="price" type="number" placeholder="Price" class="input-field-sm">
                                 <input name="stock" type="number" placeholder="Stock" class="input-field-sm">
                             </div>
                        </div>
                        --%>
                    </div>

                    <%-- 
                      NÚT ADD VARIANT (Style "XỊN" VÀ "HIỆN ĐẠI")
                      Dùng border đứt khúc (dashed)
                    --%>
                    <button type="button" id="addVariantBtn" 
                            class="w-full mt-4 p-3 border-2 border-dashed border-blue-400 text-blue-500 rounded-lg flex items-center justify-center gap-2 hover:bg-blue-50 transition">
                        <i class="fas fa-plus"></i>
                        Add New Variant
                    </button>

                </div>

                <div class="flex items-center justify-end gap-3 p-4 border-t border-gray-200 rounded-b">
                    <button type="button" id="footerCancelEditBtn" 
                            class="text-gray-500 bg-white hover:bg-gray-100 border border-gray-200 text-sm font-medium px-5 py-2.5 rounded-lg">
                        Cancel
                    </button>
                    <button type="submit" id="saveProductBtn"
                            class="text-white bg-blue-600 hover:bg-blue-700 text-sm font-medium px-5 py-2.5 rounded-lg">
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
