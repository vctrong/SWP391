package controller.admin;

import com.google.gson.Gson;
import db.DBContext;
import jakarta.servlet.http.HttpSession;
import model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet trả JSON danh sách orders cho admin (paging, filter, search)
 */
@WebServlet(name = "GetOrdersServlet", urlPatterns = {"/admin/GetOrders"})
public class GetOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // Admin-only access check
        HttpSession session = request.getSession(false);
        Users currentUser = null;
        if (session != null) {
            Object uo = session.getAttribute("user");
            if (uo instanceof Users) currentUser = (Users) uo;
        }
        boolean wantsJson = true; // admin pages expect JSON
        if (currentUser == null) {
            // not logged in
            if (wantsJson) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().print("{\"error\":\"unauthorized\"}");
                return;
            } else {
                String returnTo = request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "");
                response.sendRedirect(request.getContextPath() + "/login?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8"));
                return;
            }
        }
        // restrict to Admin role (RoleEnum.ADMIN -> code 4)
        if (currentUser.getRole() != 4) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().print("{\"error\":\"forbidden\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        int page = 1;
        int pageSize = 10;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
        try { pageSize = Integer.parseInt(request.getParameter("pageSize")); } catch (Exception e) {}
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        try ( PrintWriter out = response.getWriter()) {
            if (!"list".equalsIgnoreCase(action)) {
                out.print("{\"data\":[],\"total\":0}");
                return;
            }

            DBContext db = new DBContext();
            String where = " WHERE 1=1 ";
            List<Object> params = new ArrayList<>();
            if (search != null && !search.trim().isEmpty()) {
                where += " AND (o.order_code LIKE ? OR u.full_name LIKE ?) ";
                String like = "%" + search.trim() + "%";
                params.add(like);
                params.add(like);
            }
            if (status != null && !status.trim().isEmpty()) {
                where += " AND o.order_status = ? ";
                params.add(status.trim());
            }

            // total count
            long total = 0;
            String countSql = "SELECT COUNT(*) AS cnt FROM Orders o LEFT JOIN Users u ON o.customer_id = u.user_id " + where;
            try (PreparedStatement pcs = db.getConnection().prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) pcs.setObject(i+1, params.get(i));
                try (ResultSet rs = pcs.executeQuery()) {
                    if (rs.next()) total = rs.getLong("cnt");
                }
            }

            // list page
            int offset = (page - 1) * pageSize;
            String listSql = "SELECT o.order_id, o.order_code, o.customer_id, u.full_name AS customer_name, o.created_at, o.total_amount, o.payment_method_code, o.order_status "
                    + "FROM Orders o LEFT JOIN Users u ON o.customer_id = u.user_id "
                    + where
                    + " ORDER BY o.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            List<Map<String,Object>> rows = new ArrayList<>();
            try (PreparedStatement ps = db.getConnection().prepareStatement(listSql)) {
                int idx = 1;
                for (Object p : params) { ps.setObject(idx++, p); }
                ps.setInt(idx++, offset);
                ps.setInt(idx++, pageSize);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String,Object> m = new HashMap<>();
                        m.put("orderId", rs.getLong("order_id"));
                        m.put("orderCode", rs.getString("order_code"));
                        m.put("customerId", rs.getLong("customer_id"));
                        m.put("customerName", rs.getString("customer_name"));
                        m.put("createdAt", rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toString() : null);
                        m.put("totalAmount", rs.getDouble("total_amount"));
                        m.put("paymentMethod", rs.getString("payment_method_code"));
                        m.put("status", rs.getString("order_status"));
                        rows.add(m);
                    }
                }
            }

            Map<String,Object> result = new HashMap<>();
            result.put("data", rows);
            result.put("total", total);

            Gson g = new Gson();
            out.print(g.toJson(result));
            out.flush();

        } catch (SQLException ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"DB error\"}");
        }
    }

}
