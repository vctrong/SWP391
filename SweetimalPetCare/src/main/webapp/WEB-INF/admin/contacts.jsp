<%-- 
    Document   : contacts
    Created on : Oct 31, 2025, 4:52:12 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                    <section id="page-contacts" class="page-section space-y-4">
                        <div class="flex items-center justify-between">
                            <h3 class="text-lg font-semibold">Contact & Support Requests</h3>
                        </div>
                        <div class="bg-white rounded-lg shadow-sm">
                            <div class="p-4">
                                <p class="text-gray-600 mb-4">Danh sách các yêu cầu tư vấn và liên hệ từ người dùng.</p>
                            </div>

                            <div class="divide-y divide-gray-200">
                                <c:if test="${not empty loadError}">
                                    <div class="p-4 text-sm text-red-600">${loadError}</div>
                                </c:if>
                                <c:choose>
                                    <c:when test="${empty consultationRequests}">
                                        <div class="p-4 text-sm text-gray-500">Không có yêu cầu tư vấn nào.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="cr" items="${consultationRequests}">
                                            <c:set var="name" value="${cr.customerName}" />
                                            <c:set var="initial" value="${empty name ? '?' : fn:toUpperCase(fn:substring(name,0,1))}" />
                                            <c:set var="approved" value="${cr.statusCode == 'ANSWERED' or cr.statusCode == 'CLOSED'}" />
                                            <c:set var="rowClass" value="${approved ? 'bg-gray-100 cursor-default' : 'hover:bg-gray-50 cursor-pointer'}" />
                                            <div class="py-4 px-4 flex gap-4 ${rowClass} cr-row">
                                                <div class="w-12 h-12 rounded-full bg-sky-100 text-sky-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">${initial}</div>
                                                <div class="flex-1 cr-content">
                                                    <div class="flex items-center justify-between">
                                                        <span class="font-medium text-gray-800 cr-name">${name}</span>
                                                        <div class="flex items-center gap-2">
                                                            <c:if test="${approved}">
                                                                <span class="px-2 py-0.5 text-xs rounded-full bg-emerald-100 text-emerald-700 font-medium">Đã duyệt</span>
                                                            </c:if>
                                                            <span class="text-xs text-gray-400 cr-created">${cr.createdAtFormatted}</span>
                                                        </div>
                                                    </div>
                                                    <p class="text-sm text-gray-500 mt-1">Loại tư vấn: <span class="text-gray-700 font-medium cr-subject">${cr.consultationTypeName}</span></p>
                                                    <p class="text-sm text-gray-600 mt-2 whitespace-pre-wrap break-words cr-message">"${cr.requestMessage}"</p>
                                                    <span class="hidden cr-email">${cr.email}</span>
                                                    <span class="hidden cr-phone">${cr.phone}</span>
                                                </div>
                                                <div class="flex items-start gap-2">
                                                    <c:choose>
                                                        <c:when test="${not approved}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/contact/approve">
                                                                <input type="hidden" name="id" value="${cr.requestId}" />
                                                                <input type="hidden" name="page" value="${currentPage}" />
                                                                <button type="submit" class="px-3 py-1.5 text-xs rounded-md bg-emerald-600 text-white hover:bg-emerald-700">Duyệt</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/contact/delete">
                                                                <input type="hidden" name="id" value="${cr.requestId}" />
                                                                <input type="hidden" name="page" value="${currentPage}" />
                                                                <button type="button" onclick="if (confirm('Xóa yêu cầu này?')) this.form.submit();" class="px-3 py-1.5 text-xs rounded-md bg-red-600 text-white hover:bg-red-700">Xóa</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <!-- Modal hiển thị chi tiết yêu cầu -->
                            <div id="crModal" class="fixed inset-0 hidden items-center justify-center z-30">
                                <div class="absolute inset-0 bg-black bg-opacity-40" id="crModalOverlay"></div>
                                <div class="relative bg-white w-11/12 md:w-[680px] rounded-lg shadow-lg p-5 md:p-6 z-10">
                                    <div class="flex items-center justify-between mb-3">
                                        <h4 class="text-lg font-semibold">Chi tiết yêu cầu</h4>
                                        <button id="crModalClose" class="p-2 rounded hover:bg-gray-100" aria-label="Đóng">✕</button>
                                    </div>
                                    <div class="space-y-2 text-sm">
                                        <div><span class="text-gray-500">Họ tên:</span> <span id="crDtlName" class="font-medium text-gray-800"></span></div>
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                            <div><span class="text-gray-500">Email:</span> <span id="crDtlEmail" class="text-gray-800"></span></div>
                                            <div><span class="text-gray-500">SĐT:</span> <span id="crDtlPhone" class="text-gray-800"></span></div>
                                        </div>
                                        <div><span class="text-gray-500">Loại tư vấn:</span> <span id="crDtlSubject" class="text-gray-800"></span></div>
                                        <div>
                                            <div class="text-gray-500 mb-1">Nội dung:</div>
                                            <pre id="crDtlMessage" class="whitespace-pre-wrap break-words text-gray-800 bg-gray-50 rounded-md p-3 max-h-96 overflow-auto"></pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="px-4 py-3 flex items-center justify-between border-t border-gray-100 bg-gray-50">
                                <div class="text-sm text-gray-600">
                                    <c:choose>
                                        <c:when test="${totalItems > 0}">
                                            Hiển thị ${startIndex}–${endIndex} trên ${totalItems} yêu cầu
                                        </c:when>
                                        <c:otherwise>Không có dữ liệu</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex items-center gap-1">
                                    <c:choose>
                                        <c:when test="${hasPrev}">
                                            <c:url var="prevUrl" value="${baseUrl}"><c:param name="page" value="${currentPage - 1}" /></c:url>
                                            <a href="${prevUrl}" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">Trước</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" class="px-3 py-1.5 rounded-md text-sm border bg-gray-100 text-gray-400 cursor-not-allowed">Trước</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="hidden md:flex items-center gap-1">
                                        <c:if test="${windowStart > 1}">
                                            <c:url var="firstUrl" value="${baseUrl}"><c:param name="page" value="1" /></c:url>
                                            <a href="${firstUrl}" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">1</a>
                                            <c:if test="${windowStart > 2}"><span class="px-2 text-gray-400">…</span></c:if>
                                        </c:if>
                                        <c:forEach var="p" items="${pagesWindow}">
                                            <c:set var="active" value="${p == currentPage}" />
                                            <c:choose>
                                                <c:when test="${active}">
                                                    <a href="#" class="px-3 py-1.5 rounded-md text-sm border bg-sky-600 border-sky-600 text-white">${p}</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="pageUrl" value="${baseUrl}"><c:param name="page" value="${p}" /></c:url>
                                                    <a href="${pageUrl}" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">${p}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${windowEnd < totalPages}">
                                            <c:if test="${windowEnd < totalPages - 1}"><span class="px-2 text-gray-400">…</span></c:if>
                                            <c:url var="lastUrl" value="${baseUrl}"><c:param name="page" value="${totalPages}" /></c:url>
                                            <a href="${lastUrl}" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">${totalPages}</a>
                                        </c:if>
                                    </div>
                                    <c:choose>
                                        <c:when test="${hasNext}">
                                            <c:url var="nextUrl" value="${baseUrl}"><c:param name="page" value="${currentPage + 1}" /></c:url>
                                            <a href="${nextUrl}" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">Sau</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="#" class="px-3 py-1.5 rounded-md text-sm border bg-gray-100 text-gray-400 cursor-not-allowed">Sau</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script>
            (function () {
                const modal = document.getElementById('crModal');
                if (!modal) return;
                const closeBtn = document.getElementById('crModalClose');
                const overlay = document.getElementById('crModalOverlay');

                function openModal() {
                    modal.classList.remove('hidden');
                    modal.classList.add('flex');
                }
                function closeModal() {
                    modal.classList.add('hidden');
                    modal.classList.remove('flex');
                }
                closeBtn && closeBtn.addEventListener('click', closeModal);
                overlay && overlay.addEventListener('click', closeModal);

                function getText(row, sel) {
                    var el = row.querySelector(sel);
                    if (!el) return '';
                    var t = el.textContent;
                    return (typeof t === 'string') ? t.trim() : '';
                }
                function getRaw(row, sel) {
                    var el = row.querySelector(sel);
                    if (!el) return '';
                    var t = el.textContent;
                    return (typeof t === 'string') ? t : '';
                }

                document.querySelectorAll('.cr-row').forEach(function(row) {
                    row.addEventListener('click', function(e) {
                        if (e.target.closest('form') || e.target.closest('button')) return; // ignore form/button clicks
                        var name = getText(row, '.cr-name');
                        var email = getText(row, '.cr-email');
                        var phone = getText(row, '.cr-phone');
                        var subject = getText(row, '.cr-subject');
                        var message = getRaw(row, '.cr-message').replace(/^"|"$/g, '');

                        document.getElementById('crDtlName').textContent = name;
                        document.getElementById('crDtlEmail').textContent = email || '(không có)';
                        document.getElementById('crDtlPhone').textContent = phone || '(không có)';
                        document.getElementById('crDtlSubject').textContent = subject;
                        document.getElementById('crDtlMessage').textContent = message;
                        openModal();
                    });
                });
            })();
        </script>
    </body>
    
</html>
