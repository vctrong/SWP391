<%-- 
    Document   : gopYHoTro
    Created on : Nov 16, 2025, 5:48:56 AM
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
    <body class="bg-gray-100 font-sans min-h-screen">
        <%@include file="/WEB-INF/include/headerProfileUser.jsp" %>
        <div class="max-w-7xl mx-auto py-8 px-4 lg:flex lg:gap-6">
            <%@include file="/WEB-INF/include/sidebarProfileUser.jsp" %>

            <!-- Main content -->
            <main class="w-full lg:w-3/4">
                <!-- Page title -->
                <div class="mb-6">
                    <h3 class="text-lg font-semibold text-sky-600 mb-1">Góp ý & Hỗ trợ</h3>
                    <p class="text-sm text-slate-500">Các kênh hỗ trợ nhanh, tra cứu lịch sử yêu cầu và đọc FAQ giúp bạn giải quyết nhanh vấn đề.</p>
                </div>

                <!-- Top cards -->
                <div class="grid lg:grid-cols-3 gap-6 mb-6">
                    <!-- Hotline / Live -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col justify-between">
                        <div>
                            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-sky-50 text-sky-600 mb-4">
                                <i class="fa-solid fa-phone fa-lg"></i>
                            </div>
                            <h4 class="text-lg font-semibold text-slate-800 mb-1">Tư vấn & Đặt lịch</h4>
                            <p class="text-sm text-slate-500 mb-3">Hỗ trợ nhanh về đặt lịch dịch vụ, tư vấn gói phù hợp cho thú cưng.</p>

                            <ul class="text-sm text-slate-600 space-y-1">
                                <li><strong>Giờ hoạt động:</strong> 08:00 – 22:00 (hằng ngày)</li>
                                <li><strong>Thời gian phản hồi:</strong> Gọi ngay để được hỗ trợ tức thì</li>
                                <li><strong>Số điện thoại:</strong> <span class="font-medium">0123 456 789</span></li>
                            </ul>
                        </div>

                        <div class="mt-6 flex gap-3">
                            <a href="tel:0123456789" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-sky-600 text-white rounded-lg text-sm hover:from-sky-700">
                                <i class="fa-solid fa-phone"></i> Gọi ngay
                            </a>
                            <a href="/chat" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-sky-50 text-sky-700 rounded-lg text-sm hover:shadow">
                                <i class="fa-solid fa-comment-dots"></i> Chat
                            </a>
                        </div>
                    </div>

                    <!-- Complaints -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col justify-between border border-red-50">
                        <div>
                            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-red-50 text-red-600 mb-4">
                                <i class="fa-solid fa-triangle-exclamation fa-lg"></i>
                            </div>
                            <h4 class="text-lg font-semibold text-slate-800 mb-1">Khiếu nại & Xử lý</h4>
                            <p class="text-sm text-slate-500 mb-3">Xử lý khiếu nại, mất mát, sai sót đơn hàng hoặc dịch vụ. Ưu tiên khách VIP.</p>

                            <ul class="text-sm text-slate-600 space-y-1">
                                <li><strong>Hỗ trợ khẩn cấp:</strong> 24/7</li>
                                <li><strong>Số tiếp nhận:</strong> <span class="font-medium">0987 654 321</span></li>
                            </ul>
                        </div>

                        <div class="mt-6 flex gap-3">
                            <a href="tel:0987654321" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-white border border-red-100 text-red-600 rounded-lg text-sm hover:bg-red-50">
                                <i class="fa-solid fa-phone-volume"></i> Gọi Khẩn
                            </a>
                            <a href="/support/submit-complaint" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg text-sm hover:bg-red-700">
                                <i class="fa-solid fa-file-circle-exclamation"></i> Gửi Khiếu nại
                            </a>
                        </div>
                    </div>

                    <!-- Email / Tickets -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col justify-between border border-emerald-50">
                        <div>
                            <div class="inline-flex items-center justify-center w-12 h-12 rounded-xl bg-emerald-50 text-emerald-700 mb-4">
                                <i class="fa-regular fa-envelope fa-lg"></i>
                            </div>
                            <h4 class="text-lg font-semibold text-slate-800 mb-1">Email & Support Ticket</h4>
                            <p class="text-sm text-slate-500 mb-3">Gửi chi tiết kèm file/hình ảnh để đội ngũ xử lý chính xác.</p>

                            <ul class="text-sm text-slate-600 space-y-1">
                                <li><strong>Email:</strong> <span class="font-medium">support@sweetimal.vn</span></li>
                                <li><strong>Thời gian phản hồi:</strong> ≤ 24 giờ làm việc</li>
                            </ul>
                        </div>

                        <div class="mt-6 flex gap-3">
                            <a href="mailto:support@sweetimal.vn" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-white border border-emerald-100 text-emerald-700 rounded-lg text-sm hover:shadow">
                                <i class="fa-regular fa-paper-plane"></i> Gửi Email
                            </a>
                            <a href="/support/tickets" class="flex-1 inline-flex items-center justify-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg text-sm hover:bg-emerald-700">
                                <i class="fa-solid fa-ticket"></i> Quản lý Ticket
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Middle section: Quick links + FAQ + recent tickets -->
                <div class="grid lg:grid-cols-3 gap-6 mb-6">
                    <!-- Quick links -->
                    <div class="bg-white rounded-2xl shadow p-6">
                        <h5 class="font-semibold text-slate-800 mb-4">Liên kết nhanh</h5>
                        <div class="flex flex-col gap-3">
                            <a href="/profile?tab=history" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                <i class="fa-solid fa-clock-rotate-left text-sky-600 w-5"></i>
                                <div>
                                    <div class="text-sm font-medium">Tra cứu đơn & lịch sử</div>
                                    <div class="text-xs text-slate-500">Xem trạng thái đơn hàng và booking</div>
                                </div>
                            </a>

                            <a href="/support/faq" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                <i class="fa-solid fa-book text-emerald-600 w-5"></i>
                                <div>
                                    <div class="text-sm font-medium">FAQ & Hướng dẫn</div>
                                    <div class="text-xs text-slate-500">Giải đáp nhanh các câu hỏi phổ biến</div>
                                </div>
                            </a>

                            <a href="/support/submit-issue" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                <i class="fa-solid fa-headset text-purple-600 w-5"></i>
                                <div>
                                    <div class="text-sm font-medium">Tạo yêu cầu hỗ trợ</div>
                                    <div class="text-xs text-slate-500">Gửi ticket để đội ngũ xử lý</div>
                                </div>
                            </a>

                            <a href="/support/returns" class="flex items-center gap-3 p-3 rounded-lg border border-slate-100 hover:shadow">
                                <i class="fa-solid fa-rotate-left text-amber-600 w-5"></i>
                                <div>
                                    <div class="text-sm font-medium">Yêu cầu đổi/hoàn trả</div>
                                    <div class="text-xs text-slate-500">Quy trình đổi/hoàn trả sản phẩm</div>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- FAQ (details) -->
                    <div class="bg-white rounded-2xl shadow p-6 lg:col-span-2">
                        <div class="flex items-center justify-between mb-4">
                            <h5 class="font-semibold text-slate-800">Câu hỏi thường gặp</h5>
                            <a href="/support/faq" class="text-sky-600 text-sm hover:underline">Xem tất cả</a>
                        </div>

                        <div class="grid gap-3">
                            <details class="group bg-slate-50 rounded-lg p-4" open>
                                <summary class="cursor-pointer font-medium text-slate-800">Làm thế nào để đổi/hoàn trả sản phẩm?</summary>
                                <div class="mt-2 text-sm text-slate-600">
                                    Bạn có thể yêu cầu đổi/hoàn trả trong vòng 7 ngày kể từ ngày nhận hàng. Liên hệ support@sweetimal.vn hoặc tạo ticket để được hỗ trợ.
                                </div>
                            </details>

                            <details class="group bg-slate-50 rounded-lg p-4">
                                <summary class="cursor-pointer font-medium text-slate-800">Tôi có thể hủy lịch hẹn không?</summary>
                                <div class="mt-2 text-sm text-slate-600">
                                    Bạn có thể hủy hoặc thay đổi lịch hẹn trước ít nhất 12 giờ. Vui lòng vào trang quản lý booking để thực hiện.
                                </div>
                            </details>

                            <details class="group bg-slate-50 rounded-lg p-4">
                                <summary class="cursor-pointer font-medium text-slate-800">Làm sao để nhận ưu đãi VIP?</summary>
                                <div class="mt-2 text-sm text-slate-600">
                                    Tích lũy điểm và đạt mốc thuộc tính VIP để nhận ưu đãi. Kiểm tra mục Tổng quan để xem tiến trình.
                                </div>
                            </details>

                            <!-- Recent tickets (hardcoded) -->
                            <div class="mt-6">
                                <h6 class="text-sm font-semibold text-slate-700 mb-3">Yêu cầu hỗ trợ gần đây</h6>
                                <div class="space-y-3">
                                    <div class="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                                        <div class="min-w-0">
                                            <div class="font-medium truncate">Tính năng đang phát triển</div>
                                            <div class="text-xs text-slate-500">Chúng tôi đang làm việc chăm chỉ để phát triển/<div>
                                        </div>
                                       
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bottom CTA -->
                <div class="bg-white rounded-2xl p-6 text-center shadow">
                    <h5 class="text-lg font-semibold text-slate-800">Cần hỗ trợ ngay?</h5>
                    <p class="text-sm text-slate-500 mt-2">Gọi hotline hoặc chat để được hỗ trợ nhanh chóng.</p>
                    <div class="mt-4 flex items-center justify-center gap-3">
                        <a href="tel:0123456789" class="px-6 py-3 bg-sky-600 text-white rounded-lg">Gọi ngay</a>
                        <a href="/chat" class="px-6 py-3 bg-white border rounded-lg">Chat</a>
                        <a href="/support/submit-issue" class="px-6 py-3 bg-emerald-600 text-white rounded-lg">Tạo ticket</a>
                    </div>
                </div>
            </main>


        </div>
    </body>
</html>
