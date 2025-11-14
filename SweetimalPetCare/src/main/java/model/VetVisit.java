package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class VetVisit {
    private long visitId;
    private Long bookingId;
    private long petId;
    private long ownerId;
    private long vetStaffId;
    private String vetStaffName;
    private String visitTypeCode;
    private String visitTypeDescription;
    private String petName;
    private LocalDateTime visitDate;
    private BigDecimal weightKg;
    private BigDecimal temperatureC;
    private String symptoms;
    private String diagnosisSummary;
    private String treatmentNotes;
    private LocalDate followUpDate;
    private LocalDateTime createdAt;

    public VetVisit(long visitId, Long bookingId, long petId, long ownerId, long vetStaffId,
                    String visitTypeCode, String visitTypeDescription, String petName, String vetStaffName, LocalDateTime visitDate,
                    BigDecimal weightKg, BigDecimal temperatureC, String symptoms,
                    String diagnosisSummary, String treatmentNotes, LocalDate followUpDate,
                    LocalDateTime createdAt) {
        this.visitId = visitId;
        this.bookingId = bookingId;
        this.petId = petId;
        this.ownerId = ownerId;
        this.vetStaffId = vetStaffId;
        this.visitTypeCode = visitTypeCode;
        this.visitTypeDescription = visitTypeDescription;
        this.petName = petName;
        this.vetStaffName = vetStaffName;
        this.visitDate = visitDate;
        this.weightKg = weightKg;
        this.temperatureC = temperatureC;
        this.symptoms = symptoms;
        this.diagnosisSummary = diagnosisSummary;
        this.treatmentNotes = treatmentNotes;
        this.followUpDate = followUpDate;
        this.createdAt = createdAt;
    }

    public long getVisitId() { return visitId; }
    public Long getBookingId() { return bookingId; }
    public long getPetId() { return petId; }
    public long getOwnerId() { return ownerId; }
    public long getVetStaffId() { return vetStaffId; }
    public String getVetStaffName() { return vetStaffName; }
    public String getVisitTypeCode() { return visitTypeCode; }
    public String getVisitTypeDescription() { return visitTypeDescription; }
    public String getPetName() { return petName; }
    public LocalDateTime getVisitDate() { return visitDate; }
    public BigDecimal getWeightKg() { return weightKg; }
    public BigDecimal getTemperatureC() { return temperatureC; }
    public String getSymptoms() { return symptoms; }
    public String getDiagnosisSummary() { return diagnosisSummary; }
    public String getTreatmentNotes() { return treatmentNotes; }
    public LocalDate getFollowUpDate() { return followUpDate; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    // Formatted helpers for JSP (Vietnamese date display)
    public String getVisitDateFormatted() {
        if (visitDate == null) return "";
        return visitDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
