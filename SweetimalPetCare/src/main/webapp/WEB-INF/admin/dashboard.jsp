<%-- 
    Document   : dashboard.jsp
    Created on : Oct 22, 2025, 4:39:50 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard Admin | Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <link rel="stylesheet" href="assets/css/adminPages.css"/>
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>

    <body class="flex bg-gradient-to-br from-sky-50 via-cyan-50 to-white min-h-screen text-gray-800">
        <%@include file="/WEB-INF/include/admin_sidebar.jsp" %>

        <!-- Main Content -->
        <div class="flex-1 ml-64 flex flex-col min-h-screen p-8 space-y-8">

            <!-- Header -->
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-4xl font-extrabold text-sky-700 tracking-tight">
                    <i class="fa-solid fa-gauge-high mr-3 text-sky-500"></i> Bảng điều khiển
                </h1>
                <p class="text-gray-500">
                    Xin chào, <span class="font-semibold text-sky-600">Admin!</span>
                </p>
            </div>

            <!-- Overview Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6">
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-user-doctor text-3xl text-sky-500 mb-2"></i>
                    <h3 class="text-gray-500">Bác sĩ</h3>
                    <p class="text-3xl font-bold text-sky-600">12</p>
                </div>
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-box text-3xl text-emerald-500 mb-2"></i>
                    <h3 class="text-gray-500">Đơn hàng</h3>
                    <p class="text-3xl font-bold text-emerald-600">56</p>
                </div>
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-users text-3xl text-cyan-500 mb-2"></i>
                    <h3 class="text-gray-500">Người dùng</h3>
                    <p class="text-3xl font-bold text-cyan-600">438</p>
                </div>
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-paw text-3xl text-pink-400 mb-2"></i>
                    <h3 class="text-gray-500">Sản phẩm</h3>
                    <p class="text-3xl font-bold text-pink-500">87</p>
                </div>
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-id-card text-3xl text-indigo-400 mb-2"></i>
                    <h3 class="text-gray-500">Nhân sự</h3>
                    <p class="text-3xl font-bold text-indigo-500">15</p>
                </div>
                <div class="bg-white shadow-md hover:shadow-xl transition rounded-2xl p-5 flex flex-col items-center text-center border border-gray-100">
                    <i class="fa-solid fa-envelope text-3xl text-yellow-500 mb-2"></i>
                    <h3 class="text-gray-500">Liên hệ</h3>
                    <p class="text-3xl font-bold text-yellow-600">8</p>
                </div>
            </div>

            <!-- Recent Info Grid -->
            <div class="grid grid-cols-1 xl:grid-cols-3 gap-8 mt-6">

                <!-- Recent Services -->
                <div class="bg-white rounded-2xl shadow-md hover:shadow-xl transition p-6 border border-gray-100">
                    <h2 class="text-xl font-semibold text-sky-700 mb-4 flex items-center gap-2">
                        <i class="fa-solid fa-hand-holding-medical text-sky-500"></i> Đơn dịch vụ gần đây
                    </h2>
                    <table class="w-full text-left">
                        <thead class="border-b border-gray-200 text-gray-500 text-sm">
                            <tr>
                                <th class="pb-2">Khách hàng</th>
                                <th class="pb-2">Dịch vụ</th>
                                <th class="pb-2 text-right">Ngày</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm text-gray-700">
                            <tr class="hover:bg-sky-50 transition">
                                <td>Nguyễn Văn A</td>
                                <td>Khám sức khỏe thú cưng</td>
                                <td class="text-right">24/10</td>
                            </tr>
                            <tr class="hover:bg-sky-50 transition">
                                <td>Lê Thị B</td>
                                <td>Tắm gội & spa</td>
                                <td class="text-right">23/10</td>
                            </tr>
                            <tr class="hover:bg-sky-50 transition">
                                <td>Phạm C</td>
                                <td>Tiêm ngừa</td>
                                <td class="text-right">22/10</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Orders -->
                <div class="bg-white rounded-2xl shadow-md hover:shadow-xl transition p-6 border border-gray-100">
                    <h2 class="text-xl font-semibold text-emerald-700 mb-4 flex items-center gap-2">
                        <i class="fa-solid fa-cart-shopping text-emerald-500"></i> Đơn hàng gần đây
                    </h2>
                    <table class="w-full text-left">
                        <thead class="border-b border-gray-200 text-gray-500 text-sm">
                            <tr>
                                <th class="pb-2">Mã đơn</th>
                                <th class="pb-2">Khách hàng</th>
                                <th class="pb-2 text-right">Tổng</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm text-gray-700">
                            <tr class="hover:bg-emerald-50 transition">
                                <td>#ORD120</td>
                                <td>Trần D</td>
                                <td class="text-right">520.000đ</td>
                            </tr>
                            <tr class="hover:bg-emerald-50 transition">
                                <td>#ORD121</td>
                                <td>Ngô E</td>
                                <td class="text-right">230.000đ</td>
                            </tr>
                            <tr class="hover:bg-emerald-50 transition">
                                <td>#ORD122</td>
                                <td>Hoàng F</td>
                                <td class="text-right">680.000đ</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Support Requests -->
                <div class="bg-white rounded-2xl shadow-md hover:shadow-xl transition p-6 border border-gray-100">
                    <h2 class="text-xl font-semibold text-pink-700 mb-4 flex items-center gap-2">
                        <i class="fa-solid fa-comments text-pink-500"></i> Các vấn đề cần tư vấn
                    </h2>
                    <ul class="divide-y divide-gray-200 text-gray-700 text-sm">
                        <li class="py-3 hover:bg-pink-50 px-2 rounded-lg transition">
                            🐶 “Cún nhà tôi bị rụng lông nhiều, cần tư vấn chăm sóc.”
                            <span class="block text-gray-400 text-xs mt-1">Từ: Nguyễn H - 24/10</span>
                        </li>
                        <li class="py-3 hover:bg-pink-50 px-2 rounded-lg transition">
                            🐱 “Mèo ăn ít và lười vận động, có cách nào cải thiện không?”
                            <span class="block text-gray-400 text-xs mt-1">Từ: Lê I - 23/10</span>
                        </li>
                        <li class="py-3 hover:bg-pink-50 px-2 rounded-lg transition">
                            🐾 “Cần tư vấn về lịch tiêm định kỳ cho thú cưng.”
                            <span class="block text-gray-400 text-xs mt-1">Từ: Phan K - 22/10</span>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Footer -->
            <div class="mt-auto">
                <%@include file="/WEB-INF/include/footer_admin.jsp" %>
            </div>
        </div>

        <script src="assets/js/adminPages.js"></script>
    </body>
</html>
