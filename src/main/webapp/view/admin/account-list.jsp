<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">

    <title>Account Management || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Account Management</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Account List</li>
            </ul>
        </div>

        <!-- Filter Section -->
        <div class="card mb-24">
            <div class="card-body p-24">
                <form action="${pageContext.request.contextPath}/admin/manage-account" method="GET">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <input type="text" class="form-control" name="search" placeholder="Search by name or email" 
                                   value="${param.search}">
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" name="role">
                                <option value="">All Roles</option>
                                <option value="staff" ${param.role == 'staff' ? 'selected' : ''}>Staff</option>
                                <option value="user" ${param.role == 'user' ? 'selected' : ''}>User</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                                <option value="false" ${param.status == 'false' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Filter</button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/manage-account?action=add" class="btn btn-success w-100">
                                Add New Account
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Account Table -->
        <div class="card">
            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="account" items="${accounts}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${account.firstName} ${account.lastName}</td>
                                    <td>${account.email}</td>
                                    <td>${account.phone}</td>
                                    <td>${account.role}</td>
                                    <td>
                                        <span class="badge ${account.status ? 'bg-success' : 'bg-danger'}">
                                            ${account.status ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/accounts/edit?id=${account.userId}" 
                                               class="btn btn-sm btn-primary">
                                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                            </a>
                                            <button class="btn btn-sm btn-danger" 
                                                    onclick="confirmDelete(${account.userId})">
                                                <iconify-icon icon="material-symbols:delete"></iconify-icon>
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
                                <a class="page-link" href="?page=${currentPage - 1}">Previous</a>
                            </li>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <main>

    </main>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST'
                        });
                    }
                });
            }
        });
    </script>

</body>
</html>

<script>
function confirmDelete(userId) {
    if (confirm('Are you sure you want to delete this account?')) {
        window.location.href = '${pageContext.request.contextPath}/accounts/delete?id=' + userId;
    }
}
</script>
