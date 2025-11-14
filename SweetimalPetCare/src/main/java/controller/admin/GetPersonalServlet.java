/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import com.google.gson.Gson;
import daos.admin.UserDAO;
import dto.StaffDTO;
import dto.UserDTO;
import dto.VetDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "GetPersonalServlet", urlPatterns = {"/admin/GetPersonal"})
public class GetPersonalServlet extends HttpServlet {

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
            out.println("<title>Servlet GetPersonalServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetPersonalServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy tham số từ JS (action và role)
        String action = request.getParameter("action");
        String roleIdStr = request.getParameter("role");

        // Mặc định role = 1 (Customer) nếu không truyền
        int roleId = 1;
        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdStr);
            } catch (NumberFormatException e) {
                roleId = 1;
            }
        }

        try ( PrintWriter out = response.getWriter()) {
            // 3. Gọi DAO lấy dữ liệu
            UserDAO dao = new UserDAO();

            // JS gửi ?action=list (kiểm tra cho chắc)
            if ("list".equals(action)) {
                List<UserDTO> list = dao.getAllUsersByRole(roleId);

                // 4. Chuyển List Java -> JSON String bằng Gson
                Gson gson = new Gson();
                String json = gson.toJson(list);

                // 5. Trả về cho trình duyệt
                out.print(json);
                out.flush();
            } else {
                // Trường hợp action lạ thì trả về mảng rỗng
                out.print("[]");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // Trả về JSON lỗi nếu cần
            response.getWriter().print("{\"error\": \"Server Error\"}");
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
        request.setCharacterEncoding("UTF-8");

        try {

            String action = request.getParameter("action"); // "add" hoặc "update"

            String username = request.getParameter("username");
            String rawPassword = request.getParameter("password"); // Có thể rỗng nếu update
            String email = request.getParameter("email");
            String fullName = request.getParameter("full_name");
            String phone = request.getParameter("phone");

            String genderStr = request.getParameter("gender");
            int gender = (genderStr != null) ? Integer.parseInt(genderStr) : 1;

            String roleIdStr = request.getParameter("role_id");
            int roleId = Integer.parseInt(roleIdStr);

            // --- XỬ LÝ NGÀY TUYỂN DỤNG (HIRE DATE) ---
            java.sql.Date hireDate = null;
            String hireDateStr = request.getParameter("hire_date");

            // Chỉ xử lý nếu là Staff/Vet
            if (roleId == 2 || roleId == 3) {
                if (hireDateStr != null && !hireDateStr.isEmpty()) {
                    try {
                        hireDate = java.sql.Date.valueOf(hireDateStr);
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    }
                } else if ("add".equals(action)) {
                    // Nếu thêm mới mà quên nhập -> lấy ngày hiện tại
                    hireDate = new java.sql.Date(System.currentTimeMillis());
                }
                // Nếu update mà rỗng -> DAO/Database có thể giữ nguyên hoặc set null tùy logic bạn muốn
            }

            // 2. TẠO ĐỐI TƯỢNG DTO (Dùng chung cho cả Add và Update)
            UserDTO userToProcess;

            if (roleId == 3) { // Vet
                VetDTO vet = new VetDTO();
                vet.setPositionTitle(request.getParameter("position_title"));
                vet.setHireDate(hireDate);
                vet.setSpecialty(request.getParameter("specialty"));
                vet.setLicenseNumber(request.getParameter("license_number"));
                userToProcess = vet;
            } else if (roleId == 2) { // Staff
                StaffDTO staff = new StaffDTO();
                staff.setPositionTitle(request.getParameter("position_title"));
                staff.setHireDate(hireDate);
                userToProcess = staff;
            } else { // Customer
                userToProcess = new UserDTO();
            }

            // Set thông tin chung
            userToProcess.setUsername(username);
            userToProcess.setEmail(email);
            userToProcess.setFullName(fullName);
            userToProcess.setPhone(phone);
            userToProcess.setGender(gender);
            userToProcess.setRoleId(roleId);
            userToProcess.setIsActive(true);

            // 3. PHÂN LOẠI XỬ LÝ (ADD vs UPDATE)
            UserDAO dao = new UserDAO();
            boolean success = false;

            if ("update".equals(action)) {
                // --- LOGIC UPDATE ---
                // Lấy ID từ input hidden
                long userId = Long.parseLong(request.getParameter("user_id"));
                userToProcess.setUserId(userId);

                // Gọi hàm update (Password có thể rỗng, DAO tự lo việc check null)
                success = dao.updateUser(userToProcess);

            } else {
                // --- LOGIC ADD ---
                userToProcess.setAvatarUrl(""); // Default avatar
                success = dao.addUser(userToProcess, rawPassword);
            }

            // 4. TRẢ KẾT QUẢ
            String redirectUrl = request.getContextPath() + "/admin/personnel?status=";
            if (success) {
                redirectUrl += "success";
            } else {
                redirectUrl += "fail";
            }
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi hệ thống thì báo lỗi
            response.sendRedirect(request.getContextPath() + "/admin/personnel?status=error");
        }
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
