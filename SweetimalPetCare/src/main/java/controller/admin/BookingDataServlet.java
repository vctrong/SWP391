/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import com.google.gson.Gson;
import daos.admin.BookingDAO;
import dto.CalendarEventDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.util.List;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "BookingDataServlet", urlPatterns = {"/admin/BookingData"})
public class BookingDataServlet extends HttpServlet {

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
            out.println("<title>Servlet BookingDataServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingDataServlet at " + request.getContextPath() + "</h1>");
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try ( PrintWriter out = response.getWriter()) {
            String startParam = request.getParameter("start");
            String endParam = request.getParameter("end");

            Date startDate = null;
            Date endDate = null;

            if (startParam != null && endParam != null) {
                // Cắt lấy 10 ký tự đầu (yyyy-MM-dd)
                if (startParam.length() > 10) {
                    startParam = startParam.substring(0, 10);
                }
                if (endParam.length() > 10) {
                    endParam = endParam.substring(0, 10);
                }

                startDate = Date.valueOf(startParam);
                endDate = Date.valueOf(endParam);
            } else {
                // Fallback nếu không có tham số (lấy ngày hiện tại)
                long millis = System.currentTimeMillis();
                startDate = new Date(millis);
                endDate = new Date(millis + (7 * 24 * 60 * 60 * 1000)); // +7 ngày
            }

            // 2. Gọi DAO lấy dữ liệu
            BookingDAO dao = new BookingDAO();
            List<CalendarEventDTO> events = dao.getBookingForCalendar(startDate, endDate);

            // 3. Chuyển List -> JSON string bằng thư viện Gson
            Gson gson = new Gson();
            String jsonResult = gson.toJson(events);

            // 4. Trả về cho trình duyệt
            out.print(jsonResult);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
        processRequest(request, response);
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
