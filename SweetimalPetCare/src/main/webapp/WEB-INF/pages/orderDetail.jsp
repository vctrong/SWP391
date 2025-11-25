<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/include/library.jsp" %>
<%!
    // Pretty-print simple JSON-like attribute strings: {"weight":"1kg","color":"Red"}
    private String prettyAttributeFromJson(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim();
        if (s.startsWith("{") && s.endsWith("}")) {
            s = s.substring(1, s.length() - 1);
        }
        s = s.replaceAll("\"", "");
        String[] parts = s.split("\\s*,\\s*");
        java.util.List<String> out = new java.util.ArrayList<>();
        for (String p : parts) {
            String[] kv = p.split("\\s*[:=]\\s*", 2);
            if (kv.length == 2) {
                String key = kv[0].trim();
                String val = kv[1].trim();
                if (!key.isEmpty() && !val.isEmpty()) {
                    String label = key.substring(0, 1).toUpperCase() + (key.length() > 1 ? key.substring(1) : "");
                    out.add(label + ": " + val);
                }
            } else {
                if (!p.trim().isEmpty()) {
                    out.add(p.trim());
                }
            }
        }
        return String.join(", ", out);
    }
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <title>Chi tiết đơn hàng</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body>
        <%@ include file="/WEB-INF/include/header.jsp" %>
        <div class="max-w-4xl mx-auto p-6">
            <h1 class="text-2xl font-bold mb-4">Chi tiết đơn hàng</h1>

            <c:if test="${not empty order}">
                <div class="bg-white p-4 rounded shadow mb-4">
                    <p>Mã đơn hàng: <strong><c:out value="${order.orderCode}"/></strong></p>
                    <c:if test="${not empty order.customerName}">
                        <p>Người đặt: <strong><c:out value="${order.customerName}"/></strong></p>
                    </c:if>
                    <p>Trạng thái: <strong><c:out value="${order.orderStatus}"/></strong></p>
                    <p>Phương thức thanh toán: <strong><c:out value="${order.paymentMethodCode}"/></strong></p>
                    <p>Thanh toán: <strong><c:out value="${order.paymentStatus}"/></strong></p>
            <!--        <p>Địa chỉ giao hàng: <strong><c:out value="${order.shippingAddressLine}"/></strong></p>-->
                    <p>Tổng: <strong><fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>₫</strong></p>
                </div>

                <div class="bg-white p-4 rounded shadow">
                    <h2 class="font-semibold mb-3">Sản phẩm</h2>
                    <c:forEach var="it" items="${orderItems}">
                        <div class="flex justify-between border-b py-2">
                            <div>
                                <div class="font-medium"><c:out value="${it.productName}"/></div>
                                <div class="text-sm text-gray-600">Số lượng: <c:out value="${it.quantity}"/></div>
                                <%                  try {
                                        model.OrderItem _oi = (model.OrderItem) pageContext.getAttribute("it");
                                        if (_oi != null) {
                                            String ajson = _oi.getAttributeJson();
                                            if (ajson != null && !ajson.trim().isEmpty()) {
                                %>
                                <div class="text-sm text-gray-600 mt-1"><%= prettyAttributeFromJson(ajson)%></div>
                                <%        }
                                        }
                                    } catch (Exception _ex) {
                                        /* ignore */ }
                                %>
                            </div>
                            <div class="font-semibold"><fmt:formatNumber value="${it.lineTotal}" type="number" groupingUsed="true"/>₫</div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty order}">
                <div class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded">Đơn hàng không tồn tại.</div>
            </c:if>
        </div>
        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>