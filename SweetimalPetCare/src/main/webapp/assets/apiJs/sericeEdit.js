/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global url */

document.addEventListener('DOMContentLoaded', () => {
    // --- 1. KHỞI TẠO CÁC BIẾN & KIỂM TRA ---
    const editModal = document.getElementById('editModal');
    // Nếu trang hiện tại không có modal này thì dừng lại, tránh lỗi JS
    if (!editModal)
        return;

    const editForm = document.getElementById('editForm');
    const packageItemsList = document.getElementById('edit-package-items-list');
    const packageItemTemplate = document.getElementById('package-item-template');
    const btnAddPackageItem = document.getElementById('btn-add-package-item');
    const packageEmptyState = document.getElementById('edit-package-empty');

    // Xác định URL API (ưu tiên dùng BASE_URL từ JSP nếu có)
    const API_URL = (typeof url !== 'undefined') ? `${url}/api/ServiceAPI` : '../api/ServiceAPI';

    // --- 2. CÁC HÀM ĐIỀU KHIỂN HIỂN THỊ MODAL ---

    // Hàm mở modal với hiệu ứng trượt xuống
    function openEditModal() {
        editModal.classList.remove('hidden');
        editModal.classList.add('flex');
        setTimeout(() => {
            editModal.classList.remove('opacity-0');
            editModal.querySelector('.modal-container').classList.remove('-translate-y-10', 'opacity-0');
        }, 10);
    }

    // Hàm đóng modal với hiệu ứng trượt lên
    function closeEditModal() {
        editModal.classList.add('opacity-0');
        editModal.querySelector('.modal-container').classList.add('-translate-y-10', 'opacity-0');
        setTimeout(() => {
            editModal.classList.remove('flex');
            editModal.classList.add('hidden');
            setEditState('loading'); // Reset trạng thái về loading cho lần mở sau
        }, 300);
    }

    // Hàm chuyển đổi giữa các trạng thái: đang tải (loading), lỗi (error), nội dung (content)
    function setEditState(state, errorMsg = '') {
        // Ẩn tất cả các trạng thái trước
        editModal.querySelectorAll('[data-state]').forEach(el => el.classList.add('hidden'));

        // Hiện trạng thái mong muốn
        const target = editModal.querySelector(`[data-state="${state}"]`);
        if (target) {
            target.classList.remove('hidden');
            // Nếu là loading hoặc error thì cần căn giữa
            if (state === 'loading' || state === 'error')
                target.classList.add('flex');
        }

        // Nếu là lỗi thì hiển thị thông báo lỗi cụ thể
        if (state === 'error') {
            const msgEl = editModal.querySelector('.error-message');
            if (msgEl)
                msgEl.textContent = errorMsg;
    }
    }

    // --- 3. HÀM GỌI API ĐỂ LẤY DỮ LIỆU CẦN SỬA ---
    async function loadEditData(id, type) {
        console.log(`✏️ [EDIT] Đang tải dữ liệu ID=${id}, Type=${type}...`);
        openEditModal();
        setEditState('loading');

        // Gán sự kiện cho nút "Thử lại" nếu việc tải bị lỗi
        const retryBtn = editModal.querySelector('.btn-retry');
        if (retryBtn)
            retryBtn.onclick = () => loadEditData(id, type);

        try {
            console.log(`✏️ [EDIT] Đang tải dữ liệu ID=${id}, Type=${type}...`);
            const response = await fetch(API_URL, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({id: id, type: type})
            });
            if (!response.ok)
                throw new Error(`Lỗi máy chủ (${response.status})`);

            const data = await response.json();
            if (!data)
                throw new Error('Không tìm thấy dữ liệu');

            console.log("✅ [EDIT] Đã nhận dữ liệu:", data);
            // Gọi hàm điền dữ liệu vào form
            renderEditForm(data, type);
            // Chuyển sang trạng thái hiển thị nội dung
            setEditState('content');

        } catch (error) {
            console.error("❌ [EDIT ERROR]:", error);
            setEditState('error', error.message || 'Không thể kết nối đến máy chủ');
        }
    }

    // --- 4. HÀM ĐIỀN DỮ LIỆU VÀO FORM (RENDER) ---
    function renderEditForm(data, type) {
        const normalizedType = (type || '').toLowerCase();
        const isService = (normalizedType === 'service');

        // A. Cập nhật tiêu đề và icon của modal cho phù hợp
        document.getElementById('edit-modal-title').textContent = isService ? 'Chỉnh sửa Dịch vụ' : 'Chỉnh sửa Gói dịch vụ';
        document.getElementById('edit-modal-icon').textContent = isService ? '🛠️' : '📦';

        // B. Điền các giá trị chung vào input
        // Lưu ý: Cần kiểm tra nhiều tên biến khác nhau để tránh lỗi nếu DTO Java thay đổi tên
        document.getElementById('edit-id').value = data.id || data.serviceId || data.packageId;
        document.getElementById('edit-type').value = type; // Giữ nguyên type gốc để gửi về server
        document.getElementById('edit-code').value = data.code || data.serviceCode || data.packageCode;
        document.getElementById('edit-name').value = data.name || data.serviceName || data.packageName;
        document.getElementById('edit-price').value = data.price || data.currentPrice || 0;
        document.getElementById('edit-status').value = data.status; // Select box sẽ tự chọn option tương ứng
        document.getElementById('edit-description').value = data.description || '';

        // C. Ẩn/hiện các khối nhập liệu đặc thù
        const durationBlock = document.getElementById('edit-duration-block');
        const categoryBlock = document.getElementById('edit-category-block');
        const packageItemsBlock = document.getElementById('edit-package-items-block');

        if (isService) {
            // --- NẾU LÀ SERVICE ---
            // Hiện: Thời lượng, Danh mục. Ẩn: Danh sách gói.
            durationBlock.classList.remove('hidden');
            categoryBlock.classList.remove('hidden');
            packageItemsBlock.classList.add('hidden');

            document.getElementById('edit-duration').value = data.baseDurationMin || data.duration || 0;
            document.getElementById('edit-category').value = data.serviceCateId;
        } else {
            // --- NẾU LÀ PACKAGE ---
            // Ẩn: Thời lượng, Danh mục. Hiện: Danh sách gói.
            durationBlock.classList.add('hidden');
            categoryBlock.classList.add('hidden');
            packageItemsBlock.classList.remove('hidden');

            // Gọi hàm riêng để render danh sách các dịch vụ con

            const items = data.packageItems || data.item || [];
            renderPackageItemsList(items);
        }
    }

    // --- 5. CÁC HÀM XỬ LÝ DANH SÁCH DỊCH VỤ CON (PACKAGE ITEMS) ---

    // Hàm render lại toàn bộ danh sách item từ dữ liệu ban đầu
    function renderPackageItemsList(items) {
        packageItemsList.innerHTML = ''; // Xóa sạch bảng cũ

        // Lọc bỏ các item lỗi (ví dụ item có ID=0 do LEFT JOIN tạo ra)
        const validItems = items.filter(item => (item.id && item.id !== 0) || (item.serviceId && item.serviceId !== 0));

        if (validItems.length === 0) {
            packageEmptyState.classList.remove('hidden'); // Hiện thông báo "Gói trống"
        } else {
            packageEmptyState.classList.add('hidden');
            // Tạo từng dòng cho mỗi item hợp lệ
            validItems.forEach(item => {
                addPackageItemRow(item.id, item.quantity);
            });
        }
    }

    // Hàm thêm một dòng mới vào bảng (sử dụng thẻ <template> trong HTML)
    function addPackageItemRow(serviceId = '', quantity = 1) {
        packageEmptyState.classList.add('hidden'); // Ẩn thông báo trống

        // Clone (sao chép) nội dung từ template
        const clone = packageItemTemplate.content.cloneNode(true);
        const row = clone.querySelector('.package-item-row');


        // Nếu đang render dữ liệu cũ, tự động chọn service và điền số lượng
        if (serviceId) {
            const selectEl = row.querySelector('.item-service-select');
            if (selectEl)
                selectEl.value = serviceId;
        }
        row.querySelector('.item-quantity-input').value = quantity;

        // Gán sự kiện click cho nút "Thùng rác" để xóa dòng này
        row.querySelector('.btn-remove-item').addEventListener('click', () => {
            row.remove();
            // Nếu xóa xong mà không còn dòng nào, hiện lại thông báo trống
            if (packageItemsList.children.length === 0) {
                packageEmptyState.classList.remove('hidden');
            }
        });

        // Thêm dòng vừa tạo vào cuối bảng
        packageItemsList.appendChild(row);
    }

    // --- 6. GÁN SỰ KIỆN (EVENT LISTENERS) ---

    // Sự kiện click vào nút "Edit" trên bảng danh sách (Sử dụng Event Delegation)
    document.addEventListener('click', (e) => {
        const btn = e.target.closest('.btn-edit-ajax');
        if (btn) {
            const id = btn.dataset.serviceId;
            const type = btn.dataset.type || 'Service';

            // Kiểm tra ID hợp lệ trước khi gọi API
            if (id && id !== "0") {
                loadEditData(id, type);
            } else {
                console.error("❌ Lỗi: Nút Edit có ID không hợp lệ:", btn);
                alert("Không thể chỉnh sửa mục này do lỗi dữ liệu.");
            }
        }
    });

    // Sự kiện cho nút "Thêm dịch vụ" (chỉ dùng cho Package)
    if (btnAddPackageItem) {
        btnAddPackageItem.addEventListener('click', () => {
            addPackageItemRow(); // Thêm một dòng trống mới
        });
    }

    // Các sự kiện đóng modal (Nút X, Nút Hủy, Click ra ngoài, Phím ESC)
    document.querySelectorAll('[data-modal-hide="editModal"]').forEach(btn => {
        btn.addEventListener('click', closeEditModal);
    });
    editModal.addEventListener('click', (e) => {
        if (e.target === editModal)
            closeEditModal();
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !editModal.classList.contains('hidden'))
            closeEditModal();
    });

    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        showCloseButton: true,
        didOpen: (toast) => {
            toast.addEventListener('mouseenter', Swal.stopTimer);
            toast.addEventListener('mouseleave', Swal.resumeTimer);
        }
        // Bạn có thể thêm customClass của bạn ở đây
        // customClass: {
        //     popup: 'toast-highlight'
        // }
    });
