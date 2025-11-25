<%--
    Document   : newjsp
    Created on : Oct 6, 2025, 1:38:11 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Setting Page</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body>
        <%@include file="/WEB-INF/include/header.jsp" %>
        <section class="bg-white p-6 rounded shadow mt-8">
            <h2 class="text-2xl font-bold mb-4 text-red-600">Xóa hoặc Vô hiệu hóa tài khoản</h2>
            <p class="text-gray-600 mb-4">
                Nếu bạn vô hiệu hóa tài khoản, bạn có thể đăng nhập lại bất kỳ lúc nào để khôi phục.
            </p>
            <form action="settings" method="post" class="space-x-4">
                <button name="action" value="deactivate"
                        onclick="return confirm('Bạn có chắc muốn vô hiệu hóa tài khoản này?');"
                        class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">
                    Vô hiệu hóa tài khoản
                </button>

                <%-- Show delete option only when user has no bookings --%>
                <% Boolean hasBooking = (Boolean) request.getAttribute("hasBooking");
                   String error = (String) request.getAttribute("error");
                   if (error != null) { %>
                    <div class="mt-4 p-3 bg-red-100 text-red-800 rounded"> <%= error %> </div>
                <% } %>

                <% if (hasBooking == null || !hasBooking) { %>
                    <button type="button" onclick="if (confirm('Bạn có chắc chắn muốn xóa tài khoản này vĩnh viễn?')) { this.name='action'; this.value='delete'; this.form.submit(); }"
                            class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">
                        Xóa tài khoản
                    </button>
                <% } else { %>
                    <div class="mt-4 p-3 bg-yellow-50 text-gray-800 rounded">
                        Bạn không thể xóa tài khoản vì bạn đã có lịch đặt trước. Bạn chỉ có thể vô hiệu hóa tài khoản.
                    </div>
                <% } %>
            </form>
        </section>
        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
