<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="bg-white rounded-lg shadow">
    <div class="px-6 py-4 border-b">
        <h2 class="text-xl font-semibold text-gray-900">Gửi đánh giá của bạn</h2>
    </div>

    <div class="p-6">
        <c:choose>
            <c:when test="${empty user}">
                <div class="p-4 bg-yellow-50 text-yellow-800 rounded">
                    Vui lòng <a href="${pageContext.request.contextPath}/login" class="text-blue-600 underline">đăng nhập</a> để đánh giá.
                </div>
            </c:when>
            <c:when test="${not hasUsedService}">
                <div class="p-4 bg-gray-50 text-gray-700 rounded">
                    Bạn chỉ có thể đánh giá sau khi đã hoàn tất sử dụng dịch vụ này.
                </div>
            </c:when>
            <c:otherwise>
                <form id="createReviewForm" method="post" action="${pageContext.request.contextPath}/service-reviews" class="space-y-4">
                    <input type="hidden" name="serviceId" value="${service.id}" />
                    <input type="hidden" name="action" value="create" />
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Chọn số sao</label>
                        <div class="flex items-center space-x-2 js-stars">
                            <c:forEach var="i" begin="1" end="5">
                                <label class="cursor-pointer">
                                    <input type="radio" name="rating" value="${i}" class="hidden" ${i == prevRating ? 'checked' : ''} />
                                    <i class="fa-regular fa-star text-2xl text-yellow-400 hover:scale-110"></i>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                    <div>
                        <label for="comment" class="block text-sm font-medium text-gray-700 mb-1">Nhận xét</label>
                        <textarea id="comment" name="comment" rows="4" maxlength="1000"
                                  class="w-full border rounded p-3 focus:outline-none focus:ring focus:border-blue-300"
                                  placeholder="Chia sẻ trải nghiệm của bạn...">${prevComment}</textarea>
                        <div class="text-sm text-gray-500 mt-1">Tối đa 1000 ký tự</div>
                    </div>
                    <div>
                        <button type="submit" class="px-5 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white font-semibold">Gửi đánh giá</button>
                    </div>
                </form>
                <script>
                    // Simple star interaction: toggle solid when selected (scoped to create form)
                    document.addEventListener('DOMContentLoaded', function() {
                        const form = document.getElementById('createReviewForm');
                        if (!form) return;
                        const box = form.querySelector('.js-stars');
                        if (!box) return;
                        const labels = box.querySelectorAll('label');
                        const icons = box.querySelectorAll('label i');
                        function setStars(n) {
                            icons.forEach((ic, idx) => {
                                ic.classList.remove('fa-solid');
                                ic.classList.add('fa-regular');
                                if (idx < n) { ic.classList.remove('fa-regular'); ic.classList.add('fa-solid'); }
                            });
                        }
                        labels.forEach((label) => {
                            label.addEventListener('click', () => {
                                const input = label.querySelector("input[name='rating']");
                                if (input) {
                                    input.checked = true;
                                    const val = parseInt(input.value, 10) || 0;
                                    setStars(val);
                                }
                            });
                        });
                        // Preselect when server returns previous rating
                        const preChecked = box.querySelector("input[name='rating']:checked");
                        if (preChecked) {
                            const val = parseInt(preChecked.value, 10) || 0;
                            if (val > 0) setStars(val);
                        }
                    });
                </script>
            </c:otherwise>
        </c:choose>
    </div>
</div>
