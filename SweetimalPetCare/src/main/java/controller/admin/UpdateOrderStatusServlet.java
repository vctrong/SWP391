package controller.admin;

import db.DBContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 * Admin endpoint to update order status. Expects POST with orderId and status.
 */
@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = {"/admin/UpdateOrderStatus"})
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Users currentUser = null;
        if (session != null) {
            Object uo = session.getAttribute("user");
            if (uo instanceof Users) currentUser = (Users) uo;
        }
        if (currentUser == null || currentUser.getRole() != 4) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().print("{\"error\":\"forbidden\"}");
            return;
        }

        String idParam = request.getParameter("orderId");
        String status = request.getParameter("status");
        long orderId = -1L;
        try { orderId = Long.parseLong(idParam); } catch (Exception e) {}
        if (orderId <= 0 || status == null || status.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\":\"invalid_parameters\"}");
            return;
        }

        DBContext db = new DBContext();
        try {
            try (PreparedStatement ps = db.getConnection().prepareStatement("UPDATE Orders SET order_status = ?, updated_at = SYSUTCDATETIME() WHERE order_id = ?")) {
                ps.setString(1, status);
                ps.setLong(2, orderId);
                int updated = ps.executeUpdate();
                if (updated <= 0) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().print("{\"error\":\"not_found\"}");
                    return;
                }
            }
            // insert history
            try (PreparedStatement ps2 = db.getConnection().prepareStatement("INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, comment, created_at) VALUES (?, ?, ?, ?, SYSUTCDATETIME())")) {
                ps2.setLong(1, orderId);
                ps2.setString(2, status);
                ps2.setLong(3, currentUser.getId());
                ps2.setString(4, "Status changed via admin");
                ps2.executeUpdate();
            } catch (SQLException ignore) {}

            response.getWriter().print("{\"success\":true}\n");
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"db_error\"}");
        }
    }
}
