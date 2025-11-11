<%--
    Trang xóa sản phẩm trong trang quản trị
    Sử dụng Spring MVC và JSP để hiển thị form xác nhận xóa sản phẩm
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- Sử dụng JSTL Core để xử lý logic --%>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> <%-- Sử dụng Spring Form taglib để tạo form --%>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <%-- Thiết lập thông tin meta cho trang web --%>
                <meta charset="utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <title>Delete Product</title> <%-- Tiêu đề trang xóa sản phẩm --%>
                <%-- Link CSS cho giao diện --%>
                <link href="/css/styles.css" rel="stylesheet" />

                <%-- Script Font Awesome cho các icon --%>
                <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
            </head>

            <body class="sb-nav-fixed"> <%-- Class CSS cho layout cố định thanh điều hướng --%>
                <%-- Include header của trang quản trị --%>
                <jsp:include page="../layout/header.jsp" />
                <div id="layoutSidenav"> <%-- Container cho layout sidebar --%>
                    <%-- Include sidebar của trang quản trị --%>
                    <jsp:include page="../layout/sidebar.jsp" />
                    <div id="layoutSidenav_content"> <%-- Vùng nội dung chính --%>
                        <main>
                            <div class="container-fluid px-4"> <%-- Container fluid với padding horizontal --%>
                                <%-- Tiêu đề trang --%>
                                <h1 class="mt-4">Products</h1>
                                <%-- Breadcrumb điều hướng --%>
                                <ol class="breadcrumb mb-4">
                                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li> <%-- Link về trang chính quản trị --%>
                                    <li class="breadcrumb-item"><a href="/admin/product">Product</a></li> <%-- Link về trang danh sách sản phẩm --%>
                                    <li class="breadcrumb-item active">Delete</li> <%-- Trang hiện tại: xóa sản phẩm --%>
                                </ol>
                                <div class=" mt-5"> <%-- Container với margin top --%>
                                    <div class="row"> <%-- Bootstrap row --%>
                                        <div class="col-12 mx-auto"> <%-- Column full width với auto margin --%>
                                            <div class="d-flex justify-content-between"> <%-- Flexbox layout --%>
                                                <%-- Tiêu đề hiển thị ID sản phẩm cần xóa --%>
                                                <h3>Delete the product with id = ${id}</h3>
                                            </div>

                                            <hr /> <%-- Đường phân cách --%>
                                            <%-- Thông báo cảnh báo xác nhận xóa --%>
                                            <div class="alert alert-danger">
                                                Are you sure to delete this product ?
                                            </div>
                                            <%-- Form xác nhận xóa sản phẩm sử dụng Spring Form --%>
                                            <form:form method="post" action="/admin/product/delete"
                                                modelAttribute="newProduct">
                                                <%-- Input ẩn chứa ID sản phẩm cần xóa --%>
                                                <div class="mb-3" style="display: none;">
                                                    <label class="form-label">Id:</label>
                                                    <form:input value="${id}" type="text" class="form-control"
                                                        path="id" />
                                                </div>
                                                <%-- Nút xác nhận xóa với class Bootstrap danger --%>
                                                <button class="btn btn-danger">Confirm</button>
                                            </form:form>

                                        </div>

                                    </div>

                                </div>
                            </div>
                        </main>
                        <%-- Include footer của trang quản trị --%>
                        <jsp:include page="../layout/footer.jsp" />
                    </div>
                </div>
                <%-- Script Bootstrap cho các component tương tác --%>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                    crossorigin="anonymous"></script>
                <%-- Script tùy chỉnh cho trang --%>
                <script src="/js/scripts.js"></script>

            </body>

            </html>