<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="daos.CartItemsDAO, model.CartItem, model.Users, java.util.List" %>
<link href="${pageContext.request.contextPath}/assets/css/header.css" rel="stylesheet" >
<!-- Page loader (site-wide). Can be disabled by setting request attribute disableLoader=true -->
<c:if test="${not disableLoader}">
    <div id="page-loader" aria-hidden="true" class="fixed inset-0 bg-white z-50 flex items-center justify-center" style="transition:opacity .25s ease; display: none;">
        <div class="flex items-center space-x-3">
            <i class="fa-solid fa-circle-notch fa-2x animate-spin text-blue-600"></i>
            <span class="text-gray-700 font-medium">Đang tải...</span>
        </div>
        <span class="sr-only">Loading</span>
    </div>
    
</c:if>

<c:set var="current" value="${pageContext.request.requestURI}" />

<header id="navbar"
        class="sticky top-0 left-0 w-full z-30 bg-white/40 backdrop-blur-md border-b border-sky-100 shadow-sm transition-all duration-500">
    <div class="container mx-auto flex justify-between items-center py-4 px-6">
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

        <nav class="hidden lg:flex items-center space-x-1 text-gray-700 font-medium">
            <a href="${pageContext.request.contextPath}/home"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/home') ? 'active' : ''}">Trang chủ</a>

            <a href="${pageContext.request.contextPath}/services"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/services') ? 'active' : ''}">Dịch vụ</a>

            <a href="${pageContext.request.contextPath}/shop"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/shop') ? 'active' : ''}">Cửa hàng</a>

            <a href="${pageContext.request.contextPath}/contacts"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/Contacts') ? 'active' : ''}">Liên hệ</a>

            <a href="${pageContext.request.contextPath}/aboutUs"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/aboutus') ? 'active' : ''}">Về chúng tôi</a>

            <a href="${pageContext.request.contextPath}/news"
               class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
               hover:text-blue-600 hover:border-blue-400
               ${fn:contains(current, '/news') ? 'active' : ''}">Tin tức</a>

            <c:if test="${not empty user and user.roleEnum == 'CUSTOMER'}">
                <a href="${pageContext.request.contextPath}/booking-history"
                   class="nav-link px-3 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                   hover:text-blue-600 hover:border-blue-400
                   ${fn:contains(current, '/bookingHistory') ? 'active' : ''}">
                    Lịch sử đặt lịch
                </a>
            </c:if>
        </nav>

        <c:if test="${not empty user}">
            <div class="space-x-4 flex items-center">
                <div class="px-1 py-1 rounded-full transform hover:scale-105 hover:text-blue-600 transition">
                    <button id="userMenuButton"
                            class="flex items-center space-x-2 bg-gradient-to-r from-sky-500 to-blue-600 hover:from-blue-600 hover:to-blue-700
                            text-white px-4 py-2 rounded-full shadow-md hover:shadow-lg transition duration-300 focus:outline-none
                            focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50
                            whitespace-nowrap">
                        ${user.fullName}
                    </button>
                </div>

                <%
                    // compute cart count for logged-in user (sum of quantities)
                    int cartCount = 0;
                    try {
                        CartItemsDAO _cartDao = new CartItemsDAO();
                        Object _userObj = session.getAttribute("user");
                        long _userId = -1L;
                        if (_userObj instanceof Users) {
                            _userId = ((Users)_userObj).getId();
                        }
                        List<CartItem> _items = null;
                        if (_userId > 0) {
                            _items = _cartDao.getCartItemsByUser(_userId);
                        }
                        if (_items != null) {
                            for (CartItem _ci : _items) {
                                if (_ci != null) cartCount += _ci.getQuantity();
                            }
                        }
                    } catch (Throwable _t) {
                        cartCount = 0;
                    }
                %>

                <a href="${pageContext.request.contextPath}/cart"
                   class="inline-flex items-center gap-2 px-3 py-2 rounded-full bg-white border shadow-sm hover:shadow-md transition mr-2 relative">
                    <i class="fa-solid fa-cart-shopping text-gray-700"></i>
                    <span class="cart-count absolute -top-2 -right-2 bg-red-600 text-white text-xs font-semibold rounded-full px-2 py-0.5"><%= cartCount %></span>
                </a>
            </div>
        </c:if>

        <c:if test="${empty user}">
            <div class="space-x-4">
                <a href="${pageContext.request.contextPath}/login"
                   class="inline-block px-4 py-2 rounded-full bg-gradient-to-r from-sky-500 to-blue-600 text-white font-semibold
                   shadow-md hover:shadow-lg hover:scale-105 transition-all duration-300">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register"
                   class="inline-block px-4 py-2 rounded-full bg-gray-100 hover:bg-gray-200 font-medium hover:scale-105 border border-transparent transition-all duration-300">
                    Đăng ký
                </a>
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