package com.se190104.hsf302_group_project.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.se190104.hsf302_group_project.domain.Cart;
import com.se190104.hsf302_group_project.domain.User;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    Cart findByUser(User user);
}
