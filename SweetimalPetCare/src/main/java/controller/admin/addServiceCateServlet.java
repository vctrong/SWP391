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
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "addServiceCateServlet", urlPatterns = {"/admin/addServiceCate"})
public class addServiceCateServlet extends HttpServlet {

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
            out.println("<title>Servlet addServiceCateServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addServiceCateServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        response.sendRedirect(request.getContextPath() + "/admin/service");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String cateName = request.getParameter("category_name");
        String descriptionBase = request.getParameter("description");
        String description = descriptionBase == null ? "" : descriptionBase.trim();
        if (cateName == null) {
            session.setAttribute("message", "Lỗi: Vui lòng không để trống Tên danh mục.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }
        ServiceDAO sDAO = new ServiceDAO();
        if (sDAO.createServiceCate(cateName, description) > 0) {
            session.setAttribute("message", "Thêm Danh mục dịch vụ thành công!");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/service?createCate=succsess");
        } else {
            session.setAttribute("message", "Lỗi: Không thể thêm Danh mục dịch vụ. Vui lòng kiểm tra CSDL.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?createCate=fail");
        }
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
