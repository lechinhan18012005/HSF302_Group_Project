package com.se190104.hsf302_group_project.domain.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecaptchaResponse {
    private boolean success;
    @JsonProperty("error-codes")
    private List<String> errorCodes;
}
