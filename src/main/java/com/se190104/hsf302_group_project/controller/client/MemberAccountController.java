package com.se190104.hsf302_group_project.controller.client;

import com.se190104.hsf302_group_project.domain.User;
import com.se190104.hsf302_group_project.domain.dto.MemberAccountDto;
import com.se190104.hsf302_group_project.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequestMapping("/member/account")
@RequiredArgsConstructor
public class MemberAccountController {

    private final UserService userService;

    @GetMapping
    public String showAccount(Model model, Principal principal) {
        // principal.getName() thường là email
        User user = userService.findByEmail((String) principal.getName());

        MemberAccountDto dto = new MemberAccountDto();
        dto.setId(user.getId());
        dto.setEmail(user.getEmail());
        dto.setFullName(user.getFullName());
        dto.setPhone(user.getPhone());
        dto.setAddress(user.getAddress());
        dto.setAvatar(user.getAvatar()); // nếu có field avatar

        if (!model.containsAttribute("profile")) {
            model.addAttribute("profile", dto);
        }

        return "client/account/profile"; // trỏ tới file account.html ở dưới
    }

    @PostMapping
    public String updateAccount(@Valid @ModelAttribute("profile") MemberAccountDto profile,
                                BindingResult bindingResult,
                                MultipartFile avatarFile,
                                Principal principal,
                                Model model,
                                RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("org.springframework.validation.BindingResult.profile", bindingResult);
            model.addAttribute("profile", profile);
            return "client/account/profile";
        }

        // Gọi service update thông tin + avatar
        userService.updateMemberProfile(principal.getName(), profile, avatarFile);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật tài khoản thành công");
        return "redirect:/";
    }
}
