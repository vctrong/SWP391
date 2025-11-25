// Mở modal tìm kiếm
function openProductSelectionModal() {
    document.getElementById('productSelectionModal').classList.remove('hidden');
    document.getElementById('productSelectionModal').classList.add('flex');
    document.getElementById('productSearchInput').focus();
    searchProducts(); // Load mặc định
}

// Đóng modal tìm kiếm
function closeProductModal() {
    document.getElementById('productSelectionModal').classList.add('hidden');
    document.getElementById('productSelectionModal').classList.remove('flex');
}

// Hàm search (Giả lập gọi API - Bạn cần thay bằng fetch API thật)
function searchProducts() {
    const keyword = document.getElementById('productSearchInput').value;
    const container = document.getElementById('productSearchResults');

    // Hiển thị loading
    container.innerHTML = '<div class="text-center py-4 text-gray-500">Đang tìm kiếm...</div>';

    // Gọi API Servlet
    fetch(url + '/api/ProductForNewOrderAPI?q=' + encodeURIComponent(keyword))
            .then(response => response.json())
            .then(data => {
                if (data.length === 0) {
                    container.innerHTML = '<div class="text-center text-gray-500 mt-4">Không tìm thấy sản phẩm nào.</div>';
                    return;
                }

                let html = '<div class="space-y-2">';
                data.forEach(p => {
                    const isOutOfStock = p.stockQuantity <= 0;
                    // Xử lý hiển thị thuộc tính (nếu có JSON) hoặc hiển thị SKU
                    // Giả sử server trả về attributeJson null hoặc string, ta hiển thị đơn giản:
                    const attrDisplay = p.sku;

                    html += `
                        <div class="flex items-center bg-white p-3 rounded shadow-sm border border-gray-100 hover:border-blue-400 transition">
                            <img src="${p.imageUrl || '/assets/images/no-image.png'}" class="w-12 h-12 object-cover rounded border mr-3" onerror="this.src='https://via.placeholder.com/50'">
                            <div class="flex-1">
                                <div class="font-bold text-gray-800">${p.productName}</div>
                                <div class="text-xs text-gray-500">SKU: ${p.sku}</div>
                                <div class="text-sm font-semibold text-blue-600">${p.price.toLocaleString()} ₫</div>
                            </div>
                            <div class="text-right mr-3">
                                <div class="text-xs text-gray-500">Kho: <span class="${isOutOfStock ? 'text-red-500 font-bold' : 'text-green-600'}">${p.stockQuantity}</span></div>
                            </div>
                            <button type="button" 
                                    onclick="selectProduct(${p.variantId}, '${p.productName} - ${p.sku}', ${p.price}, ${p.stockQuantity})"
                                    ${isOutOfStock ? 'disabled' : ''}
                                    class="${isOutOfStock ? 'bg-gray-300 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700'} text-white px-3 py-1.5 rounded text-sm font-medium transition">
                                ${isOutOfStock ? 'Hết hàng' : 'Chọn'}
                            </button>
                        </div>
                    `;
                });
                html += '</div>';
                container.innerHTML = html;
            })
            .catch(error => {
                console.error('Error:', error);
                container.innerHTML = '<div class="text-center text-red-500 mt-4">Lỗi kết nối server.</div>';
            });
}

// Debounce: Đợi user ngừng gõ 300ms mới search (để đỡ lag)
let timeoutId;
function debounceSearch() {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(searchProducts, 300);
}

// --- 2. QUẢN LÝ FORM CHÍNH (ADD ROW) ---

// Hàm được gọi khi user bấm nút "Chọn" trong Modal
function selectProduct(variantId, displayName, price, maxStock) {
    // Kiểm tra xem sản phẩm đã có trong list chưa
    const existingRow = document.querySelector(`.product-row[data-variant-id="${variantId}"]`);

    if (existingRow) {
        // Nếu có rồi -> Tăng số lượng lên 1
        const qtyInput = existingRow.querySelector('.row-qty-input');
        let currentQty = parseInt(qtyInput.value);
        if (currentQty < maxStock) {
            qtyInput.value = currentQty + 1;
            // Hiệu ứng nháy màu để báo hiệu đã thêm
            existingRow.classList.add('bg-blue-50');
            setTimeout(() => existingRow.classList.remove('bg-blue-50'), 500);
        } else {
            alert("Đã đạt giới hạn tồn kho!");
        }
    } else {
        // Nếu chưa có -> Tạo dòng mới
        addProductRowToForm(variantId, displayName, price, maxStock);
    }

    updateOrderTotals();
    // Option: Có thể đóng modal luôn hoặc giữ nguyên để chọn tiếp
    // closeProductModal(); 

    // Hiện thông báo nhỏ (Toast) là đã thêm (Optional)
}

