<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Về chúng tôi - PetCare</title>
        <%@include file="/WEB-INF/include/library.jsp" %>

    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>
        <div class="relative flex justify-center items-center min-h-screen pt-32 pb-16">
            <!-- Ảnh bên trái -->
            <img src="https://cdn2.fptshop.com.vn/unsafe/800x0/meme_cho_1_e568e5b1a5.jpg" alt="Cute Dog" class="hidden lg:block absolute left-0 top-1/3 w-48 h-48 object-cover rounded-3xl shadow-2xl border-4 border-pink-200 animate-fadeInLeft" style="z-index:1;"/>
            <!-- Ảnh bên phải -->
            <img src="https://cdn11.dienmaycholon.vn/filewebdmclnew/public/userupload/files/Image%20FP_2024/meme-meo-4.jpg" alt="Cute Cat" class="hidden lg:block absolute right-0 top-1/2 w-48 h-48 object-cover rounded-3xl shadow-2xl border-4 border-indigo-200 animate-fadeInRight" style="z-index:1;"/>
            <div class="max-w-4xl mx-auto py-12 px-4 md:px-10 pet-gradient rounded-3xl shadow-2xl border border-indigo-100 relative z-10">
                <div class="flex flex-col md:flex-row items-center mb-10">
                    <img src="assets/img/logo.jpg" alt="Sweetimal Logo" class="h-28 w-28 rounded-full shadow-lg border-4 border-indigo-200 mb-4 md:mb-0 md:mr-8"/>
                    <div>
                        <h1 class="text-5xl font-bold text-indigo-600 mb-2 pet-title">Về chúng tôi 🐾</h1>
                        <p class="text-lg text-gray-700 max-w-2xl mt-2">PetCare tự hào là đơn vị tiên phong trong lĩnh vực chăm sóc thú cưng tại Việt Nam với hơn 10 năm kinh nghiệm. Chúng tôi đã phục vụ hàng ngàn khách hàng và thú cưng, nhận được sự tin tưởng tuyệt đối nhờ vào chất lượng dịch vụ, sự tận tâm và chuyên nghiệp. Đội ngũ của chúng tôi gồm các bác sĩ thú y đầu ngành, kỹ thuật viên giàu kinh nghiệm và nhân viên chăm sóc yêu động vật, luôn đặt sức khỏe và hạnh phúc của thú cưng lên hàng đầu.</p>
                    </div>
                </div>
                <section class="mb-10 bg-white/80 rounded-xl shadow p-6 hover:shadow-lg transition">
                    <h2 class="text-2xl font-semibold text-indigo-500 mb-2 flex items-center">Vì sức khỏe thú cưng <span class="ml-2">❤️🐶🐱</span></h2>
                    <p class="text-gray-700">Chúng tôi hiểu rằng thú cưng không chỉ là vật nuôi mà còn là thành viên quan trọng trong gia đình bạn. PetCare luôn chú trọng cập nhật các phương pháp chăm sóc hiện đại, sử dụng thiết bị y tế tiên tiến và quy trình kiểm soát chất lượng nghiêm ngặt. Mỗi dịch vụ đều được thiết kế cá nhân hóa, phù hợp với từng giống loài, độ tuổi và tình trạng sức khỏe của thú cưng. Chúng tôi đồng hành cùng bạn trong mọi giai đoạn phát triển của "boss", từ tiêm phòng, khám sức khỏe định kỳ, điều trị bệnh lý đến tư vấn dinh dưỡng và chăm sóc toàn diện.</p>
                </section>
                <section class="mb-10 bg-white/80 rounded-xl shadow p-6 hover:shadow-lg transition">
                    <h2 class="text-2xl font-semibold text-indigo-500 mb-2 flex items-center">Lý do lựa chọn <span class="ml-2">✨</span></h2>
                    <ul class="list-disc pl-6 text-gray-700 space-y-1">
                        <li>Đội ngũ chuyên gia giàu kinh nghiệm, được đào tạo bài bản và thường xuyên cập nhật kiến thức mới 🧑‍⚕️</li>
                        <li>Cơ sở vật chất hiện đại, trang thiết bị y tế nhập khẩu từ các nước phát triển 🏥</li>
                        <li>Dịch vụ đa dạng, đáp ứng mọi nhu cầu từ chăm sóc, làm đẹp, khám chữa bệnh đến trông giữ thú cưng 🐕🐈</li>
                        <li>Chính sách chăm sóc khách hàng tận tình, hỗ trợ 24/7, tư vấn miễn phí 🤝</li>
                        <li>Cam kết minh bạch về chi phí, quy trình rõ ràng, không phát sinh phụ phí 📋</li>
                        <li>Hợp tác với các đối tác uy tín trong và ngoài nước, đảm bảo chất lượng dịch vụ tốt nhất 🌏</li>
                        <li>Được khách hàng đánh giá cao trên các nền tảng mạng xã hội và truyền thông ⭐</li>
                    </ul>
                </section>
                <section class="mb-10 bg-white/80 rounded-xl shadow p-6 hover:shadow-lg transition">
                    <h2 class="text-2xl font-semibold text-indigo-500 mb-2 flex items-center">Mục tiêu của chúng tôi <span class="ml-2">🎯</span></h2>
                    <p class="text-gray-700">Mục tiêu của PetCare là trở thành trung tâm chăm sóc thú cưng hàng đầu Việt Nam và khu vực, không ngừng đổi mới để mang lại trải nghiệm tốt nhất cho khách hàng và thú cưng. Chúng tôi hướng tới xây dựng cộng đồng yêu thú cưng văn minh, lan tỏa giá trị nhân văn và nâng cao nhận thức về quyền lợi động vật. PetCare cam kết phát triển bền vững, đóng góp tích cực cho xã hội và môi trường.</p>
                </section>
                <section class="bg-white/80 rounded-xl shadow p-6 hover:shadow-lg transition">
                    <h2 class="text-2xl font-semibold text-indigo-500 mb-2 flex items-center">Lời hứa của chúng tôi <span class="ml-2">🤝</span></h2>
                    <ul class="list-disc pl-6 text-gray-700 space-y-1">
                        <li>Cam kết minh bạch, rõ ràng trong mọi dịch vụ, tư vấn trung thực và tận tâm</li>
                        <li>Chuyên nghiệp trong từng quy trình chăm sóc, đảm bảo an toàn tuyệt đối cho thú cưng</li>
                        <li>Luôn đặt lợi ích và sức khỏe thú cưng lên hàng đầu, coi thú cưng như thành viên trong gia đình</li>
                        <li>Không ngừng nâng cao chất lượng dịch vụ, đầu tư vào con người và công nghệ</li>
                        <li>Luôn lắng nghe, tiếp thu ý kiến khách hàng để hoàn thiện hơn mỗi ngày</li>
                        <li>Đồng hành cùng khách hàng và thú cưng trên mọi chặng đường phát triển</li>
                    </ul>
                </section>
                <div class="flex justify-center mt-12">
                    <a href="home" class="inline-block px-8 py-3 bg-gradient-to-r from-indigo-500 to-pink-400 text-white rounded-full font-semibold text-lg shadow-lg hover:scale-105 hover:from-indigo-600 hover:to-pink-500 transition-all duration-200">Quay lại trang chủ</a>
                </div>
            </div>
        </div>
        <%@include file="/WEB-INF/include/footer.jsp" %>

    </body>
</html>
