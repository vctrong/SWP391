// /assets/js/shop.js - Robust AJAX variant
// Builds URLs from current location + visible UI (checked checkboxes), toggles params reliably,
// fetches fragments and replaces sidebar + products. Assumes window.CONTEXT_PATH set in JSP.

(function () {
    const sidebarSelector = '#shopSidebar';
    const productsSelector = '#productsSection';
    const filterFormSelector = '#filterForm';
    const sortFormSelector = '#sortForm';
    let debounceTimer = null;

    // Use current location as source of truth
    function makeUrl() {
        return new URL(window.location.href);
    }

    function applyUiStateToParams(params) {
        const minInput = document.querySelector('#filterForm input[name="minPrice"]');
        const maxInput = document.querySelector('#filterForm input[name="maxPrice"]');
        const minVal = minInput ? String(minInput.value || '').trim() : '';
        const maxVal = maxInput ? String(maxInput.value || '').trim() : '';
        if (minVal !== '' && minVal !== '0') params.set('minPrice', minVal);
        else params.delete('minPrice');
        if (maxVal !== '' && maxVal !== '0') params.set('maxPrice', maxVal);
        else params.delete('maxPrice');

        const sortSelect = document.querySelector('#sortForm select[name="sort"]');
        const pageSizeSelect = document.querySelector('#pageSizeSelect');
        if (sortSelect && sortSelect.value) params.set('sort', sortSelect.value);
        else params.delete('sort');
        if (pageSizeSelect && pageSizeSelect.value) params.set('pageSize', pageSizeSelect.value);
        else params.delete('pageSize');

        params.delete('page');
    }

    function toggleParam(params, name, value, add) {
        const values = params.getAll(name);
        if (add) {
            if (!values.includes(value)) params.append(name, value);
        } else {
            const kept = values.filter(v => v !== value);
            params.delete(name);
            kept.forEach(v => params.append(name, v));
        }
    }

    function buildUrlToggleFromLocation(name, value, add) {
        const url = makeUrl();
        const params = url.searchParams;
        toggleParam(params, name, value, add);
        applyUiStateToParams(params);
        return url.toString();
    }

    function buildUrlForRemoveFromHref(href) {
        try {
            const linkUrl = new URL(href, window.location.href);
            const url = makeUrl();
            const params = url.searchParams;

            if (linkUrl.searchParams.has('removeCategory')) {
                const val = linkUrl.searchParams.get('removeCategory');
                toggleParam(params, 'category', val, false);
            }
            if (linkUrl.searchParams.has('removeBrand')) {
                const val = linkUrl.searchParams.get('removeBrand');
                toggleParam(params, 'brand', val, false);
            }
            if (linkUrl.searchParams.has('removeStock')) {
                const val = linkUrl.searchParams.get('removeStock');
                toggleParam(params, 'stock', val, false);
            }
            if (linkUrl.searchParams.has('removePrice')) {
                params.delete('minPrice');
                params.delete('maxPrice');
            }

            const hrefHasAnyParam = Array.from(linkUrl.searchParams.keys()).length > 0;
            if (!hrefHasAnyParam) {
                ['category', 'brand', 'stock', 'minPrice', 'maxPrice', 'page', 'sort'].forEach(k => params.delete(k));
                applyUiStateToParams(params);
                return url.toString();
            }

            applyUiStateToParams(params);
            return url.toString();
        } catch (err) {
            console.error('buildUrlForRemoveFromHref error', err);
            return href;
        }
    }

    function resolveHref(href) {
        try { return new URL(href, window.location.href).toString(); } catch (e) { return null; }
    }

    function isShopUrl(urlString) {
        try {
            const u = new URL(urlString);
            const ctx = window.CONTEXT_PATH || '';
            return u.pathname === (ctx + '/shop') || u.pathname.endsWith('/shop');
        } catch (e) { return false; }
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
        } else { if (el) el.remove(); }
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
                history.pushState({}, '', targetUrl || makeUrl().toString());
            } catch (e) {}
        }

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
                window.location.href = url;
            })
            .finally(() => showLoading(false));
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

        if (!sidebar) return;

        // Delegated change handler: toggle param based on current location, then fetch fragment
        sidebar.addEventListener('change', (e) => {
            const target = e.target;
            if (!target || !target.matches('input[type="checkbox"]')) return;
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                const url = buildUrlToggleFromLocation(target.name, target.value, target.checked);
                fetchAndReplace(url);
            }, 150);
        });

        // pageSize
        const pageSizeSelect = document.getElementById('pageSizeSelect');
        if (pageSizeSelect) {
            pageSizeSelect.onchange = () => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    const url = makeUrl();
                    const params = url.searchParams;
                    applyUiStateToParams(params);
                    url.search = params.toString();
                    fetchAndReplace(url.toString());
                }, 150);
            };
        }

        // filter submit
        if (filterForm) {
            filterForm.onsubmit = (e) => {
                e.preventDefault();
                const url = makeUrl();
                const params = url.searchParams;
                applyUiStateToParams(params);
                url.search = params.toString();
                fetchAndReplace(url.toString());
            };
        }

        // apply price button
        const applyBtn = document.getElementById('applyPriceBtn');
        if (applyBtn) {
            applyBtn.onclick = (e) => {
                e.preventDefault();
                const url = makeUrl();
                const params = url.searchParams;
                applyUiStateToParams(params);
                url.search = params.toString();
                fetchAndReplace(url.toString());
            };
        }

        // sort handlers
        if (sortForm) {
            const sortSelect = sortForm.querySelector('select[name="sort"]');
            if (sortSelect) {
                sortSelect.onchange = () => {
                    const url = makeUrl();
                    const params = url.searchParams;
                    applyUiStateToParams(params);
                    url.search = params.toString();
                    fetchAndReplace(url.toString());
                };
            }
            sortForm.onsubmit = (e) => {
                e.preventDefault();
                const url = makeUrl();
                const params = url.searchParams;
                applyUiStateToParams(params);
                url.search = params.toString();
                fetchAndReplace(url.toString());
            };
        }

        // remove-filter-link: parse remove* and remove from current location params, then fetch
        sidebar.querySelectorAll('a.remove-filter-link').forEach(a => {
            a.onclick = (e) => {
                e.preventDefault();
                const href = a.getAttribute('href');
                const resolved = resolveHref(href);
                if (!resolved) return;
                if (isShopUrl(resolved)) {
                    const url = buildUrlForRemoveFromHref(href);
                    fetchAndReplace(url);
                } else {
                    window.location.href = resolved;
                }
            };
        });

        // ajax-shop-link
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

        // intercept other internal links
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
                if (a.classList && a.classList.contains('ajax-shop-link')) return;
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