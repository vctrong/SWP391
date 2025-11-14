package controller;

import daos.ConsultationRequestDAO;
import daos.ConsultationTypeDAO;
import model.ConsultationType;
import utils.ConsultationRequestValidator;
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
        String consultationTypeParam = request.getParameter("consultation_type_id");
        String message = request.getParameter("request_message");

        ConsultationRequest cr = new ConsultationRequest();
        cr.setCustomerName(customerName != null ? customerName.trim() : null);
        cr.setEmail(email != null ? email.trim() : null);
        cr.setPhone(phone != null ? phone.trim() : null);
        Integer consultationTypeId = null;
        if (consultationTypeParam != null && !consultationTypeParam.trim().isEmpty()) {
            try {
                consultationTypeId = Integer.valueOf(consultationTypeParam);
            } catch (NumberFormatException ignore) {
                consultationTypeId = null;
            }
        }
        cr.setConsultationTypeId(consultationTypeId);
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
        if (consultationTypeId != null) {
            try {
                ConsultationTypeDAO typeDao = new ConsultationTypeDAO();
                ConsultationType ct = typeDao.findById(consultationTypeId);
                if (ct == null || ct.getActive() == null || !ct.getActive()) {
                    String msg = java.net.URLEncoder.encode("Loại tư vấn không hợp lệ.", "UTF-8");
                    response.sendRedirect(request.getContextPath() + "/home?cr_success=0&cr_msg=" + msg + "#contact");
                    return;
                }
            } catch (Exception ex) {
                String msg = java.net.URLEncoder.encode("Không thể kiểm tra loại tư vấn.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/home?cr_success=0&cr_msg=" + msg + "#contact");
                return;
            }
        }
        String validateMsg = ConsultationRequestValidator.validate(cr);
        if (validateMsg != null) {
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
