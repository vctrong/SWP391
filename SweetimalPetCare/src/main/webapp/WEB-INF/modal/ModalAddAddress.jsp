<%-- 
    Document   : ModalAddAddress
    Created on : Nov 16, 2025, 12:10:29 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="modal-add-address" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg p-6 m-4">
        <div class="flex items-center justify-between mb-4">
            <h4 class="text-lg font-semibold text-slate-800">Thêm địa chỉ mới</h4>
            <button type="button" data-modal-close="modal-add-address" class="text-slate-400 hover:text-slate-600">&times;</button>
        </div>

        <form id="form-add-address" 
              action="${pageContext.request.contextPath}/profile"
              data-action="addAddress">

            <div class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label for="addr_label" class="block text-sm font-medium text-slate-700 mb-1">Nhãn</label>
                        <input type="text" id="addr_label" name="label" placeholder="Ví dụ: Nhà, Công ty"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                    </div>
                    <div>
                        <label for="addr_recipientName" class="block text-sm font-medium text-slate-700 mb-1">Tên người nhận</label>
                        <input type="text" id="addr_recipientName" name="recipientName" value="${profile.fullName}"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                    </div>
                </div>
                <div>
                    <label for="addr_phone" class="block text-sm font-medium text-slate-700 mb-1">Số điện thoại</label>
                    <input type="tel" id="addr_phone" name="phone" value="${profile.phone}"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div>
                    <label for="addr_addressLine1" class="block text-sm font-medium text-slate-700 mb-1">Địa chỉ chi tiết</label>
                    <input type="text" id="addr_addressLine1" name="addressLine1" placeholder="Số nhà, tên đường..."
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div class="grid grid-cols-3 gap-4">
                    <div>
                        <label for="addr_city" class="block text-sm font-medium text-slate-700 mb-1">Tỉnh/Thành phố</label>
                        <input type="text" id="addr_city" name="city"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                    </div>
                    <div>
                        <label for="addr_district" class="block text-sm font-medium text-slate-700 mb-1">Quận/Huyện</label>
                        <input type="text" id="addr_district" name="district"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                    </div>
                    <div>
                        <label for="addr_ward" class="block text-sm font-medium text-slate-700 mb-1">Phường/Xã</label>
                        <input type="text" id="addr_ward" name="ward"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                    </div>
                </div>
            </div>

            <div class="mt-6 flex justify-end gap-3">
                <button type="button" data-modal-close="modal-add-address" 
                        class="px-4 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 bg-sky-600 text-white rounded-lg text-sm hover:bg-sky-700">Lưu địa chỉ</button>
                        
            </div>
        </form>
    </div>
</div>
