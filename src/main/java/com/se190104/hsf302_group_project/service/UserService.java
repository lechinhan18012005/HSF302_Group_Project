package com.se190104.hsf302_group_project.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.NoSuchElementException;

import com.se190104.hsf302_group_project.domain.dto.MemberAccountDto;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.se190104.hsf302_group_project.domain.Role;
import com.se190104.hsf302_group_project.domain.User;
import com.se190104.hsf302_group_project.domain.dto.RegisterDTO;
import com.se190104.hsf302_group_project.repository.OrderRepository;
import com.se190104.hsf302_group_project.repository.ProductRepository;
import com.se190104.hsf302_group_project.repository.RoleRepository;
import com.se190104.hsf302_group_project.repository.UserRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final UploadService uploadService;

    public Page<User> getAllUsers(Pageable page) {
        return this.userRepository.findAll(page);
    }

    public List<User> getAllUsersByEmail(String email) {
        return this.userRepository.findOneByEmail(email);
    }

    public User handleSaveUser(User user) {
        return this.userRepository.save(user);
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public void deleteAUser(long id) {
        this.userRepository.deleteById(id);
    }

    public Role getRoleByName(String name) {
        return this.roleRepository.findByName(name);
    }

    public User registerDTOtoUser(RegisterDTO registerDTO) {
        User user = new User();
        user.setFullName(registerDTO.getFirstName() + " " + registerDTO.getLastName());
        user.setEmail(registerDTO.getEmail());
        user.setPassword(registerDTO.getPassword());
        return user;
    }

    public boolean checkEmailExist(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public long countUsers() {
        return this.userRepository.count();
    }

    public long countProducts() {
        return this.productRepository.count();
    }

    public long countOrders() {
        return this.orderRepository.count();
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Transactional
    public void updateMemberProfile(String email,
                                    MemberAccountDto profile,
                                    MultipartFile avatarFile) {

        User user = userRepository.findByEmail(email);

        // cập nhật thông tin cơ bản
        user.setFullName(profile.getFullName());
        user.setPhone(profile.getPhone());
        user.setAddress(profile.getAddress());

        // xử lý avatar nếu có upload
        if (avatarFile != null && !avatarFile.isEmpty()) {
            String avatar = uploadService.handleSaveUploadFile(avatarFile, "avatar");
            user.setAvatar(avatar);
        }
        userRepository.save(user);
    }
}
