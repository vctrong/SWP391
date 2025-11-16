/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class FileUploadUtil {

    /**
     * Thư mục con cho sản phẩm (chỉ dùng trên Render, vì đường dẫn local đã bao
     * gồm tên thư mục).
     */
    public static final String PRODUCT_UPLOAD_DIR = "assets/products_img";

    /**
     * Đường dẫn URL ảo (virtual path) khi chạy Local. (Phải khớp với <Context>
     * trong server.xml của Tomcat).
     */
    private static final String LOCAL_URL_PATH = "local-uploads";

    private static String getBaseUploadPath(HttpServletRequest request) {

        // Render.com tự động set biến môi trường "RENDER_INSTANCE_ID"
        String renderInstanceId = System.getenv("RENDER_INSTANCE_ID");

        if (renderInstanceId != null) {
            // 1. ĐANG CHẠY TRÊN RENDER
            // Trả về đường dẫn GỐC của Disk (ví dụ: /data/uploads)
            System.out.println("[FileUploadUtil] Render Env. Dùng Disk GỐC: /data/uploads");
            return "/data/uploads";

        } else {
            // 2. ĐANG CHẠY LOCAL
            // Trả về đường dẫn CỨNG (hardcoded) mà bạn chỉ định
            String localPath = "D:/BackUp_Important/ChuyenNganh/KY5/SWP391/SWP391/products_img";
            System.out.println("[FileUploadUtil] Local Env. Dùng đường dẫn CỨNG: " + localPath);
            return localPath;
        }
    }

    /**
     * Lưu file (từ Part) vào thư mục đã chọn (Local hoặc Render) và trả về
     * đường dẫn URL tương đối để lưu vào CSDL.
     *
     * @param request HttpServletRequest
     * @param filePart Part của file
     * @param relativeUploadDir Thư mục con (VD: "assets/products_img" cho
     * Render, hoặc "" (rỗng) cho Local)
     * @return Đường dẫn URL (ví dụ: "assets/products_img/file.jpg" hoặc
     * "local-uploads/file.jpg")
     * @throws Exception Nếu lưu file thất bại
     */
    public static String saveFile(HttpServletRequest request, Part filePart, String relativeUploadDir) throws Exception {

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isEmpty()) {
            return null; // Không có file
        }

        // Lấy đường dẫn GỐC (Base Path) tự động
        String baseUploadPath = getBaseUploadPath(request);

        // Nối đường dẫn Gốc và đường dẫn Tương đối (nếu có)
        String fullUploadPath = baseUploadPath;
        if (relativeUploadDir != null && !relativeUploadDir.isEmpty()) {
            fullUploadPath = baseUploadPath + File.separator + relativeUploadDir;
        }

        // --- Đảm bảo thư mục tồn tại và có quyền ghi ---
        File uploadDir = new File(fullUploadPath);
        if (!uploadDir.exists()) {
            System.out.println("[FileUploadUtil] Tạo thư mục: " + fullUploadPath);
            uploadDir.mkdirs(); // Tạo thư mục
        }

        if (!uploadDir.canWrite()) {
            System.err.println("[FileUploadUtil] LỖI: Không có quyền ghi vào: " + fullUploadPath);
            throw new Exception("Lỗi quyền: Không thể ghi file vào: " + fullUploadPath);
        }
        // --- Kết thúc kiểm tra ---

        // Tạo tên file duy nhất
        String fileExtension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        String savePath = fullUploadPath + File.separator + uniqueFileName;

        // Lưu file
        try ( InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(savePath), StandardCopyOption.REPLACE_EXISTING);
        }

        // Trả về URL chính xác
        String renderInstanceId = System.getenv("RENDER_INSTANCE_ID");
        if (renderInstanceId != null) {
            // 1. RENDER: Trả về URL thật (ví dụ: "assets/products_img/file.jpg")
            return relativeUploadDir.replace(File.separator, "/") + "/" + uniqueFileName;
        } else {
            // 2. LOCAL: Trả về URL ảo (ví dụ: "local-uploads/file.jpg")
            return "/" + LOCAL_URL_PATH + "/" + uniqueFileName;
        }
    }
}
