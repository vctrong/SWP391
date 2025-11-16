/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.sql.Date;

/**
 *
 * @author Vo Chi Trong - CE191062
 */
public class UserDTO {

    protected long userId;
    protected String username;
    protected String email;
    protected String phone;
    protected String fullName;
    protected int gender;       // 1: Male, 0: Female
    protected Date birthday;
    protected boolean isActive;
    protected String avatarUrl;

    // Trường hỗ trợ hiển thị (Join từ bảng Roles)
    protected int roleId;
    protected String roleName;

    public UserDTO() {
    }

    public UserDTO(long userId, String username, String email, String phone, String fullName, int gender, Date birthday, boolean isActive, String avatarUrl, int roleId, String roleName) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.fullName = fullName;
        this.gender = gender;
        this.birthday = birthday;
        this.isActive = isActive;
        this.avatarUrl = avatarUrl;
        this.roleId = roleId;
        this.roleName = roleName;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

}
