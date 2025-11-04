<%-- 
    Document   : footer_admin
    Created on : Oct 29, 2025, 4:56:03 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer class="mt-auto bg-white border-t">
      <div class="max-w-7xl mx-auto px-6 py-4">
        <div class="flex flex-col sm:flex-row items-center justify-between gap-3 text-sm text-slate-600">
          <!-- Brand -->
          <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-md bg-slate-100 flex items-center justify-center text-slate-700">🐾</div>
            <span class="font-semibold text-slate-700">Sweetimal Admin</span>
            <span class="hidden sm:inline text-slate-400">•</span>
            <span class="hidden sm:inline text-slate-500">Bảng điều khiển quản trị</span>
          </div>

          <!-- Links -->
          <nav class="flex items-center gap-4">
            <a href="#" class="hover:text-slate-800 transition-colors">Tài liệu</a>
            <a href="#" class="hover:text-slate-800 transition-colors">Hỗ trợ</a>
            <a href="#" class="hover:text-slate-800 transition-colors">Chính sách</a>
          </nav>

          <!-- Copyright -->
          <div class="text-slate-500">
            © <span id="year"></span> Sweetimal
          </div>
        </div>
      </div>
    </footer>