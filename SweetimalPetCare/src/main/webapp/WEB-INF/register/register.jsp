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
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Password -->
                    <div>
                        <label for="password" class="block text-gray-700 mb-1">Mật khẩu</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label for="confirm" class="block text-gray-700 mb-1">Xác nhận mật khẩu</label>
                        <input type="password" id="confirm" name="confirm" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-pink-400 outline-none">
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-gray-700 mb-1">Email</label>
                        <input type="email" id="email" name="email" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Phone -->
                    <div>
                        <label for="phone" class="block text-gray-700 mb-1">Số điện thoại</label>
                        <input type="text" id="phone" name="phone"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Full name -->
                    <div>
                        <label for="fullname" class="block text-gray-700 mb-1">Họ và tên</label>
                        <input type="text" id="fullname" name="fullname"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
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

        <footer id="contact" class="bg-gray-800 text-gray-200 py-10">
            <div class="container mx-auto px-6 grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <div class="flex items-center space-x-2 mb-3">
                        <img src="assets/img/logo.jpg" alt="Sweetimal Logo" class="w-8 h-8 rounded-full">
                        <h4 class="font-bold text-lg">Sweetimal Pet Care</h4>
                    </div>
                    <p>Đối tác tin cậy của bạn về dịch vụ và sản phẩm cho thú cưng.</p>
                </div>
                <div>
                    <h4 class="font-bold text-lg mb-4">Liên kết nhanh</h4>
                    <ul>
                        <li><a href="home" class="hover:underline">Trang chủ</a></li>
                        <li><a href="#services" class="hover:underline">Dịch vụ</a></li>
                        <li><a href="#shop" class="hover:underline">Cửa hàng</a></li>
                        <li><a href="#contact" class="hover:underline">Liên hệ</a></li>
                        <li><a href="aboutUs" class="hover:underline">Về chúng tôi</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-lg mb-4">Liên hệ</h4>
                    <p>Email: support@sweetimal.com</p>
                    <p>Điện thoại: +336 922 235</p>
                </div>
            </div>
            <div class="text-center mt-10 text-gray-400">
                © 2025 Sweetimal Pet Care. Đã đăng ký bản quyền.
            </div>
        </footer>
    </body>
</html>
