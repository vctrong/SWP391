<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Phản hồi bác sĩ</title>
    <%@include file="/WEB-INF/include/library.jsp" %>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        .truncate { max-width: 22rem; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .indicator { transition: transform .2s ease; }
        .rotate-180 { transform: rotate(180deg); }
    </style>
    </head>
<body class="bg-white">
<jsp:include page="/WEB-INF/include/header.jsp" />
<div class="max-w-7xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h1 class="text-3xl font-extrabold tracking-tight text-gray-900">Phản hồi bác sĩ</h1>
            <p class="text-gray-500 mt-1">Danh sách các lần khám thú cưng của bạn.</p>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-700">${error}</div>
    </c:if>

    <div class="overflow-x-auto bg-white/80 backdrop-blur rounded-2xl shadow-xl border border-gray-100">
        <table class="min-w-full">
            <thead class="bg-gray-100/90 text-xs font-semibold text-gray-700 sticky top-0 z-10">
                <tr>
                    <th class="px-5 py-3 text-left">STT</th>
                    <th class="px-5 py-3 text-left">Ngày khám</th>
                    <th class="px-5 py-3 text-left">Loại khám</th>
                    <th class="px-5 py-3 text-left">Thú cưng</th>
                    <th class="px-5 py-3 text-left">Bác sĩ thú y</th>
                    <th class="px-5 py-3 text-left">Cân nặng (kg)</th>
                    <th class="px-5 py-3 text-left">Nhiệt độ (°C)</th>             
                    <th class="px-5 py-3 text-left">Chi tiết</th>
                </tr>
            </thead>
            <tbody class="text-sm text-gray-700">
                <c:forEach var="v" items="${visits}" varStatus="st">
                    <c:set var="typeClass" value="bg-gray-100 text-gray-700"/>
                    <c:choose>
                        <c:when test="${v.visitTypeCode == 'CHECKUP'}"><c:set var="typeClass" value="bg-sky-100 text-sky-700"/></c:when>
                        <c:when test="${v.visitTypeCode == 'EMERGENCY'}"><c:set var="typeClass" value="bg-red-100 text-red-700"/></c:when>
                        <c:when test="${v.visitTypeCode == 'SURGERY'}"><c:set var="typeClass" value="bg-purple-100 text-purple-700"/></c:when>
                        <c:when test="${v.visitTypeCode == 'ULTRASOUND'}"><c:set var="typeClass" value="bg-amber-100 text-amber-700"/></c:when>
                        <c:when test="${v.visitTypeCode == 'VACCINE'}"><c:set var="typeClass" value="bg-emerald-100 text-emerald-700"/></c:when>
                    </c:choose>
                    <!-- Summary Row -->
                    <tr class="group cursor-pointer border-b border-gray-100 hover:bg-blue-50/50 transition" data-expand-row>
                        <td class="px-5 py-3">
                            <c:set var="rowNumber" value="${(currentPage - 1)*pageSize + st.count}"/>
                            <span class="inline-flex items-center justify-center w-7 h-7 rounded-full bg-gray-100 text-gray-800 font-semibold">${rowNumber}</span>
                        </td>
                        <td class="px-5 py-3 font-medium text-gray-900">${v.visitDateFormatted}</td>
                        <td class="px-5 py-3">
                            <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-semibold ${typeClass}">${v.visitTypeCode}</span>
                            <span class="block text-gray-500 text-xs mt-1">${v.visitTypeDescription}</span>
                        </td>
                        <td class="px-5 py-3">
                            <div class="flex items-center gap-3">
                                <span class="inline-flex items-center justify-center h-8 w-8 rounded-full bg-blue-50 text-blue-700 font-semibold">${fn:substring(v.petName,0,1)}</span>
                                <span class="font-medium text-gray-900">${v.petName}</span>
                            </div>
                        </td>
                        <td class="px-5 py-3">
                            <div class="flex items-center gap-3">
                                <span class="inline-flex items-center justify-center h-8 w-8 rounded-full bg-rose-50 text-rose-700 font-semibold">${fn:substring(v.vetStaffName,0,1)}</span>
                                <span class="text-gray-900">${v.vetStaffName}</span>
                            </div>
                        </td>
                        <td class="px-5 py-3"><span class="px-2 py-0.5 rounded bg-gray-100 text-gray-800">${v.weightKg}</span></td>
                        <td class="px-5 py-3"><span class="px-2 py-0.5 rounded bg-orange-100 text-orange-800">${v.temperatureC}</span></td>
                        <td class="px-5 py-3">
                            <button type="button" class="text-blue-600 text-xs flex items-center gap-1 expand-btn">
                                <span class="indicator">▼</span><span>Xem chi tiết</span>
                            </button>
                        </td>
                    </tr>
                    <!-- Detail Row -->
                    <tr class="hidden bg-gray-50" data-detail-row>
                        <td colspan="9" class="px-6 py-5">
                            <div class="grid md:grid-cols-4 gap-6 text-sm">
                                <div class="p-4 rounded-xl border border-gray-200 bg-white">
                                    <h4 class="font-semibold text-gray-800 mb-1">Chẩn đoán</h4>
                                    <p class="text-gray-600">${v.diagnosisSummary}</p>
                                </div>
                                <div class="p-4 rounded-xl border border-gray-200 bg-white">
                                    <h4 class="font-semibold text-gray-800 mb-1">Điều trị</h4>
                                    <p class="text-gray-600">${v.treatmentNotes}</p>
                                </div>
                                <div class="p-4 rounded-xl border border-gray-200 bg-white">
                                    <h4 class="font-semibold text-gray-800 mb-1">Ngày tái khám</h4>
                                    <p class="text-gray-600"><c:out value="${v.followUpDate != null ? v.followUpDate : '-'}"/></p>
                                </div>
                                <div class="p-4 rounded-xl border border-gray-200 bg-white">
                                    <h4 class="font-semibold text-gray-800 mb-1">Tạo lúc</h4>
                                    <p class="text-gray-600">${v.createdAtFormatted}</p>
                                </div>
                                <div class="md:col-span-4 p-4 rounded-xl border border-gray-200 bg-white">
                                    <h4 class="font-semibold text-gray-800 mb-1">Triệu chứng đầy đủ</h4>
                                    <p class="text-gray-600">${v.symptoms}</p>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty visits}">
                    <tr>
                        <td colspan="9" class="px-6 py-14 text-center">
                            <div class="inline-flex flex-col items-center gap-2">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <p class="text-gray-500">Chưa có lần khám nào.</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <!-- Pagination Controls -->
    <c:if test="${totalPages > 1}">
        <div class="mt-6 flex items-center justify-center gap-2 flex-wrap">
            <c:set var="prevPage" value="${currentPage - 1}"/>
            <c:set var="nextPage" value="${currentPage + 1}"/>
            <a href="${pageContext.request.contextPath}/vet/visits?page=${prevPage}"
               class="px-3 py-2 rounded-lg border text-sm ${currentPage == 1 ? 'pointer-events-none opacity-40' : 'bg-white hover:bg-gray-50'}">Trước</a>
            <c:forEach begin="1" end="${totalPages}" var="p">
                <a href="${pageContext.request.contextPath}/vet/visits?page=${p}"
                   class="px-3 py-2 rounded-lg border text-sm ${p == currentPage ? 'bg-blue-600 text-white border-blue-600' : 'bg-white hover:bg-gray-50'}">${p}</a>
            </c:forEach>
            <a href="${pageContext.request.contextPath}/vet/visits?page=${nextPage}"
               class="px-3 py-2 rounded-lg border text-sm ${currentPage == totalPages ? 'pointer-events-none opacity-40' : 'bg-white hover:bg-gray-50'}">Sau</a>
        </div>
    </c:if>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('[data-expand-row]').forEach(function(summaryRow) {
        summaryRow.addEventListener('click', function(e) {
            // Avoid double toggle if clicking button area: let it work either way.
            const detailRow = summaryRow.nextElementSibling;
            if (!detailRow || !detailRow.hasAttribute('data-detail-row')) return;
            const btn = summaryRow.querySelector('.expand-btn');
            const indicator = summaryRow.querySelector('.indicator');
            const showing = !detailRow.classList.contains('hidden');
            // Collapse all other open rows for cleaner UI
            document.querySelectorAll('[data-detail-row]').forEach(r => { if (r !== detailRow) r.classList.add('hidden'); });
            document.querySelectorAll('.expand-btn .indicator').forEach(i => { if (i !== indicator) { i.textContent = '▼'; i.classList.remove('rotate-180'); } });
            document.querySelectorAll('.expand-btn span:nth-child(2)').forEach(t => { if (t !== btn.querySelector('span:nth-child(2)')) t.textContent = 'Xem chi tiết'; });
            if (showing) {
                detailRow.classList.add('hidden');
                indicator.textContent = '▼';
                indicator.classList.remove('rotate-180');
                btn.querySelector('span:nth-child(2)').textContent = 'Xem chi tiết';
            } else {
                detailRow.classList.remove('hidden');
                indicator.textContent = '▲';
                indicator.classList.add('rotate-180');
                btn.querySelector('span:nth-child(2)').textContent = 'Ẩn chi tiết';
            }
        });
    });
});
</script>
<jsp:include page="/WEB-INF/include/footer.jsp" />
</body>
</html>
