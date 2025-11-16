/**
 * assets/js/product.js
 * Externalized JS for product.jsp
 *
 * Requirements:
 * - product.jsp injects window.PRODUCT_CONFIG as shown in product.jsp above.
 * - Place this file at webapp/assets/js/product.js and ensure product.jsp loads it.
 *
 * Features:
 * - Attribute selection, thumbnails, qty controls, add-to-cart via AJAX, review submission via AJAX,
 *   tab switching and star rating interactions.
 */

(function () {
    const cfg = window.PRODUCT_CONFIG || {};
    const variantsData = cfg.variantsData || [];
    const images = cfg.images || [];
    const ctx = cfg.contextPath || '';

    // Helpers
    function formatVND(n) {
        const num = Number(n) || 0;
        return num.toLocaleString('vi-VN') + '₫';
    }

    function showMessage(type, text, timeout = 3500) {
        let id = 'productFlash';
        let el = document.getElementById(id);
        if (!el) {
            el = document.createElement('div');
            el.id = id;
            el.style.position = 'fixed';
            el.style.top = '84px';
            el.style.right = '20px';
            el.style.zIndex = 99999;
            el.style.padding = '10px 14px';
            el.style.borderRadius = '6px';
            el.style.color = '#fff';
            el.style.maxWidth = '380px';
            el.style.boxShadow = '0 6px 20px rgba(0,0,0,.12)';
            document.body.appendChild(el);
        }
        el.textContent = text;
        el.style.background = (type === 'success') ? '#16a34a' : '#ef4444';
        el.style.display = 'block';
        clearTimeout(el._timer);
        el._timer = setTimeout(() => { el.style.display = 'none'; }, timeout);
    }

    // DOM Utilities
    function qs(sel, root=document) { return root.querySelector(sel); }
    function qsa(sel, root=document) { return Array.from(root.querySelectorAll(sel)); }

    // State
    let selectedAttrs = {}; // key -> value
    let selectedVariantId = null;
    let selectedVariantStock = undefined;
    let currentUnitPrice = Number(cfg.defaultPrice || 0);
    let maxQty = 99;

    // Main DOM elements
    let mainImgEl, priceDisplayEl, totalPriceEl, qtyEl, btnInc, btnDec, buyBtn, stockInfoEl, hiddenVariantInput, addToCartForm;

    // Parse attr JSON safely
    function parseAttrString(s) {
        if (!s) return {};
        try { return JSON.parse(s); } catch (e) {
            try { return JSON.parse(s.replace(/'/g,'"')); } catch (e2) { return {}; }
        }
    }

    // find matched variant
    function findMatchedVariant() {
        for (const v of variantsData) {
            let obj = parseAttrString(v.attr || '{}');
            let match = true;
            for (const k in selectedAttrs) {
                const want = String(selectedAttrs[k]);
                let found = false;
                for (const key in obj) {
                    if (key.toLowerCase() === k.toLowerCase()) {
                        if (String(obj[key]) === want) found = true;
                    }
                }
                if (!found) { match = false; break; }
            }
            if (match) return v;
        }
        return null;
    }

    function clearAttrHighlights() {
        qsa('.attr-btn').forEach(b => {
            b.classList.remove('border-red-500','text-red-600','shadow-md','z-10');
        });
    }

    function highlightButtonsForVariant(v) {
        if (!v) return;
        const obj = parseAttrString(v.attr || '{}');
        for (const k in obj) {
            if (!Object.prototype.hasOwnProperty.call(obj, k)) continue;
            const normKey = k.toLowerCase();
            const normVal = String(obj[k]);
            const btn = document.querySelector(`.attr-btn[data-attr-name="${normKey}"][data-attr-value="${normVal}"]`);
            if (btn) btn.classList.add('border-red-500','text-red-600','shadow-md','z-10');
        }
    }

    function updateUIForVariant(v, visual=true) {
        if (!v) return;
        selectedVariantId = v.id;
        selectedVariantStock = v.stock;
        if (hiddenVariantInput) hiddenVariantInput.value = String(v.id);
        currentUnitPrice = Number(v.price || 0);
        if (priceDisplayEl) priceDisplayEl.textContent = formatVND(currentUnitPrice);
        maxQty = (typeof v.stock === 'number' && v.stock >= 0) ? v.stock : 99;
        if (maxQty <= 0) {
            if (stockInfoEl) stockInfoEl.textContent = 'Tạm thời hết hàng';
            if (buyBtn) { buyBtn.disabled = true; buyBtn.classList.add('opacity-50','cursor-not-allowed'); }
            qtyEl.value = 0;
        } else {
            if (stockInfoEl) stockInfoEl.textContent = 'Còn ' + maxQty + ' sản phẩm';
            if (buyBtn) { buyBtn.disabled = false; buyBtn.classList.remove('opacity-50','cursor-not-allowed'); }
            let q = parseInt(qtyEl.value,10);
            if (isNaN(q) || q <= 0) qtyEl.value = 1;
            if (!isNaN(q) && q > maxQty) qtyEl.value = maxQty;
        }
        updateTotalFromInput();
        if (v.img && mainImgEl) {
            mainImgEl.style.opacity = 0;
            setTimeout(() => { mainImgEl.src = v.img; mainImgEl.style.opacity = 1; }, 180);
        }
        if (visual) {
            clearAttrHighlights();
            highlightButtonsForVariant(v);
        }
    }

    function updateTotalFromInput(animate=true) {
        let qty = parseInt(qtyEl.value, 10);
        if (isNaN(qty) || qty === 0) {
            totalPriceEl.textContent = formatVND(0);
        } else {
            if (qty < 1) qty = 1;
            if (qty > maxQty) qty = maxQty;
            totalPriceEl.textContent = formatVND(currentUnitPrice * qty);
        }
        if (animate) {
            totalPriceEl.style.transition = 'transform 0.08s';
            totalPriceEl.style.transform = 'scale(1.05)';
            setTimeout(()=> totalPriceEl.style.transform = 'scale(1)', 90);
        }
        updateButtonsState();
    }

    function updateButtonsState() {
        let q = parseInt(qtyEl.value,10);
        if (isNaN(q)) q = 0;
        if (btnDec) btnDec.disabled = q <= 1;
        if (btnInc) btnInc.disabled = (maxQty === 0) || (q >= maxQty);
        if (btnDec) {
            if (btnDec.disabled) btnDec.classList.add('opacity-50','cursor-not-allowed'); else btnDec.classList.remove('opacity-50','cursor-not-allowed');
        }
        if (btnInc) {
            if (btnInc.disabled) btnInc.classList.add('opacity-50','cursor-not-allowed'); else btnInc.classList.remove('opacity-50','cursor-not-allowed');
        }
    }

    // attribute click
    function onAttrButtonClick(ev) {
        const btn = ev.currentTarget;
        const name = btn.dataset.attrName;
        const value = btn.dataset.attrValue;
        const price = btn.dataset.price ? Number(btn.dataset.price) : undefined;
        if (!name) return;
        selectedAttrs[name.toLowerCase()] = value;

        qsa('.attr-btn').forEach(b => b.classList.remove('border-red-500','text-red-600','shadow-md','z-10'));
        btn.classList.add('border-red-500','text-red-600','shadow-md','z-10');

        const matched = findMatchedVariant();
        if (matched) {
            updateUIForVariant(matched, true);
        } else {
            if (typeof price === 'number') {
                currentUnitPrice = price;
                if (priceDisplayEl) priceDisplayEl.textContent = formatVND(price);
            }
            selectedVariantId = null;
            selectedVariantStock = undefined;
            if (hiddenVariantInput) hiddenVariantInput.value = '';
            maxQty = 99;
            if (stockInfoEl) stockInfoEl.textContent = '';
            if (buyBtn) buyBtn.classList.remove('opacity-50','cursor-not-allowed');
            updateTotalFromInput();
        }
    }

    // image helpers
    let currentIndex = 0;
    function showImage(index) {
        if (!images || index < 0 || index >= images.length) return;
        if (!mainImgEl) return;
        mainImgEl.style.opacity = 0;
        setTimeout(()=> {
            mainImgEl.src = images[index];
            mainImgEl.style.opacity = 1;
        }, 160);
        qsa('.thumb').forEach((t, i) => {
            t.classList.toggle('border-red-500', i === index);
            t.classList.toggle('border-gray-200', i !== index);
        });
        currentIndex = index;
    }
    function nextImage() { showImage((currentIndex + 1) % images.length); }
    function prevImage() { showImage((currentIndex - 1 + images.length) % images.length); }

    // AJAX add-to-cart
    async function submitAddToCartAjax(form) {
        const submitBtn = form.querySelector('button[type="submit"], #buyBtn');
        if (submitBtn) submitBtn.disabled = true;

        const formData = new FormData(form);
        if (!formData.get('variantId') && selectedVariantId) formData.set('variantId', String(selectedVariantId));
        if (!formData.get('quantity')) {
            const q = qtyEl && qtyEl.value ? qtyEl.value.replace(/\D/g,'') : '1';
            formData.set('quantity', q || '1');
        }

        try {
            const resp = await fetch(form.action, {
                method: form.method || 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: new URLSearchParams(formData),
                credentials: 'same-origin'
            });
            const text = await resp.text();
            let json = null;
            try { json = text ? JSON.parse(text) : null; } catch (err) { console.error('Invalid JSON from cart', text); }

            if (!resp.ok) {
                if (json && json.message) showMessage('error', json.message);
                else showMessage('error', 'Lỗi khi thêm vào giỏ hàng');
                if (json && json.login) {
                    window.location.href = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
                }
                return;
            }

            if (json && json.success) {
                if (json.redirect) {
                    window.location.href = json.redirect;
                    return;
                }
                showMessage('success', json.message || 'Đã thêm vào giỏ hàng');
            } else {
                showMessage('error', (json && json.message) ? json.message : 'Không thể thêm vào giỏ hàng');
                if (json && json.login) window.location.href = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
            }
        } catch (err) {
            console.error('Add to cart error', err);
            form.submit();
        } finally {
            if (submitBtn) { submitBtn.disabled = false; }
        }
    }

    // REVIEW AJAX
    async function submitReviewAjax(form) {
        const submitBtn = form.querySelector('button[type="submit"], #submitReviewBtn');
        if (submitBtn) submitBtn.disabled = true;
        const body = new URLSearchParams(new FormData(form)).toString();

        try {
            const resp = await fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                },
                body: body,
                credentials: 'same-origin'
            });
            const text = await resp.text();
            let json = null;
            try { json = text ? JSON.parse(text) : null; } catch (err) { console.error('Invalid JSON', text); }

            if (!resp.ok) {
                if (json && json.message) showMessage('error', json.message);
                else showMessage('error', 'Lỗi server. Vui lòng thử lại.');
                if (json && json.login) window.location.href = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
                return;
            }

            if (json) {
                if (json.success) {
                    if (json.redirect) { window.location.href = json.redirect; return; }
                    showMessage('success', json.message || 'Gửi đánh giá thành công');
                    setTimeout(() => window.location.reload(), 900);
                } else {
                    showMessage('error', json.message || 'Không thể gửi đánh giá');
                    if (json.login) window.location.href = ctx + '/login?redirect=' + encodeURIComponent(window.location.href);
                }
            } else {
                window.location.reload();
            }
        } catch (err) {
            console.error('Review submit error:', err);
            showMessage('error','Lỗi mạng, thử lại sau');
        } finally {
            if (submitBtn) submitBtn.disabled = false;
        }
    }

    // init
    function init() {
        mainImgEl = qs('#mainImg');
        priceDisplayEl = qs('#priceDisplay');
        totalPriceEl = qs('#totalPrice');
        qtyEl = qs('#qty');
        btnInc = qs('#btnInc');
        btnDec = qs('#btnDec');
        buyBtn = qs('#buyBtn');
        stockInfoEl = qs('#stockInfo');
        hiddenVariantInput = qs('#hiddenVariantId');
        addToCartForm = qs('#addToCartForm');

        // attribute buttons
        qsa('.attr-btn').forEach(b => b.addEventListener('click', onAttrButtonClick));

        // default selection: cheapest variant
        let defaultVariant = null;
        if (variantsData && variantsData.length > 0) {
            defaultVariant = variantsData.reduce((acc,v)=> (!acc || v.price < acc.price) ? v : acc, null);
        }
        if (defaultVariant) {
            try {
                const obj = parseAttrString(defaultVariant.attr);
                for (const k in obj) selectedAttrs[k.toLowerCase()] = String(obj[k]);
            } catch(e){}
            updateUIForVariant(defaultVariant, true);
        } else {
            if (hiddenVariantInput && hiddenVariantInput.value) selectedVariantId = hiddenVariantInput.value;
            currentUnitPrice = Number(cfg.defaultPrice || 0);
            if (priceDisplayEl) priceDisplayEl.textContent = formatVND(currentUnitPrice);
            updateTotalFromInput(false);
        }

        // qty handlers
        if (btnInc) btnInc.addEventListener('click', (e) => { e.preventDefault(); changeQty(1); });
        if (btnDec) btnDec.addEventListener('click', (e) => { e.preventDefault(); changeQty(-1); });
        if (qtyEl) {
            qtyEl.addEventListener('input', function(e) {
                const digits = this.value.replace(/\D/g, '');
                this.value = digits;
                if (!isNaN(parseInt(digits,10)) && parseInt(digits,10) > maxQty) {
                    showMessage('error', 'Bạn đã đạt giới hạn: ' + maxQty, 1200);
                }
                updateTotalFromInput(false);
            });
        }

        function changeQty(n) {
            let qty = parseInt(qtyEl.value, 10);
            if (isNaN(qty)) qty = 0;
            let target = qty + n;

            if (target < 1) { target = 1; showMessage('error','Số lượng tối thiểu là 1',1000); }
            if (target > maxQty) {
                if (maxQty === 0) { showMessage('error','Sản phẩm tạm hết hàng'); qtyEl.value = maxQty; updateTotalFromInput(); return; }
                else { showMessage('error','Bạn đã đạt giới hạn: ' + maxQty, 1200); target = maxQty; }
            }
            qtyEl.value = target;
            updateTotalFromInput();
        }

        // add-to-cart -> AJAX
        if (addToCartForm) {
            addToCartForm.addEventListener('submit', function(e) {
                e.preventDefault();
                if (hiddenVariantInput && !hiddenVariantInput.value && selectedVariantId) hiddenVariantInput.value = String(selectedVariantId);
                const q = qtyEl && qtyEl.value ? qtyEl.value.replace(/\D/g,'') : '1';
                const hiddenQty = qs('#hiddenQuantity');
                if (hiddenQty) hiddenQty.value = q || '1';
                submitAddToCartAjax(addToCartForm);
            });
        }

        // tabs
        qsa('.tab-btn').forEach(btn => btn.addEventListener('click', function(){
            qsa('.tab-btn').forEach(b => b.classList.remove('text-red-500','border-b-2','border-red-500'));
            qsa('.tab-content').forEach(c => c.classList.add('hidden'));
            this.classList.add('text-red-500','border-b-2','border-red-500');
            const tab = this.dataset.tab;
            if (tab === 'desc') qs('#tab-desc').classList.remove('hidden');
            if (tab === 'reviews') qs('#tab-reviews').classList.remove('hidden');
        }));

        // thumbs
        qsa('.thumb').forEach(t => {
            t.addEventListener('click', function(){
                const idx = Number(this.dataset.index || 0);
                showImage(idx);
            });
        });

        // review toggle and validation & AJAX
        const toggleBtn = qs('#toggleReviewForm');
        const purchaseNotice = qs('#purchaseNotice');
        if (toggleBtn) {
            toggleBtn.addEventListener('click', function(){
                const hasReviewed = String(this.dataset.hasReviewed) === 'true';
                if (hasReviewed) {
                    if (purchaseNotice) { purchaseNotice.textContent = 'Bạn chỉ có thể gửi 1 phản hồi. Vui lòng xóa hoặc chỉnh sửa đánh giá hiện có.'; purchaseNotice.classList.remove('hidden'); }
                    const rf = qs('#reviewForm'); if (rf && !rf.classList.contains('hidden')) rf.classList.add('hidden');
                    return;
                }
                const hasPurchased = String(this.dataset.hasPurchased) === 'true';
                const rf = qs('#reviewForm');
                if (!hasPurchased) {
                    if (purchaseNotice) { purchaseNotice.textContent = 'Bạn phải mua sản phẩm mới được viết đánh giá.'; purchaseNotice.classList.remove('hidden'); }
                    if (rf && !rf.classList.contains('hidden')) rf.classList.add('hidden');
                    return;
                }
                if (purchaseNotice) { purchaseNotice.textContent = ''; purchaseNotice.classList.add('hidden'); }
                if (rf) rf.classList.toggle('hidden');
            });
        }

        // star rating interactions
        const ratingInput = qs('#ratingInput');
        const stars = qsa('#starRating .star');
        if (ratingInput && stars.length) {
            stars.forEach(star => {
                star.addEventListener('mouseover', () => {
                    stars.forEach(s => { s.textContent = '☆'; s.classList.remove('text-yellow-400'); });
                    const v = parseInt(star.dataset.value,10) || 0;
                    for (let i=0;i<v;i++) { stars[i].textContent='★'; stars[i].classList.add('text-yellow-400'); }
                });
                star.addEventListener('click', ()=> { ratingInput.value = star.dataset.value; });
                star.addEventListener('mouseout', ()=> {
                    const sel = parseInt(ratingInput.value,10) || 0;
                    stars.forEach((s, idx) => {
                        s.textContent = (idx < sel) ? '★' : '☆';
                        if (idx < sel) s.classList.add('text-yellow-400'); else s.classList.remove('text-yellow-400');
                    });
                });
            });
        }

        // review form submission
        const reviewFormInner = qs('#reviewFormInner');
        if (reviewFormInner) {
            reviewFormInner.addEventListener('submit', function(e){
                let ok = true;
                const ratingVal = parseInt((ratingInput && ratingInput.value) || 0, 10);
                const ratingErrorEl = qs('#ratingError');
                const commentEl = qs('#reviewComment');
                const commentErrorEl = qs('#commentError');
                if (ratingVal < 1) { ratingErrorEl && ratingErrorEl.classList.remove('hidden'); ok = false; } else { ratingErrorEl && ratingErrorEl.classList.add('hidden'); }
                // Do not enforce a minimum character count; only require non-empty content
                if (!commentEl.value || commentEl.value.trim().length === 0) { commentErrorEl && commentErrorEl.classList.remove('hidden'); ok = false; } else { commentErrorEl && commentErrorEl.classList.add('hidden'); }
                if (!ok) { e.preventDefault(); const firstErr = document.querySelector('.text-red-500:not(.hidden)'); if (firstErr) firstErr.scrollIntoView({behavior:'smooth', block:'center'}); return false; }
                e.preventDefault();
                submitReviewAjax(reviewFormInner);
            });
        }

        // init images
        if (images && images.length > 0) {
            currentIndex = 0;
            showImage(0);
        }

        if (!qtyEl) { qtyEl = document.createElement('input'); qtyEl.value = '1'; }
        if (!totalPriceEl) { totalPriceEl = document.createElement('span'); totalPriceEl.textContent = formatVND(currentUnitPrice); }
        updateTotalFromInput(false);
    }

    // expose small utilities for inline usage if needed
    window.selectAttr = function(btn, name, value, price, visual) {
        if (typeof btn === 'string') {
            const el = document.querySelector(`.attr-btn[data-attr-name="${name}"][data-attr-value="${value}"]`);
            if (el) el.click();
            return;
        }
        try { onAttrButtonClick({ currentTarget: btn }); } catch(e) {}
    };
    window.showImage = showImage;
    window.nextImage = nextImage;
    window.prevImage = prevImage;
    window.changeQty = function(n) {
        if (n > 0 && btnInc) btnInc.click();
        if (n < 0 && btnDec) btnDec.click();
    };

    document.addEventListener('DOMContentLoaded', init);
})();