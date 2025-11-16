/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global url */

document.addEventListener('DOMContentLoaded', () => {

    // --- 1. Chọn các phần tử DOM ---
    const searchInput = document.getElementById('serviceSearch');
    const tableBody = document.getElementById('servicesTableBody');
    const filterButtons = document.querySelectorAll('.filter-btn');

    // Biến để lưu trạng thái filter và search
    let currentFilter = 'all'; // Giá trị filter mặc định
    let currentSearchTerm = ''; // Giá trị search mặc định

    // Đã có sẵn từ JSP: const url = '${pageContext.request.contextPath}';
    if (typeof url === 'undefined') {
        console.error('Biến "url" (contextPath) chưa được định nghĩa!');
        return;
    }

    // --- 2. Hàm Debounce ---
    // Ngăn việc gọi API liên tục mỗi khi gõ phím
    function debounce(func, delay) {
        let timeoutId;
        return (...args) => {
            clearTimeout(timeoutId);
            timeoutId = setTimeout(() => {
                func.apply(this, args);
            }, delay);
        };
    }

    // --- 3. Hàm Fetch và Render chính ---
    async function fetchAndRender() {
        // Cả hai giá trị (search & filter) đều được gửi lên server
        const searchUrl = `${url}/admin/searchService?query=${encodeURIComponent(currentSearchTerm)}&filter=${encodeURIComponent(currentFilter)}`;

        try {
            const response = await fetch(searchUrl);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const services = await response.json();

            // Vẽ lại bảng với dữ liệu mới
            renderTable(services);

        } catch (error) {
            console.error('Lỗi khi tìm kiếm dịch vụ:', error);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center py-4 text-red-500">Lỗi khi tải dữ liệu. Vui lòng thử lại.</td>
                </tr>
            `;
        }
    }

    // --- 4. Hàm Render Bảng ---
    function renderTable(services) {
        // Xóa toàn bộ nội dung cũ của tbody
        tableBody.innerHTML = '';

        if (services.length === 0) {
            // Hiển thị thông báo "No results"
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center py-4 text-gray-500">No services found matching your criteria.</td>
                </tr>
            `;
            return;
        }

        // Lặp qua dữ liệu JSON và tạo từng hàng
        services.forEach(service => {
            // Định dạng giá (giống <fmt:formatNumber>)
            const formattedPrice = new Intl.NumberFormat('vi-VN').format(service.price);

            // Định dạng ngày (giống <fmt:formatDate>)
            // Giả định service.createdAt là một timestamp (số) hoặc string (ISO 8601)
            const formattedDate = new Date(service.createdAt).toLocaleDateString('vi-VN', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });

            // Định dạng status (giống ${... ? ... : ...})
            const statusClass = service.status === "ACTIVE" ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700";
            const statusText = service.status;

            const rowHtml = `
                <tr data-category="${service.type}" class="filter-item hover:bg-gray-50 transition">
                    <td class="px-4 py-2">${service.id}</td>
                    <td class="px-4 py-2 font-medium text-sky-600">${service.code}</td>
                    <td class="px-4 py-2">${service.name}</td>
                    <td class="px-4 py-2 text-right">${formattedPrice}</td>
                    <td class="px-4 py-2 text-center">
                        <span class="px-2 py-1 text-xs font-semibold rounded-full ${statusClass}">
                            ${statusText}
                        </span>
                    </td>
                    <td class="px-4 py-2 text-center">${formattedDate}</td>
                    <td class="px-4 py-2 text-center">
                        <div class="flex justify-center gap-2">
                            <button type="button"
                                    data-service-id="${service.id}"
                                    data-type="${service.type}"
                                    class="btn-view-detail-ajax px-3 py-1 bg-sky-500 hover:bg-sky-600 text-white text-xs rounded-md transition-colors">
                                Detail
                            </button>
                            <button type="button"
                                    data-service-id="${service.id}"
                                    data-type="${service.type}"
                                    class="btn-edit-ajax px-3 py-1 bg-amber-500 hover:bg-amber-600 text-white text-xs rounded-md transition-colors">
                                Edit
                            </button>
                        </div>
                    </td>
                </tr>
            `;
            tableBody.innerHTML += rowHtml;
        });

        // QUAN TRỌNG:
        // Nếu các file js khác (serviceFetchAPI.js, sericeEdit.js)
        // không dùng "event delegation", bạn có thể cần phải
        // gọi lại hàm init của chúng ở đây để gắn lại listener
        // cho các nút Detail/Edit vừa được tạo.
        // Ví dụ: if (typeof initEditButtons === 'function') initEditButtons();
    }

    // --- 5. Gắn Event Listeners ---

    // Gắn listener cho ô search (với debounce)
    searchInput.addEventListener('input', debounce((event) => {
        currentSearchTerm = event.target.value;
        fetchAndRender(); // Gọi hàm fetch chính
    }, 300)); // Trì hoãn 300ms

    // Gắn listener cho các nút filter
    filterButtons.forEach(clickedButton => {
        clickedButton.addEventListener('click', () => {
            // 1. Cập nhật style nút (giống file cũ)
            filterButtons.forEach(btn => {
                btn.classList.remove('bg-white', 'text-sky-700', 'shadow-sm');
                btn.classList.add('text-gray-600', 'hover:bg-gray-200');
            });
            clickedButton.classList.add('bg-white', 'text-sky-700', 'shadow-sm');
            clickedButton.classList.remove('text-gray-600', 'hover:bg-gray-200');

            // 2. Cập nhật biến filter
            currentFilter = clickedButton.dataset.filter;

            // 3. Gọi lại hàm fetch chính
            fetchAndRender();
        });
    });

});