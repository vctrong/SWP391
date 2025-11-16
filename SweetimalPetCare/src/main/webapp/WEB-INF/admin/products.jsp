<%-- 
    Document   : products
    Created on : Oct 31, 2025, 4:51:36 PM
    Author     : Vo Chi Trong - CE191062
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Services Admin | Sweetimal Pet Care</title>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="includes/headAdmin.jsp" %>
    </head>
    <body  class="font-inter bg-gray-50 text-gray-800">
        <div class="min-h-screen flex">
            <%@include file="../admin/includes/admin_sidebar.jsp" %>
            <%@include file="includes/mobileApp.jsp" %>
            <div class="flex-1 md:pl-72">
                <%@include file="includes/admin_header.jsp" %>
                <main class="p-4 md:p-8">
                    <section id="page-products" class="page-section space-y-4">
                        <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                            <h3 class="text-lg font-semibold">Product Management</h3>
                            <div class="flex flex-col md:flex-row items-center gap-2 w-full md:w-auto">
                                <select id="categoryFilter" class="input-field w-full md:w-auto">
                                    <option value="0">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.productCategoryId}">${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                                <input id="productSearch" placeholder="Search product..." class="input-field w-full md:w-auto" />
                                <button id="addProductBtn" class="btn-primary w-full md:w-auto">Add Product</button>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full table-auto">


                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell">ID</th>
                                            <th class="table-header-cell">Product Name</th>
                                            <th class="table-header-cell">Brand</th>
                                            <th class="table-header-cell">Category</th>
                                            <th class="table-header-cell text-right">Price</th>
                                            <th class="table-header-cell text-center">Stock</th>
                                            <th class="table-header-cell text-center">Status</th>
                                            <th class="table-header-cell text-center">Actions</th>
                                        </tr>
                                    </thead>


                                    <tbody id="productsTableBody" class="text-sm divide-y divide-gray-200">

                                    </tbody>

                                    <%-- [MỚI] Footer cho Pagination --%>
                                    <tfoot id="paginationControls" class="bg-gray-50 border-t border-gray-200">
                                        <tr>
                                            <td colspan="8" class="p-4">
                                                <div class="flex items-center justify-between">

                                                    <%-- BÊN TRÁI: THÔNG TIN TRANG + BỘ CHỌN PAGE SIZE --%>
                                                    <div class="flex items-center gap-4">
                                                        <span id="pageInfo" class="text-sm text-gray-600"></span>


                                                        <select id="pageSizeSelector" class="input-field" style="padding: 4px 8px; font-size: 0.875rem;">
                                                            <option value="10" selected>10</option>
                                                            <option value="5">5</option>
                                                            <option value="15">15</option>
                                                            <option value="20">20</option>
                                                            <option value="30">30</option>
                                                            <option value="50">50</option>
                                                        </select>
                                                    </div>


                                                    <div id="pageButtons" class="flex gap-1"></div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tfoot>

                                </table>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <%@include file="/WEB-INF/modal/modalDetailProduct.jsp" %>
        <%@include file="/WEB-INF/modal/modalEditProduct.jsp" %>
        <%@include file="/WEB-INF/modal/modalAddProduct.jsp" %>

        <script>
            const contextPath = '${pageContext.request.contextPath}';
            const APP_DATA = {
                categories: ${gson.toJson(categories)},
                brands: ${gson.toJson(listBrand)}
            };
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminProduct.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/adminAddProduct.js"></script>
    </body>
</html>
