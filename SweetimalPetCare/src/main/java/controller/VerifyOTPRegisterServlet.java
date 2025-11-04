package controller;

import daos.RegisterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOTPRegisterServlet", urlPatterns = {"/verifyOTPRegister"})
public class VerifyOTPRegisterServlet extends HttpServlet {

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

           
            String username = (String) session.getAttribute("username");
            String password = (String) session.getAttribute("password");
            String email = (String) session.getAttribute("email");
            String phone = (String) session.getAttribute("phone");
            String fullname = (String) session.getAttribute("fullname");
            String gender = (String) session.getAttribute("gender");
            String birthday = (String) session.getAttribute("birthday");

            try {
                RegisterDAO dao = new RegisterDAO();
                boolean success = dao.createUser(username, password, email, phone, fullname, gender, birthday);

                if (success) {
                  
                    session.removeAttribute("otp");
                    session.removeAttribute("username");
                    session.removeAttribute("password");
                    session.removeAttribute("email");
                    session.removeAttribute("phone");
                    session.removeAttribute("fullname");
                    session.removeAttribute("gender");
                    session.removeAttribute("birthday");

                   
                    response.sendRedirect(request.getContextPath() + "/registerSuccess");
                } else {
                    request.setAttribute("error", "Không thể lưu thông tin tài khoản vào cơ sở dữ liệu!");
                    request.getRequestDispatcher("WEB-INF/register/verifyOTP.jsp").forward(request, response);
                }

            } catch (Exception e) {
                throw new ServletException("Lỗi khi ghi dữ liệu vào DB: " + e.getMessage(), e);
            }

        } else {
            
            request.setAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn!");
            request.getRequestDispatcher("WEB-INF/register/verifyOTP.jsp").forward(request, response);
        }
    }
}
