package controller;

import Utils.SendEmail;
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

        // Kiểm tra cơ bản
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
            return;
        }

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

            // Tạo người dùng mới (lưu password đã mã hóa trong DAO)
            boolean created = rdao.createUser(username, password, email, phone, fullname, gender, birthday);

            if (created) {
                // Tạo và gửi OTP như trước
                HttpSession session = request.getSession(); // tạo session nếu chưa có
                String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

                boolean sent = SendEmail.sendOTP(email, otp);

                if (sent) {
                    session.setAttribute("otp", otp);
                    session.setAttribute("email", email);
                    session.setAttribute("username", username);

                    response.sendRedirect(request.getContextPath() + "/verifyOTP");
                    return;
                } else {
                    request.setAttribute("error", "Không thể gửi OTP đến email. Vui lòng thử lại!");
                    request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "Đăng ký thất bại!");
                request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            // Log lỗi (tùy project bạn có logger hay không)
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
    }
}
