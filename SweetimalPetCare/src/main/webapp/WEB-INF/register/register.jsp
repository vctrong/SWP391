<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <header class="fixed top-0 left-0 w-full z-50 bg-white/30 backdrop-blur-md shadow-sm">
            <div class="container mx-auto flex items-center py-4 px-6">
                <!-- Logo + Brand (trái) -->
                <div class="flex items-center space-x-3">
                    <img src="assets/img/logo.jpg" 
                         alt="Sweetimal Logo" 
                         class="w-10 h-10 rounded-full border border-blue-600 shadow-sm">
                    <h1 class="text-2xl font-bold text-blue-600">Sweetimal Pet Care</h1>
                </div>

                <!-- Nav Links (giữa) -->
                <nav class="flex-1 flex justify-center space-x-6">
                    <a href="home" class="hover:text-blue-500">Trang chủ</a>
                    <a href="#services" class="hover:text-blue-500">Dịch vụ</a>
                    <a href="#shop" class="hover:text-blue-500">Cửa hàng</a>
                    <a href="#contact" class="hover:text-blue-500">Liên hệ</a>
                    <a href="aboutUs" class="hover:text-blue-500">Về chúng tôi</a>
                </nav>
                <div class="space-x-4">
                    <a href="${pageContext.request.contextPath}/login" class="button px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Đăng nhập</a>
                    <a href="register" class="px-4 py-2 bg-gray-200 rounded-lg hover:bg-gray-300">
                        Đăng ký
                    </a>
                </div>

                <!-- User info (phải) -->
                <c:if test="${not empty user}">
                    <div class="space-x-4">
                        <a href="#" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                            ${user.fullName}
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
