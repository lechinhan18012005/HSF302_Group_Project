<%-- Định nghĩa content type và encoding cho trang JSP --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%-- Import thư viện JSTL core để sử dụng các thẻ điều kiện và vòng lặp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Import thư viện Spring Form để binding dữ liệu và validation --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%-- Thiết lập encoding và responsive meta tags --%>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <%-- viewport: Để trang responsive trên mobile, shrink-to-fit=no: Ngăn iOS Safari thu nhỏ trang --%>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>Create Product</title>
    <%-- Link đến file CSS chính của ứng dụng --%>
    <link href="/css/styles.css" rel="stylesheet"/>
    <%-- Import jQuery từ CDN để xử lý DOM và events --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        // JavaScript để xử lý preview ảnh khi upload file
        $(document).ready(() => {
            // Lấy element input file để upload avatar
            const avatarFile = $("#avatarFile");
            // Lắng nghe sự kiện thay đổi file
            avatarFile.change(function (e) {
                // Tạo URL tạm thời cho file được chọn để preview
                const imgURL = URL.createObjectURL(e.target.files[0]);
                // Set src cho thẻ img preview
                $("#avatarPreview").attr("src", imgURL);
                // Hiển thị ảnh preview (mặc định là ẩn)
                $("#avatarPreview").css({"display": "block"});
            });
        });
    </script>
    <%-- Import Font Awesome icons từ CDN --%>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<%-- sb-nav-fixed: Class để cố định navigation bar khi scroll --%>
