package controller.admin;

import daos.ConsultationRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DeleteConsultationRequestServlet", urlPatterns = {"/admin/contact/delete"})
public class DeleteConsultationRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String pageParam = request.getParameter("page");
        long id = -1L;
        try {
            id = Long.parseLong(idParam);
        } catch (Exception ignore) {
        }

        if (id > 0) {
            ConsultationRequestDAO dao = new ConsultationRequestDAO();
            dao.deleteById(id);
        } else {
            request.getSession().setAttribute("deleteError", "ID yêu cầu không hợp lệ.");
        }

        String redirectUrl = request.getContextPath() + "/admin/contact" + (pageParam != null && !pageParam.isEmpty() ? ("?page=" + pageParam) : "");
        response.sendRedirect(redirectUrl);
    }
}
