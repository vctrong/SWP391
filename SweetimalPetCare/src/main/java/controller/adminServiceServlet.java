package controller;

import daos.ServiceDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import model.Users;
import enums.RoleEnum;

@WebServlet(name = "adminServiceServlet", urlPatterns = {"/admin/services"})
public class adminServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || user.getRoleEnum() != RoleEnum.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/admin/services");
            return;
        }

        try {
            List<Service> services = serviceDAO.getAllServices();
            request.setAttribute("services", services);
            request.getRequestDispatcher("/WEB-INF/pages/admin_services.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load services", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || user.getRoleEnum() != RoleEnum.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/admin/services");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                String code = request.getParameter("serviceCode");
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                int duration = Integer.parseInt(request.getParameter("duration"));
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                serviceDAO.createService(code, name, desc, duration, price, null);
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("serviceId"));
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                int duration = Integer.parseInt(request.getParameter("duration"));
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                serviceDAO.updateService(id, name, desc, duration, price);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("serviceId"));
                serviceDAO.inactivateService(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/services?success=1");
        } catch (SQLException ex) {
            throw new ServletException("Failed to perform service action", ex);
        }
    }
}
