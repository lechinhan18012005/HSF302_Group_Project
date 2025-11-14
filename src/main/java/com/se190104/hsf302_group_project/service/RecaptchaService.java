package com.se190104.hsf302_group_project.service;

import com.se190104.hsf302_group_project.domain.dto.RecaptchaResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class RecaptchaService {

    @Value("${recaptcha.secret}")
    private String secret;

    @Value("${recaptcha.verify-url}")
    private String recaptchaVerifyUrl;

    public boolean verify(String token) {
        RestTemplate restTemplate = new RestTemplate();

        Map<String, String> body = new HashMap<>();
        body.put("secret", secret);
        body.put("response", token);

        RecaptchaResponse response =
                restTemplate.postForObject(recaptchaVerifyUrl, body, RecaptchaResponse.class);

        return response != null && response.isSuccess();
    }
}
