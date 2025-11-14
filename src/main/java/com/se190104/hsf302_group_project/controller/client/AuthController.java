package com.se190104.hsf302_group_project.controller.client;

import com.se190104.hsf302_group_project.service.RecaptchaService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final RecaptchaService recaptchaService;

    @PostMapping("/do-login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("g-recaptcha-response") String captchaToken,
            HttpServletRequest request) {

        if (!recaptchaService.verify(captchaToken)) {
            return "redirect:/login?captchaError";
        }

        request.setAttribute("username", username);
        request.setAttribute("password", password);

        return "forward:/do-login";
    }
}
