/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */





function formatCurrency(value, notation = 'standard') {
    // Kiểm tra xem 'Intl' có tồn tại và hoạt động không
    if (typeof Intl === 'object' && typeof Intl.NumberFormat === 'function') {
        try {
            // Trình duyệt hiện đại: Dùng Intl (cách tốt nhất)
            let options = {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            };

            if (notation === 'compact') {
                options.notation = 'compact'; // vd: 1,5 tr ₫
                options.maximumFractionDigits = 1;
            }

            return new Intl.NumberFormat('vi-VN', options).format(value);

        } catch (e) {
            // Đề phòng lỗi (ví dụ: 'vi-VN' không được hỗ trợ)
            // Bỏ qua và dùng fallback bên dưới
        }
    }

    // --- Phương án dự phòng (Fallback) ---
    // Dành cho môi trường cũ không có 'Intl' (như trình duyệt của NetBeans)
    // Biến 1500000 -> "1.500.000 ₫"

    // Lấy phần nguyên
    let numStr = String(Math.floor(value));
    // Thêm dấu chấm
    let formatted = numStr.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

    return formatted + ' ₫';
}


/**
 * Khởi tạo biểu đồ đường (Line Chart) cho doanh thu
 * Đã thêm định dạng số tiền hàng triệu cho "gọn gàng".
 * @param {string} canvasId - ID của thẻ canvas (vd: 'revenueChart')
 * @param {string[]} labels - Mảng các nhãn (vd: ['2025-10-01', ...])
 * @param {number[]} data - Mảng dữ liệu doanh thu (vd: [1200000, ...])
 */
function initRevenueChart(canvasId, labels, data) {
    const ctx = document.getElementById(canvasId);
    if (!ctx)
        return; // Không tìm thấy canvas

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                    label: 'Doanh thu (₫)',
                    data: data,
                    tension: 0.3, // Bo tròn đường line
                    fill: true, // Tô màu bên dưới
                    backgroundColor: 'rgba(14, 165, 164, 0.08)', // Màu teal
                    borderColor: '#0891b2', // Màu cyan
                    pointRadius: 2,
                    pointBackgroundColor: '#0891b2'
                }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // Cho phép canvas co dãn
            scales: {
                y: {
                    beginAtZero: true,
                    // === SỬA LỖI 'Intl': Gọi hàm formatCurrency an toàn ===
                    ticks: {
                        callback: function (value) {
                            // Gọi hàm helper, yêu cầu định dạng "compact" (gọn)
                            return formatCurrency(value, 'compact');
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    display: false // Ẩn legend (chú thích)
                },
                tooltip: {
                    // Tùy chỉnh tooltip khi hover (hiển thị số tiền đầy đủ)
                    callbacks: {
                        label: function (context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed.y !== null) {
                                // Gọi hàm helper, yêu cầu định dạng "standard" (đầy đủ)
                                label += formatCurrency(context.parsed.y, 'standard');
                            }
                            return label;
                        }
                    }
                }
            }
        }
    });
}

/**
 * Khởi tạo biểu đồ tròn (Doughnut Chart) cho Top 5
 * @param {string} canvasId - ID của thẻ canvas (vd: 'servicePie')
 * @param {string[]} labels - Mảng các nhãn (vd: ['Tắm gội', ...])
 * @param {number[]} data - Mảng dữ liệu số lượng (vd: [45, ...])
 */
function initDoughnutChart(canvasId, labels, data) {
    const ctx = document.getElementById(canvasId);
    if (!ctx)
        return; // Không tìm thấy canvas

    // 5 màu (blue, green, yellow, red, indigo)
    const colors = ['#3b82f6', '#22c55e', '#eab308', '#ef4444', '#6366f1'];

    new Chart(ctx, {
        type: 'doughnut', // 'pie' hoặc 'doughnut' đều được
        data: {
            labels: labels,
            datasets: [{
                    label: 'Số lượng',
                    data: data,
                    backgroundColor: colors,
                    borderWidth: 0 // Bỏ viền
                }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom', // Đặt chú thích ở dưới
                    align: 'start', // Căn lề trái
                    labels: {
                        boxWidth: 20, // Kích thước ô màu
                        padding: 15
                    }
                }
            }
        }
    });
}





document.getElementById('openMobileSidebar').addEventListener('click', () => {
    document.getElementById('mobileSidebar').classList.remove('hidden');
});
document.getElementById('closeMobileSidebar').addEventListener('click', () => {
    document.getElementById('mobileSidebar').classList.add('hidden');
});

