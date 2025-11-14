<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đánh giá dịch vụ - ${service.name}</title>
    <jsp:include page="/WEB-INF/include/library.jsp" />
</head>
<body class="bg-gray-50">
<jsp:include page="/WEB-INF/include/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <div class="mb-6">
        <a href="${pageContext.request.contextPath}/services" class="text-blue-600 hover:underline"><i class="fa fa-arrow-left"></i> Quay lại danh sách dịch vụ</a>
    </div>

    <h1 class="text-2xl md:text-3xl font-bold text-gray-900 mb-2">Đánh giá dịch vụ: <span class="text-blue-600">${service.name}</span></h1>
    <p class="text-gray-600 mb-6">${service.description}</p>

    <!-- Alerts (support flash from session) -->
    <c:set var="_flashSuccess" value="${not empty flashSuccess ? flashSuccess : sessionScope.flashSuccess}" />
    <c:set var="_flashError" value="${not empty flashError ? flashError : sessionScope.flashError}" />
    <c:if test="${not empty _flashSuccess}">
        <div class="mb-4 p-4 rounded bg-green-100 text-green-700">${_flashSuccess}</div>
        <c:remove var="flashSuccess" scope="session" />
    </c:if>
    <c:if test="${not empty _flashError}">
        <div class="mb-4 p-4 rounded bg-red-100 text-red-700">${_flashError}</div>
        <c:remove var="flashError" scope="session" />
    </c:if>
    <c:if test="${not empty errors}">
        <div class="mb-4 p-4 rounded bg-red-100 text-red-700">
            <ul class="list-disc ml-6">
                <c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach>
            </ul>
        </div>
    </c:if>

    
        <div class="md:col-span-1 bg-white p-6 rounded-lg shadow">
            <div class="flex items-center mb-4">
                <div class="text-4xl font-bold mr-2">${avgText}</div>
                <div class="flex text-yellow-400">
                    <c:forEach var="i" begin="1" end="5">
                        <i class="fa${i <= avgRounded ? 's' : 'r'} fa-star mr-1"></i>
                    </c:forEach>
                </div>
            </div>
     

        <!-- Review list + form -->
        <div class="md:col-span-2 space-y-6">
            <c:if test="${empty user or user.role == 1}">
                <jsp:include page="/WEB-INF/include/review-form.jsp" />
            </c:if>
            <jsp:include page="/WEB-INF/include/review-list.jsp" />
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/include/footer.jsp" />

<script>
    // Apply width percentages to progress bars after DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.js-bar').forEach(function(el){
            var pct = el.getAttribute('data-width');
            if (!pct) pct = 0;
            el.style.width = pct + '%';
        });
    });
    </script>

</body>
</html>
