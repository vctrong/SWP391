package utils;

import model.ConsultationRequest;

public final class ConsultationRequestValidator {
    private ConsultationRequestValidator() {}

    public static String validate(ConsultationRequest cr) {
        if (cr == null) return "Dữ liệu không hợp lệ.";
        if (cr.getCustomerName() == null || cr.getCustomerName().trim().isEmpty()) return "Vui lòng nhập họ tên.";
        if (cr.getEmail() == null || cr.getEmail().trim().isEmpty()) return "Vui lòng nhập email.";
        if (cr.getConsultationTypeId() == null) return "Vui lòng chọn loại tư vấn.";
        if (cr.getRequestMessage() == null || cr.getRequestMessage().trim().isEmpty()) return "Vui lòng nhập nội dung.";
        if (cr.getCustomerName().length() > 50) return "Tên quá dài.";
        if (cr.getEmail().length() > 100) return "Email quá dài.";
        if (cr.getPhone() != null) {
            String phone = cr.getPhone().trim();
            if (!phone.isEmpty()) {
                if (phone.length() > 10) return "Số điện thoại không quá 10 số.";
                if (!phone.matches("\\d+")) return "Số điện thoại chỉ được nhập số.";
            }
        }
        return null;
    }
}
