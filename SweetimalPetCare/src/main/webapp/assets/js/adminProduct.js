/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* global contextPath, APP_DATA */

/**
 * adminProduct.js
 * * Xử lý AJAX cho trang Quản lý Sản phẩm (products.jsp)
 * - Tải danh sách sản phẩm (load, filter, search)
 * - Xử lý phân trang (pagination)
 * - Xử lý Modal Detail (Read-only)
 * - Xử lý Modal Edit (Read/Write)
 */

document.addEventListener('DOMContentLoaded', function () {

    // 1. LẤY ELEMENTS
    // --- Elements Chung (Bảng, Filter, Search) ---
    const tableBody = document.getElementById('productsTableBody');
    const categoryFilter = document.getElementById('categoryFilter');
    const searchInput = document.getElementById('productSearch');
    const pageSizeSelector = document.getElementById('pageSizeSelector');

    // --- Elements Pagination ---
    const paginationControls = document.getElementById('paginationControls');
    const pageInfo = document.getElementById('pageInfo');
    const pageButtons = document.getElementById('pageButtons');

    // --- Elements Modal Detail (Read-only) ---
    const detailModal = document.getElementById('detailModal');
    const modalBackdrop = document.getElementById('modalBackdrop');
    const modalContainer = document.getElementById('modalContainer');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const footerCloseBtn = document.getElementById('footerCloseBtn');
    const modalMainImage = document.getElementById('modalMainImage');
    const modalThumbnails = document.getElementById('modalThumbnails');
    const modalProductName = document.getElementById('modalProductName');
    const modalStatus = document.getElementById('modalStatus');
    const modalBrandName = document.getElementById('modalBrandName');
    const modalCategoryName = document.getElementById('modalCategoryName');
    const modalProductCode = document.getElementById('modalProductCode');
    const modalDescription = document.getElementById('modalDescription');
    const modalVariantsTableBody = document.getElementById('modalVariantsTableBody');

    // --- Elements Modal Edit (Read/Write) ---
    const editModal = document.getElementById('editModal');
    const editModalBackdrop = document.getElementById('editModalBackdrop');
    const editModalContainer = document.getElementById('editModalContainer');
    const closeEditModalBtn = document.getElementById('closeEditModalBtn');
    const footerCancelEditBtn = document.getElementById('footerCancelEditBtn');
    const editProductForm = document.getElementById('editProductForm');
    const saveProductBtn = document.getElementById('saveProductBtn');
    const addVariantBtn = document.getElementById('addVariantBtn');
    const variantsContainer = document.getElementById('variantsContainer');
    const editProductId = document.getElementById('editProductId');
    const editProductName = document.getElementById('editProductName');
    const editProductCode = document.getElementById('editProductCode');
    const editProductCategory = document.getElementById('editProductCategory');
    const editProductBrand = document.getElementById('editProductBrand');
    const editProductDescription = document.getElementById('editProductDescription');
    const editProductStatus = document.getElementById('editProductStatus');

    // 2. BIẾN TRẠNG THÁI
    let currentPage = 1;
    let currentCategory = 0;
    let currentSearch = '';
    let debounceTimeout;

    // 3. HÀM TRỢ GIÚP
    // (createEl, currencyFormatter, debounce...)

    function createEl(tag, className, content) {
        const el = document.createElement(tag);
        if (className)
            el.className = className;
        if (content)
            el.textContent = content;
        return el;
    }

    const currencyFormatter = new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        maximumFractionDigits: 0
    });

    function debounce(func, delay) {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(func, delay);
    }

    // 4. LOGIC CHÍNH: TẢI BẢNG (LIST)
    async function fetchProducts(page = 1, categoryId = 0, searchTerm = '') {
        currentPage = page;
        currentCategory = categoryId;
        currentSearch = searchTerm;
        const pageSize = pageSizeSelector.value;

        const url = `${contextPath}/api/ProductAPI?page=${page}&category=${categoryId}&search=${encodeURIComponent(searchTerm)}&pageSize=${pageSize}`;

        tableBody.innerHTML = `<tr><td colspan="8" class="p-4 text-center text-gray-500">Loading...</td></tr>`;

        try {
            const response = await fetch(url);
            if (!response.ok)
                throw new Error(`HTTP error! Status: ${response.status}`);
            const data = await response.json();

            renderTable(data.products);

            const pagination = data.pagination;
            const totalItems = pagination.totalItems;
            const totalPages = pagination.totalPages;
            const pageSizeVal = Number(pageSizeSelector.value);
            const startIndex = (pagination.currentPage - 1) * pageSizeVal;
            const endIndex = Math.min(startIndex + pageSizeVal, totalItems);

            renderPagination(totalPages, totalItems, startIndex, endIndex);
        } catch (error) {
            console.error('Lỗi khi tải sản phẩm:', error);
            tableBody.innerHTML = `<tr><td colspan="8" class="p-4 text-center text-red-500">Không thể tải dữ liệu. Vui lòng thử lại.</td></tr>`;
    }
    }

    function renderTable(products) {
        tableBody.innerHTML = '';
        if (!products || products.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="8" class="px-4 py-3 text-center text-gray-500">Không tìm thấy sản phẩm nào.</td></tr>';
            return;
        }
        products.forEach(product => {
            const variant = product.mainVariant;
            const price = variant ? currencyFormatter.format(variant.price) : 'N/A';
            const stock = variant ? variant.stockQuantity : 'N/A';
            const statusBadge = product.isActive
                    ? '<span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-700">Active</span>'
                    : '<span class="px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-700">Inactive</span>';

            const rowHtml = `
                <tr class="hover:bg-gray-50 transition">
                    <td class="px-4 py-2 text-center">${product.productId}</td>
                    <td class="px-4 py-2 font-medium text-sky-600">${product.productName}</td>
                    <td class="px-4 py-2">${product.brandName || 'N/A'}</td>
                    <td class="px-4 py-2">${product.productCategoryName || 'N/A'}</td>
                    <td class="px-4 py-2 text-right">${price}</td>
                    <td class="px-4 py-2 text-center">${stock}</td>
                    <td class="px-4 py-2 text-center">${statusBadge}</td>
                    <td class="px-4 py-2 text-center">
                        <div class="flex justify-center gap-2">
                            <button type="button" data-product-id="${product.productId}" class="btn-view-detail-ajax px-3 py-1 bg-sky-500 hover:bg-sky-600 text-white text-xs rounded-md transition-colors">Detail</button>
                            <button type="button" data-product-id="${product.productId}" class="btn-edit-ajax px-3 py-1 bg-amber-500 hover:bg-amber-600 text-white text-xs rounded-md transition-colors">Edit</button>
                        </div>
                    </td>
                </tr>`;
            tableBody.insertAdjacentHTML('beforeend', rowHtml);
        });
    }

    // 5. LOGIC MODAL DETAIL (Read-only)

    function openModal() {
        modalProductName.textContent = 'Loading...';
        modalBrandName.textContent = '...';
        modalCategoryName.textContent = '...';
        modalProductCode.textContent = '...';
        modalDescription.innerHTML = '<p>Loading details...</p>';
        modalMainImage.innerHTML = '<i class="fas fa-spinner fa-spin fa-2x text-gray-400"></i>';
        modalThumbnails.innerHTML = '';
        modalVariantsTableBody.innerHTML = `<tr><td colspan="4" class="p-4 text-center">Loading variants...</td></tr>`;

        detailModal.classList.remove('hidden');
        requestAnimationFrame(() => {
            modalBackdrop.classList.remove('opacity-0');
            modalContainer.classList.remove('opacity-0', 'scale-95');
        });
    }

    function closeModal() {
        modalContainer.classList.add('opacity-0', 'scale-95');
        modalBackdrop.classList.add('opacity-0');
        setTimeout(() => {
            detailModal.classList.add('hidden');
        }, 300);
    }

    async function loadProductDetails(productId) {
        const url = `${contextPath}/api/ProductDetailAPI?id=${productId}`;

        try {
            const response = await fetch(url);
            if (!response.ok)
                throw new Error(`HTTP error! Status: ${response.status}`);
            const data = await response.json();

            modalProductName.textContent = data.product.productName;
            modalBrandName.textContent = data.product.brandName || 'N/A';
            modalCategoryName.textContent = data.product.productCategoryName || 'N/A';
            modalProductCode.textContent = data.product.productCode;
            modalDescription.innerHTML = data.product.description || '<p><i>No description provided.</i></p>';

            if (data.product.isActive) {
                modalStatus.textContent = 'Active';
                modalStatus.className = 'px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-700';
            } else {
                modalStatus.textContent = 'Inactive';
                modalStatus.className = 'px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-700';
            }
            renderModalGallery(data.images, data.product.productName);
            renderModalVariants(data.variants);
        } catch (error) {
            console.error('Lỗi khi tải chi tiết sản phẩm:', error);
            modalProductName.textContent = 'Error';
            modalDescription.innerHTML = `<p class="text-red-500">Failed to load product details. ${error.message}</p>`;
            modalVariantsTableBody.innerHTML = `<tr><td colspan="4" class="p-4 text-center text-red-500">Error loading data.</td></tr>`;
        }
    }

    function renderModalGallery(images, altText) {
        modalMainImage.innerHTML = '';
        modalThumbnails.innerHTML = '';
        if (!images || images.length === 0) {
            modalMainImage.innerHTML = '<span class="text-gray-400">No Image</span>';
            return;
        }
        let mainImg = images.find(img => img.isMain) || images[0];
        const mainImgElement = createEl('img', 'w-full h-full object-cover rounded-lg', null);
        mainImgElement.src = mainImg.imageUrl;
        mainImgElement.alt = altText;
        modalMainImage.appendChild(mainImgElement);

        images.forEach(img => {
            const thumbBtn = createEl('button', 'aspect-square bg-gray-100 rounded-md overflow-hidden focus:outline-none focus:ring-2 focus:ring-blue-500');
            const thumbImg = createEl('img', 'w-full h-full object-cover', null);
            thumbImg.src = img.imageUrl;
            thumbImg.alt = `Thumbnail ${img.displayOrder}`;
            thumbBtn.appendChild(thumbImg);
            thumbBtn.addEventListener('click', () => {
                mainImgElement.src = img.imageUrl;
            });
            modalThumbnails.appendChild(thumbBtn);
        });
    }

    function renderModalVariants(variants) {
        modalVariantsTableBody.innerHTML = '';
        if (!variants || variants.length === 0) {
            modalVariantsTableBody.innerHTML = `<tr><td colspan="4" class="p-4 text-center text-gray-500">This product has no defined variants.</td></tr>`;
            return;
        }
        variants.forEach(variant => {
            let attributes = 'N/A';
            if (variant.attributeJson) {
                try {
                    const attrs = JSON.parse(variant.attributeJson);
                    attributes = Object.entries(attrs).map(([key, value]) => `${key}: ${value}`).join(', ');
                } catch (e) {
                    attributes = variant.attributeJson;
                }
            }
            const row = `
                <tr class="hover:bg-gray-50">
                    <td class="px-3 py-2 font-medium">${variant.sku}</td>
                    <td class="px-3 py-2 text-gray-600">${attributes}</td>
                    <td class="px-3 py-2 text-right">${currencyFormatter.format(variant.price)}</td>
                    <td class="px-3 py-2 text-center">${variant.stockQuantity}</td>
                </tr>`;
            modalVariantsTableBody.insertAdjacentHTML('beforeend', row);
        });
    }

    // 6. LOGIC MODAL EDIT (Read/Write)

    function openEditModal(productId) {
        editProductForm.reset();
        variantsContainer.innerHTML = '<div class="text-center p-4"><i class="fas fa-spinner fa-spin"></i> Loading variants...</div>';

        editModal.classList.remove('hidden');
        requestAnimationFrame(() => {
            editModalBackdrop.classList.remove('opacity-0');
            editModalContainer.classList.remove('opacity-0', 'scale-95');
        });

        // [FIX] Gọi hàm loadEditData đã được đơn giản hóa
        loadEditData(productId);
    }

    function closeEditModal() {
        editModalContainer.classList.add('opacity-0', 'scale-95');
        editModalBackdrop.classList.add('opacity-0');
        setTimeout(() => {
            editModal.classList.add('hidden');
        }, 300);
    }

    /**
     * [ĐÃ SỬA]
     * Tải chi tiết sản phẩm và điền vào form Edit.
     * Sử dụng APP_DATA (đã tải sẵn) cho Categories và Brands.
     */
    async function loadEditData(productId) {
        // [FIX 1] Chỉ cần 1 URL. Tái sử dụng Servlet Detail.
        const detailUrl = `${contextPath}/api/ProductDetailAPI?id=${productId}`;

        try {
            const response = await fetch(detailUrl);
            if (!response.ok) {
                throw new Error('Failed to load product details.');
            }

            const productData = await response.json(); // {product, variants, images}

            // [FIX 2] Không cần fetch formData. Dùng APP_DATA (đã tải sẵn)
            const formData = {
                categories: APP_DATA.categories,
                brands: APP_DATA.brands
            };

            // Dữ liệu sẵn sàng, "vẽ" lên form
            populateEditForm(productData, formData);

        } catch (error) {
            console.error('Lỗi khi tải dữ liệu Edit:', error);
            variantsContainer.innerHTML = `<div class="text-center p-4 text-red-500">Error: ${error.message}</div>`;
        }
    }

    function populateEditForm(productData, formData) {
        const {product, variants, images} = productData;

        // 1. Điền thông tin chính
        editProductId.value = product.productId;
        editProductName.value = product.productName;
        editProductCode.value = product.productCode;
        editProductDescription.value = product.description || '';
        editProductStatus.value = product.isActive ? 'true' : 'false';

        // 2. Điền và chọn các <select>
        // (Chúng ta dùng 'productCategoryName' và 'brandName' từ DTO chi tiết
        // thay vì ID, nhưng form cần ID. Dùng DTO list là tốt nhất)
        // [SỬA LẠI] - Hàm 'populateSelect' này đã có trong code của bạn và rất chính xác.
        populateSelect(editProductCategory, formData.categories, 'productCategoryId', 'categoryName', product.productCategoryId);
        populateSelect(editProductBrand, formData.brands, 'brandId', 'brandName', product.brandId, 'No Brand');

        // 3. "Vẽ" các variant hiện có
        variantsContainer.innerHTML = '';
        if (variants && variants.length > 0) {
            variants.forEach(variant => renderEditVariantRow(variant));
        } else {
            variantsContainer.innerHTML = '<div class="text-center p-4 text-gray-500">Sản phẩm này chưa có biến thể.</div>';
        }

        // (Tùy chọn: "Vẽ" thư viện ảnh edit)
    }

    /**
     * Hàm trợ giúp: "Vẽ" một hàng/card của Variant
     * @param {object | null} variant - Dữ liệu variant (hoặc null nếu là hàng mới)
     */
    function renderEditVariantRow(variant = null) {
        const isNew = variant === null;

        // Tạo một ID ngẫu nhiên cho hàng mới để dễ xóa
        const rowId = isNew ? `new_${Math.random().toString(36).substr(2, 9)}` : `variant_${variant.variantId}`;

        const row = createEl('div', 'variant-form-row p-4 border rounded-lg bg-gray-50 relative');
        row.id = rowId;

        // Chuyển JSON attributes thành string
        const attributes = isNew ? '' : (variant.attributeJson || '');

        // [SỬA LỖI] Escape giá trị 'attributes' để tránh lỗi HTML
        let attributesValue = '';
        if (!isNew && variant.attributeJson) {
            attributesValue = variant.attributeJson.replace(/'/g, "&apos;").replace(/"/g, "&quot;");
        }

        const rowHtml = `
        <input type="hidden" name="variantId" value="${isNew ? '0' : variant.variantId}">
        
        <div class="grid grid-cols-1 md:grid-cols-4 gap-3">
            <div>
                <label class="form-label-sm">SKU</label>
                <input type="text" name="sku" placeholder="SKU (bắt buộc)" value="${isNew ? '' : variant.sku}" class="input-field-sm" required>
            </div>
            <div>
                <label class="form-label-sm">Attributes (JSON)</label>
                <input type="text" name="attributes" placeholder='{"size":"L"}' value='${attributesValue}' class="input-field-sm">
            </div>
            <div>
                <label class="form-label-sm">Price (đ)</label>
                <input type="number" step="1000" name="price" placeholder="0" value="${isNew ? '' : variant.price}" class="input-field-sm" required>
            </div>
            <div>
                <label class="form-label-sm">Stock</label>
                <input type="number" name="stock" placeholder="0" value="${isNew ? '' : variant.stockQuantity}" class="input-field-sm" required>
            </div>
        </div>
        
        <button type="button" 
                class="btn-delete-variant absolute -top-2 -right-2 w-7 h-7 bg-red-500 text-white rounded-full flex items-center justify-center shadow hover:bg-red-600 transition">
            <i class="fas fa-times fa-xs"></i>
        </button>
    `;

        row.innerHTML = rowHtml;

        // [CẬP NHẬT] Gắn sự kiện click cho nút Xóa (Dùng SweetAlert2)
        row.querySelector('.btn-delete-variant').addEventListener('click', () => {

            // Thay thế confirm() bằng Swal.fire()
            Swal.fire({
                title: 'Xóa biến thể này?',
                text: "Bạn có chắc muốn xóa hàng biến thể này không?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33', // Màu đỏ
                cancelButtonColor: '#3085d6', // Màu xanh
                confirmButtonText: 'Vâng, xóa nó!',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                // Nếu người dùng nhấn "Vâng, xóa nó!"
                if (result.isConfirmed) {
                    row.remove(); // Xóa hàng khỏi DOM

                    // (Không cần thông báo thành công, vì nó chỉ xóa ở local)
                }
            });
        });

        // Thêm hàng mới vào container
        variantsContainer.appendChild(row);
    }

    function populateSelect(selectElement, list, valueField, textField, selectedId, defaultOptionText = 'None') {
        selectElement.innerHTML = '';
        const defaultOpt = createEl('option', '', defaultOptionText);
        defaultOpt.value = '0';
        selectElement.appendChild(defaultOpt);

        list.forEach(item => {
            const option = createEl('option', '', item[textField]);
            option.value = item[valueField];
            if (item[valueField] == selectedId) {
                option.selected = true;
            }
            selectElement.appendChild(option);
        });
    }

    // 7. LOGIC PAGINATION (Smart)
    function renderPagination(totalPages, totalItems, startIndex, endIndex) {
        pageInfo.textContent = totalItems > 0 ? `Showing ${startIndex + 1} to ${endIndex} of ${totalItems} results` : 'No data found';

        const pageButtonsContainer = document.getElementById('pageButtons');
        if (!pageButtonsContainer) {
            console.error("Không tìm thấy element #pageButtons");
            return;
        }
        pageButtonsContainer.replaceChildren();

        if (totalPages <= 1)
            return;

        const appendBtn = (page, label, isActive = false, isDisabled = false) => {
            const btnClass = `page-btn min-w-[32px] h-8 px-2 mx-0.5 text-sm border rounded-md transition-colors ${isActive ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'} ${isDisabled ? 'opacity-50 cursor-not-allowed' : ''}`;
            const btn = createEl('button', btnClass, label);
            if (isDisabled)
                btn.disabled = true;

            btn.addEventListener('click', () => {
                if (page !== currentPage && !isDisabled) {
                    fetchProducts(page, currentCategory, currentSearch);
                }
            });
            pageButtonsContainer.appendChild(btn);
        };

        appendBtn(currentPage - 1, 'Prev', false, currentPage === 1);
        appendBtn(1, '1', currentPage === 1);
        if (currentPage > 3) {
            pageButtonsContainer.appendChild(createEl('span', 'px-2 text-gray-400', '...'));
        }
        for (let i = Math.max(2, currentPage - 1); i <= Math.min(totalPages - 1, currentPage + 1); i++) {
            appendBtn(i, i.toString(), currentPage === i);
        }
        if (currentPage < totalPages - 2) {
            pageButtonsContainer.appendChild(createEl('span', 'px-2 text-gray-400', '...'));
        }
        if (totalPages > 1) {
            appendBtn(totalPages, totalPages.toString(), currentPage === totalPages);
        }
        appendBtn(currentPage + 1, 'Next', false, currentPage === totalPages);
    }

    // 8. GẮN SỰ KIỆN (EVENT LISTENERS)

    // --- Listeners cho Bảng chính ---
    pageSizeSelector.addEventListener('change', (e) => {
        fetchProducts(1, categoryFilter.value, searchInput.value);
    });
    categoryFilter.addEventListener('change', (e) => {
        fetchProducts(1, e.target.value, searchInput.value);
    });
    searchInput.addEventListener('keyup', (e) => {
        const searchTerm = e.target.value;
        debounce(() => {
            fetchProducts(1, categoryFilter.value, searchTerm);
        }, 400);
    });

    // --- Listeners cho các nút trong Bảng (Detail/Edit) ---
    tableBody.addEventListener('click', (e) => {
        const detailButton = e.target.closest('.btn-view-detail-ajax');
        const editButton = e.target.closest('.btn-edit-ajax');

        if (detailButton) {
            const productId = detailButton.dataset.productId;
            openModal();
            loadProductDetails(productId);
            return;
        }

        if (editButton) {
            const productId = editButton.dataset.productId;
            openEditModal(productId);
            return;
        }
    });

    // --- Listeners cho Modal Detail ---
    closeModalBtn.addEventListener('click', closeModal);
    footerCloseBtn.addEventListener('click', closeModal);
    if (modalContainer && modalContainer.parentElement) {
        modalContainer.parentElement.addEventListener('click', (event) => {
            if (event.target === modalContainer.parentElement) {
                closeModal();
            }
        });
    }

    // --- Listeners cho Modal Edit ---
    closeEditModalBtn.addEventListener('click', closeEditModal);
    footerCancelEditBtn.addEventListener('click', closeEditModal);
    if (editModalContainer && editModalContainer.parentElement) {
        editModalContainer.parentElement.addEventListener('click', (event) => {
            if (event.target === editModalContainer.parentElement) {
                closeEditModal();
            }
        });
    }
    addVariantBtn.addEventListener('click', () => {
        renderEditVariantRow(null);
    });

    // --- Listener cho SUBMIT FORM EDIT ---
    editProductForm.addEventListener('submit', async (e) => {
        e.preventDefault(); // Ngăn trang tải lại

        // [BƯỚC 1] HỎI XÁC NHẬN TRƯỚC KHI LÀM BẤT CỨ ĐIỀU GÌ
        Swal.fire({
            title: 'Lưu thay đổi?',
            text: "Bạn có chắc muốn cập nhật thông tin sản phẩm này không?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6', // Màu xanh cho nút "Lưu"
            cancelButtonColor: '#d33', // Màu đỏ cho nút "Hủy"
            confirmButtonText: 'Lưu thay đổi',
            cancelButtonText: 'Hủy'
        }).then(async (result) => {

            // Nếu người dùng nhấn "Lưu thay đổi"
            if (result.isConfirmed) {

                // [BƯỚC 2] TIẾN HÀNH GỬI DỮ LIỆU (Code cũ của bạn)
                saveProductBtn.disabled = true;
                saveProductBtn.textContent = 'Saving...';

                try {
                    // 1. Thu thập dữ liệu chính
                    const productData = {
                        productId: editProductId.value,
                        productName: editProductName.value,
                        productCode: editProductCode.value,
                        productCategoryId: editProductCategory.value,
                        brandId: editProductBrand.value,
                        description: editProductDescription.value,
                        isActive: editProductStatus.value === 'true'
                    };

                    // 2. Thu thập các variants
                    const variantsData = [];
                    const variantRows = variantsContainer.querySelectorAll('.variant-form-row');
                    variantRows.forEach(row => {
                        variantsData.push({
                            variantId: row.querySelector('[name="variantId"]').value,
                            sku: row.querySelector('[name="sku"]').value,
                            attributeJson: row.querySelector('[name="attributes"]').value,
                            price: row.querySelector('[name="price"]').value,
                            stockQuantity: row.querySelector('[name="stock"]').value
                        });
                    });

                    // 3. Gói dữ liệu
                    const payload = {
                        product: productData,
                        variants: variantsData
                    };

                    // 4. Gửi AJAX (POST)
                    const response = await fetch(`${contextPath}/api/ProductEditAPI`, {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(payload)
                    });

                    const result = await response.json();

                    if (response.ok) {
                        // [BƯỚC 3] THÔNG BÁO THÀNH CÔNG
                        closeEditModal(); // Đóng modal
                        Swal.fire(
                                'Thành công!',
                                'Sản phẩm đã được cập nhật.',
                                'success'
                                );
                        // Tải lại bảng với dữ liệu mới
                        fetchProducts(currentPage, currentCategory, currentSearch);
                    } else {
                        // Lỗi từ phía Servlet (ví dụ: Lỗi 500)
                        throw new Error(result.error || 'Failed to save product');
                    }
                } catch (error) {
                    // [BƯỚC 4] THÔNG BÁO THẤT BẠI
                    Swal.fire(
                            'Thất bại!',
                            error.message, // Hiển thị lỗi
                            'error'
                            );
                } finally {
                    // Dù thành công hay thất bại, bật lại nút Save
                    saveProductBtn.disabled = false;
                    saveProductBtn.textContent = 'Save Changes';
                }
            }
            // Nếu người dùng nhấn "Hủy", không làm gì cả
        });
    });

    // 9. KHỞI CHẠY LẦN ĐẦU
    if (tableBody) {
        fetchProducts();
    }
});