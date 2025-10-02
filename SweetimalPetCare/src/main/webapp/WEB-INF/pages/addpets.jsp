<%--
    Document   : addpets
    Created on : Oct 2, 2025, 10:39:16 AM
    Author     : Lim Thế Toàn - CE190616
--%>

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
            <form action="pets" method="post"
                  class="bg-white shadow-lg rounded-xl p-8 space-y-6 max-w-lg w-full">
                <h2 class="text-2xl font-bold mb-6 text-blue-700 text-center">Thêm thú cưng</h2>
                <input type="hidden" name="action" value="add"/>

                <!-- Tên -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tên</label>
                    <input type="text" name="name" required
                           class="w-full border rounded px-3 py-2 focus:ring focus:ring-blue-200"/>
                </div>

                <!-- Loài -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Loài</label>
                    <select name="speciesId" class="w-full border rounded px-3 py-2" required>
                        <c:forEach var="s" items="${speciesList}">
                            <option value="${s.id}">${s.name}</option>
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

                <!-- Màu -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                    <input type="text" name="color"
                           class="w-full border rounded px-3 py-2"/>
                </div>

                <!-- Ngày sinh -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ngày sinh</label>
                    <input type="date" name="birthdate"
                           class="w-full border rounded px-3 py-2"/>
                </div>

                <!-- Giới tính -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Giới tính</label>
                    <select name="gender" class="w-full border rounded px-3 py-2">
                        <option value="">-- Chọn giới tính --</option>
                        <option value="M" <c:if test="${pet.gender == 'M'}">selected</c:if>>Đực</option>
                        <option value="F" <c:if test="${pet.gender == 'F'}">selected</c:if>>Cái</option>
                        </select>
                    </div>

                    <!-- Cân nặng -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Cân nặng (kg)</label>
                        <input type="number" step="0.1" name="weightKg"
                               class="w-full border rounded px-3 py-2"/>
                    </div>

                    <!-- Ghi chú -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                        <textarea name="notes"
                                  class="w-full border rounded px-3 py-2"></textarea>
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
