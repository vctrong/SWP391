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
        <div class="flex items-center gap-3">
            <div class="text-right hidden sm:block">
                <div class="text-sm font-medium">${user.fullName}</div>
                <div class="text-xs text-gray-500">${user.roleEnum.text}</div>
            </div>
            <img src="https://i.pravatar.cc/40" alt="avatar" class="w-10 h-10 rounded-full" />
        </div>
    </div>
</header>