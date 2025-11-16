/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;



/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class CalendarEventDTO {

    private String id;              // ID của booking (để biết click vào cái nào)
    private String title;           // Dòng chữ hiện trên thanh lịch (VD: "Tắm - Nguyễn Văn A")
    private String start;           // Thời gian bắt đầu (Dạng String ISO: "2025-11-12T09:30:00")
    private String end;             // Thời gian kết thúc (Tùy chọn, nếu muốn hiện độ dài thanh)
    private String backgroundColor; // Màu nền (Xanh/Đỏ/Vàng tùy theo Status)
    private String borderColor;     // Màu viền (thường trùng màu nền)

    private ExtendedProps extendedProps;

    public CalendarEventDTO() {
    }

    public CalendarEventDTO(String id, String title, String start, String end, String color) {
        this.id = id;
        this.title = title;
        this.start = start;
        this.end = end;
        this.backgroundColor = color;
        this.borderColor = color;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(String backgroundColor) {
        this.backgroundColor = backgroundColor;
        this.borderColor = backgroundColor;
    }

    public String getBorderColor() {
        return borderColor;
    }

    public void setBorderColor(String borderColor) {
        this.borderColor = borderColor;
    }

    public ExtendedProps getExtendedProps() {
        return extendedProps;
    }

    public void setExtendedProps(ExtendedProps extendedProps) {
        this.extendedProps = extendedProps;
    }

    public static class ExtendedProps {

        // 1. Thông tin Khách hàng (Từ bảng Users)
        private String customerName;
        private String customerPhone;
        private String customerEmail;

        // 2. Thông tin Thú cưng (Từ bảng Pets)
        private String petName;
        private String petType;

        // 3. Thông tin Dịch vụ (Xử lý logic Service hoặc Package)
        private String itemName;

        // 4. Thông tin Booking (Từ bảng Booking)
        private double totalPrice;
        private String paymentStatus;
        private String notes;
        private String status;

        public ExtendedProps() {
        }

        public ExtendedProps(String customerName, String customerPhone, String customerEmail, String petName, String petType, String itemName, double totalPrice, String paymentStatus, String notes, String status) {
            this.customerName = customerName;
            this.customerPhone = customerPhone;
            this.customerEmail = customerEmail;
            this.petName = petName;
            this.petType = petType;
            this.itemName = itemName;
            this.totalPrice = totalPrice;
            this.paymentStatus = paymentStatus;
            this.notes = notes;
            this.status = status;
        }

        public String getCustomerName() {
            return customerName;
        }

        public void setCustomerName(String customerName) {
            this.customerName = customerName;
        }

        public String getCustomerPhone() {
            return customerPhone;
        }

        public void setCustomerPhone(String customerPhone) {
            this.customerPhone = customerPhone;
        }

        public String getCustomerEmail() {
            return customerEmail;
        }

        public void setCustomerEmail(String customerEmail) {
            this.customerEmail = customerEmail;
        }

        public String getPetName() {
            return petName;
        }

        public void setPetName(String petName) {
            this.petName = petName;
        }

        public String getPetType() {
            return petType;
        }

        public void setPetType(String petType) {
            this.petType = petType;
        }

        public String getItemName() {
            return itemName;
        }

        public void setItemName(String itemName) {
            this.itemName = itemName;
        }

        public double getTotalPrice() {
            return totalPrice;
        }

        public void setTotalPrice(double totalPrice) {
            this.totalPrice = totalPrice;
        }

        public String getPaymentStatus() {
            return paymentStatus;
        }

        public void setPaymentStatus(String paymentStatus) {
            this.paymentStatus = paymentStatus;
        }

        public String getNotes() {
            return notes;
        }

        public void setNotes(String notes) {
            this.notes = notes;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

    }

}
