package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author Nguyen Lam Thanh Luan - CE190980
 */

@WebServlet(name = "FloatingVetChatbotServlet", urlPatterns = {"/chatbot"})
public class FloatingVetChatbotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            doPost(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");

        String action = request.getParameter("action");
        if (action != null) {
            action = action.trim();
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
}
