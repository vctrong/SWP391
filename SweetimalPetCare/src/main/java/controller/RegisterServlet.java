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

            if (rdao.isUsernameExist(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
                return;
            }

            boolean created = rdao.createUser(username, password, email, phone, fullname, gender, birthday);

            if (created) {

                HttpSession session = request.getSession();
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

            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/register/register.jsp").forward(request, response);
    }
}