// Hàm vẽ dòng HTML vào Form chính
function addProductRowToForm(variantId, name, price, maxStock) {
    const container = document.getElementById('product-list-container');
    const emptyMsg = document.getElementById('empty_row_message');
    if (emptyMsg)
        emptyMsg.style.display = 'none'; // Ẩn thông báo rỗng

    const rowDiv = document.createElement('div');
    rowDiv.className = "product-row flex items-center gap-3 border border-gray-200 rounded-lg p-3 bg-white hover:shadow-sm transition-all";
    rowDiv.setAttribute('data-variant-id', variantId); // Đánh dấu để check trùng

    rowDiv.innerHTML = `
            <div class="flex-1">
                <div class="font-medium text-gray-800 text-sm">${name}</div>
                <div class="text-xs text-blue-600 font-semibold">${price.toLocaleString()} ₫</div>
                <input type="hidden" name="variantIds" value="${variantId}">
                <input type="hidden" class="row-price-hidden" value="${price}">
            </div>

            <div class="w-24 border-l border-gray-200 pl-3">
                <input type="number" name="quantities" value="1" min="1" max="${maxStock}"
                       class="row-qty-input w-full text-center border border-gray-300 rounded px-1 py-1 text-sm font-bold focus:ring-blue-500 focus:border-blue-500"
                       oninput="updateOrderTotals()">
            </div>

            <div class="w-8 flex justify-center">
                <button type="button" onclick="removeProductRow(this)" class="text-gray-400 hover:text-red-500 p-1 rounded-full hover:bg-red-50 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                </button>
            </div>
        `;

    container.appendChild(rowDiv);
}

// Hàm xóa dòng
function removeProductRow(btn) {
    btn.closest('.product-row').remove();
    const container = document.getElementById('product-list-container');
    // Check nếu không còn dòng product-row nào thì hiện lại thông báo rỗng
    if (!container.querySelector('.product-row')) {
        document.getElementById('empty_row_message').style.display = 'block';
    }
    updateOrderTotals();
}

function validateOrderForm(event) {
    // 1. Đếm xem có dòng sản phẩm nào không
    const productRows = document.querySelectorAll('.product-row');

    if (productRows.length === 0) {
        // Nếu không có sản phẩm nào
        event.preventDefault(); // Chặn không cho gửi form
        alert("Vui lòng chọn ít nhất một sản phẩm để tạo đơn hàng!");
        return false;
    }

    // Nếu ok thì cho qua
    return true;
}


function filterOrders() {
    const searchText = document.getElementById('orderSearch').value.toLowerCase();
    const statusFilter = document.getElementById('orderStatusFilter').value; // Không toLowerCase vì value trong option khớp với text hiển thị

    // 2. Lấy bảng và các dòng dữ liệu
    const tableBody = document.getElementById('ordersTableBody');
    const rows = tableBody.getElementsByTagName('tr');

    let hasResult = false; // Biến kiểm tra xem có tìm thấy dòng nào không

    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];

        // Bỏ qua dòng thông báo "No orders found" hoặc dòng loading nếu có
        if (row.cells.length < 2)
            continue;

        // Lấy nội dung các cột cần tìm (Dựa trên thứ tự cột trong thead cũ của bạn)
        // Cột 1: Order Code (index 1)
        // Cột 2: Customer Name (index 2)
        // Cột 6: Status (index 6) - Chứa text trạng thái

        const orderCode = (row.cells[1] && row.cells[1].textContent) ? row.cells[1].textContent.toLowerCase() : "";
        const customerName = (row.cells[2] && row.cells[2].textContent) ? row.cells[2].textContent.toLowerCase() : "";
        const statusText = (row.cells[6] && row.cells[6].textContent) ? row.cells[6].textContent.trim() : "";

        // 4. Kiểm tra điều kiện
        // Điều kiện 1: Search text khớp với Code HOẶC Customer
        const matchesSearch = orderCode.includes(searchText) || customerName.includes(searchText);

        // Điều kiện 2: Status filter khớp (hoặc chọn All)
        const matchesStatus = statusFilter === "" || statusText.includes(statusFilter);

        // 5. Ẩn/Hiện dòng
        if (matchesSearch && matchesStatus) {
            row.style.display = ""; // Hiện lại
            hasResult = true;
        } else {
            row.style.display = "none"; // Ẩn đi
        }
    }
    // Kiểm tra xem đã có dòng thông báo "No result" chưa
    let noResultRow = document.getElementById('no-result-row');

    if (!hasResult) {
        if (!noResultRow) {
            noResultRow = document.createElement('tr');
            noResultRow.id = 'no-result-row';
            noResultRow.innerHTML = `
                    <td colspan="8" class="text-center py-8 text-gray-500">
                        <div class="flex flex-col items-center justify-center">
                            <svg class="w-12 h-12 text-gray-300 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                            <p>No orders found matching your criteria.</p>
                        </div>
                    </td>
                `;
            tableBody.appendChild(noResultRow);
        } else {
            noResultRow.style.display = ""; // Hiện thông báo nếu đã có
        }
    } else {
        if (noResultRow) {
            noResultRow.style.display = "none"; // Ẩn thông báo đi nếu tìm thấy
        }
    }
}


