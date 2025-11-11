package com.se190104.hsf302_group_project.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.se190104.hsf302_group_project.domain.Cart;
import com.se190104.hsf302_group_project.domain.CartDetail;
import com.se190104.hsf302_group_project.domain.Product;

@Repository
public interface CartDetailRepository extends JpaRepository<CartDetail, Long> {
    boolean existsByCartAndProduct(Cart cart, Product product);

    CartDetail findByCartAndProduct(Cart cart, Product product);
}
