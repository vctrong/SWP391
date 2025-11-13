<%-- 
    Document   : contacts
    Created on : Oct 31, 2025, 4:52:12 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                                <%
                                    java.util.List<model.ConsultationRequest> crList = (java.util.List<model.ConsultationRequest>) request.getAttribute("consultationRequests");
                                    String loadError = (String) request.getAttribute("loadError");
                                    java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
                                    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
                                    Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
                                    Integer pageSizeObj = (Integer) request.getAttribute("pageSize");
                                    int currentPage = currentPageObj != null ? currentPageObj : 1;
                                    int totalItems = totalItemsObj != null ? totalItemsObj : (crList != null ? crList.size() : 0);
                                    int pageSize = pageSizeObj != null ? pageSizeObj : 15;
                                    int totalPages = (totalPagesObj != null && totalPagesObj > 0) ? totalPagesObj : ((totalItems + pageSize - 1) / Math.max(pageSize, 1));
                                    int startIndex = (totalItems == 0) ? 0 : ((currentPage - 1) * pageSize + 1);
                                    int endIndex = Math.min(currentPage * pageSize, totalItems);
                                    String baseUrl = request.getContextPath() + "/admin/contact";
                                %>
                                <% if (loadError != null) { %>
                                    <div class="p-4 text-sm text-red-600"><%= loadError %></div>
                                <% } %>
                                <% if (crList == null || crList.isEmpty()) { %>
                                    <div class="p-4 text-sm text-gray-500">Không có yêu cầu tư vấn nào.</div>
                                <% } else { 
                                    for (model.ConsultationRequest cr : crList) { 
                                        String name = cr.getCustomerName();
                                        String initial = (name != null && !name.isEmpty()) ? name.substring(0,1).toUpperCase() : "?";
                                        String subject = cr.getSubject();
                                        String message = cr.getRequestMessage();
                                        String created = (cr.getCreatedAt() != null) ? dtf.format(cr.getCreatedAt()) : "";
                                %>
                                <div class="py-4 px-4 flex gap-4 hover:bg-gray-50 cursor-pointer">
                                    <div class="w-12 h-12 rounded-full bg-sky-100 text-sky-600 flex-shrink-0 flex items-center justify-center font-bold text-lg"><%= initial %></div>
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between">
                                            <span class="font-medium text-gray-800"><%= name %></span>
                                            <span class="text-xs text-gray-400"><%= created %></span>
                                        </div>
                                        <p class="text-sm text-gray-500 mt-1">Chủ đề: <span class="text-gray-700 font-medium"><%= subject %></span></p>
                                        <p class="text-sm text-gray-600 mt-2 whitespace-pre-wrap break-words">"<%= message %>"</p>
                                    </div>
                                </div>
                                <% } } %>
                            </div>
                            <div class="px-4 py-3 flex items-center justify-between border-t border-gray-100 bg-gray-50">
                                <div class="text-sm text-gray-600">
                                    <% if (totalItems > 0) { %>
                                        Hiển thị <%= startIndex %>–<%= endIndex %> trên <%= totalItems %> yêu cầu
                                    <% } else { %>
                                        Không có dữ liệu
                                    <% } %>
                                </div>
                                <div class="flex items-center gap-1">
                                    <% boolean hasPrev = currentPage > 1; boolean hasNext = totalPages > 0 && currentPage < totalPages; %>
                                    <a href="<%= hasPrev ? (baseUrl + "?page=" + (currentPage - 1)) : "#" %>"
                                       class="px-3 py-1.5 rounded-md text-sm border <%= hasPrev ? "bg-white text-gray-700 hover:bg-gray-100" : "bg-gray-100 text-gray-400 cursor-not-allowed" %>">
                                        Trước
                                    </a>
                                    <div class="hidden md:flex items-center gap-1">
                                        <%
                                            int window = 2; // show current +/- 2 pages
                                            int start = Math.max(1, currentPage - window);
                                            int end = Math.min(totalPages, currentPage + window);
                                            if (start > 1) {
                                        %>
                                            <a href="<%= baseUrl %>?page=1" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100">1</a>
                                            <% if (start > 2) { %>
                                                <span class="px-2 text-gray-400">…</span>
                                            <% } %>
                                        <% }
                                           for (int p = start; p <= end; p++) { boolean active = (p == currentPage); %>
                                            <a href="<%= active ? "#" : (baseUrl + "?page=" + p) %>"
                                               class="px-3 py-1.5 rounded-md text-sm border <%= active ? "bg-sky-600 border-sky-600 text-white" : "bg-white text-gray-700 hover:bg-gray-100" %>"><%= p %></a>
                                        <% }
                                           if (end < totalPages) {
                                               if (end < totalPages - 1) { %>
                                                <span class="px-2 text-gray-400">…</span>
                                               <% } %>
                                               <a href="<%= baseUrl %>?page=<%= totalPages %>" class="px-3 py-1.5 rounded-md text-sm border bg-white text-gray-700 hover:bg-gray-100"><%= totalPages %></a>
                                        <% } %>
                                    </div>
                                    <a href="<%= hasNext ? (baseUrl + "?page=" + (currentPage + 1)) : "#" %>"
                                       class="px-3 py-1.5 rounded-md text-sm border <%= hasNext ? "bg-white text-gray-700 hover:bg-gray-100" : "bg-gray-100 text-gray-400 cursor-not-allowed" %>">
                                        Sau
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
    </body>
</html>
