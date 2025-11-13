package controller;

import daos.ConsultationRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import model.ConsultationRequest;
import model.Users;

@WebServlet(name = "ConsultationRequestServlet", urlPatterns = {"/consultation-request"})
public class ConsultationRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String customerName = request.getParameter("customer_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("request_message");

        // Build model
        ConsultationRequest cr = new ConsultationRequest();
        cr.setCustomerName(customerName != null ? customerName.trim() : null);
        cr.setEmail(email != null ? email.trim() : null);
        cr.setPhone(phone != null ? phone.trim() : null);
        cr.setSubject(subject != null ? subject.trim() : null);
        cr.setRequestMessage(message != null ? message.trim() : null);

        HttpSession session = request.getSession(false);
        Long userId = null;
        if (session != null) {
            Object uobj = session.getAttribute("user");
            if (uobj instanceof Users) {
                userId = Long.valueOf(((Users) uobj).getId());
            }
        }
        cr.setUserId(userId);
        cr.setStatusCode("PENDING");
        cr.setCreatedAt(LocalDateTime.now());

        ConsultationRequestDAO dao = new ConsultationRequestDAO();
        String validateMsg = dao.validate(cr);
        if (validateMsg != null) {
            // Redirect back to home with error message and anchor to #contact
            String msg = java.net.URLEncoder.encode(validateMsg, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/home?cr_success=0&cr_msg=" + msg + "#contact");
            return;
        }

        try {
            dao.create(cr);
            response.sendRedirect(request.getContextPath() + "/home?cr_success=1#contact");
        } catch (Exception ex) {
            String msg = java.net.URLEncoder.encode("Không thể gửi yêu cầu. Vui lòng thử lại sau.", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/home?cr_success=0&cr_msg=" + msg + "#contact");
        }
    }
}
