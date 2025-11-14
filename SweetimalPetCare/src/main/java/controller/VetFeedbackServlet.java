package controller;

import daos.VetVisitDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.VetVisit;
import model.Users;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "vetFeedbackServlet", urlPatterns = {"/vet/visits"})
public class VetFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            VetVisitDAO dao = new VetVisitDAO();
            int pageSize = 10;
            int page = 1;
            try {
                String p = request.getParameter("page");
                if (p != null) {
                    page = Integer.parseInt(p);
                    if (page < 1) page = 1;
                }
            } catch (NumberFormatException ignore) { page = 1; }

            List<VetVisit> visits;
            int total = 0;
            Users sessionUser = (Users) request.getSession().getAttribute("user");
            if (sessionUser != null && sessionUser.getRole() == 1) { // Customer
                total = dao.countByOwner(sessionUser.getId());
                int totalPages = (int) Math.ceil(total / (double) pageSize);
                if (page > totalPages && totalPages > 0) page = totalPages;
                visits = dao.listByOwnerPaged(sessionUser.getId(), page, pageSize);
                request.setAttribute("totalPages", totalPages);
            } else {
                total = dao.countAll();
                int totalPages = (int) Math.ceil(total / (double) pageSize);
                if (page > totalPages && totalPages > 0) page = totalPages;
                visits = dao.listAllPaged(page, pageSize);
                request.setAttribute("totalPages", totalPages);
            }
            request.setAttribute("visits", visits);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
        } catch (Exception e) {
            request.setAttribute("visits", Collections.emptyList());
            request.setAttribute("error", "Unable to load vet visits: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/pages/vet-visits.jsp").forward(request, response);
    }
}
