<%--
    Trang cập nhật sản phẩm trong trang quản trị
    Sử dụng form Spring và JavaScript để preview hình ảnh
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%-- Sử dụng JSTL Core để xử lý logic --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Sử dụng Spring Form taglib để tạo form --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%-- Thiết lập thông tin meta cho trang web --%>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <%-- Tiêu đề trang cập nhật sản phẩm --%>
    <title>Update Product</title>
    <%-- Link CSS cho giao diện --%>
    <link href="/css/styles.css" rel="stylesheet"/>

    <%-- Script Font Awesome cho các icon --%>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <%-- Script jQuery để xử lý upload và preview hình ảnh --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <script>
        // Xử lý preview hình ảnh khi trang được tải
        $(document).ready(() => {
            // Lấy element input file cho hình ảnh
            const avatarFile = $("#avatarFile");
            // Lấy tên hình ảnh hiện tại từ server
            const orgImage = "${newProduct.image}";
            // Nếu có hình ảnh hiện tại, hiển thị nó
            if (orgImage) {
                const urlImage = "/images/product/" + orgImage;
                $("#avatarPreview").attr("src", urlImage);
                $("#avatarPreview").css({"display": "block"});
            }

            // Xử lý sự kiện khi người dùng chọn file mới
            avatarFile.change(function (e) {
                // Tạo URL tạm thời cho file vừa chọn để preview
                const imgURL = URL.createObjectURL(e.target.files[0]);
                $("#avatarPreview").attr("src", imgURL);
                $("#avatarPreview").css({"display": "block"});
            });
        });
    </script>
</head>


