<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - Sweetimal Pet Care</title>
        <!-- Tailwind CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">
        <c:set var="disableLoader" value="true" scope="request" />
        <jsp:include page="/WEB-INF/include/header.jsp" />


        <!-- Form Register -->
        <div class="flex items-center justify-center min-h-screen bg-gradient-to-br from-blue-100 via-pink-100 to-blue-200 pt-10">
            <div class="bg-white shadow-lg rounded-2xl w-full max-w-md p-8">

                <!-- Logo + Title -->
                <div class="flex flex-col items-center mb-8">
                    <img src="${pageContext.request.contextPath}/assets/img/logo.jpg" alt="Logo"
                         class="w-16 mb-4 drop-shadow-lg rounded-full" />
                    <h2 class="text-3xl font-bold text-blue-800 mb-2">Đăng ký</h2>
                </div>

                <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-4">
                    <!-- Username -->
                    <div>
                        <label for="username" class="block text-gray-700 mb-1">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" required 
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="ABCxyz">
                    </div>

                    <!-- Password -->
                    <div>
                        <label for="password" class="block text-gray-700 mb-1">Mật khẩu</label>
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="Mật khẩu">
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label for="confirm" class="block text-gray-700 mb-1">Xác nhận mật khẩu</label>
                        <input type="password" id="confirm" name="confirm" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-pink-400 outline-none"
                               placeholder="Nhập lại mật khẩu">
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-gray-700 mb-1">Email</label>
                        <input type="email" id="email" name="email" required
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="you@example.com">
                    </div>

                    <!-- Phone -->
                    <div>
                        <label for="phone" class="block text-gray-700 mb-1">Số điện thoại</label>
                        <input type="text" id="phone" name="phone"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="08********">
                    </div>

                    <!-- Full name -->
                    <div>
                        <label for="fullname" class="block text-gray-700 mb-1">Họ và tên</label>
                        <input type="text" id="fullname" name="fullname"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                               placeholder="Nhập tên của bạn">
                    </div>

                    <!-- Gender -->
                    <div>
                        <label for="gender" class="block text-gray-700 mb-1">Giới tính</label>
                        <select id="gender" name="gender"
                                class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>

                    <!-- Birthday -->
                    <div>
                        <label for="birthday" class="block text-gray-700 mb-1">Ngày sinh</label>
                        <input type="date" id="birthday" name="birthday"
                               class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>

                    <!-- Submit button -->
                    <button type="submit"
                            class="w-full bg-pink-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-pink-600 transition">
                        Đăng ký
                    </button>
                </form>

                <!-- Hiện lỗi -->
                <c:if test="${not empty error}">
                    <p class="text-red-500 mt-4 text-center">${error}</p>
                </c:if>

                <p class="mt-4 text-center text-sm text-gray-600">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/login" class="text-blue-600 hover:underline">Đăng nhập</a>
                </p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/include/footer.jsp" />

    </body>
</html>
