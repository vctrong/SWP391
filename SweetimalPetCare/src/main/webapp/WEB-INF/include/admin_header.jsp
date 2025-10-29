<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Admin sidebar (include this inside a container with a sibling content area) -->
<aside class="w-64 bg-white border-r p-4">
    <div class="mb-6">
        <h3 class="font-semibold text-lg">Admin Dashboard</h3>
    </div>
    <nav class="space-y-2">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="block px-3 py-2 rounded hover:bg-gray-100">Tổng quan</a>
        <a href="${pageContext.request.contextPath}/admin/services" class="block px-3 py-2 rounded hover:bg-gray-100">Quản lý dịch vụ</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="block px-3 py-2 rounded hover:bg-gray-100">Người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/bookings" class="block px-3 py-2 rounded hover:bg-gray-100">Đặt lịch</a>
        <a href="${pageContext.request.contextPath}/admin/products" class="block px-3 py-2 rounded hover:bg-gray-100">Sản phẩm</a>
    </nav>
</aside>
