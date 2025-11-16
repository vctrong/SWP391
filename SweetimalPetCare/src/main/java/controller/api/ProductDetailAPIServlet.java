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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.product.Product;
import model.product.ProductImg;
import model.product.ProductVariant;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ProductDetailAPIServlet", urlPatterns = {"/api/ProductDetailAPI"})
public class ProductDetailAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductDetailAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductDetailAPIServlet at " + request.getContextPath() + "</h1>");
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

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        // Map để chứa dữ liệu JSON trả về
        Map<String, Object> responseData = new HashMap<>();

        try {
// 2. Lấy và xác thực tham số 'id'
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                // Lỗi 400 Bad Request: Thiếu ID
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseData.put("error", "Product ID is missing.");
                out.print(gson.toJson(responseData));
                out.flush();
                return;
            }

            long productId = Long.parseLong(idParam);

            // 3. Khởi tạo DAO
            ProductDAO productDAO = new ProductDAO();

            // 4. Gọi cả 3 hàm DAO mới
            Product product = productDAO.getProductForDetail(productId);
            ArrayList<ProductVariant> variants = productDAO.getAllVariantsByProductId(productId);
            ArrayList<ProductImg> images = productDAO.getAllImagesByProductId(productId);

            // 5. Kiểm tra xem có tìm thấy sản phẩm không
            if (product == null) {
                // Lỗi 404 Not Found: Không tìm thấy ID
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseData.put("error", "Product not found with ID: " + productId);
            } else {
                // 6. Gói dữ liệu (Thành công)
                // JavaScript mong đợi 3 key: 'product', 'variants', và 'images'
                responseData.put("product", product);
                responseData.put("variants", variants);
                responseData.put("images", images);
            }

            // 7. Gửi JSON về client
            out.print(gson.toJson(responseData));
        } catch (NumberFormatException e) {
            // Lỗi 400 Bad Request: ID không phải là số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseData.put("error", "Invalid Product ID format.");
            out.print(gson.toJson(responseData));
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
