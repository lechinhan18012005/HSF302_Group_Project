package com.se190104.hsf302_group_project.service;

import java.util.List;
import java.util.Optional;

import com.se190104.hsf302_group_project.domain.Order;
import com.se190104.hsf302_group_project.domain.OrderDetail;
import com.se190104.hsf302_group_project.domain.User;
import com.se190104.hsf302_group_project.repository.OrderDetailRepository;
import com.se190104.hsf302_group_project.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

/**
 * Service quản lý đơn hàng
 * Xử lý các chức năng: xem, cập nhật, xóa đơn hàng
 */
@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;

    public boolean hasOrder(long userId) {
        return orderRepository.existsByUserId(userId);
    }

    /**
     * Lấy danh sách tất cả đơn hàng với phân trang
     */
    public Page<Order> fetchAllOrders(Pageable page) {
        return this.orderRepository.findAll(page);
    }

    /**
     * Lấy thông tin đơn hàng theo ID
     */
    public Optional<Order> fetchOrderById(long id) {
        return this.orderRepository.findById(id);
    }

    /**
     * Xóa đơn hàng theo ID
     * Xóa tất cả chi tiết đơn hàng trước khi xóa đơn hàng chính
     */
    public void deleteOrderById(long id) {
        // Xóa chi tiết đơn hàng
        Optional<Order> orderOptional = this.fetchOrderById(id);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();
            List<OrderDetail> orderDetails = order.getOrderDetails();
            for (OrderDetail orderDetail : orderDetails) {
                this.orderDetailRepository.deleteById(orderDetail.getId());
            }
        }

        // Xóa đơn hàng
        this.orderRepository.deleteById(id);
    }

    /**
     * Cập nhật trạng thái đơn hàng
     */
    public void updateOrder(Order order) {
        Optional<Order> orderOptional = this.fetchOrderById(order.getId());
        if (orderOptional.isPresent()) {
            Order currentOrder = orderOptional.get();
            currentOrder.setStatus(order.getStatus());
            this.orderRepository.save(currentOrder);
        }
    }

    /**
     * Lấy danh sách đơn hàng theo người dùng
     */
    public List<Order> fetchOrderByUser(User user) {
        return this.orderRepository.findByUser(user);
    }

}