<%-- Class CSS cho layout cố định thanh điều hướng --%>
<body class="sb-nav-fixed">
<%-- Include header của trang quản trị --%>
<jsp:include page="../layout/header.jsp"/>
<%-- Container cho layout sidebar --%>
<div id="layoutSidenav">
    <%-- Include sidebar của trang quản trị --%>
    <jsp:include page="../layout/sidebar.jsp"/>
    <%-- Vùng nội dung chính --%>
    <div id="layoutSidenav_content">
        <main>
            <%-- Container fluid với padding horizontal --%>
            <div class="container-fluid px-4">
                <%-- Tiêu đề trang --%>
                <h1 class="mt-4">Products</h1>
                <%-- Breadcrumb điều hướng --%>
                <ol class="breadcrumb mb-4">
                    <%-- Link về trang chính quản trị --%>
                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                    <%-- Link về trang danh sách sản phẩm --%>
                    <li class="breadcrumb-item"><a href="/admin/product">Product</a></li>
                    <%-- Trang hiện tại: cập nhật --%>
                    <li class="breadcrumb-item active">Update</li>
                </ol>
                <%-- Container với margin top --%>
                <div class=" mt-5">
                    <%-- Bootstrap row --%>
                    <div class="row">
                        <%-- Column responsive với auto margin --%>
                        <div class="col-md-6 col-12 mx-auto">
                            <%-- Tiêu đề form --%>
                            <h3>Update a product</h3>
                            <%-- Đường phân cách --%>
                            <hr/>
                            <%-- Form cập nhật sản phẩm với Spring Form, hỗ trợ multipart cho upload file --%>
                            <form:form method="post" action="/admin/product/update" class="row"
                                       enctype="multipart/form-data" modelAttribute="newProduct">
                                <%-- Thiết lập các biến chứa lỗi validation từ Spring --%>
                                <c:set var="errorName">
                                    <form:errors path="name" cssClass="invalid-feedback"/>
                                </c:set>
                                <c:set var="errorPrice">
                                    <form:errors path="price" cssClass="invalid-feedback"/>
                                </c:set>
                                <c:set var="errorDetailDesc">
                                    <form:errors path="detailDesc" cssClass="invalid-feedback"/>
                                </c:set>
                                <c:set var="errorShortDesc">
                                    <form:errors path="shortDesc" cssClass="invalid-feedback"/>
                                </c:set>
                                <c:set var="errorQuantity">
                                    <form:errors path="quantity" cssClass="invalid-feedback"/>
                                </c:set>

                                <%-- Input ẩn chứa ID sản phẩm để server biết sản phẩm nào cần cập nhật --%>
                                <div class="mb-3" style="display: none;">
                                    <label class="form-label">Id:</label>
                                    <form:input type="text" class="form-control" path="id"/>
                                </div>

                                <%-- Trường nhập tên sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Name:</label>
                                    <form:input type="text"
                                                class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                                                path="name"/>
                                        ${errorName}
                                </div>
                                <%-- Trường nhập giá sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Price:</label>
                                    <form:input type="number"
                                                class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                                                path="price"/>
                                        ${errorPrice}
                                </div>
                                <%-- Trường mô tả chi tiết sản phẩm --%>
                                <div class="mb-3 col-12">
                                    <label class="form-label">Detail description:</label>
                                    <form:textarea type="text"
                                                   class="form-control ${not empty errorDetailDesc ? 'is-invalid' : ''}"
                                                   path="detailDesc"/>
                                        ${errorDetailDesc}
                                </div>
                                <%-- Trường mô tả ngắn sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Short description:</label>
                                    <form:input type="text"
                                                class="form-control ${not empty errorShortDesc ? 'is-invalid' : ''}"
                                                path="shortDesc"/>
                                        ${errorShortDesc}
                                </div>
                                <%-- Trường nhập số lượng sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Quantity:</label>
                                    <form:input type="number"
                                                class="form-control ${not empty errorQuantity ? 'is-invalid' : ''}"
                                                path="quantity"/>
                                        ${errorQuantity}
                                </div>

                                <%-- Dropdown chọn nhà sản xuất --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Factory:</label>
                                    <form:select class="form-select" path="factory">
                                        <form:option value="APPLE">Apple (MacBook)</form:option>
                                        <form:option value="ASUS">Asus</form:option>
                                        <form:option value="LENOVO">Lenovo</form:option>
                                        <form:option value="DELL">Dell</form:option>
                                        <form:option value="LG">LG</form:option>
                                        <form:option value="ACER">Acer</form:option>
                                    </form:select>
                                </div>
                                <%-- Dropdown chọn đối tượng sử dụng --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Target:</label>
                                    <form:select class="form-select" path="target">
                                        <form:option value="GAMING">Gaming</form:option>
                                        <form:option value="SINHVIEN-VANPHONG">Sinh viên - Văn phòng
                                        </form:option>
                                        <form:option value="THIET-KE-DO-HOA">Thiết kế đồ họa
                                        </form:option>
                                        <form:option value="MONG-NHE">Mỏng nhẹ</form:option>
                                        <form:option value="DOANH-NHAN">Doanh nhân</form:option>
                                    </form:select>
                                </div>
                                <%-- Input file để upload hình ảnh mới --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label for="avatarFile" class="form-label">Image:</label>
                                    <input class="form-control" type="file" id="avatarFile"
                                           accept=".png, .jpg, .jpeg" name="productImageFile"/>
                                </div>
                                <%-- Vùng hiển thị preview hình ảnh --%>
                                <div class="col-12 mb-3">
                                    <img style="max-height: 250px; display: none;" alt="avatar preview"
                                         id="avatarPreview"/>
                                </div>
                                <%-- Nút submit form cập nhật --%>
                                <div class="col-12 mb-5">
                                    <button type="submit" class="btn btn-warning">Update</button>
                                </div>
                            </form:form>

                        </div>

                    </div>

                </div>
            </div>
        </main>
        <%-- Include footer của trang quản trị --%>
        <jsp:include page="../layout/footer.jsp"/>
    </div>
</div>
<%-- Script Bootstrap cho các component tương tác --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
<%-- Script tùy chỉnh cho trang --%>
<script src="/js/scripts.js"></script>

</body>

</html>