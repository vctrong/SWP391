/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import com.google.gson.Gson;
import daos.admin.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import model.Users;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "VetVisitUpdateServlet", urlPatterns = {"/admin/VetVisitUpdate"})
public class VetVisitUpdateServlet extends HttpServlet {

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
            out.println("<title>Servlet VetVisitUpdateServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VetVisitUpdateServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        processRequest(request, response);
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            // 1. KIỂM TRA QUYỀN (Bắt buộc phải là VET)
            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null || currentUser.getRole() != 3) { // 3 là Role Vet
                throw new Exception("Bạn không có quyền thực hiện chức năng này!");
            }

            // 2. LẤY DỮ LIỆU TỪ FORM & ÉP KIỂU
            long bookingId = Long.parseLong(request.getParameter("bookingId"));
            long petId = Long.parseLong(request.getParameter("petId"));
            long ownerId = Long.parseLong(request.getParameter("customerId"));
            long vetStaffId = currentUser.getId(); // Lấy ID bác sĩ từ session

            String visitType = request.getParameter("visitType");

            // Parse Ngày giờ khám (HTML datetime-local trả về: "2025-11-14T21:30")
            String visitDateStr = request.getParameter("visitDate");
            Timestamp visitDate = Timestamp.valueOf(visitDateStr.replace("T", " ") + ":00");

            // Parse Cân nặng & Nhiệt độ (Có thể rỗng)
            String wStr = request.getParameter("weight");
            BigDecimal weight = (wStr != null && !wStr.isEmpty()) ? new BigDecimal(wStr) : null;

            String tStr = request.getParameter("temperature");
            BigDecimal temperature = (tStr != null && !tStr.isEmpty()) ? new BigDecimal(tStr) : null;

            String symptoms = request.getParameter("symptoms");
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");

            // Parse Ngày tái khám (Có thể rỗng)
            String fDateStr = request.getParameter("followUpDate");
            Date followUpDate = (fDateStr != null && !fDateStr.isEmpty()) ? Date.valueOf(fDateStr) : null;

            // 3. GỌI DAO (Truyền tham số trực tiếp, KHÔNG CẦN MODEL)
            BookingDAO dao = new BookingDAO();
            boolean success = dao.insertVetVisit(
                    bookingId, petId, ownerId, vetStaffId, visitType, visitDate,
                    weight, temperature, symptoms, diagnosis, treatment, followUpDate
            );

            if (success) {
                result.put("success", true);
            } else {
                throw new Exception("Lỗi Database: Không thể lưu bệnh án.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        out.print(gson.toJson(result));
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
