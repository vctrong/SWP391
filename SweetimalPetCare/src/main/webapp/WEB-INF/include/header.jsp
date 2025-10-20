<%--
    Document   : header
    Created on : Sep 15, 2025, 1:13:59 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Page loader (site-wide). Visible until window.load or when showPageLoader() is called -->
<div id="page-loader" aria-hidden="false" class="fixed inset-0 bg-white z-50 flex items-center justify-center" style="transition:opacity .25s ease;">
    <div class="flex items-center space-x-3">
        <i class="fa-solid fa-circle-notch fa-2x animate-spin text-blue-600"></i>
        <span class="text-gray-700 font-medium">Đang tải...</span>
    </div>
    <span class="sr-only">Loading</span>
</div>

<header class="sticky top-0 left-0 w-full z-30 bg-white/30 backdrop-blur-md shadow-sm">
    <div class="container mx-auto flex justify-between items-center py-4 px-6">
        <!-- Logo + Brand -->
        <div class="flex items-center space-x-3">
            <div class="flex items-center space-x-3 px-2 py-1 rounded-full transition-all transform hover:scale-105 hover:text-blue-600 hover:shadow-md hover:border-blue-400" title="Sweetimal Home">
                <img src="${pageContext.request.contextPath}/assets/img/logo.jpg"
                     alt="Sweetimal Logo"
                     class="w-10 h-10 rounded-full border border-blue-600 shadow-sm">
                <h1 class="text-2xl font-bold text-blue-600">Sweetimal Pet Care</h1>
            </div>
        </div>

        <!-- Nav Links -->
        <nav class="space-x-6 hidden md:flex">
            <a href="home" class="hover:text-blue-500">Trang chủ</a>
            <a href="#services" class="hover:text-blue-500">Dịch vụ</a>
            <a href="#shop" class="hover:text-blue-500">Cửa hàng</a>
            <a href="contacts" class="hover:text-blue-500">Liên hệ</a>
            <a href="aboutUs" class="hover:text-blue-500">Về chúng tôi</a>
            <a href="news" class="hover:text-blue-500">Tin tức</a>
            <c:if test="${not empty user}">
                <a href="${pageContext.request.contextPath}/booking-history" class="px-3 py-2 rounded-full border border-transparent transition-all transform hover:scale-105 hover:text-blue-600 hover:border-blue-400">Lịch sử đặt lịch</a>
            </c:if>
        </nav>

        <c:if test="${not empty user}">
            <div class="space-x-4 flex items-center">
                <div class="px-1 py-1 rounded-full transform hover:scale-105 hover:text-blue-600">
                    <button id="userMenuButton" class="flex items-center space-x-2 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white px-4 py-2 rounded-full transition duration-300 transform focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">${user.fullName}</button>
                </div>
            </div>
        </c:if>
        <c:if test="${empty user}">
            <!-- Buttons -->
            <div class="space-x-4">
                <a href="${pageContext.request.contextPath}/login" class="button inline-block px-4 py-2 bg-blue-600 text-white rounded-full transition-all transform hover:scale-105 border border-transparent">Đăng nhập</a>
                <button class="button inline-block px-4 py-2 bg-gray-200 rounded-full transition-all transform hover:scale-105 border border-transparent">Đăng ký</button>
            </div>
        </c:if>

    </div>
</header>


<!-- Floating Vet Chatbox -->
<jsp:include page="/WEB-INF/include/chatbox.jsp" />

<%@include file="/WEB-INF/include/sidebarInfo.jsp" %>
<%@include file="/WEB-INF/include/cardID.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>

