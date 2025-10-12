<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <script src="https://cdn.tailwindcss.com"></script>
        <title>Thêm thú cưng</title>
    </head>
    <body class="bg-gray-100 text-gray-800 min-h-screen">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="min-h-screen flex flex-col items-center justify-center">
            <form action="pets" method="get"
                  class="bg-white shadow-lg rounded-xl p-8 space-y-6 max-w-lg w-full">
                <h2 class="text-2xl font-bold mb-6 text-blue-700 text-center">Thêm thú cưng</h2>

                <!-- Loài -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Loài</label>
                    <select name="speciesId" class="w-full border rounded px-3 py-2" onchange="this.form.submit()" required>
                        <option value="">-- Chọn loài --</option>
                        <c:forEach var="s" items="${speciesList}">
                            <option value="${s.id}" ${param.speciesId == s.id ? 'selected' : ''}>
                                ${s.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Giống -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Giống</label>
                    <select name="breedId" class="w-full border rounded px-3 py-2">
                        <option value="">-- Chọn giống --</option>
                        <c:forEach var="b" items="${breedList}">
                            <option value="${b.id}">${b.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </form>

                        <!-- Second form for actual add -->
                        <form action="pets" method="post"
                                    class="bg-white shadow-lg rounded-xl p-8 space-y-6 max-w-lg w-full mt-4">
                                <input type="hidden" name="action" value="add"/>
                                <input type="hidden" name="speciesId" value="${param.speciesId}"/>
                                <!-- persist selected breed from the GET form so POST includes it -->
                                <input type="hidden" name="breedId" value="${param.breedId}"/>

                <!-- Other fields -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tên</label>
                    <input type="text" name="name" required
                           class="w-full border rounded px-3 py-2 focus:ring focus:ring-blue-200"/>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                    <input type="text" name="color" class="w-full border rounded px-3 py-2"/>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ngày sinh</label>
                    <input type="date" name="birthdate" class="w-full border rounded px-3 py-2"/>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Giới tính</label>
                    <select name="gender" class="w-full border rounded px-3 py-2">
                        <option value="">-- Chọn giới tính --</option>
                        <option value="M">Đực</option>
                        <option value="F">Cái</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Cân nặng (kg)</label>
                    <input type="number" step="0.1" name="weightKg"
                           class="w-full border rounded px-3 py-2"/>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                    <textarea name="notes" class="w-full border rounded px-3 py-2"></textarea>
                </div>

                <button type="submit"
                        class="w-full bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700">
                    Thêm thú cưng
                </button>
            </form>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
