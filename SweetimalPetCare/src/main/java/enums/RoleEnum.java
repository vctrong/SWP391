/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Enum.java to edit this template
 */
package enums;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public enum RoleEnum {

    ADMIN(4, "Admin", "fa-solid fa-user-tie"),
    STAFF(2, "Staff", "fa-solid fa-users"),
    VET(3, "Vet", "fa-solid fa-user-doctor"),
    CUSTOMER(1, "Customer", "fa-solid fa-user");

    private int code;
    private String text;
    private String icon;

    private RoleEnum(int code, String text, String icon) {
        this.code = code;
        this.text = text;
        this.icon = icon;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public static RoleEnum findCode(int code) {
        for (RoleEnum value : RoleEnum.values()) {
            if (value.code == code) {
                return value;
            }
        }
        return null;
    }

}
