/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/*
 * NỘI DUNG FILE profile.js
 * Xử lý hiện/ẩn modal và gửi AJAX cho 3 form
 */
document.addEventListener("DOMContentLoaded", () => {

    // ===================================
    // 1. XỬ LÝ HIỆN/ẨN MODAL
    // ===================================

    // Lấy tất cả các nút bấm mở modal
    const modalTriggers = document.querySelectorAll("[data-modal-target]");

    // Lấy tất cả các nút bấm đóng modal (nút 'x' và nút 'Hủy')
    const modalCloses = document.querySelectorAll("[data-modal-close]");

    // Gán sự kiện click cho các nút mở modal
    modalTriggers.forEach(button => {
        button.addEventListener("click", () => {
            const modalId = button.getAttribute("data-modal-target");
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove("hidden");
            }
        });
    });

    // Gán sự kiện click cho các nút đóng modal
    modalCloses.forEach(button => {
        button.addEventListener("click", () => {
            const modalId = button.getAttribute("data-modal-close");
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add("hidden");
            }
        });
    });

    // Đóng modal khi click ra ngoài khu vực modal
    document.querySelectorAll(".fixed.inset-0").forEach(modalBackdrop => {
        modalBackdrop.addEventListener("click", (e) => {
            // Chỉ đóng nếu click vào backdrop (chính nó), không phải con (panel)
            if (e.target === modalBackdrop) {
                modalBackdrop.classList.add("hidden");
            }
        });
    });

    // ===================================
    // 2. XỬ LÝ GỬI FORM (AJAX)
    // ===================================

    // Hàm chung để xử lý gửi AJAX
    const handleAjaxFormSubmit = async (form, formData) => {
        const action = form.getAttribute("action");
        const method = "POST";

        // Thêm 'action' vào formData để Servlet biết làm gì
        formData.append("action", form.dataset.action);

        try {
            const response = await fetch(action, {
                method: method,
                body: formData,
                credentials: "same-origin" // <-- THÊM DÒNG NÀY VÀO ĐÂY
            });

            const result = await response.json();

            // Thông báo kết quả
            alert(result.message);

            if (result.success) {
                // Tải lại trang để xem thay đổi
                location.reload();
            }

        } catch (error) {
            console.error("Lỗi khi gửi form:", error);
            alert("Đã xảy ra lỗi, không thể gửi yêu cầu.");
        }
    };

    // --- Xử lý Form 1: Cập nhật Profile ---
    const formUpdateProfile = document.getElementById("form-update-profile");
    if (formUpdateProfile) {
        formUpdateProfile.addEventListener("submit", (e) => {
            e.preventDefault();
            const formData = new FormData(formUpdateProfile);

            // **Xử lý đặc biệt cho ngày sinh**
            // Input date trả về 'yyyy-MM-dd', cần đổi sang 'dd/MM/yyyy' cho Servlet
            const isoDate = formData.get("birthday_iso"); // Lấy từ 'yyyy-MM-dd'
            if (isoDate) {
                const parts = isoDate.split('-'); // [yyyy, MM, dd]
                const formattedDate = `${parts[2]}/${parts[1]}/${parts[0]}`; // dd/MM/yyyy
                formData.set("birthday", formattedDate); // Set lại trường 'birthday'
            }
            formData.delete("birthday_iso"); // Xóa trường tạm

            handleAjaxFormSubmit(formUpdateProfile, formData);
        });
    }

    // --- Xử lý Form 2: Thêm Địa chỉ ---
    const formAddAddress = document.getElementById("form-add-address");
    if (formAddAddress) {
        formAddAddress.addEventListener("submit", (e) => {
            e.preventDefault();
            const formData = new FormData(formAddAddress);
            handleAjaxFormSubmit(formAddAddress, formData);
        });
    }

    // --- Xử lý Form 3: Đổi Mật khẩu ---
    const formChangePassword = document.getElementById("form-change-password");
    if (formChangePassword) {
        formChangePassword.addEventListener("submit", (e) => {
            e.preventDefault();
            const formData = new FormData(formChangePassword);

            // (Tùy chọn: Validate phía client)
            const newPass = formData.get("newPassword");
            const confirmPass = formData.get("confirmPassword");

            if (newPass.length < 6) {
                alert("Mật khẩu mới phải từ 6 ký tự.");
                return;
            }
            if (newPass !== confirmPass) {
                alert("Mật khẩu xác nhận không khớp.");
                return;
            }

            handleAjaxFormSubmit(formChangePassword, formData);
        });
    }
});