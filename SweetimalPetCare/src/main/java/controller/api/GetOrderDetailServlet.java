/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import com.google.gson.Gson;
import daos.admin.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import model.orderAdmin.order;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "GetOrderDetailServlet", urlPatterns = {"/api/GetOrderDetail"})
public class GetOrderDetailServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GetOrderDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetOrderDetailServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        OrderDAO oDAO = new OrderDAO();
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        try {
            // 2. Lấy ID từ tham số request
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": " + "\"Missing ID\"" + "}");
                return;
            }

            long orderId = Long.parseLong(idStr);

            // 3. Gọi DAO lấy dữ liệu (Hàm getOrderWithItemsById bạn vừa viết)
            order order = oDAO.getOrderWithItemsById(orderId);

            if (order != null) {
                // 4. Chuyển Object thành JSON string
                String jsonResult = gson.toJson(order);
                out.print(jsonResult);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": " + "\"Order not found\"" + "}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": " + "\"Invalid ID format\"" + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": " + "\"Server Error\"" + "}");
        } finally {
            out.flush();
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO oDAO = new OrderDAO();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Hỗ trợ đọc tiếng Việt nếu gửi form-urlencoded
        request.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();
        try {
            // 2. Lấy tham số
            String idStr = request.getParameter("orderId");
            String newStatus = request.getParameter("status");

            if (idStr != null && newStatus != null) {
                long orderId = Long.parseLong(idStr);

                // 3. Gọi DAO update
                boolean isSuccess = oDAO.updateOrderStatus(orderId, newStatus);

                // 4. Trả kết quả
                if (isSuccess) {
                    result.put("success", true);
                    result.put("message", "Update successful");
                } else {
                    result.put("success", false);
                    result.put("message", "Update failed in Database");
                }
            } else {
                result.put("success", false);
                result.put("message", "Missing parameters");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Server Error: " + e.getMessage());
        }

        // Xuất JSON
        out.print(gson.toJson(result));
        out.flush();
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
