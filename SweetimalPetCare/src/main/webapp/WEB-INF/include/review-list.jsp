<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="bg-white rounded-lg shadow">
    <div class="px-6 py-4 border-b">
        <h2 class="text-xl font-semibold text-gray-900">Tất cả đánh giá</h2>
    </div>
    <div class="p-4 space-y-4">
        <c:choose>
            <c:when test="${empty reviews}">
                <div class="p-6 text-gray-600">Chưa có đánh giá nào cho dịch vụ này.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${reviews}">
                    <div class="p-5 bg-gray-50 border border-gray-200 rounded-lg shadow-sm">
                        <div>
                            <div class="flex items-center justify-between">
                                <div class="font-semibold text-gray-900">${r.customerName}</div>
                                <div class="text-sm text-gray-500">
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                            <div class="flex text-yellow-400 my-1">
                                <c:forEach var="i" begin="1" end="5">
                                    <i class="fa${i <= r.rating ? 's' : 'r'} fa-star mr-1"></i>
                                </c:forEach>
                            </div>
                            <c:choose>
                                <c:when test="${not empty editIdLong and editIdLong == r.reviewId and not empty user and user.id == r.customerId}">
                                    <form method="post" action="${pageContext.request.contextPath}/service-reviews" class="space-y-3 mt-2">
                                        <input type="hidden" name="action" value="update" />
                                        <input type="hidden" name="serviceId" value="${service.id}" />
                                        <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">Chỉnh số sao</label>
                                            <div class="flex items-center space-x-2 js-stars">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <label class="cursor-pointer">
                                                        <input type="radio" name="rating" value="${i}" class="hidden" ${i == r.rating ? 'checked' : ''} />
                                                        <i class="${i <= r.rating ? 'fa-solid' : 'fa-regular'} fa-star text-2xl text-yellow-400 hover:scale-110"></i>
                                                    </label>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div>
                                            <textarea name="comment" rows="3" maxlength="1000" class="w-full border rounded p-3 focus:outline-none focus:ring focus:border-blue-300">${fn:replace(fn:replace(r.comment, ' (đã chỉnh sửa)', ''), '(đã chỉnh sửa)', '')}</textarea>
                                            <div class="text-sm text-gray-500 mt-1">Tối đa 1000 ký tự</div>
                                        </div>
                                        <div class="space-x-2">
                                            <button type="submit" class="px-4 py-2 rounded bg-blue-600 text-white">Lưu</button>
                                            <a href="${pageContext.request.contextPath}/service-reviews?serviceId=${service.id}" class="px-4 py-2 rounded border">Hủy</a>
                                        </div>
                                    </form>
                                    <script>
                                        // toggle stars for the inline edit form (scoped by reviewId)
                                        (function() {
                                            var form = document.currentScript.previousElementSibling;
                                            if (!form) return;
                                            var box = form.querySelector('.js-stars');
                                            if (!box) return;
                                            var labels = box.querySelectorAll('label');
                                            var icons = box.querySelectorAll('label i');
                                            function setStars(n){
                                                icons.forEach(function(ic, idx){
                                                    ic.classList.remove('fa-solid'); ic.classList.add('fa-regular');
                                                    if (idx < n) { ic.classList.remove('fa-regular'); ic.classList.add('fa-solid'); }
                                                });
                                            }
                                            labels.forEach(function(label, idx){
                                                label.addEventListener('click', function(){
                                                    var input = label.querySelector("input[name='rating']");
                                                    var val = input ? parseInt(input.value, 10) : (idx+1);
                                                    if (input) { input.checked = true; }
                                                    setStars(val);
                                                });
                                            });
                                        })();
                                    </script>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-gray-800 whitespace-pre-line">
                                        ${fn:replace(fn:replace(r.comment, ' (đã chỉnh sửa)', ''), '(đã chỉnh sửa)', '')}
                                        <c:if test="${fn:contains(r.comment,'đã chỉnh sửa')}">
                                            <span class="ml-2 text-xs text-gray-500 italic">đã chỉnh sửa</span>
                                        </c:if>
                                    </div>
                                    <!-- Staff/Admin/Vet reply section -->
                                    <c:set var="reply" value="${repliesMap[r.reviewId]}" />
                                    <c:if test="${not empty reply}">
                                        <div class="mt-3 p-3 border border-gray-200 bg-gray-50 rounded">
                                            <div class="text-sm text-gray-600 font-medium">Phản hồi từ nhân viên</div>
                                            <div class="mt-1 text-gray-800 whitespace-pre-line">${reply.replyContent}</div>
                                            <div class="text-xs text-gray-500 mt-1"><fmt:formatDate value="${reply.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                            <c:if test="${not empty user and user.role != 1}">
                                                <c:if test="${empty replyEditReviewIdLong or replyEditReviewIdLong != r.reviewId}">
                                                    <div class="mt-2 space-x-2">
                                                        <a href="${pageContext.request.contextPath}/service-reviews?serviceId=${service.id}&replyEditReviewId=${r.reviewId}" class="px-3 py-1 bg-green-600 text-white rounded inline-block">Cập nhật</a>
                                                        <form method="post" action="${pageContext.request.contextPath}/service-reviews" style="display:inline" onsubmit="return confirm('Xóa phản hồi này?');">
                                                            <input type="hidden" name="serviceId" value="${service.id}" />
                                                            <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                            <button type="submit" name="action" value="replyDelete" class="px-3 py-1 bg-red-600 text-white rounded">Xóa</button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty replyEditReviewIdLong and replyEditReviewIdLong == r.reviewId}">
                                                    <form method="post" action="${pageContext.request.contextPath}/service-reviews" class="mt-3 space-y-2">
                                                        <input type="hidden" name="serviceId" value="${service.id}" />
                                                        <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                        <textarea name="replyContent" rows="2" maxlength="1000" class="w-full border rounded p-2">${reply.replyContent}</textarea>
                                                        <div class="space-x-2">
                                                            <button type="submit" name="action" value="replyUpdate" class="px-3 py-1 bg-blue-600 text-white rounded">Lưu thay đổi</button>
                                                            <a href="${pageContext.request.contextPath}/service-reviews?serviceId=${service.id}" class="px-3 py-1 bg-gray-300 rounded">Hủy</a>
                                                        </div>
                                                    </form>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty reply and not empty user and user.role != 1}">
                                        <div class="mt-3 p-3 border border-gray-200 rounded bg-white">
                                            <form method="post" action="${pageContext.request.contextPath}/service-reviews" class="space-y-2">
                                                <input type="hidden" name="serviceId" value="${service.id}" />
                                                <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                <label class="text-sm text-gray-600">Phản hồi của bạn</label>
                                                <textarea name="replyContent" rows="2" maxlength="1000" class="w-full border rounded p-2" placeholder="Nhập phản hồi..."></textarea>
                                                <button type="submit" name="action" value="replyCreate" class="px-3 py-1 bg-blue-600 text-white rounded">Gửi phản hồi</button>
                                            </form>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty user and (user.id == r.customerId || user.role != 1)}">
                                        <div class="mt-2 space-x-2">
                                            <c:if test="${user.id == r.customerId}">
                                                <a class="text-blue-600 hover:underline" href="${pageContext.request.contextPath}/service-reviews?serviceId=${service.id}&editId=${r.reviewId}">Chỉnh sửa</a>
                                            </c:if>
                                            <form method="post" action="${pageContext.request.contextPath}/service-reviews" style="display:inline" onsubmit="return confirm('Xóa đánh giá này?');">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="serviceId" value="${service.id}" />
                                                <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                                <button type="submit" class="text-red-600 hover:underline">Xóa</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
