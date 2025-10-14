<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lại mật khẩu</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-gray-100">
    <main class="flex justify-center items-center h-screen">
      <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4 text-center">Đặt lại mật khẩu</h1>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
          <div class="mb-4 p-3 bg-red-100 text-red-700 rounded"><%= error %></div>
        <% } %>
        <form action="${pageContext.request.contextPath}/reset-password" method="post" class="space-y-4">
          <div>
            <label class="block mb-1">Mật khẩu mới</label>
            <input type="password" name="password" required minlength="6" class="w-full border rounded px-3 py-2" />
          </div>
          <div>
            <label class="block mb-1">Xác nhận mật khẩu</label>
            <input type="password" name="confirmPassword" required minlength="6" class="w-full border rounded px-3 py-2" />
          </div>
          <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded">Cập nhật mật khẩu</button>
        </form>
      </div>
    </main>
  </body>
  </html>
