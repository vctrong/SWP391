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
                                <div class="py-4 px-4 flex gap-4 hover:bg-gray-50 cursor-pointer">
                                    <div class="w-12 h-12 rounded-full bg-sky-100 text-sky-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">V</div>
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between">
                                            <span class="font-medium text-gray-800">Văn An</span>
                                            <span class="text-xs text-gray-400">2 giờ trước</span>
                                        </div>
                                        <p class="text-sm text-gray-500 mt-1">Chủ đề: <span class="text-gray-700 font-medium">Tư vấn grooming cho Poodle</span></p>
                                        <p class="text-sm text-gray-600 mt-2 truncate">"Chào shop, mình muốn hỏi về gói grooming đầy đủ cho bé Poodle nhà mình, bé 5kg..."</p>
                                    </div>
                                </div>
                                <div class="py-4 px-4 flex gap-4 hover:bg-gray-50 cursor-pointer opacity-70">
                                    <div class="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">T</div>
                                    <div class="flex-1">
                                        <div class="flex items-center justify-between">
                                            <span class="font-medium text-gray-800">Chị Thu</span>
                                            <span class="text-xs text-gray-400">Hôm qua</span>
                                        </div>
                                        <p class="text-sm text-gray-500 mt-1">Chủ đề: <span class="text-gray-700 font-medium">Hỏi về thức ăn hạt</span></p>
                                        <p class="text-sm text-gray-600 mt-2 truncate">"Mèo nhà mình bị kén ăn, shop có thể tư vấn loại hạt nào phù hợp..."</p>
                                    </div>
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
