package controller;

import daos.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("fp_verified") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("WEB-INF/login/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("fp_verified") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");
        if (password == null || confirm == null || !password.equals(confirm) || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu không hợp lệ hoặc không khớp (tối thiểu 6 ký tự).");
            request.getRequestDispatcher("WEB-INF/login/reset_password.jsp").forward(request, response);
            return;
        }

        String email = (String) session.getAttribute("fp_email");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        UserDAO dao = new UserDAO();
        boolean ok = dao.updatePasswordByEmail(email, password);
        if (ok) {
            // Clear FP flow state
            session.removeAttribute("fp_email");
            session.removeAttribute("fp_otp");
            session.removeAttribute("fp_otp_exp");
            session.removeAttribute("fp_verified");
            session.setAttribute("resetSuccess", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/login?view=login");
        } else {
            request.setAttribute("error", "Cập nhật mật khẩu thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("WEB-INF/login/reset_password.jsp").forward(request, response);
        }
    }
}
