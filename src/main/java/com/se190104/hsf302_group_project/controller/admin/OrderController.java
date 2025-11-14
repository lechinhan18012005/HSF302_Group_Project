package com.se190104.hsf302_group_project.controller.admin;

import com.se190104.hsf302_group_project.domain.Order;
import com.se190104.hsf302_group_project.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;
    private static final Logger log = LoggerFactory.getLogger(OrderController.class);

    @GetMapping("/admin/order")
    public String getDashboard(Model model,
                               @RequestParam(value = "page", defaultValue = "1") int page) {

        if (page < 1) page = 1;

        Pageable pageable = PageRequest.of(page - 1, 6);
        Page<Order> ordersPage = this.orderService.fetchAllOrders(pageable);
        List<Order> orders = ordersPage.getContent();

        model.addAttribute("orders", orders);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", ordersPage.getTotalPages());
        return "admin/order/show";
    }

    @GetMapping("/admin/order/{id}")
    public String getOrderDetailPage(Model model, @PathVariable long id) {
        Optional<Order> maybe = this.orderService.fetchOrderById(id);
        if (maybe.isPresent()) {
            Order order = maybe.get();
            model.addAttribute("order", order);
            model.addAttribute("id", id);
            model.addAttribute("orderDetails", order.getOrderDetails());
            return "admin/order/detail";
        }
        model.addAttribute("error", "Không tìm thấy đơn hàng.");
        return "admin/order/show";
    }

    @GetMapping("/admin/order/delete/{id}")
    public String getDeleteOrderPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        return "admin/order/delete";
    }

    @PostMapping("/admin/order/delete")
    public String postDeleteOrder(@ModelAttribute("id") long id, RedirectAttributes redirectAttributes) {
        try {
            this.orderService.deleteOrderById(id);
            redirectAttributes.addFlashAttribute("success", "Xóa đơn hàng thành công.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Xóa đơn hàng thất bại: " + ex.getMessage());
            log.error("Error deleting order {}", id, ex);
        }
        return "redirect:/admin/order";
    }

    @GetMapping("/admin/order/update/{id}")
    public String getUpdateOrderPage(Model model, @PathVariable long id, RedirectAttributes redirectAttributes) {
        Optional<Order> currentOrder = this.orderService.fetchOrderById(id);
        if (currentOrder.isPresent()) {
            model.addAttribute("newOrder", currentOrder.get());
            return "admin/order/update";
        }
        redirectAttributes.addFlashAttribute("error", "Không tìm thấy đơn hàng");
        return "redirect:/admin/order";
    }

    @PostMapping("/admin/order/update")
    public String handleUpdateOrder(@ModelAttribute("newOrder") Order order, RedirectAttributes redirectAttributes) {
        try {
            this.orderService.updateOrder(order);
            redirectAttributes.addFlashAttribute("success", "Cập nhật đơn hàng thành công.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Cập nhật đơn hàng thất bại: " + ex.getMessage());
            log.error("Error updating order {}", order != null ? order.getId() : null, ex);
        }
        return "redirect:/admin/order";
    }
}
