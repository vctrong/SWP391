/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import com.google.gson.Gson;
import daos.admin.ScheduleSlotDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "GenerateScheduleServlet", urlPatterns = {"/api/GenerateSchedule"})
public class GenerateScheduleServlet extends HttpServlet {

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
            out.println("<title>Servlet GenerateScheduleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GenerateScheduleServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            long staffId = Long.parseLong(request.getParameter("staffId"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));
            int startHour = Integer.parseInt(request.getParameter("startHour"));
            int endHour = Integer.parseInt(request.getParameter("endHour"));
            int duration = Integer.parseInt(request.getParameter("duration"));
            String roomName = request.getParameter("roomName");
            boolean skipLunch = request.getParameter("skipLunch") != null; // Checkbox gửi "on" hoặc null

            ScheduleSlotDAO dao = new ScheduleSlotDAO();
            int count = dao.generateSlots(staffId, startDate, endDate, startHour, endHour, duration, skipLunch, roomName);

            result.put("success", true);
            result.put("count", count);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        out.print(gson.toJson(result));
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
