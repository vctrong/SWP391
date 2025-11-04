<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - Sweetimal Pet Care</title>
        <!-- Tailwind CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">

        <!-- Header -->
        <header id="navbar"
                class="sticky top-0 left-0 w-full z-30 bg-white/40 backdrop-blur-md border-b border-sky-100 shadow-sm transition-all duration-500">
            <div class="container mx-auto flex justify-between items-center py-4 px-6">
                <!-- Logo + Brand -->
                <div class="flex items-center space-x-3">
                    <a href="${pageContext.request.contextPath}/home"
                       class="flex items-center space-x-3 px-2 py-1 rounded-full transition-all transform hover:scale-105 hover:shadow-md hover:text-blue-600"
                       title="Sweetimal Home">
                        <img src="${pageContext.request.contextPath}/assets/img/logo.jpg"
                             alt="Sweetimal Logo"
                             class="w-10 h-10 rounded-full border border-blue-600 shadow-sm hover:shadow-lg transition">
                        <h1 class="text-2xl font-bold bg-gradient-to-r from-sky-500 to-blue-600 bg-clip-text text-transparent">
                            Sweetimal Pet Care
                        </h1>
                    </a>
                </div>

                <!-- Nav Links -->
                <nav class="hidden md:flex items-center space-x-2 text-gray-700 font-medium">
                    <a href="${pageContext.request.contextPath}/home"
                       class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                       hover:text-blue-600 hover:border-blue-400
                       ${fn:contains(current, '/home') ? 'active' : ''}">Trang chủ</a>

                    <a href="${pageContext.request.contextPath}/services"
                       class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                       hover:text-blue-600 hover:border-blue-400
                       ${fn:contains(current, '/services') ? 'active' : ''}">Dịch vụ</a>

                    <a href="#shop"
                       class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                       hover:text-blue-600 hover:border-blue-400
                       ${fn:contains(current, '/shop') ? 'active' : ''}">Cửa hàng</a>

                    <a href="${pageContext.request.contextPath}/contacts"
                       class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                       hover:text-blue-600 hover:border-blue-400
                       ${fn:contains(current, '/Contacts') ? 'active' : ''}">Liên hệ</a>

                    <a href="${pageContext.request.contextPath}/aboutUs"
                       class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                       hover:text-blue-600 hover:border-blue-400
                       ${fn:contains(current, '/aboutus') ? 'active' : ''}">Về chúng tôi</a>

                    <c:if test="${not empty user}">
                        <a href="${pageContext.request.contextPath}/booking-history"
                           class="nav-link px-4 py-2 rounded-full relative transition-all duration-300 transform hover:scale-105
                           hover:text-blue-600 hover:border-blue-400
                           ${fn:contains(current, '/bookingHistory') ? 'active' : ''}">
                            Lịch sử đặt lịch
                        </a>
                    </c:if>
                </nav>

                <!-- User / Auth Buttons -->
                <c:if test="${not empty user}">



                    <div class="space-x-4 flex items-center">
                        <div class="px-1 py-1 rounded-full transform hover:scale-105 hover:text-blue-600 transition">
                            <button id="userMenuButton"
                                    class="flex items-center space-x-2 bg-gradient-to-r from-sky-500 to-blue-600 hover:from-blue-600 hover:to-blue-700
                                    text-white px-4 py-2 rounded-full shadow-md hover:shadow-lg transition duration-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50">
                                ${user.fullName}
                            </button>
                        </div>

                    </div>
                </c:if>

                <c:if test="${empty user}">
                    <div class="space-x-4">
                        <a href="${pageContext.request.contextPath}/login"
                           class="inline-block px-4 py-2 rounded-full bg-gradient-to-r from-sky-500 to-blue-600 text-white font-semibold
                           shadow-md hover:shadow-lg hover:scale-105 transition-all duration-300">Đăng nhập</a>
                        <a href="register"
                           class="inline-block px-4 py-2 rounded-full bg-gray-100 hover:bg-gray-200 font-medium hover:scale-105 border border-transparent transition-all duration-300">
                            Đăng ký
                        </a>

                    </div>
                </c:if>
            </div>
        </header>


        <!-- Form Register -->
        <div class="flex items-center justify-center min-h-screen bg-gradient-to-br from-blue-100 via-pink-100 to-blue-200 pt-10">
            <div class="bg-white shadow-lg rounded-2xl w-full max-w-md p-8">

                <!-- Logo + Title -->
                <div class="flex flex-col items-center mb-8">
                    <img src="assets/img/logo.jpg" alt="Logo"
                         class="w-16 mb-4 drop-shadow-lg rounded-full" />
                    <h2 class="text-3xl font-bold text-blue-800 mb-2">Đăng ký</h2>
                </div>

                <form action="register" method="post" class="space-y-4">
                    <!-- Username -->
                    <div>
                        <label for="username" class="block text-gray-700 mb-1">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" required 
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="ABCxyz">
                    </div>

                    <!-- Password -->
                    <div>
                        <label for="password" class="block text-gray-700 mb-1">Mật khẩu</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="Mật khẩu">
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label for="confirm" class="block text-gray-700 mb-1">Xác nhận mật khẩu</label>
                        <input type="password" id="confirm" name="confirm" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-pink-400 outline-none"
                               placeholder="Nhập lại mật khẩu">
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-gray-700 mb-1">Email</label>
                        <input type="email" id="email" name="email" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="you@example.com">
                    </div>

                    <!-- Phone -->
                    <div>
                        <label for="phone" class="block text-gray-700 mb-1">Số điện thoại</label>
                        <input type="text" id="phone" name="phone"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="08********">
                    </div>

                    <!-- Full name -->
                    <div>
                        <label for="fullname" class="block text-gray-700 mb-1">Họ và tên</label>
                        <input type="text" id="fullname" name="fullname"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="Nhập tên của bạn">
                    </div>

                    <!-- Gender -->
                    <div>
                        <label for="gender" class="block text-gray-700 mb-1">Giới tính</label>
                        <select id="gender" name="gender"
                                class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <!-- Birthday -->
                    <div>
                        <label for="birthday" class="block text-gray-700 mb-1">Ngày sinh</label>
                        <input type="date" id="birthday" name="birthday"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Submit button -->
                    <button type="submit"
                            class="w-full bg-pink-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-pink-600 transition">
                        Đăng ký
                    </button>
                </form>

                <!-- Hiện lỗi -->
                <c:if test="${not empty error}">
                    <p class="text-red-500 mt-4 text-center">${error}</p>
                </c:if>

                <p class="mt-4 text-center text-sm text-gray-600">
                    Đã có tài khoản?
                    <a href="login" class="text-blue-600 hover:underline">Đăng nhập</a>
                </p>
            </div>
        </div>

        <!-- Footer -->
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <style>
            @keyframes pulse-slow {
                0%, 100% {
                    opacity: 0.25;
                    transform: scale(1);
                }
                50% {
                    opacity: 0.4;
                    transform: scale(1.05);
                }
            }
            .animate-pulse-slow {
                animation: pulse-slow 6s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% {
                    transform: translateY(0px);
                }
                50% {
                    transform: translateY(-5px);
                }
            }
            .animate-float {
                animation: float 4s ease-in-out infinite;
            }

            @keyframes twinkle {
                0%, 100% {
                    opacity: 0;
                    transform: scale(0.8);
                }
                50% {
                    opacity: 0.8;
                    transform: scale(1.2);
                }
            }
            .animate-twinkle {
                animation: twinkle 3s ease-in-out infinite;
            }
        </style>

        <footer class="relative bg-gradient-to-br from-gray-900 via-blue-950 to-gray-900 text-gray-200 py-14 mt-20 overflow-hidden">
            <!-- Hiệu ứng nền -->
            <div class="absolute inset-0 overflow-hidden">
                <div class="absolute w-80 h-80 bg-cyan-400/20 rounded-full blur-3xl top-10 left-10 animate-pulse-slow"></div>
                <div class="absolute w-96 h-96 bg-indigo-400/20 rounded-full blur-3xl bottom-10 right-10 animate-pulse-slow"></div>
                <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_left,rgba(255,255,255,0.08),transparent_70%)]"></div>
            </div>

            <div class="relative z-10 container mx-auto px-6 grid grid-cols-1 md:grid-cols-3 gap-10">
                <!-- Logo & Giới thiệu -->
                <div class="space-y-5">
                    <div class="flex items-center space-x-3">
                        <img src="assets/img/logo.jpg" alt="Sweetimal Logo" class="w-10 h-10 rounded-full border-2 border-cyan-400 shadow-lg shadow-cyan-500/20 animate-float">
                        <h4 class="text-2xl font-bold bg-gradient-to-r from-cyan-400 to-blue-400 bg-clip-text text-transparent">
                            Sweetimal Pet Care
                        </h4>
                    </div>
                    <p class="text-gray-300 leading-relaxed">
                        Cùng bạn yêu thương và chăm sóc các bé thú cưng mỗi ngày 🐾  
                        Dịch vụ tận tâm, sản phẩm chất lượng, trải nghiệm trọn vẹn.
                    </p>
                    <div class="flex space-x-4 mt-5">
                        <a href="#" class="hover:text-cyan-400 transition transform hover:scale-110"><i class="fa-brands fa-facebook text-2xl"></i></a>
                        <a href="#" class="hover:text-cyan-400 transition transform hover:scale-110"><i class="fa-brands fa-instagram text-2xl"></i></a>
                        <a href="#" class="hover:text-cyan-400 transition transform hover:scale-110"><i class="fa-brands fa-tiktok text-2xl"></i></a>
                        <a href="#" class="hover:text-cyan-400 transition transform hover:scale-110"><i class="fa-brands fa-youtube text-2xl"></i></a>
                    </div>
                </div>

                <!-- Liên kết nhanh -->
                <div>
                    <h4 class="text-xl font-semibold text-white mb-5 relative inline-block">
                        Liên kết nhanh
                        <span class="absolute -bottom-1 left-0 w-2/3 h-0.5 bg-gradient-to-r from-cyan-400 to-blue-500 rounded-full animate-pulse"></span>
                    </h4>
                    <ul class="space-y-3 text-gray-300">
                        <li><a href="home" class="hover:text-cyan-400 hover:translate-x-1 transition-all">Trang chủ</a></li>
                        <li><a href="#services" class="hover:text-cyan-400 hover:translate-x-1 transition-all">Dịch vụ</a></li>
                        <li><a href="#shop" class="hover:text-cyan-400 hover:translate-x-1 transition-all">Cửa hàng</a></li>
                        <li><a href="contacts" class="hover:text-cyan-400 hover:translate-x-1 transition-all">Liên hệ</a></li>
                        <li><a href="aboutUs" class="hover:text-cyan-400 hover:translate-x-1 transition-all">Về chúng tôi</a></li>
                    </ul>
                </div>

                <!-- Liên hệ -->
                <div>
                    <h4 class="text-xl font-semibold text-white mb-5 relative inline-block">
                        Liên hệ
                        <span class="absolute -bottom-1 left-0 w-1/2 h-0.5 bg-gradient-to-r from-blue-400 to-cyan-400 rounded-full animate-pulse"></span>
                    </h4>
                    <ul class="space-y-3 text-gray-300">
                        <li><i class="fa-solid fa-envelope text-cyan-400 mr-2"></i> support@sweetimal.vn</li>
                        <li><i class="fa-solid fa-phone text-cyan-400 mr-2"></i> +336 922 235</li>
                        <li class="flex items-start">
                            <i class="fa-solid fa-location-dot text-cyan-400 mr-2 mt-1"></i>
                            <span>600 Nguyễn Văn Cừ Nối Dài, An Bình, Bình Thủy, Cần Thơ</span>
                        </li>
                    </ul>
                    <a href="https://maps.app.goo.gl/z5q3vaek9iW416mL6" target="_blank"
                       class="inline-flex items-center mt-6 px-5 py-2.5 rounded-full bg-gradient-to-r from-cyan-500 to-blue-500 text-white font-semibold shadow-md hover:shadow-cyan-500/30 hover:scale-105 transition-all duration-300">
                        <i class="fa-solid fa-map-location-dot mr-2"></i> Xem bản đồ
                    </a>
                </div>
            </div>

            <!-- Bản quyền -->
            <div class="relative z-10 text-center mt-14 border-t border-gray-700 pt-6 text-gray-400 text-sm">
                © 2025 <span class="text-cyan-400 font-semibold">Sweetimal Pet Care</span>. Mọi quyền được bảo lưu.
            </div>

            <!-- Hiệu ứng lấp lánh -->
            <div class="absolute inset-0 pointer-events-none">
                <div class="animate-twinkle absolute w-1 h-1 bg-white rounded-full opacity-60 top-1/3 left-1/4"></div>
                <div class="animate-twinkle absolute w-1 h-1 bg-white rounded-full opacity-70 top-2/3 left-2/3"></div>
                <div class="animate-twinkle absolute w-1 h-1 bg-white rounded-full opacity-50 top-1/5 right-1/4"></div>
            </div>
        </footer>

    </body>
</html>
