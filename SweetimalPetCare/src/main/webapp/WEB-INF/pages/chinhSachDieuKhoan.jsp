<%-- 
    Document   : chinhSachDieuKhoan
    Created on : Nov 16, 2025, 5:49:12 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body>
        <%@include file="/WEB-INF/include/headerProfileUser.jsp" %>
        <div class="max-w-7xl mx-auto py-8 px-4 lg:flex lg:gap-6">
            <%@include file="/WEB-INF/include/sidebarProfileUser.jsp" %>
            <main class="w-full lg:w-3/4">
                <article class="bg-white rounded-2xl shadow-md p-6">
                    <header class="mb-6">
                        <h3 id="policy-top" class="text-lg font-semibold text-sky-600 mb-2">Chính sách &amp; Điều khoản</h3>
                        <p class="text-sm text-slate-500 mb-3">Tổng hợp điều khoản, chính sách bảo mật, đổi trả, thanh toán và các quy định liên quan đến đặt lịch &amp; dịch vụ. Vui lòng đọc kỹ trước khi sử dụng dịch vụ hoặc mua hàng.</p>

                        <div class="flex items-center gap-3">
                            <div class="text-xs text-slate-500">Cập nhật lần cuối:</div>
                            <div class="text-sm font-medium text-slate-800">10/10/2025</div>

                            <div class="ml-auto flex items-center gap-2">
                                <a href="/policy/download" class="inline-flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">
                                    <i class="fa-solid fa-file-arrow-down"></i> Tải PDF
                                </a>
                                <button onclick="window.print()" class="inline-flex items-center gap-2 px-3 py-2 bg-sky-50 border border-sky-100 text-sky-700 rounded-lg text-sm hover:shadow">
                                    <i class="fa-solid fa-print"></i> In trang
                                </button>
                            </div>
                        </div>
                    </header>

                    <!-- Table of contents (simple anchors) -->
                    <nav class="mb-6">
                        <h4 class="text-sm font-medium text-slate-700 mb-2">Mục lục</h4>
                        <ul class="text-sm text-slate-600 space-y-1">
                            <li><a href="#privacy" class="text-sky-600 hover:underline">1. Chính sách bảo mật</a></li>
                            <li><a href="#returns" class="text-sky-600 hover:underline">2. Chính sách đổi trả & Hoàn tiền</a></li>
                            <li><a href="#terms" class="text-sky-600 hover:underline">3. Điều khoản sử dụng</a></li>
                            <li><a href="#booking" class="text-sky-600 hover:underline">4. Chính sách đặt lịch & Hủy</a></li>
                            <li><a href="#payment" class="text-sky-600 hover:underline">5. Thanh toán & Hoá đơn</a></li>
                            <li><a href="#safety" class="text-sky-600 hover:underline">6. An toàn & Y tế thú cưng</a></li>
                            <li><a href="#contact" class="text-sky-600 hover:underline">7. Khiếu nại & Liên hệ</a></li>
                        </ul>
                    </nav>

                    <!-- Sections -->
                    <section id="privacy" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">1. Chính sách bảo mật</h5>
                        <p class="text-slate-600">Chúng tôi cam kết bảo vệ thông tin cá nhân của khách hàng. Các loại dữ liệu thu thập bao gồm: thông tin tài khoản (họ tên, email, số điện thoại), thông tin địa chỉ giao hàng, lịch sử đơn hàng và lịch hẹn. Dữ liệu chỉ được sử dụng cho mục đích xử lý đơn hàng, cung cấp dịch vụ và cải thiện trải nghiệm người dùng.</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Không chia sẻ thông tin cá nhân cho bên thứ ba mà không có sự đồng ý, trừ khi pháp luật yêu cầu.</li>
                            <li>Sử dụng biện pháp kỹ thuật hợp lệ (HTTPS, mã hóa mật khẩu) để bảo vệ dữ liệu.</li>
                            <li>Khách hàng có quyền yêu cầu truy xuất, chỉnh sửa hoặc xoá dữ liệu theo quy định.</li>
                        </ul>
                    </section>

                    <section id="returns" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">2. Chính sách đổi trả & Hoàn tiền</h5>
                        <p class="text-slate-600">Chính sách đổi trả áp dụng cho các sản phẩm chưa qua sử dụng và còn nguyên bao bì, trong vòng 7 ngày kể từ ngày nhận hàng, trừ trường hợp sản phẩm thuộc danh mục không được đổi trả (ví dụ: sản phẩm tiêu hao mở hộp, sản phẩm y tế).</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Quá trình yêu cầu đổi trả: Khách hàng tạo yêu cầu tại mục Hỗ trợ → Tạo yêu cầu hỗ trợ và đính kèm thông tin đơn hàng, hình ảnh sản phẩm.</li>
                            <li>Hoàn tiền: Sau khi sản phẩm về kho và kiểm tra hợp lệ, tiền sẽ được hoàn trong vòng 5–7 ngày làm việc.</li>
                            <li>Phí vận chuyển: Tùy chính sách khuyến mãi hoặc nguyên nhân đổi trả, phí vận chuyển có thể được hoàn hoặc khách hàng chịu phí.</li>
                        </ul>
                    </section>

                    <section id="terms" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">3. Điều khoản sử dụng</h5>
                        <p class="text-slate-600">Khi sử dụng website và dịch vụ của chúng tôi, khách hàng đồng ý tuân thủ các điều khoản sau:</p>
                        <ol class="list-decimal pl-5 text-slate-600">
                            <li>Thông tin cung cấp phải chính xác, không giả mạo.</li>
                            <li>Nghiêm cấm các hành vi lạm dụng, gây hại cho hệ thống hoặc người dùng khác.</li>
                            <li>Chúng tôi có quyền tạm khoá hoặc chấm dứt tài khoản nếu phát hiện vi phạm nghiêm trọng.</li>
                        </ol>
                    </section>

                    <section id="booking" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">4. Chính sách đặt lịch & Hủy</h5>
                        <p class="text-slate-600">Chính sách này áp dụng cho mọi dịch vụ (grooming, khám bệnh, boarding):</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Đặt lịch: Khách hàng phải chọn dịch vụ, thời gian và thú cưng. Đơn đặt lịch sẽ được xác nhận qua hệ thống hoặc nhân viên phụ trách.</li>
                            <li>Hủy/Thay đổi: Khách hàng có thể hủy hoặc thay đổi lịch hẹn trước ít nhất 12 giờ; nếu hủy muộn có thể áp dụng phí hủy theo từng gói.</li>
                            <li>Không đến (no-show): Nếu khách hàng không đến và không hủy, có thể bị tính phí hoặc giới hạn quyền đặt lịch tiếp theo.</li>
                        </ul>
                    </section>

                    <section id="payment" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">5. Thanh toán & Hoá đơn</h5>
                        <p class="text-slate-600">Hỗ trợ nhiều phương thức thanh toán: tiền mặt, chuyển khoản, ví điện tử, COD. Hoá đơn điện tử sẽ được gửi qua email sau khi đơn hàng/booking hoàn tất.</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Mọi giao dịch đều yêu cầu xác thực thông tin người mua để xuất hoá đơn hợp lệ.</li>
                            <li>Trong trường hợp tranh chấp về thanh toán, vui lòng liên hệ hỗ trợ kèm theo mã đơn/hoá đơn.</li>
                        </ul>
                    </section>

                    <section id="safety" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">6. An toàn & Y tế thú cưng</h5>
                        <p class="text-slate-600">Chúng tôi tuân thủ các quy trình an toàn khi thực hiện dịch vụ y tế và chăm sóc. Khách hàng cần cung cấp thông tin y tế, tiền sử bệnh và các dị ứng (nếu có).</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Trước khi thực hiện thủ thuật (phẫu thuật, gây mê), nhân viên sẽ yêu cầu biểu mẫu đồng ý và thông tin sức khoẻ đầy đủ.</li>
                            <li>Trong trường hợp thú cưng có dấu hiệu bệnh lý nghiêm trọng, bác sĩ có quyền từ chối dịch vụ để đảm bảo an toàn và sẽ tư vấn phương án điều trị.</li>
                        </ul>
                    </section>

                    <section id="contact" class="prose-sm mb-6">
                        <h5 class="text-slate-800 font-semibold mb-2">7. Khiếu nại & Liên hệ</h5>
                        <p class="text-slate-600">Nếu cần khiếu nại hoặc hỗ trợ, bạn có thể:</p>
                        <ul class="list-disc pl-5 text-slate-600">
                            <li>Gọi Hotline: <span class="font-medium">0123 456 789</span> (08:00–22:00)</li>
                            <li>Gửi email: <a href="mailto:support@sweetimal.vn" class="text-sky-600 hover:underline">support@sweetimal.vn</a></li>
                            <li>Tạo ticket tại mục <a href="/support/submit-issue" class="text-sky-600 hover:underline">Tạo yêu cầu hỗ trợ</a> trong trang cá nhân.</li>
                        </ul>

                        <p class="text-sm text-slate-500 mt-3">Bạn có quyền yêu cầu giải quyết hoặc khiếu nại theo quy định pháp luật; chúng tôi cam kết phản hồi trong thời gian sớm nhất.</p>
                    </section>

                    <!-- Footer note -->
                    <footer class="pt-4 border-t border-slate-100 text-sm text-slate-500">
                        <p>Ghi chú: Đây là bản tóm tắt chính sách. Nội dung đầy đủ và chi tiết hơn được lưu trữ trên trang <a href="/policy/full" class="text-sky-600 hover:underline">Chính sách đầy đủ</a>. Công ty bảo lưu quyền cập nhật chính sách — các thay đổi có hiệu lực sau khi được đăng công khai.</p>
                    </footer>
                </article>
            </main>
        </div>
    </body>
</html>
