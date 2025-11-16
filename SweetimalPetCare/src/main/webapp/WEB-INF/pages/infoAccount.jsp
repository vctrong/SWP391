<%-- 
    Document   : infoAccount
    Created on : Nov 16, 2025, 5:48:44 AM
    Author     : Vo Chi Trong - CE191062
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
    </head>
    <body class="bg-gray-100 font-sans min-h-screen">
        <%@include file="/WEB-INF/include/headerProfileUser.jsp" %>
        <div class="max-w-7xl mx-auto py-8 px-4 lg:flex lg:gap-6">
            <%@include file="/WEB-INF/include/sidebarProfileUser.jsp" %>
            <main class="w-full lg:w-3/4">
                <div class="space-y-6">

                    <div class="bg-white rounded-2xl shadow-md p-6 flex items-center justify-between">
                        <div>
                            <h3 class="text-xl font-semibold text-sky-600">Thông tin tài khoản</h3>
                            <p class="text-sm text-slate-500 mt-1">Quản lý thông tin cá nhân, địa chỉ giao hàng và bảo mật.</p>
                        </div>
                        <div class="flex items-center gap-3">
                            <button type="button" 
                                    class="px-4 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow"
                                    data-modal-target="modal-update-profile"> <%-- THÊM DÒNG NÀY --%>
                                <i class="fa-solid fa-pen mr-2"></i>Cập nhật
                            </button>
                            <button type="button" 
                                    class="px-4 py-2 bg-sky-600 text-white rounded-lg text-sm hover:bg-sky-700"
                                    data-modal-target="modal-change-password"> <%-- THÊM DÒNG NÀY --%>
                                <i class="fa-solid fa-key mr-2"></i>Thay đổi mật khẩu
                            </button>
                        </div>
                    </div>

                    <section class="bg-white rounded-2xl shadow-md p-6">
                        <div class="flex items-start justify-between gap-6">
                            <div class="flex items-center gap-4">
                                <%-- Dùng biến 'profile' từ request.setAttribute("profile", ...) --%>
                                <img src="${profile.avatarUrl}"
                                     alt="Avatar ${profile.fullName}"
                                     class="w-20 h-20 rounded-full border object-cover"/>
                                <div>
                                    <h4 class="text-lg font-semibold text-slate-800">${profile.fullName}</h4>
                                    <div class="text-sm text-slate-500">${profile.roleName} • ${profile.membershipDuration}</div>

                                    <div class="mt-3 flex flex-wrap gap-3 text-sm text-slate-600">
                                        <div class="flex items-center gap-2">
                                            <i class="fa-solid fa-phone text-slate-400"></i>
                                            <span>${profile.phone}</span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i class="fa-regular fa-envelope text-slate-400"></i>
                                            <span>${profile.email}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="flex flex-col items-end gap-3">
                                <div class="text-sm text-slate-500">Ngày tạo</div>
                                <div class="text-sm font-medium text-slate-800">${profile.createdAtFormatted}</div>
                                <a href="${pageContext.request.contextPath}/profile?tab=history" class="inline-flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow">
                                    <i class="fa-solid fa-box-open text-sky-600"></i>
                                    Xem đơn hàng
                                </a>
                            </div>
                        </div>

                        <div class="mt-6 grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-4">
                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Họ và tên</span>
                                    <span class="font-medium text-slate-800">${profile.fullName}</span>
                                </div>

                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Giới tính</span>
                                    <span class="font-medium text-slate-800">${profile.genderDisplay}</span>
                                </div>

                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Ngày sinh</span>
                                    <span class="font-medium text-slate-800">${profile.birthdayFormatted}</span>
                                </div>
                            </div>

                            <div class="space-y-4">
                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Số điện thoại</span>
                                    <span class="font-medium text-slate-800">${profile.phone}</span>
                                </div>

                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Email</span>
                                    <span class="font-medium text-slate-800">${profile.email}</span>
                                </div>

                                <div class="flex justify-between py-3 border-b border-slate-100">
                                    <span class="text-slate-600">Địa chỉ mặc định</span>
                                    <%-- Thêm text-right để không bị vỡ layout nếu địa chỉ quá dài --%>
                                    <span class="font-medium text-slate-800 text-right max-w-[250px] truncate">
                                        ${profile.defaultAddressSummary}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="bg-white rounded-2xl shadow-md p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-lg font-semibold text-slate-800">Sổ địa chỉ</h4>
                            <div class="flex items-center gap-2">
                                <button type="button" 
                                        class="px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow"
                                        data-modal-target="modal-add-address"> <%-- THÊM DÒNG NÀY --%>
                                    <i class="fa-solid fa-plus mr-2"></i>Thêm địa chỉ
                                </button>
                            </div>
                        </div>

                        <div class="space-y-4">
                            <%-- 
                              Bắt đầu vòng lặp JSTL.
                              Dùng biến 'addressList' từ request.setAttribute("addressList", ...) 
                            --%>
                            <c:forEach var="addr" items="${addressList}">
                                <%-- Dùng <c:choose> để thay đổi style cho địa chỉ mặc định --%>
                                <c:choose>
                                    <c:when test="${addr.isDefault}">
                                        <div class="p-4 bg-slate-50 rounded-xl flex items-start justify-between">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="p-4 bg-white rounded-xl flex items-start justify-between border border-slate-100">
                                            </c:otherwise>
                                        </c:choose>

                                        <div>
                                            <div class="font-medium">${addr.label} - ${addr.recipientName}</div>
                                            <div class="text-sm text-slate-600 mt-1">${addr.phone}</div>
                                            <div class="text-sm text-slate-600 mt-1">${addr.fullAddress}</div>
                                        </div>
                                        <div class="flex flex-col items-end gap-2">
                                            <%-- Chỉ hiển thị tag Mặc định nếu isDefault == true --%>
                                            <c:if test="${addr.isDefault}">
                                                <div class="text-xs text-emerald-700 bg-emerald-100 px-2 py-1 rounded-full">Mặc định</div>
                                            </c:if>
                                            <div class="flex items-center gap-2">
                                                <button type="button" class="text-sm text-sky-600 hover:underline">Sửa</button>
                                                <button type="button" class="text-sm text-red-600 hover:underline">Xóa</button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <%-- Hiển thị nếu không có địa chỉ nào --%>
                                <c:if test="${empty addressList}">
                                    <div class="p-4 text-center text-sm text-slate-500">
                                        Bạn chưa có địa chỉ nào trong sổ.
                                    </div>
                                </c:if>

                            </div>
                    </section>

                    <section class="bg-white rounded-2xl shadow-md p-6 w-full sm:w-2/3">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-lg font-semibold text-slate-800">Bảo mật & Mật khẩu</h4>
                            <div class="flex items-center gap-2">
                                <button type="button" 
                                        class="px-3 py-2 bg-white border border-slate-200 rounded-lg text-sm hover:shadow"
                                        data-modal-target="modal-change-password"> <%-- THÊM DÒNG NÀY --%>
                                    Thay đổi mật khẩu
                                </button>
                            </div>
                        </div>

                        <div class="flex flex-col gap-3">
                            <div class="flex justify-between items-center py-3 border-b border-slate-100">
                                <div>
                                    <div class="text-sm text-slate-600">Cập nhật lần cuối</div>
                                    <div class="font-medium text-slate-800">${profile.lastUpdatedAtFormatted}</div>
                                </div>

                                <div class="text-right">
                                    <div class="text-sm text-slate-600">2FA</div>
                                    <%-- Dùng <c:choose> để hiển thị Bật/Tắt 2FA (mặc định CSDL là Tắt) --%>
                                    <c:choose>
                                        <c:when test="${profile.is2faEnabled}">
                                            <div><span class="inline-block px-2 py-1 bg-emerald-100 text-emerald-700 rounded-lg text-xs">Bật</span></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div><span class="inline-block px-2 py-1 bg-slate-100 text-slate-700 rounded-lg text-xs">Tắt</span></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="text-sm text-slate-500">
                                Để bảo mật tài khoản, bạn nên thay đổi mật khẩu định kỳ và bật xác thực hai yếu tố (2FA).
                            </div>
                        </div>
                    </section>

                </div>
            </main>
        </div>

        <%@include file="/WEB-INF/modal/ModalAddAddress.jsp" %>
        <%@include file="/WEB-INF/modal/ModalChangePass.jsp" %>
        <%@include file="/WEB-INF/modal/ModalUpdateProfile.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/profileJs.js"></script>
    </body>
</html>
