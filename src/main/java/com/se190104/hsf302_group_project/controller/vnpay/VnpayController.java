package com.se190104.hsf302_group_project.controller.vnpay;

import java.io.UnsupportedEncodingException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.se190104.hsf302_group_project.domain.Cart;
import com.se190104.hsf302_group_project.domain.CartDetail;
import com.se190104.hsf302_group_project.domain.User;
import com.se190104.hsf302_group_project.domain.dto.VnpayRequest;
import com.se190104.hsf302_group_project.repository.CartRepository;
import com.se190104.hsf302_group_project.repository.UserRepository;
import com.se190104.hsf302_group_project.service.ProductService;
import com.se190104.hsf302_group_project.service.VnpayService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/api/vnpay")
@AllArgsConstructor
public class VnpayController {
    private final VnpayService vnpayService;
    private final ProductService productService;
    private final UserRepository userRepository;
    private final CartRepository cartRepository;

    /**
     * Nhận form từ trang đặt hàng, tính tổng tiền giỏ hàng, gọi VNPay và redirect.
     */
    @PostMapping("/checkout")
    public String checkout(
            HttpServletRequest request,
            @RequestParam String receiverName,
            @RequestParam String receiverAddress,
            @RequestParam String receiverPhone,
            @RequestParam String paymentMethod // COD / VNPAY
    ) throws UnsupportedEncodingException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return "redirect:/login";
        }
        Long userId = (Long) session.getAttribute("id");

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Cart cart = cartRepository.findByUser(user);
        if (cart == null || cart.getCartDetails() == null || cart.getCartDetails().isEmpty()) {
            return "redirect:/cart";
        }

        // === CASE 1: Thanh toán COD (như logic cũ) ===
        if ("COD".equalsIgnoreCase(paymentMethod)) {
            productService.handlePlaceOrder(userId, session, receiverName, receiverAddress, receiverPhone);
            return "redirect:/thanks"; // trang cảm ơn
        }

        // === CASE 2: Thanh toán VNPay ===
        if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
            long total = 0L;
            for (CartDetail cd : cart.getCartDetails()) {
                total += (long) cd.getPrice(); // chỉnh theo kiểu dữ liệu price của bạn
            }

            VnpayRequest vnpayRequest = new VnpayRequest();
            vnpayRequest.setAmount(String.valueOf(total));

            String paymentUrl = vnpayService.createPayment(vnpayRequest);

            // Lưu tạm thông tin người nhận để tạo Order sau khi thanh toán thành công
            session.setAttribute("receiverName", receiverName);
            session.setAttribute("receiverAddress", receiverAddress);
            session.setAttribute("receiverPhone", receiverPhone);

            return "redirect:" + paymentUrl;
        }

        // Nếu gửi linh tinh value
        return "redirect:/cart";
    }

    @PostMapping
    public ResponseEntity<String> createPayment(@RequestBody VnpayRequest paymentRequest) {
        try {
            String paymentUrl = vnpayService.createPayment(paymentRequest);
            return ResponseEntity.ok(paymentUrl);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Đã xảy ra lỗi khi tạo thanh toán!");
        }
    }

    @GetMapping("/return")
    public String returnPayment(
            @RequestParam("vnp_ResponseCode") String responseCode,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if ("00".equals(responseCode)) {
            // Lấy lại info từ session
            Long userId = (Long) session.getAttribute("id");
            String receiverName = (String) session.getAttribute("receiverName");
            String receiverAddress = (String) session.getAttribute("receiverAddress");
            String receiverPhone = (String) session.getAttribute("receiverPhone");

            // Gọi lại service tạo order + clear cart
            productService.handlePlaceOrder(userId, session, receiverName, receiverAddress, receiverPhone);

            return "redirect:/thanks"; // trang cảm ơn
        } else {
            return "redirect:/payment-failed"; // hoặc /cart?error=payment
        }
    }
}
