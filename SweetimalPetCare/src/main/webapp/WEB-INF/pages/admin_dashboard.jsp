<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div>
    <h2 class="text-2xl font-semibold mb-4">Tổng quan quản trị</h2>

    <div class="grid grid-cols-4 gap-4 mb-6">
        <div class="p-4 bg-white rounded shadow">
            <div class="text-sm text-gray-500">Người dùng</div>
            <div class="text-3xl font-bold text-blue-600">${userCount}</div>
        </div>
        <div class="p-4 bg-white rounded shadow">
            <div class="text-sm text-gray-500">Đơn hàng</div>
            <div class="text-3xl font-bold text-blue-600">${orderCount}</div>
        </div>
        <div class="p-4 bg-white rounded shadow">
            <div class="text-sm text-gray-500">Đặt lịch</div>
            <div class="text-3xl font-bold text-blue-600">${bookingCount}</div>
        </div>
        <div class="p-4 bg-white rounded shadow">
            <div class="text-sm text-gray-500">Sản phẩm</div>
            <div class="text-3xl font-bold text-blue-600">${productCount}</div>
        </div>
    </div>

    <section class="bg-white p-4 rounded shadow mb-6">
        <h3 class="font-semibold mb-2">Recent Audit Log</h3>
        <table class="w-full text-left">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Action</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${recentActions}">
                    <tr>
                        <td>${a.fullName}</td>
                        <td>${a.actionType}</td>
                        <td>${a.createdAt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </section>

    <section class="bg-white p-4 rounded shadow">
        <h3 class="font-semibold mb-2">Recent Bookings</h3>
        <table class="w-full text-left">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Service</th>
                    <th>When</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${recentBookings}">
                    <tr>
                        <td>${b.id}</td>
                        <td>${b.customerName}</td>
                        <td>${b.serviceName}</td>
                        <td>${b.requestedDate} ${b.requestedStart}</td>
                        <td>${b.currentStatus}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </section>
</div>