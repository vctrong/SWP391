package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verifyOTP"})
public class VerifyOTPServlet extends HttpServlet {

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/register/verifyOTP.jsp").forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");

        if (storedOTP != null && otp != null && otp.equals(storedOTP)) {
            
            session.removeAttribute("otp");

           
            response.sendRedirect(request.getContextPath() + "/registerSuccess");

        } else {
            request.setAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn!");
            request.getRequestDispatcher("WEB-INF/register/verifyOTP.jsp").forward(request, response);
        }
    }
}
