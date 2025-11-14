/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* * File: filter.js
 * Logic để xử lý việc chuyển đổi nút active và lọc nội dung
 */

// Luôn đợi cho đến khi toàn bộ HTML được tải xong
document.addEventListener('DOMContentLoaded', () => {

    // --- 1. Chọn các phần tử ---
    const filterButtons = document.querySelectorAll('.filter-btn');
    const filterableItems = document.querySelectorAll('#servicesTableBody tr.filter-item');
    const noResultsRow = document.getElementById('filter-no-results');

    // --- 2. Gắn sự kiện click cho các nút filter ---
    filterButtons.forEach(clickedButton => {
        clickedButton.addEventListener('click', () => {

            // --- A. Logic chuyển đổi style nút ---
            filterButtons.forEach(btn => {
                btn.classList.remove('bg-white', 'text-sky-700', 'shadow-sm');
                btn.classList.add('text-gray-600', 'hover:bg-gray-200');
            });
            clickedButton.classList.add('bg-white', 'text-sky-700', 'shadow-sm');
            clickedButton.classList.remove('text-gray-600', 'hover:bg-gray-200');


            // --- B. Logic lọc nội dung ---
            const filterValue = clickedButton.dataset.filter;

            // Biến đếm số mục được hiển thị
            let visibleItemCount = 0;

            // Lặp qua từng MỤC (từng <tr>)
            filterableItems.forEach(item => {
                const itemCategory = item.dataset.category;

                if (filterValue === 'all') {
                    item.classList.remove('hidden');
                    visibleItemCount++;
                } else if (filterValue === itemCategory) {
                    item.classList.remove('hidden');
                    visibleItemCount++;
                } else {
                    item.classList.add('hidden');
                }
            });

            // --- C. Xử lý hiển thị dòng "No results" ---
            // Chỉ chạy logic này nếu danh sách có item (filterableItems.length > 0)
            if (filterableItems.length > 0) {
                if (visibleItemCount === 0) {
                    // Nếu không có mục nào hiển thị, BẬT dòng "No results"
                    noResultsRow.classList.remove('hidden');
                } else {
                    // Nếu có, TẮT dòng "No results"
                    noResultsRow.classList.add('hidden');
                }
            }
        });
    });
});