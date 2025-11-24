<%-- 
    Document   : DetailOrderModal
    Created on : Nov 25, 2025, 3:56:06 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="orderDetailModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-black bg-opacity-50 transition-opacity backdrop-blur-sm">
    <div class="bg-white rounded-xl shadow-2xl w-11/12 md:w-3/4 lg:w-2/3 max-h-[90vh] flex flex-col overflow-hidden animate-fade-in-down">

        <div class="flex items-center justify-between p-4 border-b bg-gray-50 flex-shrink-0">
            <h4 class="text-lg font-bold text-gray-800 flex items-center gap-2">
                <span class="bg-blue-100 text-blue-600 p-1 rounded">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" /></svg>
                </span>
                Chi tiết đơn hàng
            </h4>
            <button onclick="closeOrderDetailModal()" class="text-gray-400 hover:text-red-500 transition-colors p-2 rounded-full hover:bg-gray-100">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
        </div>

        <div class="p-6 overflow-y-auto flex-1 bg-white space-y-6">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-3 text-sm">
                    <div class="flex justify-between border-b border-gray-100 pb-2"><span class="text-gray-500">Mã đơn hàng:</span><span id="od_code" class="font-mono font-bold text-blue-600 text-base">Loading...</span></div>
                    <div class="flex justify-between border-b border-gray-100 pb-2"><span class="text-gray-500">Ngày đặt:</span><span id="od_created" class="font-medium text-gray-800">...</span></div>
                    <div class="flex justify-between border-b border-gray-100 pb-2"><span class="text-gray-500">Khách hàng:</span><span id="od_customer" class="font-bold text-gray-800">...</span></div>
                    <div class="flex justify-between border-b border-gray-100 pb-2"><span class="text-gray-500">Trạng thái hiện tại:</span><span id="od_current_status_badge" class="font-bold px-2 py-0.5 rounded-full bg-gray-100 text-gray-800">...</span></div>
                </div>
                <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                    <div class="flex items-center gap-2 mb-3 border-b border-gray-200 pb-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-red-500" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                        </svg>
                        <span class="text-xs font-bold text-gray-500 uppercase tracking-wider">ĐỊA CHỈ GIAO HÀNG</span>
                    </div>

                    <div class="pl-6 space-y-2">
                        <span id="od_address" class="text-sm text-gray-800 block font-medium leading-relaxed">
                            ...
                        </span>

                        <div class="flex items-center gap-2 text-sm text-gray-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                            </svg>
                            <span id="od_phone" class="font-mono font-semibold text-blue-600">...</span>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <h5 class="text-sm font-bold text-gray-700 uppercase mb-3 border-l-4 border-blue-600 pl-2">Danh sách sản phẩm</h5>
                <div class="border rounded-lg overflow-hidden shadow-sm">
                    <table class="w-full text-sm text-left">
                        <thead class="bg-gray-100 text-gray-600 font-semibold uppercase text-xs tracking-wider">
                            <tr><th class="px-4 py-3">Sản phẩm</th><th class="px-4 py-3 text-right">Đơn giá</th><th class="px-4 py-3 text-center">SL</th><th class="px-4 py-3 text-right">Thành tiền</th></tr>
                        </thead>
                        <tbody id="od_items" class="divide-y divide-gray-200 bg-white">
                            <tr><td colspan="4" class="text-center py-4 text-gray-400 italic">Đang tải dữ liệu...</td></tr>
                        </tbody>
                        <tfoot class="bg-gray-50 text-gray-800">
                            <tr><td colspan="3" class="px-4 py-3 text-right font-bold text-gray-500">Tổng cộng:</td><td class="px-4 py-3 text-right text-blue-600 text-lg font-bold" id="od_total">0 ₫</td></tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="p-4 bg-gray-50 border-t border-gray-200 flex justify-end items-center gap-3 flex-shrink-0">
            <button onclick="closeOrderDetailModal()" class="px-4 py-2 border border-gray-300 rounded text-gray-700 hover:bg-gray-100 font-medium transition">
                Đóng
            </button>

            <div id="status-actions-container" class="flex gap-2">
            </div>

            <input type="hidden" id="od_hidden_id">
        </div>

    </div>
</div>