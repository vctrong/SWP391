<%-- 
    Document   : admin_sidebar
    Created on : Oct 29, 2025, 4:56:23 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="w-64 bg-gradient-to-b from-sky-600 to-sky-700 text-white flex flex-col fixed h-screen shadow-lg">
    <div class="text-center py-6 border-b border-sky-500">
        <h2 class="text-2xl font-bold tracking-wide">🐾 Sweetimal Admin</h2>
    </div>

    <nav class="flex-1 px-3 py-4 space-y-1 text-sky-100">
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60 active">
            <i class="fa-solid fa-house w-6"></i> <span>Trang chủ</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-paw w-6"></i> <span>Quản lý sản phẩm</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-people-group w-6"></i> <span>Quản lý nhân sự</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-box w-6"></i> <span>Quản lý dịch vụ</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-cart-shopping w-6"></i> <span>Quản lý đơn hàng</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-envelope w-6"></i> <span>Liên hệ</span>
        </a>
        <a href="#" class="flex items-center px-4 py-2 rounded-lg hover:bg-sky-500/60">
            <i class="fa-solid fa-gear w-6"></i> <span>Cài đặt</span>
        </a>
    </nav>

    <div class="mt-auto text-center py-4 border-t border-sky-500">
        <p class="text-sm text-sky-100">&copy; 2025 Sweetimal</p>
    </div>
</aside>
