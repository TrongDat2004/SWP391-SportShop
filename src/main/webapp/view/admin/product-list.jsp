<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> <%-- Thêm fmt nếu cần format giá --%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management || Admin</title> <%-- Sửa title --%>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                .fixed-width-btn {
                    min-width: 100px;
                    text-align: center;
                    margin-bottom: 5px; /* Thêm margin bottom */
                }
                .action-buttons .btn {
                    margin-right: 5px;
                } /* Khoảng cách giữa các nút action */
                .product-img-thumb {
                    width: 50px;
                    height: 50px;
                    object-fit: cover;
                    border-radius: 5px;
                    border: 1px solid #eee;
                } /* Style ảnh thumbnail */
            </style>
        </head>
        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>
            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <%-- Pagination URL Builder --%>
        <c:url value="/admin/manage-product" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty categoryFilter}"><c:param name="category" value="${categoryFilter}" /></c:if>
            <c:if test="${not empty statusFilter}"><c:param name="status" value="${statusFilter}" /></c:if>
            <c:if test="${not empty searchFilter}"><c:param name="search" value="${searchFilter}" /></c:if>
        </c:url>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Product Management</h6> <%-- Tăng size chữ --%>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" ></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li><i class="fas fa-chevron-right text-muted"></i>-</li>
                    <li class="fw-medium text-dark">Product List</li> <%-- Đổi màu chữ --%>
                </ul>
            </div>

            <!-- Filter Section -->
            <div class="card mb-24 shadow-sm"> <%-- Thêm shadow --%>
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="GET">
                        <input type="hidden" name="action" value="list"/> <%-- Luôn gửi action list khi filter --%>
                        <div class="row g-3 align-items-end"> <%-- align-items-end để nút thẳng hàng --%>
                            <div class="col-lg-3 col-md-6">
                                <input type="text" id="searchFilter" class="form-control form-control-sm" name="search" placeholder="Search by product name" value="${searchFilter}">
                            </div>
                            <div class="col-lg-3 col-md-6">
                                <select class="form-select form-select-sm" id="categoryFilter" name="category">
                                    <option value="">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}" ${categoryFilter == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-lg-2 col-md-4">
                                <select class="form-select form-select-sm" id="statusFilter" name="status">
                                    <option value="">All Status</option>
                                    <option value="true" ${statusFilter == 'true' ? 'selected' : ''}>Active</option>
                                    <option value="false" ${statusFilter == 'false' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-lg-2 col-md-4">
                                <button type="submit" class="btn btn-primary btn-sm w-100"><i class="fas fa-filter me-1"></i> Filter</button>
                            </div>
                            <div class="col-lg-2 col-md-4">
                                <a href="${pageContext.request.contextPath}/admin/manage-product?action=add" class="btn btn-success btn-sm w-100"> <i class="fas fa-plus me-1"></i> Add New Product </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Error/Success Messages -->
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.toastMessage}">
                <div class="alert alert-${sessionScope.toastType == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                    ${sessionScope.toastMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("toastMessage"); session.removeAttribute("toastType"); %>
            </c:if>


            <!-- Product Table -->
            <div class="card shadow-sm"> <%-- Thêm shadow --%>
                <div class="card-header bg-light d-flex justify-content-between align-items-center"> <%-- Header cho table --%>
                    <h5 class="card-title mb-0">Product List (${totalCount} products)</h5>
                    <%-- Có thể thêm nút export ở đây --%>
                </div>
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered table-sm"> <%-- Thêm bordered và sm --%>
                            <thead class="table-light"> <%-- Đổi màu a bit --%>
                                <tr class="text-center"> <%-- Căn giữa header --%>
                                    <th scope="col">#</th>
                                    <th scope="col">Image</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Category</th>
                                    <th scope="col">Price</th>
                                    <th scope="col">Status</th>
                                    <th scope="col" style="width: 15%;">Actions</th> <%-- Tăng width actions --%>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty productList}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-4">No products found matching your criteria.</td>
                                    </tr>
                                </c:if>
                                <c:forEach var="product" items="${productList}" varStatus="loop">
                                    <tr>
                                        <td class="text-center">${(currentPage - 1) * pageSize + loop.index + 1}</td> <%-- Số thứ tự đúng theo trang --%>
                                        <td class="text-center">
                                            <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.name}" class="product-img-thumb" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                        </td>
                                        <td>${product.name}</td>
                                        <td>${product.category.name}</td> <%-- Giả sử product đã có category object --%>
                                        <td class="text-end"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> VND</td> <%-- Format giá và căn phải --%>
                                        <td>
                                            <span class="badge ${product.status ? 'bg-success' : 'bg-danger'}">
                                                ${product.status ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td class="text-center action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/manage-product?action=manageSizes&id=${product.productId}"
                                               class="btn btn-sm btn-info fixed-width-btn" title="Manage Sizes & Stock">
                                                <i class="fas fa-boxes"></i> Sizes
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/manage-product?action=edit&id=${product.productId}"
                                               class="btn btn-sm btn-primary fixed-width-btn" title="Edit Product">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger fixed-width-btn" title="Delete Product"
                                                    onclick="confirmDelete('${product.productId}', '${product.name}')"> <%-- Thêm tên sp vào confirm --%>
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Product pagination" class="mt-24">
                            <ul class="pagination justify-content-center flex-wrap"> <%-- Thêm flex-wrap --%>

                                <%-- Previous Link --%>
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <%-- Chỉ tạo link hợp lệ khi currentPage > 1 --%>
                                            <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true">«</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Hiển thị span không click được khi ở trang đầu --%>
                                            <span class="page-link" aria-hidden="true">«</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>

                                <%-- Page Number Links --%>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <%-- Link cho từng số trang --%>
                                        <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>

                                <%-- Next Link --%>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <%-- Chỉ tạo link hợp lệ khi chưa phải trang cuối --%>
                                            <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                                <span aria-hidden="true">»</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Hiển thị span không click được khi ở trang cuối --%>
                                            <span class="page-link" aria-hidden="true">»</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>

                            </ul>
                        </nav>
                    </c:if> <%-- End check totalPages > 1 --%>
                </div>
            </div>
        </div>

        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <%-- Thêm SweetAlert nếu chưa có --%>
        <script>
                                                        // Toast message logic (giữ nguyên hoặc dùng của dashboard template nếu có sẵn)
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            // Xử lý toast nếu có (có thể dùng iziToast hoặc của template)
                                                            const toastMessage = "${sessionScope.toastMessage}";
                                                            const toastType = "${sessionScope.toastType}";
                                                            if (toastMessage) {
                                                                Swal.fire({
                                                                    icon: toastType,
                                                                    title: toastMessage,
                                                                    toast: true,
                                                                    position: 'top-end',
                                                                    showConfirmButton: false,
                                                                    timer: 3000,
                                                                    timerProgressBar: true
                                                                });
            <% session.removeAttribute("toastMessage"); session.removeAttribute("toastType"); %>
                                                            }
                                                        });

                                                        // Hàm confirm delete với tên sản phẩm
                                                        function confirmDelete(productId, productName) {
                                                            Swal.fire({
                                                                title: 'Are you sure?',
                                                                html: `Do you want to delete product: <br><small>This will also delete associated sizes and stock information.</small>`, // Hiển thị tên SP
                                                                icon: 'warning',
                                                                showCancelButton: true,
                                                                confirmButtonColor: '#d33',
                                                                cancelButtonColor: '#3085d6',
                                                                confirmButtonText: 'Yes, delete it!',
                                                                cancelButtonText: 'Cancel'
                                                            }).then((result) => {
                                                                if (result.isConfirmed) {
                                                                    // Chuyển hướng đến action delete
                                                                    window.location.href = '${pageContext.request.contextPath}/admin/manage-product?action=delete&id=' + productId;
                                                                }
                                                            });
                                                        }
        </script>
    </body>
</html>