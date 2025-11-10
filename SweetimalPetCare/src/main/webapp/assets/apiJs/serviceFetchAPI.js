/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global Intl, url */

document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('detailServiceModal');
    if (!modal) {
        return;
    }

    function openModal() {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
        setTimeout(() => {
            modal.classList.remove('opacity-0');
            modal.querySelector('.modal-container').classList.remove('-translate-y-10', 'opacity-0');
        }, 10);
    }

    function closeModal() {
        modal.classList.add('opacity-0');
        modal.querySelector('.modal-container').classList.add('-translate-y-10', 'opacity-0');
        setTimeout(() => {
            modal.classList.remove('flex');
            modal.classList.add('hidden');
            setModalState('loading'); // Reset về loading cho lần mở sau
        }, 300);
    }


    function setModalState(state, errorMsg = 'Đã xảy ra lỗi không xác định') {
        // Ẩn hết các state
        modal.querySelectorAll('[data-state]').forEach(el => el.classList.add('hidden'));
        // Hiện state cần thiết
        const target = modal.querySelector(`[data-state="${state}"]`);
        if (target) {
            target.classList.remove('hidden');
            // Nếu là loading hoặc error thì cần flex để căn giữa
            if (state === 'loading' || state === 'error')
                target.classList.add('flex');
        }
        // Nếu là error thì điền thông báo
        if (state === 'error')
            modal.querySelector('.error-message').textContent = errorMsg;
    }

    async function loadDetailData(id, type) {
        console.log("day la id: ", id);
        ;
        openModal();
        setModalState('loading');
        modal.querySelector('.btn-retry').onclick = () => loadDetailData(id, type);
        try {
            const response = await fetch(`${url}/api/ServiceAPI`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    id: id,
                    type: type
                })
            });
            console.log(response);
            if (!response.ok)
                throw new Error(`Lỗi kết nối (${response.status})`);
            const data = await response.json();
            if (!data)
                throw new Error('Không tìm thấy dữ liệu');
            renderDataToModal(data, type);
            setModalState('content');
        } catch (error) {
            console.error("Detail load error:", error);
            setModalState('error', error.message || 'Không thể kết nối đến máy chủ');
        }
    }


    function renderDataToModal(data, type) {
        // A. Render các trường CHUNG (Service & Package đều có)
        console.log("📦 [DEBUG] Data nhận được:", data);
        const isService = (type === 'Service');

        document.getElementById('detail-modal-title').textContent = isService ? 'Chi tiết Dịch vụ' : 'Chi tiết Gói dịch vụ';
        document.getElementById('detail-modal-icon').textContent = isService ? '🛠️' : '📦';

        setText('d-code', data.code);
        setText('d-name', data.name);
        setText('d-description', data.description || 'Không có mô tả.');
        setText('d-price', new Intl.NumberFormat('vi-VN').format(data.price || 0));
        setText('d-created', data.createdAt || 'N/A'); // Cần đảm bảo server trả về chuỗi ngày tháng đẹp, hoặc format lại ở đây.

        // Status badge
        const statusEl = document.getElementById('d-status');
        statusEl.textContent = data.status;
        statusEl.className = `px-3 py-1 rounded-full text-sm font-semibold ${
                data.status === 'ACTIVE' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                }`;

        // B. Xử lý riêng cho SERVICE
        const durationBlock = document.getElementById('d-duration-block');
        const categoryBlock = document.getElementById('d-category-block');
        if (isService) {
            durationBlock.classList.remove('hidden');
            categoryBlock.classList.remove('hidden');
            setText('d-duration', data.baseDurationMin || 0);
            setText('d-category', data.serviceCateName || 'N/A');
        } else {
            durationBlock.classList.add('hidden');
            categoryBlock.classList.add('hidden');
        }
        // C. Xử lý riêng cho PACKAGE (Hiển thị danh sách items)
        const packageBlock = document.getElementById('d-package-items-block');
        if (!isService && type === 'Package') {
            packageBlock.classList.remove('hidden');
            const listContainer = document.getElementById('d-package-items-list');
            listContainer.innerHTML = ''; // Xóa dữ liệu cũ
            // Giả sử data.packageItems là mảng các object { serviceName: 'ABC', quantity: 2 }
            const rawItems = data.item || [];

            const items = rawItems.filter(item => item.id && item.id !== 0);
            console.log("day la items", items);
            document.getElementById('d-item-count').textContent = `${items.length} dịch vụ`;
            if (items.length > 0) {
                items.forEach(item => {
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td class="px-4 py-3 text-sm text-gray-900">${item.name || 'Unknown Service'}</td>
                    <td class="px-4 py-3 text-sm text-gray-600 text-center align-middle">
                        ${item.duration} phút
                    </td>
                        <td class="px-4 py-3 text-sm text-gray-900 text-center font-medium bg-gray-50">${item.quantity || 1}</td>
                    `;
                    listContainer.appendChild(row);
                });
            } else {
                listContainer.innerHTML = '<tr><td colspan="3" class="px-4 py-3 text-sm text-gray-500 text-center italic">Gói này chưa có dịch vụ nào.</td></tr>';
            }

        } else {
            packageBlock.classList.add('hidden');
        }
    }

    function setText(id, value) {
        const el = document.getElementById(id);
        if (el) {
            el.textContent = value;
        }
    }

    document.addEventListener('click', (e) => {
        // Sửa tên class cho khớp với HTML
        const btn = e.target.closest('.btn-view-detail-ajax');
        if (btn) {
            // Sửa tên thuộc tính dataset cho khớp với data-service-id
            const id = btn.dataset.serviceId;
            const type = btn.dataset.type || 'Service';
            if (id) {
                loadDetailData(id, type);
            } else {
                console.error("Button thiếu data-service-id", btn);
            }
        }
    });

    // Nút đóng modal
    document.querySelectorAll('[data-modal-hide="detailServiceModal"]').forEach(btn => {
        btn.addEventListener('click', closeModal);
    });

    // Đóng khi click ra ngoài
    modal.addEventListener('click', (e) => {
        if (e.target === modal)
            closeModal();
    });

    // Đóng bằng phím ESC
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.classList.contains('hidden'))
            closeModal();
    });

});

