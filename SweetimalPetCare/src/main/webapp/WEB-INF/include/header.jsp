<%-- 
    Document   : header
    Created on : Sep 15, 2025, 1:13:59 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<header class="fixed top-0 left-0 w-full z-50 bg-white/30 backdrop-blur-md shadow-sm">
    <div class="container mx-auto flex justify-between items-center py-4 px-6">
        <!-- Logo + Brand -->
        <div class="flex items-center space-x-3">
            <img src="assets/img/logo.jpg" 
                 alt="Sweetimal Logo" 
                 class="w-10 h-10 rounded-full border border-blue-600 shadow-sm">
            <h1 class="text-2xl font-bold text-blue-600">Sweetimal Pet Care</h1>
        </div>

        <!-- Nav Links -->
        <nav class="space-x-6 hidden md:flex">
            <a href="home" class="hover:text-blue-500">Trang chủ</a>
            <a href="#services" class="hover:text-blue-500">Dịch vụ</a>
            <a href="#shop" class="hover:text-blue-500">Cửa hàng</a>
            <a href="#contact" class="hover:text-blue-500">Liên hệ</a>
            <a href="aboutUs" class="hover:text-blue-500">Về chúng tôi</a>
        </nav>

        <c:if test="${not empty user}">
            <div class="space-x-4">
                <a href="#" class="button px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">${user.fullName}</a>
            </div>
        </c:if>
        <c:if test="${empty user}">
            <!-- Buttons -->
            <div class="space-x-4">
                <a href="${pageContext.request.contextPath}/login" class="button px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Đăng nhập</a>
                <a href="register" class="px-4 py-2 bg-gray-200 rounded-lg hover:bg-gray-300">
                    Đăng ký
                </a>

            </div>
        </c:if>

    </div>
</header>