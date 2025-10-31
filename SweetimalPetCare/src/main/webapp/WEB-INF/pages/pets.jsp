<%--
    Document   : pet
    Created on : Oct 2, 2025, 8:54:24 AM
    Author     : Lim Thế Toàn - CE190616
--%>

<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="/WEB-INF/include/library.jsp" %>
        <title>Quản lý thú cưng</title>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="container mx-auto px-6 py-24">

            <!-- Danh sách thú cưng -->
            <section class="mb-12">
                <div class="flex justify-center">
                    <div class="inline-block bg-blue-50 shadow-md px-4 py-2 rounded-lg">
                        <h2 class="text-2xl font-bold text-blue-700 text-center m-0">Danh sách thú cưng</h2>
                    </div>
                </div>

                <a href="pets?action=add"
                   class="inline-block mt-6 bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700">
                    + Thêm thú cưng
                </a>
                <div class="overflow-x-auto bg-white shadow rounded-lg">
                    <table class="min-w-full border border-gray-200">
                        <thead class="bg-blue-600 text-white">
                            <tr>
                                <th class="px-4 py-3 text-left">Tên</th>
                                <th class="px-4 py-3 text-left">Loài</th>
                                <th class="px-4 py-3 text-left">Màu</th>
                                <th class="px-4 py-3 text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="p" items="${pets}">
                                <tr class="hover:bg-gray-50">
                                    <td class="px-4 py-3">${p.name}</td>
                                    <td class="px-4 py-3">
                                        <c:forEach var="s" items="${speciesList}">
                                            <c:if test="${s.id == p.speciesId}">
                                                ${s.name}
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td class="px-4 py-3">${p.color}</td>
                                    <td class="px-4 py-3 text-center space-x-2">
                                        <!-- Nút sửa -->
                                        <form action="pets" method="get" class="inline">
                                            <input type="hidden" name="action" value="edit"/>
                                            <input type="hidden" name="petId" value="${p.id}"/>
                                            <button type="submit"
                                                    class="px-3 py-1 bg-yellow-500 text-white rounded hover:bg-yellow-600">
                                                Sửa
                                            </button>
                                        </form>

                                        <!-- Nút xóa -->
                                        <form action="pets" method="post" class="inline" onsubmit="return confirmDelete(this);">
                                            <input type="hidden" name="petId" value="${p.id}"/>
                                            <button type="submit" name="action" value="delete"
                                                    class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">
                                                Xóa
                                            </button>
                                        </form>
                                    </td>

                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                </div>
            </section>
        </main>

        <script>
            // confirm delete with pet name from the same row
            function confirmDelete(form) {
                try {
                    var tr = form.closest('tr');
                    var nameCell = tr ? tr.querySelector('td') : null;
                    var petName = nameCell ? nameCell.textContent.trim() : '';
                    if (!petName) petName = 'thú cưng này';
                    return confirm('Bạn có chắc muốn xóa ' + petName + ' không?');
                } catch (e) {
                    return confirm('Bạn có chắc muốn xóa thú cưng này không?');
                }
            }
        </script>
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>

