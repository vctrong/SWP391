/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import com.google.gson.Gson;
import daos.admin.ServiceDAO;
import dto.ServiceForListPackageDTO;
import dto.serviceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.service.packageItem;
import model.service.service;
import model.service.servicePackage;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ServiceEditAPIServlet", urlPatterns = {"/api/ServiceEditAPI"})
public class ServiceEditAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ServiceEditAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServiceEditAPIServlet at " + request.getContextPath() + "</h1>");
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
        ServiceDAO sDAO = new ServiceDAO();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        Map<String, String> jsonResponse = new HashMap<>();

        try ( PrintWriter out = response.getWriter()) {
            String idStr = request.getParameter("id");
            String type = request.getParameter("type"); // "Service" hoặc "Package"
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            String code = request.getParameter("code"); // Thường không sửa code, nhưng cứ lấy nếu cần
            if (idStr == null || type == null || name == null || name.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Lỗi 400
                out.print("{\"status\":\"error\", \"message\":\"Dữ liệu không hợp lệ\"}");
                return;
            }

            long id = Long.parseLong(idStr);

            // Sử dụng BigDecimal cho giá tiền để chính xác hơn double
            BigDecimal price = (priceStr == null || priceStr.isEmpty()) ? BigDecimal.ZERO : new BigDecimal(priceStr);

            boolean isUpdated = false;

            if ("Service".equalsIgnoreCase(type)) {
                service oldS = sDAO.getServiceByID(id);
                boolean isTryingToInactive = oldS.getStatus().equalsIgnoreCase("active") && status.equalsIgnoreCase("inactive");
                if (isTryingToInactive) {
                    // Giả sử hàm này trả về TRUE nếu CÓ booking
                    if (sDAO.checkBookingService(id)) {

                        // 3. Nếu CÓ booking, DỪNG LẠI và gửi lỗi cụ thể
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Lỗi 400
                        jsonResponse.put("status", "error");
                        jsonResponse.put("message", "Không thể vô hiệu hóa! Dịch vụ này đang có lịch hẹn.");
                        out.print(gson.toJson(jsonResponse));
                        return; // <<< RẤT QUAN TRỌNG: Dừng thực thi
                    }
                    // Nếu không có booking, code sẽ tự động tiếp tục xuống phần update
                }
                // === XỬ LÝ CẬP NHẬT SERVICE ===
                String durationStr = request.getParameter("duration");
                String categoryIdStr = request.getParameter("categoryId");

                int duration = (durationStr == null || durationStr.isEmpty()) ? 0 : Integer.parseInt(durationStr);
                int categoryId = (categoryIdStr == null || categoryIdStr.isEmpty()) ? 0 : Integer.parseInt(categoryIdStr);

                isUpdated = sDAO.updateService(categoryId, code, name, description, duration, price, status, id) > 0;

            } else if ("Package".equalsIgnoreCase(type)) {

                servicePackage oldP = sDAO.getPackageServiceByID(id);
                boolean isTryingToInactive = oldP.getStatus().equalsIgnoreCase("active") && status.equalsIgnoreCase("inactive");
                if (isTryingToInactive) {
                    if (sDAO.checkBookingPackage(id)) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Lỗi 400
                        jsonResponse.put("status", "error");
                        jsonResponse.put("message", "Không thể vô hiệu hóa! Gói dịch vụ này đang có lịch hẹn.");
                        out.print(gson.toJson(jsonResponse));
                        return;
                    }
                }

                String[] itemServiceIds = request.getParameterValues("packageItemServiceId[]");
                String[] itemQuantities = request.getParameterValues("packageItemQuantity[]");

                List<packageItem> newItemList = new ArrayList<>();
                if (itemServiceIds != null && itemQuantities != null) {
                    for (int i = 0; i < itemServiceIds.length; i++) {
                        if (itemServiceIds[i] != null && !itemServiceIds[i].isEmpty()) {
                            long sId = Long.parseLong(itemServiceIds[i]);
                            int qty = Integer.parseInt(itemQuantities[i]);
                            newItemList.add(new packageItem(id, sId, qty));
                        }
                    }
                }
                isUpdated = sDAO.updatePackageService(id, name, price, status, description, newItemList) > 0;
            }

            if (isUpdated) {
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Cập nhật thành công!");
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Cập nhật thất bại. Vui lòng thử lại.");
            }
            out.print(gson.toJson(jsonResponse));
//            response.sendRedirect(request.getContextPath() + "/admin/service");
        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi phía server để debug
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            // Cố gắng trả về JSON lỗi nếu có thể
            try {
                response.getWriter().print("{\"status\":\"error\", \"message\":\"Lỗi Server: " + e.getMessage() + "\"}");
            } catch (IOException ex) {
                /* Không làm gì được nữa nếu response đã commited */ }
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
