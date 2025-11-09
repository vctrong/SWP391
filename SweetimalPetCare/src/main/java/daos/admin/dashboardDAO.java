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
            String qr = "select \n"
                    + "(select COALESCE(sum(total_amount),0) from Orders\n"
                    + "where payment_status = 'PAID' \n"
                    + "and created_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)\n"
                    + "and created_at < DATEADD(month, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))) \n"
                    + "+ \n"
                    + "(select COALESCE(sum(total_price),0) from Booking\n"
                    + "where payment_status = 'PAID'\n"
                    + "and created_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)\n"
                    + "and created_at < DATEADD(month, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)))\n"
                    + "as revenue";
            double revenue = 0;
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                revenue = rs.getDouble(1);
                return revenue;
            }

        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0.0;
    }

    public int bookingToday() {
        try {
            String qr = "SELECT COUNT(booking_id) AS total_bookings_today\n"
                    + "FROM Booking\n"
                    + "WHERE\n"
                    + "    created_at >= CAST(GETDATE() AS DATE)\n"
                    + "    AND created_at < DATEADD(day, 1, CAST(GETDATE() AS DATE))\n"
                    + "    AND current_status IN ('PENDING', 'COMFIRMED', 'COMPLETED', 'IN_PROGRESS');";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int orderToday() {
        try {
            String qr = "SELECT COUNT(order_id) AS orders_today\n"
                    + "FROM Orders\n"
                    + "WHERE\n"
                    + "	created_at >= CAST(GETDATE() AS DATE)\n"
                    + "    AND created_at < DATEADD(day, 1, CAST(GETDATE() AS DATE))\n"
                    + "	and order_status in ('COMPLETED', 'PAID', 'PENDING', 'PROGRESSING', 'SHIPPED')";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int customerInMonth() {
        try {
            String qr = "	SELECT COUNT(user_id) AS new_customers_this_month\n"
                    + "FROM Users\n"
                    + "WHERE\n"
                    + "    created_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)\n"
                    + "    AND created_at < DATEADD(month, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))\n"
                    + "	and role_id = 1";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public int orderPending() {
        try {
            String qr = "	SELECT COUNT(order_id) AS pending_orders\n"
                    + "FROM Orders\n"
                    + "WHERE\n"
                    + "    order_status = 'PENDING';";
            ResultSet rs = this.executeSelectQuery(qr, null);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public LinkedHashMap<String, Integer> topService() {
        try {
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
                    + "        AND b.created_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)\n"
                    + "        AND b.created_at < DATEADD(month, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))\n"
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
                    + "        AND b.created_at >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)\n"
                    + "        AND b.created_at < DATEADD(month, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))\n"
                    + ")\n"
                    + "\n"
                    + "SELECT \n"
                    + "    TOP 5\n"
                    + "    item_name AS label,\n"
                    + "    COUNT(*) AS data\n"
                    + "FROM \n"
                    + "    AllBookedItems\n"
                    + "GROUP BY \n"
                    + "    item_name\n"
                    + "ORDER BY \n"
                    + "    data DESC;";
            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public LinkedHashMap<String, Integer> revenue30Day() {
        try {
            String qr = "DECLARE @Today DATE = CAST(GETDATE() AS DATE);\n"
                    + "DECLARE @StartDate DATE = DATEADD(day, -29, @Today);\n"
                    + ";WITH DateTally (report_date) AS\n"
                    + "(\n"
                    + "    SELECT @StartDate AS report_date\n"
                    + "    UNION ALL\n"
                    + "    SELECT DATEADD(day, 1, report_date)\n"
                    + "    FROM DateTally\n"
                    + "    WHERE report_date < @Today\n"
                    + "),\n"
                    + "AllRevenueTransactions (revenue_date, amount) AS\n"
                    + "(\n"
                    + "    SELECT \n"
                    + "        CAST(created_at AS DATE), \n"
                    + "        total_amount \n"
                    + "    FROM Orders\n"
                    + "    WHERE \n"
                    + "        payment_status = 'PAID'\n"
                    + "        AND created_at >= @StartDate\n"
                    + "    UNION ALL\n"
                    + "    SELECT \n"
                    + "        CAST(created_at AS DATE), \n"
                    + "        total_price \n"
                    + "    FROM Booking\n"
                    + "    WHERE \n"
                    + "        payment_status = 'PAID'\n"
                    + "        AND created_at >= @StartDate\n"
                    + "),\n"
                    + "DailyTotals (report_date, total) AS\n"
                    + "(\n"
                    + "    SELECT \n"
                    + "        revenue_date, \n"
                    + "        SUM(amount) AS total\n"
                    + "    FROM AllRevenueTransactions\n"
                    + "    GROUP BY revenue_date\n"
                    + ")\n"
                    + "SELECT \n"
                    + "    CONVERT(varchar, tally.report_date, 23) AS label,\n"
                    + "    COALESCE(daily.total, 0) AS data \n"
                    + "FROM \n"
                    + "    DateTally AS tally\n"
                    + "LEFT JOIN \n"
                    + "    DailyTotals AS daily ON tally.report_date = daily.report_date\n"
                    + "ORDER BY\n"
                    + "    tally.report_date ASC\n"
                    + "OPTION (MAXRECURSION 30);";
            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public LinkedHashMap<String, Integer> topProduct() {
        try {
            String qr = "DECLARE @MonthStart DATETIME = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);\n"
                    + "SELECT \n"
                    + "    TOP 5\n"
                    + "    p.product_name AS label,\n"
                    + "    SUM(oi.quantity) AS data\n"
                    + "FROM \n"
                    + "    Orders AS o\n"
                    + "JOIN \n"
                    + "    OrderItems AS oi ON o.order_id = oi.order_id\n"
                    + "join \n"
                    + "	ProductVariant as pv on pv.variant_id = oi.variant_id\n"
                    + "JOIN \n"
                    + "    Product AS p ON pv.product_id = p.product_id\n"
                    + "WHERE \n"
                    + "    o.payment_status = 'PAID'\n"
                    + "    AND o.created_at >= @MonthStart\n"
                    + "    AND o.created_at < DATEADD(month, 1, @MonthStart)\n"
                    + "GROUP BY\n"
                    + "    p.product_name\n"
                    + "ORDER BY\n"
                    + "    data DESC;";
            LinkedHashMap<String, Integer> temp = new LinkedHashMap<>();
            ResultSet rs = this.executeSelectQuery(qr, null);
            while (rs.next()) {
                temp.put(rs.getString(1), rs.getInt(2));
            }
            return temp;
        } catch (SQLException ex) {
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<BookingSummary> recentBooking() {
        try {
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
                    + "    b.requested_date >= CAST(GETDATE() AS DATE)\n"
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
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public ArrayList<OrderSummary> recentOrder() {
        try {
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
                    + "    o.created_at >= DATEADD(day, -7, GETDATE())\n"
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
            Logger.getLogger(dashboardDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void main(String[] args) {
        dashboardDAO d = new dashboardDAO();
        System.out.println(d.revenue30Day());
    }
}
