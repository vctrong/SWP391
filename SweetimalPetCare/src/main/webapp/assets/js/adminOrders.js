// adminOrders.js: fetch and render admin orders with paging and filters
(function(){
    const get = (sel) => document.querySelector(sel);
    const tbody = get('#ordersTableBody');
    const pageInfo = get('#ordersPageInfo');
    const paginationEl = get('#ordersPaginationControls');
    const pageSizeEl = get('#ordersPageSize');
    const searchEl = get('#orderSearch');
    const statusEl = get('#orderStatusFilter');

    let page = 1;

    function formatCurrency(v){
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0);
    }

    function renderRows(rows){
        if(!tbody) return;
        tbody.innerHTML = '';
        if(!rows || rows.length === 0){
            tbody.innerHTML = '<tr><td colspan="7" class="text-center">No orders</td></tr>';
            return;
        }
        const base = (window.contextPath || '');
        for(const r of rows){
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${escapeHtml(r.orderCode)}</td>
                <td>${escapeHtml(r.customerName || '')}</td>
                <td>${escapeHtml(r.createdAt || '')}</td>
                <td>${formatCurrency(r.totalAmount)}</td>
                <td>${escapeHtml(r.paymentMethod || '')}</td>
                <td>${escapeHtml(r.status || '')}</td>
                <td>
                    <button class="btn btn-sm btn-secondary details-btn" data-id="${r.orderId}">Details</button>
                </td>
            `;
            tbody.appendChild(tr);
        }
        // attach handlers for details buttons
        const detailBtns = document.querySelectorAll('.details-btn');
        detailBtns.forEach(b => {
            b.addEventListener('click', (e) => {
                const id = b.getAttribute('data-id');
                openDetails(id);
            });
        });
    }

    function escapeHtml(s){
        if(s == null) return '';
        return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function renderPagination(total, pageSize){
        if(!paginationEl || !pageInfo) return;
        const pages = Math.max(1, Math.ceil((total||0) / pageSize));
        paginationEl.innerHTML = '';
        for(let i=1;i<=pages;i++){
            const li = document.createElement('li');
            li.className = 'page-item' + (i===page ? ' active' : '');
            li.innerHTML = `<a class="page-link" href="#">${i}</a>`;
            li.addEventListener('click', (e)=>{ e.preventDefault(); page = i; load(); });
            paginationEl.appendChild(li);
        }
        pageInfo.textContent = `Page ${page} of ${pages} (${total} orders)`;
    }

    async function load(){
        if(!tbody) return;
        const pageSize = parseInt((pageSizeEl && pageSizeEl.value) || '10');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center">Loading...</td></tr>';

        const params = new URLSearchParams({ action: 'list', page: page, pageSize: pageSize });
        if(searchEl && searchEl.value) params.set('search', searchEl.value);
        if(statusEl && statusEl.value) params.set('status', statusEl.value);

        try{
            const base = (window.contextPath || '');
            const res = await fetch(base + '/admin/GetOrders?' + params.toString(), { credentials: 'same-origin' });
            if(!res.ok) throw new Error('Network error');
            const json = await res.json();
            renderRows(json.data || []);
            renderPagination(json.total || 0, pageSize);
        }catch(err){
            console.error(err);
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Failed to load orders</td></tr>';
            if(pageInfo) pageInfo.textContent = '';
        }
    }

    // show / hide modal helpers and details fetch
    function showModal() {
        const m = document.getElementById('orderDetailModal');
        if (m) m.classList.remove('hidden');
    }
    function hideModal() {
        const m = document.getElementById('orderDetailModal');
        if (m) m.classList.add('hidden');
    }

    async function openDetails(orderId) {
        if (!orderId) return;
        const base = (window.contextPath || '');
        const tbodyItems = document.getElementById('od_items');
        const od_code = document.getElementById('od_code');
        const od_customer = document.getElementById('od_customer');
        const od_created = document.getElementById('od_created');
        const od_total = document.getElementById('od_total');
        const od_status = document.getElementById('od_status');
        const od_save = document.getElementById('od_save_status');

        try {
            const res = await fetch(base + '/admin/GetOrderDetails?orderId=' + encodeURIComponent(orderId), { credentials: 'same-origin' });
            if (!res.ok) throw new Error('Failed to fetch');
            const json = await res.json();
            const o = json.order;
            const items = json.items || [];
            if (od_code) od_code.textContent = o.orderCode || '';
            if (od_customer) od_customer.textContent = o.customerName || '';
            if (od_created) od_created.textContent = o.createdAt || '';
            if (od_total) od_total.textContent = formatCurrency(o.totalAmount || 0);
            if (od_status) od_status.value = o.orderStatus || o.orderStatus || '';
            if (tbodyItems) {
                tbodyItems.innerHTML = '';
                if (items.length === 0) {
                    tbodyItems.innerHTML = '<tr><td colspan="4" class="text-center">No items</td></tr>';
                } else {
                    for (const it of items) {
                        const tr = document.createElement('tr');
                        tr.innerHTML = `<td>${escapeHtml(it.productName || '')}</td><td class="text-right">${formatCurrency(it.unitPrice)}</td><td class="text-right">${it.quantity}</td><td class="text-right">${formatCurrency(it.lineTotal)}</td>`;
                        tbodyItems.appendChild(tr);
                    }
                }
            }
            showModal();

            // attach save handler
            if (od_save) {
                od_save.onclick = async function () {
                    const newStatus = od_status.value;
                    try {
                        const resp = await fetch(base + '/admin/UpdateOrderStatus', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            credentials: 'same-origin',
                            body: 'orderId=' + encodeURIComponent(orderId) + '&status=' + encodeURIComponent(newStatus)
                        });
                        if (!resp.ok) throw new Error('Failed to update');
                        const j = await resp.json().catch(()=>({}));
                        // refresh list
                        load();
                        hideModal();
                    } catch (err) {
                        console.error(err);
                        alert('Failed to update status');
                    }
                };
            }

        } catch (err) {
            console.error(err);
            alert('Failed to load order details');
        }
    }

    // bind modal close
    document.addEventListener('DOMContentLoaded', ()=>{
        const close = document.getElementById('orderDetailClose');
        if (close) close.addEventListener('click', hideModal);
        const modal = document.getElementById('orderDetailModal');
        if (modal) modal.addEventListener('click', (e)=>{ if (e.target === modal) hideModal(); });
    });

    function init(){
        if(pageSizeEl) pageSizeEl.addEventListener('change', ()=>{ page = 1; load(); });
        if(searchEl) searchEl.addEventListener('input', debounce(()=>{ page = 1; load(); }, 350));
        if(statusEl) statusEl.addEventListener('change', ()=>{ page = 1; load(); });
        load();
    }

    function debounce(fn, wait){
        let t;
        return function(){ clearTimeout(t); t = setTimeout(()=>fn.apply(this, arguments), wait); };
    }

    document.addEventListener('DOMContentLoaded', init);
})();
