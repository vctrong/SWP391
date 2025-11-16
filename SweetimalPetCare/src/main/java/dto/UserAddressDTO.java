/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserAddressDTO {

    private long addressId;
    private String label;
    private String recipientName;
    private String phone;
    private String fullAddress; // (ví dụ: "12 Nguyễn Văn A, Phường B, Quận C, Hà Nội")
    private boolean isDefault;

    public UserAddressDTO() {
    }

    public UserAddressDTO(long addressId, String label, String recipientName, String phone, String fullAddress, boolean isDefault) {
        this.addressId = addressId;
        this.label = label;
        this.recipientName = recipientName;
        this.phone = phone;
        this.fullAddress = fullAddress;
        this.isDefault = isDefault;
    }

    public long getAddressId() {
        return addressId;
    }

    public void setAddressId(long addressId) {
        this.addressId = addressId;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

}
