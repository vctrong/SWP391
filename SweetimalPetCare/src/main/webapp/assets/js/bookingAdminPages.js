/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

let searchTimeout;
const PAGE_SIZE = 6;

function filterStatus(element, status) {
    // A. Đổi giao diện Active Tab
    const tabs = document.querySelectorAll('.status-tab');
    tabs.forEach(tab => {
        // Reset về style mặc định (màu xám)
        tab.className = 'status-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300 cursor-pointer';
    });

    // Set tab hiện tại thành màu xanh
    element.className = 'status-tab active-tab whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm text-blue-600 border-blue-500 cursor-pointer';

    // B. Lưu status vào input hidden
    document.getElementById('currentStatus').value = status;

    // C. Load lại trang 1
    loadBookingPage(1);
}


function handleSearch(event) {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        loadBookingPage(1);
    }, 500);
}



function loadBookingPage(pageIndex) {
    const tbody = document.getElementById('bookingsTableBody');
    if (tbody)
        tbody.style.opacity = '0.5'; // Hiệu ứng loading

    // Lấy dữ liệu input
    const search = document.getElementById('bookingSearch').value;
    const status = document.getElementById('currentStatus').value;

    // Tạo URL gọi Servlet
    // Lưu ý: tham số pageSize=6 được gửi đi
    const url = `${contextPath}/api/Booking?page=${pageIndex}&pageSize=${PAGE_SIZE}&search=${encodeURIComponent(search)}&status=${encodeURIComponent(status)}`;

    fetch(url)
            .then(response => {
                if (!response.ok)
                    throw new Error('Network response was not ok');
                return response.text();
            })
            .then(htmlData => {
                if (tbody) {
                    tbody.innerHTML = htmlData;
                    tbody.style.opacity = '1';

                    const totalRecordsEl = document.getElementById('ajax-total-records');
                    const badgeEl = document.getElementById('totalBookingsBadge');

                    if (totalRecordsEl && badgeEl) {
                        badgeEl.innerText = 'Total: ' + totalRecordsEl.value + ' orders';
                    }


                    // Đọc thông tin phân trang từ thẻ ẩn (được trả về trong htmlData)
                    const totalPagesEl = document.getElementById('ajax-total-pages');
                    const currentPageEl = document.getElementById('ajax-current-page');

                    if (totalPagesEl && currentPageEl) {
                        const total = parseInt(totalPagesEl.value) || 0;
                        const current = parseInt(currentPageEl.value) || 1;

                        // Vẽ lại nút phân trang
                        renderPagination(current, total);
                    } else {
                        // Nếu không có dữ liệu -> Xóa nút phân trang
                        const pagContainer = document.getElementById('paginationControls');
                        if (pagContainer)
                            pagContainer.innerHTML = '';
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (tbody)
                    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-red-500 py-4">Error loading data</td></tr>';
            });
}


function renderPagination(currentPage, totalPages) {
    const container = document.getElementById('paginationControls');
    if (!container)
        return;

    let html = '';

    // --- Nút Previous ---
    const prevDisabled = currentPage <= 1;
    html += `<button ${prevDisabled ? 'disabled' : `onclick="loadBookingPage(${currentPage - 1})"`} 
             class="px-3 py-1 border rounded-l ${prevDisabled ? 'bg-gray-100 text-gray-300 cursor-not-allowed' : 'hover:bg-gray-100 text-gray-600'}">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
             </button>`;

    // --- Các nút số (Ellipsis Logic) ---
    const createBtn = (i) => {
        if (i === currentPage) {
            return `<button class="px-3 py-1 border-t border-b border-r bg-blue-600 text-white font-bold">${i}</button>`;
        }
        return `<button onclick="loadBookingPage(${i})" class="px-3 py-1 border-t border-b border-r hover:bg-gray-100 text-gray-600">${i}</button>`;
    };
    const dots = `<span class="px-2 py-1 border-t border-b border-r text-gray-400">...</span>`;

    if (totalPages <= 7) {
        for (let i = 1; i <= totalPages; i++)
            html += createBtn(i);
    } else {
        if (currentPage <= 4) {
            for (let i = 1; i <= 5; i++)
                html += createBtn(i);
            html += dots;
            html += createBtn(totalPages);
        } else if (currentPage >= totalPages - 3) {
            html += createBtn(1);
            html += dots;
            for (let i = totalPages - 4; i <= totalPages; i++)
                html += createBtn(i);
        } else {
            html += createBtn(1);
            html += dots;
            html += createBtn(currentPage - 1);
            html += createBtn(currentPage);
            html += createBtn(currentPage + 1);
            html += dots;
            html += createBtn(totalPages);
        }
    }

    // --- Nút Next ---
    const nextDisabled = currentPage >= totalPages;
    html += `<button ${nextDisabled ? 'disabled' : `onclick="loadBookingPage(${currentPage + 1})"`} 
             class="px-3 py-1 border-t border-b border-r rounded-r ${nextDisabled ? 'bg-gray-100 text-gray-300 cursor-not-allowed' : 'hover:bg-gray-100 text-gray-600'}">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
             </button>`;

    container.innerHTML = html;
}

function viewFromTable(id, dateStr) {
    document.getElementById('modalBookingId').value = id;
    // 1. Gọi API lấy chi tiết
    fetch(`${contextPath}/admin/GetBookingDetail?id=${id}`)
            .then(response => {
                if (!response.ok)
                    throw new Error('Not found');
                return response.json();
            })
            .then(data => {
                // 'data' ở đây chính là object Booking trả về từ Java

                // 2. Đổ dữ liệu vào Modal
                // Lưu ý: Tên trường (data.xxx) phải khớp với tên biến trong Model Booking.java
                document.getElementById('modalTitle').innerText = (data.item || 'Service') + ' - ' + (data.fullName || 'Guest');

                // Ghép ngày + giờ (cần xử lý string cẩn thận vì JSON trả về format khác nhau tùy Gson)
                // Giả sử data.reqDate là "Nov 12, 2025" và reqStart là "09:30:00"
                document.getElementById('modalTime').innerText = data.reqDate + ' ' + data.reqStart;

                document.getElementById('modalCustomer').innerText = data.fullName;
                document.getElementById('modalPhone').innerText = data.phone || 'N/A'; // Nếu model có trường phone
                document.getElementById('modalPet').innerText = data.petName;
                document.getElementById('modalService').innerText = data.item; // item là tên biến trong Model/DTO

                // Format tiền
                const price = data.totalPrice || data.price; // Tùy tên biến trong model
                document.getElementById('modalPrice').innerText = price ? price.toLocaleString('vi-VN') + ' đ' : '0 đ';

                document.getElementById('modalNotes').innerText = data.notes || 'Không có ghi chú';

                // Màu status
                const statusEl = document.getElementById('modalStatus');
                statusEl.innerText = data.currentStatus;
                // Hàm getStatusColorText đã có ở file JS trước
                // Nếu chưa có thì copy lại từ adminCalendar.js qua
                if (typeof getStatusColorText === "function") {
                    statusEl.className = 'font-bold uppercase ' + getStatusColorText(data.currentStatus);
                }
                setupActionButtons(data.currentStatus);
                // 3. Mở Modal
                document.getElementById('bookingModal').classList.remove('hidden');

                // 4. Nhảy lịch (Jump Calendar)
                if (window.mainCalendar && dateStr) {
                    window.mainCalendar.gotoDate(dateStr);
                    document.getElementById('calendar').scrollIntoView({behavior: 'smooth', block: 'center'});
                }
            })
            .catch(error => {
                console.error('Error fetching detail:', error);
                alert('Không thể tải thông tin chi tiết!');
            });
}

function setupActionButtons(status) {
    // Lấy tất cả các nút
    const btnConfirm = document.getElementById('btnConfirm');
    const btnStart = document.getElementById('btnStart');
    const btnNoShow = document.getElementById('btnNoShow');
    const btnComplete = document.getElementById('btnComplete');
    const btnCancel = document.getElementById('btnCancel');

    // Reset: Ẩn tất cả trước
    [btnConfirm, btnStart, btnNoShow, btnComplete, btnCancel].forEach(btn => {
        if (btn)
            btn.classList.add('hidden');
    });

    // Logic hiển thị theo từng trạng thái
    if (status === 'PENDING') {
        btnConfirm.classList.remove('hidden');
        btnCancel.classList.remove('hidden');
    } else if (status === 'CONFIRMED') {
        btnStart.classList.remove('hidden');
        btnCancel.classList.remove('hidden');
        btnNoShow.classList.remove('hidden');
    } else if (status === 'IN_PROGRESS') {
        btnComplete.classList.remove('hidden');
    }
    // Các trạng thái CANCELLED, NO_SHOW, COMPLETED -> Không hiện nút nào (đã ẩn hết ở trên)
}

function updateBookingStatus(newStatus) {
    const id = document.getElementById('modalBookingId').value;
    console.log("id day:", id);
    if (!id) {
        console.log("khong lay duoc id");
        return;
    }


    // 1. Hiện hộp thoại xác nhận (Confirm Dialog)
    Swal.fire({
        title: 'Xác nhận thay đổi?',
        text: `Bạn có chắc muốn chuyển trạng thái sang: ${newStatus}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6', // Màu xanh dương
        cancelButtonColor: '#d33', // Màu đỏ
        confirmButtonText: 'Đồng ý, cập nhật!',
        cancelButtonText: 'Hủy bỏ'
    }).then((result) => {

        // 2. Nếu người dùng bấm nút "Đồng ý"
        if (result.isConfirmed) {

            // Hiện loading trong lúc chờ Server xử lý
            Swal.fire({
                title: 'Đang xử lý...',
                text: 'Vui lòng chờ trong giây lát',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Gọi API
            fetch(`${contextPath}/admin/GetBookingDetail`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `id=${id}&status=${newStatus}`
            })
                    .then(response => {
                        if (response.ok) {
                            // 3a. Thành công -> Hiện thông báo đẹp
                            Swal.fire({
                                title: 'Thành công!',
                                text: 'Trạng thái đơn hàng đã được cập nhật.',
                                icon: 'success',
                                timer: 1500, // Tự tắt sau 1.5s
                                showConfirmButton: false
                            });

                            // Đóng modal và load lại dữ liệu
                            closeModal();
                            loadBookingPage(1); // Load lại bảng
                            if (window.mainCalendar)
                                window.mainCalendar.refetchEvents(); // Load lại lịch

                        } else {
                            // 3b. Thất bại -> Báo lỗi
                            Swal.fire(
                                    'Lỗi!',
                                    'Không thể cập nhật trạng thái. Vui lòng thử lại.',
                                    'error'
                                    );
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        Swal.fire(
                                'Lỗi mạng!',
                                'Có lỗi xảy ra khi kết nối tới máy chủ.',
                                'error'
                                );
                    });
        }
    });
}

function openVetModal(bookingId, petId, ownerId, petName) {
    // 1. Điền dữ liệu vào input ẩn
    document.getElementById('vetBookingId').value = bookingId;
    document.getElementById('vetPetId').value = petId;
    document.getElementById('vetOwnerId').value = ownerId;

    // 2. Điền tên thú cưng lên tiêu đề
    document.getElementById('vetPetName').innerText = petName;

    // 3. Set mặc định ngày giờ khám là HIỆN TẠI
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset()); // Chỉnh lại múi giờ local
    const currentDateTime = now.toISOString().slice(0, 16); // Format: YYYY-MM-DDTHH:mm
    document.getElementsByName('visitDate')[0].value = currentDateTime;

    // 4. Reset các ô nhập liệu khác
    document.getElementsByName('weight')[0].value = '';
    document.getElementsByName('temperature')[0].value = '';
    document.getElementsByName('symptoms')[0].value = '';
    document.getElementsByName('diagnosis')[0].value = '';
    document.getElementsByName('treatment')[0].value = '';
    document.getElementsByName('followUpDate')[0].value = '';

    // 5. Hiện Modal
    document.getElementById('vetVisitModal').classList.remove('hidden');
}

function closeVetModal() {
    document.getElementById('vetVisitModal').classList.add('hidden');
}

/**
 * Gửi form bệnh án lên Server
 */
function submitVetVisit(event) {
    event.preventDefault();

    const formData = new URLSearchParams(new FormData(event.target));

    Swal.fire({
        title: 'Đang lưu hồ sơ...',
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading()
    });

    // Gọi Servlet (Chúng ta sẽ tạo ở Bước 5)
    fetch(`${contextPath}/admin/VetVisitUpdate`, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData
    })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        title: 'Thành công!',
                        text: 'Đã lưu bệnh án vào hệ thống.',
                        icon: 'success',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    closeVetModal();
                } else {
                    Swal.fire('Lỗi!', data.message || 'Không thể lưu bệnh án.', 'error');
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire('Lỗi mạng', 'Lỗi kết nối server.', 'error');
            });
}

// --- KHỞI CHẠY LẦN ĐẦU ---
document.addEventListener('DOMContentLoaded', function () {
    loadBookingPage(1);
});