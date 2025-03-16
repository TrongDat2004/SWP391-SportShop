<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <title>Add New Voucher || Clothing</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Add New Voucher</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Add Voucher</li>
                    </ul>
                </div>

                <!-- Add Voucher Form -->
                <div class="card">
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger">${param.error}</div>
                </c:if>

                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-voucher" method="POST">
                        <div class="row g-3">
                            <!-- Voucher Information -->
                            <input type="hidden" class="form-control" name="action" value="add" required>

                            <!-- Voucher Code -->
                            <div class="col-md-6">
                                <label class="form-label">Voucher Code</label>
                                <input type="text" class="form-control" name="code" required>
                            </div>

                            <!-- Discount Amount -->
                            <div class="col-md-6">
                                <label class="form-label">Discount Amount</label>
                                <input type="number" class="form-control" name="discountAmount" required min="1" step="0.01">
                            </div>

                            <!-- Start Date -->
                            <div class="col-md-6">
                                <label class="form-label">Start Date</label>
                                <input type="date" class="form-control" name="startDate" required>
                            </div>

                            <!-- Expiry Date -->
                            <div class="col-md-6">
                                <label class="form-label">Expiry Date</label>
                                <input type="date" class="form-control" name="expiryDate" required>
                            </div>

                            <!-- Max Usage -->
                            <div class="col-md-6">
                                <label class="form-label">Max Usage</label>
                                <input type="number" class="form-control" name="maxUsage" required min="1">
                            </div>

                            <!-- Status -->
                            <div class="col-md-6">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status" required>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>

                            <!-- Submit Button -->
                            <div class="col-md-12 mt-4">
                                <button type="submit" class="btn btn-primary">Add Voucher</button>
                                <a href="${pageContext.request.contextPath}/admin/manage-voucher" class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
            <script>
                // Toast message logic (if any)
                var toastMessage = "${sessionScope.toastMessage}";
                var toastType = "${sessionScope.toastType}";
                if (toastMessage) {
                    iziToast.show({
                        title: toastType === 'success' ? 'Success' : 'Error',
                        message: toastMessage,
                        position: 'topRight',
                        color: toastType === 'success' ? 'green' : 'red',
                        timeout: 5000,
                        onClosing: function () {
                            fetch('${pageContext.request.contextPath}/remove-toast', {
                                method: 'POST'
                            });
                        }
                    });
                }
        </script>
    </body>
</html>
