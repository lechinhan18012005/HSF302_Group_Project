<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- Sử dụng JSTL Core để xử lý logic --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> <%-- Sử dụng Spring Form taglib --%>
<!DOCTYPE html>
<html lang="en">

<head>
    <%-- Thiết lập thông tin meta cho trang web --%>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Detail Product</title> <%-- Tiêu đề trang chi tiết sản phẩm --%>
    <%-- Link CSS cho giao diện --%>
    <link href="/css/styles.css" rel="stylesheet"/>

    <%-- Script Font Awesome cho các icon --%>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<body class="sb-nav-fixed"> <%-- Class CSS cho layout cố định thanh điều hướng --%>
<%-- Include header của trang quản trị --%>
<jsp:include page="../layout/header.jsp"/>
<div id="layoutSidenav"> <%-- Container cho layout sidebar --%>
    <%-- Include sidebar của trang quản trị --%>
    <jsp:include page="../layout/sidebar.jsp"/>
    <div id="layoutSidenav_content"> <%-- Vùng nội dung chính --%>
        <main>
            <div class="container-fluid px-4"> <%-- Container fluid với padding horizontal --%>
                <%-- Tiêu đề trang --%>
                <h1 class="mt-4">Products</h1>
                <%-- Breadcrumb điều hướng --%>
                <ol class="breadcrumb mb-4">
                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                    <%-- Link về trang chính quản tr�� --%>
                    <li class="breadcrumb-item"><a href="/admin/product">Product</a></li>
                    <%-- Link về trang danh sách sản phẩm --%>
                    <li class="breadcrumb-item active">View detail</li>
                    <%-- Trang hiện tại: xem chi tiết --%>
                </ol>
                <div class="container mt-5"> <%-- Container với margin top --%>
                    <div class="row"> <%-- Bootstrap row --%>
                        <div class="col-12 mx-auto"> <%-- Column full width với auto margin --%>
                            <div class="d-flex justify-content-between"> <%-- Flexbox layout --%>
                                <%-- Tiêu đề hiển thị ID sản phẩm đang xem --%>
                                <h3>Product detail with id = ${id}</h3>
                            </div>

                            <hr/>
                            <%-- Đường phân cách --%>

                            <%-- Card hiển thị thông tin chi tiết sản phẩm --%>
                            <div class="card" style="width: 60%">
                                <%-- Hình ảnh sản phẩm từ thư mục images/product --%>
                                <img class="card-img-top" src="/images/product/${product.image}"
                                     alt="Card image cap">

                                <%-- Header của card chứa tiêu đề thông tin sản phẩm --%>
                                <div class="card-header">
                                    Product information
                                </div>
                                <%-- Danh sách thông tin sản phẩm sử dụng Bootstrap list group --%>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item">ID: ${product.id}</li>
                                    <%-- Hiển thị ID sản phẩm --%>
                                    <li class="list-group-item">Name: ${product.name}</li>
                                    <%-- Hiển thị tên sản phẩm --%>
                                    <li class="list-group-item">Price: ${product.price}</li>
                                    <%-- Hiển thị giá sản phẩm --%>
                                </ul>
                            </div>
                            <%-- Nút quay lại trang danh sách sản phẩm --%>
                            <a href="/admin/product" class="btn btn-success mt-3">Back</a>

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
