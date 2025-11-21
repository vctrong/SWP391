<%-- 
    Document   : orders
    Created on : Oct 31, 2025, 4:52:02 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Services Admin | Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="includes/headAdmin.jsp" %>
    </head>
    <body  class="font-inter bg-gray-50 text-gray-800">
        <div class="min-h-screen flex">
            <%@include file="../admin/includes/admin_sidebar.jsp" %>
            <%@include file="includes/mobileApp.jsp" %>
            <div class="flex-1 md:pl-72">
                <%@include file="includes/admin_header.jsp" %>
                <main class="p-4 md:p-8">
                    <section id="page-orders" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold">Order Management</h3>
                            <div class="flex items-center gap-2">
                                <input id="orderSearch" placeholder="Search orders..." class="input-field" />
                                <select id="orderStatusFilter" class="input-field">
                                    <option value="">All</option>
                                    <option>Unpaid</option>
                                    <option>Paid</option>
                                    <option>Processing</option>
                                    <option>Delivered</option>
                                </select>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell">Order ID</th>
                                            <th class="table-header-cell">Customer</th>
                                            <th class="table-header-cell text-center">Date</th>
                                            <th class="table-header-cell text-right">Total</th>
                                            <th class="table-header-cell text-center">Payment</th>
                                            <th class="table-header-cell text-center">Shipping</th>
                                        </tr>
                                    </thead>
                                    <tbody id="ordersTableBody" class="text-sm divide-y divide-gray-200">
                                        <c:choose>
                                            <c:when test="${not empty orders}">
                                                <c:forEach var="o" items="${orders}">
                                                    <tr>
                                                        <td class="px-4 py-3"><a class="text-blue-600 hover:underline" href="${pageContext.request.contextPath}/admin/order/view?id=${o.orderId}">${o.orderCode}</a></td>
                                                        <td class="px-4 py-3">${o.customerName}</td>
                                                        <td class="px-4 py-3 text-center"><fmt:formatDate value="${o.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                        <td class="px-4 py-3 text-right"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                                        <td class="px-4 py-3 text-center">${o.paymentStatus}</td>
                                                        <td class="px-4 py-3 text-center">${o.orderStatus}</td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="6" class="px-4 py-6 text-center text-sm text-gray-500">No orders found.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
    </body>
</html>
