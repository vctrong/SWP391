/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import daos.ProfileDAO;
import dto.BookingHistoryDTO;
import dto.BookingSummary;
import dto.HistoryKPIs;
import dto.OrderHistoryDTO;
import dto.RecentActivity;
import dto.UserAddressDTO;
import dto.UserProfileDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@MultipartConfig
@WebServlet(name = "profileServlet", urlPatterns = {"/profile"})
public class profileServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet profileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet profileServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private final DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        String tab = request.getParameter("tab");
        ProfileDAO pfDAO = new ProfileDAO();
        BookingSummary bS = pfDAO.getNextBooking(user.getId());
        request.setAttribute("bookingNext", bS);
        if (tab.equals("overview")) {

            try {
                request.setAttribute("countOrder", pfDAO.getCountOrder(user.getId()));
                request.setAttribute("countBooking", pfDAO.getCountBooking(user.getId()));
                List<RecentActivity> listRecent;
                listRecent = pfDAO.getRecentActivities(user.getId(), 6);
                System.out.println(listRecent);
                request.setAttribute("recent", listRecent);
                request.getRequestDispatcher("WEB-INF/pages/profileUser.jsp").forward(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(profileServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

        } else if (tab.equals("history")) {
            HistoryKPIs kpis = pfDAO.getHistoryKPIs(user.getId());
            List<OrderHistoryDTO> orderList = pfDAO.getAllOrders(user.getId());
            List<BookingHistoryDTO> bookingList = pfDAO.getAllBookings(user.getId());

            // 4. Đặt dữ liệu vào request để gửi sang JSP
            request.setAttribute("kpis", kpis);             // Dữ liệu thống kê
            request.setAttribute("orderList", orderList);   // Danh sách đơn hàng
            request.setAttribute("bookingList", bookingList); // Danh sách booking
            request.getRequestDispatcher("WEB-INF/pages/history.jsp").forward(request, response);

        } else if (tab.equals("account")) {
            // 3. Gọi các phương thức DAO
            UserProfileDTO profile = pfDAO.getUserProfile(user.getId());
            List<UserAddressDTO> addressList = pfDAO.getUserAddresses(user.getId());

            // 4. Đặt dữ liệu vào request để gửi sang JSP
            request.setAttribute("profile", profile);       // Dữ liệu profile chính
            request.setAttribute("addressList", addressList);
            request.getRequestDispatcher("WEB-INF/pages/infoAccount.jsp").forward(request, response);
        } else if (tab.equals("policy")) {
            request.getRequestDispatcher("WEB-INF/pages/chinhSachDieuKhoan.jsp").forward(request, response);
        } else if (tab.equals("support")) {
            request.getRequestDispatcher("WEB-INF/pages/gopYHoTro.jsp").forward(request, response);
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo đọc UTF-8 (Tiếng Việt)

        // 1. Lấy user ID từ session
        HttpSession session = request.getSession();
        Users account = (Users) session.getAttribute("user");
        System.out.println(account);
        if (account == null) {
            sendJsonResponse(response, false, "Phiên đăng nhập đã hết hạn.");
            return;
        }
        long customerId = account.getId();

        // 2. Lấy tham số 'action' để phân loại request
        String action = request.getParameter("action");
        ProfileDAO dao = new ProfileDAO();
        boolean success = false;
        String message = "";

        if (action == null) {
            sendJsonResponse(response, false, "Hành động không xác định.");
            return;
        }

        // 3. Phân luồng xử lý
        switch (action) {
            case "updateProfile":
                try {
                // Lấy dữ liệu từ form
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                int gender = Integer.parseInt(request.getParameter("gender"));
                LocalDate birthday = LocalDate.parse(request.getParameter("birthday"), dtf);

                // Gọi DAO
                success = dao.updateUserProfile(customerId, fullName, phone, gender, birthday);
                message = success ? "Cập nhật thông tin thành công!" : "Cập nhật thất bại, vui lòng thử lại.";

            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi: Dữ liệu không hợp lệ.";
            }
            break;

            case "addAddress":
                try {
                // Lấy dữ liệu từ form
                String label = request.getParameter("label");
                String recipientName = request.getParameter("recipientName");
                String phone = request.getParameter("phone");
                String addressLine1 = request.getParameter("addressLine1");
                String ward = request.getParameter("ward");
                String district = request.getParameter("district");
                String city = request.getParameter("city");

                // Gọi DAO
                success = dao.addNewAddress(customerId, label, recipientName, phone, addressLine1, ward, district, city);
                message = success ? "Thêm địa chỉ thành công!" : "Thêm địa chỉ thất bại.";

            } catch (Exception e) {
                e.printStackTrace();
                message = "Lỗi: Dữ liệu không hợp lệ.";
            }
            break;

            case "changePassword":
                try {
                // Lấy dữ liệu từ form
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");

                // Validate
                if (newPassword == null || newPassword.length() < 6) {
                    message = "Mật khẩu mới phải từ 6 ký tự.";
                } else if (!newPassword.equals(confirmPassword)) {
                    message = "Mật khẩu xác nhận không khớp.";
                } else {
                    // Gọi DAO
                    String daoResult = dao.changePassword(customerId, oldPassword, newPassword);
                    switch (daoResult) {
                        case "SUCCESS":
                            success = true;
                            message = "Thay đổi mật khẩu thành công!";
                            break;
                        case "WRONG_PASSWORD":
                            message = "Mật khẩu cũ không chính xác.";
                            break;
                        default:
                            message = "Đã xảy ra lỗi, vui lòng thử lại.";
                            break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Đã xảy ra lỗi hệ thống.";
            }
            break;

            default:
                message = "Hành động không được hỗ trợ.";
                break;
        }

        // 4. Gửi JSON response về cho JavaScript
        sendJsonResponse(response, success, message);

    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        // Tạo JSON thủ công (Bạn có thể dùng thư viện Gson nếu muốn)
        out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
        out.flush();
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
