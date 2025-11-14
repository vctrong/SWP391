/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


function openModal(modalId) {
    const modal = document.getElementById(modalId);
    const container = modal.querySelector('.modal-container');

    if (!modal || !container)
        return;

    // 1. Hiển thị lớp phủ (overlay) trước nhưng vẫn để opacity = 0
    modal.classList.remove('hidden');
    modal.classList.add('flex'); // Để dùng flexbox căn giữa

    // 2. Kích hoạt hiệu ứng sau một khoảng thời gian cực ngắn (để browser kịp render)
    setTimeout(() => {
        modal.classList.remove('opacity-0'); // Hiển thị dần overlay
        container.classList.remove('-translate-y-10', 'opacity-0'); // Trượt xuống và hiện rõ container
        container.classList.add('translate-y-0', 'opacity-100');
    }, 10);
}

// Hàm đóng modal với hiệu ứng ngược lại
function closeModal(modal) {
    const container = modal.querySelector('.modal-container');
    if (!container)
        return;

    // 1. Bắt đầu hiệu ứng ẩn đi
    modal.classList.add('opacity-0');
    container.classList.add('-translate-y-10', 'opacity-0');
    container.classList.remove('translate-y-0', 'opacity-100');

    // 2. Đợi hiệu ứng chạy xong (300ms khớp với duration-300 trong CSS) mới ẩn hẳn khỏi DOM
    setTimeout(() => {
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }, 300);
}


document.addEventListener('DOMContentLoaded', () => {
    // Nút mở Detail
    document.querySelectorAll('.btn-view-detail-ajax').forEach(btn => {
        btn.addEventListener('click', () => openModal('detailServiceModal'));
    });

    // Nút mở Edit
    document.querySelectorAll('.btn-edit-ajax').forEach(btn => {
        btn.addEventListener('click', () => openModal('editServiceModal'));
    });

    // Nút đóng modal (dấu X hoặc nút Hủy)
    document.querySelectorAll('[data-modal-hide]').forEach(btn => {
        btn.addEventListener('click', function () {
            const modalId = this.getAttribute('data-modal-hide');
            const modal = document.getElementById(modalId);
            if (modal)
                closeModal(modal);
        });
    });

    // Đóng khi click ra ngoài container (vào vùng tối)
    document.querySelectorAll('.modal-overlay').forEach(modal => {
        modal.addEventListener('click', function (e) {
            if (e.target === this)
                closeModal(this);
        });
    });

    // Đóng khi nhấn phím ESC
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.flex').forEach(modal => closeModal(modal));
        }
    });
});