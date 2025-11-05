<%-- 
    Document   : mobileApp
    Created on : Oct 31, 2025, 4:56:49 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="w-full md:hidden bg-white border-b fixed top-0 left-0 right-0 z-30">
    <div class="flex items-center justify-between px-4 py-3">
        <div class="flex items-center gap-3">
            <button id="openMobileSidebar" class="p-2 rounded-md bg-gray-100">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
                </svg>
            </button>
            <div class="text-lg font-semibold">Sweetimal Admin</div>
        </div>
        <div class="flex items-center gap-3">
            <button class="p-2 rounded-full bg-gray-100">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A2.25 2.25 0 0015.75 6.75A2.25 2.25 0 0013.5 9v.75c0 5.026 4.027 9.043 9 9.043.5 0 .979-.04 1.44-.118z" />
                </svg>
            </button>
            <img src="https://i.pravatar.cc/40" alt="avatar" class="w-8 h-8 rounded-full" />
        </div>
    </div>
</div>

<div id="mobileSidebar" class="fixed inset-0 bg-black/40 z-40 hidden">
    <aside class="w-64 bg-white h-full p-4">
        <div class="flex items-center justify-between mb-4">
            <div class="font-semibold">Menu</div>
            <button id="closeMobileSidebar" class="text-xl">✕</button>
        </div>
        <nav>
            <ul class="space-y-2">
                <li><a href="#" data-link="dashboard" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Dashboard</a></li>
                <li><a href="#" data-link="services" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Services</a></li>
                <li><a href="#" data-link="products" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Products</a></li>
                <li><a href="#" data-link="personnel" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Personnel</a></li>
                <li><a href="#" data-link="bookings" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Bookings</a></li>
                <li><a href="#" data-link="orders" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Orders</a></li>
                <li><a href="#" data-link="contacts" class="mobile-nav-link block px-3 py-2 rounded hover:bg-gray-100">Contacts</a></li>
            </ul>
        </nav>
    </aside>
</div>
