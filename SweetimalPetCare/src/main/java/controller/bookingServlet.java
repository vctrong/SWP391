/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.PetDAO;
import daos.ScheduleDAO;
import daos.ServiceDAO;
import db.DBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import model.Pet;
import model.Service;
import model.Users;

/**
 *
 * @author Lim Thế Toàn - CE190616
 */
@WebServlet(name = "bookingServlet", urlPatterns = {"/booking"})
public class bookingServlet extends HttpServlet {

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
            out.println("<title>Servlet bookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet bookingServlet at " + request.getContextPath() + "</h1>");
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
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/booking");
            return;
        }

        try {
            PetDAO petDAO = new PetDAO();
            ServiceDAO serviceDAO = new ServiceDAO();
            ScheduleDAO scheduleDAO = new ScheduleDAO();

            List<Pet> pets = petDAO.getPetsByOwner(user.getId());
            List<Service> services = serviceDAO.getAllServices();
            List<model.ScheduleSlot> availableSlots = scheduleDAO.getAvailableSlots();

            // allow pre-selection of a service via query parameter ?serviceId=123
            String serviceIdParam = request.getParameter("serviceId");
            if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
                try {
                    Integer selectedServiceId = Integer.valueOf(serviceIdParam);
                    request.setAttribute("selectedServiceId", selectedServiceId);
                } catch (NumberFormatException ex) {
                    // ignore invalid param
                }
            }

            request.setAttribute("pets", pets);
            request.setAttribute("services", services);
            request.setAttribute("availableSlots", availableSlots);

            request.getRequestDispatcher("/WEB-INF/pages/calendar_user.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error loading booking form", e);
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
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            long customerId = user.getId();
            int petId = Integer.parseInt(request.getParameter("petId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String notes = request.getParameter("notes");

            // 1) get slot info
            daos.ScheduleDAO scheduleDAO = new daos.ScheduleDAO();
            model.ScheduleSlot slot = scheduleDAO.getSlotById(slotId);
            if (slot == null) {
                throw new ServletException("Selected slot not found");
            }

            // map slot start timestamp to requested_date and requested_start
            java.sql.Timestamp ts = slot.getStartTime();
            java.time.LocalDate requestedDate = ts.toLocalDateTime().toLocalDate();
            java.time.LocalTime requestedStart = ts.toLocalDateTime().toLocalTime();

            // 2) determine price from service
            daos.ServiceDAO serviceDAO = new daos.ServiceDAO();
            model.Service svc = null;
            for (model.Service s : serviceDAO.getAllServices()) {
                if (s.getId() == serviceId) {
                    svc = s;
                    break;
                }
            }

            java.math.BigDecimal totalPrice = svc != null ? svc.getPrice() : java.math.BigDecimal.ZERO;

            // 3) create booking via BookingDAO
            daos.BookingDAO bookingDAO = new daos.BookingDAO();
            int bookingId = bookingDAO.createBooking((int) customerId, petId, serviceId, null,
                    requestedDate, requestedStart, notes, totalPrice);

            if (bookingId <= 0) {
                throw new ServletException("Failed to create booking");
            }

            // 4) assign booking to slot
            scheduleDAO.assignBookingToSlot(slotId, bookingId);

            response.sendRedirect(request.getContextPath() + "/booking?success=1");
        } catch (Exception e) {
            throw new ServletException("Booking failed", e);
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
