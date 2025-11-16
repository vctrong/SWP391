/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function () {

    // --- 0. XỬ LÝ THÔNG BÁO (SWEETALERT2) ---
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');

    if (status) {
        let title = '', text = '', icon = '';
        switch (status) {
            case 'success':
                title = 'Success!';
                text = 'User has been saved successfully.';
                icon = 'success';
                break;
            case 'updated': // Thêm case updated
                title = 'Success!';
                text = 'User information updated.';
                icon = 'success';
                break;
            case 'fail':
                title = 'Failed!';
                text = 'Action failed. Please try again.';
                icon = 'error';
                break;
            case 'error':
                title = 'Error!';
                text = 'System error occurred.';
                icon = 'error';
                break;
        }
        if (icon) {
            Swal.fire({title, text, icon, confirmButtonText: 'OK', confirmButtonColor: '#2563EB', timer: 3000, timerProgressBar: true});
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }

    // --- 1. STATE MANAGEMENT ---
    let fullData = [];
    let state = {
        roleId: 1,
        currentPage: 1,
        pageSize: 10,
        searchQuery: ""
    };

    // --- 2. DOM ELEMENTS (KHAI BÁO 1 LẦN DUY NHẤT TẠI ĐÂY) ---
    const tabs = document.querySelectorAll('.tabBtn');
    const tableBody = document.getElementById('peopleTableBody');
    const searchInput = document.getElementById('personSearch');
    const pageSizeSelect = document.getElementById('pageSizeSelect');
    const paginationControls = document.getElementById('paginationControls');
    const pageInfo = document.getElementById('pageInfo');

    // Modal Elements
    const modal = document.getElementById('addPersonModal');
    const openModalBtn = document.getElementById('addPeopleBtn');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const cancelModalBtn = document.getElementById('cancelModalBtn');

    // Form Logic Elements
    const roleSelectInput = document.getElementById('roleSelect');
    const staffFieldsDiv = document.getElementById('staffFields');
    const vetSpecificFieldsDiv = document.getElementById('vetSpecificFields');

    // --- 3. HELPER FUNCTIONS ---
    const createEl = (tag, className = '', text = '') => {
        const el = document.createElement(tag);
        if (className)
            el.className = className;
        if (text)
            el.textContent = text;
        return el;
    };

    const createBadge = (text, colorClass, dotColorClass = null) => {
        const span = createEl('span', `inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium ${colorClass}`);
        if (dotColorClass) {
            const dot = createEl('span', `w-2 h-2 rounded-full ${dotColorClass}`);
            span.appendChild(dot);
        }
        span.appendChild(document.createTextNode(text));
        return span;
    };

    const formatDateForInput = (dateString) => {
        if (!dateString)
            return '';
        const date = new Date(dateString);
        return !isNaN(date) ? date.toISOString().split('T')[0] : '';
    };

    // --- 4. CHỨC NĂNG EDIT USER ---
    const openEditModal = (userId) => {
        const user = fullData.find(u => u.userId === userId);
        if (!user)
            return;

        // 1. Đổi giao diện Modal
        const modalTitle = document.querySelector('#addPersonModal h3');
        if (modalTitle)
            modalTitle.textContent = 'Edit User';

        const actionInput = document.querySelector('input[name="action"]');
        if (actionInput)
            actionInput.value = 'update';

        // Input hidden ID
        let idInput = document.querySelector('input[name="user_id"]');
        if (!idInput) {
            idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'user_id';
            document.getElementById('addPersonForm').appendChild(idInput);
        }
        idInput.value = user.userId;

        // 2. Ẩn Password
        const passInput = document.querySelector('input[name="password"]');
        if (passInput) {
            const container = passInput.closest('div'); // Tìm div bao ngoài
            if (container)
                container.style.display = 'none';
            passInput.required = false;
            passInput.disabled = true;
        }

        // 3. Điền dữ liệu
        const form = document.getElementById('addPersonForm');
        const usernameInput = form.querySelector('input[name="username"]');
        if (usernameInput) {
            usernameInput.value = user.username;
            usernameInput.readOnly = true;
            usernameInput.classList.add('bg-gray-100', 'cursor-not-allowed');
        }

        form.querySelector('input[name="email"]').value = user.email;
        form.querySelector('input[name="full_name"]').value = user.fullName;
        form.querySelector('input[name="phone"]').value = user.phone || '';

        const genderVal = user.gender === 1 ? '1' : '0';
        const radio = form.querySelector(`input[name="gender"][value="${genderVal}"]`);
        if (radio)
            radio.checked = true;

        // 4. Trigger Role Change
        if (roleSelectInput) {
            roleSelectInput.value = user.roleId;
            roleSelectInput.dispatchEvent(new Event('change'));
        }

        // 5. Điền thông tin phụ (dùng timeout để đợi UI ẩn hiện xong)
        setTimeout(() => {
            if (user.positionTitle)
                form.querySelector('input[name="position_title"]').value = user.positionTitle;
            if (user.hireDate)
                form.querySelector('input[name="hire_date"]').value = formatDateForInput(user.hireDate);
            if (user.specialty)
                form.querySelector('input[name="specialty"]').value = user.specialty;
            if (user.licenseNumber)
                form.querySelector('input[name="license_number"]').value = user.licenseNumber;
        }, 0);

        toggleModal(true);
    };

    // --- 5. CORE FUNCTIONS (Render) ---
    function renderApp() {
        const query = state.searchQuery.toLowerCase().trim();
        const filteredData = query === "" ? fullData : fullData.filter(user => {
            const name = (user.fullName || "").toLowerCase();
            const email = (user.email || "").toLowerCase();
            const username = (user.username || "").toLowerCase();
            return name.includes(query) || email.includes(query) || username.includes(query);
        });

        const totalItems = filteredData.length;
        const totalPages = Math.ceil(totalItems / state.pageSize);

        if (state.currentPage > totalPages)
            state.currentPage = 1;
        if (state.currentPage < 1 && totalPages > 0)
            state.currentPage = 1;

        const startIndex = (state.currentPage - 1) * state.pageSize;
        const endIndex = Math.min(startIndex + state.pageSize, totalItems);
        const pageData = filteredData.slice(startIndex, endIndex);

        renderTable(pageData);
        renderPagination(totalPages, totalItems, startIndex, endIndex);
    }

    function renderTable(data) {
        tableBody.replaceChildren();

        if (data.length === 0) {
            const tr = createEl('tr');
            const td = createEl('td', 'text-center py-10 text-gray-500', 'No users found.');
            td.colSpan = 5;
            tr.appendChild(td);
            tableBody.appendChild(tr);
            return;
        }

        data.forEach(user => {
            const tr = createEl('tr', 'hover:bg-gray-50 transition-colors border-b last:border-b-0');

            // User Info
            const tdInfo = createEl('td', 'px-6 py-4');
            tdInfo.append(createEl('div', 'font-medium text-gray-900', user.fullName), createEl('div', 'text-xs text-gray-500', `@${user.username}`));
            if (user.specialty)
                tdInfo.appendChild(createEl('div', 'text-xs text-purple-600 mt-1', `⚕️ Spec: ${user.specialty}`));
            else if (user.positionTitle)
                tdInfo.appendChild(createEl('div', 'text-xs text-orange-600 mt-1', `💼 Pos: ${user.positionTitle}`));
            tr.appendChild(tdInfo);

            // Contact
            const tdContact = createEl('td', 'px-6 py-4');
            tdContact.append(createEl('div', 'text-sm text-gray-900', user.email), createEl('div', 'text-xs text-gray-500', user.phone || ''));
            tr.appendChild(tdContact);

            // Role
            const tdRole = createEl('td', 'px-6 py-4 text-center');
            let roleClass = 'bg-gray-100 text-gray-800';
            if (user.roleId === 1)
                roleClass = 'bg-blue-50 text-blue-700 border border-blue-200';
            else if (user.roleId === 2)
                roleClass = 'bg-orange-50 text-orange-700 border border-orange-200';
            else if (user.roleId === 3)
                roleClass = 'bg-purple-50 text-purple-700 border border-purple-200';
            tdRole.appendChild(createBadge(user.roleName || 'Unknown', roleClass));
            tr.appendChild(tdRole);

            // Status
            const tdStatus = createEl('td', 'px-6 py-4 text-center');
            const statusBadge = user.isActive ? createBadge('Active', 'bg-green-100 text-green-800', 'bg-green-600') : createBadge('Inactive', 'bg-red-100 text-red-800', 'bg-red-600');
            tdStatus.appendChild(statusBadge);
            tr.appendChild(tdStatus);

            // Actions
            const tdAction = createEl('td', 'px-6 py-4 text-center');

            // [FIX] Nút Edit gọi hàm openEditModal
            const editBtn = createEl('button', 'text-blue-600 hover:text-blue-800 text-sm font-medium', 'Edit');
            editBtn.addEventListener('click', (e) => {
                e.preventDefault();
                openEditModal(user.userId); // <--- GỌI HÀM EDIT THẬT
            });
            tdAction.appendChild(editBtn);

            if (user.roleId === 2 || user.roleId === 3) {
                const scheduleBtn = createEl('button', 'text-green-600 hover:text-green-900 text-sm font-medium ml-3', 'Schedule');
                scheduleBtn.innerHTML = `<svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg> Schedule`;
                scheduleBtn.addEventListener('click', () => openScheduleModal(user.userId, user.fullName));
                tdAction.appendChild(scheduleBtn);
            }
            tr.appendChild(tdAction);
            tableBody.appendChild(tr);
        });
    }

    function renderPagination(totalPages, totalItems, startIndex, endIndex) {
        pageInfo.textContent = totalItems > 0 ? `Showing ${startIndex + 1} to ${endIndex} of ${totalItems} entries` : 'No data';
        paginationControls.replaceChildren();
        if (totalPages <= 1)
            return;

        const appendBtn = (page, label, isActive = false, isDisabled = false) => {
            const btn = createEl('button', `page-btn min-w-[32px] h-8 px-2 mx-0.5 text-sm border rounded-md transition-colors ${isActive ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'} ${isDisabled ? 'opacity-50 cursor-not-allowed' : ''}`, label);
            if (isDisabled)
                btn.disabled = true;
            btn.addEventListener('click', () => {
                if (page !== state.currentPage && !isDisabled) {
                    state.currentPage = page;
                    renderApp();
                }
            });
            paginationControls.appendChild(btn);
        };

        appendBtn(state.currentPage - 1, 'Prev', false, state.currentPage === 1);
        appendBtn(1, '1', state.currentPage === 1);
        if (state.currentPage > 3)
            paginationControls.appendChild(createEl('span', 'px-2 text-gray-400', '...'));

        for (let i = Math.max(2, state.currentPage - 1); i <= Math.min(totalPages - 1, state.currentPage + 1); i++) {
            appendBtn(i, i.toString(), state.currentPage === i);
        }

        if (state.currentPage < totalPages - 2)
            paginationControls.appendChild(createEl('span', 'px-2 text-gray-400', '...'));
        if (totalPages > 1)
            appendBtn(totalPages, totalPages.toString(), state.currentPage === totalPages);
        appendBtn(state.currentPage + 1, 'Next', false, state.currentPage === totalPages);
    }

    // --- 6. DATA FETCHING ---
    function loadData(roleId) {
        tableBody.replaceChildren();
        const tr = createEl('tr');
        const td = createEl('td', 'text-center py-12 text-gray-500');
        td.colSpan = 5;
        td.innerHTML = '<div class="animate-spin inline-block w-6 h-6 border-2 border-blue-600 border-t-transparent rounded-full"></div><span class="ml-2">Loading data...</span>';
        tr.appendChild(td);
        tableBody.appendChild(tr);

        // LƯU Ý: BẠN TỰ SỬA URL Ở ĐÂY NHÉ
        const servletURL = `${contextPath}/admin/GetPersonal`; // Sửa cái này theo project của bạn

        fetch(`${servletURL}?action=list&role=${roleId}`)
                .then(res => res.ok ? res.json() : Promise.reject(`HTTP error! status: ${res.status}`))
                .then(data => {
                    fullData = data;
                    state.currentPage = 1;
                    state.searchQuery = "";
                    if (searchInput)
                        searchInput.value = "";
                    renderApp();
                })
                .catch(err => {
                    console.error(err);
                    tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-red-500 py-8">Failed to load data.</td></tr>';
                });
    }

    // --- 7. EVENT LISTENERS ---
    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            tabs.forEach(t => {
                t.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600');
                t.classList.add('text-gray-500', 'border-transparent', 'hover:border-gray-300');
            });
            this.classList.add('text-blue-600', 'border-b-2', 'border-blue-600');
            this.classList.remove('text-gray-500', 'border-transparent', 'hover:border-gray-300');
            state.roleId = parseInt(this.getAttribute('data-role-id'));
            loadData(state.roleId);
        });
    });

    if (searchInput)
        searchInput.addEventListener('input', (e) => {
            state.searchQuery = e.target.value;
            state.currentPage = 1;
            renderApp();
        });

    if (pageSizeSelect)
        pageSizeSelect.addEventListener('change', (e) => {
            state.pageSize = parseInt(e.target.value);
            state.currentPage = 1;
            renderApp();
        });

    // --- 8. MODAL LOGIC ---
    const toggleModal = (show) => {
        if (show) {
            modal.classList.remove('hidden');
            modal.classList.add('flex');
        } else {
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }
    };

    if (openModalBtn) {
        openModalBtn.addEventListener('click', (e) => {
            e.preventDefault();
            // Reset Form về chế độ Add
            document.getElementById('addPersonForm').reset();
            const modalTitle = document.querySelector('#addPersonModal h3');
            if (modalTitle)
                modalTitle.textContent = 'Add New Person';
            const actionInput = document.querySelector('input[name="action"]');
            if (actionInput)
                actionInput.value = 'add';

            // Hiện lại Password
            const passInput = document.querySelector('input[name="password"]');
            if (passInput) {
                const container = passInput.closest('div');
                if (container)
                    container.style.display = 'block';
                passInput.required = true;
                passInput.disabled = false;
            }

            // Unlock Username
            const userInput = document.querySelector('input[name="username"]');
            if (userInput) {
                userInput.readOnly = false;
                userInput.classList.remove('bg-gray-100', 'cursor-not-allowed');
            }

            // Reset Role ẩn hiện
            if (roleSelectInput) {
                roleSelectInput.value = '1';
                roleSelectInput.dispatchEvent(new Event('change'));
            }
            toggleModal(true);
        });
    }

    if (closeModalBtn)
        closeModalBtn.addEventListener('click', () => toggleModal(false));
    if (cancelModalBtn)
        cancelModalBtn.addEventListener('click', () => toggleModal(false));
    window.addEventListener('click', (e) => {
        if (e.target === modal)
            toggleModal(false);
    });

    // --- 9. LOGIC ẨN HIỆN FORM STAFF/VET (ĐÃ SỬA) ---
    if (roleSelectInput && staffFieldsDiv && vetSpecificFieldsDiv) {
        roleSelectInput.addEventListener('change', function () {
            const val = parseInt(this.value);

            // 1. Khung chung Staff
            if (val === 2 || val === 3) {
                staffFieldsDiv.classList.remove('hidden');
            } else {
                staffFieldsDiv.classList.add('hidden');
                staffFieldsDiv.querySelectorAll('input').forEach(i => i.value = '');
            }

            // 2. Khung riêng Vet
            if (val === 3) {
                vetSpecificFieldsDiv.classList.remove('hidden');
            } else {
                vetSpecificFieldsDiv.classList.add('hidden');
                vetSpecificFieldsDiv.querySelectorAll('input').forEach(i => i.value = '');
            }
        });
    }

    // INIT LOAD
    loadData(state.roleId);
});

