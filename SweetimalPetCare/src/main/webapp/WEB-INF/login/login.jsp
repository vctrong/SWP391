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

        <section class="min-h-screen flex items-center justify-center bg-gradient-to-br from-sky-50 via-cyan-50 to-white py-12 px-4">
            <div class="w-full max-w-3xl bg-white rounded-3xl shadow-2xl overflow-hidden grid grid-cols-1 md:grid-cols-2">
                <!-- Left: Branding / friendly info (desktop only) -->
                <aside class="hidden md:flex flex-col items-center justify-center bg-sky-50 p-8 gap-4">
                    <div class="w-36 h-36 rounded-2xl bg-gradient-to-br from-sky-200 to-cyan-200 flex items-center justify-center shadow-sm transform transition-transform duration-500 hover:scale-105">
                        <img src="assets/img/logo.jpg" alt="Logo" class="w-28 h-28 rounded-xl object-cover" />
                    </div>

                    <h3 class="mt-2 text-2xl font-extrabold text-sky-700 text-center">Chăm sóc thú cưng</h3>
                    <p class="mt-1 text-center text-gray-600 max-w-xs">
                        Dịch vụ tận tâm — đặt lịch nhanh, chăm sóc chu đáo cho bé cưng của bạn.
                    </p>

                    <div class="mt-6 flex flex-col gap-3">
                        <div class="flex items-center gap-3 bg-white rounded-xl px-3 py-2 shadow-sm">
                            <i class="fa-solid fa-shield-halved text-sky-500"></i>
                            <div class="text-sm">
                                <p class="font-semibold text-sky-700">An toàn</p>
                                <p class="text-xs text-gray-500">Trang thiết bị vệ sinh</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-3 bg-white rounded-xl px-3 py-2 shadow-sm">
                            <i class="fa-solid fa-clock text-cyan-500"></i>
                            <div class="text-sm">
                                <p class="font-semibold text-sky-700">Nhanh chóng</p>
                                <p class="text-xs text-gray-500">Đặt lịch dễ dàng</p>
                            </div>
                        </div>
                    </div>
                </aside>

                <!-- Right: Login Form -->
                <main class="p-6 md:p-10">
                    <div class="flex flex-col items-center mb-6 md:mb-8">
                        <div class="w-16 h-16 rounded-full bg-gradient-to-br from-sky-100 to-cyan-100 flex items-center justify-center shadow-md mb-3 animate-[float_4s_ease-in-out_infinite]">
                            <img src="assets/img/logo.jpg" alt="Logo" class="w-12 h-12 rounded-full object-cover" />
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800">Đăng nhập</h2>
                        <p class="text-sm text-gray-500 mt-1 text-center">Đăng nhập để đặt lịch và quản lý hồ sơ thú cưng của bạn</p>
                    </div>

                    <!-- Keep browser validation (required) and server-side logic -->
                    <form id="loginForm" action="${pageContext.request.contextPath}/login?view=login" method="POST" class="space-y-4" autocomplete="on">
                        <!-- Username -->
                        <label class="relative block">
                            <span class="sr-only">Tên đăng nhập</span>
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400 z-10 pointer-events-none">
                                <i class="fa-solid fa-user"></i>
                            </span>
                            <input
                                id="username"
                                name="username"
                                type="text"
                                placeholder="Tên đăng nhập"
                                required
                                class="w-full pl-12 pr-4 py-3 border border-sky-100 rounded-lg bg-white text-gray-700 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-300 transition"
                                aria-label="Tên đăng nhập"
                                autocomplete="username"
                                autofocus
                                />
                        </label>

                        <!-- Password with toggle (keeps toggle, no icon disappearing) -->
                        <label class="relative block">
                            <span class="sr-only">Mật khẩu</span>
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400 z-10 pointer-events-none">
                                <i class="fa-solid fa-lock"></i>
                            </span>
                            <input
                                id="password"
                                name="password"
                                type="password"
                                placeholder="Mật khẩu"
                                required
                                class="w-full pl-12 pr-12 py-3 border border-sky-100 rounded-lg bg-white text-gray-700 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sky-300 transition"
                                aria-label="Mật khẩu"
                                autocomplete="current-password"
                                />
                            <!-- Toggle button: z-20 so always above input; pointer-events-auto to be clickable -->
                            <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-500 z-20" aria-label="Hiển thị mật khẩu" aria-pressed="false">
                                <i id="toggleIcon" class="fa-regular fa-eye"></i>
                            </button>
                        </label>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <input id="remember" name="remember" type="checkbox" class="h-4 w-4 text-sky-600 focus:ring-sky-500 border-gray-300 rounded" />
                                <label for="remember" class="text-sm text-gray-600">Ghi nhớ đăng nhập</label>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="text-sm text-sky-600 hover:text-sky-700">Quên mật khẩu?</a>
                            </div>
                        </div>

                        <button type="submit" class="w-full inline-flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-sky-500 to-cyan-500 text-white rounded-lg font-semibold shadow hover:from-sky-600 hover:to-cyan-600 transform hover:-translate-y-0.5 transition">
                            <i class="fa-solid fa-right-to-bracket"></i>
                            <span>Đăng nhập</span>
                        </button>
                    </form>

                    <!-- Divider -->
                    <div class="flex items-center gap-3 my-6">
                        <hr class="flex-grow border-gray-200" />
                        <span class="text-sm text-gray-400">hoặc</span>
                        <hr class="flex-grow border-gray-200" />
                    </div>

                    <!-- Social logins -->
                    <div class="flex justify-center gap-4">
                        <a href="#"
                           class="flex items-center justify-center w-12 h-12 rounded-full border border-gray-200 bg-white shadow-sm hover:shadow-md transition transform hover:-translate-y-0.5"
                           aria-label="Login with Google" title="Đăng nhập với Google">
                            <i class="fa-brands fa-google text-red-500"></i>
                        </a>
                        <a href="#"
                           class="flex items-center justify-center w-12 h-12 rounded-full bg-sky-600 border border-sky-600 text-white shadow-sm hover:bg-sky-700 transition transform hover:-translate-y-0.5"
                           aria-label="Login with Facebook" title="Đăng nhập với Facebook">
                            <i class="fa-brands fa-facebook-f"></i>
                        </a>
                        <a href="#"
                           class="flex items-center justify-center w-12 h-12 rounded-full bg-cyan-600 border border-cyan-600 text-white shadow-sm hover:bg-cyan-700 transition transform hover:-translate-y-0.5"
                           aria-label="Login with Apple" title="Đăng nhập với Apple">
                            <i class="fa-brands fa-apple"></i>
                        </a>
                    </div>

                    <p class="mt-6 text-center text-sm text-gray-600">
                        Chưa có tài khoản?
                        <a href="register.html" class="text-sky-600 font-medium hover:underline"> Đăng ký ngay</a>
                    </p>
                </main>
            </div>

            <!-- Minimal inline script: only toggle password visibility; no other JS -->
            <script>
                (function () {
                    const toggleBtn = document.getElementById('togglePassword');
                    const pwd = document.getElementById('password');
                    const toggleIcon = document.getElementById('toggleIcon');

                    if (toggleBtn && pwd && toggleIcon) {
                        toggleBtn.addEventListener('click', () => {
                            const isPwd = pwd.getAttribute('type') === 'password';
                            pwd.setAttribute('type', isPwd ? 'text' : 'password');
                            // toggle icon
                            toggleIcon.classList.toggle('fa-eye');
                            toggleIcon.classList.toggle('fa-eye-slash');
                            toggleBtn.setAttribute('aria-pressed', isPwd ? 'true' : 'false');
                        });
                    }
                })();
            </script>
        </section>
        <%@include file="/WEB-INF/toast/loginFail.jsp" %>
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
