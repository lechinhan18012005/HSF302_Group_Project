<%--
    Trang hiển thị danh sách sản phẩm trong trang quản trị
    Sử dụng bảng để hiển thị thông tin và phân trang
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%-- Sử dụng JSTL Core để xử lý logic --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Sử dụng JSTL Formatting để định dạng số và tiền tệ --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <%-- Thiết lập thông tin meta cho trang web --%>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <%-- Tiêu đề trang quản trị --%>
    <title>Dashboard</title>
    <%-- Link CSS cho giao diện --%>
    <link href="/css/styles.css" rel="stylesheet"/>
    <%-- Script Font Awesome cho các icon --%>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
                <h1 class="mt-4">Manage Products</h1>
                <%-- Breadcrumb điều hướng --%>
                <ol class="breadcrumb mb-4">
                    <%-- Link về trang chính quản trị --%>
                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                    <%-- Trang hiện tại: sản phẩm --%>
                    <li class="breadcrumb-item active">Product</li>
                </ol>
                <%-- Container với margin top --%>
                <div class="mt-5">
                    <%-- Bootstrap row --%>
                    <div class="row">
                        <%-- Column full width với auto margin --%>
                        <div class="col-12 mx-auto">
                            <%-- Flexbox layout cho tiêu đề và nút tạo --%>
                            <div class="d-flex justify-content-between">
                                <%-- Tiêu đề bảng sản phẩm --%>
                                <h3>Table products</h3>
                                <%-- Nút tạo sản phẩm mới --%>
                                <a href="/admin/product/create" class="btn btn-primary">Create a
                                    product</a>
                            </div>

                            <%-- Đường phân cách --%>
                            <hr/>
                            <%-- Bảng hiển thị danh sách sản phẩm với Bootstrap styling --%>
                            <table class=" table table-bordered table-hover">
                                <%-- Header của bảng --%>
                                <thead>
                                <tr>
                                    <%-- Cột ID sản phẩm --%>
                                    <th>ID</th>
                                    <%-- Cột tên sản phẩm --%>
                                    <th>Name</th>
                                    <%-- Cột giá sản phẩm --%>
                                    <th>Price</th>
                                    <%-- Cột nhà sản xuất --%>
                                    <th>Factory</th>
                                    <%-- Cột các hành động (xem, sửa, xóa) --%>
                                    <th>Action</th>
                                </tr>
                                </thead>
                                <%-- Nội dung của bảng --%>
                                <tbody>
                                <%-- Lặp qua danh sách sản phẩm --%>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                            <%-- Hiển thị ID sản phẩm --%>
                                        <th>${product.id}</th>
                                            <%-- Hiển thị tên sản phẩm --%>
                                        <td>${product.name}</td>
                                        <td>
                                                <%-- Định dạng giá sản phẩm theo kiểu số và thêm ký hiệu đồng --%>
                                            <fmt:formatNumber type="number"
                                                              value="${product.price}"/> đ
                                        </td>
                                            <%-- Hiển thị nhà sản xuất --%>
                                        <td>${product.factory}</td>
                                        <td>
                                                <%-- Nút xem chi tiết sản phẩm --%>
                                            <a href="/admin/product/${product.id}"
                                               class="btn btn-success">View</a>
                                                <%-- Nút cập nhật sản phẩm --%>
                                            <a href="/admin/product/update/${product.id}"
                                               class="btn btn-warning  mx-2">Update</a>
                                                <%-- Nút xóa sản phẩm --%>
                                            <a href="/admin/product/delete/${product.id}"
                                               class="btn btn-danger">Delete</a>
                                        </td>
                                    </tr>

                                </c:forEach>

                                </tbody>
                            </table>
                            <%-- Phân trang sử dụng Bootstrap pagination --%>
                            <nav aria-label="Page navigation example">
                                <%-- Danh sách các trang --%>
                                <ul class="pagination justify-content-center">
                                    <%-- Nút Previous để chuyển về trang trước --%>
                                    <li class="page-item">
                                        <%-- Vô hiệu hóa nút Previous nếu đang ở trang đầu --%>
                                        <a class="${1 eq currentPage ? 'disabled page-link' : 'page-link'}"
                                           href="/admin/product?page=${currentPage - 1}"
                                           aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <%-- Lặp qua các số trang --%>
                                    <c:forEach begin="0" end="${totalPages - 1}" varStatus="loop">
                                        <li class="page-item">
                                                <%-- Đánh dấu trang hiện tại với class active --%>
                                            <a class="${(loop.index + 1) eq currentPage ? 'active page-link' : 'page-link'}"
                                               href="/admin/product?page=${loop.index + 1}">
                                                    ${loop.index + 1}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <%-- Nút Next để chuyển sang trang tiếp theo --%>
                                    <li class="page-item">
                                        <%-- Vô hiệu hóa nút Next nếu đang ở trang cuối --%>
                                        <a class="${totalPages eq currentPage ? 'disabled page-link' : 'page-link'}"
                                           href="/admin/product?page=${currentPage + 1}"
                                           aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
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