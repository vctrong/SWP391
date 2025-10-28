/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Pham Nguyen Xuan Mai - CE190106
 */
public class OrderDAO extends db.DBContext{
    /**
     * Place order from cart for a given customer.
     * Returns orderId on success or throws SQLException on failure.
     *
     * Simple implementation: no explicit transaction control.
     */
    public int placeOrderFromCart(int customerId, int shippingAddressId, String paymentMethod, double shippingFee) throws SQLException {
        try {
            // 1) Read cart items with current price and stock
            String sqlCart = "SELECT ci.variant_id, ci.quantity, v.price, v.stock_quantity " +
                             "FROM CartItem ci JOIN ProductVariant v ON ci.variant_id = v.variant_id " +
                             "WHERE ci.customer_id = ?";
            PreparedStatement psCart = getConnection().prepareStatement(sqlCart);
            psCart.setInt(1, customerId);
            ResultSet rsCart = psCart.executeQuery();

            class Line { int variantId; int qty; double unitPrice; int stock; }
            List<Line> lines = new ArrayList<>();
            double subtotal = 0.0;

            while (rsCart.next()) {
                Line L = new Line();
                L.variantId = rsCart.getInt("variant_id");
                L.qty = rsCart.getInt("quantity");
                L.unitPrice = rsCart.getDouble("price");
                L.stock = rsCart.getInt("stock_quantity");
                if (L.qty <= 0) continue;
                lines.add(L);
                subtotal += L.unitPrice * L.qty;
            }
            rsCart.close();
            psCart.close();

            if (lines.isEmpty()) {
                throw new SQLException("Cart is empty");
            }

            double discount = 0.0;
            double tax = 0.0;
            double total = subtotal - discount + shippingFee + tax;

            // 2) Insert Orders
            String orderCode = generateOrderCode();
            String sqlInsertOrder = "INSERT INTO Orders(order_code, customer_id, shipping_address_id, order_status, subtotal_amount, discount_amount, shipping_fee, tax_amount, total_amount) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psInsertOrder = getConnection().prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS);
            psInsertOrder.setString(1, orderCode);
            psInsertOrder.setInt(2, customerId);
            psInsertOrder.setInt(3, shippingAddressId);
            psInsertOrder.setString(4, "PENDING");
            psInsertOrder.setDouble(5, subtotal);
            psInsertOrder.setDouble(6, discount);
            psInsertOrder.setDouble(7, shippingFee);
            psInsertOrder.setDouble(8, tax);
            psInsertOrder.setDouble(9, total);
            int affected = psInsertOrder.executeUpdate();
            if (affected == 0) {
                psInsertOrder.close();
                throw new SQLException("Insert order failed");
            }
            ResultSet gen = psInsertOrder.getGeneratedKeys();
            int orderId;
            if (gen.next()) {
                orderId = gen.getInt(1);
            } else {
                gen.close();
                psInsertOrder.close();
                throw new SQLException("No order id returned");
            }
            gen.close();
            psInsertOrder.close();

            // 3) For each line: insert OrderItems, decrement stock, insert InventoryTransaction
            String sqlInsertItem = "INSERT INTO OrderItems(order_id, variant_id, unit_price, quantity) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE ProductVariant SET stock_quantity = stock_quantity - ? WHERE variant_id = ? AND stock_quantity >= ?";
            String sqlInsertTxn = "INSERT INTO InventoryTransaction(variant_id, location_id, txn_type_code, quantity, reference_no, note) VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement psInsertItem = null;
            PreparedStatement psUpdateStock = null;
            PreparedStatement psInsertTxn = null;

            try {
                psInsertItem = getConnection().prepareStatement(sqlInsertItem);
                psUpdateStock = getConnection().prepareStatement(sqlUpdateStock);
                psInsertTxn = getConnection().prepareStatement(sqlInsertTxn);

                for (Line L : lines) {
                    // check stock as read earlier; extra protection with conditional update
                    if (L.stock < L.qty) {
                        throw new SQLException("Insufficient stock for variant_id=" + L.variantId);
                    }

                    // insert order item
                    psInsertItem.setInt(1, orderId);
                    psInsertItem.setInt(2, L.variantId);
                    psInsertItem.setDouble(3, L.unitPrice);
                    psInsertItem.setInt(4, L.qty);
                    psInsertItem.executeUpdate();

                    // decrement stock atomically (WHERE checks available stock)
                    psUpdateStock.setInt(1, L.qty);
                    psUpdateStock.setInt(2, L.variantId);
                    psUpdateStock.setInt(3, L.qty);
                    int rows = psUpdateStock.executeUpdate();
                    if (rows == 0) {
                        throw new SQLException("Failed to decrement stock for variant_id=" + L.variantId);
                    }

                    // insert inventory transaction (use location_id = 1 by default)
                    psInsertTxn.setInt(1, L.variantId);
                    psInsertTxn.setInt(2, 1);
                    psInsertTxn.setString(3, "SALE");
                    psInsertTxn.setInt(4, L.qty);
                    psInsertTxn.setString(5, orderCode);
                    psInsertTxn.setString(6, "Sale - order " + orderCode);
                    psInsertTxn.executeUpdate();
                }
            } finally {
                try { if (psInsertItem != null) psInsertItem.close(); } catch (SQLException e) {}
                try { if (psUpdateStock != null) psUpdateStock.close(); } catch (SQLException e) {}
                try { if (psInsertTxn != null) psInsertTxn.close(); } catch (SQLException e) {}
            }

            // 4) Insert OrderStatusHistory
            PreparedStatement psStatus = getConnection().prepareStatement(
                    "INSERT INTO OrderStatusHistory(order_id, status_code, changed_by, note) VALUES (?, ?, ?, ?)");
            psStatus.setInt(1, orderId);
            psStatus.setString(2, "PENDING");
            psStatus.setInt(3, customerId);
            psStatus.setString(4, "Order placed");
            psStatus.executeUpdate();
            psStatus.close();

            // 5) Payments (mark success for CASH/EWALLET)
            String paymentStatus = "PENDING";
            java.sql.Timestamp paidAt = null;
            if (paymentMethod != null && ("CASH".equalsIgnoreCase(paymentMethod) || "EWALLET".equalsIgnoreCase(paymentMethod))) {
                paymentStatus = "SUCCESS";
                paidAt = new java.sql.Timestamp(new Date().getTime());
            }
            PreparedStatement psPayment = getConnection().prepareStatement(
                    "INSERT INTO Payments(order_id, payment_method_code, amount, status, transaction_ref, paid_at) VALUES (?, ?, ?, ?, ?, ?)");
            psPayment.setInt(1, orderId);
            psPayment.setString(2, paymentMethod);
            psPayment.setDouble(3, total);
            psPayment.setString(4, paymentStatus);
            psPayment.setString(5, "TXN-" + orderCode);
            if (paidAt != null) psPayment.setTimestamp(6, paidAt); else psPayment.setTimestamp(6, null);
            psPayment.executeUpdate();
            psPayment.close();

            // 6) Invoice
            PreparedStatement psInv = getConnection().prepareStatement(
                    "INSERT INTO Invoice(invoice_code, order_id, issue_date, total_amount, tax_amount, note) VALUES (?, ?, ?, ?, ?, ?)");
            psInv.setString(1, "INV" + orderCode);
            psInv.setInt(2, orderId);
            psInv.setTimestamp(3, new java.sql.Timestamp(new Date().getTime()));
            psInv.setDouble(4, total);
            psInv.setDouble(5, tax);
            psInv.setString(6, "Invoice for order " + orderCode);
            psInv.executeUpdate();
            psInv.close();

            // 7) Shipping
            PreparedStatement psShip = getConnection().prepareStatement(
                    "INSERT INTO Shipping(order_id, carrier_name, tracking_number, shipped_at, delivered_at, status, note) VALUES (?, ?, ?, ?, ?, ?, ?)");
            psShip.setInt(1, orderId);
            psShip.setString(2, null);
            psShip.setString(3, null);
            psShip.setTimestamp(4, null);
            psShip.setTimestamp(5, null);
            psShip.setString(6, "PENDING");
            psShip.setString(7, "Awaiting fulfillment");
            psShip.executeUpdate();
            psShip.close();

            // 8) Clear cart
            PreparedStatement psClear = getConnection().prepareStatement("DELETE FROM CartItem WHERE customer_id = ?");
            psClear.setInt(1, customerId);
            psClear.executeUpdate();
            psClear.close();

            // Return orderId
            return orderId;

        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    private String generateOrderCode() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String ts = sdf.format(new Date());
        int rnd = (int)(Math.random() * 90) + 10;
        return "ORD" + ts + rnd;
    }

}
