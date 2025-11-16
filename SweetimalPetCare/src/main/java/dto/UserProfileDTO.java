/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserProfileDTO {

    private String avatarUrl;
    private String fullName;
    private String roleName;
    private String membershipDuration; // (ví dụ: "Thành viên 2 năm")
    private String phone;
    private String email;
    private String createdAtFormatted; // (ví dụ: "12/01/2023")
    private String genderDisplay; // (ví dụ: "Nam", "Nữ", "Khác")
    private String birthdayFormatted; // (ví dụ: "01/06/1998")
    private String defaultAddressSummary; // (ví dụ: "12 Nguyễn Văn A, Hà Nội")
    private String lastUpdatedAtFormatted; // (ví dụ: "12/01/2025 23:27")
    private boolean is2faEnabled;

    public UserProfileDTO() {
    }

    public UserProfileDTO(String avatarUrl, String fullName, String roleName, String membershipDuration, String phone, String email, String createdAtFormatted, String genderDisplay, String birthdayFormatted, String defaultAddressSummary, String lastUpdatedAtFormatted, boolean is2faEnabled) {
        this.avatarUrl = avatarUrl;
        this.fullName = fullName;
        this.roleName = roleName;
        this.membershipDuration = membershipDuration;
        this.phone = phone;
        this.email = email;
        this.createdAtFormatted = createdAtFormatted;
        this.genderDisplay = genderDisplay;
        this.birthdayFormatted = birthdayFormatted;
        this.defaultAddressSummary = defaultAddressSummary;
        this.lastUpdatedAtFormatted = lastUpdatedAtFormatted;
        this.is2faEnabled = is2faEnabled;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getMembershipDuration() {
        return membershipDuration;
    }

    public void setMembershipDuration(String membershipDuration) {
        this.membershipDuration = membershipDuration;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCreatedAtFormatted() {
        return createdAtFormatted;
    }

    public void setCreatedAtFormatted(String createdAtFormatted) {
        this.createdAtFormatted = createdAtFormatted;
    }

    public String getGenderDisplay() {
        return genderDisplay;
    }

    public void setGenderDisplay(String genderDisplay) {
        this.genderDisplay = genderDisplay;
    }

    public String getBirthdayFormatted() {
        return birthdayFormatted;
    }

    public void setBirthdayFormatted(String birthdayFormatted) {
        this.birthdayFormatted = birthdayFormatted;
    }

    public String getDefaultAddressSummary() {
        return defaultAddressSummary;
    }

    public void setDefaultAddressSummary(String defaultAddressSummary) {
        this.defaultAddressSummary = defaultAddressSummary;
    }

    public String getLastUpdatedAtFormatted() {
        return lastUpdatedAtFormatted;
    }

    public void setLastUpdatedAtFormatted(String lastUpdatedAtFormatted) {
        this.lastUpdatedAtFormatted = lastUpdatedAtFormatted;
    }

    public boolean isIs2faEnabled() {
        return is2faEnabled;
    }

    public void setIs2faEnabled(boolean is2faEnabled) {
        this.is2faEnabled = is2faEnabled;
    }

}
