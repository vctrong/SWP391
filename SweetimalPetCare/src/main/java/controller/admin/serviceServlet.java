/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import daos.admin.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import model.service.service;
import model.service.serviceCate;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "serviceAdminServlet", urlPatterns = {"/admin/service"})
public class serviceServlet extends HttpServlet {

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
            out.println("<title>Servlet serviceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet serviceServlet at " + request.getContextPath() + "</h1>");
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
        ServiceDAO sDAO = new ServiceDAO();
        ArrayList<service> listService = sDAO.getServiceAdmin();
        request.setAttribute("listCate", sDAO.getServiceCate());
        request.setAttribute("listService", listService);

        request.getRequestDispatcher("/WEB-INF/admin/services.jsp").forward(request, response);
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
        String serviceCode = request.getParameter("service_code");
        String serviceName = request.getParameter("service_name");
        String serviceCategoryIdStr = request.getParameter("service_category_id");
        String baseDurationStr = request.getParameter("base_duration_min");
        String currentPriceStr = request.getParameter("current_price");
        String status = request.getParameter("status");
        String descriptionBase = request.getParameter("description");

        String description = descriptionBase == null ? "" : descriptionBase.trim();

        if (serviceCode == null || serviceName == null) {
            request.setAttribute("err", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }

        long serviceCategoryId = 0;
        int baseDurationMin = 0;
        BigDecimal currentPrice = null;

        try {
            serviceCategoryId = Long.parseLong(serviceCategoryIdStr);
            baseDurationMin = Integer.parseInt(baseDurationStr);
            currentPrice = new BigDecimal(currentPriceStr);
        } catch (NumberFormatException e) {

            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }
        ServiceDAO sDAO = new ServiceDAO();
        if (sDAO.exitsServiceCode(serviceCode)) {

            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }
        int createService = sDAO.createService(serviceCategoryId, serviceCode,
                serviceName, description, baseDurationMin, currentPrice, status);

        response.sendRedirect(request.getContextPath() + "/admin/service?create=succsec");
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
