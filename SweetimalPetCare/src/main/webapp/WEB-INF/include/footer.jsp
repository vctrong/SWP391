<%--
    Document   : footer
    Created on : Sep 15, 2025, 1:05:25 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
@keyframes pulse-slow {
  0%, 100% { opacity: 0.25; transform: scale(1); }
  50% { opacity: 0.4; transform: scale(1.05); }
}
.animate-pulse-slow {
  animation: pulse-slow 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-5px); }
}
.animate-float {
  animation: float 4s ease-in-out infinite;
}

@keyframes twinkle {
  0%, 100% { opacity: 0; transform: scale(0.8); }
  50% { opacity: 0.8; transform: scale(1.2); }
}
.animate-twinkle {
  animation: twinkle 3s ease-in-out infinite;
}
</style>

<footer class="relative bg-gradient-to-br from-gray-900 via-blue-950 to-gray-900 text-gray-200 py-14 mt-20 overflow-hidden">
  <!-- Hiệu ứng lấp lánh nền -->
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


