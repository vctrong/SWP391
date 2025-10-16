// Lightweight page loader controller
(function () {
    'use strict';
    function loader() { return document.getElementById('page-loader'); }

    function hideLoader() {
        var l = loader();
        if (!l) return;
        l.style.opacity = '0';
        l.setAttribute('aria-hidden', 'true');
        setTimeout(function () { try { l.style.display = 'none'; } catch (e) { console.error('Failed to hide loader:', e); } }, 300);
    }

    function showLoader() {
        var l = loader();
        if (!l) return;
        l.style.display = 'flex';
        // ensure it's visible
        setTimeout(function(){ l.style.opacity = '1'; l.setAttribute('aria-hidden','false'); }, 10);
    }

    // Hide loader when fully loaded
    if (typeof window !== 'undefined') {
        window.addEventListener('load', function() { hideLoader(); }, { passive: true });

        // Show loader for internal navigation clicks (SPA-like experience)
        document.addEventListener('click', function (e) {
            var a = e.target.closest && e.target.closest('a');
            if (!a) return;
            // skip if explicitly disabled
            if (a.dataset && a.dataset.noLoader !== undefined) return;
            // skip anchors, external, or target=_blank
            if (a.getAttribute('href') && a.getAttribute('href').indexOf('#') === 0) return;
            if (a.target === '_blank' || a.hasAttribute('download')) return;
            try {
                var url = new URL(a.href, location.href);
                if (url.origin !== location.origin) return; // external
            } catch (err) {
                return;
            }
            if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return; // user opened in new tab
            showLoader();
        }, true);

        // Show loader for normal form submits
        document.addEventListener('submit', function(e) {
            var form = e.target;
            if (!form) return;
            if (form.dataset && form.dataset.noLoader !== undefined) return;
            showLoader();
        }, true);

        // If a navigation or page error prevents window.load from firing or hideLoader
        // from running, ensure the loader doesn't stay visible forever by setting
        // a reasonable timeout. showLoader will start the timer and hideLoader
        // clears it.
        var _loaderTimeout = null;
        var _LOADER_TIMEOUT_MS = 15000; // 15 seconds

        var origShow = showLoader;
        showLoader = function() {
            try { origShow(); } catch (e) { console.error('showLoader failed', e); }
            try {
                if (_loaderTimeout) clearTimeout(_loaderTimeout);
                _loaderTimeout = setTimeout(function() {
                    console.warn('Page loader auto-hiding after timeout');
                    hideLoader();
                }, _LOADER_TIMEOUT_MS);
            } catch (e) { console.error(e); }
        };

        var origHide = hideLoader;
        hideLoader = function() {
            try { origHide(); } catch (e) { console.error('hideLoader failed', e); }
            try { if (_loaderTimeout) { clearTimeout(_loaderTimeout); _loaderTimeout = null; } } catch (e) {}
        };

        // Hide loader on global JS errors or unhandled promise rejections so page isn't stuck
        window.addEventListener('error', function (ev) {
            console.error('Unhandled error:', ev && ev.error ? ev.error : ev);
            hideLoader();
        });

        window.addEventListener('unhandledrejection', function (ev) {
            console.error('Unhandled rejection:', ev && ev.reason ? ev.reason : ev);
            hideLoader();
        });

        // expose API
        window.showPageLoader = showLoader;
        window.hidePageLoader = hideLoader;
    }
})();
