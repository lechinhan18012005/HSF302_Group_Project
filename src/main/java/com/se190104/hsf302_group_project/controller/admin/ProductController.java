package com.se190104.hsf302_group_project.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import com.se190104.hsf302_group_project.domain.Product;
import com.se190104.hsf302_group_project.service.ProductService;
import com.se190104.hsf302_group_project.service.UploadService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller quản lý sản phẩm cho admin
 * Xử lý các chức năng: xem, tạo, cập nhật, xóa sản phẩm
 */
@Controller
public class ProductController {

    private final UploadService uploadService;
    private final ProductService productService;

    public ProductController(
            UploadService uploadService,
            ProductService productService) {
        this.uploadService = uploadService;
        this.productService = productService;
    }

    /**
     * Hiển thị danh sách sản phẩm với phân trang
     */
    @GetMapping("/admin/product")
    public String getProduct(
            Model model,
            @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                // Chuyển đổi tham số page từ String sang int
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception e) {
            // Nếu có lỗi, mặc định về trang 1
        }

        // Tạo đối tượng Pageable với 5 sản phẩm mỗi trang
        Pageable pageable = PageRequest.of(page - 1, 5);
        Page<Product> prs = this.productService.fetchProducts(pageable);
        List<Product> listProducts = prs.getContent();
        model.addAttribute("products", listProducts);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", prs.getTotalPages());

        return "admin/product/show";
    }

    /**
     * Mở trang tạo sản phẩm mới
     */
    @GetMapping("/admin/product/create")
    public String getCreateProductPage(Model model) {
        model.addAttribute("newProduct", new Product());
        return "admin/product/create";
    }

    /**
     * Xử lý tạo sản phẩm mới
     * Upload hình ảnh và lưu vào database
     */
    @PostMapping("/admin/product/create")
    public String handleCreateProduct(
            @ModelAttribute("newProduct") @Valid Product pr,
            BindingResult newProductBindingResult,
            @RequestParam("productImageFile") MultipartFile file,
            RedirectAttributes redirectAttributes) {
        // Kiểm tra lỗi validation
        if (newProductBindingResult.hasErrors()) {
            return "admin/product/create";
        }

        try {
            // Upload hình ảnh sản phẩm
            String image = this.uploadService.handleSaveUploadFile(file, "product");
            pr.setImage(image);

            // Lưu sản phẩm vào database
            this.productService.createProduct(pr);

            // Set flash success message
            redirectAttributes.addFlashAttribute("success", "Tạo sản phẩm thành công.");
        } catch (Exception ex) {
            // Set flash error message
            redirectAttributes.addFlashAttribute("error", "Tạo sản phẩm thất bại: " + ex.getMessage());
        }

        return "redirect:/admin/product";
    }

    /**
     * Mở trang cập nhật sản phẩm
     */
    @GetMapping("/admin/product/update/{id}")
    public String getUpdateProductPage(Model model, @PathVariable long id) {
        Optional<Product> currentProduct = this.productService.fetchProductById(id);
        if (currentProduct.isPresent()) {
            model.addAttribute("newProduct", currentProduct.get());
            return "admin/product/update";
        }
        // if product not found, redirect back to list with error
        model.addAttribute("error", "Không tìm thấy sản phẩm.");
        return "admin/product/show";
    }

    /**
     * Xử lý cập nhật thông tin sản phẩm
     * Có thể cập nhật hình ảnh hoặc giữ hình ảnh cũ
     */
    @PostMapping("/admin/product/update")
    public String handleUpdateProduct(@ModelAttribute("newProduct") @Valid Product pr,
            BindingResult newProductBindingResult,
            @RequestParam(value = "productImageFile", required = false) MultipartFile file,
            RedirectAttributes redirectAttributes) {

        // Kiểm tra lỗi validation
        if (newProductBindingResult.hasErrors()) {
            return "admin/product/update";
        }

        Optional<Product> maybeCurrent = this.productService.fetchProductById(pr.getId());
        if (maybeCurrent.isPresent()) {
            Product currentProduct = maybeCurrent.get();
            // Cập nhật hình ảnh nếu có file mới
            try {
                if (file != null && !file.isEmpty()) {
                    String img = this.uploadService.handleSaveUploadFile(file, "product");
                    currentProduct.setImage(img);
                }

                // Cập nhật các thông tin sản phẩm
                currentProduct.setName(pr.getName());
                currentProduct.setPrice(pr.getPrice());
                currentProduct.setQuantity(pr.getQuantity());
                currentProduct.setDetailDesc(pr.getDetailDesc());
                currentProduct.setShortDesc(pr.getShortDesc());
                currentProduct.setFactory(pr.getFactory());
                currentProduct.setTarget(pr.getTarget());

                // Lưu sản phẩm đã cập nhật
                this.productService.createProduct(currentProduct);
                redirectAttributes.addFlashAttribute("success", "Cập nhật sản phẩm thành công.");
            } catch (Exception ex) {
                redirectAttributes.addFlashAttribute("error", "Cập nhật thất bại: " + ex.getMessage());
            }
        }

        return "redirect:/admin/product";
    }

    /**
     * Mở trang xác nhận xóa sản phẩm
     */
    @GetMapping("/admin/product/delete/{id}")
    public String getDeleteProductPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        return "admin/product/delete";
    }

    /**
     * Xử lý xóa sản phẩm từ database
     */
    @PostMapping("/admin/product/delete")
    public String postDeleteProduct(@RequestParam long id, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            this.productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("success", "Xóa sản phẩm thành công.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Xóa sản phẩm thất bại: " + ex.getMessage());
        }
        return "redirect:/admin/product";
    }

    /**
     * Hiển thị chi tiết sản phẩm
     */
    @GetMapping("/admin/product/{id}")
    public String getProductDetailPage(Model model, @PathVariable long id) {
        Optional<Product> maybePr = this.productService.fetchProductById(id);
        if (maybePr.isPresent()) {
            model.addAttribute("product", maybePr.get());
            model.addAttribute("id", id);
            return "admin/product/detail";
        }
        model.addAttribute("error", "Không tìm thấy sản phẩm.");
        return "admin/product/show";
    }
}
