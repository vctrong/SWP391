// /assets/js/shop.js - updated: immediate AJAX for remove-filter-link and ajax-shop-link
// Assumes window.CONTEXT_PATH is set in shop.jsp before this script loads.

(function () {
    const sidebarSelector = '#shopSidebar';
    const productsSelector = '#productsSection';
    const filterFormSelector = '#filterForm';
    const sortFormSelector = '#sortForm';
    let debounceTimer = null;

    function buildUrlFromForms() {
        const CONTEXT_PATH = window.CONTEXT_PATH || '';
        const base = new URL(CONTEXT_PATH + '/shop', window.location.origin).toString();
        const url = new URL(base);
        const filterForm = document.querySelector(filterFormSelector);
        const sortForm = document.querySelector(sortFormSelector);
        const forms = [filterForm, sortForm].filter(Boolean);

        forms.forEach(form => {
            const fd = new FormData(form);
            if (fd.get('minPrice') === '') fd.delete('minPrice');
            if (fd.get('maxPrice') === '') fd.delete('maxPrice');

            for (const [k, v] of fd.entries()) {
                if (k === 'page') continue;
                url.searchParams.append(k, v);
            }
        });

        return url.toString();
    }

    function resolveHref(href) {
        try {
            return new URL(href, window.location.href).toString();
        } catch (e) {
            return null;
        }
    }

    function isShopUrl(urlString) {
        try {
            const u = new URL(urlString);
            const ctx = window.CONTEXT_PATH || '';
            // Allow both /ctx/shop and /shop (if deployed at root)
            return u.pathname === (ctx + '/shop') || u.pathname.endsWith('/shop');
        } catch (e) {
            return false;
        }
    }

    function showLoading(show) {
        let el = document.getElementById('shop-ajax-loader');
        if (show) {
            if (!el) {
                el = document.createElement('div');
                el.id = 'shop-ajax-loader';
                el.style.position = 'fixed';
                el.style.top = '12px';
                el.style.right = '12px';
                el.style.padding = '6px 10px';
                el.style.background = 'rgba(0,0,0,0.7)';
                el.style.color = '#fff';
                el.style.borderRadius = '6px';
                el.style.zIndex = '9999';
                el.textContent = 'Đang tải...';
                document.body.appendChild(el);
            }
        } else {
            if (el) el.remove();
        }
    }

    function parseAndReplace(htmlText, pushState = true, targetUrl = null) {
        const parser = new DOMParser();
        const doc = parser.parseFromString(htmlText, 'text/html');

        const newSidebar = doc.querySelector(sidebarSelector);
        const newProducts = doc.querySelector(productsSelector);

        const currentSidebar = document.querySelector(sidebarSelector);
        const currentProducts = document.querySelector(productsSelector);

        if (newSidebar && currentSidebar) currentSidebar.innerHTML = newSidebar.innerHTML;
        if (newProducts && currentProducts) currentProducts.innerHTML = newProducts.innerHTML;

        if (pushState) {
            try {
                const urlToPush = targetUrl || buildUrlFromForms();
                history.pushState({}, '', urlToPush);
            } catch (e) { /* ignore */ }
        }

        // re-bind events on updated DOM
        initShopAjax();
    }

    function fetchAndReplace(url, pushState = true) {
        showLoading(true);
        fetch(url, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
            credentials: 'same-origin'
        })
            .then(resp => {
                if (!resp.ok) throw new Error('Network response was not ok');
                return resp.text();
            })
            .then(html => parseAndReplace(html, pushState, url))
            .catch(err => {
                console.error('Fetch error:', err);
                // fallback full navigation
                window.location.href = url;
            })
            .finally(() => showLoading(false));
    }

    function validatePriceRange(minVal, maxVal) {
        if (minVal && maxVal && parseInt(minVal) > parseInt(maxVal)) {
            alert('Giá từ không được lớn hơn giá đến.');
            return false;
        }
        if (minVal && parseInt(minVal) < 0) {
            alert('Giá không được âm.');
            return false;
        }
        return true;
    }

    function initPriceSlider() {
        const sliderEl = document.getElementById('priceSlider');
        if (!sliderEl || typeof noUiSlider === 'undefined') return;

        if (sliderEl.noUiSlider) sliderEl.noUiSlider.destroy();

        const min = parseInt(sliderEl.getAttribute('data-min') || '0', 10);
        const max = parseInt(sliderEl.getAttribute('data-max') || '1000000', 10);
        const startMin = parseInt(sliderEl.getAttribute('data-start-min') || min, 10);
        const startMax = parseInt(sliderEl.getAttribute('data-start-max') || max, 10);

        const minInput = document.getElementById('minPriceInput');
        const maxInput = document.getElementById('maxPriceInput');

        noUiSlider.create(sliderEl, {
            start: [startMin, startMax],
            connect: true,
            step: 1000,
            range: { 'min': min, 'max': max },
            tooltips: [true, true],
            format: {
                to: value => Math.round(value).toLocaleString('vi-VN'),
                from: value => Number(value.replace(/\./g, ''))
            }
        });

        sliderEl.noUiSlider.on('update', (values) => {
            const v0 = parseInt(values[0].replace(/\./g, ''), 10);
            const v1 = parseInt(values[1].replace(/\./g, ''), 10);
            if (minInput) minInput.value = isNaN(v0) ? '' : v0;
            if (maxInput) maxInput.value = isNaN(v1) ? '' : v1;
        });

        if (minInput) minInput.addEventListener('change', () => {
            try { sliderEl.noUiSlider.set([minInput.value || null, null]); } catch(e) {}
        });
        if (maxInput) maxInput.addEventListener('change', () => {
            try { sliderEl.noUiSlider.set([null, maxInput.value || null]); } catch(e) {}
        });
    }

    function initShopAjax() {
        initPriceSlider();

        const sidebar = document.querySelector(sidebarSelector);
        const productsArea = document.querySelector(productsSelector);
        const filterForm = document.querySelector(filterFormSelector);
        const sortForm = document.querySelector(sortFormSelector);

        if (!sidebar || !filterForm) return;

        // checkboxes: debounce (small)
        sidebar.querySelectorAll('input[type="checkbox"]').forEach(cb => {
            cb.onchange = () => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    const url = buildUrlFromForms();
                    fetchAndReplace(url);
                }, 200);
            };
        });

        // page size select: small debounce
        const pageSizeSelect = document.getElementById('pageSizeSelect');
        if (pageSizeSelect) {
            pageSizeSelect.onchange = () => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    const url = buildUrlFromForms();
                    fetchAndReplace(url);
                }, 150);
            };
        }

        // filterForm fallback submit
        filterForm.onsubmit = (e) => {
            e.preventDefault();
            const minInput = filterForm.querySelector('input[name="minPrice"]');
            const maxInput = filterForm.querySelector('input[name="maxPrice"]');
            const minVal = minInput ? minInput.value : '';
            const maxVal = maxInput ? maxInput.value : '';
            if (!validatePriceRange(minVal, maxVal)) return;
            if (minInput && minInput.value === '') minInput.removeAttribute('name');
            if (maxInput && maxInput.value === '') maxInput.removeAttribute('name');
            const url = buildUrlFromForms();
            fetchAndReplace(url);
        };

        // apply price button: immediate (no debounce)
        const applyBtn = document.getElementById('applyPriceBtn');
        if (applyBtn) {
            applyBtn.onclick = (e) => {
                e.preventDefault();
                const minInput = filterForm.querySelector('input[name="minPrice"]');
                const maxInput = filterForm.querySelector('input[name="maxPrice"]');
                const minVal = minInput ? (minInput.value === '0' ? '' : minInput.value) : '';
                const maxVal = maxInput ? (maxInput.value === '0' ? '' : maxInput.value) : '';
                if (!validatePriceRange(minVal, maxVal)) return;
                if (minInput && minInput.value === '') minInput.removeAttribute('name');
                if (maxInput && maxInput.value === '') maxInput.removeAttribute('name');
                const url = buildUrlFromForms();
                fetchAndReplace(url);
            };
        }

        // sort select immediate
        if (sortForm) {
            const sortSelect = sortForm.querySelector('select[name="sort"]');
            if (sortSelect) {
                sortSelect.onchange = () => {
                    const url = buildUrlFromForms();
                    fetchAndReplace(url);
                };
            }
            sortForm.onsubmit = (e) => {
                e.preventDefault();
                const url = buildUrlFromForms();
                fetchAndReplace(url);
            };
        }

        // Immediate handlers for remove-filter-link (tag ×)
        sidebar.querySelectorAll('a.remove-filter-link').forEach(a => {
            a.onclick = (e) => {
                e.preventDefault();
                const resolved = resolveHref(a.getAttribute('href'));
                if (!resolved) return;
                if (isShopUrl(resolved)) fetchAndReplace(resolved);
                else window.location.href = resolved;
            };
        });

        // Immediate handlers for ajax-shop-link (brand links, pagination links)
        // This gives same instant behavior as checkboxes.
        document.querySelectorAll('a.ajax-shop-link').forEach(a => {
            a.onclick = (e) => {
                e.preventDefault();
                const resolved = resolveHref(a.getAttribute('href'));
                if (!resolved) return;
                if (isShopUrl(resolved)) {
                    fetchAndReplace(resolved);
                } else {
                    window.location.href = resolved;
                }
            };
        });

        // Delegation for other links inside sidebar/products (fallback)
        sidebar.addEventListener('click', (e) => {
            const a = e.target.closest('a');
            if (!a) return;
            if (a.classList && (a.classList.contains('remove-filter-link') || a.classList.contains('ajax-shop-link'))) return;
            const resolved = resolveHref(a.getAttribute('href'));
            if (!resolved) return;
            if (isShopUrl(resolved)) {
                e.preventDefault();
                fetchAndReplace(resolved);
            }
        });

        if (productsArea) {
            productsArea.addEventListener('click', (e) => {
                const a = e.target.closest('a');
                if (!a) return;
                if (a.classList && a.classList.contains('ajax-shop-link')) {
                    // already handled above by direct handler, but keep here for newly inserted nodes
                    return;
                }
                const resolved = resolveHref(a.getAttribute('href'));
                if (!resolved) return;
                if (isShopUrl(resolved)) {
                    e.preventDefault();
                    fetchAndReplace(resolved);
                }
            });
        }
    }

    window.addEventListener('popstate', () => {
        fetchAndReplace(window.location.href, false);
    });

    document.addEventListener('DOMContentLoaded', () => {
        initShopAjax();
    });
})();