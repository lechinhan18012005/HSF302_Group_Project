package com.se190104.hsf302_group_project.controller.admin;

import com.se190104.hsf302_group_project.domain.User;
import com.se190104.hsf302_group_project.domain.dto.UserUpdateDTO;
import com.se190104.hsf302_group_project.service.OrderService;
import com.se190104.hsf302_group_project.service.UploadService;
import com.se190104.hsf302_group_project.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final UploadService uploadService;
    private final PasswordEncoder passwordEncoder;
    private final OrderService orderService;

    @GetMapping("/admin/user")
    public String getUserPage(
            Model model,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "10") int size,
            @RequestParam(name = "sort", defaultValue = "id") String sort,
            @RequestParam(name = "dir", defaultValue = "asc") String dir) {

        page = Math.max(page, 1);
        size = Math.max(size, 1);

        Sort sortSpec = "desc".equalsIgnoreCase(dir)
                ? Sort.by(sort).descending()
                : Sort.by(sort).ascending();

        Pageable pageable = PageRequest.of(page - 1, size, sortSpec);
        Page<User> usersPage = userService.getAllUsers(pageable);

        // Lấy thông tin user hiện tại để không cho phép xóa chính mình
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserEmail = authentication.getName();
        User currentUser = userService.getUserByEmail(currentUserEmail);

        model.addAttribute("users", usersPage.getContent());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", usersPage.getTotalPages());
        model.addAttribute("size", size);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/user/show";
    }

    @RequestMapping("/admin/user/{id}")
    public String getUserDetailPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("id", id);
        return "admin/user/detail";
    }

    @GetMapping("/admin/user/create") // GET
    public String getCreateUserPage(Model model) {
        model.addAttribute("newUser", new User());
        return "admin/user/create";
    }

    @PostMapping(value = "/admin/user/create")
    public String createUserPage(
                                 @ModelAttribute("newUser") @Valid User user,
                                 BindingResult newUserBindingResult,
                                 @RequestParam("avatarFile") MultipartFile file,
                                 RedirectAttributes redirectAttributes) {

        // Manual validation logic
        validateUserInput(user.getFullName(), user.getPhone(), user.getAddress(), newUserBindingResult);

        // Check for duplicate email
        if (this.userService.checkEmailExist(user.getEmail())) {
            newUserBindingResult.rejectValue("email", "email.exists", "Email đã tồn tại trong hệ thống");
        }

        // validate
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/create";
        }

        try {
            String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
            String hashPassword = this.passwordEncoder.encode(user.getPassword());

            user.setAvatar(avatar);
            user.setPassword(hashPassword);
            user.setRole(this.userService.getRoleByName(user.getRole().getName()));
            // save
            this.userService.handleSaveUser(user);

            redirectAttributes.addFlashAttribute("success", "Tạo người dùng thành công.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Tạo người dùng thất bại: " + ex.getMessage());
        }

        return "redirect:/admin/user";
    }

    @RequestMapping("/admin/user/update/{id}") // GET
    public String getUpdateUserPage(Model model, @PathVariable long id) {
        User currentUser = this.userService.getUserById(id);
        if (currentUser == null) {
            return "redirect:/admin/user";
        }

        UserUpdateDTO userUpdateDTO = new UserUpdateDTO(
            currentUser.getId(),
            currentUser.getFullName(),
            currentUser.getAddress(),
            currentUser.getPhone()
        );

        model.addAttribute("newUser", userUpdateDTO);
        model.addAttribute("userEmail", currentUser.getEmail()); // For display purposes
        return "admin/user/update";
    }

    @PostMapping("/admin/user/update")
    public String postUpdateUser(Model model,
                                @ModelAttribute("newUser") UserUpdateDTO userUpdateDTO,
                                BindingResult bindingResult,
                                RedirectAttributes redirectAttributes) {

        // Manual validation logic for update
        validateUserInput(userUpdateDTO.getFullName(), userUpdateDTO.getPhone(), userUpdateDTO.getAddress(), bindingResult);

        if (bindingResult.hasErrors()) {
            User currentUser = this.userService.getUserById(userUpdateDTO.getId());
            model.addAttribute("userEmail", currentUser != null ? currentUser.getEmail() : "");
            return "admin/user/update";
        }

        User currentUser = this.userService.getUserById(userUpdateDTO.getId());
        if (currentUser != null) {
            currentUser.setAddress(userUpdateDTO.getAddress());
            currentUser.setFullName(userUpdateDTO.getFullName());
            currentUser.setPhone(userUpdateDTO.getPhone());

            try {
                this.userService.handleSaveUser(currentUser);
                redirectAttributes.addFlashAttribute("success", "Cập nhật người dùng thành công.");
            } catch (Exception ex) {
                redirectAttributes.addFlashAttribute("error", "Cập nhật thất bại: " + ex.getMessage());
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Người dùng không tồn tại.");
        }
        return "redirect:/admin/user";
    }

    @GetMapping("/admin/user/delete/{id}")
    public String getDeleteUserPage(Model model, @PathVariable long id, RedirectAttributes redirectAttributes) {
        // Lấy thông tin user hiện tại đang đăng nhập
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserEmail = authentication.getName();
        User currentUser = userService.getUserByEmail(currentUserEmail);

        // Kiểm tra nếu admin đang cố gắng xóa chính mình
        if (currentUser != null && currentUser.getId() == id) {
            redirectAttributes.addFlashAttribute("error", "Bạn không thể xóa chính tài khoản của mình!");
            return "redirect:/admin/user";
        }

        model.addAttribute("id", id);
        //check coi user này có đơn hàng nào ko trc khi xóa nếu có thì không có xóa
        return "admin/user/delete";
    }

    @PostMapping("/admin/user/delete")
    public String postDeleteUser(RedirectAttributes box, @RequestParam("id") long id) {
        // Lấy thông tin user hiện tại đang đăng nhập
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserEmail = authentication.getName();
        User currentUser = userService.getUserByEmail(currentUserEmail);

        // Kiểm tra nếu admin đang cố gắng xóa chính mình
        if (currentUser != null && currentUser.getId() == id) {
            box.addFlashAttribute("error", "Bạn không thể xóa chính tài khoản của mình!");
            return "redirect:/admin/user";
        }

        boolean isOrders = orderService.hasOrder(id);
        if(isOrders) {
            box.addFlashAttribute("error", "This user has orders in the System that cannot be deleted");
            return "redirect:/admin/user";
        }
        try {
            userService.deleteAUser(id);
            box.addFlashAttribute("success", "Xóa người dùng thành công");
        } catch (Exception ex) {
            box.addFlashAttribute("error", "Xóa thất bại: " + ex.getMessage());
        }
        return "redirect:/admin/user";
    }

    // Helper methods for validation
    private void validateUserInput(String fullName, String phone, String address, BindingResult bindingResult) {
        // Validate full name
        if (fullName == null || fullName.trim().isEmpty()) {
            bindingResult.rejectValue("fullName", "fullName.empty", "Họ tên không được để trống");
        } else if (fullName.trim().length() < 3) {
            bindingResult.rejectValue("fullName", "fullName.short", "Họ tên phải có tối thiểu 3 ký tự");
        }

        // Validate phone
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^0[0-9]{9}$")) {
                bindingResult.rejectValue("phone", "phone.invalid", "Số điện thoại phải có 10 số và bắt đầu bằng số 0");
            }
        }

        // Validate address
        if (address != null && address.length() > 255) {
            bindingResult.rejectValue("address", "address.tooLong", "Địa chỉ không được vượt quá 255 ký tự");
        }
    }
}