// Hàm tính tiền (Giữ nguyên logic cũ nhưng selector class mới)
function updateOrderTotals() {
    let subtotal = 0;
    document.querySelectorAll('.product-row').forEach(row => {
        const price = parseFloat(row.querySelector('.row-price-hidden').value) || 0;
        const qty = parseInt(row.querySelector('.row-qty-input').value) || 0;
        subtotal += price * qty;
    });

    const shippingInput = document.getElementById('shippingFeeInput');
    const shippingFee = shippingInput ? parseFloat(shippingInput.value) || 0 : 0;
    const total = subtotal + shippingFee;

    // Cập nhật text hiển thị (Lưu ý: Bạn cần chắc chắn ID lbl_subtotal và lbl_total có trong HTML)
    if (document.getElementById('lbl_subtotal'))
        document.getElementById('lbl_subtotal').innerText = subtotal.toLocaleString('vi-VN', {style: 'currency', currency: 'VND'});

    if (document.getElementById('lbl_total'))
        document.getElementById('lbl_total').innerText = total.toLocaleString('vi-VN', {style: 'currency', currency: 'VND'});
}




const STATUS_RULES = {
    'PENDING': ['PROCESSING', 'PAID', 'CANCELLED'],
    'PROCESSING': ['SHIPPED', 'COMPLETED', 'PAID', 'CANCELLED'],
    'SHIPPED': ['COMPLETED', 'PAID'], // Shipped rồi thì chỉ có thể Hoàn thành hoặc Trả tiền
    'COMPLETED': ['PAID'], // Xong việc thì chỉ còn trả tiền (nếu chưa)
    'PAID': ['PROCESSING', 'SHIPPED', 'COMPLETED'], // Đã trả tiền thì làm tiếp quy trình
    'CANCELLED': [] // Đã hủy thì đứng yên
};

