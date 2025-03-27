<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <title>Edit Product || Clothing</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    </head>

    <body>
        <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

        <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Edit Product</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Edit Product</li>
                </ul>
            </div>
            <!-- Edit Product Form -->
            <div class="card">
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data">
                        <div class="row g-3">
                            <!-- Product Information -->
                            <input type="hidden" class="form-control" name="action" value="edit" required>
                            <input type="hidden" class="form-control" name="productId" value="${product.productId}" required>

                            <div class="col-md-6">
                                <label class="form-label">Product Name</label>
                                <input type="text" class="form-control" name="name" value="${product.name}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="4" required>${product.description}</textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category</label>
                                <select class="form-select" name="categoryId" required>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" ${category.categoryId == product.categoryId ? 'selected' : ''}>${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Price</label>
                                <input type="number" step="0.01" class="form-control" name="price" value="${product.price}" required min="1000">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Stock</label>
                                <input type="number" class="form-control" name="stock" value="${product.stock}" required min="1">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Product Image</label>
                                <input type="file" class="form-control" name="image" accept="image/*" id="imageInput">
                                 <input type="hidden" class="form-control" name="oldImage" accept="image/*" id="imageInput" value="${product.image}">
                                <small class="form-text text-muted">Leave blank if you don't want to change the image</small>

                                <!-- Current Image Preview -->
                                <div class="mt-2">
                                    <label class="form-label">Current Image</label><br>
                                    <img src="${pageContext.request.contextPath}/${product.image}" id="currentImage" alt="Current Image" width="100" height="100">
                                </div>

                                <!-- New Image Preview -->
                                <div class="mt-2">
                                    <label class="form-label">New Image Preview</label><br>
                                    <img id="newImagePreview" src="#" alt="New Image Preview" width="100" height="100" style="display:none;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status" required>
                                    <option value="true" ${product.status ? 'selected' : ''}>Active</option>
                                    <option value="false" ${!product.status ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>

                            <!-- Submit Button -->
                            <div class="col-md-12 mt-4">
                                <button type="submit" class="btn btn-primary">Update Product</button>
                                <a href="${pageContext.request.contextPath}/admin/manage-product" 
                                   class="btn btn-secondary">Cancel</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
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

                // Image preview functionality
                document.getElementById('imageInput').addEventListener('change', function (e) {
                    var file = e.target.files[0];
                    var reader = new FileReader();

                    reader.onload = function (e) {
                        var newImage = document.getElementById('newImagePreview');
                        newImage.src = e.target.result;
                        newImage.style.display = 'block';
                    };

                    if (file) {
                        reader.readAsDataURL(file);
                    }
                });
            });
        </script>
    </body>
</html>
