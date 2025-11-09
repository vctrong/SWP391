<%-- News page pulling RSS items --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <title>Tin tức thú cưng</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <style>
            body.news-page #page-loader { display: none !important; }
        </style>
        </head>
    <body class="bg-gray-50 text-gray-800 news-page">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <h1 class="text-3xl font-bold text-blue-700 mb-8">Tin tức thú cưng</h1>

            <c:choose>
                <c:when test="${empty items}">
                    <div class="bg-white rounded-xl p-8 text-center shadow">
                        <p>Không có bài viết phù hợp. Thử nguồn khác hoặc từ khóa khác.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid gap-6 grid-cols-1 md:grid-cols-2">
                        <c:forEach var="n" items="${items}">
                            <a href="${n.link}" target="_blank" class="block bg-white rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl hover:-translate-y-0.5 transition">
                                <c:choose>
                                    <c:when test="${not empty n.imageUrl}">
                                        <div class="w-full h-52 bg-gray-100 flex items-center justify-center overflow-hidden">
                                            <img src="${n.imageUrl}" alt="${n.title}"
                                                 class="max-h-full w-auto"
                                                 onerror="this.parentElement.style.display='none';"/>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- no image -->
                                    </c:otherwise>
                                </c:choose>
                                <div class="p-5">
                                    <div class="text-[11px] font-semibold uppercase tracking-wider text-gray-500 mb-2"> 
                                        <c:choose>
                                            <c:when test="${n.source == 'petcarevn'}">PetCare.vn</c:when>
                                            <c:otherwise>Tin tức</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h2 class="font-bold text-xl text-gray-900 mb-2">
                                        <c:choose>
                                            <c:when test="${fn:length(n.title) > 100}">${fn:substring(n.title,0,100)}...</c:when>
                                            <c:otherwise>${n.title}</c:otherwise>
                                        </c:choose>
                                    </h2>
                                    <p class="text-sm leading-6 text-gray-600">
                                        <c:choose>
                                            <c:when test="${fn:length(n.description) > 180}">${fn:substring(n.description,0,180)}...</c:when>
                                            <c:otherwise>${n.description}</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="mt-4 flex items-center justify-between text-xs text-gray-500">
                                        <span class="truncate max-w-[50%]">${n.author}</span>
                                        <span class="shrink-0">
                                            <fmt:formatDate value="${n.publishedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:if test="${totalPages > 1}">
                <div class="mt-10 flex items-center justify-center gap-2">
                    <c:if test="${page > 1}">
                        <a href="news?page=${page - 1}"
                           class="px-4 py-2 rounded-lg border text-gray-700 hover:bg-gray-50">« Trước</a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="news?page=${i}"
                           class="px-3 py-2 rounded-lg border ${i == page ? 'bg-blue-600 text-white border-blue-600' : 'text-gray-700 hover:bg-gray-50'}">${i}</a>
                    </c:forEach>

                    <c:if test="${page < totalPages}">
                        <a href="news?page=${page + 1}"
                           class="px-4 py-2 rounded-lg border text-gray-700 hover:bg-gray-50">Tiếp »</a>
                    </c:if>
                </div>
            </c:if>
        </div>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
