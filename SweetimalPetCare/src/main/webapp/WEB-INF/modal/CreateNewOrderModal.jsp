<%-- 
    Document   : CreateNewOrderModal
    Created on : Nov 24, 2025, 6:53:23 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="createOrderModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black bg-opacity-50">
    <div class="bg-white rounded-lg w-11/12 md:w-3/4 lg:w-2/3 p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between mb-4 border-b pb-2">
            <h4 class="text-xl font-bold text-gray-800">Create New Order</h4>
            <button onclick="document.getElementById('createOrderModal').classList.add('hidden'); document.getElementById('createOrderModal').classList.remove('flex');" class="text-gray-500 hover:text-red-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/order" method="POST" id="createOrderForm" onsubmit="return validateOrderForm(event)">
            <input type="hidden" name="customerId" value="${sessionScope.user.id}"/>
            <input type="hidden" name="shippingAddressId" value="12" />

            <div class="bg-blue-50 p-4 rounded-md border border-blue-100 mb-4">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">
                            Order Code <span class="text-red-500">*</span>
                        </label>
                        <input type="text" name="orderCode" required 
                               class="input-field w-full uppercase font-mono tracking-wider placeholder-gray-400" 
                               placeholder="e.g. ORD-2025-001">
                            <p class="text-xs text-gray-500 mt-1">Leave empty if auto-generated</p>
                    </div>

                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">
                            Payment Method
                        </label>
                        <select name="paymentMethodCode" class="input-field w-full bg-white cursor-pointer">
                            <option value="BANK">Chuyển khoản ngân hàng (Banking)</option>
                            <option value="CASH">Tiền mặt (Tại quầy)</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="mb-6">
                <div class="flex justify-between items-center mb-4 pb-2 border-b border-gray-100">
                    <h3 class="text-sm font-bold text-gray-700 uppercase">Danh sách sản phẩm</h3>
                    <button type="button" onclick="openProductSelectionModal()" 
                            class="flex items-center gap-1 bg-blue-50 text-blue-600 hover:bg-blue-100 px-3 py-1.5 rounded-full text-sm font-medium transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd" />
                        </svg>
                        Thêm sản phẩm
                    </button>
                </div>

                <div class="border border-gray-200 rounded-xl p-4 bg-white shadow-sm">
                    <div class="flex items-center text-xs text-gray-400 font-medium mb-2 px-2">
                        <div class="flex-1 pl-1">TÊN SẢN PHẨM</div>
                        <div class="w-28 text-center">SỐ LƯỢNG</div>
                        <div class="w-8"></div> </div>

                    <div id="product-list-container" class="space-y-3">
                        <div id="empty_row_message" class="text-center text-gray-400 italic py-4 bg-gray-50 rounded-lg border border-dashed border-gray-200">
                            Chưa có SẢN PHẨM nào được chọn. Vui lòng bấm "Thêm sản phẩm".
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Notes</label>
                    <textarea name="notes" rows="3" class="input-field w-full" placeholder="Order notes..."></textarea>
                </div>
                <div class="bg-gray-50 p-4 rounded-md space-y-2">
                    <div class="flex justify-between text-sm"><span id="lbl_subtotal">Subtotal:</span> <span>0 ₫</span></div>
                    <div class="flex justify-between text-sm"><span>Shipping:</span> <input type="number" id="shippingFeeInput" readonly class=" w-20 text-right border rounded" value="0"></div>
                    <div class="flex justify-between font-bold text-lg border-t pt-2 mt-2"><span >Total:</span> <span id="lbl_total" class="text-blue-600">0 ₫</span></div>
                </div>
            </div>

            <div class="mt-6 flex justify-end gap-3">
                <button type="button" onclick="document.getElementById('createOrderModal').classList.add('hidden'); document.getElementById('createOrderModal').classList.remove('flex');" class="px-4 py-2 border rounded-md hover:bg-gray-50">Cancel</button>
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 font-medium">Create Order</button>
            </div>
        </form>
    </div>
</div>


<div id="productSelectionModal" class="fixed inset-0 z-[60] hidden items-center justify-center bg-black bg-opacity-60">
    <div class="bg-white rounded-lg w-11/12 md:w-2/3 lg:w-1/2 flex flex-col max-h-[85vh]">

        <div class="p-4 border-b flex justify-between items-center bg-gray-50 rounded-t-lg">
            <h3 class="font-bold text-lg text-gray-800">Chọn sản phẩm</h3>
            <button onclick="closeProductModal()" class="text-gray-500 hover:text-red-500">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <div class="p-4 border-b bg-white">
            <div class="relative">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </span>
                <input type="text" id="productSearchInput" onkeyup="debounceSearch()" 
                       class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                       placeholder="Tìm theo tên sản phẩm, mã SKU...">
            </div>
        </div>

        <div class="flex-1 overflow-y-auto p-2 bg-gray-50" id="productSearchResults">
            <div class="text-center text-gray-400 mt-10">Nhập từ khóa để tìm kiếm...</div>
        </div>

        <div class="p-3 border-t bg-white text-right rounded-b-lg">
            <button onclick="closeProductModal()" class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded text-gray-700 font-medium">Đóng</button>
        </div>
    </div>
</div>
