<%-- 
    Document   : bookingRow
    Created on : Nov 13, 2025, 11:56:14 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:forEach items="${bookingList}" var="b">
    <tr class="hover:bg-gray-50 transition-colors">
        <td class="py-3 px-4 font-medium text-gray-900"> #${b.bookingID} </td>

        <td class="py-3 px-4">
            <div class="font-medium text-gray-800">${b.fullName}</div>
            <div class="text-xs text-gray-500">${b.customerID}</div>
        </td>

        <td class="py-3 px-4">
            <span class="bg-blue-50 text-blue-700 py-1 px-2 rounded text-xs font-semibold">
                ${b.petName}
            </span>
        </td>

        <td class="py-3 px-4">
            <div class="text-gray-800">${b.item}</div>
            <div class="text-xs text-gray-500 italic">${b.type} 
                <c:if test="${b.type == 'Service'}">(${b.duration} min)</c:if>
                </div>
            </td>

            <td class="py-3 px-4">
                <div>${b.reqDate}</div>
            <div class="text-xs text-gray-500">${b.reqStart}</div>
        </td>

        <td class="py-3 px-4 font-medium">
            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
        </td>

        <td class="py-3 px-4">
            <%-- Logic màu sắc cho Badge --%>
            <c:set var="statusColor" value="bg-gray-100 text-gray-800" />
            <c:if test="${b.currentStatus == 'PENDING'}"><c:set var="statusColor" value="bg-yellow-100 text-yellow-800" /></c:if>
            <c:if test="${b.currentStatus == 'CONFIRMED'}"><c:set var="statusColor" value="bg-green-100 text-green-800" /></c:if>
            <c:if test="${b.currentStatus == 'IN_PROGRESS'}"><c:set var="statusColor" value="bg-blue-100 text-blue-800" /></c:if>
            <c:if test="${b.currentStatus == 'CANCELLED' || b.currentStatus == 'NO_SHOW'}"><c:set var="statusColor" value="bg-red-100 text-red-800" /></c:if>

                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${statusColor}">
                ${b.currentStatus}
            </span>
        </td>

        <td class="py-3 px-4">
            <button onclick="viewFromTable(${b.bookingID}, '${b.reqDate}')" class="text-indigo-600 hover:text-indigo-900 font-medium focus:outline-none">View</button>
            <c:if test="${(b.currentStatus == 'IN_PROGRESS' || b.currentStatus == 'COMPLETED') && b.vet}">

                <button onclick="openVetModal(${b.bookingID}, ${b.petID}, ${b.customerID}, '${b.petName}')"
                        class="text-teal-600 hover:text-teal-900 font-medium ml-2" 
                        title="Ghi bệnh án">
                    <svg class="w-5 h-5 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path>
                    </svg>
                </button>

            </c:if>
        </td>
    </tr>
</c:forEach>

<%-- Xử lý khi không tìm thấy dữ liệu --%>
<c:if test="${empty bookingList}">
    <tr>
        <td colspan="8" class="py-8 text-center text-gray-500">
            No bookings found matching your criteria.
        </td>
    </tr>
</c:if>

<%-- QUAN TRỌNG: Input ẩn để gửi thông số phân trang về cho JS --%>
<input type="hidden" id="ajax-total-pages" value="${totalPages}" />
<input type="hidden" id="ajax-current-page" value="${currentPage}" />
<input type="hidden" id="ajax-total-records" value="${totalRecords}" />
