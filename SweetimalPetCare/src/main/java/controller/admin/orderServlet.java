/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import daos.admin.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.orderAdmin.order;
import model.orderAdmin.orderItem;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
@WebServlet(name = "orderAdminServlet", urlPatterns = {"/admin/order"})
public class orderServlet extends HttpServlet {

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
            out.println("<title>Servlet orderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet orderServlet at " + request.getContextPath() + "</h1>");
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
        OrderDAO oDAO = new OrderDAO();
        request.setAttribute("orderList", oDAO.getAllOrders());
        request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
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
        OrderDAO oDAO = new OrderDAO();
        HttpSession session = request.getSession();
        try {
            String orderCode = request.getParameter("orderCode");
            String customerIdStr = request.getParameter("customerId");
            long customerId = (customerIdStr != null && !customerIdStr.isEmpty()) ? Long.parseLong(customerIdStr) : 0;
            String addressIdStr = request.getParameter("shippingAddressId");
            Long shippingAddressId = (addressIdStr != null && !addressIdStr.isEmpty()) ? Long.parseLong(addressIdStr) : null;
            String paymentMethod = request.getParameter("paymentMethodCode");
            String notes = request.getParameter("notes");
            BigDecimal shippingFee = null;
            try {
                shippingFee = new BigDecimal(request.getParameter("shippingFee").trim());
            } catch (Exception e) {
                shippingFee = BigDecimal.ZERO;
            }

            String[] arrVariantIds = request.getParameterValues("variantIds");
            String[] arrQuantities = request.getParameterValues("quantities");
            // Kiểm tra validate cơ bản
            if (arrVariantIds == null || arrVariantIds.length == 0) {
                // Nếu không có sản phẩm -> Báo lỗi quay về trang cũ
                session.setAttribute("notifiType", "error");
                session.setAttribute("notifiMsg", "Tạo đơn hàng thất bại. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/admin/order?create=fail");
                return;
            }

            // --- C. XỬ LÝ TÍNH TOÁN & TẠO LIST ITEMS ---
            List<orderItem> listItems = new ArrayList<>();
            double calculatedSubtotal = 0;
            Map<Long, Integer> productMap = new HashMap<>();
            if (arrVariantIds != null && arrQuantities != null) {
                for (int i = 0; i < arrVariantIds.length; i++) {
                    try {
                        long vId = Long.parseLong(arrVariantIds[i]);
                        int qty = Integer.parseInt(arrQuantities[i]);

                        if (qty > 0) {
                            productMap.put(vId, productMap.getOrDefault(vId, 0) + qty);
                        }
                    } catch (NumberFormatException e) {
                        continue; // Bỏ qua nếu dữ liệu lỗi
                    }
                }
            }
            for (Map.Entry<Long, Integer> entry : productMap.entrySet()) {
                long variantId = entry.getKey();
                int quantity = entry.getValue();
                BigDecimal unitPrice = oDAO.getPriceVariantById(variantId);
                if (unitPrice != null) {
                    // Tạo OrderItem
                    orderItem item = new orderItem();
                    item.setVariantId(variantId);
                    item.setQuantity(quantity);
                    item.setUnitPrice(unitPrice);

                    double lineTotal = unitPrice.doubleValue() * quantity;
                    item.setLineTotal(lineTotal);

                    // Cộng tổng phụ
                    calculatedSubtotal += lineTotal;

                    // Thêm vào list
                    listItems.add(item);
                }
            }

            order newOrder = new order();
            if (orderCode == null || orderCode.trim().isEmpty()) {
                orderCode = "ORD-" + System.currentTimeMillis();
            }
            newOrder.setOrderCode(orderCode.toUpperCase());

            newOrder.setCustomerId(customerId);
            newOrder.setShippingAddressId(shippingAddressId);
            // Các trạng thái mặc định khi tạo mới
            newOrder.setOrderStatus("PENDING");
            newOrder.setPaymentStatus("PAID");
            newOrder.setPaymentMethodCode(paymentMethod);
            newOrder.setNotes(notes);
            newOrder.setCreatedAt(new Date());
            newOrder.setSubtotalAmount(calculatedSubtotal);
            newOrder.setShippingFee(shippingFee);
            BigDecimal castBig = new BigDecimal(calculatedSubtotal);
            newOrder.setTotalAmount(castBig.add(shippingFee));
            newOrder.setItems(listItems);
            long resultID = oDAO.insertOrder(newOrder);
            if (resultID > 0) {
                session.setAttribute("notifiType", "success");
                session.setAttribute("notifiMsg", "Tạo đơn hàng thành công! Mã đơn: " + newOrder.getOrderCode());
                response.sendRedirect(request.getContextPath() + "/admin/order?create=success");
            } else {
                // Thất bại
                session.setAttribute("notifiType", "error");
                session.setAttribute("notifiMsg", "Tạo đơn hàng thất bại. Vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/admin/order?create=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("notifiType", "error");
            session.setAttribute("notifiMsg", "System Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/order?create=fail");
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
