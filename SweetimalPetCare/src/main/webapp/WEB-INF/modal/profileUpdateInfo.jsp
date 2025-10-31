<%-- 
    Document   : profileUpdateInfo
    Created on : Oct 8, 2025, 3:59:59 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Modal Cập nhật thông tin -->

<div id="updateProfileModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>Cập nhật thông tin cá nhân</h3>
            <button class="modal-close" onclick="closeModal('updateProfileModal')">
                <svg width="16" height="16" fill="white" viewBox="0 0 24 24">
                <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                </svg>
            </button>
        </div>

        <div class="modal-body">
            <div class="form-group">
                <label class="form-label">Họ và tên</label>
                <input type="text" value="Võ Chí Trọng" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <input type="text" value="0336922235" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Email</label>
                <input type="email" value="vctrong665@gmail.com" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Ngày sinh</label>
                <input type="date" value="2005-10-06" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Giới tính</label>
                <select class="form-input">
                    <option value="Nam" selected>Nam</option>
                    <option value="Nữ">Nữ</option>
                    <option value="Khác">Khác</option>
                </select>
            </div>
        </div>

        <div class="modal-footer">
            <button onclick="saveProfile()" class="btn-primary">Lưu thay đổi</button>
            <button onclick="closeModal('updateProfileModal')" class="btn-secondary">Hủy</button>
        </div>
    </div>
</div>
