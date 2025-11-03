/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.ScheduleDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import model.ScheduleSlot;
import model.Users;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
@WebServlet(name = "scheduleServlet", urlPatterns = {"/schedule"})
public class scheduleServlet extends HttpServlet {

    ScheduleDAO scheduleDAO = new ScheduleDAO();

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
            out.println("<title>Servlet scheduleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet scheduleServlet at " + request.getContextPath() + "</h1>");
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
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        if (user.getRoleEnum() != enums.RoleEnum.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ admin mới được truy cập trang này.");
            return;
        }
        try {
            List<ScheduleSlot> slots = scheduleDAO.getSlotsByStaff(user.getId());
            request.setAttribute("slots", slots);
            request.getRequestDispatcher("/WEB-INF/pages/schedule.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
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
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || user.getRoleEnum() != enums.RoleEnum.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ admin mới được thêm ca làm việc.");
            return;
        }
        String room = request.getParameter("room");
        LocalDate date = LocalDate.parse(request.getParameter("date"));
        LocalTime start = LocalTime.parse(request.getParameter("start"));
        LocalTime end = LocalTime.parse(request.getParameter("end"));
        try {
            scheduleDAO.addSlot(user.getId(), room, LocalDateTime.of(date, start), LocalDateTime.of(date, end));
            response.sendRedirect("schedule");
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
