/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class HistoryKPIs {

    private int totalOrdersAndBookings; // Tổng đơn (gộp cả order và booking)
    private int processingItems;        // Đang xử lý (gộp cả order và booking)
    private double totalSpent;

    public HistoryKPIs() {
    }

    public HistoryKPIs(int totalOrdersAndBookings, int processingItems, double totalSpent) {
        this.totalOrdersAndBookings = totalOrdersAndBookings;
        this.processingItems = processingItems;
        this.totalSpent = totalSpent;
    }

    public int getTotalOrdersAndBookings() {
        return totalOrdersAndBookings;
    }

    public void setTotalOrdersAndBookings(int totalOrdersAndBookings) {
        this.totalOrdersAndBookings = totalOrdersAndBookings;
    }

    public int getProcessingItems() {
        return processingItems;
    }

    public void setProcessingItems(int processingItems) {
        this.processingItems = processingItems;
    }

    public double getTotalSpent() {
        return totalSpent;
    }

    public void setTotalSpent(double totalSpent) {
        this.totalSpent = totalSpent;
    }

}
