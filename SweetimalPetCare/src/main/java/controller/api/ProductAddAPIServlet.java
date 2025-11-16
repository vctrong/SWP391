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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.product.Product;
import model.product.ProductImg;
import model.product.ProductVariant;
import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.http.Part;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import utils.FileUploadUtil;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "ProductAddAPIServlet", urlPatterns = {"/api/ProductAddAPI"})
public class ProductAddAPIServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductAddAPIServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductAddAPIServlet at " + request.getContextPath() + "</h1>");
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

        ProductDAO productDAO = new ProductDAO();

        // Chuẩn bị các đối tượng để gửi cho DAO
        Product product = new Product();
        List<ProductVariant> variants = new ArrayList<>();
        List<ProductImg> images = new ArrayList<>();

        try {
            // --- BƯỚC 1: LẤY DỮ LIỆU TEXT (TỪ FORMDATA) ---
            product.setProductCode(request.getParameter("productCode"));
            product.setProductName(request.getParameter("productName"));
            product.setProductCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            product.setBrandId(Integer.parseInt(request.getParameter("brandId")));
            product.setDescription(request.getParameter("description"));
            product.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

            // --- BƯỚC 2: LẤY CHUỖI JSON (VARIANTS) VÀ PARSE ---
            String variantsJson = request.getParameter("variantsJson");
            if (variantsJson == null || variantsJson.isEmpty()) {
                throw new Exception("Product must have at least one variant.");
            }
            // Định nghĩa kiểu List<ProductVariant> cho Gson
            Type listType = new TypeToken<ArrayList<ProductVariant>>() {
            }.getType();
            variants = gson.fromJson(variantsJson, listType);

            // --- BƯỚC 3: LẤY FILE ẢNH & LƯU (DÙNG FileUploadUtil) ---
            // Lặp qua tất cả các 'part' trong request
            String renderInstanceId = System.getenv("RENDER_INSTANCE_ID");
            String uploadSubDir;

            if (renderInstanceId != null) {
                // Đang trên Render -> Dùng thư mục con
                uploadSubDir = FileUploadUtil.PRODUCT_UPLOAD_DIR;
            } else {
                // Đang ở Local -> KHÔNG dùng thư mục con (vì đường dẫn Gốc đã là thư mục cuối)
                uploadSubDir = ""; // <-- GỬI CHUỖI RỖNG
            }

            System.out.println("[Servlet DEBUG] Upload SubDirectory set to: '" + uploadSubDir + "'");

            for (Part part : request.getParts()) {
                String partName = part.getName();
                String submittedFileName = part.getSubmittedFileName();

                if ("images".equals(partName) && submittedFileName != null && !submittedFileName.isEmpty()) {

                    // Gọi hàm util với thư mục con đã được quyết định
                    String dbUrl = FileUploadUtil.saveFile(request, part, uploadSubDir);

                    if (dbUrl != null) {
                        ProductImg img = new ProductImg();
                        img.setImageUrl(dbUrl); // URL này sẽ là "local-uploads/..." hoặc "assets/products_img/..."
                        images.add(img);
                    }
                }
            }

            // --- BƯỚC 4: GỌI DAO TRANSACTION ---
            long newProductId = productDAO.addNewProductTransaction(product, variants, images);

            // --- BƯỚC 5: TRẢ VỀ KẾT QUẢ ---
            if (newProductId > 0) {
                Map<String, Object> successMsg = new HashMap<>();
                successMsg.put("success", true);
                successMsg.put("message", "Tạo sản phẩm thành công (ID: " + newProductId + ")");
                out.print(gson.toJson(successMsg));
            } else {
                throw new SQLException("Tạo sản phẩm thất bại, DAO không trả về ID.");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> errorMsg = new HashMap<>();
            errorMsg.put("success", false);
            errorMsg.put("error", "Database error: " + e.getMessage());
            out.print(gson.toJson(errorMsg));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, Object> errorMsg = new HashMap<>();
            errorMsg.put("success", false);
            // Sửa lại thông báo lỗi cho đúng
            errorMsg.put("error", "Invalid data or File Upload Error: " + e.getMessage());
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
