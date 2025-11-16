/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import dto.BookingHistoryDTO;
import dto.BookingSummary;
import dto.HistoryKPIs;
import dto.OrderHistoryDTO;
import dto.RecentActivity;
import dto.UserAddressDTO;
import dto.UserProfileDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.PasswordUtils;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class ProfileDAO extends db.DBContext {

    public int getCountOrder(int userID) {
        try {
            String qr = "select count(*) from Orders\n"
                    + "where customer_id = ?";
            Object[] params = {userID};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProfileDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public int getCountBooking(int userID) {
        try {
            String qr = "select count(*) from booking\n"
                    + "where customer_id = ?";
            Object[] params = {userID};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProfileDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public BookingSummary getNextBooking(long userID) {
        try {
            String qr = "SELECT TOP(1) b.booking_id, b.requested_date, b.requested_start, b.booking_time, b.current_status, \n"
                    + "s.service_name, p.name AS pet_name \n"
                    + "FROM Booking b \n"
                    + "LEFT JOIN Services s ON b.service_id = s.service_id \n"
                    + "LEFT JOIN Pets p ON b.pet_id = p.pet_id \n"
                    + "WHERE b.customer_id = ? AND b.booking_time > SYSUTCDATETIME() AND b.current_status NOT IN ('CANCELLED','COMPLETED','NO_SHOW') \n"
                    + "ORDER BY b.booking_time ASC";
            Object[] params = {userID};
            ResultSet rs = this.executeSelectQuery(qr, params);
            if (rs.next()) {
                return new BookingSummary(rs.getLong(1), rs.getDate(2), rs.getTime(3), rs.getDate(4), rs.getString(5), rs.getString(6), rs.getString(7));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProfileDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<RecentActivity> getRecentActivities(long userId, int limit) throws SQLException {
        String sql
                = "WITH activities AS ( "
                + "  SELECT 'ORDER' AS type, o.order_id AS id, o.order_code AS ref_code, "
                + "    (SELECT TOP (1) p.product_name "
                + "     FROM OrderItems oi2 "
                + "     JOIN ProductVariant pv2 ON oi2.variant_id = pv2.variant_id "
                + "     JOIN Product p ON pv2.product_id = p.product_id "
                + "     WHERE oi2.order_id = o.order_id "
                + "     ORDER BY oi2.order_item_id) AS title, "
                + "    o.created_at AS ts, o.total_amount AS amount, o.order_status AS status, "
                + "    (o.order_code + ' • ' + CONVERT(varchar(10), o.created_at, 103)) AS meta "
                + "  FROM Orders o "
                + "  WHERE o.customer_id = ? "
                + "  UNION ALL "
                + "  SELECT 'BOOKING' AS type, b.booking_id AS id, '' AS ref_code, "
                + "    COALESCE(s.service_name, '') AS title, b.booking_time AS ts, NULL AS amount, b.current_status AS status, "
                + "    (CONVERT(varchar(10), b.requested_date, 103) + ' • ' + ISNULL(CONVERT(varchar(5), b.requested_start, 108), '')) AS meta "
                + "  FROM Booking b "
                + "  LEFT JOIN Services s ON s.service_id = b.service_id "
                + "  WHERE b.customer_id = ? "
                + ") "
                + "SELECT type, id, ref_code, title, ts, amount, status, meta "
                + "FROM ( "
                + "  SELECT *, ROW_NUMBER() OVER (ORDER BY ts DESC) AS rn FROM activities "
                + ") t "
                + "WHERE rn <= ? "
                + "ORDER BY ts DESC;";

        List<RecentActivity> out = new ArrayList<>();
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);   // o.customer_id
            ps.setLong(2, userId);   // b.customer_id
            ps.setInt(3, limit);     // rn <= ?
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecentActivity a = new RecentActivity();
                    String type = rs.getString("type");
                    a.setType(type);
                    a.setId(rs.getLong("id"));
                    a.setRefCode(rs.getString("ref_code"));
                    a.setTitle(rs.getString("title"));
                    a.setTs(rs.getTimestamp("ts"));
                    a.setAmount(rs.getBigDecimal("amount")); // null for bookings
                    a.setStatus(rs.getString("status"));
                    a.setMeta(rs.getString("meta"));
                    out.add(a);
                }
            }
        }
        return out;
    }

    public HistoryKPIs getHistoryKPIs(long customerId) {
        HistoryKPIs kpis = new HistoryKPIs();
        // Câu query này thực hiện 3 truy vấn con để lấy tất cả KPI trong 1 lần gọi DB
        String sql = "SELECT "
                + // 1. Tổng chi: Tổng tiền của Orders VÀ Bookings đã 'COMPLETED'
                "(SELECT ISNULL(SUM(total_amount), 0) FROM Orders WHERE customer_id = ? AND order_status = 'COMPLETED') + "
                + "(SELECT ISNULL(SUM(total_price), 0) FROM Booking WHERE customer_id = ? AND current_status = 'COMPLETED') "
                + "AS TotalSpent, "
                + // 2. Đang xử lý: Tổng Orders VÀ Bookings KHÔNG ở trạng thái cuối
                "(SELECT COUNT(*) FROM Orders WHERE customer_id = ? AND order_status NOT IN ('COMPLETED', 'CANCELLED')) + "
                + "(SELECT COUNT(*) FROM Booking WHERE customer_id = ? AND current_status NOT IN ('COMPLETED', 'CANCELLED', 'NO_SHOW')) "
                + "AS TotalProcessing, "
                + // 3. Tổng đơn: Tổng số lượng Orders VÀ Bookings
                "(SELECT COUNT(*) FROM Orders WHERE customer_id = ?) + "
                + "(SELECT COUNT(*) FROM Booking WHERE customer_id = ?) "
                + "AS TotalOrdersAndBookings";

        // Thay thế 'DBContext.getConnection()' bằng phương thức kết nối của bạn
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, customerId); // Cho TotalSpent (Orders)
            ps.setLong(2, customerId); // Cho TotalSpent (Booking)
            ps.setLong(3, customerId); // Cho TotalProcessing (Orders)
            ps.setLong(4, customerId); // Cho TotalProcessing (Booking)
            ps.setLong(5, customerId); // Cho TotalOrders (Orders)
            ps.setLong(6, customerId); // Cho TotalOrders (Booking)

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    kpis.setTotalSpent(rs.getDouble("TotalSpent"));
                    kpis.setProcessingItems(rs.getInt("TotalProcessing"));
                    kpis.setTotalOrdersAndBookings(rs.getInt("TotalOrdersAndBookings"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý exception (ví dụ: log lại)
        }
        return kpis;
    }

    public List<OrderHistoryDTO> getAllOrders(long customerId) {
        List<OrderHistoryDTO> orderList = new ArrayList<>();

        // SQL đã loại bỏ bộ lọc và phân trang
        String sql = "SELECT "
                + "    o.order_id, o.order_code, o.created_at, o.total_amount, os.description AS status_display, "
                + // Sub-query lấy tên sản phẩm đầu tiên
                "    (SELECT TOP 1 p.product_name "
                + "     FROM OrderItems oi "
                + "     JOIN ProductVariant pv ON oi.variant_id = pv.variant_id "
                + "     JOIN Product p ON pv.product_id = p.product_id "
                + "     WHERE oi.order_id = o.order_id) AS primary_product_name, "
                + // Sub-query lấy mô tả (attribute_json) của variant đầu tiên
                "    (SELECT TOP 1 pv.attribute_json "
                + "     FROM OrderItems oi "
                + "     JOIN ProductVariant pv ON oi.variant_id = pv.variant_id "
                + "     WHERE oi.order_id = o.order_id) AS primary_product_desc "
                + "FROM Orders o "
                + "JOIN OrderStatus os ON o.order_status = os.order_status_code "
                + "WHERE o.customer_id = ? "
                + // Chỉ lọc theo customer_id
                "ORDER BY o.created_at DESC";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, customerId); // customer_id

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderHistoryDTO order = new OrderHistoryDTO();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setOrderCode(rs.getString("order_code"));
                    order.setPurchaseDate(rs.getDate("created_at"));
                    order.setTotalPrice(rs.getDouble("total_amount"));
                    order.setStatusDisplay(rs.getString("status_display"));
                    order.setPrimaryProductName(rs.getString("primary_product_name"));
                    order.setPrimaryProductDescription(rs.getString("primary_product_desc"));
                    orderList.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }

    public List<BookingHistoryDTO> getAllBookings(long customerId) {
        List<BookingHistoryDTO> bookingList = new ArrayList<>();

        // SQL đã loại bỏ bộ lọc và phân trang
        String sql = "SELECT "
                + "    b.booking_id, b.requested_date, b.requested_start, b.total_price, "
                + "    bs.description AS status_display, "
                + "    p.name AS pet_name, "
                + "    COALESCE(s.service_name, sp.package_name) AS service_name "
                + "FROM Booking b "
                + "JOIN BookingStatus bs ON b.current_status = bs.booking_status_code "
                + "JOIN Pets p ON b.pet_id = p.pet_id "
                + "LEFT JOIN Services s ON b.service_id = s.service_id "
                + "LEFT JOIN ServicePackage sp ON b.package_id = sp.package_id "
                + "WHERE b.customer_id = ? "
                + // Chỉ lọc theo customer_id
                "ORDER BY b.requested_date DESC, b.requested_start DESC";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, customerId); // customer_id

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingHistoryDTO booking = new BookingHistoryDTO();
                    booking.setBookingId(rs.getLong("booking_id"));
                    booking.setAppointmentDate(rs.getDate("requested_date"));
                    booking.setAppointmentTime(rs.getTime("requested_start"));
                    booking.setPrice(rs.getDouble("total_price"));
                    booking.setStatusDisplay(rs.getString("status_display"));
                    booking.setServiceName(rs.getString("service_name"));
                    booking.setServiceDescription("Cho thú cưng: " + rs.getString("pet_name"));
                    bookingList.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingList;
    }
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public UserProfileDTO getUserProfile(long userId) {
        UserProfileDTO profile = null;
        // Câu SQL này JOIN Users, Roles, và UserAddress (địa chỉ mặc định)
        String sql = "SELECT "
                + "    u.avatar_url, u.full_name, u.phone, u.email, u.gender, u.birthday, u.created_at, u.updated_at, "
                + "    r.role_name, "
                + "    a.address_line1, a.ward, a.district, a.city "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + // LEFT JOIN để vẫn lấy được user dù họ chưa có địa chỉ mặc định
                "LEFT JOIN UserAddress a ON u.user_id = a.user_id AND a.is_default = 1 "
                + "WHERE u.user_id = ?";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    profile = new UserProfileDTO();
                    profile.setFullName(rs.getString("full_name"));
                    profile.setPhone(rs.getString("phone"));
                    profile.setEmail(rs.getString("email"));
                    profile.setRoleName(rs.getString("role_name"));

                    // Xử lý Avatar (nếu null thì dùng ảnh mặc định)
                    String avatar = rs.getString("avatar_url");
                    profile.setAvatarUrl(avatar != null ? avatar : "assets/img/default-avatar.png"); // Thay path ảnh mặc định của bạn

                    // Xử lý ngày tháng
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    profile.setCreatedAtFormatted(createdAt.format(DATE_FORMATTER));

                    LocalDateTime updatedAt = rs.getTimestamp("updated_at") != null
                            ? rs.getTimestamp("updated_at").toLocalDateTime()
                            : createdAt;
                    profile.setLastUpdatedAtFormatted(updatedAt.format(DATETIME_FORMATTER));

                    // Tính toán thời gian thành viên
                    profile.setMembershipDuration(formatMembershipDuration(createdAt));

                    // Xử lý ngày sinh
                    java.sql.Date birthday = rs.getDate("birthday");
                    profile.setBirthdayFormatted(birthday != null ? birthday.toLocalDate().format(DATE_FORMATTER) : "Chưa cập nhật");

                    // Xử lý giới tính (Giả sử 1=Nam, 2=Nữ, 0=Khác)
                    profile.setGenderDisplay(formatGender(rs.getInt("gender")));

                    // Xử lý địa chỉ mặc định
                    String addressLine1 = rs.getString("address_line1");
                    String ward = rs.getString("ward");
                    String district = rs.getString("district");
                    String city = rs.getString("city");
                    profile.setDefaultAddressSummary(formatFullAddress(addressLine1, ward, district, city, true));

                    // 2FA (Không có trong CSDL, mặc định là false)
                    profile.setIs2faEnabled(false);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profile;
    }

    /**
     * Lấy TẤT CẢ địa chỉ của người dùng (cho Sổ địa chỉ).
     *
     * @param userId ID của người dùng
     * @return Danh sách UserAddressDTO
     */
    public List<UserAddressDTO> getUserAddresses(long userId) {
        List<UserAddressDTO> addressList = new ArrayList<>();
        // Sắp xếp cho địa chỉ "Mặc định" lên đầu
        String sql = "SELECT * FROM UserAddress WHERE user_id = ? ORDER BY is_default DESC, created_at ASC";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserAddressDTO address = new UserAddressDTO();
                    address.setAddressId(rs.getLong("address_id"));
                    address.setLabel(rs.getString("label"));
                    address.setRecipientName(rs.getString("recipient_name"));
                    address.setPhone(rs.getString("phone"));
                    address.setIsDefault(rs.getBoolean("is_default"));

                    // Ghép địa chỉ đầy đủ
                    String fullAddress = formatFullAddress(
                            rs.getString("address_line1"),
                            rs.getString("ward"),
                            rs.getString("district"),
                            rs.getString("city"),
                            false // false = hiển thị đầy đủ
                    );
                    address.setFullAddress(fullAddress);

                    addressList.add(address);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return addressList;
    }

    // =================================================================
    // 3. CÁC HÀM HỖ TRỢ (PRIVATE)
    // =================================================================
    /**
     * Chuyển đổi mã giới tính (INT) sang chuỗi hiển thị.
     */
    private String formatGender(int genderCode) {
        switch (genderCode) {
            case 1:
                return "Nam";
            case 2:
                return "Nữ";
            case 0:
                return "Khác";
            default:
                return "Chưa cập nhật";
        }
    }

    /**
     * Tính toán thời gian thành viên.
     */
    private String formatMembershipDuration(LocalDateTime createdAt) {
        long years = ChronoUnit.YEARS.between(createdAt.toLocalDate(), LocalDate.now());
        if (years < 1) {
            long months = ChronoUnit.MONTHS.between(createdAt.toLocalDate(), LocalDate.now());
            if (months < 1) {
                return "Thành viên mới";
            }
            return "Thành viên " + months + " tháng";
        }
        return "Thành viên " + years + " năm";
    }

    /**
     * Ghép các thành phần địa chỉ thành một chuỗi.
     *
     * @param summaryOnly true=chỉ lấy dòng 1 và thành phố (cho profile),
     * false=lấy đầy đủ (cho sổ địa chỉ)
     */
    private String formatFullAddress(String line1, String ward, String district, String city, boolean summaryOnly) {
        if (line1 == null || line1.isEmpty()) {
            return "Chưa cập nhật";
        }

        StringBuilder sb = new StringBuilder(line1);

        if (summaryOnly) {
            if (city != null && !city.isEmpty()) {
                sb.append(", ").append(city);
            }
        } else {
            if (ward != null && !ward.isEmpty()) {
                sb.append(", ").append(ward);
            }
            if (district != null && !district.isEmpty()) {
                sb.append(", ").append(district);
            }
            if (city != null && !city.isEmpty()) {
                sb.append(", ").append(city);
            }
        }

        return sb.toString();
    }

    public boolean updateUserProfile(long userId, String fullName, String phone, int gender, LocalDate birthday) {
        String sql = "UPDATE Users SET "
                + " full_name = ?, "
                + " phone = ?, "
                + " gender = ?, "
                + " birthday = ?, "
                + " updated_at = SYSUTCDATETIME() "
                + "WHERE user_id = ?";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setInt(3, gender);
            ps.setDate(4, java.sql.Date.valueOf(birthday));
            ps.setLong(5, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addNewAddress(long userId, String label, String recipientName, String phone,
            String addressLine1, String ward, String district, String city) {

        // Địa chỉ mới không bao giờ là mặc định
        String sql = "INSERT INTO UserAddress "
                + " (user_id, label, recipient_name, phone, address_line1, ward, district, city, is_default) "
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)";

        // *** THAY THẾ 'DBContext.getConnection()' BẰNG CÁCH KẾT NỐI CỦA BẠN ***
        try ( Connection conn = this.openNewConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.setString(2, label);
            ps.setString(3, recipientName);
            ps.setString(4, phone);
            ps.setString(5, addressLine1);
            ps.setString(6, ward);
            ps.setString(7, district);
            ps.setString(8, city);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String changePassword(long userId, String oldPassword, String newPassword) {
        String sqlSelect = "SELECT password_hash FROM Users WHERE user_id = ?";
        String sqlUpdate = "UPDATE Users SET password_hash = ?, updated_at = SYSUTCDATETIME() WHERE user_id = ?";

        try ( Connection conn = this.openNewConnection()) {
            String currentHash = "";

            // BƯỚC 1: Lấy hash mật khẩu hiện tại
            try ( PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
                psSelect.setLong(1, userId);
                try ( ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        currentHash = rs.getString("password_hash");
                    } else {
                        return "ERROR"; // Không tìm thấy user
                    }
                }
            }

            // BƯỚC 2: Kiểm tra mật khẩu cũ
            // **ĐÃ THAY THẾ:** Gọi hàm checkPassword từ class mới
            boolean isOldPasswordCorrect = PasswordUtils.checkPassword(oldPassword, currentHash);

            if (!isOldPasswordCorrect) {
                return "WRONG_PASSWORD"; // Mật khẩu cũ không đúng
            }

            // BƯỚC 3: Hash mật khẩu mới
            // **ĐÃ THAY THẾ:** Gọi hàm hashPassword từ class mới
            String newHash = PasswordUtils.hashPassword(newPassword);

            // BƯỚC 4: Cập nhật mật khẩu mới vào CSDL
            try ( PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {
                psUpdate.setString(1, newHash);
                psUpdate.setLong(2, userId);
                int rowsAffected = psUpdate.executeUpdate();

                return (rowsAffected > 0) ? "SUCCESS" : "ERROR";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR";
        }
    }
}