<body class="sb-nav-fixed">
<%-- Include header navigation từ file riêng --%>
<jsp:include page="../layout/header.jsp"/>
<%-- layoutSidenav: Container chính cho layout có sidebar --%>
<div id="layoutSidenav">
    <%-- Include sidebar navigation từ file riêng --%>
    <jsp:include page="../layout/sidebar.jsp"/>
    <%-- layoutSidenav_content: Container cho nội dung chính bên phải sidebar --%>
    <div id="layoutSidenav_content">
        <main>
            <%-- container-fluid: Bootstrap container full width, px-4: padding horizontal 1.5rem --%>
            <div class="container-fluid px-4">
                <%-- mt-4: margin-top 1.5rem --%>
                <h1 class="mt-4">Products</h1>
                <%-- Breadcrumb navigation để hiển thị đường dẫn trang --%>
                <%-- breadcrumb: Bootstrap class cho navigation breadcrumb --%>
                <%-- mb-4: margin-bottom 1.5rem --%>
                <ol class="breadcrumb mb-4">
                    <%-- breadcrumb-item: Class cho từng item trong breadcrumb --%>
                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="/admin/product">Product</a></li>
                    <%-- active: Đánh dấu item hiện tại --%>
                    <li class="breadcrumb-item active">Create</li>
                </ol>
                <%-- mt-5: margin-top 3rem --%>
                <div class="mt-5">
                    <%-- Bootstrap grid system --%>
                    <div class="row">
                        <%-- col-md-6: 6/12 columns trên màn hình medium trở lên --%>
                        <%-- col-12: 12/12 columns (full width) trên màn hình nhỏ --%>
                        <%-- mx-auto: margin horizontal auto để center content --%>
                        <div class="col-md-6 col-12 mx-auto">
                            <h3>Create a product</h3>
                            <%-- hr: Horizontal rule để tạo đường kẻ ngang --%>
                            <hr/>
                            <%-- Spring Form với binding object và cấu hình upload file --%>
                            <%-- enctype="multipart/form-data": Cho phép upload file --%>
                            <%-- modelAttribute: Binding với object newProduct từ controller --%>
                            <%-- row: Bootstrap class để tạo grid row --%>
                            <form:form method="post" action="/admin/product/create" class="row"
                                       enctype="multipart/form-data" modelAttribute="newProduct">
                                <%-- Tạo các biến để lưu error messages cho validation --%>
                                <%-- cssClass="invalid-feedback": Bootstrap class để styling error messages --%>
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

                                <%-- Form group cho tên sản phẩm --%>
                                <%-- mb-3: margin-bottom 1rem --%>
                                <%-- col-12 col-md-6: Full width trên mobile, 6/12 columns trên medium+ --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <%-- form-label: Bootstrap class cho label --%>
                                    <label class="form-label">Name:</label>
                                    <%-- Spring form input với conditional CSS class --%>
                                    <%-- form-control: Bootstrap class cho input styling --%>
                                    <%-- is-invalid: Bootstrap class để hiển thị trạng thái lỗi --%>
                                    <form:input type="text"
                                                class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                                                path="name"/>
                                        ${errorName}
                                </div>
                                <%-- Form group cho giá sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Price:</label>
                                    <%-- type="number": Input chỉ chấp nhận số --%>
                                    <form:input type="number"
                                                class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                                                path="price"/>
                                        ${errorPrice}
                                </div>
                                <%-- Form group cho mô tả chi tiết --%>
                                <%-- col-12: Full width trên tất cả screen sizes --%>
                                <div class="mb-3 col-12">
                                    <label class="form-label">Detail description:</label>
                                    <%-- textarea: Multi-line text input --%>
                                    <form:textarea type="text"
                                                   class="form-control ${not empty errorDetailDesc ? 'is-invalid' : ''}"
                                                   path="detailDesc"/>
                                        ${errorDetailDesc}
                                </div>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Short description:</label>
                                    <form:input type="text"
                                                class="form-control ${not empty errorShortDesc ? 'is-invalid' : ''}"
                                                path="shortDesc"/>
                                        ${errorShortDesc}
                                </div>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Quantity:</label>
                                    <form:input type="number"
                                                class="form-control ${not empty errorQuantity ? 'is-invalid' : ''}"
                                                path="quantity"/>
                                        ${errorQuantity}
                                </div>

                                <%-- Form group cho dropdown hãng sản xuất --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Factory:</label>
                                    <%-- form-select: Bootstrap class cho select dropdown --%>
                                    <form:select class="form-select" path="factory">
                                        <%-- Các option cho hãng sản xuất laptop --%>
                                        <form:option value="APPLE">Apple (MacBook)</form:option>
                                        <form:option value="ASUS">Asus</form:option>
                                        <form:option value="LENOVO">Lenovo</form:option>
                                        <form:option value="DELL">Dell</form:option>
                                        <form:option value="LG">LG</form:option>
                                        <form:option value="ACER">Acer</form:option>
                                    </form:select>
                                </div>
                                <%-- Form group cho dropdown đối tượng sử dụng --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label class="form-label">Target:</label>
                                    <form:select class="form-select" path="target">
                                        <%-- Các option cho đối tượng sử dụng laptop --%>
                                        <form:option value="GAMING">Gaming</form:option>
                                        <form:option value="SINHVIEN-VANPHONG">Sinh viên - Văn phòng
                                        </form:option>
                                        <form:option value="THIET-KE-DO-HOA">Thiết kế đồ họa
                                        </form:option>
                                        <form:option value="MONG-NHE">Mỏng nhẹ</form:option>
                                        <form:option value="DOANH-NHAN">Doanh nhân</form:option>
                                    </form:select>
                                </div>
                                <%-- Form group cho upload ảnh sản phẩm --%>
                                <div class="mb-3 col-12 col-md-6">
                                    <label for="avatarFile" class="form-label">Image:</label>
                                    <%-- Input file với giới hạn định dạng ảnh --%>
                                    <%-- accept: Chỉ cho phép file ảnh png, jpg, jpeg --%>
                                    <%-- name="hoidanitFile": Tên parameter để controller nhận file --%>
                                    <input class="form-control" type="file" id="avatarFile"
                                           accept=".png, .jpg, .jpeg" name="hoidanitFile"/>
                                </div>
                                <%-- Container cho ảnh preview --%>
                                <div class="col-12 mb-3">
                                    <%-- Ảnh preview với max-height và ẩn mặc định --%>
                                    <%-- display: none: Ẩn ảnh cho đến khi có file được chọn --%>
                                    <img style="max-height: 250px; display: none;" alt="avatar preview"
                                         id="avatarPreview"/>
                                </div>
                                <%-- Container cho nút submit --%>
                                <%-- mb-5: margin-bottom 3rem để tạo space với footer --%>
                                <div class="col-12 mb-5">
                                    <%-- btn btn-primary: Bootstrap classes cho nút chính --%>
                                    <button type="submit" class="btn btn-primary">Create</button>
                                </div>
                            </form:form>

                        </div>

                    </div>
                </div>
            </div>
        </main>
        <%-- Include footer từ file riêng --%>
        <jsp:include page="../layout/footer.jsp"/>
    </div>
</div>
<%-- Bootstrap JavaScript bundle cho các components interactive --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
<%-- Custom JavaScript cho ứng dụng --%>
<script src="/js/scripts.js"></script>

</body>

</html>