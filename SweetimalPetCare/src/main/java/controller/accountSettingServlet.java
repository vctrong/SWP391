/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.UserDAO;
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
 * @author Lim Thế Toàn - CE190616
 */
@WebServlet(name = "accountSettingServlet", urlPatterns = {"/settings"})
public class accountSettingServlet extends HttpServlet {

    Users user = new Users();
    private final UserDAO userDAO = new UserDAO();

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
            out.println("<title>Servlet accountSettingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet accountSettingServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false);
        user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/settings");
        } else {
            // Check if user has booking data so the JSP can hide the delete option
            try {
                boolean hasBooking = new daos.UserDAO().hasBookings(user.getId());
                request.setAttribute("hasBooking", hasBooking);
            } catch (Exception ex) {
                // if check fails, default to conservative behavior (assume has bookings)
                request.setAttribute("hasBooking", true);
            }
            request.getRequestDispatcher("/WEB-INF/pages/settings.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("deactivate".equalsIgnoreCase(action)) {
                userDAO.updateUserStatus(user.getId(), false);  // Set is_active = 0
                session.invalidate(); // Log them out
                response.sendRedirect("login?msg=Account deactivated successfully");
            } else if ("delete".equalsIgnoreCase(action)) {
                // Prevent hard delete if user has bookings
                boolean hasBooking = false;
                try {
                    hasBooking = userDAO.hasBookings(user.getId());
                } catch (Exception ex) {
                    // on error, treat as having bookings to be safe
                    hasBooking = true;
                }
                if (hasBooking) {
                    request.setAttribute("error", "Bạn không thể xóa tài khoản vì bạn đã có lịch đặt trước. Bạn chỉ có thể vô hiệu hóa tài khoản.");
                    // Re-run the GET logic: mark hasBooking so JSP renders correctly
                    request.setAttribute("hasBooking", true);
                    request.getRequestDispatcher("/WEB-INF/pages/settings.jsp").forward(request, response);
                    return;
                }

                userDAO.deleteUser(user.getId());
                session.invalidate();
                response.sendRedirect("login?msg=Account deleted successfully");
            }
        } catch (Exception e) {
            throw new ServletException(e);
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
