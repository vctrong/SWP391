<%-- 
    Document   : loginFail
    Created on : Oct 2, 2025, 10:52:28 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="tw-toast-container" class="fixed top-4 right-4 z-[9999] flex flex-col gap-2 pointer-events-none"></div>
<!-- Error Toast Template -->
<div id="toast-error" class="hidden pointer-events-auto grid grid-cols-[22px_1fr_auto] items-start
     gap-2 min-w-[280px] max-w-[380px] rounded-xl border-l-4 p-3 pr-2
     shadow-md border-red-400 bg-red-50 text-red-900">
    <svg class="h-[22px] w-[22px] mt-[2px] flex-shrink-0" viewBox="0 0 24 24" fill="none" aria-hidden="true">
    <circle cx="12" cy="12" r="10" class="fill-red-100"></circle>
    <path d="M8 8l8 8M16 8l-8 8" class="stroke-red-700" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
    <div>
        <p class="m-0 text-sm font-semibold">Thất bại</p>
        <p class="mt-1 text-xs opacity-90">Đăng nhập thất bại!</p>
    </div>
    <button class="close-btn ml-1 inline-flex h-6 w-6 items-center justify-center rounded-md text-slate-500 hover:bg-black/5">
        <span class="text-base">&times;</span>
    </button>
</div>
<script src="assets/js/loginNoti.js"></script>
<c:if test="${loginFail}">
    <script>
        toastError();
    </script>
    <c:remove var="loginFail" scope="session" />
</c:if>
