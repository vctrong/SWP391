/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class RecentActivity {

    private String type;
    private long id;             // order_id or booking_id
    private String refCode;      // order_code or booking_code (if any)
    private String title;        // product name or service name
    private Timestamp ts;        // timestamp to sort by (created_at or booking_time)
    private BigDecimal amount;   // order total (nullable for booking)
    private String status;       // order_status or booking status
    private String meta;

    public RecentActivity() {
    }

    public RecentActivity(String type, long id, String refCode, String title, Timestamp ts, BigDecimal amount, String status, String meta) {
        this.type = type;
        this.id = id;
        this.refCode = refCode;
        this.title = title;
        this.ts = ts;
        this.amount = amount;
        this.status = status;
        this.meta = meta;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getRefCode() {
        return refCode;
    }

    public void setRefCode(String refCode) {
        this.refCode = refCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Timestamp getTs() {
        return ts;
    }

    public void setTs(Timestamp ts) {
        this.ts = ts;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMeta() {
        return meta;
    }

    public void setMeta(String meta) {
        this.meta = meta;
    }

}
