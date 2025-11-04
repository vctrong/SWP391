<%--
    Document   : header
    Created on : Sep 15, 2025, 1:13:59 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="${pageContext.request.contextPath}/assets/css/header.css" rel="stylesheet" >
<!-- Page loader (site-wide). Visible until window.load or when showPageLoader() is called -->
<div id="page-loader" aria-hidden="false" class="fixed inset-0 bg-white z-50 flex items-center justify-center" style="transition:opacity .25s ease;">
    <div class="flex items-center space-x-3">
        <i class="fa-solid fa-circle-notch fa-2x animate-spin text-blue-600"></i>
        <span class="text-gray-700 font-medium">Đang tải...</span>
    </div>
    <span class="sr-only">Loading</span>
</div>

<c:set var="current" value="${pageContext.request.requestURI}" />

<header id="navbar"
        class="sticky top-0 left-0 w-full z-30 bg-white/40 backdrop-blur-md border-b border-sky-100 shadow-sm transition-all duration-500">
    <div class="container mx-auto flex justify-between items-center py-4 px-6">
        <!-- Logo + Brand -->
        <div class="flex items-center space-x-3">
            <a href="${pageContext.request.contextPath}/home"
               class="flex items-center space-x-3 px-2 py-1 rounded-full transition-all transform hover:scale-105 hover:shadow-md hover:text-blue-600"
               title="Sweetimal Home">
                <img src="${pageContext.request.contextPath}/assets/img/logo.jpg"
                     alt="Sweetimal Logo"
                     class="w-10 h-10 rounded-full border border-blue-600 shadow-sm hover:shadow-lg transition">
                <h1 class="text-2xl font-bold bg-gradient-to-r from-sky-500 to-blue-600 bg-clip-text text-transparent">
                    Sweetimal Pet Care
                </h1>
            </a>
        </div>

          <!-- Nav Links -->
          <nav class="hidden md:flex items-center space-x-2 text-gray-700 font-medium">
                <c:choose>
                    <%-- If user is admin (role == 4) show only Home + Dashboard --%>
                     <c:when test="${not empty user and user.role == 4}">
                          <a href="${pageContext.request.contextPath}/home"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/home') ? 'active' : ''}">Trang chủ</a>

                          <a href="${pageContext.request.contextPath}/dashboard"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/dashboard') ? 'active' : ''}">Dashboard</a>
                     </c:when>
                    <%-- Default navbar for non-admin users / guests --%>
                     <c:otherwise>
                          <a href="${pageContext.request.contextPath}/home"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/home') ? 'active' : ''}">Trang chủ</a>

                          <a href="${pageContext.request.contextPath}/services"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/services') ? 'active' : ''}">Dịch vụ</a>

                          <a href="#shop"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/shop') ? 'active' : ''}">Cửa hàng</a>

                          <a href="${pageContext.request.contextPath}/contacts"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/contacts') ? 'active' : ''}">Liên hệ</a>

                          <a href="${pageContext.request.contextPath}/aboutUs"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/aboutus') ? 'active' : ''}">Về chúng tôi</a>
                       
                          <a href="${pageContext.request.contextPath}/news"
                              class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                              hover:text-blue-600 hover:border-blue-400
                              ${fn:contains(current, '/news') ? 'active' : ''}">Tin tức</a>

                          <c:if test="${not empty user}">
                                <a href="${pageContext.request.contextPath}/booking-history"
                                    class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                                    hover:text-blue-600 hover:border-blue-400
                                    ${fn:contains(current, '/bookingHistory') ? 'active' : ''}">
                                     Lịch sử đặt lịch
                                </a>
                          </c:if>
                     </c:otherwise>
                </c:choose>
          </nav>

        <!-- User / Auth Buttons -->
        <c:if test="${not empty user}">
            <div class="space-x-4 flex items-center">
                <div class="px-1 py-1 rounded-full transform hover:scale-105 hover:text-blue-600 transition">
                    <button id="userMenuButton"
                            class="flex items-center space-x-2 bg-gradient-to-r from-sky-500 to-blue-600 hover:from-blue-600 hover:to-blue-700
                            text-white px-4 py-2 rounded-full shadow-md hover:shadow-lg transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
                        ${user.fullName}
                    </button>
                </div>
            </div>
        </c:if>

        <c:if test="${empty user}">
            <div class="space-x-4">
                <a href="${pageContext.request.contextPath}/login"
                   class="inline-block px-4 py-2 rounded-full bg-gradient-to-r from-sky-500 to-blue-600 text-white font-semibold
                   shadow-md hover:shadow-lg hover:scale-105 transition-all duration-300">Đăng nhập</a>
                <button
                    class="inline-block px-4 py-2 rounded-full bg-gray-100 hover:bg-gray-200 font-medium hover:scale-105 border border-transparent transition-all duration-300">
                    Đăng ký
                </button>
            </div>
        </c:if>
    </div>
</header>

<!-- Style -->


<!-- Script -->
<script>
    // Hiệu ứng thu nhỏ khi cuộn
    window.addEventListener("scroll", () => {
        const nav = document.getElementById("navbar");
        if (window.scrollY > 50)
            nav.classList.add("scrolled");
        else
            nav.classList.remove("scrolled");
    });
</script>



<!-- Floating Vet Chatbox -->
<jsp:include page="/WEB-INF/include/chatbox.jsp" />

<%@include file="/WEB-INF/include/sidebarInfo.jsp" %>
<%@include file="/WEB-INF/include/cardID.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>