function closeOrderDetailModal() {
    const modal = document.getElementById('orderDetailModal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
}

function renderStatusOptions(currentStatus) {
    const container = document.getElementById('status-actions-container');
    container.innerHTML = ''; // Xóa các nút cũ

    // Cập nhật badge hiển thị trạng thái hiện tại trong body modal
    const statusBadge = document.getElementById('od_current_status_badge');
    if (statusBadge)
        statusBadge.innerText = currentStatus;

    // Lấy danh sách các trạng thái được phép chuyển tới
    const allowedNextSteps = STATUS_RULES[currentStatus] || [];

    if (allowedNextSteps.length > 0) {
        // Tạo nút bấm cho từng trạng thái tiếp theo
        allowedNextSteps.forEach(status => {
            if (status !== currentStatus) {
                // Logic màu sắc nút bấm cho trực quan
                let btnColor = 'bg-blue-600 hover:bg-blue-700'; // Mặc định xanh
                if (status === 'CANCELLED')
                    btnColor = 'bg-red-500 hover:bg-red-600'; // Hủy thì màu đỏ
                if (status === 'COMPLETED' || status === 'PAID')
                    btnColor = 'bg-green-600 hover:bg-green-700'; // Thành công màu xanh lá

                const btnHtml = `
                    <button onclick="updateOrderStatus('${status}', this)" 
                            class="status-action-btn px-4 py-2 ${btnColor} text-white font-medium rounded shadow-sm transition flex items-center gap-1 whitespace-nowrap text-sm">
                        <span>Sang <strong>${status}</strong></span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" /></svg>
                    </button>
                `;
                container.insertAdjacentHTML('beforeend', btnHtml);
            }
        });
    } else {
        // Nếu không còn bước nào (ví dụ Cancelled)
        container.innerHTML = `<span class="text-gray-400 italic font-medium px-3 text-sm">Không thể thay đổi trạng thái</span>`;
    }
}

function viewOrderDetails(orderId) {
    // Lưu ID vào input ẩn để dùng khi update
    document.getElementById('od_hidden_id').value = orderId;

    // Reset và hiện Modal
    const modal = document.getElementById('orderDetailModal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');

    // Set trạng thái Loading
    document.getElementById('od_items').innerHTML = '<tr><td colspan="4" class="text-center py-8 text-gray-400">Đang tải dữ liệu...</td></tr>';
    document.getElementById('od_code').innerText = 'Loading...';
    document.getElementById('status-actions-container').innerHTML = ''; // Xóa nút cũ

    // GỌI API: GET /api/GetOrderDetail
    fetch(window.contextPath + '/api/GetOrderDetail?id=' + orderId)
            .then(res => {
                if (!res.ok)
                    throw new Error("Network response was not ok");
                return res.json();
            })
            .then(data => {
                // A. Đổ dữ liệu thông tin chung
                document.getElementById('od_code').innerText = data.orderCode;
                document.getElementById('od_customer').innerText = data.customerName;

                document.getElementById('od_address').innerText = data.shippingAddressLine || 'Nhận tại cửa hàng / Không có địa chỉ';
                document.getElementById('od_phone').innerText = data.customerPhone || 'Không có SĐT';

                const dateObj = new Date(data.createdAt);
                document.getElementById('od_created').innerText = dateObj.toLocaleString('vi-VN');
                document.getElementById('od_total').innerText = data.totalAmount.toLocaleString('vi-VN', {style: 'currency', currency: 'VND'});

                // B. Vẽ các nút chuyển trạng thái
                renderStatusOptions(data.orderStatus);

                // C. Đổ dữ liệu bảng sản phẩm
                const tbody = document.getElementById('od_items');
                tbody.innerHTML = '';

                if (data.items && data.items.length > 0) {
                    data.items.forEach(item => {
                        // Logic tính lineTotal (nếu server chưa trả về thì tự tính)
                        const lineTotal = item.lineTotal || (item.unitPrice * item.quantity);

                        const row = `
                        <tr class="border-b bg-white hover:bg-gray-50 transition-colors">
                            <td class="px-4 py-3">
                                <div class="font-medium text-gray-900">${item.productName}</div>
                                <div class="text-xs text-gray-500">Mã: ${item.variantId}</div>
                            </td>
                            <td class="px-4 py-3 text-right">${item.unitPrice.toLocaleString()}</td>
                            <td class="px-4 py-3 text-center font-medium bg-gray-50 text-gray-700">${item.quantity}</td>
                            <td class="px-4 py-3 text-right font-bold text-blue-600">${lineTotal.toLocaleString()}</td>
                        </tr>`;
                        tbody.insertAdjacentHTML('beforeend', row);
                    });
                } else {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4 text-gray-500">Không có sản phẩm nào.</td></tr>';
                }
            })
            .catch(err => {
                console.error('Error fetching detail:', err);
                Swal.fire('Lỗi', 'Không thể tải chi tiết đơn hàng.', 'error');
                closeOrderDetailModal();
            });
}

function updateOrderStatus(targetStatus, clickedBtn) {
    const orderId = document.getElementById('od_hidden_id').value;

    // Chặn click liên tục
    if (clickedBtn.disabled)
        return;

    // Hiệu ứng Loading trên nút
    const originalHtml = clickedBtn.innerHTML;
    clickedBtn.innerHTML = `<svg class="animate-spin h-4 w-4 text-white inline mr-1" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Xử lý...`;

    // Disable tất cả các nút để tránh xung đột
    const allBtns = document.querySelectorAll('.status-action-btn');
    allBtns.forEach(btn => btn.disabled = true);

    // GỌI API: POST /api/GetOrderDetail
    // Dữ liệu gửi đi dạng form-urlencoded: orderId=...&status=...
    fetch(window.contextPath + '/api/GetOrderDetail', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'orderId=' + encodeURIComponent(orderId) + '&status=' + encodeURIComponent(targetStatus)
    })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Cập nhật thành công!',
                        text: `Đơn hàng đã chuyển sang trạng thái ${targetStatus}.`,
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => {
                        location.reload(); // Reload trang để cập nhật danh sách
                    });
                } else {
                    throw new Error(data.message || 'Update failed');
                }
            })
            .catch(err => {
                console.error('Error updating status:', err);
                Swal.fire('Thất bại', 'Không thể cập nhật trạng thái.', 'error');

                // Reset lại nút nếu lỗi để user thử lại
                clickedBtn.innerHTML = originalHtml;
                allBtns.forEach(btn => btn.disabled = false);
            });
}

document.addEventListener('click', function (e) {

    // Kiểm tra xem cái thứ vừa được click có phải là nút ".btn-view-order" không
    const btn = e.target.closest('.btn-view-order');

    if (btn) {
        // 1. Lấy ID từ attribute data-order-id
        const orderId = btn.getAttribute('data-order-id');

        // 2. Gọi hàm mở Modal (hàm này mình đã viết ở các bước trước)
        viewOrderDetails(orderId);
    }
});