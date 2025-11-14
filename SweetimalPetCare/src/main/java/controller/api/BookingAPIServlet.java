/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import daos.admin.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.bookingAdmin.Booking;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "BookingAPIServlet", urlPatterns = {"/api/Booking"})
public class BookingAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet BookingAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingAPIServlet at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {

            String search = request.getParameter("search");
            String status = request.getParameter("status");

            // Mặc định trang 1, pageSize 6 nếu không có tham số
            int pageIndex = 1;
            int pageSize = 6;

            try {
                if (request.getParameter("page") != null) {
                    pageIndex = Integer.parseInt(request.getParameter("page"));
                }
                if (request.getParameter("pageSize") != null) {
                    pageSize = Integer.parseInt(request.getParameter("pageSize"));
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
                pageSize = 6;
            }

            BookingDAO dao = new BookingDAO();

            // A. Đếm tổng số dòng (để tính số trang)
            int totalRecords = dao.countBookings(search, status);

            // B. Tính tổng số trang
            // Công thức: Math.ceil(total / size)
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // C. Lấy danh sách dữ liệu cho trang hiện tại
            List<Booking> list = dao.getBookingsByPage(search, status, pageIndex, pageSize);

            // 4. Đẩy dữ liệu sang JSP "Con" (booking_rows.jsp)
            request.setAttribute("bookingList", list);
            request.setAttribute("totalRecords", totalRecords); // Gửi tổng số dòng để hiện badge "Total: ..."
            request.setAttribute("totalPages", totalPages);     // Gửi tổng số trang để vẽ nút phân trang
            request.setAttribute("currentPage", pageIndex);
            request.getRequestDispatcher("/WEB-INF/admin/includes/bookingRow.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            // Nếu lỗi server thì trả về mã lỗi để JS catch được
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing booking data");
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
