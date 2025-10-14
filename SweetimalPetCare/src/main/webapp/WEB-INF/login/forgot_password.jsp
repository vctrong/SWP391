<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-gray-100">
    <main class="flex justify-center items-center h-screen">
      <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4 text-center">Quên mật khẩu</h1>
        <% String error = (String) request.getAttribute("error"); String message = (String) request.getAttribute("message"); %>
        <% if (error != null) { %>
          <div class="mb-4 p-3 bg-red-100 text-red-700 rounded"><%= error %></div>
        <% } %>
        <% if (message != null) { %>
          <div class="mb-4 p-3 bg-green-100 text-green-700 rounded"><%= message %></div>
        <% } %>
        <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="space-y-4">
          <div>
            <label class="block mb-1">Email</label>
            <input type="email" name="email" required class="w-full border rounded px-3 py-2" placeholder="you@example.com" />
          </div>
          <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded">Gửi OTP</button>
        </form>
        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/login?view=login" class="text-blue-600 hover:underline">Quay lại đăng nhập</a>
        </div>
      </div>
    </main>
  </body>
  </html>
