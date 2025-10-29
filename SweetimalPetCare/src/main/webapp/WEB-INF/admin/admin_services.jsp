<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý dịch vụ</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body class="bg-gray-50 text-gray-800">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="max-w-5xl mx-auto py-10">
            <div class="px-6">
                <h2 class="text-2xl font-bold text-blue-700 mb-6">Quản lý dịch vụ</h2>

                <section class="bg-white p-6 rounded shadow mb-6">
                <h3 class="font-semibold mb-3">Thêm dịch vụ mới</h3>
                <form method="post" action="${pageContext.request.contextPath}/admin/services" class="grid grid-cols-2 gap-3">
                    <input type="hidden" name="action" value="create" />
                    <input name="serviceCode" placeholder="Mã dịch vụ" class="border p-2" required />
                    <input name="name" placeholder="Tên dịch vụ" class="border p-2" required />
                    <input name="duration" placeholder="Thời lượng (phút)" class="border p-2" required />
                    <input name="price" placeholder="Giá" class="border p-2" required />
                    <textarea name="description" placeholder="Mô tả" class="border p-2 col-span-2"></textarea>
                    <div class="col-span-2 text-right">
                        <button class="bg-green-600 text-white px-4 py-2 rounded">Tạo</button>
                    </div>
                </form>
            </section>

                <section class="bg-white p-6 rounded shadow">
                <h3 class="font-semibold mb-3">Danh sách dịch vụ</h3>
                <table class="min-w-full">
                    <thead class="bg-blue-600 text-white"><tr><th class="p-2">ID</th><th class="p-2">Tên</th><th class="p-2">Mô tả</th><th class="p-2">Thời lượng</th><th class="p-2">Giá</th><th class="p-2">Hành động</th></tr></thead>
                    <tbody>
                        <c:forEach var="s" items="${services}">
                            <tr class="border-b">
                                <td class="p-2">${s.id}</td>
                                <td class="p-2">${s.name}</td>
                                <td class="p-2">${s.description}</td>
                                <td class="p-2">${s.durationMin}</td>
                                <td class="p-2">${s.price}</td>
                                <td class="p-2">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/services" style="display:inline-block">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="serviceId" value="${s.id}" />
                                        <button class="px-2 py-1 bg-red-500 text-white rounded" onclick="return confirm('Xác nhận ẩn dịch vụ này?');">Xóa</button>
                                    </form>
                                    <button class="px-2 py-1 bg-yellow-500 text-white rounded ml-2" 
                                            data-id="${s.id}"
                                            data-name="${fn:escapeXml(s.name)}"
                                            data-desc="${fn:escapeXml(s.description)}"
                                            data-duration="${s.durationMin}"
                                            data-price="${s.price}"
                                            onclick="openEditFromButton(this)">Sửa</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </section>

            </div>
            <!-- Edit modal (simple) -->
            <div id="editModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center">
                <div class="bg-white p-6 rounded w-96">
                    <h4 class="font-semibold mb-3">Sửa dịch vụ</h4>
                    <form id="editForm" method="post" action="${pageContext.request.contextPath}/admin/services">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" id="editServiceId" name="serviceId" />
                        <input id="editName" name="name" class="border p-2 w-full mb-2" />
                        <input id="editDuration" name="duration" class="border p-2 w-full mb-2" />
                        <input id="editPrice" name="price" class="border p-2 w-full mb-2" />
                        <textarea id="editDesc" name="description" class="border p-2 w-full mb-2"></textarea>
                        <div class="text-right">
                            <button type="button" onclick="closeEdit()" class="px-3 py-1 border mr-2">Hủy</button>
                            <button class="px-3 py-1 bg-blue-600 text-white rounded">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>

        <script>
            function openEdit(id, name, desc, duration, price) {
                document.getElementById('editServiceId').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editDesc').value = desc;
                document.getElementById('editDuration').value = duration;
                document.getElementById('editPrice').value = price;
                document.getElementById('editModal').classList.remove('hidden');
                document.getElementById('editModal').classList.add('flex');
            }

            function openEditFromButton(btn) {
                var id = btn.getAttribute('data-id');
                var name = btn.getAttribute('data-name') || '';
                var desc = btn.getAttribute('data-desc') || '';
                var duration = btn.getAttribute('data-duration') || '';
                var price = btn.getAttribute('data-price') || '';
                // decode HTML entities if necessary
                var parser = new DOMParser();
                try {
                    var decodedName = parser.parseFromString(name, 'text/html').documentElement.textContent;
                    var decodedDesc = parser.parseFromString(desc, 'text/html').documentElement.textContent;
                    name = decodedName;
                    desc = decodedDesc;
                } catch (e) {
                    // ignore
                }
                openEdit(id, name, desc, duration, price);
            }
            function closeEdit() {
                document.getElementById('editModal').classList.add('hidden');
                document.getElementById('editModal').classList.remove('flex');
            }
        </script>
    </body>
</html>
