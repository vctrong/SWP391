<%-- 
    Document   : loginOk
    Created on : Oct 2, 2025, 10:52:00 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="tw-toast-container" class="fixed top-4 right-4 z-[9999] flex flex-col gap-2 pointer-events-none"></div>

<div id="toast-success" class="hidden pointer-events-auto grid grid-cols-[22px_1fr_auto] items-start
     gap-2 min-w-[280px] max-w-[380px] rounded-xl border-l-4 p-3 pr-2
     shadow-md border-emerald-400 bg-emerald-50 text-emerald-900">
    <svg class="h-[22px] w-[22px] mt-[2px] flex-shrink-0" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <circle cx="12" cy="12" r="10" class="fill-emerald-100"></circle>
    <path d="M7.5 12.5l3 3 6-6" class="stroke-emerald-700" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
    <div>
        <p class="m-0 text-sm font-semibold">Thành công</p>
        <p class="mt-1 text-xs opacity-90">Đăng nhập thành công!</p>
    </div>
    <button class="close-btn ml-1 inline-flex h-6 w-6 items-center justify-center rounded-md text-slate-500 hover:bg-black/5">
        <span class="text-base">&times;</span>
    </button>
</div>
<script src="assets/js/loginNoti.js"></script>
<c:if test="${loginOk}">
    <script>
        toastSuccess();
    </script>
    <c:remove var="loginOk" scope="session" />
</c:if>
