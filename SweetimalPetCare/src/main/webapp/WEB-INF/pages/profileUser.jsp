<%-- 
    Document   : profileUser
    Created on : Oct 8, 2025, 3:20:56 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile Pages</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <link rel="stylesheet" href="assets/css/profile.css"/>

    </head>
    <body class="bg-gray-100 font-[Inter]">

        <!-- ====== HEADER INFO (CỐ ĐỊNH Ở TRÊN) ====== -->
        <header class="max-w-7xl mx-auto mt-4 px-4">
            <div
                class="bg-white shadow-md rounded-2xl p-6 flex flex-col sm:flex-row justify-between items-center sticky top-4 z-20">

                <!-- Logo và thông tin user -->
                <div class="flex items-center space-x-6 w-full sm:w-auto">
                    <!-- Logo Shop -->
                    <!-- Logo Shop -->
                    <a href="${pageContext.request.contextPath}/home" class="flex items-center cursor-pointer hover:opacity-80 transition-opacity">
                        <div class="w-12 h-12 rounded-xl flex items-center justify-center mr-3 overflow-hidden border">
                            <img src="assets/img/logo.jpg" alt="Sweetimal Logo" class="w-full h-full object-cover rounded-xl">
                        </div>
                        <div class="hidden md:block">
                            <h1 class="text-lg font-bold text-gray-800">Sweetimal</h1>
                            <p class="text-xs text-gray-500">Pet Care & Shop</p>
                        </div>
                    </a>

                    <!-- Divider -->
                    <div class="hidden sm:block w-px h-12 bg-gray-200"></div>

                    <!-- User Info -->
                    <div class="flex items-center space-x-4">
                        <img src="assets/img/avt.webp" alt="avatar" class="w-16 h-16 rounded-full border object-cover">
                        <div>
                            <h2 class="text-xl font-semibold text-gray-800">Võ Chí Trọng</h2>
                            <p class="text-gray-500">0336922235</p>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="flex items-center gap-8 mt-4 sm:mt-0">
                    <!-- Tổng số đơn hàng -->
                    <div class="flex items-center space-x-3 bg-red-50 px-4 py-3 rounded-xl">
                        <div class="w-10 h-10 bg-red-100 rounded-lg flex items-center justify-center">
                            <span class="text-red-600 text-xl">🛒</span>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-red-600">12</p>
                            <p class="text-gray-500 text-sm">Tổng số đơn hàng đã mua</p>
                        </div>
                    </div>

                    <!-- Số dịch vụ đã book -->
                    <div class="flex items-center space-x-3 bg-green-50 px-4 py-3 rounded-xl">
                        <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                            <span class="text-green-600 text-xl">🏥</span>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-green-600">8</p>
                            <p class="text-gray-500 text-sm">Số dịch vụ đã book</p>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- ====== BODY: SIDEBAR + NỘI DUNG ====== -->
        <div class="max-w-7xl mx-auto py-8 px-4 flex flex-col lg:flex-row gap-6">

            <!-- SIDEBAR -->
            <aside class="w-full lg:w-1/4 bg-white shadow-md rounded-2xl p-4 space-y-2 h-fit sticky top-[8rem]">
                <button class="sidebar-btn w-full flex items-center p-3 rounded-xl hover:bg-blue-50 active" data-tab="overview">
                    🏠 <span class="ml-3">Tổng quan</span>
                </button>
                <button class="sidebar-btn w-full flex items-center p-3 rounded-xl hover:bg-blue-50" data-tab="history">
                    🛒 <span class="ml-3">Lịch sử mua hàng</span>
                </button>
                <button class="sidebar-btn w-full flex items-center p-3 rounded-xl hover:bg-blue-50" data-tab="account">
                    👤 <span class="ml-3">Thông tin tài khoản</span>
                </button>
                <button class="sidebar-btn w-full flex items-center p-3 rounded-xl hover:bg-blue-50" data-tab="support">
                    💬 <span class="ml-3">Góp ý - Hỗ trợ</span>
                </button>
                <button class="sidebar-btn w-full flex items-center p-3 rounded-xl hover:bg-blue-50" data-tab="policy">
                    📜 <span class="ml-3">Chính sách & Điều khoản</span>
                </button>
                <button class="sidebar-btn w-full flex items-center p-3 text-red-500 hover:bg-red-100 font-semibold"
                        data-tab="logout">
                    🚪 <span class="ml-3">Đăng xuất</span>
                </button>
            </aside>

            <!-- CONTENT -->
            <section class="w-full lg:w-3/4 space-y-6">

                <!-- TAB: TỔNG QUAN -->
                <div id="overview" class="tab-content active">
                    <h3 class="text-2xl font-bold mb-6 text-gray-800">Chào mừng trở lại, Võ Chí Trọng! 👋</h3>

                    <!-- Stats Cards -->
                    <div class="grid md:grid-cols-3 gap-6 mb-8">
                        <!-- Card Đơn hàng -->
                        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="relative z-10">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-xl flex items-center justify-center">
                                        <span class="text-2xl">🛒</span>
                                    </div>
                                    <span class="text-sm opacity-80">+2 tháng này</span>
                                </div>
                                <h4 class="text-2xl font-bold mb-1">12</h4>
                                <p class="text-sm opacity-90">Đơn hàng đã mua</p>
                            </div>
                        </div>

                        <!-- Card Dịch vụ -->
                        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-2xl p-6 text-white relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="relative z-10">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-xl flex items-center justify-center">
                                        <span class="text-2xl">🏥</span>
                                    </div>
                                    <span class="text-sm opacity-80">+1 tuần này</span>
                                </div>
                                <h4 class="text-2xl font-bold mb-1">8</h4>
                                <p class="text-sm opacity-90">Dịch vụ đã sử dụng</p>
                            </div>
                        </div>

                        <!-- Card Tiết kiệm -->
                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl p-6 text-white relative overflow-hidden">
                            <div class="absolute top-0 right-0 w-20 h-20 bg-white bg-opacity-10 rounded-full -mr-10 -mt-10"></div>
                            <div class="relative z-10">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="w-12 h-12 bg-white bg-opacity-20 rounded-xl flex items-center justify-center">
                                        <span class="text-2xl">💰</span>
                                    </div>
                                    <span class="text-sm opacity-80">Tổng cộng</span>
                                </div>
                                <h4 class="text-2xl font-bold mb-1">1.2M</h4>
                                <p class="text-sm opacity-90">Đã tiết kiệm</p>
                            </div>
                        </div>
                    </div>

                    <div class="grid lg:grid-cols-3 gap-6">
                        <!-- Đơn hàng gần đây - 2/3 width -->
                        <div class="lg:col-span-2 bg-white rounded-2xl shadow-lg p-6">
                            <div class="flex items-center justify-between mb-6">
                                <h4 class="text-lg font-semibold text-gray-800">Đơn hàng gần đây</h4>
                                <button class="text-blue-600 hover:text-blue-700 text-sm font-medium">Xem tất cả →</button>
                            </div>

                            <div class="space-y-4">
                                <!-- Đơn hàng 1 -->
                                <div class="flex items-center p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                                    <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mr-4">
                                        <span class="text-xl">🐾</span>
                                    </div>
                                    <div class="flex-1">
                                        <h5 class="font-medium text-gray-800">Thức ăn cho mèo Whiskas</h5>
                                        <p class="text-sm text-gray-500">#DH001 • 01/10/2025</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-semibold text-gray-800">450.000đ</p>
                                        <span class="inline-block px-2 py-1 bg-green-100 text-green-700 rounded-lg text-xs font-medium">Đã giao</span>
                                    </div>
                                </div>

                                <!-- Đơn hàng 2 -->
                                <div class="flex items-center p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                                    <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center mr-4">
                                        <span class="text-xl">🧴</span>
                                    </div>
                                    <div class="flex-1">
                                        <h5 class="font-medium text-gray-800">Sữa tắm cho chó PetClean</h5>
                                        <p class="text-sm text-gray-500">#DH002 • 03/10/2025</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-semibold text-gray-800">120.000đ</p>
                                        <span class="inline-block px-2 py-1 bg-yellow-100 text-yellow-700 rounded-lg text-xs font-medium">Đang giao</span>
                                    </div>
                                </div>

                                <!-- Đơn hàng 3 -->
                                <div class="flex items-center p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                                    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mr-4">
                                        <span class="text-xl">🎾</span>
                                    </div>
                                    <div class="flex-1">
                                        <h5 class="font-medium text-gray-800">Đồ chơi cao su cho chó</h5>
                                        <p class="text-sm text-gray-500">#DH003 • 05/10/2025</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-semibold text-gray-800">85.000đ</p>
                                        <span class="inline-block px-2 py-1 bg-gray-100 text-gray-700 rounded-lg text-xs font-medium">Chờ xác nhận</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sidebar bên phải -->
                        <div class="space-y-6">
                            <!-- Ưu đãi -->
                            <div class="bg-gradient-to-br from-orange-400 to-pink-500 rounded-2xl p-6 text-white relative overflow-hidden">
                                <div class="absolute top-0 right-0 w-16 h-16 bg-white bg-opacity-10 rounded-full -mr-8 -mt-8"></div>
                                <div class="relative z-10">
                                    <div class="w-10 h-10 bg-white bg-opacity-20 rounded-lg flex items-center justify-center mb-4">
                                        <span class="text-xl">🎁</span>
                                    </div>
                                    <h4 class="font-bold text-lg mb-2">Ưu đãi đặc biệt</h4>
                                    <p class="text-sm opacity-90 mb-4">Giảm giá lên đến 30% cho thành viên VIP</p>
                                    <button class="bg-white text-orange-500 px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-100 transition-colors">
                                        Khám phá ngay
                                    </button>
                                </div>
                            </div>

                            <!-- Lịch hẹn sắp tới -->
                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                <h4 class="font-semibold text-gray-800 mb-4 flex items-center">
                                    <span class="w-2 h-2 bg-blue-500 rounded-full mr-2"></span>
                                    Lịch hẹn sắp tới
                                </h4>
                                <div class="space-y-3">
                                    <div class="flex items-center p-3 bg-blue-50 rounded-xl">
                                        <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mr-3">
                                            <span class="text-sm">🏥</span>
                                        </div>
                                        <div class="flex-1">
                                            <p class="font-medium text-gray-800 text-sm">Tắm rửa + Cắt tỉa</p>
                                            <p class="text-xs text-gray-500">08/10 • 10:00</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center p-3 bg-green-50 rounded-xl">
                                        <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center mr-3">
                                            <span class="text-sm">💉</span>
                                        </div>
                                        <div class="flex-1">
                                            <p class="font-medium text-gray-800 text-sm">Tiêm phòng vaccine</p>
                                            <p class="text-xs text-gray-500">12/10 • 16:00</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                <h4 class="font-semibold text-gray-800 mb-4">Thao tác nhanh</h4>
                                <div class="flex justify-around items-center gap-4 flex-wrap mt-4">
                                    <button class="p-4 w-24 bg-blue-50 hover:bg-blue-100 rounded-2xl transition-all duration-200 text-center hover:scale-105 hover:shadow-md">
                                        <span class="block text-2xl mb-1">🛒</span>
                                        <span class="block text-sm font-semibold text-gray-700">Mua sắm</span>
                                    </button>

                                    <button class="p-4 w-24 bg-green-50 hover:bg-green-100 rounded-2xl transition-all duration-200 text-center hover:scale-105 hover:shadow-md">
                                        <span class="block text-2xl mb-1">📅</span>
                                        <span class="block text-sm font-semibold text-gray-700">Đặt lịch</span>
                                    </button>

                                    <button class="p-4 w-24 bg-purple-50 hover:bg-purple-100 rounded-2xl transition-all duration-200 text-center hover:scale-105 hover:shadow-md">
                                        <span class="block text-2xl mb-1">💬</span>
                                        <span class="block text-sm font-semibold text-gray-700">Hỗ trợ</span>
                                    </button>

                                    <button class="p-4 w-24 bg-orange-50 hover:bg-orange-100 rounded-2xl transition-all duration-200 text-center hover:scale-105 hover:shadow-md">
                                        <span class="block text-2xl mb-1">🎁</span>
                                        <span class="block text-sm font-semibold text-gray-700">Ưu đãi</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB: LỊCH SỬ -->
                <div id="history" class="tab-content">
                    <h3 class="text-lg font-semibold mb-4 text-blue-600">Lịch sử mua hàng & Dịch vụ</h3>

                    <!-- Lịch sử mua hàng -->
                    <div class="bg-white rounded-2xl shadow-md p-6 mb-6">
                        <h4 class="font-semibold mb-4 text-red-600 flex items-center">
                            🛒 <span class="ml-2">Lịch sử mua hàng</span>
                        </h4>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead class="border-b">
                                    <tr class="text-gray-600">
                                        <th class="pb-2">Mã đơn</th>
                                        <th>Sản phẩm</th>
                                        <th>Ngày mua</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody class="text-gray-700">
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#DH001</td>
                                        <td class="py-3">
                                            <div class="font-medium">Thức ăn cho mèo Whiskas</div>
                                            <div class="text-sm text-gray-500">2kg - Vị cá ngừ</div>
                                        </td>
                                        <td class="py-3">01/10/2025</td>
                                        <td class="py-3">450.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-green-100 text-green-700 rounded-lg text-sm">Hoàn
                                                tất</span></td>
                                    </tr>
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#DH002</td>
                                        <td class="py-3">
                                            <div class="font-medium">Sữa tắm cho chó PetClean</div>
                                            <div class="text-sm text-gray-500">500ml - Khử mùi</div>
                                        </td>
                                        <td class="py-3">03/10/2025</td>
                                        <td class="py-3">120.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-yellow-100 text-yellow-700 rounded-lg text-sm">Đang
                                                giao</span></td>
                                    </tr>
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#DH003</td>
                                        <td class="py-3">
                                            <div class="font-medium">Đồ chơi cao su cho chó</div>
                                            <div class="text-sm text-gray-500">Bóng tennis size M</div>
                                        </td>
                                        <td class="py-3">05/10/2025</td>
                                        <td class="py-3">85.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-gray-100 text-gray-700 rounded-lg text-sm">Chờ xác
                                                nhận</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Lịch sử booking dịch vụ -->
                    <div class="bg-white rounded-2xl shadow-md p-6">
                        <h4 class="font-semibold mb-4 text-green-600 flex items-center">
                            🏥 <span class="ml-2">Lịch sử booking dịch vụ</span>
                        </h4>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left">
                                <thead class="border-b">
                                    <tr class="text-gray-600">
                                        <th class="pb-2">Mã booking</th>
                                        <th>Dịch vụ</th>
                                        <th>Ngày hẹn</th>
                                        <th>Giá dịch vụ</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody class="text-gray-700">
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#BK001</td>
                                        <td class="py-3">
                                            <div class="font-medium">Khám tổng quát</div>
                                            <div class="text-sm text-gray-500">Cho mèo - Bác sĩ Nguyễn An</div>
                                        </td>
                                        <td class="py-3">
                                            <div>02/10/2025</div>
                                            <div class="text-sm text-gray-500">14:30</div>
                                        </td>
                                        <td class="py-3">300.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-green-100 text-green-700 rounded-lg text-sm">Hoàn
                                                thành</span></td>
                                    </tr>
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#BK002</td>
                                        <td class="py-3">
                                            <div class="font-medium">Tắm rửa + Cắt tỉa lông</div>
                                            <div class="text-sm text-gray-500">Cho chó Golden Retriever</div>
                                        </td>
                                        <td class="py-3">
                                            <div>08/10/2025</div>
                                            <div class="text-sm text-gray-500">10:00</div>
                                        </td>
                                        <td class="py-3">250.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-blue-100 text-blue-700 rounded-lg text-sm">Đã xác
                                                nhận</span></td>
                                    </tr>
                                    <tr class="border-b border-gray-100">
                                        <td class="py-3">#BK003</td>
                                        <td class="py-3">
                                            <div class="font-medium">Tiêm phòng vaccine</div>
                                            <div class="text-sm text-gray-500">Cho mèo - Vaccine 4 bệnh</div>
                                        </td>
                                        <td class="py-3">
                                            <div>12/10/2025</div>
                                            <div class="text-sm text-gray-500">16:00</div>
                                        </td>
                                        <td class="py-3">180.000đ</td>
                                        <td class="py-3"><span class="px-2 py-1 bg-orange-100 text-orange-700 rounded-lg text-sm">Chờ xác
                                                nhận</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- TAB: THÔNG TIN TÀI KHOẢN -->
                <div id="account" class="tab-content">
                    <h3 class="text-lg font-semibold mb-4 text-blue-600">Thông tin tài khoản</h3>

                    <!-- Thông tin cá nhân -->
                    <div class="bg-white rounded-2xl shadow-md p-6 mb-6">
                        <div class="flex justify-between items-center mb-6">
                            <h4 class="text-lg font-semibold text-gray-800">Thông tin cá nhân</h4>
                            <button
                                class="flex items-center text-red-600 hover:text-red-700 transition-colors hover:bg-red-50 px-3 py-2 rounded-lg"
                                onclick="updateProfile()">
                                <span class="mr-1">✏️</span>
                                <span class="text-sm">Cập nhật</span>
                            </button>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Cột trái -->
                            <div class="space-y-4">
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Họ và tên:</span>
                                    <span class="font-medium text-gray-800">${user.fullName}</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Giới tính:</span>
                                    <span class="font-medium text-gray-800">Nam</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Ngày sinh:</span>
                                    <span class="font-medium text-gray-800">${user.birthday}</span>
                                </div>
                            </div>

                            <!-- Cột phải -->
                            <div class="space-y-4">
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Số điện thoại:</span>
                                    <span class="font-medium text-gray-800">0336922235</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Email:</span>
                                    <span class="font-medium text-gray-800">vctrong665@gmail.com</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-gray-100">
                                    <span class="text-gray-600">Địa chỉ mặc định:</span>
                                    <span class="font-medium text-gray-800">-</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sổ địa chỉ -->
                    <div class="bg-white rounded-2xl shadow-md p-6  mb-6">
                        <div class="flex justify-between items-center mb-6">
                            <h4 class="text-lg font-semibold text-gray-800">Sổ địa chỉ</h4>
                            <button
                                class="flex items-center text-red-600 hover:text-red-700 transition-colors hover:bg-red-50 px-3 py-2 rounded-lg"
                                onclick="addAddress()">
                                <span class="mr-1">➕</span>
                                <span class="text-sm">Thêm địa chỉ</span>
                            </button>
                        </div>

                        <!-- Empty state với mascot -->
                        <div class="flex flex-col items-center justify-center py-12">
                            <div class="w-32 h-32 mb-4 bg-red-50 rounded-full flex items-center justify-center">
                                <div class="text-6xl">🎁</div>
                            </div>
                            <p class="text-gray-400 text-center">Bạn chưa có địa chỉ nào được tạo</p>
                        </div>
                    </div>

                    <!-- Mật khẩu -->
                    <div class="bg-white rounded-2xl shadow-md p-6 w-1/2">
                        <div class="flex justify-between items-center mb-6">
                            <h4 class="text-lg font-semibold text-gray-800">Mật khẩu</h4>
                            <button
                                class="flex items-center text-red-600 hover:text-red-700 transition-colors hover:bg-red-50 px-3 py-2 rounded-lg"
                                onclick="changePassword()">
                                <span class="mr-1">🔑</span>
                                <span class="text-sm">Thay đổi mật khẩu</span>
                            </button>
                        </div>

                        <div class="flex justify-between py-3 border-b border-gray-100">
                            <span class="text-gray-600">Cập nhật lần cuối lúc:</span>
                            <span class="font-medium text-gray-800">12/01/2025 23:27</span>
                        </div>
                    </div>
                </div>

                <!-- TAB: HỖ TRỢ -->
                <!-- TAB: HỖ TRỢ -->
                <div id="support" class="tab-content">
                    <h3 class="text-lg font-semibold text-blue-600 mb-4">Góp ý - Hỗ trợ</h3>
                    <div class="bg-white rounded-2xl shadow-md p-6">
                        <div class="grid md:grid-cols-2 gap-6">
                            <!-- Card Tư vấn -->
                            <div class="bg-blue-50 rounded-xl p-6 text-center border border-blue-100">
                                <div class="text-4xl mb-3">📞</div>
                                <h4 class="font-semibold text-blue-700 mb-3 text-lg">Tư vấn</h4>
                                <p class="text-blue-600 font-medium text-lg">0123 456 789</p>
                                <p class="text-gray-500 text-sm mt-2">8:00 - 22:00 hàng ngày</p>
                                <p class="text-gray-600 text-xs mt-1">Hỗ trợ tư vấn sản phẩm và dịch vụ</p>
                            </div>

                            <!-- Card Khiếu nại -->
                            <div class="bg-red-50 rounded-xl p-6 text-center border border-red-100">
                                <div class="text-4xl mb-3">⚠️</div>
                                <h4 class="font-semibold text-red-700 mb-3 text-lg">Khiếu nại</h4>
                                <p class="text-red-600 font-medium text-lg">0987 654 321</p>
                                <p class="text-gray-500 text-sm mt-2">24/7 - Luôn sẵn sàng</p>
                                <p class="text-gray-600 text-xs mt-1">Giải quyết khiếu nại và tranh chấp</p>
                            </div>
                        </div>

                        <!-- Card Email -->
                        <div class="mt-6">
                            <div class="bg-green-50 rounded-xl p-6 text-center border border-green-100">
                                <div class="text-4xl mb-3">📧</div>
                                <h4 class="font-semibold text-green-700 mb-3 text-lg">Email hỗ trợ</h4>
                                <p class="text-green-600 font-medium text-lg">support@sweetimal.vn</p>
                                <p class="text-gray-500 text-sm mt-2">Phản hồi trong 24h</p>
                                <p class="text-gray-600 text-xs mt-1">Gửi email để được hỗ trợ chi tiết</p>
                            </div>
                        </div>

                        <!-- Form góp ý -->
                        <div class="mt-6 pt-6 border-t border-gray-200">
                            <h4 class="font-semibold mb-3">Gửi góp ý cho chúng tôi</h4>
                            <div class="space-y-3">
                                <textarea class="w-full p-3 border border-gray-300 rounded-xl resize-none" rows="4"
                                          placeholder="Chia sẻ ý kiến của bạn về dịch vụ..."></textarea>
                                <button class="px-6 py-2 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors">Gửi góp
                                    ý</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB: CHÍNH SÁCH -->
                <div id="policy" class="tab-content">
                    <div class="bg-white rounded-2xl shadow-md p-6">
                        <h3 class="text-lg font-semibold text-blue-600 mb-3">Chính sách & Điều khoản</h3>
                        <p class="text-gray-700">Chúng tôi cam kết bảo vệ quyền lợi khách hàng, tuân thủ quy định về bảo mật, đổi trả
                            và dịch vụ chăm sóc thú cưng theo quy định hiện hành.</p>
                    </div>
                </div>

                <!-- TAB: ĐĂNG XUẤT -->
                <<form action="logout" method="get">
                    <div id="logout" class="tab-content text-center">
                        <p class="text-gray-600 mt-10">Bạn có chắc muốn đăng xuất không?</p>
                        <button type="submit" class="mt-4 px-6 py-2 bg-red-500 text-white rounded-xl hover:bg-red-600">Đăng xuất</button>
                    </div>
                </form>


            </section>
        </div>

        <!-- MODALS -->
        <%@include file="/WEB-INF/modal/profileUpdateInfo.jsp" %>
        <%@include file="/WEB-INF/modal/profileUpdateAddress.jsp" %>
        <%@include file="/WEB-INF/modal/profileUpdatePassword.jsp" %>



        <%@include file="/WEB-INF/include/footer.jsp" %>
        <script src="assets/js/profile.js"></script>
    </body>
</html>
