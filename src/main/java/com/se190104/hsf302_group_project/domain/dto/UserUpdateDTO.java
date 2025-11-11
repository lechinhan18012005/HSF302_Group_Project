package com.se190104.hsf302_group_project.domain.dto;

import jakarta.validation.constraints.*;

public class UserUpdateDTO {

    private long id;

    @NotNull(message = "Họ tên không được để trống")
    @NotBlank(message = "Họ tên không được để trống")
    @Size(min = 3, message = "Họ tên phải có tối thiểu 3 ký tự")
    private String fullName;

    @Size(max = 255, message = "Địa chỉ không được vượt quá 255 ký tự")
    private String address;

    @Pattern(regexp = "^0[0-9]{9}$", message = "Số điện thoại phải có 10 số và bắt đầu bằng số 0")
    private String phone;

    // Constructors
    public UserUpdateDTO() {}

    public UserUpdateDTO(long id, String fullName, String address, String phone) {
        this.id = id;
        this.fullName = fullName;
        this.address = address;
        this.phone = phone;
    }

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
