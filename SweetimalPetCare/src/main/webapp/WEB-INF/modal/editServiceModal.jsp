<%-- 
    Document   : editServiceModal
    Created on : Nov 5, 2025, 8:34:03 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="editModal" class="modal-overlay hidden fixed inset-0 z-50 flex items-center justify-center bg-gray-900/70 backdrop-blur-sm transition-all duration-300 opacity-0">

    <div class="modal-container bg-white rounded-2xl shadow-2xl w-full max-w-3xl mx-4 transform scale-95 transition-all duration-300 opacity-0 overflow-hidden max-h-[90vh] flex flex-col border border-gray-300">

        <div class="flex justify-between items-center px-6 py-5 border-b border-gray-300 shrink-0">
            <div>
                <h3 class="text-xl font-bold text-gray-800 flex items-center gap-3">
                    <span id="edit-modal-icon" class="p-2 bg-amber-100 rounded-lg text-lg">✏️</span>
                    <span id="edit-modal-title">Chỉnh sửa</span>
                </h3>
            </div>
            <button type="button" data-modal-hide="editModal" class="text-gray-500 hover:text-gray-700 hover:bg-gray-100 rounded-full p-2 transition-all">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>

        <div class="p-6 overflow-y-auto flex-grow relative min-h-[350px] scroll-smooth">

            <div data-state="loading" class="absolute inset-0 flex flex-col items-center justify-center bg-white/80 z-10 space-y-4">
                <div class="flex flex-col items-center space-y-3">
                    <svg class="animate-spin h-10 w-10 text-amber-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <span class="text-gray-500 font-medium">Đang tải dữ liệu...</span>
                </div>
            </div>

            <div data-state="error" class="hidden absolute inset-0 flex flex-col items-center justify-center bg-white z-10 space-y-4">
                <div class="text-red-500 bg-red-50 p-4 rounded-full mb-2 border border-red-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <h4 class="text-lg font-semibold text-gray-800">Không thể tải dữ liệu</h4>
                <p class="error-message text-sm text-gray-500 px-6 text-center max-w-md"></p>
                <button type="button" class="btn-retry px-6 py-2.5 bg-gray-900 text-white font-medium rounded-lg hover:bg-black transition-transform active:scale-95">Thử lại</button>
            </div>

            <div data-state="content" class="hidden">
                <form id="editForm" action="${pageContext.request.contextPath}/api/ServiceEditAPI" method="POST" class="space-y-8">
                    <input type="hidden" name="id" id="edit-id">
                        <input type="hidden" name="type" id="edit-type">

                            <div class="space-y-5">
                                <div class="flex items-center gap-4">
                                    <h4 class="text-sm font-bold text-gray-900 uppercase tracking-wider">Thông tin chung</h4>
                                    <div class="h-px bg-gray-300 flex-grow"></div> 
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Mã dịch vụ</label>
                                        <div class="relative">
                                            <input type="text" id="edit-code" name="code" readonly 
                                                   class="w-full bg-gray-100 border border-gray-300 rounded-xl px-4 py-2.5 text-gray-500 font-medium cursor-not-allowed focus:ring-0">
                                                <div class="absolute inset-y-0 right-3 flex items-center">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                                                    </svg>
                                                </div>
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Trạng thái</label>
                                        <select id="edit-status" name="status" class="w-full bg-white border border-gray-300 rounded-xl px-4 py-2.5 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all font-medium">
                                            <option value="ACTIVE">Hoạt động</option>
                                            <option value="INACTIVE">Ngừng hoạt động</option>
                                        </select>
                                    </div>

                                    <div class="md:col-span-2">
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                                            Tên dịch vụ <span class="text-red-500">*</span>
                                        </label>
                                        <input type="text" id="edit-name" name="name" required 
                                               placeholder="Nhập tên dịch vụ..."
                                               class="w-full border border-gray-300 rounded-xl px-4 py-2.5 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all shadow-sm">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">
                                            Giá niêm yết <span class="text-red-500">*</span>
                                        </label>
                                        <div class="relative">
                                            <input type="number" id="edit-price" name="price" required min="0" step="1000" 
                                                   class="w-full border border-gray-300 rounded-xl pl-4 pr-12 py-2.5 font-bold text-gray-800 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all shadow-sm"
                                                   placeholder="0">
                                                <div class="absolute inset-y-0 right-0 flex items-center pr-4 pointer-events-none">
                                                    <span class="text-gray-500 font-medium bg-gray-100 px-2 py-1 rounded text-xs border border-gray-300">VNĐ</span>
                                                </div>
                                        </div>
                                    </div>

                                    <div id="edit-duration-block">
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Thời lượng (phút)</label>
                                        <div class="relative">
                                            <input type="number" id="edit-duration" name="duration" min="0" 
                                                   class="w-full border border-gray-300 rounded-xl px-4 py-2.5 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all shadow-sm"
                                                   placeholder="Ví dụ: 60">
                                                <div class="absolute inset-y-0 right-3 flex items-center pointer-events-none">
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                    </svg>
                                                </div>
                                        </div>
                                    </div>

                                    <div id="edit-category-block" class="md:col-span-2">
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Danh mục dịch vụ</label>
                                        <select id="edit-category" name="categoryId" class="w-full border border-gray-300 rounded-xl px-4 py-2.5 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all shadow-sm">
                                            <c:forEach items="${listCate}" var="cate">
                                                <option value="${cate.serviceCategoryId}">${cate.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="md:col-span-2">
                                        <label class="block text-sm font-medium text-gray-700 mb-1.5">Mô tả chi tiết</label>
                                        <textarea id="edit-description" name="description" rows="3" 
                                                  placeholder="Nhập thông tin thêm về dịch vụ này..."
                                                  class="w-full border border-gray-300 rounded-xl px-4 py-2.5 focus:border-amber-500 focus:ring-2 focus:ring-amber-200 transition-all shadow-sm resize-none"></textarea>
                                    </div>
                                </div>
                            </div>

                            <div id="edit-package-items-block" class="hidden space-y-5 pt-2">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-4 flex-grow">
                                        <h4 class="text-sm font-bold text-gray-900 uppercase tracking-wider">Dịch vụ trong gói</h4>
                                        <div class="h-px bg-gray-300 flex-grow"></div>
                                    </div>
                                    <button type="button" id="btn-add-package-item" 
                                            class="ml-4 flex items-center gap-2 px-3 py-1.5 bg-sky-50 text-sky-600 text-sm font-medium rounded-full hover:bg-sky-100 hover:text-sky-700 transition-colors focus:outline-none focus:ring-2 focus:ring-sky-200 border border-sky-200">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd" />
                                        </svg>
                                        Thêm dịch vụ
                                    </button>
                                </div>

                                <div class="bg-gray-50 rounded-2xl p-4 border border-gray-300">
                                    <div class="grid grid-cols-12 gap-3 px-4 mb-2 text-xs font-medium text-gray-600 uppercase">
                                        <div class="col-span-8 md:col-span-9">Tên dịch vụ</div>
                                        <div class="col-span-3 md:col-span-2 text-center">Số lượng</div>
                                        <div class="col-span-1"></div>
                                    </div>

                                    <div id="edit-package-items-list" class="space-y-2 border-t border-gray-200 pt-2">
                                    </div>

                                    <div id="edit-package-empty" class="hidden py-8 flex flex-col items-center justify-center text-gray-400 border-2 border-dashed border-gray-300 rounded-xl bg-white mt-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 mb-2 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                                        </svg>
                                        <p class="text-sm">Gói này chưa có dịch vụ nào</p>
                                    </div>
                                </div>

                                <template id="package-item-template">
                                    <div class="package-item-row grid grid-cols-12 gap-3 items-center bg-white p-2 rounded-xl border border-gray-300 shadow-sm hover:border-amber-400 transition-colors">
                                        <div class="col-span-8 md:col-span-9">
                                            <select name="packageItemServiceId[]" class="item-service-select w-full border-0 bg-transparent py-2 pl-2 pr-8 text-gray-900 font-medium focus:ring-0 sm:text-sm">
                                                <option value="">-- Chọn dịch vụ --</option>
                                                <c:forEach items="${listSeriviceForListPackage}" var="s">
                                                    <option value="${s.id}">${s.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-span-3 md:col-span-2">
                                            <input type="number" name="packageItemQuantity[]" value="1" min="1" 
                                                   class="item-quantity-input w-full text-center bg-gray-50 border border-gray-300 rounded-lg py-1.5 text-gray-800 font-bold focus:ring-2 focus:ring-amber-500 sm:text-sm">
                                        </div>
                                        <div class="col-span-1 flex justify-end">
                                            <button type="button" class="btn-remove-item p-2 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded-full transition-all">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </div>
                                    </div>
                                </template>

                            </div> </form>
                            </div>
                            </div>

                            <div class="flex justify-end gap-3 px-6 py-4 bg-white border-t border-gray-300 shrink-0">
                                <button type="button" data-modal-hide="editModal" 
                                        class="px-5 py-2.5 text-gray-700 font-medium rounded-xl border border-gray-400 hover:bg-gray-100 hover:border-gray-500 transition-all focus:ring-2 focus:ring-gray-300">
                                    Hủy bỏ
                                </button>
                                <button type="submit" form="editForm" 
                                        class="px-6 py-2.5 bg-gradient-to-r from-amber-500 to-orange-500 text-white font-bold rounded-xl hover:from-amber-600 hover:to-orange-600 transition-all shadow-md hover:shadow-lg active:scale-95 flex items-center gap-2">
                                    <span id="btn-save-text">Lưu thay đổi</span>
                                    <svg id="btn-save-loading" class="hidden animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                </button>
                            </div>

                            </div>
                            </div>
