<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management || Clothing</title>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                .fixed-width-btn {
                    min-width: 120px;
                    text-align: center;
                }
            </style>
        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <c:url value="/admin/manage-product" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty param.category}">
                <c:param name="category" value="${param.category}" />
            </c:if>
            <c:if test="${not empty param.status}">
                <c:param name="status" value="${param.status}" />
            </c:if>
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}" />
            </c:if>
        </c:url>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Product Management</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Product List</li>
                </ul>
            </div>

            <!-- Filter Section -->
            <div class="card mb-24">
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="GET">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <input type="text" class="form-control" name="search" placeholder="Search by product name" value="${param.search}">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" name="category">
                                    <option value="">All Categories</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}" ${param.category == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="status">
                                    <option value="">All Status</option>
                                    <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                                    <option value="false" ${param.status == 'false' ? 'selected' : ''}>In actve</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Filter</button>
                            </div>
                            <div class="col-md-2">
                                <a href="${pageContext.request.contextPath}/admin/manage-product?action=add" class="btn btn-success w-100">
                                    Add New Product
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Product Table -->
            <div class="card">
                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${productList}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${product.name}</td>
                                        <td>${product.category.name}</td>
                                        <td>${product.price}₫</td>
                                        <td>${product.stock}</td>
                                        <td>
                                            <span class="badge ${product.status ? 'bg-success' : 'bg-danger'}">
                                                ${product.status ? 'Available' : 'In active'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/manage-product?action=edit&id=${product.productId}" 
                                                   class="btn btn-sm btn-primary">
                                                    <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-danger fixed-width-btn"
                                                        onclick="confirmDelete('${product.productId}')">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
            <script>
                                                            document.addEventListener('DOMContentLoaded', function () {
                                                                var toastStatus = "${param.statusM}";
                                                                var toastType = "${param.typeM}";
                                                                if (toastStatus) {
                                                                    iziToast.show({
                                                                        title: toastStatus === "1" ? 'Success' : 'Error',
                                                                        message: toastType === 'add' ? "Add successfully" : "Update successfully",
                                                                        position: 'topRight',
                                                                        color: toastStatus === '1' ? 'green' : 'red',
                                                                        timeout: 5000,
                                                                        onClosing: function () {
                                                                            fetch('${pageContext.request.contextPath}/remove-toast', {
                                                                                method: 'POST',
                                                                                headers: {
                                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                                },
                                                                            }).then(response => {
                                                                                if (!response.ok) {
                                                                                    console.error('Failed to remove toast attributes');
                                                                                }
                                                                            }).catch(error => {
                                                                                console.error('Error:', error);
                                                                            });
                                                                        }
                                                                    });
                                                                }
                                                            });
        </script>
        <script>
            function confirmDelete(productId) {
                if (confirm('Are you sure you want to delete this product?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/manage-product?action=delete&id=' + productId;
                }
            }
        </script>
    </body>
</html>
