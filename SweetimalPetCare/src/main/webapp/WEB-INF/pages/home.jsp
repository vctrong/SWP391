<%-- 
    Document   : home
    Created on : Sep 15, 2025, 12:41:25 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sweetimal Pet Care</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.12.0/dist/cdn.min.js" defer></script>
    </head>
    <body class="bg-white text-gray-800">
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>
        <%@include file="/WEB-INF/include/sidebarInfo.jsp" %>
        <!-- Phần giới thiệu -->
        <section class="relative bg-blue-100">
            <div class="container mx-auto flex flex-col md:flex-row items-center py-20 px-6">
                <div class="md:w-1/2">
                    <h2 class="text-4xl md:text-5xl font-bold mb-6 text-blue-800">
                        Chăm sóc thú cưng của bạn với tình yêu & đam mê
                    </h2>
                    <p class="text-lg mb-6">
                        Khám phá các dịch vụ và sản phẩm chất lượng cho thú cưng. Từ làm đẹp đến bữa ăn dinh dưỡng, chúng tôi đều có.
                    </p>
                    <a href="#services" class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Khám phá dịch vụ</a>
                </div>
                <div class="md:w-1/2 mt-10 md:mt-0">
                    <img src="https://cdn.pixabay.com/photo/2017/09/25/13/12/dog-2785074_1280.jpg" alt="Chăm sóc thú cưng" class="rounded-2xl shadow-lg">
                </div>
            </div>
        </section>


        <!-- Giới thiệu -->
        <section class="py-16 px-6 text-center">
            <h2 class="text-3xl font-bold mb-4">Về Sweetimal Pet Care</h2>
            <p class="max-w-2xl mx-auto text-gray-600">Chúng tôi cung cấp dịch vụ làm đẹp, kiểm tra sức khỏe thú y và đa dạng sản phẩm cho thú cưng để các bé luôn khỏe mạnh, hạnh phúc.</p>
        </section>

        <!-- Dịch vụ nổi bật -->
        <section id="services" class="py-16 bg-gray-50 px-6 text-center">
            <h2 class="text-3xl font-bold mb-8">Dịch vụ của chúng tôi</h2>
            <div class="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Chăm sóc - Làm đẹp</h3>
                    <p class="text-gray-500 text-sm">Chăm sóc chuyên nghiệp cho mọi giống thú cưng.</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Thú y</h3>
                    <p class="text-gray-500 text-sm">Bác sĩ thú y giàu kinh nghiệm, tận tâm.</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://cdn-icons-png.flaticon.com/512/616/616408.png" class="w-16 mx-auto mb-4" />
                    <h3 class="font-semibold text-lg">Huấn luyện thú cưng</h3>
                    <p class="text-gray-500 text-sm">Huấn luyện vâng lời, cải thiện hành vi.</p>
                </div>
            </div>
            <a href="/services" class="inline-block mt-8 bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Xem thêm dịch vụ</a>
        </section>

        <!-- Cửa hàng thú cưng -->
        <section id="shop" class="py-16 px-6 text-center">
            <h2 class="text-3xl font-bold mb-8">Cửa hàng thú cưng</h2>
            <div class="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1558788353-f76d92427f16?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Thức ăn cho chó</h3>
                    <p class="text-gray-500 text-sm">250.000đ</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1598133894005-449d6e5c7fbb?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Đồ chơi cho mèo</h3>
                    <p class="text-gray-500 text-sm">100.000đ</p>
                </div>
                <div class="p-6 bg-white rounded-2xl shadow hover:shadow-lg">
                    <img src="https://images.unsplash.com/photo-1619983081654-7fa34b5d2a5a?auto=format&fit=crop&w=400&q=80" class="w-full h-40 object-cover rounded-lg mb-4" />
                    <h3 class="font-semibold">Giường thú cưng</h3>
                    <p class="text-gray-500 text-sm">450.000đ</p>
                </div>
            </div>
            <a href="/shop" class="inline-block mt-8 bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Đến cửa hàng</a>
        </section>

        <!-- Đăng ký tư vấn miễn phí -->
        <section id="contact" class="py-16 bg-gray-100 px-6 text-center">
            <h2 class="text-3xl font-bold mb-6">Đăng ký tư vấn miễn phí</h2>
            <form class="max-w-xl mx-auto space-y-4">
                <input type="text" placeholder="Họ và tên" class="w-full border rounded-lg px-4 py-3" />
                <input type="email" placeholder="Email của bạn" class="w-full border rounded-lg px-4 py-3" />
                <select class="w-full border rounded-lg px-4 py-3">
                    <option>Chọn dịch vụ/sản phẩm</option>
                    <option>Chăm sóc - Làm đẹp</option>
                    <option>Thú y</option>
                    <option>Huấn luyện thú cưng</option>
                    <option>Hỏi đáp cửa hàng</option>
                </select>
                <textarea placeholder="Nội dung cần tư vấn" class="w-full border rounded-lg px-4 py-3"></textarea>
                <button type="submit" class="bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Gửi</button>
            </form>
        </section>

        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
        <script src="assets/js/script.js"></script>
    </body>
</html>



