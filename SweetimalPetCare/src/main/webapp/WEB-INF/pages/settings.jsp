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
                        class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">
                    Vô hiệu hóa tài khoản
                </button>
                <button name="action" value="delete"
                        onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này vĩnh viễn?')"
                        class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">
                    Xóa tài khoản
                </button>
            </form>
        </section>
        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
