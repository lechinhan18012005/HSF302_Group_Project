package com.se190104.hsf302_group_project.domain.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MemberAccountDto {

    private Long id;

    @Email
    private String email; // chỉ hiển thị, không cho sửa

    @NotBlank(message = "Full name không được để trống")
    @Size(min = 3, max = 100, message = "Full name phải từ 3 đến 100 ký tự")
    private String fullName;

    @NotBlank(message = "Số điện thoại không được để trống")
    private String phone;

    @Size(max = 255, message = "Địa chỉ tối đa 255 ký tự")
    private String address;

    // Đường dẫn avatar hiện tại (để hiển thị)
    private String avatar;
}
