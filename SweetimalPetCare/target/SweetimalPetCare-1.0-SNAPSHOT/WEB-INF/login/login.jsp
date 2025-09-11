<%-- 
    Document   : login
    Created on : Sep 10, 2025, 5:28:53 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>PetCare - Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gradient-to-br from-indigo-50 to-yellow-50 min-h-screen flex items-center justify-center">

        <!-- Card Login -->
        <div class="w-full max-w-md bg-white shadow-xl rounded-2xl p-8">

            <!-- Logo + Name -->
            <div class="flex justify-center items-center mb-6">
                <img src="assets/img/logo.jpg" alt="PetCare" class="w-12 h-12 rounded-full shadow-md">
                <span class="ml-3 text-2xl font-bold text-indigo-600">PetCare</span>
            </div>

            <!-- Title -->
            <h2 class="text-center text-xl font-semibold text-gray-700 mb-6">Đăng nhập tài khoản</h2>

            <!-- Form -->
            <form action="#" method="POST" class="space-y-5">
                <!-- Email -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-600">Email</label>
                    <input type="email" id="email" name="email" required
                           class="mt-1 w-full px-4 py-2 border rounded-xl focus:ring-2 focus:ring-indigo-400 focus:outline-none">
                </div>

                <!-- Password -->
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-600">Mật khẩu</label>
                    <input type="password" id="password" name="password" required
                           class="mt-1 w-full px-4 py-2 border rounded-xl focus:ring-2 focus:ring-indigo-400 focus:outline-none">
                </div>

                <!-- Remember + Forgot -->
                <div class="flex items-center justify-between text-sm text-gray-600">
                    <label class="flex items-center space-x-2">
                        <input type="checkbox" class="h-4 w-4 text-indigo-500 border-gray-300 rounded">
                        <span>Ghi nhớ đăng nhập</span>
                    </label>
                    <a href="#" class="text-indigo-500 hover:underline">Quên mật khẩu?</a>
                </div>

                <!-- Submit Button -->
                <button type="submit"
                        class="w-full bg-indigo-600 text-white py-2 rounded-xl shadow-md hover:bg-indigo-700 transition">
                    Đăng nhập
                </button>
            </form>

            <!-- Register -->
            <p class="mt-6 text-center text-sm text-gray-600">
                Chưa có tài khoản? 
                <a href="#" class="text-indigo-500 font-medium hover:underline">Đăng ký ngay</a>
            </p>
        </div>

    </body>
</html>

