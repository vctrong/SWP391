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

        <main class="pt-28 pb-20 bg-gradient-to-br from-sky-50 via-white to-pink-50">
            <section class="max-w-7xl mx-auto px-6 text-center">
                <!-- Tiêu đề -->
                <h1 class="text-4xl md:text-5xl font-bold text-blue-600 mb-4">
                    Liên hệ với Sweetimal Pet Care
                </h1>
                <p class="text-gray-600 mb-10 max-w-3xl mx-auto">
                    Có thắc mắc hay cần hỗ trợ? Hãy để Sweetimal giúp bạn và bé thú cưng của bạn nhận được sự chăm sóc tận tâm nhất 💕
                </p>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
                    <!-- Thông tin liên hệ -->
                    <div class="bg-white/80 backdrop-blur-sm shadow-xl rounded-3xl p-8 text-left border border-blue-100 hover:shadow-2xl transition duration-500">
                        <h2 class="text-2xl font-semibold text-indigo-600 mb-4 flex items-center">
                            <i class="fa-solid fa-paw text-pink-500 mr-2"></i> Thông tin liên hệ
                        </h2>
                        <ul class="space-y-3 text-gray-700">
                            <li>
                                <i class="fa-solid fa-location-dot text-red-500 mr-2"></i>
                                <span>600 Nguyễn Văn Cừ Nối Dài, An Bình, Bình Thủy, Cần Thơ</span>
                            </li>
                            <li>
                                <i class="fa-solid fa-phone text-green-600 mr-2"></i>
                                <span>+336 922 235</span>
                            </li>
                            <li>
                                <i class="fa-solid fa-envelope text-indigo-600 mr-2"></i>
                                <span>support@sweetimal.vn</span>
                            </li>
                            <li>
                                <i class="fa-brands fa-facebook text-blue-600 mr-2"></i>
                                <a href="#" target="_blank" class="hover:underline text-blue-600">Facebook</a>
                            </li>
                        </ul>

                        <a href="https://maps.app.goo.gl/z5q3vaek9iW416mL6"
                           target="_blank"
                           class="inline-flex items-center px-6 py-3 mt-6 rounded-full bg-gradient-to-r from-pink-500 to-indigo-500 text-white font-semibold shadow-md hover:shadow-xl hover:scale-105 transition duration-300">
                            <i class="fa-solid fa-map-location-dot mr-2"></i> Xem trên Google Maps
                        </a>
                    </div>

                    <!-- Hình ảnh bản đồ -->
                    <div class="relative group">
                        <div class="absolute inset-0 bg-gradient-to-tr from-pink-200/30 to-blue-200/30 rounded-3xl blur-2xl opacity-70 group-hover:opacity-100 transition duration-500"></div>
                        <img src="assets/img/ggmaps.png"
                             alt="Bản đồ Sweetimal Pet Care"
                             class="relative w-full h-80 object-cover rounded-3xl shadow-lg border border-gray-200 transform group-hover:scale-[1.02] transition duration-500" />
                    </div>
                </div>

                <!-- Form liên hệ -->
                <div class="mt-16 bg-gradient-to-r from-blue-50 to-pink-50 border border-blue-100 rounded-3xl shadow-inner p-8 max-w-3xl mx-auto">
                    <h2 class="text-2xl font-semibold text-indigo-600 mb-6">Gửi tin nhắn cho chúng tôi</h2>
                    <form class="space-y-4">
                        <div class="grid md:grid-cols-2 gap-4">
                            <input type="text" placeholder="Họ và tên" class="w-full border rounded-xl px-4 py-3 focus:ring-2 focus:ring-pink-400 outline-none transition" />
                            <input type="email" placeholder="Email của bạn" class="w-full border rounded-xl px-4 py-3 focus:ring-2 focus:ring-pink-400 outline-none transition" />
                        </div>
                        <input type="text" placeholder="Chủ đề" class="w-full border rounded-xl px-4 py-3 focus:ring-2 focus:ring-pink-400 outline-none transition" />
                        <textarea placeholder="Nội dung tin nhắn" rows="4" class="w-full border rounded-xl px-4 py-3 focus:ring-2 focus:ring-pink-400 outline-none transition"></textarea>
                        <button type="submit" class="bg-gradient-to-r from-pink-500 to-indigo-500 text-white px-6 py-3 rounded-full font-semibold hover:from-pink-600 hover:to-indigo-600 transition duration-300 shadow-lg hover:shadow-xl">
                            <i class="fa-solid fa-paper-plane mr-2"></i> Gửi tin nhắn
                        </button>
                    </form>
                </div>
            </section>
        </main>


        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
