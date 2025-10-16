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
        <%@include file="/WEB-INF/include/library.jsp" %>
        <style>
            html {
                scroll-behavior: smooth;
            }
        </style>
    </head>
    <body class="bg-white text-gray-800">
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>
        <%@include file="/WEB-INF/toast/loginOk.jsp" %>
        <!-- Phần giới thiệu -->
        <section class="relative bg-gradient-to-br from-sky-50 via-cyan-50 to-white overflow-hidden">
            <!-- Decorative circles -->
            <div class="absolute top-0 right-0 w-72 h-72 bg-sky-200 rounded-full blur-3xl opacity-30 animate-pulse"></div>
            <div class="absolute bottom-0 left-0 w-64 h-64 bg-cyan-200 rounded-full blur-3xl opacity-20"></div>

            <div class="container mx-auto flex flex-col md:flex-row items-center py-20 px-6 relative z-10">
                <!-- Content -->
                <div class="md:w-1/2">
                    <div class="inline-flex items-center bg-white rounded-full shadow-sm px-4 py-2 text-sm text-sky-600 font-medium mb-6 hover:shadow-md transition-shadow duration-300">
                        <i class="fa-solid fa-paw mr-2 animate-bounce"></i>
                        <span>Chăm sóc chuyên nghiệp</span>
                    </div>

                    <h2 class="text-4xl md:text-5xl font-bold mb-6 text-gray-800 leading-tight">
                        Chăm sóc thú cưng của bạn với 
                        <span class="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 to-cyan-600">tình yêu & đam mê</span>
                    </h2>

                    <p class="text-lg text-gray-600 mb-8 leading-relaxed">
                        Khám phá các dịch vụ và sản phẩm chất lượng cho thú cưng. Từ làm đẹp đến bữa ăn dinh dưỡng, chúng tôi đều có.
                    </p>

                    <div class="flex flex-col sm:flex-row gap-4">
                        <a href="#services" 
                           class="inline-flex items-center justify-center px-6 py-3 bg-gradient-to-r from-sky-500 to-cyan-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl hover:from-sky-600 hover:to-cyan-600 hover:-translate-y-0.5 transition-all duration-300">
                            <i class="fa-solid fa-rocket mr-2"></i>Khám phá dịch vụ
                        </a>
                        <a href="#contact" 
                           class="inline-flex items-center justify-center px-6 py-3 bg-white text-sky-600 rounded-xl font-semibold shadow hover:shadow-lg border-2 border-sky-100 hover:border-sky-300 hover:-translate-y-0.5 transition-all duration-300">
                            <i class="fa-solid fa-phone mr-2"></i>Liên hệ ngay
                        </a>
                    </div>
                </div>

                <!-- Image -->
                <div class="md:w-1/2 mt-10 md:mt-0 md:pl-12">
                    <div class="relative group">
                        <!-- Glow effect -->
                        <div class="absolute inset-0 bg-gradient-to-br from-sky-300 to-cyan-300 rounded-3xl blur-2xl opacity-20 group-hover:opacity-30 transition-opacity duration-500"></div>

                        <!-- Main image -->
                        <img src="https://cdn.pixabay.com/photo/2017/09/25/13/12/dog-2785074_1280.jpg" 
                             alt="Chăm sóc thú cưng" 
                             class="relative rounded-3xl shadow-2xl w-full transform group-hover:scale-105 transition-transform duration-500">

                        <!-- Floating badge -->
                        <div class="absolute -bottom-4 -left-4 bg-white rounded-2xl shadow-xl p-4 flex items-center gap-3 hover:scale-105 transition-transform duration-300">
                            <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-sky-100 to-cyan-100 flex items-center justify-center">
                                <i class="fa-solid fa-star text-sky-500 text-xl"></i>
                            </div>
                            <div>
                                <p class="font-bold text-gray-800">Tin cậy #1</p>
                                <p class="text-xs text-gray-500">5000+ khách hàng</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <!-- Giới thiệu -->
        <section class="py-16 px-6 text-center">
            <h2 class="text-3xl font-bold mb-4">Về Sweetimal Pet Care</h2>
            <p class="max-w-2xl mx-auto text-gray-600">Chúng tôi cung cấp dịch vụ làm đẹp, kiểm tra sức khỏe thú y và đa dạng sản phẩm cho thú cưng để các bé luôn khỏe mạnh, hạnh phúc.</p>
        </section>

        <!-- Dịch vụ nổi bật -->
        <section id="services" class="scroll-mt-24 py-16 bg-gray-50 px-6 text-center">
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
            <a href="services" class="inline-block mt-8 bg-pink-500 text-white px-6 py-3 rounded-lg hover:bg-pink-600">Xem thêm dịch vụ</a>
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
        <section id="contact" class="scroll-mt-24 py-16 bg-gray-100 px-6 text-center">
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


    </body>
</html>



