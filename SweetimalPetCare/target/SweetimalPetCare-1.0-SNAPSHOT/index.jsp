<%-- 
    Document   : index
    Created on : Sep 10, 2025, 4:54:52 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Pet Service</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-50 text-gray-800">

        <!-- Navbar -->
        <nav class="fixed w-full bg-white/80 backdrop-blur-md shadow z-50">
            <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                <a href="#" class="flex items-center space-x-2 text-2xl font-bold text-indigo-600">
                    <img src="assets/img/logo.jpg" alt="PetCare Logo" class="h-10 w-10 rounded-full"/>
                    <span>ST PetCare</span>
                </a>
                <div class="hidden md:flex space-x-6">
                    <a href="#" class="hover:text-indigo-600">Dịch vụ</a>
                    <a href="#" class="hover:text-indigo-600">Giới thiệu</a>
                    <a href="#" class="hover:text-indigo-600">Liên hệ</a>
                </div>
                <div class="space-x-3 hidden md:flex">
                    <a href="${pageContext.request.contextPath}/login" class="px-4 py-2 border border-indigo-600 text-indigo-600 rounded-lg hover:bg-indigo-600 hover:text-white transition">Đăng nhập</a>
                    <a href="#" class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">Đăng ký</a>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="relative min-h-screen flex items-center justify-center bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1558788353-f76d92427f16');">
            <div class="absolute inset-0 bg-black/50"></div>
            <div class="relative z-10 text-center text-white max-w-2xl px-6">
                <h1 class="text-4xl md:text-6xl font-extrabold mb-4">Dịch vụ chăm sóc thú cưng toàn diện</h1>
                <p class="text-lg md:text-xl mb-6">Mang đến sự yêu thương và chăm sóc tốt nhất cho người bạn bốn chân của bạn 🐶🐱</p>
                <div class="space-x-4">
                    <a href="#" class="px-6 py-3 bg-yellow-400 text-black font-semibold rounded-lg hover:bg-yellow-500 transition">Xem dịch vụ</a>
                    <a href="#" class="px-6 py-3 bg-white text-indigo-600 font-semibold rounded-lg hover:bg-gray-100 transition">Đăng ký ngay</a>
                </div>
            </div>
        </section>

        <!-- Body Info Section -->
        <section class="py-16 bg-white">
            <div class="max-w-7xl mx-auto px-6 text-center">
                <h2 class="text-3xl md:text-4xl font-bold text-gray-800 mb-6">Tại sao chọn PetCare?</h2>
                <p class="text-lg text-gray-600 mb-12">Chúng tôi mang đến những dịch vụ tốt nhất để thú cưng của bạn luôn khỏe mạnh và hạnh phúc.</p>

                <!-- Cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

                    <!-- Card 1 -->
                    <div class="bg-gray-50 p-6 rounded-2xl shadow hover:shadow-lg transition">
                        <div class="text-indigo-600 text-5xl mb-4">🐶</div>
                        <h3 class="text-xl font-semibold mb-2">Chăm sóc thú cưng</h3>
                        <p class="text-gray-600">Dịch vụ chăm sóc chuyên nghiệp giúp thú cưng của bạn sạch sẽ, khỏe mạnh và vui vẻ mỗi ngày.</p>
                    </div>

                    <!-- Card 2 -->
                    <div class="bg-gray-50 p-6 rounded-2xl shadow hover:shadow-lg transition">
                        <div class="text-indigo-600 text-5xl mb-4">🏥</div>
                        <h3 class="text-xl font-semibold mb-2">Thú y tận tâm</h3>
                        <p class="text-gray-600">Đội ngũ bác sĩ thú y giàu kinh nghiệm, sẵn sàng hỗ trợ thú cưng khi cần thiết.</p>
                    </div>

                    <!-- Card 3 -->
                    <div class="bg-gray-50 p-6 rounded-2xl shadow hover:shadow-lg transition">
                        <div class="text-indigo-600 text-5xl mb-4">🏡</div>
                        <h3 class="text-xl font-semibold mb-2">Dịch vụ trông giữ</h3>
                        <p class="text-gray-600">Không lo lắng khi bận rộn, chúng tôi sẽ chăm sóc và chơi cùng thú cưng của bạn như ở nhà.</p>
                    </div>

                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="bg-gray-900 text-gray-300 py-10 mt-10">
            <div class="max-w-7xl mx-auto px-6 grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <h2 class="text-2xl font-bold text-white mb-3">🐾 PetCare</h2>
                    <p class="text-sm">Nền tảng dịch vụ thú cưng uy tín, giúp bạn an tâm khi gửi gắm những người bạn bốn chân.</p>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-white mb-3">Liên kết nhanh</h3>
                    <ul class="space-y-2">
                        <li><a href="#" class="hover:text-white">Dịch vụ</a></li>
                        <li><a href="#" class="hover:text-white">Giới thiệu</a></li>
                        <li><a href="#" class="hover:text-white">Liên hệ</a></li>
                    </ul>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-white mb-3">Liên hệ</h3>
                    <p>Email: support@petcare.com</p>
                    <p>Điện thoại: +84 123 456 789</p>
                    <div class="flex space-x-4 mt-3">
                        <a href="#" class="hover:text-white">🐦</a>
                        <a href="#" class="hover:text-white">📘</a>
                        <a href="#" class="hover:text-white">📸</a>
                    </div>
                </div>
            </div>
            <div class="text-center text-gray-500 mt-8 text-sm">
                © 2025 PetCare. All rights reserved.
            </div>
        </footer>

    </body>
</html>

