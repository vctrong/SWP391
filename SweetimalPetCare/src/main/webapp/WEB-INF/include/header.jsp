<%-- 
    Document   : header
    Created on : Sep 15, 2025, 1:13:59 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<header class="fixed top-0 left-0 w-full z-50 bg-white/30 backdrop-blur-md shadow-sm">
    <div class="container mx-auto flex justify-between items-center py-4 px-6">
        <!-- Logo + Brand -->
        <div class="flex items-center space-x-3">
            <img src="assets/img/logo.jpg" 
                 alt="Sweetimal Logo" 
                 class="w-10 h-10 rounded-full border border-blue-600 shadow-sm">
            <h1 class="text-2xl font-bold text-blue-600">Sweetimal Pet Care</h1>
        </div>

        <!-- Nav Links -->
        <nav class="space-x-6 hidden md:flex">
            <a href="#" class="hover:text-blue-500">Home</a>
            <a href="#services" class="hover:text-blue-500">Services</a>
            <a href="#shop" class="hover:text-blue-500">Shop</a>
            <a href="#contact" class="hover:text-blue-500">Contact</a>
        </nav>

        <!-- Buttons -->
        <div class="space-x-4">
            <button class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Login</button>
            <button class="px-4 py-2 bg-gray-200 rounded-lg hover:bg-gray-300">Sign Up</button>
        </div>
    </div>
</header>