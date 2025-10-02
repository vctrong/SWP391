(function () {
    const DEFAULT_DURATION = 3000; // ms

    function ensureContainer() {
        let container = document.getElementById('tw-toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'tw-toast-container';
            container.className = 'fixed top-4 right-4 z-[9999] flex flex-col gap-2 pointer-events-none';
            document.body.appendChild(container);
        }
        return container;
    }

    function cloneToast(id) {
        const tpl = document.getElementById(id);
        if (!tpl)
            return null;

        const node = tpl.cloneNode(true);
        node.id = ''; // tránh trùng id
        node.classList.remove('hidden');
        node.classList.add('tw-toast-enter');

        // Nút đóng
        const closeBtn = node.querySelector('.close-btn');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => hideToast(node));
        }
        return node;
    }

    function hideToast(el) {
        if (!el)
            return;
        el.classList.remove('tw-toast-enter');
        el.classList.add('tw-toast-leave');

        el.addEventListener('animationend', () => {
            el.remove();
        }, {once: true});

        // fallback
        setTimeout(() => el.remove(), 800);
    }

    function showToast(templateId, duration = DEFAULT_DURATION) {
        const container = ensureContainer();
        const toast = cloneToast(templateId);
        if (!toast)
            return;

        container.appendChild(toast);

        if (duration > 0) {
            setTimeout(() => hideToast(toast), duration);
    }
    }

    // API public
    window.toastSuccess = () => showToast('toast-success');
    window.toastError = () => showToast('toast-error');
})();