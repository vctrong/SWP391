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
@WebServlet(name = "contactAdminServlet", urlPatterns = {"/admin/contact"})
public class contactServlet extends HttpServlet {

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
            out.println("<title>Servlet contactServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet contactServlet at " + request.getContextPath() + "</h1>");
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
        final int pageSize = 15;
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignore) {
            }
        }
        if (page < 1) {
            page = 1;
        }

        ConsultationRequestDAO dao = new ConsultationRequestDAO();
        List<ConsultationRequest> crList = null;
        int totalItems = 0;
        int totalPages = 0;
        totalItems = dao.countAll();
        totalPages = (totalItems + pageSize - 1) / pageSize;
        if (totalPages == 0) {
            page = 1;
        } else if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * pageSize;
        crList = dao.listPaged(offset, pageSize);

        request.setAttribute("consultationRequests", crList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", pageSize);

        int startIndex = (totalItems == 0) ? 0 : ((page - 1) * pageSize + 1);
        int endIndex = Math.min(page * pageSize, totalItems);
        boolean hasPrev = page > 1;
        boolean hasNext = totalPages > 0 && page < totalPages;
        request.setAttribute("startIndex", startIndex);
        request.setAttribute("endIndex", endIndex);
        request.setAttribute("hasPrev", hasPrev);
        request.setAttribute("hasNext", hasNext);
        request.setAttribute("baseUrl", "/admin/contact");

        java.util.List<Integer> pagesWindow = new java.util.ArrayList<>();
        int window = 2;
        int start = Math.max(1, page - window);
        int finish = Math.min(totalPages, page + window);
        for (int p = start; p <= finish; p++) {
            pagesWindow.add(p);
        }
        request.setAttribute("pagesWindow", pagesWindow);
        request.setAttribute("windowStart", start);
        request.setAttribute("windowEnd", finish);

        request.getRequestDispatcher("/WEB-INF/admin/contacts.jsp").forward(request, response);
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
