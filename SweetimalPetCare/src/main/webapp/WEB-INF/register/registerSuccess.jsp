<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành công - Sweetimal Pet Care</title>
    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<!-- Header -->
<header class="fixed top-0 left-0 w-full z-50 bg-white/30 backdrop-blur-md shadow-sm">
    <div class="container mx-auto flex items-center py-4 px-6">
        <div class="flex items-center space-x-3">
            <img src="assets/img/logo.jpg" alt="Sweetimal Logo"
                 class="w-10 h-10 rounded-full border border-blue-600 shadow-sm">
            <h1 class="text-2xl font-bold text-blue-600">Sweetimal Pet Care</h1>
        </div>
    </div>
</header>

<!-- Main -->
<div class="flex items-center justify-center min-h-screen bg-gradient-to-br from-blue-100 via-pink-100 to-blue-200 pt-10">
    <div class="bg-white shadow-lg rounded-2xl w-full max-w-md p-8 text-center">
        <img src="assets/img/logo.jpg" alt="Logo"
             class="w-16 mb-4 drop-shadow-lg rounded-full mx-auto"/>

        <h2 class="text-3xl font-bold text-blue-800 mb-2">Đăng ký thành công!</h2>
        <p class="text-gray-600 mb-6">Cảm ơn bạn đã đăng ký tại Sweetimal Pet Care. Vui lòng đăng nhập để trải nghiệm dịch vụ.</p>
        <a href="login"
           class="w-full inline-block bg-pink-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-pink-600 transition text-center">
            Đăng nhập ngay
        </a>

    </div>
</div>

<!-- Footer -->
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
