/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos.admin;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BookingSummary;
import model.OrderSummary;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class dashboardDAO extends db.DBContext {

    public double revenueInMonth() {
        try {
            // --- GIẢI THÍCH SỰ THAY ĐỔI SQL ---
            // 1. DATE_TRUNC('month', CURRENT_DATE): Lấy ngày đầu tiên của tháng hiện tại (Thay cho DATEFROMPARTS...)
            // 2. + INTERVAL '1 month': Cộng thêm 1 tháng (Thay cho DATEADD...)
            // 3. CURRENT_DATE: Lấy ngày hiện tại (Thay cho GETDATE())

            String qr = "select \n"
                    + "(select COALESCE(sum(total_amount),0) from Orders\n"
                    + "where payment_status = 'PAID' \n"
                    + "and created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "and created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month') \n"
                    + "+ \n"
                    + "(select COALESCE(sum(total_price),0) from Booking\n"
                    + "where payment_status = 'PAID'\n"
                    + "and created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "and created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month')\n"
                    + "as revenue";

            double revenue = 0;
            // executeSelectQuery tham số thứ 2 nên là mảng rỗng thay vì null nếu hàm đó không handle null tốt
            // Nhưng nếu hàm executeSelectQuery của bạn handle được null thì giữ nguyên.
            ResultSet rs = this.executeSelectQuery(qr, null);

            if (rs.next()) {
                revenue = rs.getDouble(1);
                return revenue;
            }

        } catch (SQLException ex) {
            // --- SỬA LỖI LOGGER ---
            // Thay tham số 'null' bằng chuỗi thông báo để tránh NullPointerException
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi tính doanh thu tháng: " + ex.getMessage(), ex);
        }
        return 0.0;
    }

    public int bookingToday() {
        try {
            // Postgres: Dùng CURRENT_DATE và INTERVAL
            String qr = "SELECT COUNT(booking_id) AS total_bookings_today\n"
                    + "FROM Booking\n"
                    + "WHERE\n"
                    + "    created_at >= CURRENT_DATE\n"
                    + "    AND created_at < CURRENT_DATE + INTERVAL '1 day'\n"
                    + "    AND current_status IN ('PENDING', 'COMFIRMED', 'COMPLETED', 'IN_PROGRESS');";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi bookingToday: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public int orderToday() {
        try {
            String qr = "SELECT COUNT(order_id) AS orders_today\n"
                    + "FROM Orders\n"
                    + "WHERE\n"
                    + "    created_at >= CURRENT_DATE\n"
                    + "    AND created_at < CURRENT_DATE + INTERVAL '1 day'\n"
                    + "    and order_status in ('COMPLETED', 'PAID', 'PENDING', 'PROGRESSING', 'SHIPPED')";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi orderToday: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public int customerInMonth() {
        try {
            // Postgres: DATE_TRUNC('month', CURRENT_DATE) lấy ngày đầu tháng hiện tại
            String qr = "SELECT COUNT(user_id) AS new_customers_this_month\n"
                    + "FROM Users\n"
                    + "WHERE\n"
                    + "    created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "    AND created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'\n"
                    + "    and role_id = 1";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi customerInMonth: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public int orderPending() {
        try {
            // Câu này cú pháp chuẩn chung nên giữ nguyên, chỉ sửa Logger
            String qr = "SELECT COUNT(order_id) AS pending_orders\n"
                    + "FROM Orders\n"
                    + "WHERE\n"
                    + "    order_status = 'PENDING';";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi orderPending: " + ex.getMessage(), ex);
        }
        return 0;
    }

    public LinkedHashMap<String, Integer> topService() {
        try {
            // Postgres: Dùng LIMIT thay cho TOP
            String qr = "WITH AllBookedItems AS (\n"
                    + "    SELECT \n"
                    + "        s.service_name AS item_name \n"
                    + "    FROM \n"
                    + "        Booking b\n"
                    + "    JOIN \n"
                    + "        Services s ON b.service_id = s.service_id \n"
                    + "    WHERE\n"
                    + "        b.payment_status = 'PAID'\n"
                    + "        AND b.service_id IS NOT NULL \n"
                    + "        AND b.created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "        AND b.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'\n"
                    + "\n"
                    + "    UNION ALL \n"
                    + "\n"
                    + "    SELECT \n"
                    + "        p.package_name AS item_name \n"
                    + "    FROM \n"
                    + "        Booking b\n"
                    + "    JOIN \n"
                    + "        ServicePackage p ON b.package_id = p.package_id \n"
                    + "    WHERE\n"
                    + "        b.payment_status = 'PAID'\n"
                    + "        AND b.package_id IS NOT NULL \n"
                    + "        AND b.created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "        AND b.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'\n"
                    + ")\n"
                    + "\n"
                    + "SELECT \n"
                    + "    item_name AS label,\n"
                    + "    COUNT(*) AS data\n"
                    + "FROM \n"
                    + "    AllBookedItems\n"
                    + "GROUP BY \n"
                    + "    item_name\n"
                    + "ORDER BY \n"
                    + "    data DESC \n"
                    + "LIMIT 5;"; // Sửa TOP 5 thành LIMIT 5

            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi topService: " + ex.getMessage(), ex);
        }
        return null;
    }

    public LinkedHashMap<String, Integer> revenue30Day() {
        try {
            // Postgres: Dùng generate_series để tạo ra 30 ngày gần nhất cực gọn
            // TO_CHAR thay cho CONVERT
            String qr = "WITH DateTally AS (\n"
                    + "    SELECT generate_series(CURRENT_DATE - INTERVAL '29 days', CURRENT_DATE, '1 day')::date AS report_date\n"
                    + "),\n"
                    + "AllRevenueTransactions AS (\n"
                    + "    SELECT \n"
                    + "        created_at::date AS revenue_date, \n"
                    + "        total_amount \n"
                    + "    FROM Orders\n"
                    + "    WHERE \n"
                    + "        payment_status = 'PAID'\n"
                    + "        AND created_at >= CURRENT_DATE - INTERVAL '29 days'\n"
                    + "    UNION ALL\n"
                    + "    SELECT \n"
                    + "        created_at::date AS revenue_date, \n"
                    + "        total_price \n"
                    + "    FROM Booking\n"
                    + "    WHERE \n"
                    + "        payment_status = 'PAID'\n"
                    + "        AND created_at >= CURRENT_DATE - INTERVAL '29 days'\n"
                    + "),\n"
                    + "DailyTotals AS (\n"
                    + "    SELECT \n"
                    + "        revenue_date, \n"
                    + "        SUM(total_amount) AS total\n"
                    + "    FROM AllRevenueTransactions\n"
                    + "    GROUP BY revenue_date\n"
                    + ")\n"
                    + "SELECT \n"
                    + "    TO_CHAR(tally.report_date, 'YYYY-MM-DD') AS label,\n" // Format ngày
                    + "    COALESCE(daily.total, 0) AS data \n"
                    + "FROM \n"
                    + "    DateTally AS tally\n"
                    + "LEFT JOIN \n"
                    + "    DailyTotals AS daily ON tally.report_date = daily.revenue_date\n"
                    + "ORDER BY\n"
                    + "    tally.report_date ASC;";

            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi revenue30Day: " + ex.getMessage(), ex);
        }
        return null;
    }

    public LinkedHashMap<String, Integer> topProduct() {
        try {
            // Postgres: Bỏ DECLARE, nhúng logic ngày tháng vào query
            // Thay TOP 5 thành LIMIT 5
            String qr = "SELECT \n"
                    + "    p.product_name AS label,\n"
                    + "    SUM(oi.quantity) AS data\n"
                    + "FROM \n"
                    + "    Orders AS o\n"
                    + "JOIN \n"
                    + "    OrderItems AS oi ON o.order_id = oi.order_id\n"
                    + "join \n"
                    + "    ProductVariant as pv on pv.variant_id = oi.variant_id\n"
                    + "JOIN \n"
                    + "    Product AS p ON pv.product_id = p.product_id\n"
                    + "WHERE \n"
                    + "    o.payment_status = 'PAID'\n"
                    + "    AND o.created_at >= DATE_TRUNC('month', CURRENT_DATE)\n"
                    + "    AND o.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'\n"
                    + "GROUP BY\n"
                    + "    p.product_name\n"
                    + "ORDER BY\n"
                    + "    data DESC\n"
                    + "LIMIT 5;";

            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi topProduct: " + ex.getMessage(), ex);
        }
        return null;
    }

    public ArrayList<BookingSummary> recentBooking() {
        try {
            // Postgres: CAST(GETDATE() AS DATE) -> CURRENT_DATE
            String qr = "SELECT\n"
                    + "    b.booking_id,\n"
                    + "    b.requested_date,\n"
                    + "    b.requested_start,\n"
                    + "    c.full_name AS customer_name,\n"
                    + "    p.name AS pet_name,\n"
                    + "    COALESCE(s.service_name, pkg.package_name) AS service_or_package,\n"
                    + "    bs.description AS status_description\n"
                    + "FROM\n"
                    + "    Booking b\n"
                    + "JOIN Users c ON b.customer_id = c.user_id\n"
                    + "JOIN Pets p ON b.pet_id = p.pet_id\n"
                    + "JOIN BookingStatus bs ON b.current_status = bs.booking_status_code\n"
                    + "LEFT JOIN Services s ON b.service_id = s.service_id\n"
                    + "LEFT JOIN ServicePackage pkg ON b.package_id = pkg.package_id\n"
                    + "WHERE\n"
                    + "    b.requested_date >= CURRENT_DATE\n"
                    + "    AND b.current_status IN ('PENDING', 'CONFIRMED', 'IN_PROGRESS')\n"
                    + "ORDER BY\n"
                    + "    b.requested_date ASC, b.requested_start ASC;";

            ArrayList<BookingSummary> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                BookingSummary book = new BookingSummary(rs.getInt(1), rs.getString(4),
                        rs.getString(5), rs.getString(6), rs.getDate(2), rs.getTime(3), rs.getString(7));
                temp.add(book);
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi recentBooking: " + ex.getMessage(), ex);
        }
        return null;
    }

    public ArrayList<OrderSummary> recentOrder() {
        try {
            // Postgres: DATEADD(day, -7, GETDATE()) -> CURRENT_DATE - INTERVAL '7 days'
            String qr = "SELECT\n"
                    + "    o.order_id AS id,\n"
                    + "    o.order_code AS orderCode,\n"
                    + "    c.full_name AS customerName,\n"
                    + "    os.description AS statusDescription,\n"
                    + "    o.payment_status AS paymentStatus,\n"
                    + "    o.total_amount AS totalAmount,\n"
                    + "    COUNT(oi.order_item_id) AS totalItems,\n"
                    + "    o.created_at AS createdAt\n"
                    + "FROM\n"
                    + "    Orders o\n"
                    + "JOIN Users c ON o.customer_id = c.user_id\n"
                    + "JOIN OrderStatus os ON o.order_status = os.order_status_code\n"
                    + "LEFT JOIN OrderItems oi ON o.order_id = oi.order_id\n"
                    + "WHERE\n"
                    + "    o.created_at >= CURRENT_DATE - INTERVAL '7 days'\n"
                    + "    AND o.order_status IN ('PENDING', 'PAID')\n"
                    + "GROUP BY\n"
                    + "    o.order_id,\n"
                    + "    o.order_code,\n"
                    + "    c.full_name,\n"
                    + "    os.description,\n"
                    + "    o.payment_status,\n"
                    + "    o.total_amount,\n"
                    + "    o.created_at\n"
                    + "ORDER BY\n"
                    + "    o.created_at DESC;";

            ArrayList<OrderSummary> temp = new ArrayList<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.add(new OrderSummary(rs.getInt(1), rs.getString(2),
                        rs.getString(3), rs.getString(4), rs.getString(5),
                        rs.getBigDecimal(6), rs.getInt(7), rs.getDate(8)));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, "Lỗi recentOrder: " + ex.getMessage(), ex);
        }
        return null;
    }

    public static void main(String[] args) {
        dashboardDAO d = new dashboardDAO();
        System.out.println(d.revenue30Day());
    }
}
