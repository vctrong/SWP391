/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.api;

import com.google.gson.Gson;
import daos.admin.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.product.Brand;
import model.product.ProductCategory;
import model.product.ProductUpdatePayload;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ProductEditAPIServlet", urlPatterns = {"/api/ProductEditAPI"})
public class ProductEditAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductEditAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductEditAPIServlet at " + request.getContextPath() + "</h1>");
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
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> responseData = new HashMap<>();

        try {
            // 1. Khởi tạo DAOs
            ProductDAO pDAO = new ProductDAO();

            // 2. Lấy dữ liệu
            ArrayList<ProductCategory> categories = pDAO.getAllCate();
            ArrayList<Brand> brands = pDAO.getAllBrands();

            // 3. Gói dữ liệu (JS mong đợi "categories" và "brands")
            responseData.put("categories", categories);
            responseData.put("brands", brands);

            // 4. Trả JSON
            out.print(gson.toJson(responseData));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("error", "Server error while fetching form data: " + e.getMessage());
            out.print(gson.toJson(responseData));
            e.printStackTrace();
        } finally {
            out.flush();
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        // 1. Đọc JSON Payload từ body
        StringBuilder sb = new StringBuilder();
        String line;

        try ( BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String jsonPayload = sb.toString();

        try {
            // 2. Chuyển JSON thành Java Objects
            ProductUpdatePayload payload = gson.fromJson(jsonPayload, ProductUpdatePayload.class);

            if (payload == null || payload.getProduct() == null || payload.getVariants() == null) {
                throw new Exception("Invalid payload format.");
            }

            // 3. Gọi DAO (Hàm Transaction)
            ProductDAO productDAO = new ProductDAO();

            // Hàm updateProductAndVariants() là hàm có transaction mà bạn đã tạo
            boolean success = productDAO.updateProductAndVariants(payload.getProduct(), payload.getVariants());

            if (success) {
                // 4. Trả về thành công
                Map<String, Object> successMsg = new HashMap<>();
                successMsg.put("success", true);
                successMsg.put("message", "Product updated successfully.");
                out.print(gson.toJson(successMsg));
            } else {
                throw new Exception("Update failed for an unknown reason.");
            }

        } catch (SQLException e) {
            // Lỗi từ CSDL (thường là transaction rollback)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> errorMsg = new HashMap<>();
            errorMsg.put("success", false);
            errorMsg.put("error", "Database error: " + e.getMessage());
            out.print(gson.toJson(errorMsg));
            e.printStackTrace();
        } catch (Exception e) {
            // Lỗi (ví dụ: JSON sai cú pháp, payload null)
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, Object> errorMsg = new HashMap<>();
            errorMsg.put("success", false);
            errorMsg.put("error", "Database error: " + e.getMessage());
            out.print(gson.toJson(errorMsg));
            e.printStackTrace();
        } finally {
            out.flush();
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
