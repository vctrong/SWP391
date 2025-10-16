<%--
    Document   : editpets
    Created on : Oct 2, 2025, 9:51:08 AM
    Author     : Lim Thế Toàn - CE190616
--%>

<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <title>Sửa thú cưng</title>
    </head>
    <body class="bg-gray-100 text-gray-800 min-h-screen">
        <%@include file="/WEB-INF/include/header.jsp" %>

        <main class="min-h-screen flex flex-col items-center justify-center">
                        <form id="editPetForm" action="pets" method="post"
                                    class="bg-white shadow-lg rounded-xl p-8 space-y-6 max-w-lg w-full">
                                <h2 class="text-2xl font-bold mb-6 text-blue-700 text-center">Chỉnh sửa thú cưng</h2>
                                <!-- default hidden action is 'edit' for auto-submits (species change); submit button will set to 'update' -->
                                <input type="hidden" id="formAction" name="action" value="edit"/>
                                <input type="hidden" name="petId" value="${pet.id}"/>

                <!-- Tên -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tên</label>
                    <input type="text" name="name" value="${pet.name}" required
                           class="w-full border rounded px-3 py-2 focus:ring focus:ring-blue-200"/>
                </div>

                <!-- Loài -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Loài</label>
            <select name="speciesId"
                class="w-full border rounded px-3 py-2"
                            onchange="preserveAndSubmit(this.form)"
                required>
                        <c:forEach var="s" items="${speciesList}">
                            <option value="${s.id}" <c:if test="${s.id == pet.speciesId}">selected</c:if>>
                                ${s.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Hidden inputs are created dynamically by JS before auto-submitting to preserve current values -->


                <!-- Giống -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Giống</label>
                    <select name="breedId" class="w-full border rounded px-3 py-2">
                        <option value="">-- Chọn giống --</option>
                        <c:forEach var="b" items="${breedList}">
                            <option value="${b.id}" <c:if test="${b.id == pet.breedId}">selected</c:if>>
                                ${b.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Màu -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Màu sắc</label>
                    <input type="text" name="color" value="${pet.color}"
                           class="w-full border rounded px-3 py-2"/>
                </div>

                <!-- Ngày sinh -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ngày sinh</label>
                    <input type="date" name="birthdate" value="${pet.birthDate}"
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
                        <input type="number" step="0.1" name="weightKg" value="${pet.weightKg}"
                           class="w-full border rounded px-3 py-2"/>
                </div>

                <!-- Ghi chú -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                    <textarea name="notes"
                              class="w-full border rounded px-3 py-2">${pet.notes}</textarea>
                </div>

                <button type="submit" onclick="document.getElementById('formAction').value='update';"
                        class="w-full bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
                    Lưu thay đổi
                </button>
            </form>
        </main>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
    <script>
        // copy visible form values into hidden inputs before auto-submit so data persists
        function preserveAndSubmit(form) {
            const fields = ['name','gender','birthdate','color','weightKg','notes','petId'];
            fields.forEach(function(n){
                let el = form.querySelector('[name="'+n+'"]');
                // create or update hidden input
                let hidden = form.querySelector('input[type=hidden][name="'+n+'"]');
                if (!hidden) {
                    hidden = document.createElement('input');
                    hidden.type = 'hidden';
                    hidden.name = n;
                    form.appendChild(hidden);
                }
                hidden.value = (el && (el.value !== undefined)) ? el.value : '';
            });
            // ensure action is 'edit' for the GET reload
            document.getElementById('formAction').value = 'edit';
            form.method = 'get';
            form.submit();
        }
        // attach to the species select onchange inline call.
    </script>
</html>

