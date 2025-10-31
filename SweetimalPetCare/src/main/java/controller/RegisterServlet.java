package controller;

import utils.SendEmail;
import daos.RegisterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String birthday = request.getParameter("birthday");

        // Kiểm tra mật khẩu hợp lệ
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xác nhận mật khẩu
        if (confirm == null || !password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
            return;
        }

        RegisterDAO rdao = new RegisterDAO();

        try {
            // Kiểm tra username tồn tại
            if (rdao.isUsernameExist(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
                return;
            }

            // Gửi OTP xác minh email (chưa ghi DB)
            String otp = String.valueOf((int) (Math.random() * 900000) + 100000);
            boolean sent = SendEmail.sendOTP(email, otp);

            if (sent) {
                HttpSession session = request.getSession();
                // Lưu toàn bộ thông tin user tạm vào session
                session.setAttribute("otp", otp);
                session.setAttribute("username", username);
                session.setAttribute("password", password);
                session.setAttribute("email", email);
                session.setAttribute("phone", phone);
                session.setAttribute("fullname", fullname);
                session.setAttribute("gender", gender);
                session.setAttribute("birthday", birthday);

                // Chuyển đến trang xác thực OTP
                response.sendRedirect(request.getContextPath() + "/verifyOTPRegister");
                return;
            } else {
                request.setAttribute("error", "Không thể gửi OTP đến email. Vui lòng thử lại!");
            }

            request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi trong quá trình đăng ký: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
    }
}
