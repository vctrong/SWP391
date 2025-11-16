<%-- 
    Document   : headerProfileUser
    Created on : Nov 16, 2025, 5:49:54 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="max-w-7xl mx-auto mt-4 px-4">
    <div class="bg-white shadow-md rounded-2xl p-4 flex items-center justify-between gap-4">
        <!-- LEFT: Logo -->
        <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-xl overflow-hidden border">
                <img src="assets/img/logo.jpg" alt="Sweetimal Logo" class="w-full h-full object-cover">
            </div>
            <div class="hidden md:flex flex-col">
                <span class="text-lg font-semibold text-slate-800">Sweetimal</span>
                <span class="text-xs text-slate-500">Pet Care & Shop</span>
            </div>
        </a>

        <!-- RIGHT: Controls & user info (kept on a single line) -->
        <div class="flex items-center gap-3 md:gap-4 flex-1 justify-end">
            <!-- Upcoming appointment (compact) -->
            <div class="flex flex-col items-end text-right pr-2 hidden sm:flex">
                <span class="text-sm font-medium text-slate-800">Cuộc hẹn tiếp theo</span>
                <span class="text-xs text-slate-500">${bookingNext.reqDate} • ${bookingNext.reqTime}</span> <!-- hardcoded for review -->
            </div>

            <!-- Pet count -->
            <div class="flex items-center gap-2 bg-emerald-50 text-emerald-700 px-3 py-2 rounded-xl">
                <!-- paw icon (inline SVG) -->
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M14.5 5.5c0 1.66-1.34 3-3 3s-3-1.34-3-3 1.34-3 3-3 3 1.34 3 3zM6 8.5C7.11 8.5 8 7.61 8 6.5S7.11 4.5 6 4.5 4 5.39 4 6.5 4.89 8.5 6 8.5zM19 8.5c1.11 0 2-.89 2-2s-.89-2-2-2-2 .89-2 2 .89 2 2 2zM12 14c-3.31 0-6 2.69-6 6h12c0-3.31-2.69-6-6-6z"/>
                </svg>
                <div class="text-sm">
                    <div class="font-semibold">${user.nop}</div> <!-- hardcoded pet count -->
                    <div class="text-xs text-slate-500">Thú cưng</div>
                </div>
            </div>

            <!-- Loyalty points (small) -->
            <div class="hidden md:flex items-center gap-2 bg-yellow-50 text-yellow-700 px-3 py-2 rounded-xl">
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                <path d="M12 2L15 8l6 .5-4.5 4 1.5 6L12 16l-6 3.5 1.5-6L3 8.5 9 8 12 2z"/>
                </svg>
                <div class="text-sm">
                    <div class="font-semibold">1,200</div>
                    <div class="text-xs text-slate-500">Điểm</div>
                </div>
            </div>

            <!-- CTA: Mua sắm -->
            <a href="${pageContext.request.contextPath}/shop" class="inline-flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">
                <svg class="w-4 h-4 text-slate-700" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                <path d="M3 3h2l.4 2M7 13h10l4-8H5.4" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                <circle cx="10" cy="20" r="1" fill="currentColor"></circle>
                <circle cx="18" cy="20" r="1" fill="currentColor"></circle>
                </svg>
                Mua sắm
            </a>

            <!-- CTA: Đặt lịch -->
            <a href="${pageContext.request.contextPath}/services" class="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-sky-500 to-sky-600 text-white rounded-lg shadow-sm text-sm hover:from-sky-600 hover:to-sky-700">
                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                <path d="M8 7V3M16 7V3M3 11h18M5 21h14a1 1 0 0 0 1-1V7a1 1 0 0 0-1-1H4a1 1 0 0 0-1 1v13a1 1 0 0 0 1 1z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                </svg>
                Đặt lịch
            </a>

            <!-- Cart (icon + count) -->
            <a href="${pageContext.request.contextPath}/cart" class="relative inline-flex items-center p-2 rounded-full hover:bg-slate-50" aria-label="Giỏ hàng">
                <svg class="w-6 h-6 text-slate-700" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                <path d="M6 6h15l-1.5 9h-12L4 2H2" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                <circle cx="10" cy="20" r="1" fill="currentColor"></circle>
                <circle cx="18" cy="20" r="1" fill="currentColor"></circle>
                </svg>
                <span class="absolute -top-1 -right-1 bg-indigo-600 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">3</span>
            </a>

            <!-- Avatar + name (single-line, no dropdown) -->
            <div class="flex items-center gap-3 pl-2">
                <img src="assets/img/avt.webp" alt="Avatar Võ Chí Trọng" class="w-12 h-12 rounded-full border object-cover">
                <div class="flex flex-col">
                    <!-- NAME must stay on one line (whitespace-nowrap) and expand horizontally -->
                    <span class="text-sm font-medium text-slate-800 whitespace-nowrap">${user.fullName}</span> <!-- hardcoded -->
                    <span class="text-xs text-slate-500">${user.roleEnum.text}</span>
                </div>
            </div>

        </div>
    </div>
</header>