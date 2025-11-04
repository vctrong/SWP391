<%-- 
    Document   : admin_header
    Created on : Oct 31, 2025, 4:06:15 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<header class="h-16 bg-white border-b flex items-center justify-between px-4 md:px-8 sticky top-0 z-10">
    <div class="flex items-center gap-4">
        <h2 id="pageTitle" class="text-xl font-semibold">Dashboard</h2>
    </div>
    <div class="flex items-center gap-4">
        <div class="relative">
            <button id="notifBtn" class="p-2 rounded-md hover:bg-gray-100">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 text-gray-500">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A2.25 2.25 0 0015.75 6.75A2.25 2.25 0 0013.5 9v.75c0 5.026 4.027 9.043 9 9.043.5 0 .979-.04 1.44-.118z" />
                </svg>
            </button>
            <span
                class="absolute -top-1 -right-1 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">3</span>
        </div>
        <div class="flex items-center gap-3">
            <div class="text-right hidden sm:block">
                <div class="text-sm font-medium">${user.fullName}</div>
                <div class="text-xs text-gray-500">${user.roleEnum.text}</div>
            </div>
            <img src="https://i.pravatar.cc/40" alt="avatar" class="w-10 h-10 rounded-full" />
        </div>
    </div>
</header>