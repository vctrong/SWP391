<%--
    Document   : login
    Created on : Sep 15, 2025, 1:05:16 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng nhập - Sweetimal Pet Care</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body>
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main
            class="flex items-center justify-center min-h-screen bg-gradient-to-br from-blue-100 via-pink-100 to-blue-200 pt-10">
            <div class="bg-white rounded-3xl shadow-2xl p-10 w-full max-w-md">
                <div class="flex flex-col items-center mb-8">
                    <img src="assets/img/logo.jpg" alt="Logo"
                         class="w-16 mb-4 drop-shadow-lg rounded-full" />
                    <h2 class="text-3xl font-bold text-blue-800 mb-2">Đăng nhập</h2>
                </div>
                <form action="${pageContext.request.contextPath}/login?view=login" method="POST" class="space-y-5">
                    <input type="text" name="username" placeholder="Tên đăng nhập" required
                           class="w-full border border-blue-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-400 transition" />
                    <input type="password" name="password" placeholder="Mật khẩu" required
                           class="w-full border border-blue-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-400 transition" />
                    <c:if test="${not empty sessionScope.loginFail}">
                        <div class="bg-red-100 text-red-700 p-3 rounded mb-4 text-center font-semibold">
                            ${sessionScope.loginFail}
                        </div>
                        <c:remove var="loginFail" scope="session" />
                    </c:if>
                    <div class="text-right -mt-2">
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm text-blue-600 hover:text-blue-700">Quên mật khẩu?</a>
                    </div>
                    <button type="submit"
                            class="w-full bg-pink-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-pink-600 transition">Đăng
                        nhập</button>
                </form>

                <div class="my-6 flex items-center">
                    <hr class="flex-grow border-gray-300" />
                    <span class="mx-3 text-gray-400 text-sm">hoặc</span>
                    <hr class="flex-grow border-gray-300" />
                </div>

                <div class="flex justify-center gap-6 mb-6">
                    <a href="#"
                       class="bg-white border border-gray-300 rounded-full w-12 h-12 flex items-center justify-center shadow hover:bg-gray-50 transition">
                        <i class="fa-brands fa-google text-red-500 text-xl"></i>
                    </a>
                    <a href="#"
                       class="bg-blue-600 border border-blue-600 rounded-full w-12 h-12 flex items-center justify-center shadow hover:bg-blue-700 transition">
                        <i class="fa-brands fa-facebook-f text-white text-xl"></i>
                    </a>
                </div>

                <div class="text-center">
                    <a href="register.html" class="text-blue-600 hover:underline">Chưa có tài khoản? Đăng ký ngay</a>
                </div>
            </div>

        </main>

        <%@include file="/WEB-INF/toast/loginFail.jsp" %>
        <%
            Boolean resetSuccess = (Boolean) session.getAttribute("resetSuccess");
            if (resetSuccess != null && resetSuccess) {
        %>
        <div class="fixed bottom-6 right-6 bg-green-500 text-white px-4 py-3 rounded shadow">
            Đổi mật khẩu thành công
        </div>
        <%
            session.removeAttribute("resetSuccess");
            }
        %>
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
