<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Navigation bar chính cho trang admin với Bootstrap styling --%>
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <!-- Navbar Brand - Logo/tên thương hiệu của ứng dụng -->
    <a class="navbar-brand ps-3" href="/admin">Laptopshop</a>

    <!-- Nút toggle để ẩn/hiện sidebar bên trái -->
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i
            class="fas fa-bars"></i></button>

    <!-- Form tìm kiếm navbar - ẩn trên màn hình nhỏ, hiện trên màn hình trung bình trở lên -->
    <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <%-- Hiển thị lời chào người dùng đã đăng nhập --%>
                <span style="color: white;">Welcome,
                    <%-- Lấy tên người dùng từ Principal object của Spring Security --%>
                    <%=request.getUserPrincipal().getName().toString()%>
<%--                    <%=request.getUserPrincipal().getName()%>--%>
                </span>
    </form>

    <!-- Menu navbar bên phải cho tài khoản người dùng -->
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <%-- Dropdown menu cho các tùy chọn tài khoản --%>
        <li class="nav-item dropdown">
            <%-- Link dropdown với icon user --%>
            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button"
               data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>

            <%-- Danh sách dropdown menu căn phải --%>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <%-- Link đến trang cài đặt --%>
                <li><a class="dropdown-item" href="#!">Settings</a></li>

                <%-- Đường phân cách trong menu --%>
                <li>
                    <hr class="dropdown-divider" />
                </li>

                <%-- Form đăng xuất với bảo mật CSRF --%>
                <li>
                    <form method="post" action="/logout">
                        <%-- Token CSRF để bảo vệ chống tấn công Cross-Site Request Forgery --%>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<%--                            <input type="hidden" name="${_csrf.parameterName}"  />--%>
                        <%-- Nút đăng xuất --%>
                        <button class="dropdown-item">Logout</button>
                    </form>
                </li>
            </ul>
        </li>
    </ul>
</nav>