// --- GLOBAL FUNCTIONS (Cho Schedule Modal) ---
// Để global vì có thể được gọi từ các nơi khác hoặc sự kiện inline cũ
function openScheduleModal(staffId, staffName) {
    const modal = document.getElementById('scheduleModal');
    const idInput = document.getElementById('scheduleStaffId');
    const nameSpan = document.getElementById('modalStaffName');

    document.getElementById('generateScheduleForm').reset();

    if (idInput)
        idInput.value = staffId;
    if (nameSpan)
        nameSpan.innerText = staffName;

    const today = new Date().toISOString().split('T')[0];
    const startInp = document.querySelector('input[name="startDate"]');
    const endInp = document.querySelector('input[name="endDate"]');
    if (startInp) {
        startInp.min = today;
        startInp.value = today;
    }
    if (endInp) {
        endInp.min = today;
    }

    if (modal)
        modal.classList.remove('hidden');
}

function closeScheduleModal() {
    const modal = document.getElementById('scheduleModal');
    if (modal)
        modal.classList.add('hidden');
}

function submitSchedule(event) {
    event.preventDefault();
    const form = event.target;
    const formData = new URLSearchParams(new FormData(form));

    Swal.fire({
        title: 'Processing...',
        text: 'Generating schedule slots.',
        allowOutsideClick: false,
        didOpen: () => Swal.showLoading()
    });

    // SỬA LỖI URL: Dùng đường dẫn tương đối
    // Giả sử servlet map tại /api/GenerateSchedule
    const url = '../api/GenerateSchedule';

    fetch(url, {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: formData
    })
            .then(res => res.ok ? res.json() : Promise.reject('Network Error'))
            .then(data => {
                if (data.success) {
                    Swal.fire('Success!', `Created ${data.count} slots!`, 'success');
                    closeScheduleModal();
                } else {
                    Swal.fire('Error!', data.message || 'Failed.', 'error');
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire('Connection Error!', 'Cannot reach server.', 'error');
            });
}