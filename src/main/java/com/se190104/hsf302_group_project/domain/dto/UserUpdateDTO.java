package com.se190104.hsf302_group_project.domain.dto;

public class UserUpdateDTO {

    private long id;
    private String fullName;
    private String address;
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
