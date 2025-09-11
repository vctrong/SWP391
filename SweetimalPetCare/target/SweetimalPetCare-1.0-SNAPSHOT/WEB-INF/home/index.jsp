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

    <%@include file="/WEB-INF/include/header.jsp" %>

    <body class="bg-gray-50 text-gray-800">

        <!-- Hero Section -->
        <section class="relative min-h-screen flex items-center justify-center bg-cover bg-center" style="background-image: url('https://images.unsplash.com/photo-1558788353-f76d92427f16');">
            <!-- Overlay -->
            <div class="absolute inset-0 bg-black/50"></div>

            <!-- Content -->
            <div class="relative z-10 text-center text-white max-w-2xl px-6">
                <h1 class="text-4xl md:text-6xl font-extrabold mb-4">Dịch vụ chăm sóc thú cưng toàn diện</h1>
                <p class="text-lg md:text-xl mb-6">Mang đến sự yêu thương và chăm sóc tốt nhất cho người bạn bốn chân của bạn 🐶🐱</p>
                <div class="space-x-4">
                    <a href="services" class="px-6 py-3 bg-yellow-400 text-black font-semibold rounded-lg hover:bg-yellow-500 transition">Xem dịch vụ</a>
                    <a href="#" class="px-6 py-3 bg-white text-indigo-600 font-semibold rounded-lg hover:bg-gray-100 transition">Đăng ký ngay</a>
                </div>
            </div>
        </section>
    </body>

    <%@include file="/WEB-INF/include/footer.jsp" %>

</html>