// --- 7. XỬ LÝ SUBMIT FORM (LƯU DỮ LIỆU) ---
    editForm.addEventListener('submit', async (e) => {
        e.preventDefault(); // 1. Chặn việc load lại trang

        // Lấy các element giao diện liên quan
        const btnSave = editModal.querySelector('button[type="submit"]');
        const btnText = document.getElementById('btn-save-text');
        const btnLoading = document.getElementById('btn-save-loading');

        // 2. Hiệu ứng đang tải
        btnSave.disabled = true;
        btnText.textContent = 'Đang lưu...';
        btnLoading.classList.remove('hidden');

        try {
            // 3. Thu thập dữ liệu từ form
            // FormData sẽ tự động lấy tất cả input có name, bao gồm cả các mảng []
            const formData = new FormData(editForm);

            // Chuyển FormData thành chuỗi URL-encoded để gửi cho Servlet (vì Servlet đang dùng request.getParameter)
            const params = new URLSearchParams();
            for (const pair of formData.entries()) {
                params.append(pair[0], pair[1]);
            }

            console.log("📤 [EDIT] Đang gửi dữ liệu cập nhật...", params.toString());

            // 4. Gọi API cập nhật
            // Lưu ý: URL phải trỏ đến ServiceEditAPI (API lưu), không phải ServiceAPI (API xem)
            const SAVE_API_URL = (typeof url !== 'undefined') ? `${url}/api/ServiceEditAPI` : '../api/ServiceEditAPI';

            const response = await fetch(SAVE_API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params
            });

            const responseText = await response.text();
            let result;
            try {
                result = JSON.parse(responseText);
            } catch (err) {
                throw new Error("Server trả về lỗi không xác định (không phải JSON).");
            }

            // 5. Xử lý kết quả
            if (response.ok && result.status === 'success') {
                // Thành công!
                closeEditModal(); // Đóng modal
                Toast.fire({// Bắn toast thành công
                    icon: 'success',
                    title: result.message // Lấy message từ JSON
                });

                // Tải lại trang sau 1.5 giây để thấy dữ liệu mới
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                // Thất bại do server báo lỗi logic (ví dụ: tên trùng, dữ liệu sai...)
                throw new Error(result.message || 'Cập nhật thất bại.');
            }

        } catch (error) {
            console.error("❌ [SAVE ERROR]:", error);
            Toast.fire({// Bắn toast lỗi
                icon: 'error',
                title: error.message
            });
        } finally {
            // 6. Reset trạng thái nút Lưu
            btnSave.disabled = false;
            btnText.textContent = 'Lưu thay đổi';
            btnLoading.classList.add('hidden');
        }
    });
}); // Kết thúc DOMContentLoaded