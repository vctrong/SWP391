<%--
    Document   : dashboard
    Created on : Oct 3, 2025, 6:50:09 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="enums.BookingStatusColor"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="/WEB-INF/include/header.jsp" %>
        <title>Admin Dashboard</title>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <div class="container mx-auto px-6 py-8">
            <div class="flex items-center justify-between mb-8">
                <h1 class="text-2xl font-semibold">Admin Dashboard</h1>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/services" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                        <i class="fa-solid fa-wrench mr-2"></i> Manage Services
                    </a>
                </div>
            </div>

            <c:if test="${accessDenied}">
                <div class="mb-6 text-red-600 font-medium">Access Denied: You must be an administrator to view this page.</div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                <div class="bg-white p-4 rounded-lg shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-blue-100 text-blue-700 rounded-full">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">Users</div>
                        <div class="text-xl font-bold">${userCount}</div>
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-green-100 text-green-700 rounded-full">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">Orders</div>
                        <div class="text-xl font-bold">${orderCount}</div>
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-yellow-100 text-yellow-700 rounded-full">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">Bookings</div>
                        <div class="text-xl font-bold">${bookingCount}</div>
                    </div>
                </div>
                <div class="bg-white p-4 rounded-lg shadow-sm flex items-center space-x-4">
                    <div class="p-3 bg-purple-100 text-purple-700 rounded-full">
                        <i class="fa-solid fa-box-open"></i>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">Products</div>
                        <div class="text-xl font-bold">${productCount}</div>
                    </div>
                </div>
            </div>

            <div class="space-y-8">
                <!-- Recent Actions -->
                <section class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-semibold">Recent User Actions</h2>
                        <a href="#" class="text-sm text-blue-600">View all</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">User</th>
                                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Details</th>
                                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <c:forEach var="a" items="${recentActions}">
                                    <tr>
                                        <td class="px-4 py-3">${a.fullName}</td>
                                        <td class="px-4 py-3">${a.email}</td>
                                        <td class="px-4 py-3 text-sm text-gray-600">${a.actionType}</td>
                                        <td class="px-4 py-3 text-sm text-gray-600">${a.description}</td>
                                        <td class="px-4 py-3 text-sm text-gray-500">${a.createdAt}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentActions}">
                                    <tr><td colspan="5" class="px-4 py-6 text-center text-gray-400">No recent logs found</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Recent Bookings -->
                <section class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-semibold">Recent Bookings</h2>
                        <a href="#" class="text-sm text-blue-600">View all</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Customer</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Pet</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Service</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">When</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Price</th>
                                    <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <c:forEach var="b" items="${recentBookings}">
                                    <tr>
                                        <td class="px-3 py-3">${b.id}</td>
                                        <td class="px-3 py-3">${b.customerName}</td>
                                        <td class="px-3 py-3">${b.petName}</td>
                                        <td class="px-3 py-3">${b.serviceName}</td>
                                        <td class="px-3 py-3">${b.requestedDate} ${b.requestedStart}</td>
                                        <td class="px-3 py-3">
                                            <% 
                                               Object __bObj = pageContext.getAttribute("b");
                                               String __status = null;
                                               if (__bObj != null) {
                                                   model.BookingSummary __bCast = (model.BookingSummary)__bObj;
                                                   __status = __bCast.getCurrentStatus();
                                               }
                                               BookingStatusColor st = BookingStatusColor.fromString(__status);
                                            %>
                                            <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium <%=st.getBgClass()%> <%=st.getTextClass()%>"><%=st.getLabel()%></span>
                                        </td>
                                        <td class="px-3 py-3">${b.totalPrice}</td>
                                        <td class="px-3 py-3">
                                            <form action="${pageContext.request.contextPath}/admin/booking/status" method="post" class="flex items-center space-x-2">
                                                <input type="hidden" name="bookingId" value="${b.id}"/>
                                                <select name="status" class="border rounded px-2 py-1 text-sm">
                                                    <option value="PENDING" <c:if test="${b.currentStatus == 'PENDING'}">selected</c:if>>PENDING</option>
                                                    <option value="CONFIRMED" <c:if test="${b.currentStatus == 'CONFIRMED'}">selected</c:if>>CONFIRMED</option>
                                                    <option value="IN_PROGRESS" <c:if test="${b.currentStatus == 'IN_PROGRESS'}">selected</c:if>>IN_PROGRESS</option>
                                                    <option value="COMPLETED" <c:if test="${b.currentStatus == 'COMPLETED'}">selected</c:if>>COMPLETED</option>
                                                    <option value="CANCELLED" <c:if test="${b.currentStatus == 'CANCELLED'}">selected</c:if>>CANCELLED</option>
                                                </select>
                                                <button type="submit" class="bg-blue-600 text-white px-3 py-1 rounded text-sm">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentBookings}">
                                    <tr><td colspan="8" class="px-4 py-6 text-center text-gray-400">No bookings found</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            
        </div>
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
