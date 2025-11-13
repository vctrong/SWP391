<%--
    Document   : home
    Created on : Sep 15, 2025, 12:41:25 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        <section class="relative bg-gradient-to-br from-sky-50 via-cyan-50 to-white overflow-hidden pb-28">
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


        <!-- Giới thiệu ngắn gọn có phân tầng -->
        <section class="relative -mt-20 bg-white rounded-t-[3rem] shadow-2xl py-20 px-6 overflow-hidden z-20">
            <!-- Decorative Elements -->
            <div class="absolute top-0 right-0 w-80 h-80 bg-sky-100 rounded-full blur-3xl opacity-20"></div>
            <div class="absolute bottom-0 left-0 w-72 h-72 bg-cyan-100 rounded-full blur-3xl opacity-30"></div>

            <div class="relative z-10 max-w-3xl mx-auto text-center">
                <!-- Badge -->
                <div class="inline-flex items-center bg-gradient-to-r from-sky-50 to-cyan-50 rounded-full shadow-sm px-4 py-2 text-sm text-sky-600 font-medium mb-6 hover:shadow-md transition duration-300">
                    <i class="fa-solid fa-paw mr-2 animate-bounce"></i>
                    <span>Về Sweetimal Pet Care</span>
                </div>

                <!-- Title -->
                <h2 class="text-4xl font-bold text-gray-800 mb-6 leading-tight">
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 to-cyan-600">
                        Chăm sóc toàn diện
                    </span> cho thú cưng của bạn
                </h2>

                <!-- Description -->
                <p class="text-lg text-gray-600 mb-8 leading-relaxed">
                    Sweetimal Pet Care là điểm đến tin cậy của hàng ngàn chủ nuôi.  
                    Từ spa, grooming, đến kiểm tra sức khỏe – chúng tôi mang đến cho thú cưng sự chăm sóc chu đáo, an toàn và tận tâm nhất.
                </p>

                <!-- Buttons -->
                <div class="flex flex-col sm:flex-row justify-center gap-4">
                    <a href="aboutUs"
                       class="inline-flex items-center justify-center px-6 py-3 bg-gradient-to-r from-sky-500 to-cyan-500 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl hover:from-sky-600 hover:to-cyan-600 hover:-translate-y-0.5 transition-all duration-300">
                        <i class="fa-solid fa-info-circle mr-2"></i> Xem chi tiết
                    </a>
                    <a href="services"
                       class="inline-flex items-center justify-center px-6 py-3 bg-white text-sky-600 rounded-xl font-semibold shadow hover:shadow-lg border-2 border-sky-100 hover:border-sky-300 hover:-translate-y-0.5 transition-all duration-300">
                        <i class="fa-solid fa-dog mr-2"></i> Khám phá dịch vụ
                    </a>
                </div>
            </div>
        </section>

        <!-- Dịch vụ nổi bật -->
        <!-- Dịch vụ nổi bật -->
        <section id="services" class="relative -mt-10 bg-gradient-to-br from-sky-50 via-cyan-50 to-white py-24 overflow-hidden rounded-t-[3rem]">
            <!-- Background Decorations -->
            <div class="absolute top-0 left-0 w-80 h-80 bg-sky-200 rounded-full blur-3xl opacity-20"></div>
            <div class="absolute bottom-0 right-0 w-96 h-96 bg-cyan-200 rounded-full blur-3xl opacity-20"></div>

            <div class="relative z-10 max-w-7xl mx-auto px-6 text-center">
                <!-- Section Header -->
                <div class="inline-flex items-center bg-gradient-to-r from-sky-100 to-cyan-100 rounded-full px-4 py-2 text-sky-600 font-medium text-sm mb-6 shadow-sm">
                    <i class="fa-solid fa-paw mr-2 animate-bounce"></i>
                    <span>Dịch vụ nổi bật</span>
                </div>

                <h2 class="text-4xl md:text-5xl font-bold text-gray-800 mb-6 leading-tight">
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 to-cyan-600">
                        Dịch vụ
                    </span> tốt nhất cho thú cưng của bạn
                </h2>

                <p class="text-gray-600 max-w-2xl mx-auto mb-14 leading-relaxed text-lg">
                    Từ chăm sóc, làm đẹp đến thăm khám và huấn luyện — Sweetimal mang đến sự tận tâm, an toàn 
                    và niềm vui cho mỗi bé thú cưng 🐶💖
                </p>

                <!-- Services Grid -->
                <div class="grid md:grid-cols-3 gap-10">
                    <!-- Service Card 1 -->
                    <div class="group relative bg-white/70 backdrop-blur-sm rounded-3xl p-8 shadow-sm border border-transparent hover:border-sky-100 hover:shadow-lg hover:-translate-y-2 transition-all duration-300">
                        <div class="absolute -top-8 left-1/2 -translate-x-1/2 w-20 h-20 rounded-2xl bg-gradient-to-br from-sky-200 to-cyan-200 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform duration-300">
                            <i class="fa-solid fa-shower text-sky-700 text-2xl"></i>
                        </div>
                        <div class="pt-14">
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Chăm sóc & Làm đẹp</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                Spa, tắm gội, cắt tỉa lông và làm đẹp giúp bé luôn thơm tho, đáng yêu và khỏe mạnh hơn.
                            </p>
                        </div>
                    </div>

                    <!-- Service Card 2 -->
                    <div class="group relative bg-white/70 backdrop-blur-sm rounded-3xl p-8 shadow-sm border border-transparent hover:border-cyan-100 hover:shadow-lg hover:-translate-y-2 transition-all duration-300">
                        <div class="absolute -top-8 left-1/2 -translate-x-1/2 w-20 h-20 rounded-2xl bg-gradient-to-br from-cyan-200 to-teal-200 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform duration-300">
                            <i class="fa-solid fa-stethoscope text-cyan-700 text-2xl"></i>
                        </div>
                        <div class="pt-14">
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Thú y tận tâm</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                Khám sức khỏe, tiêm phòng và điều trị bởi đội ngũ bác sĩ chuyên nghiệp, yêu thương thú cưng như của mình.
                            </p>
                        </div>
                    </div>

                    <!-- Service Card 3 -->
                    <div class="group relative bg-white/70 backdrop-blur-sm rounded-3xl p-8 shadow-sm border border-transparent hover:border-pink-100 hover:shadow-lg hover:-translate-y-2 transition-all duration-300">
                        <div class="absolute -top-8 left-1/2 -translate-x-1/2 w-20 h-20 rounded-2xl bg-gradient-to-br from-pink-200 to-rose-200 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform duration-300">
                            <i class="fa-solid fa-dog text-pink-700 text-2xl"></i>
                        </div>
                        <div class="pt-14">
                            <h3 class="text-xl font-semibold text-gray-800 mb-3">Huấn luyện hành vi</h3>
                            <p class="text-gray-500 text-sm leading-relaxed">
                                Huấn luyện cơ bản, cải thiện hành vi và giúp bé học cách hòa đồng, ngoan ngoãn và vui vẻ hơn.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Button -->
                <div class="mt-14">
                    <a href="services"
                       class="inline-flex items-center justify-center gap-2 px-8 py-3 bg-gradient-to-r from-sky-500 to-cyan-500 text-white font-semibold rounded-full shadow-md hover:shadow-xl hover:scale-105 transition-all duration-300">
                        <i class="fa-solid fa-paw"></i> Xem thêm dịch vụ
                    </a>
                </div>
            </div>
        </section>


        <!-- Cửa hàng thú cưng -->
        <!-- 🐾 CỬA HÀNG THÚ CƯNG -->
        <section id="shop" class="relative bg-white py-20 px-6 overflow-hidden">
            <!-- Decorative elements -->
            <div class="absolute top-0 left-0 w-80 h-80 bg-sky-100 rounded-full blur-3xl opacity-20"></div>
            <div class="absolute bottom-0 right-0 w-72 h-72 bg-cyan-100 rounded-full blur-3xl opacity-20"></div>

            <div class="relative z-10 text-center max-w-6xl mx-auto">
                <div class="inline-flex items-center bg-gradient-to-r from-sky-50 to-cyan-50 rounded-full shadow-sm px-4 py-2 text-sm text-sky-600 font-medium mb-6 hover:shadow-md transition duration-300">
                    <i class="fa-solid fa-store mr-2 text-cyan-500"></i>
                    <span>Cửa hàng thú cưng</span>
                </div>

                <h2 class="text-4xl font-bold text-gray-800 mb-10 leading-tight">
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 to-cyan-600">
                        Sản phẩm nổi bật
                    </span> được yêu thích nhất
                </h2>

                <div class="grid md:grid-cols-3 gap-8">
                    <!-- Card 1 -->
                    <div class="group bg-gradient-to-br from-white to-sky-50 rounded-3xl shadow-lg hover:shadow-2xl p-6 transition-all duration-500 transform hover:-translate-y-2">
                        <div class="relative overflow-hidden rounded-2xl mb-4">
                            <img src="https://images.unsplash.com/photo-1629306219761-c85a6a436bd9?auto=format&fit=crop&w=600&q=80"
                                 class="w-full h-52 object-cover group-hover:scale-110 transition-transform duration-700" />
                            <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-40 transition duration-500 rounded-2xl"></div>
                        </div>
                        <h3 class="font-semibold text-lg text-gray-800">Thức ăn dinh dưỡng cho chó</h3>
                        <p class="text-sky-600 font-medium mt-2">250.000đ</p>
                    </div>

                    <!-- Card 2 -->
                    <div class="group bg-gradient-to-br from-white to-sky-50 rounded-3xl shadow-lg hover:shadow-2xl p-6 transition-all duration-500 transform hover:-translate-y-2">
                        <div class="relative overflow-hidden rounded-2xl mb-4">
                            <img src="https://images.unsplash.com/photo-1601758124510-52d02f08b0b4?auto=format&fit=crop&w=600&q=80"
                                 class="w-full h-52 object-cover group-hover:scale-110 transition-transform duration-700" />
                            <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-40 transition duration-500 rounded-2xl"></div>
                        </div>
                        <h3 class="font-semibold text-lg text-gray-800">Đồ chơi tương tác cho mèo</h3>
                        <p class="text-sky-600 font-medium mt-2">120.000đ</p>
                    </div>

                    <!-- Card 3 -->
                    <div class="group bg-gradient-to-br from-white to-sky-50 rounded-3xl shadow-lg hover:shadow-2xl p-6 transition-all duration-500 transform hover:-translate-y-2">
                        <div class="relative overflow-hidden rounded-2xl mb-4">
                            <img src="https://images.unsplash.com/photo-1607419726999-6be7eb32b5b0?auto=format&fit=crop&w=600&q=80"
                                 class="w-full h-52 object-cover group-hover:scale-110 transition-transform duration-700" />
                            <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-40 transition duration-500 rounded-2xl"></div>
                        </div>
                        <h3 class="font-semibold text-lg text-gray-800">Giường êm ái cho thú cưng</h3>
                        <p class="text-sky-600 font-medium mt-2">450.000đ</p>
                    </div>
                </div>

                <a href="/shop"
                   class="mt-12 inline-flex items-center justify-center bg-gradient-to-r from-sky-500 to-cyan-500 text-white px-8 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl hover:from-sky-600 hover:to-cyan-600 hover:-translate-y-0.5 transition-all duration-300">
                    <i class="fa-solid fa-paw mr-2"></i> Đến cửa hàng
                </a>
            </div>
        </section>

        <!-- 💌 ĐĂNG KÝ TƯ VẤN MIỄN PHÍ -->
        <section id="contact" class="relative bg-gradient-to-br from-sky-50 via-cyan-50 to-white py-20 px-6 overflow-hidden">
            <!-- Decorative Elements -->
            <div class="absolute top-0 right-0 w-80 h-80 bg-sky-200 rounded-full blur-3xl opacity-25"></div>
            <div class="absolute bottom-0 left-0 w-72 h-72 bg-cyan-200 rounded-full blur-3xl opacity-25"></div>

            <div class="relative z-10 text-center max-w-3xl mx-auto">
                <div class="inline-flex items-center bg-white/70 backdrop-blur-sm rounded-full shadow-sm px-4 py-2 text-sm text-sky-600 font-medium mb-6 hover:shadow-md transition duration-300">
                    <i class="fa-solid fa-comments mr-2"></i>
                    <span>Tư vấn miễn phí</span>
                </div>

                <h2 class="text-4xl font-bold text-gray-800 mb-8 leading-tight">
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 to-cyan-600">
                        Đăng ký ngay
                    </span> để được hỗ trợ tận tâm nhất
                </h2>

                <form class="space-y-5" method="post" action="${pageContext.request.contextPath}/consultation-request">
                    <div class="grid md:grid-cols-2 gap-4">
                        <input name="customer_name" type="text" placeholder="Họ và tên" required maxlength="120" class="w-full border border-sky-100 rounded-xl px-4 py-3 focus:ring-2 focus:ring-cyan-300 outline-none transition" />
                        <input name="email" type="email" placeholder="Email của bạn" required maxlength="150" class="w-full border border-sky-100 rounded-xl px-4 py-3 focus:ring-2 focus:ring-cyan-300 outline-none transition" />
                    </div>
                    <div class="grid md:grid-cols-2 gap-4">
                        <input name="phone" type="text" placeholder="Số điện thoại" maxlength="20" class="w-full border border-sky-100 rounded-xl px-4 py-3 focus:ring-2 focus:ring-cyan-300 outline-none transition" />
                        <select name="subject" required class="w-full border border-sky-100 rounded-xl px-4 py-3 focus:ring-2 focus:ring-cyan-300 outline-none transition">
                            <option value="">Chọn dịch vụ/sản phẩm</option>
                            <option>Chăm sóc - Làm đẹp</option>
                            <option>Thú y</option>
                            <option>Huấn luyện thú cưng</option>
                            <option>Hỏi đáp cửa hàng</option>
                        </select>
                    </div>
                    <textarea name="request_message" placeholder="Nội dung cần tư vấn" required class="w-full border border-sky-100 rounded-xl px-4 py-3 h-32 focus:ring-2 focus:ring-cyan-300 outline-none transition"></textarea>

                    <button type="submit"
                            class="bg-gradient-to-r from-sky-500 to-cyan-500 text-white px-8 py-3 rounded-xl font-semibold shadow-lg hover:shadow-xl hover:from-sky-600 hover:to-cyan-600 hover:-translate-y-0.5 transition-all duration-300">
                        <i class="fa-solid fa-paper-plane mr-2"></i> Gửi yêu cầu
                    </button>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${param.cr_success == '1'}">
                        <div class="text-green-600 font-medium">Yêu cầu của bạn đã được gửi thành công!</div>
                    </c:if>
                    <c:if test="${param.cr_success == '0'}">
                        <div class="text-red-600 font-medium">${fn:escapeXml(param.cr_msg)}</div>
                    </c:if>
                </form>
            </div>
        </section>


        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>


    </body>
</html>



