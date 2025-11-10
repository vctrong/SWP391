/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import daos.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.Order;

/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
@WebServlet(name="ordersServlet", urlPatterns={"/orders/*"})
public class ordersServlet extends HttpServlet {
   
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // pathInfo ví dụ: /123
        String path = request.getPathInfo(); // returns "/{orderId}" or null
        if (path == null || path.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing order id");
            return;
        }
        String idStr = path.substring(1);
        long orderId;
        try {
            orderId = Long.parseLong(idStr);
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order id");
            return;
        }

        OrderDAO orderDao = new OrderDAO();
        try {
            // giả sử OrderDAO có method getOrderById(long)
            Order order = orderDao.getOrderById(orderId);
            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }
            request.setAttribute("order", order);
            // nếu cần danh sách items
            request.setAttribute("orderItems", orderDao.listOrderItems(orderId));
            request.getRequestDispatcher("/WEB-INF/pages/orderDetail.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
