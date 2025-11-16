package controller.admin;

import com.google.gson.Gson;
import daos.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.Users;

/**
 * Return JSON details (order + items) for a given order id (admin only)
 */
@WebServlet(name = "GetOrderDetailsServlet", urlPatterns = {"/admin/GetOrderDetails"})
public class GetOrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        long orderId = -1L;
        try { orderId = Long.parseLong(idParam); } catch (Exception e) {}
        if (orderId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\":\"invalid_order_id\"}");
            return;
        }

        try (PrintWriter out = response.getWriter()) {
            OrderDAO dao = new OrderDAO();
            Order order = dao.getOrderById(orderId);
            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"not_found\"}");
                return;
            }
            Map<String, Object> res = new HashMap<>();
            res.put("order", order);
            res.put("items", dao.listOrderItems(orderId));
            Gson g = new Gson();
            out.print(g.toJson(res));
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"db_error\"}");
        }
    }
}
