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
import model.bookingAdmin.Booking;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "GetBookingDetailServlet", urlPatterns = {"/admin/GetBookingDetail"})
public class GetBookingDetailServlet extends HttpServlet {

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
            out.println("<title>Servlet GetBookingDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetBookingDetailServlet at " + request.getContextPath() + "</h1>");
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
            String idStr = request.getParameter("id");

            if (idStr != null) {
                long id = Long.parseLong(idStr);
                BookingDAO dao = new BookingDAO();
                Booking b = dao.getBookingByID(id);

                if (b != null) {
                    // Chuyển Object thành JSON
                    Gson gson = new Gson();
                    out.print(gson.toJson(b));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
        try {
            long id = Long.parseLong(request.getParameter("id"));
            String newStatus = request.getParameter("status");

            // 2. Gọi DAO update
            BookingDAO dao = new BookingDAO();
            boolean success = dao.updateBookingStatus(id, newStatus);

            // 3. Trả về kết quả
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK); // 200 OK
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Update failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
