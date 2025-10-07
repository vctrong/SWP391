<%--
    Document   : dashboard
    Created on : Oct 3, 2025, 6:50:09 PM
    Author     : Lim Thế Toàn - CE190616
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="/WEB-INF/include/library.jsp" %>
        <%@include file="/WEB-INF/include/header.jsp" %>
        <title>Admin Dashboard</title>
        <style>
            .summary-card {
                width: 23%;
                margin: 1%;
                padding: 20px;
                border-radius: 10px;
                background: #f5f5f5;
                text-align: center;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                background: white;
            }
            th, td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: #2c3e50;
                color: white;
            }
        </style>
    </head>
    <body>
        <h1 style="text-align:center;">Admin Dashboard</h1>

        <c:if test="${accessDenied}">
            <div style="color:red; text-align:center; margin:20px;">
                <strong>Access Denied:</strong> You must be an administrator to view this page.
            </div>
        </c:if>

        <div style="display:flex; justify-content:space-around;">
            <div class="summary-card"><h2>Users</h2><p style="font-size:2em; color:#2b7;">${userCount}</p></div>
            <div class="summary-card"><h2>Orders</h2><p style="font-size:2em; color:#27a;">${orderCount}</p></div>
            <div class="summary-card"><h2>Bookings</h2><p style="font-size:2em; color:#e67e22;">${bookingCount}</p></div>
            <div class="summary-card"><h2>Products</h2><p style="font-size:2em; color:#8e44ad;">${productCount}</p></div>
        </div>

        <div style="text-align:center; color:red;">${error != null ? error : ""}</div>

        <!-- Recent Audit Log Section -->
        <section style="max-width:1000px; margin:40px auto;">
            <h2 style="font-size:1.8em; margin-bottom:10px;">Recent User Actions (Audit Log)</h2>
            <table>
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Email</th>
                        <th>Action</th>
                        <th>Details</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${recentActions}">
                        <tr>
                            <td>${a.fullName}</td>
                            <td>${a.email}</td>
                            <td>${a.actionType}</td>
                            <td>${a.description}</td>
                            <td>${a.createdAt}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentActions}">
                        <tr><td colspan="5" style="text-align:center; color:gray;">No recent logs found</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>

        <%@include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
