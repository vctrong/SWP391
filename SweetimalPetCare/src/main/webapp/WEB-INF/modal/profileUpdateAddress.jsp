<%-- 
    Document   : profileUpdateAddress
    Created on : Oct 8, 2025, 4:01:18 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Modal Thêm địa chỉ -->
<div id="addAddressModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>Thêm địa chỉ mới</h3>
            <button class="modal-close" onclick="closeModal('addAddressModal')">
                <svg width="16" height="16" fill="white" viewBox="0 0 24 24">
                <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                </svg>
            </button>
        </div>

        <div class="modal-body">
            <div class="form-group">
                <label class="form-label">Tên người nhận</label>
                <input type="text" placeholder="Nhập tên người nhận" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <input type="text" placeholder="Nhập số điện thoại" class="form-input">
            </div>

            <div class="form-group">
                <label class="form-label">Tỉnh/Thành phố</label>
                <select class="form-input">
                    <option value="">Chọn tỉnh/thành phố</option>
                    <option value="HCM">TP. Hồ Chí Minh</option>
                    <option value="HN">Hà Nội</option>
                    <option value="DN">Đà Nẵng</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Quận/Huyện</label>
                <select class="form-input">
                    <option value="">Chọn quận/huyện</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Phường/Xã</label>
                <select class="form-input">
                    <option value="">Chọn phường/xã</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ chi tiết</label>
                <textarea placeholder="Nhập số nhà, tên đường..." class="form-input form-textarea"></textarea>
            </div>

            <div class="flex items-center mt-4">
                <input type="checkbox" id="defaultAddress" class="mr-3 w-4 h-4 accent-purple-600">
                <label for="defaultAddress" class="form-label mb-0">Đặt làm địa chỉ mặc định</label>
            </div>
        </div>

        <div class="modal-footer">
            <button onclick="saveAddress()" class="btn-primary">Lưu địa chỉ</button>
            <button onclick="closeModal('addAddressModal')" class="btn-secondary">Hủy</button>
        </div>
    </div>
</div>