/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import com.google.gson.Gson;
import daos.admin.dashboardDAO;
import enums.RoleEnum;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import model.Users;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
@WebServlet(name = "adminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class adminDashboardServlet extends HttpServlet {

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
            out.println("<title>Servlet adminDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet adminDashboardServlet at " + request.getContextPath() + "</h1>");
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
        dashboardDAO dDAO = new dashboardDAO();
        request.setAttribute("revenue", dDAO.revenueInMonth());
        request.setAttribute("bookingToday", dDAO.bookingToday());
        request.setAttribute("orderToday", dDAO.orderToday());
        request.setAttribute("newCustomer", dDAO.customerInMonth());
        request.setAttribute("pending", dDAO.orderPending());
        LinkedHashMap<String, Integer> topService = dDAO.topService();
        LinkedHashMap<String, Integer> revenue30Day = dDAO.revenue30Day();
        LinkedHashMap<String, Integer> topProduct = dDAO.topProduct();
        List<String> labelService = new ArrayList<>(topService.keySet());
        List<Integer> dataService = new ArrayList<>(topService.values());

        List<String> labelRevenue = new ArrayList<>(revenue30Day.keySet());
        List<Integer> dataRevenue = new ArrayList<>(revenue30Day.values());

        List<String> labelProduct = new ArrayList<>(topProduct.keySet());
        List<Integer> dataProduct = new ArrayList<>(topProduct.values());

        Gson gson = new Gson();
        String labelServiceJson = gson.toJson(labelService);
        String dataServiceJson = gson.toJson(dataService);

        String labelRevenueJson = gson.toJson(labelRevenue);
        String dataRevenueJson = gson.toJson(dataRevenue);

        String labelProductJson = gson.toJson(labelProduct);
        String dataProductJson = gson.toJson(dataProduct);
        System.out.println("day la label product" + labelProductJson);
        System.out.println("day la label service" + labelServiceJson);
        System.out.println("day la date prodcut" + dataProductJson);
        System.out.println("day la data servie" + dataServiceJson);
        request.setAttribute("labelService", labelServiceJson);
        request.setAttribute("dataService", dataServiceJson);
        request.setAttribute("labelRevenue", labelRevenueJson);
        request.setAttribute("dataRevenue", dataRevenueJson);
        request.setAttribute("labelProduct", labelProductJson);
        request.setAttribute("dataProduct", dataProductJson);
        request.setAttribute("isNullService", topService.isEmpty());
        request.setAttribute("isNullProduct", topProduct.isEmpty());
        request.setAttribute("recentBookings", dDAO.recentBooking());
        request.setAttribute("recentOrder", dDAO.recentOrder());
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
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
        processRequest(request, response);
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
