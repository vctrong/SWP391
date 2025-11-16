<%-- 
    Document   : ModalChangePass
    Created on : Nov 16, 2025, 12:10:55 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="modal-change-password" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-6 m-4">
        <div class="flex items-center justify-between mb-4">
            <h4 class="text-lg font-semibold text-slate-800">Thay đổi mật khẩu</h4>
            <button type="button" data-modal-close="modal-change-password" class="text-slate-400 hover:text-slate-600">&times;</button>
        </div>

        <form id="form-change-password" 
              action="${pageContext.request.contextPath}/profile"
              data-action="changePassword">

            <div class="space-y-4">
                <div>
                    <label for="pass_old" class="block text-sm font-medium text-slate-700 mb-1">Mật khẩu cũ</label>
                    <input type="password" id="pass_old" name="oldPassword"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div>
                    <label for="pass_new" class="block text-sm font-medium text-slate-700 mb-1">Mật khẩu mới</label>
                    <input type="password" id="pass_new" name="newPassword"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div>
                    <label for="pass_confirm" class="block text-sm font-medium text-slate-700 mb-1">Xác nhận mật khẩu mới</label>
                    <input type="password" id="pass_confirm" name="confirmPassword"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
            </div>

            <div class="mt-6 flex justify-end gap-3">
                <button type="button" data-modal-close="modal-change-password" 
                        class="px-4 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 bg-sky-600 text-white rounded-lg text-sm hover:bg-sky-700">Đổi mật khẩu</button>
            </div>
        </form>
    </div>
</div>