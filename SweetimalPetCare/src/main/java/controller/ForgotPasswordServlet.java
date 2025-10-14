package controller;

import daos.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import jakarta.mail.MessagingException;
import utils.EmailUtility;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/login/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("WEB-INF/login/forgot_password.jsp").forward(request, response);
            return;
        }
        if (userDAO.findByEmail(email) == null) {
            // Không tiết lộ sự tồn tại của email
            request.setAttribute("message", "Nếu email tồn tại, OTP sẽ được gửi trong giây lát.");
            request.getRequestDispatcher("WEB-INF/login/forgot_password.jsp").forward(request, response);
            return;
        }

        String otp = String.format("%06d", new SecureRandom().nextInt(1_000_000));
        long expiresAt = System.currentTimeMillis() + 3 * 60 * 1000;
        HttpSession session = request.getSession(true);
        session.setAttribute("fp_email", email);
        session.setAttribute("fp_otp", otp);
        session.setAttribute("fp_otp_exp", expiresAt);

        try {
            String subject = "Mã OTP đặt lại mật khẩu";
            String content = "Mã OTP của bạn là: " + otp + "\nMã có hiệu lực trong 3 phút.";
            String user = getServletContext().getInitParameter("MAIL_USER");
            String pass = getServletContext().getInitParameter("MAIL_PASS");
            if (user != null && !user.isEmpty() && pass != null && !pass.isEmpty()) {
                EmailUtility.sendEmailWithAuth(email, subject, content, user, pass);
            } else {
                EmailUtility.sendEmail(email, subject, content);
            }
        } catch (MessagingException ex) {
            request.setAttribute("error", "Gửi email thất bại: " + ex.getMessage());
            request.getRequestDispatcher("WEB-INF/login/forgot_password.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("WEB-INF/login/verify_otp.jsp").forward(request, response);
    }
}
