/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import daos.admin.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "addServicePackagesServlet", urlPatterns = {"/admin/addServicePackage"})
public class addServicePackagesServlet extends HttpServlet {

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
            out.println("<title>Servlet addServicePackagesServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addServicePackagesServlet at " + request.getContextPath() + "</h1>");
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
        response.sendRedirect(request.getContextPath() + "/admin/service");
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
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String packageCode = request.getParameter("package_code");
        String packageName = request.getParameter("package_name");
        String packagePriceStr = request.getParameter("package_price");
        String status = request.getParameter("status");
        String descriptionBase = request.getParameter("description");
        String desctiption = descriptionBase == null ? "" : descriptionBase.trim();
        BigDecimal price = null;

        if (packageCode == null || packageCode.trim().isEmpty()
                || packageName == null || packageName.trim().isEmpty()) {
            session.setAttribute("message", "Lỗi: Vui lòng không để trống Mã gói và Tên gói.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }
        try {
            price = new BigDecimal(packagePriceStr);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Lỗi: Giá gói không hợp lệ (null, sai định dạng, hoặc là số âm).");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?create=fail");
            return;
        }
        ServiceDAO sDAO = new ServiceDAO();
        if (sDAO.exitsPackageCode(packageCode)) {
            session.setAttribute("message", "Lỗi: Mã gói dịch vụ '" + packageCode + "' đã tồn tại.");
            System.out.println(session.getAttribute("message"));
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?createPackage=fail");
            return;
        }
        if (sDAO.createServicePackage(packageCode, packageName, desctiption, status, price) > 0) {
            session.setAttribute("message", "Thêm Gói dịch vụ thành công!");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/service?createPackage=succsess");
        } else {
            session.setAttribute("message", "Lỗi: Không thể thêm Gói dịch vụ. Vui lòng kiểm tra CSDL.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/service?createPackage=fail");
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
