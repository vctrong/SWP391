/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import com.google.gson.Gson;
import daos.admin.ServiceDAO;
import dto.ResquestServiceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ServiceAPIServlet", urlPatterns = {"/api/ServiceAPI"})
public class ServiceAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ServiceAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ServiceAPIServlet at " + request.getContextPath() + "</h1>");
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
        ServiceDAO sDAO = new ServiceDAO();
        Gson gson = new Gson();
        try ( PrintWriter out = response.getWriter();  BufferedReader reader = request.getReader()) {

            ResquestServiceDTO rSDTO = gson.fromJson(reader, ResquestServiceDTO.class);
            if (rSDTO == null || rSDTO.getType() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(new Error("Dữ liệu yêu cầu không hợp lệ")));
                return;
            }

            long id = rSDTO.getId();
            System.out.println("day la id: " + id);
            String type = rSDTO.getType();
            System.out.println("day la type: " + type);
            Object resultData = null;

            if ("Service".equalsIgnoreCase(type)) {
                resultData = sDAO.getServiceByID(id);
            } else if ("Package".equalsIgnoreCase(type)) {
                resultData = sDAO.getPackageServiceByID(id);
                System.out.println("day la ket qua tim tu dao: " + sDAO.getPackageServiceByID(id));
            }
            if (resultData != null) {
                out.print(gson.toJson(resultData));
                System.out.println("day la resuDAa " + gson.toJson(resultData));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(new Error("Không tìm thấy dữ liệu với ID: " + id)));
                System.out.println("Không tìm thấy dữ liệu với ID: " + id);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            if (!response.isCommitted()) {
                response.getWriter().print("{\"error\": \"Đã xảy ra lỗi phía máy chủ.\"}");
            }
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
