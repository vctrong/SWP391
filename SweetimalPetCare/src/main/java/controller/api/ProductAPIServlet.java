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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.product.Product;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "ProductAPIServlet", urlPatterns = {"/api/ProductAPI"})
public class ProductAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductAPIServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    // Giá trị pageSize mặc định nếu người dùng không cung cấp
    private static final int DEFAULT_PAGE_SIZE = 10;
    // Giới hạn pageSize để tránh lạm dụng
    private static final int MAX_PAGE_SIZE = 50;

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

        // Dùng PrintWriter để gửi chuỗi JSON về
        PrintWriter out = response.getWriter();

        // Khởi tạo Gson để chuyển đổi Java Object -> JSON
        Gson gson = new Gson();

        // Tạo một Map để chứa response cuối cùng
        // (Sẽ có dạng: { "products": [...], "pagination": {...} } )
        Map<String, Object> responseData = new HashMap<>();

        try {

            // 2. Lấy tham số từ request (từ file JS)
            String searchTerm = request.getParameter("search");
            String categoryParam = request.getParameter("category");
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");

            // 3. Xử lý giá trị mặc định (phòng trường hợp null)
            if (searchTerm == null) {
                searchTerm = "";
            }
            int categoryId = 0; // 0 = "All Categories"
            if (categoryParam != null && !categoryParam.isEmpty()) {
                categoryId = Integer.parseInt(categoryParam);
            }
            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
            }

            // Xử lý pageSize động (đã cập nhật)
            int pageSize = DEFAULT_PAGE_SIZE;
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeParam);
                // Validation: Đảm bảo pageSize nằm trong giới hạn cho phép
                if (pageSize < 5 || pageSize > MAX_PAGE_SIZE) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
            }

            // 4. Gọi DAO để lấy dữ liệu
            ProductDAO productDAO = new ProductDAO();

            // 4.1. Lấy tổng số sản phẩm (khớp với filter)
            int totalItems = productDAO.getTotalProductCount(searchTerm, categoryId);

            // 4.2. Tính toán phân trang
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);

            // 4.3. Lấy danh sách sản phẩm cho trang hiện tại
            ArrayList<Product> productList = productDAO.getProductsList(searchTerm, categoryId, currentPage, pageSize);

            // 5. Gói Dữ Liệu
            // 5.1. Tạo phần "pagination" mà JS mong đợi
            Map<String, Integer> paginationData = new HashMap<>();
            paginationData.put("currentPage", currentPage);
            paginationData.put("totalPages", totalPages);
            paginationData.put("totalItems", totalItems);

            // 5.2. Đặt 2 phần vào response chính
            responseData.put("products", productList);
            responseData.put("pagination", paginationData);

            // 6. Chuyển đổi đối tượng Java (responseData) thành chuỗi JSON
            String jsonResponse = gson.toJson(responseData);

            // 7. Gửi JSON về cho JavaScript
            out.print(jsonResponse);

        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu 'page' hoặc 'category' không phải là số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Lỗi 400
            responseData.put("error", "Invalid parameter format. Page, category, and pageSize must be numbers.");
            out.print(gson.toJson(responseData));
        } catch (Exception e) {
            // Xử lý các lỗi khác (ví dụ: lỗi SQL từ DAO)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Lỗi 500
            responseData.put("error", "An internal server error occurred: " + e.getMessage());
            out.print(gson.toJson(responseData));
            e.printStackTrace(); // In lỗi ra console server
        } finally {
            out.flush(); // Đẩy dữ liệu ra
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
