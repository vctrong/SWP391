package controller;

import daos.BookingDAO;
import daos.ScheduleDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "CancelBookingServlet", urlPatterns = {"/cancel-booking"})
public class CancelBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/booking-history");
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/booking-history?error=missing_id");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);

            // verify ownership
            model.Booking b = bookingDAO.getBookingById(bookingId);
            if (b == null || b.getCustomerId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/booking-history?error=not_allowed");
                return;
            }

            // Only allow cancel if booking is not already completed/cancelled
            String status = b.getCurrentStatus();
            if (status != null && (status.equalsIgnoreCase("COMPLETED") || status.equalsIgnoreCase("CANCELLED") || status.equalsIgnoreCase("DONE"))) {
                response.sendRedirect(request.getContextPath() + "/booking-history?error=cannot_cancel");
                return;
            }

            // Update booking status
            bookingDAO.updateBookingStatus(bookingId, "CANCELLED", (int) user.getId());

            // Free linked schedule slots so they can be reused
            scheduleDAO.freeSlotsByBookingId(bookingId);

            response.sendRedirect(request.getContextPath() + "/booking-history?cancelled=1");
        } catch (NumberFormatException | SQLException ex) {
            throw new ServletException("Failed to cancel booking", ex);
        }
    }
}
