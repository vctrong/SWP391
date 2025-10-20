package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verify-otp"})
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        Long exp = (Long) session.getAttribute("fp_otp_exp");
        if (exp != null) {
            request.setAttribute("otpExpiry", exp);
        }
        
        request.getRequestDispatcher("WEB-INF/login/verify_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String inputOtp = request.getParameter("otp");
        String sessionOtp = (String) session.getAttribute("fp_otp");
        Long exp = (Long) session.getAttribute("fp_otp_exp");

        if (sessionOtp == null || exp == null || System.currentTimeMillis() > exp) {
            request.setAttribute("error", "OTP đã hết hạn. Vui lòng yêu cầu lại.");
            request.getRequestDispatcher("WEB-INF/login/forgot_password.jsp").forward(request, response);
            return;
        }

        if (inputOtp == null || !inputOtp.equals(sessionOtp)) {
            request.setAttribute("error", "OTP không đúng.");
            request.setAttribute("otpExpiry", exp);
            request.getRequestDispatcher("WEB-INF/login/verify_otp.jsp").forward(request, response);
            return;
        }

        // Mark OTP verified
        session.setAttribute("fp_verified", Boolean.TRUE);
        // Clear OTP after successful verification
        session.removeAttribute("fp_otp");
        session.removeAttribute("fp_otp_exp");
        request.getRequestDispatcher("WEB-INF/login/reset_password.jsp").forward(request, response);
    }
}
