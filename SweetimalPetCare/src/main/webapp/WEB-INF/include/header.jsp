<%--
    Document   : header
    Created on : Sep 11, 2025, 1:23:00 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- Navbar -->
<nav class="fixed w-full bg-white/80 backdrop-blur-md shadow z-50">
    <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <a href="home" class="flex items-center space-x-2 text-2xl font-bold text-indigo-600">
            <img src="assets/img/logo.jpg" alt="PetCare Logo" class="h-10 w-10 rounded-full"/>
            <span>STPetCare</span>
        </a>
        <div class="hidden md:flex space-x-6">
            <a href="services" class="hover:text-indigo-600">Dịch vụ</a>
            <a href="home" class="hover:text-indigo-600">Giới thiệu</a>
            <a href="contact" class="hover:text-indigo-600">Liên hệ</a>
        </div>
        <div class="space-x-3 hidden md:flex">
            <a href="#" class="px-4 py-2 border border-indigo-600 text-indigo-600 rounded-lg hover:bg-indigo-600 hover:text-white transition">Đăng nhập</a>
            <a href="#" class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">Đăng ký</a>
        </div>
    </div>
</nav>
