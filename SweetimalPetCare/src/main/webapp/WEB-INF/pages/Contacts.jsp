<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Liên hệ - Sweetimal Pet Care</title>
    <%@include file="/WEB-INF/include/library.jsp" %>
  </head>
  <body class="bg-gray-50 text-gray-800">
    <%@include file="/WEB-INF/include/header.jsp" %>

    <main class="pt-28 pb-16">
      <section class="max-w-6xl mx-auto px-4">
        <h1 class="text-4xl font-bold text-indigo-600 mb-6">Liên hệ</h1>
        <p class="text-gray-700 mb-8 max-w-3xl">
          Có câu hỏi hoặc cần hỗ trợ? Hãy liên hệ với Sweetimal Pet Care. Chúng tôi luôn sẵn sàng đồng hành cùng bạn và các bé thú cưng.
        </p>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Thông tin liên hệ -->
          <div class="bg-white rounded-2xl shadow p-6 space-y-4">
            <h2 class="text-2xl font-semibold text-blue-600">Thông tin</h2>
            <div class="space-y-2 text-gray-700">
              <p><i class="fa-solid fa-location-dot text-red-500 mr-2"></i>Địa chỉ: 600 Nguyễn Văn Cừ Nối Dài, An Bình, Bình Thủy, Cần Thơ 900000, Việt Nam</p>
              <p><i class="fa-solid fa-phone text-green-600 mr-2"></i>Điện thoại: +336 922 235</p>
              <p><i class="fa-solid fa-envelope text-indigo-600 mr-2"></i>Email: support@sweetimal.vn</p>
              <p>
                <i class="fa-brands fa-facebook text-blue-600 mr-2"></i>
                <a class="text-blue-600 hover:underline" href="#" target="_blank" rel="noopener">Facebook</a>
              </p>
            </div>

            <div class="mt-6">
              <a href="https://maps.app.goo.gl/z5q3vaek9iW416mL6" target="_blank" rel="noopener"
                 class="inline-flex items-center px-5 py-3 rounded-full bg-gradient-to-r from-indigo-500 to-pink-500 text-white font-semibold shadow hover:from-indigo-600 hover:to-pink-600">
                <i class="fa-solid fa-map-location-dot mr-2"></i> Xem trên Google Maps
              </a>
            </div>
          </div>

          <div class="space-y-4">
            <img src="assets/img/ggmaps.png" alt="Sweetimal Pet Care" class="w-full h-64 object-cover rounded-2xl shadow border" />
          </div>
        </div>

      </section>
    </main>

    <%@include file="/WEB-INF/include/footer.jsp" %>
  </body>
</html>
