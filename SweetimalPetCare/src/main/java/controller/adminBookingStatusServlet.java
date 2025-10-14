package controller;

import daos.BookingDAO;
import enums.RoleEnum;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "adminBookingStatusServlet", urlPatterns = {"/admin/booking/status"})
public class adminBookingStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Users u = (Users) session.getAttribute("user");
        if (u.getRoleEnum() != RoleEnum.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String status = request.getParameter("status");

            daos.BookingDAO dao = new BookingDAO();
            dao.updateBookingStatus(bookingId, status, (int) u.getId());

            response.sendRedirect(request.getContextPath() + "/dashboard?statusUpdated=1");
        } catch (Exception ex) {
            throw new ServletException("Failed to update booking status", ex);
        }
    }
}
