/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.PetDAO;
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
            return; // nhớ return để không chạy tiếp
        }

        try {
            PetDAO petDAO = new PetDAO();
            ServiceDAO serviceDAO = new ServiceDAO();

            List<Pet> pets = petDAO.getPetsByOwner(user.getId());
            List<Service> services = serviceDAO.getAllServices();

            // Lấy serviceId từ URL
            String serviceIdParam = request.getParameter("serviceId");
            Long selectedServiceId = (serviceIdParam != null && !serviceIdParam.isEmpty())
                    ? Long.parseLong(serviceIdParam)
                    : null;

            request.setAttribute("pets", pets);
            request.setAttribute("services", services);
            request.setAttribute("selectedServiceId", selectedServiceId);

            request.getRequestDispatcher("/WEB-INF/pages/booking.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            long customerId = user.getId();
            long petId = Long.parseLong(request.getParameter("petId"));
            long serviceId = Long.parseLong(request.getParameter("serviceId"));
            String requestedDate = request.getParameter("requestedDate");
            String requestedStart = request.getParameter("requestedStart");
            String notes = request.getParameter("notes");

            // Insert vào DB
            DBContext db = new DBContext();
            String sql = "INSERT INTO Booking(customer_id, pet_id, service_id, booking_time, requested_date, requested_start, notes, current_status) "
                    + "VALUES (?, ?, ?, SYSUTCDATETIME(), ?, ?, ?, 'PENDING')";
            db.executeQuery(sql, new Object[]{customerId, petId, serviceId, requestedDate, requestedStart, notes});

            response.sendRedirect(request.getContextPath() + "bookingHistory.jsp"); // sau này làm trang history
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
