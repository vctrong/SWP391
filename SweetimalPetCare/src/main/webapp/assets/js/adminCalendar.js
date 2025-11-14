/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global contextPath, FullCalendar */

document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');

    // Kiểm tra xem có element calendar không (tránh lỗi ở trang khác)
    if (calendarEl) {
        var calendar = new FullCalendar.Calendar(calendarEl, {
            // --- Cấu hình giao diện ---
            initialView: 'dayGridMonth',
            themeSystem: 'standard',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            buttonText: {
                today: 'Hôm nay',
                month: 'Tháng',
                week: 'Tuần',
                day: 'Ngày'
            },
            height: 'auto', // Tự động giãn chiều cao
            navLinks: true, // Cho phép click vào ngày để xem ngày đó
            editable: false, // Không cho kéo thả sửa ngày (vì logic phức tạp)

            // --- Nguồn dữ liệu (Gọi Servlet) ---
            // FullCalendar sẽ tự động nối thêm ?start=...&end=... vào URL này
            events: contextPath + '/admin/BookingData', // <--- ĐỔI TÊN PROJECT CỦA BẠN NẾU KHÁC

            // --- Xử lý sự kiện Click vào Booking ---
            eventClick: function (info) {
                // Ngăn chặn hành vi mặc định
                info.jsEvent.preventDefault();

                // Lấy dữ liệu từ ExtendedProps (DTO)
                const props = info.event.extendedProps;

                // --- Đổ dữ liệu vào Modal ---
                // (Đảm bảo ID trong HTML khớp với ID ở đây)
                const modalIdInput = document.getElementById('modalBookingId');
                if (modalIdInput) {
                    modalIdInput.value = info.event.id;
                }
                document.getElementById('modalTitle').innerText = info.event.title;

                // Format ngày giờ
                const startDate = info.event.start;
                const dateStr = startDate ? startDate.toLocaleString('vi-VN') : '';
                document.getElementById('modalTime').innerText = dateStr;

                document.getElementById('modalCustomer').innerText = props.customerName || 'N/A';
                document.getElementById('modalPhone').innerText = props.customerPhone || 'N/A';
                document.getElementById('modalPet').innerText = (props.petName || '') + ' (' + (props.petType || '') + ')';
                document.getElementById('modalService').innerText = props.itemName || 'N/A';

                // Format tiền tệ
                const price = props.totalPrice;
                document.getElementById('modalPrice').innerText = price ? price.toLocaleString('vi-VN') + ' đ' : '0 đ';

                document.getElementById('modalNotes').innerText = props.notes || 'Không có ghi chú';

                // Xử lý màu status trong modal
                const statusEl = document.getElementById('modalStatus');
                statusEl.innerText = props.status;
                statusEl.className = 'font-bold ' + getStatusColorText(props.status);

                if (typeof setupActionButtons === "function") {
                    setupActionButtons(props.status);
                }
                // Hiện Modal (Bỏ class hidden)
                document.getElementById('bookingModal').classList.remove('hidden');
            }
        });

        calendar.render();
        window.mainCalendar = calendar;
    }
});

// Hàm phụ trợ lấy class màu chữ
function getStatusColorText(status) {
    switch (status) {
        case 'PENDING':
            return 'text-yellow-600'; // Màu Vàng cam
        case 'CONFIRMED':
            return 'text-green-600';  // Màu Xanh lá
        case 'IN_PROGRESS':
            return 'text-blue-600';   // Màu Xanh dương
        case 'COMPLETED':
            return 'text-gray-500';   // Màu Xám (đã xong)
        case 'CANCELLED':
            return 'text-red-500';    // Màu Đỏ tươi
        case 'NO_SHOW':
            return 'text-red-800';    // Màu Đỏ đậm (cảnh báo khách bùng kèo)
        default:
            return 'text-gray-400';
    }
}

// Hàm đóng modal (Gắn vào nút Close trong HTML)
function closeModal() {
    document.getElementById('bookingModal').classList.add('hidden');
}