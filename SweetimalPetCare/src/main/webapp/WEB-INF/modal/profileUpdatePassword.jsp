<%-- 
    Document   : profileUpdatePassword
    Created on : Oct 8, 2025, 4:02:09 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Modal Thay đổi mật khẩu -->
<div id="changePasswordModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>Thay đổi mật khẩu</h3>
            <button class="modal-close" onclick="closeModal('changePasswordModal')">
                <svg width="16" height="16" fill="white" viewBox="0 0 24 24">
                <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                </svg>
            </button>
        </div>

        <div class="modal-body">
            <div class="form-group">
                <label class="form-label">Mật khẩu hiện tại</label>
                <input type="password" placeholder="Nhập mật khẩu hiện tại" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Mật khẩu mới</label>
                <input type="password" placeholder="Nhập mật khẩu mới" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Xác nhận mật khẩu mới</label>
                <input type="password" placeholder="Nhập lại mật khẩu mới" class="form-input">
            </div>

            <div class="alert-warning">
                <p><strong>Lưu ý:</strong> Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.</p>
            </div>
        </div>

        <div class="modal-footer">
            <button onclick="savePassword()" class="btn-primary">Đổi mật khẩu</button>
            <button onclick="closeModal('changePasswordModal')" class="btn-secondary">Hủy</button>
        </div>
    </div>
</div>
