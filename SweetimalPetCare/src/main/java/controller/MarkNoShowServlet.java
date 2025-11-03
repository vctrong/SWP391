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

@WebServlet(name = "MarkNoShowServlet", urlPatterns = {"/admin/booking/no-show"})
public class MarkNoShowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Users u = (Users) session.getAttribute("user");
        if (u.getRoleEnum() != RoleEnum.ADMIN && u.getRoleEnum() != RoleEnum.STAFF) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            daos.BookingDAO dao = new BookingDAO();
            dao.updateBookingStatus(bookingId, "NO_SHOW", (int) u.getId());
            response.sendRedirect(request.getContextPath() + "/dashboard?noShowMarked=1");
        } catch (Exception ex) {
            throw new ServletException("Failed to mark booking as no-show", ex);
        }
    }
}
