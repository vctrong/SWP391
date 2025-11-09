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
                            <div class="flex items-center gap-2">
                                <input id="productSearch" placeholder="Search product..." class="input-field" />
                                <button id="addProductBtn" class="btn-primary">Add Product</button>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg shadow-sm overflow-hidden">
                            <div class="overflow-x-auto">
                                <table class="w-full table-auto">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="table-header-cell">Image</th>
                                            <th class="table-header-cell">Name</th>
                                            <th class="table-header-cell">Category</th>
                                            <th class="table-header-cell text-right">Price</th>
                                            <th class="table-header-cell text-center">Stock</th>
                                            <th class="table-header-cell text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="productsTableBody" class="text-sm divide-y divide-gray-200"></tbody>
                                </table>
                            </div>
                        </div>
                    </section>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/adminPages.js"></script>
    </body>
</html>
