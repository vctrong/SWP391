/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import daos.ConsultationRequestDAO;
import model.ConsultationRequest;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name="contactAdminServlet", urlPatterns={"/admin/contact"})
public class contactServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet contactServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet contactServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

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
        final int pageSize = 15; // fixed page size as requested
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignore) {}
        }
        if (page < 1) page = 1;

        ConsultationRequestDAO dao = new ConsultationRequestDAO();
        List<ConsultationRequest> crList = null;
        int totalItems = 0;
        int totalPages = 0;
        try {
            totalItems = dao.countAll();
            totalPages = (totalItems + pageSize - 1) / pageSize; // ceil division
            if (totalPages == 0) {
                page = 1; // no data, default page 1
            } else if (page > totalPages) {
                page = totalPages; // clamp to last page
            }
            int offset = (page - 1) * pageSize;
            crList = dao.listPaged(offset, pageSize);
        } catch (SQLException e) {
            request.setAttribute("loadError", "Không thể tải danh sách: " + e.getMessage());
            System.err.println("[contactServlet] Failed loading consultation requests: " + e.getMessage());
        }

        request.setAttribute("consultationRequests", crList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/WEB-INF/admin/contacts.jsp").forward(request, response);
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
        processRequest(request, response);
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
