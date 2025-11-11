<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Container chính cho sidebar navigation --%>
<%-- layoutSidenav_nav: ID để định vị sidebar trong layout tổng thể --%>
<div id="layoutSidenav_nav">
    <%-- Navigation sidebar với accordion effect và theme tối --%>
    <%-- sb-sidenav: Class chính cho sidebar navigation --%>
    <%-- accordion: Cho phép các menu item có thể mở rộng/thu gọn --%>
    <%-- sb-sidenav-dark: Theme tối cho sidebar --%>
    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">

        <%-- Container chứa các menu item --%>
        <%-- sb-sidenav-menu: Class để styling cho phần menu chính --%>
        <div class="sb-sidenav-menu">
            <%-- Container navigation cho các link --%>
            <%-- nav: Bootstrap class cho navigation component --%>
            <div class="nav">

                <%-- Tiêu đề phân nhóm cho các menu item --%>
                <%-- sb-sidenav-menu-heading: Class để styling cho tiêu đề menu --%>
                <div class="sb-sidenav-menu-heading">Features</div>

                <%-- Link đến trang Dashboard chính --%>
                <%-- nav-link: Bootstrap class cho navigation link --%>
                <a class="nav-link" href="/admin">
                    <%-- Icon dashboard với Font Awesome --%>
                    <%-- sb-nav-link-icon: Class để spacing và alignment cho icon --%>
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    Dashboard
                </a>

                <%-- Link đến trang quản lý người dùng --%>
                <a class="nav-link" href="/admin/user">
                    <%-- Icon cho quản lý user --%>
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    User
                </a>

                <%-- Link đến trang quản lý sản phẩm --%>
                <a class="nav-link" href="/admin/product">
                    <%-- Icon cho quản lý product --%>
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    Product
                </a>

                <%-- Link đến trang quản lý đơn hàng --%>
                <a class="nav-link" href="/admin/order">
                    <%-- Icon cho quản lý order --%>
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    Order
                </a>
            </div>
        </div>

        <%-- Footer sidebar hiển thị thông tin user đã đăng nhập --%>
        <%-- sb-sidenav-footer: Class để styling footer của sidebar --%>
        <div class="sb-sidenav-footer">
            <%-- Text nhỏ mô tả trạng thái đăng nhập --%>
            <%-- small: Bootstrap class để text có kích thước nhỏ hơn --%>
            <div class="small">Logged in as:</div>
            <%-- Hiển thị role/tên của user hiện tại --%>
            Admin
        </div>
    </nav>
</div>