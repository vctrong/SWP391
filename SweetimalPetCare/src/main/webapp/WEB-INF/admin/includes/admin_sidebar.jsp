<%-- 
    Document   : admin_sidebar
    Created on : Oct 29, 2025, 4:56:23 PM
    Author     : Vo Chi Trong - CE191062
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="current" value="${pageContext.request.requestURI}" />
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="hidden md:flex w-72 bg-white border-r flex flex-col fixed inset-y-0 left-0 z-20">
    <div class="p-5 border-b">
        <a href="${pageContext.request.contextPath}/home" class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-full overflow-hidden bg-gradient-to-br from-emerald-400 to-sky-500 flex items-center justify-center">
                <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="Sweetimal Logo" class="w-full h-full object-cover">
            </div>
            <div>
                <h1 class="text-lg font-semibold text-gray-800">Sweetimal</h1>
                <p class="text-xs text-gray-500">Admin Dashboard</p>
            </div>
        </a>
    </div>

    <nav class="p-4 flex-1 overflow-auto">
        <ul class="space-y-1">
            <li>
                <span class="text-xs font-semibold text-gray-500 uppercase px-3 pt-2">Main</span>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" data-link="dashboard"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/dashboard') ? 'nav-active' : ''} ">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25A2.25 2.25 0 0113.5 8.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z" />
                    </svg>
                    Dashboard
                </a>
            </li>

            <li>
                <span class="text-xs font-semibold text-gray-500 uppercase px-3 pt-4">Manage</span>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/service" data-link="services"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/service') ? 'nav-active' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9.53 16.122a3 3 0 00-5.78 1.128 2.25 2.25 0 01-2.4 2.245 4.5 4.5 0 008.4-2.245c0-.399-.078-.78-.22-1.128zm0 0a15.998 15.998 0 003.388-1.62m-5.043-.025a15.998 15.998 0 011.622-3.388m1.128 5.78l-1.128-5.78m5.78 1.128a3 3 0 01-5.78-1.128 2.25 2.25 0 00-2.4-2.245 4.5 4.5 0 018.4 2.245c0 .399-.078-.78-.22 1.128zm0 0A15.998 15.998 0 0118 13.5m-5.043-.025a15.998 15.998 0 00-1.622-3.388m1.128 5.78l-1.128-5.78" />
                    </svg>
                    Services
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/product" data-link="products"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/product') ? 'nav-active' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25H12" />
                    </svg>
                    Products
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/personnel" data-link="personnel"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/personnel') ? 'nav-active' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                    </svg>
                    Personnel
                </a>
            </li>   
            <li>
                <a href="${pageContext.request.contextPath}/admin/booking" data-link="bookings"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/booking') ? 'nav-active' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5m-9-6h.008v.008H12v-.008zM12 15h.008v.008H12V15zm0 2.25h.008v.008H12v-.008zM9.75 15h.008v.008H9.75V15zm0 2.25h.008v.008H9.75v-.008zM7.5 15h.008v.008H7.5V15zm0 2.25h.008v.008H7.5v-.008zm6.75-4.5h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V15zm0 2.25h.008v.008h-.008v-.008zm2.25-4.5h.008v.008H16.5v-.008zm0 2.25h.008v.008H16.5V15z" />
                    </svg>
                    Bookings
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/order" data-link="orders"
                   class="nav-link flex items-center gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/order') ? 'nav-active' : ''}">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z" />
                    </svg>
                    Orders
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/contact" data-link="contacts"
                   class="nav-link flex items-center justify-between gap-3 px-3 py-2.5 rounded-md hover:bg-gray-100
                   ${fn:contains(current, '/admin/contact') ? 'nav-active' : ''}">
                    <span class="flex items-center gap-3">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 13.5h3.86a2.25 2.25 0 012.012 1.244l.256.512a2.25 2.25 0 002.013 1.244h3.218a2.25 2.25 0 002.013-1.244l.256-.512a2.25 2.25 0 012.013-1.244h3.859m-19.5.338V18a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 0021.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 00-2.12-1.58H6.88a2.25 2.25 0 00-2.12 1.58L2.35 13.177a2.25 2.25 0 00-.1.661z" />
                        </svg>
                        Contacts
                    </span>
                    <span class="bg-amber-500 text-white text-xs font-semibold px-2 py-0.5 rounded-full">3</span>
                </a>
            </li>

        </ul>
    </nav>
                   <form action="${pageContext.request.contextPath}/logout" method="GET">
        <div class="p-4 border-t">
            <button id="logoutBtn"
                    class="w-full text-sm py-2 px-3 rounded-md bg-red-50 text-red-600 hover:bg-red-100 flex items-center justify-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75" />
                </svg>
                Logout
            </button>
        </div>
    </form>
</aside>
