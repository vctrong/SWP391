/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


const buttons = document.querySelectorAll(".sidebar-btn");
const tabs = document.querySelectorAll(".tab-content");

buttons.forEach(btn => {
    btn.addEventListener("click", () => {
        buttons.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");

        const target = btn.dataset.tab;
        tabs.forEach(tab => {
            tab.classList.remove("active");
            if (tab.id === target)
                tab.classList.add("active");
        });
    });
});


// Hàm xử lý modal
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    const modalContent = modal.querySelector('.modal');

    modal.classList.add('active');
    setTimeout(() => {
        modalContent.classList.add('active');
    }, 50);

    // Prevent body scroll
    document.body.style.overflow = 'hidden';
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    const modalContent = modal.querySelector('.modal');

    modalContent.classList.remove('active');
    setTimeout(() => {
        modal.classList.remove('active');
        // Restore body scroll
        document.body.style.overflow = 'auto';
    }, 300);
}

// Hàm xử lý các nút tương tác
function updateProfile() {
    openModal('updateProfileModal');
}

function changePassword() {
    openModal('changePasswordModal');
}

function addAddress() {
    openModal('addAddressModal');
}

// Hàm xử lý lưu dữ liệu
function saveProfile() {
    alert('Cập nhật thông tin thành công!');
    closeModal('updateProfileModal');
}

function savePassword() {
    alert('Đổi mật khẩu thành công!');
    closeModal('changePasswordModal');
}

function saveAddress() {
    alert('Thêm địa chỉ thành công!');
    closeModal('addAddressModal');
}

// Đóng modal khi click overlay
document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) {
            const modalId = overlay.id;
            closeModal(modalId);
        }
    });
});

// Đóng modal khi nhấn ESC
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            closeModal(modal.id);
        });
    }
});
