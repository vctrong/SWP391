<%-- 
    Document   : sidebarProfileUser
    Created on : Nov 16, 2025, 5:50:56 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<c:choose>
    <c:when test="${not empty param.tab}">
        <c:set var="activeTab" value="${param.tab}" />
    </c:when>
    <c:otherwise>
        <c:set var="activeTab" value="overview" />
    </c:otherwise>
</c:choose>

<aside
    class="bg-white shadow-md rounded-2xl p-4 h-auto lg:h-[calc(100vh-6rem)] lg:w-64
    lg:sticky lg:top-24 lg:overflow-auto flex flex-col justify-between z-10"
    role="navigation" aria-label="Profile sidebar">

    <!-- Top: nav links -->
    <nav class="space-y-2" aria-label="Profile sections">
        <a href="${pageContext.request.contextPath}/profile?tab=overview"
           class="flex items-center gap-3 p-3 rounded-xl transition-colors duration-150
           ${activeTab == 'overview' ? 'bg-sky-50 text-sky-600 font-medium' : 'text-slate-700 hover:bg-slate-50'}"
           aria-current="${activeTab == 'overview' ? 'page' : 'false'}">
            <!-- icon: home -->
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
            <path d="M3 10.5L12 4l9 6.5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M5 21V11h14v10" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
            <span class="text-sm">Tổng quan</span>
        </a>

        <a href="${pageContext.request.contextPath}/profile?tab=history"
           class="flex items-center gap-3 p-3 rounded-xl transition-colors duration-150
           ${activeTab == 'history' ? 'bg-sky-50 text-sky-600 font-medium' : 'text-slate-700 hover:bg-slate-50'}"
           aria-current="${activeTab == 'history' ? 'page' : 'false'}">
            <!-- icon: orders -->
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
            <path d="M3 7h18" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M6 7l1 12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-12" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M10 11h4" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
            <span class="text-sm">Lịch sử giao dich</span>
        </a>

        <a href="${pageContext.request.contextPath}/profile?tab=account"
           class="flex items-center gap-3 p-3 rounded-xl transition-colors duration-150
           ${activeTab == 'account' ? 'bg-sky-50 text-sky-600 font-medium' : 'text-slate-700 hover:bg-slate-50'}"
           aria-current="${activeTab == 'account' ? 'page' : 'false'}">
            <!-- icon: account -->
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
            <path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M4 20a8 8 0 0 1 16 0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
            <span class="text-sm">Thông tin tài khoản</span>
        </a>


        <a href="${pageContext.request.contextPath}/profile?tab=support"
           class="flex items-center gap-3 p-3 rounded-xl transition-colors duration-150
           ${activeTab == 'support' ? 'bg-sky-50 text-sky-600 font-medium' : 'text-slate-700 hover:bg-slate-50'}"
           aria-current="${activeTab == 'support' ? 'page' : 'false'}">
            <!-- icon: support -->
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
            <path d="M21 15a2 2 0 0 1-2 2H9l-4 4V5a2 2 0 0 1 2-2h10" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
            <span class="text-sm">Góp ý - Hỗ trợ</span>
        </a>

        <a href="${pageContext.request.contextPath}/profile?tab=policy"
           class="flex items-center gap-3 p-3 rounded-xl transition-colors duration-150
           ${activeTab == 'policy' ? 'bg-sky-50 text-sky-600 font-medium' : 'text-slate-700 hover:bg-slate-50'}"
           aria-current="${activeTab == 'policy' ? 'page' : 'false'}">
            <!-- icon: policy -->
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
            <path d="M12 2l7 4v6c0 5-4 9-7 10-3-1-7-5-7-10V6l7-4z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
            </svg>
            <span class="text-sm">Chính sách & Điều khoản</span>
        </a>
    </nav>

    <!-- Footer area: placed at bottom of sidebar -->
    <div class="mt-4">
        <div class="border-t border-slate-100 pt-4">
            <div class="text-xs text-slate-500 mb-2 px-1">Tùy chọn</div>

            <form action="${pageContext.request.contextPath}/logout" method="get" class="m-0">
                <%-- Insert CSRF token here if your framework requires it:
                     <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                --%>
                <button type="submit"
                        class="w-full flex items-center gap-3 p-3 rounded-xl text-sm text-red-600 hover:bg-red-50 transition-colors">
                    <!-- logout icon -->
                    <svg class="w-5 h-5 text-red-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
                    <path d="M16 17l5-5-5-5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <path d="M21 12H9" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <path d="M9 19H6a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h3" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    </svg>
                    <span>Đăng xuất</span>
                </button>
            </form>
        </div>
    </div>
</aside>
