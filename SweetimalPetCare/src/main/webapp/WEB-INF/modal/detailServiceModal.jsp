<%-- 
    Document   : detailServiceModal
    Created on : Nov 5, 2025, 8:34:13 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="detailServiceModal" class="modal-overlay hidden fixed inset-0 z-50 items-start justify-center bg-black/50 opacity-0 transition-opacity duration-300">
    <div class="modal-container bg-white rounded-lg shadow-xl w-full max-w-md mx-4 mt-20 transform -translate-y-10 transition-all duration-300 opacity-0">
        <div class="flex justify-between items-center p-4 border-b">
            <h3 class="text-lg font-semibold text-gray-800">
                <span id="detail-modal-icon">🔍</span> 
                <span id="detail-modal-title">Chi tiết Dịch vụ</span>
            </h3>
            <button type="button" data-modal-hide="detailServiceModal" class="text-gray-400 hover:text-gray-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
        </div>
        <div class="p-6 min-h-[300px] max-h-[70vh] overflow-y-auto relative">

            <div data-state="loading" class="absolute inset-0 flex flex-col items-center justify-center bg-white z-10 p-6 space-y-6">
                <div class="w-full max-w-md animate-pulse flex space-x-4 opacity-60">
                    <div class="flex-1 space-y-4 py-1">
                        <div class="h-4 bg-gray-200 rounded w-3/4 mx-auto"></div>
                        <div class="space-y-3">
                            <div class="grid grid-cols-3 gap-4">
                                <div class="h-4 bg-gray-200 rounded col-span-2"></div>
                                <div class="h-4 bg-gray-200 rounded col-span-1"></div>
                            </div>
                            <div class="h-4 bg-gray-200 rounded"></div>
                        </div>
                    </div>
                </div>
                <div class="flex items-center space-x-2 text-sky-600 font-medium bg-white px-4 py-2 rounded-full shadow-sm border">
                    <svg class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <span>Đang tải dữ liệu...</span>
                </div>
                <div class="w-full max-w-md animate-pulse flex space-x-4 opacity-30">
                    <div class="flex-1 space-y-4 py-1">
                        <div class="space-y-3">
                            <div class="h-4 bg-gray-200 rounded"></div>
                            <div class="grid grid-cols-3 gap-4">
                                <div class="h-4 bg-gray-200 rounded col-span-1"></div>
                                <div class="h-4 bg-gray-200 rounded col-span-2"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div data-state="error" class="hidden absolute inset-0 flex flex-col items-center justify-center bg-white z-10 space-y-4">
                <div class="text-red-500 bg-red-50 p-4 rounded-full">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </div>
                <h4 class="text-lg font-semibold text-gray-700">Không thể tải thông tin</h4>
                <p class="error-message text-sm text-gray-500 px-6 text-center"></p>
                <button type="button" class="btn-retry px-6 py-2 bg-gray-800 text-white rounded-md hover:bg-black transition">
                    Thử lại
                </button>
            </div>

            <div data-state="content" class="hidden space-y-8">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-4">
                        <div>
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Mã (Code)</label>
                            <div id="d-code" class="text-gray-900 font-medium text-lg break-all"></div>
                        </div>
                        <div>
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Tên (Name)</label>
                            <div class="text-gray-900 font-bold text-xl break-words" id="d-name"></div>
                        </div>
                        <div>
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Trạng thái</label>
                            <div class="mt-1"><span id="d-status" class="px-3 py-1 rounded-full text-sm font-semibold"></span></div>
                        </div>
                        <div id="d-category-block" class="hidden">
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Danh mục</label>
                            <div id="d-category" class="text-gray-900 font-medium mt-1"></div>
                        </div>
                    </div>


                    <div class="space-y-4 bg-gray-50 p-4 rounded-lg border">
                        <div>
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Giá hiện tại</label>
                            <div class="text-sky-600 font-bold text-2xl mt-1">
                                <span id="d-price"></span> <span class="text-sm align-top">VNĐ</span>
                            </div>
                        </div>
                        <div>
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Ngày tạo</label>
                            <div id="d-created" class="text-gray-700 font-medium"></div>
                        </div>
                        <div id="d-duration-block" class="hidden">
                            <label class="text-xs font-bold text-gray-400 uppercase tracking-wider">Thời lượng (Duration)</label>
                            <div class="text-gray-900 font-medium"><i class="fa-regular fa-clock mr-2"></i><span id="d-duration"></span> phút</div>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2 block">Mô tả chi tiết</label>
                    <div id="d-description" class="p-4 bg-gray-50 rounded-lg text-gray-700 text-sm whitespace-pre-line border min-h-[80px]"></div>
                </div>

                <div id="d-package-items-block" class="hidden">
                    <div class="flex items-center justify-between mb-3">
                        <label class="text-sm font-bold text-gray-700 uppercase tracking-wider flex items-center gap-2">
                            <span class="bg-sky-100 text-sky-700 p-1 rounded"><i class="fa-solid fa-box-open"></i></span>
                            Dịch vụ trong gói này
                        </label>
                        <span id="d-item-count" class="text-xs font-medium bg-gray-200 text-gray-700 px-2 py-1 rounded-full">0 items</span>
                    </div>

                    <div class="overflow-hidden border rounded-lg">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-100">
                                <tr>
                                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tên Dịch vụ</th>
                                    <th class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase">Thời lượng</th>
                                    <th class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase w-24">Số lượng</th>
                                </tr>
                            </thead>
                            <tbody id="d-package-items-list" class="divide-y divide-gray-200 bg-white">
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> </div>

        <div class="flex justify-end p-4 border-t bg-gray-50 rounded-b-lg">
            <button type="button" data-modal-hide="detailServiceModal" class="px-4 py-2 bg-gray-200 text-gray-800 rounded hover:bg-gray-300 transition">Đóng</button>
        </div>
    </div>
</div>