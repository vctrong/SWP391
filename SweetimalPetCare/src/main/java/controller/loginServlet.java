/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.LoginDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "loginServlet", urlPatterns = {"/login"})
public class loginServlet extends HttpServlet {

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
            out.println("<title>Servlet loginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loginServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("WEB-INF/login/login.jsp").forward(request, response);
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
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String view = request.getParameter("view");
        
        LoginDAO lDAO = new LoginDAO();
        System.out.println("Day la pass khi ma hoa" + lDAO.hashMd5(password));
        Users user = lDAO.login(username, password);

        HttpSession session = request.getSession(true); // always ensure a session exists

        if (user == null) {
            session.setAttribute("loginFail", "Tên đăng nhập hoặc mật khẩu không đúng.");
            response.sendRedirect(request.getContextPath() + "/login?view=fail");
            return;
        }

        if (user.getActive() == 0) {
            session.setAttribute("loginFail", "Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ hỗ trợ.");
            response.sendRedirect(request.getContextPath() + "/login?view=inactive");
            return;
        }

        session.setAttribute("user", user);
        session.setAttribute("loginOk", Boolean.TRUE);

        switch (user.getRoleEnum()) {
            case ADMIN:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;

            case STAFF:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;

            case VET:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;

            case CUSTOMER:
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
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
