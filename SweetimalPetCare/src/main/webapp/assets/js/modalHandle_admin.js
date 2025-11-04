/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function () {

    // --- 1. LOGIC CHO DROPDOWN ---
    const menuButton = document.getElementById('addMenuBtn');
    const dropdownMenu = document.getElementById('addMenuDropdown');

    if (menuButton && dropdownMenu) {
        // Mở/đóng menu khi nhấn nút
        menuButton.addEventListener('click', function (event) {
            event.stopPropagation();
            dropdownMenu.classList.toggle('hidden');
        });

        // Đóng menu khi click ra ngoài
        window.addEventListener('click', function (event) {
            if (!dropdownMenu.classList.contains('hidden') && !menuButton.contains(event.target)) {
                dropdownMenu.classList.add('hidden');
            }
        });
    }

    // --- 2. LOGIC CHUNG CHO CÁC MODAL (TRƯỢT TỪ BÊN PHẢI) ---

    // Hàm Mở Modal
    function openModal(modalId) {
        const modal = document.getElementById(modalId);
        if (!modal)
            return;

        const overlay = modal.querySelector('[data-modal-overlay]');
        const panel = modal.querySelector('.panel'); // Lấy panel bằng class

        // 1. Hiển thị modal (bỏ 'hidden')
        modal.classList.remove('hidden');

        // 2. Chờ một frame để trình duyệt nhận diện thay đổi
        //    Sau đó mới chạy animation
        requestAnimationFrame(() => {
            overlay.classList.remove('opacity-0');
            overlay.classList.add('opacity-100'); // Thêm class để chắc chắn
            panel.classList.remove('translate-x-full');
            panel.classList.add('translate-x-0'); // Thêm class để chắc chắn
        });

        // Đóng dropdown lại
        if (dropdownMenu) {
            dropdownMenu.classList.add('hidden');
        }
    }

    // Hàm Đóng Modal
    function closeModal(modalId) {
        const modal = document.getElementById(modalId);
        if (!modal)
            return;

        const overlay = modal.querySelector('[data-modal-overlay]');
        const panel = modal.querySelector('.panel');

        // 1. Chạy animation đóng
        overlay.classList.add('opacity-0');
        overlay.classList.remove('opacity-100');
        panel.classList.add('translate-x-full');
        panel.classList.remove('translate-x-0');


        // 2. Chờ animation chạy xong (300ms) rồi mới ẩn modal đi
        setTimeout(() => {
            modal.classList.add('hidden');
        }, 300); // 300ms này phải khớp với 'duration-300' của Tailwind
    }

    // Gán sự kiện click cho các nút MỞ modal (trong dropdown)
    document.querySelectorAll('[data-modal-target]').forEach(button => {
        button.addEventListener('click', function () {
            const modalId = this.getAttribute('data-modal-target');
            openModal(modalId);
        });
    });

    // Gán sự kiện click cho các nút ĐÓNG modal (dấu X, nút Cancel, nền mờ)
    document.querySelectorAll('[data-modal-close]').forEach(button => {
        button.addEventListener('click', function () {
            const modalId = this.getAttribute('data-modal-close');
            closeModal(modalId);
        });
    });

});