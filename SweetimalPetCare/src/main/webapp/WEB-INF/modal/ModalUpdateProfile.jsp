<%-- 
    Document   : ModalUpdateProfile
    Created on : Nov 16, 2025, 12:09:23 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div id="modal-update-profile" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg p-6 m-4">
        <div class="flex items-center justify-between mb-4">
            <h4 class="text-lg font-semibold text-slate-800">Cập nhật thông tin</h4>
            <button type="button" data-modal-close="modal-update-profile" class="text-slate-400 hover:text-slate-600">&times;</button>
        </div>
        
        <%-- Form này sẽ được gửi bằng AJAX --%>
        <form id="form-update-profile" 
              action="${pageContext.request.contextPath}/profile" <%-- URL của Servlet --%>
              data-action="updateProfile"> <%-- Action cho Servlet biết --%>
            
            <div class="space-y-4">
                <div>
                    <label for="prof_fullName" class="block text-sm font-medium text-slate-700 mb-1">Họ và tên</label>
                    <%-- Dùng JSTL để điền sẵn giá trị --%>
                    <input type="text" id="prof_fullName" name="fullName" value="${profile.fullName}"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div>
                    <label for="prof_phone" class="block text-sm font-medium text-slate-700 mb-1">Số điện thoại</label>
                    <input type="tel" id="prof_phone" name="phone" value="${profile.phone}"
                           class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label for="prof_gender" class="block text-sm font-medium text-slate-700 mb-1">Giới tính</label>
                        <select id="prof_gender" name="gender" class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm bg-white">
                            <%-- Giả sử 1=Nam, 2=Nữ, 0=Khác (Dựa trên DAO) --%>
                            <option value="1" ${profile.genderDisplay == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="2" ${profile.genderDisplay == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="0" ${profile.genderDisplay == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    <div>
                        <label for="prof_birthday" class="block text-sm font-medium text-slate-700 mb-1">Ngày sinh (dd/MM/yyyy)</label>
                        <%-- Chú ý: input type="date" yêu cầu định dạng yyyy-MM-dd --%>
                        <%-- Chúng ta cần chuyển đổi từ 'dd/MM/yyyy' của DTO sang 'yyyy-MM-dd' --%>
                        <fmt:parseDate value="${profile.birthdayFormatted}" pattern="dd/MM/yyyy" var="parsedBirthday"/>
                        <fmt:formatDate value="${parsedBirthday}" pattern="yyyy-MM-dd" var="isoBirthday"/>
                        <input type="date" id="prof_birthday" name="birthday_iso" value="${isoBirthday}"
                               class="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm" required>
                        <%-- Chúng ta sẽ dùng JS để chuyển đổi yyyy-MM-dd về dd/MM/yyyy trước khi gửi --%>
                        <input type="hidden" name="birthday">
                    </div>
                </div>
            </div>
            
            <div class="mt-6 flex justify-end gap-3">
                <button type_button" data-modal-close="modal-update-profile" 
                        class="px-4 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">Hủy</button>
                <button type="submit" 
                        class="px-4 py-2 bg-sky-600 text-white rounded-lg text-sm hover:bg-sky-700">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>