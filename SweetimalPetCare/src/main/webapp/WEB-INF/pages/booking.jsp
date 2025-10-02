<%--
    Document   : booking
    Created on : Sep 30, 2025, 8:51:07 AM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page import="java.util.List, model.Service, model.Pet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Service> services = (List<Service>) request.getAttribute("services");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 text-gray-800">
        <!-- Navbar -->
        <%@include file="/WEB-INF/include/header.jsp" %>

        <div class="max-w-2xl mx-auto mt-10 bg-white shadow p-6 rounded-lg">
            <h2 class="text-2xl font-bold mb-4">Đặt dịch vụ cho thú cưng</h2>
            <form action="booking" method="post" class="space-y-4">
                <!-- Chọn thú cưng -->
                <label class="block">
                    <span class="text-gray-700">Thú cưng</span>
                    <select name="petId" class="w-full border rounded px-3 py-2" required>
                        <option value="">-- Chọn thú cưng --</option>
                        <% for (Pet p : pets) {%>
                        <option value="<%= p.getId()%>"><%= p.getName()%></option>
                        <% } %>
                    </select>
                </label>

                <!-- Chọn dịch vụ -->
                <label class="block">
                    <span class="text-gray-700">Dịch vụ</span>
                    <select name="serviceId" class="w-full border rounded px-3 py-2" required>
                        <option value="">-- Chọn dịch vụ --</option>
                        <%
                            Long selectedServiceId = (Long) request.getAttribute("selectedServiceId");
                            if (services != null) {
                                for (Service s : services) {
                                    String selected = (selectedServiceId != null && selectedServiceId == s.getId())
                                            ? "selected"
                                            : "";
                        %>
                        <option value="<%= s.getId()%>" <%= selected%>>
                            <%= s.getName()%>
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </label>


                <!-- Chọn ngày -->
                <label class="block">
                    <span class="text-gray-700">Ngày</span>
                    <input type="date" name="requestedDate" class="w-full border rounded px-3 py-2" required />
                </label>

                <!-- Chọn giờ -->
                <label class="block">
                    <span class="text-gray-700">Giờ bắt đầu</span>
                    <input type="time" name="requestedStart" class="w-full border rounded px-3 py-2" required />
                </label>

                <!-- Ghi chú -->
                <label class="block">
                    <span class="text-gray-700">Ghi chú</span>
                    <textarea name="notes" class="w-full border rounded px-3 py-2"></textarea>
                </label>

                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    Đặt lịch
                </button>
            </form>
        </div>

        <!-- Footer -->
        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
