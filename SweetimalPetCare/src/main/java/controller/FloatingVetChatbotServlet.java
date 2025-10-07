package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;

/**
 *
 * @author Nguyen Lam Thanh Luan - CE190980
 */

@WebServlet(name = "FloatingVetChatbotServlet", urlPatterns = {"/chatbot"})
public class FloatingVetChatbotServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet aboutUsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet aboutUsServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");

        String action = request.getParameter("action");
        // Normalize possible label-based actions to canonical keys
        if (action != null) {
            action = action.trim();
            switch (action) {
                case "🆘 Dấu hiệu cấp cứu": action = "emergency"; break;
                case "🍖 Tư vấn dinh dưỡng": action = "nutrition"; break;
                case "Hành vi và huấn luyện": action = "behavior"; break;
                case "Sinh sản và triệt sản": action = "reproduction"; break;
                case "Chăm sóc và vệ sinh": action = "care"; break;
                case "Chảy máu nhiều": action = "emergency_bleeding"; break;
                case "Khó thở/Ngạt": action = "emergency_breath"; break;
                case "Co giật/Bất tỉnh": action = "emergency_seizure"; break;
                case "Chó con/Mèo con": action = "nutrition_puppy"; break;
                case "Thừa cân/Béo phì": action = "nutrition_overweight"; break;
                case "Dị ứng/Đường ruột": action = "nutrition_allergy"; break;
                case "Làm sao để chó ngừng sủa nhiều hoặc cắn phá đồ?": action = "behavior_bark_destroy"; break;
                case "Cách làm quen giữa hai thú cưng mới và cũ?": action = "behavior_introduce_pets"; break;
                case "Có cần dạy lệnh cơ bản cho chó không?": action = "behavior_basic_commands"; break;
                case "Triệt sản có ảnh hưởng đến tính cách không?": action = "reproduction_neuter_temperament"; break;
                case "Có nên cho thú cưng sinh sản một lứa trước khi triệt sản không?": action = "reproduction_breed_before_neuter"; break;
                case "Khi nào nên triệt sản cho chó/mèo?": action = "reproduction_when_neuter"; break;
                case "Bao lâu nên tắm cho chó/mèo một lần?": action = "care_bathing_frequency"; break;
                case "Có nên dùng dầu gội của người để tắm cho thú cưng không?": action = "care_human_shampoo"; break;
                case "Cách vệ sinh tai, răng miệng cho thú cưng thế nào?": action = "care_clean_ears_teeth"; break;
                // contact deep labels removed
                default: break;
            }
            // Diacritic-insensitive fallback mapping
            if (!action.contains("_") && !action.matches("^(emergency|nutrition|behavior|reproduction|care)$")) {
                String n = normalizeKey(action);
                if (n.contains("dau hieu cap cuu") || n.contains("emergency")) action = "emergency";
                else if (n.contains("tu van dinh duong") || n.contains("nutrition")) action = "nutrition";
                else if (n.contains("hanh vi") || n.contains("huan luyen") || n.contains("behavior")) action = "behavior";
                else if (n.contains("sinh san") || n.contains("triet san") || n.contains("reproduction")) action = "reproduction";
                else if (n.contains("cham soc") || n.contains("ve sinh") || n.contains("care")) action = "care";
    
            }
            if (!action.matches("^[a-z_]+$")) {
                String n = normalizeKey(action);
                if (n.contains("chay mau")) action = "emergency_bleeding";
                else if (n.contains("kho tho") || n.contains("ngat")) action = "emergency_breath";
                else if (n.contains("co giat") || n.contains("bat tinh")) action = "emergency_seizure";
                else if (n.contains("cho con") || n.contains("meo con")) action = "nutrition_puppy";
                else if (n.contains("thua can") || n.contains("beo phi")) action = "nutrition_overweight";
                else if (n.contains("di ung") || n.contains("duong ruot")) action = "nutrition_allergy";
                else if (n.contains("sua nhieu") || n.contains("can pha") || n.contains("sua") || n.contains("can pha do")) action = "behavior_bark_destroy";
                else if (n.contains("lam quen") || n.contains("thu cung moi") || n.contains("thu cung cu")) action = "behavior_introduce_pets";
                else if (n.contains("lenh co ban") || n.contains("day lenh") || n.contains("co can day lenh")) action = "behavior_basic_commands";
                else if (n.contains("triet san") && n.contains("tinh cach")) action = "reproduction_neuter_temperament";
                else if (n.contains("sinh san mot lua") || (n.contains("sinh san") && n.contains("truoc khi triet san"))) action = "reproduction_breed_before_neuter";
                else if (n.contains("khi nao") && n.contains("triet san")) action = "reproduction_when_neuter";
                else if (n.contains("tam bao lau") || n.contains("bao lau tam") || n.contains("tam cho meo")) action = "care_bathing_frequency";
                else if (n.contains("dau goi nguoi") || n.contains("dau goi cua nguoi")) action = "care_human_shampoo";
                else if (n.contains("ve sinh tai") || n.contains("rang mieng") || n.contains("ve sinh rang")) action = "care_clean_ears_teeth";
                // contact deep options removed
            }
        }
        String reply;
        switch (action == null ? "" : action) {
            case "emergency":
                reply = "Nếu thú cưng có các dấu hiệu: khó thở, nôn liên tục, co giật, chảy máu nhiều, nuốt phải dị vật, hoặc bất tỉnh — hãy đưa đến cơ sở thú y gần nhất ngay lập tức và gọi số hotline hỗ trợ. Giữ ấm và hạn chế di chuyển.";
                break;
            case "emergency_bleeding":
                reply = "Chảy máu nhiều:\n" +
                        "1) Dùng gạc/khăn sạch ấn trực tiếp lên vết thương 5–10 phút, giữ lực ép đều.\n" +
                        "2) Băng cố định, nâng cao vị trí nếu có thể.\n" +
                        "3) Không rửa mạnh, không tự ý rút dị vật cắm sâu.\n" +
                        "4) Di chuyển tới cơ sở thú y gần nhất càng sớm càng tốt.";
                break;
            case "emergency_breath":
                reply = "Khó thở/Ngạt:\n" +
                        "1) Giữ cổ thẳng, nới lỏng vòng cổ/đai đeo.\n" +
                        "2) Tránh gây hoảng sợ, hạn chế vận động.\n" +
                        "3) Nếu nghi dị vật, không móc sâu gây tổn thương.\n" +
                        "4) Đưa đi cấp cứu ngay lập tức (nguy cơ suy hô hấp).";
                break;
            case "emergency_seizure":
                reply = "Co giật/Bất tỉnh:\n" +
                        "1) Dọn vật sắc nhọn xung quanh, để thú cưng nằm an toàn.\n" +
                        "2) Không cho đồ vật vào miệng, không cố giữ lưỡi.\n" +
                        "3) Ghi lại thời gian và số lần co giật.\n" +
                        "4) Liên hệ bác sĩ ngay sau cơn, đưa đi khám sớm.";
                break;
            case "nutrition":
                reply = "Tư vấn dinh dưỡng: Chia khẩu phần theo cân nặng và độ tuổi. Ưu tiên thức ăn cân bằng protein–chất béo–xơ. Tránh sô-cô-la, nho/miếng nho khô, hành/tỏi, xylitol. Luôn có nước sạch. Có thể đặt lịch tư vấn chi tiết với bác sĩ.";
                break;
            case "nutrition_puppy":
                reply = "Chó/Mèo con:\n" +
                        "• Khẩu phần: 3–4 bữa/ngày, theo cân nặng & tuần tuổi.\n" +
                        "• Thức ăn: Công thức puppy/kitten, giàu DHA, protein chất lượng.\n" +
                        "• Bổ sung: Canxi, men tiêu hoá khi cần theo chỉ định bác sĩ.\n" +
                        "• Theo dõi: Tăng cân đều, phân đẹp, lông mượt.";
                break;
            case "nutrition_overweight":
                reply = "Thừa cân/Béo phì:\n" +
                        "• Thức ăn: Dòng kiểm soát cân nặng/low-calorie.\n" +
                        "• Luyện tập: 20–30 phút/ngày, tăng dần cường độ.\n" +
                        "• Hạn chế: Snack nhiều năng lượng, đồ ăn thừa.\n" +
                        "• Theo dõi: Cân hằng tuần, mục tiêu giảm 1–2%/tuần.";
                break;
            case "nutrition_allergy":
                reply = "Dị ứng/Đường ruột:\n" +
                        "• Chế độ: Thức ăn thuỷ phân hoặc novel protein (vịt, nai…).\n" +
                        "• Phác đồ loại trừ: 6–8 tuần, không dùng thêm đồ ăn khác.\n" +
                        "• Theo dõi: Da, ngứa, tiêu hoá (phân), cân nặng.\n" +
                        "• Tái khám: Điều chỉnh theo đáp ứng lâm sàng.";
                break;
            case "behavior":
                reply = "Hành vi & huấn luyện: Tập trung vào củng cố tích cực, tăng vận động, và quản lý môi trường. Chọn buổi tập ngắn, vui vẻ, nhất quán.";
                break;
            case "behavior_bark_destroy":
                reply = "Giảm sủa/cắn phá:\n" +
                        "• Tăng vận động, đồ chơi kích thích trí tuệ (puzzle, nhồi thức ăn).\n" +
                        "• Bỏ qua hành vi xấu; thưởng khi im lặng/bình tĩnh.\n" +
                        "• Dạy lệnh 'Im'/'Để đó' với clicker/đồ ăn thưởng.\n" +
                        "• Tìm nguyên nhân (chán, lo âu chia ly), tránh phạt nặng tay.";
                break;
            case "behavior_introduce_pets":
                reply = "Làm quen thú cưng mới–cũ:\n" +
                        "• Cách ly ban đầu; trao đổi mùi qua khăn/đồ vật.\n" +
                        "• Gặp có kiểm soát, ngắn và tích cực; thưởng khi bình tĩnh.\n" +
                        "• Tăng dần thời gian; luôn giám sát.\n" +
                        "• Không ép buộc; cho lối thoát, nơi trú an toàn.";
                break;
            case "behavior_basic_commands":
                reply = "Lệnh cơ bản nên dạy:\n" +
                        "• Tên gọi, 'Ngồi', 'Nằm', 'Lại đây', 'Đợi'.\n" +
                        "• Buổi ngắn 3–5 phút, nhiều lần/ngày.\n" +
                        "• Tăng độ khó và đa dạng hoá bối cảnh.\n" +
                        "• Dùng thưởng nhỏ; luôn tích cực, nhất quán.";
                break;
            case "reproduction":
                reply = "Sinh sản & triệt sản: Quyết định dựa trên sức khoẻ, độ tuổi, giống và kế hoạch gia đình. Trao đổi với bác sĩ để chọn thời điểm phù hợp.";
                break;
            case "reproduction_neuter_temperament":
                reply = "Triệt sản & tính cách:\n" +
                        "• Không làm mất tính cách tích cực nếu huấn luyện đúng.\n" +
                        "• Giảm hành vi do hormone (đánh dấu, bỏ nhà).\n" +
                        "• Ổn định nội tiết, giúp thú cưng thư thái hơn.";
                break;
            case "reproduction_breed_before_neuter":
                reply = "Có nên sinh sản 1 lứa trước triệt sản?\n" +
                        "• Không bắt buộc; không có lợi ích sức khoẻ rõ ràng.\n" +
                        "• Triệt sản đúng lúc giảm bệnh sinh sản.\n" +
                        "• Cân nhắc phúc lợi thú cưng và điều kiện chăm sóc.";
                break;
            case "reproduction_when_neuter":
                reply = "Khi nào triệt sản?\n" +
                        "• Chó: 6–12 tháng (tuỳ giống/kích thước).\n" +
                        "• Mèo: 5–6 tháng, trước dậy thì.\n" +
                        "• Cá thể hoá theo sức khoẻ/hành vi.";
                break;
            case "care":
                reply = "Chăm sóc & vệ sinh: Duy trì vệ sinh tai, răng miệng, da lông; sử dụng sản phẩm dành cho thú cưng; lịch tắm phù hợp từng cá thể.";
                break;
            case "care_bathing_frequency":
                reply = "Tắm bao lâu 1 lần?\n" +
                        "• Chó: 2–4 tuần/lần tuỳ da/giống/hoạt động.\n" +
                        "• Mèo: thường không cần, trừ khi bẩn/da dầu.\n" +
                        "• Dùng sữa tắm thú y, sấy khô kỹ.";
                break;
            case "care_human_shampoo":
                reply = "Dùng dầu gội người?\n" +
                        "• Không nên: pH khác, có thể gây kích ứng.\n" +
                        "• Chọn sản phẩm thú cưng theo tư vấn chuyên môn.";
                break;
            case "care_clean_ears_teeth":
                reply = "Vệ sinh tai & răng:\n" +
                        "• Tai: dung dịch chuyên dụng, massage, lau phần ngoài.\n" +
                        "• Răng: chải 3–4 lần/tuần bằng kem/bàn chải cho thú cưng.\n" +
                        "• Kết hợp đồ nhai hỗ trợ vệ sinh răng miệng.";
                break;
            default:
                reply = "Hiện chưa xác định chủ đề. Vui lòng chọn một mục tư vấn trong danh sách.";
        }

        try (PrintWriter out = response.getWriter()) {
            String json = "{\"message\":" + toJsonString(reply) + "}";
            out.write(json);
        }
    }

    private String toJsonString(String s) {
        if (s == null) return "\"\"";
        String escaped = s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
        return "\"" + escaped + "\"";
    }

    private String normalizeKey(String s) {
        if (s == null) return "";
        String noAccent = Normalizer.normalize(s, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "");
        noAccent = noAccent.replaceAll("[^a-zA-Z0-9_ ]", " ").toLowerCase();
        return noAccent.replaceAll("\\s+", " ").trim();
    }
}
