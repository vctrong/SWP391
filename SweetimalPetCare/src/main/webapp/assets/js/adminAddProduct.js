/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function () {

    // --- 1. HÀM TRỢ GIÚP (Helpers) ---

    // Tạo Element
    function createEl(tag, className, content) {
        const el = document.createElement(tag);
        if (className)
            el.className = className;
        if (content)
            el.textContent = content;
        return el;
    }

    // Điền vào <select>
    function populateSelect(selectElement, list, valueField, textField, selectedId, defaultOptionText = 'None') {
        selectElement.innerHTML = '';
        const defaultOpt = createEl('option', '', defaultOptionText);
        defaultOpt.value = (defaultOptionText === 'None' || defaultOptionText === 'No Brand') ? '0' : '';
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

    // --- 2. LẤY ELEMENTS (Chỉ cho ADD) ---
    const addProductBtn = document.getElementById('addProductBtn');
    const addModal = document.getElementById('addModal');
    const addModalBackdrop = document.getElementById('addModalBackdrop');
    const addModalContainer = document.getElementById('addModalContainer');
    const closeAddModalBtn = document.getElementById('closeAddModalBtn');
    const footerCancelAddBtn = document.getElementById('footerCancelAddBtn');

    // Form và các nút
    const addProductForm = document.getElementById('addProductForm');
    const saveAddProductBtn = document.getElementById('saveAddProductBtn');
    const addNewVariantBtn = document.getElementById('addNewVariantBtn'); // Nút Add trong modal Add

    // Vùng chứa động
    const addVariantsContainer = document.getElementById('addVariantsContainer');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    const addProductImagesInput = document.getElementById('addProductImages');

    // Các trường <input> và <select> chính
    const addProductName = document.getElementById('addProductName');
    const addProductCode = document.getElementById('addProductCode');
    const addProductCategory = document.getElementById('addProductCategory');
    const addProductBrand = document.getElementById('addProductBrand');
    const addProductDescription = document.getElementById('addProductDescription');

    // --- 3. HÀM LOGIC (Mở/Đóng/Vẽ) ---

    /**
     * "Vẽ" một hàng/card của Variant MỚI
     * (Đây là hàm "xịn" dùng cho modal Add)
     */
    function renderAddVariantRow() {
        const rowId = `new_${Math.random().toString(36).substr(2, 9)}`;
        const row = createEl('div', 'variant-form-row p-4 border rounded-lg bg-gray-50 relative');
        row.id = rowId;

        const rowHtml = `
            <input type="hidden" name="variantId" value="0">
            
            <div class="grid grid-cols-1 md:grid-cols-4 gap-3">
                <div>
                    <label class="form-label-sm">SKU</label>
                    <input type="text" name="sku" placeholder="SKU (bắt buộc)" value="" class="input-field-sm" required>
                </div>
                <div>
                    <label class="form-label-sm">Attributes (JSON)</label>
                    <input type="text" name="attributes" placeholder='{"size":"L"}' value='' class="input-field-sm">
                </div>
                <div>
                    <label class="form-label-sm">Price (đ)</label>
                    <input type="number" step="1000" name="price" placeholder="0" value="" class="input-field-sm" required>
                </div>
                <div>
                    <label class="form-label-sm">Stock</label>
                    <input type="number" name="stock" placeholder="0" value="" class="input-field-sm" required>
                </div>
            </div>
            
            <button type="button" 
                    class="btn-delete-variant absolute -top-2 -right-2 w-7 h-7 bg-red-500 text-white rounded-full flex items-center justify-center shadow hover:bg-red-600 transition">
                <i class="fas fa-times fa-xs"></i>
            </button>
        `;
        row.innerHTML = rowHtml;

        // Gắn sự kiện SweetAlert2 cho nút Xóa
        row.querySelector('.btn-delete-variant').addEventListener('click', () => {
            Swal.fire({
                title: 'Xóa biến thể này?',
                text: "Bạn có chắc muốn xóa hàng biến thể này không?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Vâng, xóa nó!',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    row.remove();
                }
            });
        });

        addVariantsContainer.appendChild(row);
    }

    /**
     * Mở Modal Add
     */
    function openAddModal() {
        if (!addModal)
            return;

        // 1. Reset form về trạng thái trống
        addProductForm.reset();
        addVariantsContainer.innerHTML = '';
        imagePreviewContainer.innerHTML = '';
        addProductImagesInput.value = ""; // Xóa các file đã chọn

        // 2. Điền các <select> (Category/Brand) từ APP_DATA (đã tải sẵn)
        if (APP_DATA && APP_DATA.categories && addProductCategory) {
            populateSelect(addProductCategory, APP_DATA.categories, 'productCategoryId', 'categoryName', 0, 'Select Category');
        }
        if (APP_DATA && APP_DATA.brands && addProductBrand) {
            populateSelect(addProductBrand, APP_DATA.brands, 'brandId', 'brandName', 0, 'No Brand');
        }

        // 3. Tự động thêm 1 hàng variant rỗng
        renderAddVariantRow();

        // 4. Hiển thị modal
        addModal.classList.remove('hidden');
        requestAnimationFrame(() => {
            addModalBackdrop.classList.remove('opacity-0');
            addModalContainer.classList.remove('opacity-0', 'scale-95');
        });
    }

    /**
     * Đóng Modal Add
     */
    function closeAddModal() {
        if (!addModal)
            return;
        addModalContainer.classList.add('opacity-0', 'scale-95');
        addModalBackdrop.classList.add('opacity-0');
        setTimeout(() => {
            addModal.classList.add('hidden');
        }, 300);
    }

    /**
     * Xử lý Preview Ảnh
     */
    function handleImagePreview(event) {
        imagePreviewContainer.innerHTML = '';
        const files = event.target.files;

        if (files.length > 5) {
            Swal.fire('Quá nhiều ảnh!', 'Bạn chỉ có thể upload tối đa 5 ảnh.', 'warning');
            addProductImagesInput.value = "";
            return;
        }

        for (const file of files) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const previewWrapper = createEl('div', 'relative w-full aspect-square rounded-lg overflow-hidden border');
                const img = createEl('img', 'w-full h-full object-cover');
                img.src = e.target.result;
                const fileName = createEl('span', 'absolute bottom-0 left-0 right-0 bg-black/50 text-white text-xs p-1 truncate', file.name);

                previewWrapper.appendChild(img);
                previewWrapper.appendChild(fileName);
                imagePreviewContainer.appendChild(previewWrapper);
            };
            reader.readAsDataURL(file);
        }
    }

    // --- 4. GẮN SỰ KIỆN (Event Listeners) ---

    // (Thêm 'if' để kiểm tra element tồn tại, giúp tránh lỗi)
    if (addProductBtn) {
        addProductBtn.addEventListener('click', openAddModal);
    }
    if (closeAddModalBtn) {
        closeAddModalBtn.addEventListener('click', closeAddModal);
    }
    if (footerCancelAddBtn) {
        footerCancelAddBtn.addEventListener('click', closeAddModal);
    }
    if (addModalContainer && addModalContainer.parentElement) {
        addModalContainer.parentElement.addEventListener('click', (event) => {
            if (event.target === addModalContainer.parentElement) {
                closeAddModal();
            }
        });
    }
    if (addNewVariantBtn) {
        addNewVariantBtn.addEventListener('click', renderAddVariantRow);
    }
    if (addProductImagesInput) {
        addProductImagesInput.addEventListener('change', handleImagePreview);
    }

    // --- Listener cho SUBMIT FORM ADD (Multipart/Form-Data) ---
    if (addProductForm) {
        addProductForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            // Hỏi xác nhận
            Swal.fire({
                title: 'Tạo sản phẩm mới?',
                text: "Bạn có chắc muốn thêm sản phẩm này vào CSDL không?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Vâng, tạo mới!'
            }).then(async (result) => {
                if (result.isConfirmed) {
                    saveAddProductBtn.disabled = true;
                    saveAddProductBtn.textContent = 'Saving...';

                    // Tạo FormData
                    const formData = new FormData();

                    // 1. Thêm dữ liệu chính
                    formData.append('productName', addProductName.value);
                    formData.append('productCode', addProductCode.value);
                    formData.append('categoryId', addProductCategory.value);
                    formData.append('brandId', addProductBrand.value);
                    formData.append('description', addProductDescription.value);
                    formData.append('isActive', 'true');

                    // 2. Thu thập và JSON hóa các Variants
                    const variantsData = [];
                    const variantRows = addVariantsContainer.querySelectorAll('.variant-form-row');
                    variantRows.forEach(row => {
                        variantsData.push({
                            variantId: "0",
                            sku: row.querySelector('[name="sku"]').value,
                            attributeJson: row.querySelector('[name="attributes"]').value,
                            price: row.querySelector('[name="price"]').value,
                            stockQuantity: row.querySelector('[name="stock"]').value
                        });
                    });
                    formData.append('variantsJson', JSON.stringify(variantsData));

                    // 3. Thêm file ảnh
                    const imageFiles = addProductImagesInput.files;
                    for (let i = 0; i < imageFiles.length; i++) {
                        formData.append('images', imageFiles[i]);
                    }

                    // 4. Gửi AJAX (POST) đến Servlet mới
                    try {
                        const response = await fetch(`${contextPath}/api/ProductAddAPI`, {
                            method: 'POST',
                            body: formData
                        });

                        const result = await response.json();

                        if (response.ok) {
                            Swal.fire('Thành công!', 'Sản phẩm mới đã được tạo.', 'success');
                            closeAddModal();
                            // Tải lại bảng (cần fetchProducts từ file kia)
                            // Nếu file này tách biệt, chúng ta tải lại trang
                            window.location.reload();
                        } else {
                            throw new Error(result.error || 'Failed to create product');
                        }
                    } catch (error) {
                        Swal.fire('Thất bại!', error.message, 'error');
                    } finally {
                        saveAddProductBtn.disabled = false;
                        saveAddProductBtn.textContent = 'Save Product';
                    }
                }
            });
        });
    }
});