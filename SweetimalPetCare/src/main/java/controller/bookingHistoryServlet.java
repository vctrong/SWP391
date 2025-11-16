package controller;

import daos.BookingDAO;
import daos.ServiceDAO;
import java.util.HashMap;
import java.util.Map;

import model.Service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Users;
import enums.RoleEnum;

@WebServlet(name = "BookingHistoryServlet", urlPatterns = {"/booking-history"})
public class bookingHistoryServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/booking-history");
            return;
        }

        // Add role check
        if (user.getRoleEnum() != RoleEnum.CUSTOMER) {
            response.sendRedirect(request.getContextPath() + "/denied");
            return;
        }

        try {
            // cap to latest 50 bookings by default
            List<Booking> bookings = bookingDAO.getBookingsByCustomer((int) user.getId(), 50);

            // load services to map service_id->service_name
            ServiceDAO serviceDAO = new ServiceDAO();
            java.util.List<Service> services = serviceDAO.getAllServices();
            Map<Integer, String> serviceMap = new HashMap<>();
            for (Service s : services) {
                serviceMap.put((int) s.getId(), s.getName());
            }

            request.setAttribute("bookings", bookings);
            request.setAttribute("serviceMap", serviceMap);
            request.getRequestDispatcher("/WEB-INF/pages/bookingHistory.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load booking history", e);
        }
    }
}
