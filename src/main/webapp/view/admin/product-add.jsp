<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favi.jpg" sizes="16x16"> <%-- Sửa path --%>
        <title>Add New Product || Admin</title> <%-- Sửa title --%>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
         <style>
             .form-label { font-weight: 500; margin-bottom: 0.5rem; }
             .card { box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
             #imagePreview { border: 1px solid #ddd; padding: 5px; border-radius: 5px; }
         </style>
    </head>
    <body>
        <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>
        <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Add New Product</h6> <%-- Tăng size --%>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" ></iconify-icon>
                            Dashboard
                        </a>
                    </li>                     
                    <li><i class="fas fa-chevron-right text-muted"></i>-</li>
                    <li class="fw-medium"> <a href="${pageContext.request.contextPath}/admin/manage-product" class="hover-text-primary"> Product List </a> </li>
                    <li><i class="fas fa-chevron-right text-muted"></i>-</li>
                    <li class="fw-medium text-dark">Add Product</li>
                </ul>
            </div>

            <!-- Display Error Messages -->
             <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error!</strong> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
             </c:if>

            <!-- Add Product Form -->
            <div class="card">
                <div class="card-body p-24">
                    <%-- Action trỏ đúng đến controller --%>
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data" id="addProductForm">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-3">
                            <div class="col-md-6 mb-3"> <%-- Thêm mb-3 --%>
                                <label for="productName" class="form-label">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="productName" name="name" value="${productName}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="categoryId" class="form-label">Category <span class="text-danger">*</span></label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}" ${selectedCategory == category.categoryId ? 'selected' : ''}>${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="4" required>${productDesc}</textarea>
                            </div>
                             <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Price (VND) <span class="text-danger">*</span></label>
                                <input type="number" step="1000" min="0" class="form-control" id="price" name="price" value="${productPrice}" required>
                                <div class="invalid-feedback">Price must be a non-negative number.</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="true" ${empty selectedStatus || selectedStatus == 'true' ? 'selected' : ''}>Active</option>
                                    <option value="false" ${selectedStatus == 'false' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-12 mb-3">
                                <label for="productImage" class="form-label">Product Image <span class="text-danger">*</span></label>
                                <input type="file" class="form-control" id="productImage" name="image" accept="image/*" required onchange="previewImage(event)">
                                <div class="invalid-feedback">Please select an image file.</div>
                                <!-- Image Preview -->
                                <img id="imagePreview" src="#" alt="Image Preview" class="mt-3 img-thumbnail" style="max-width: 200px; max-height: 200px; display: none;">
                            </div>
                            <!-- Submit Button -->
                            <div class="col-12 d-flex justify-content-end gap-2 mt-3"> <%-- Căn phải nút --%>
                                <a href="${pageContext.request.contextPath}/admin/manage-product" class="btn btn-secondary"><i class="fas fa-times me-1"></i> Cancel</a>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-plus me-1"></i> Add Product</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
         <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <%-- Thêm SweetAlert nếu chưa có --%>
        <script>
            // Image Preview Function
            function previewImage(event) {
                const reader = new FileReader();
                const imagePreview = document.getElementById('imagePreview');
                reader.onload = function(){
                    imagePreview.src = reader.result;
                    imagePreview.style.display = 'block'; // Show preview
                }
                if (event.target.files[0]) {
                    reader.readAsDataURL(event.target.files[0]);
                } else {
                     imagePreview.src = '#';
                     imagePreview.style.display = 'none'; // Hide if no file selected
                }
            }

            // Simple Client-side Validation (Optional but recommended)
            document.getElementById('addProductForm').addEventListener('submit', function(event) {
                 let isValid = true;
                 const priceInput = document.getElementById('price');
                 const imageInput = document.getElementById('productImage');

                 // Validate Price
                 if (parseFloat(priceInput.value) < 0) {
                     priceInput.classList.add('is-invalid');
                     isValid = false;
                 } else {
                      priceInput.classList.remove('is-invalid');
                 }

                 // Validate Image Selection
                 if (imageInput.files.length === 0) {
                     imageInput.classList.add('is-invalid');
                      // Find existing error message span or create one
                      let errorSpan = imageInput.nextElementSibling;
                      if (!errorSpan || !errorSpan.classList.contains('invalid-feedback')) {
                           errorSpan = document.createElement('div');
                           errorSpan.classList.add('invalid-feedback');
                           imageInput.parentNode.appendChild(errorSpan);
                      }
                      errorSpan.textContent = 'Please select an image file.';
                     isValid = false;
                 } else {
                      imageInput.classList.remove('is-invalid');
                      let errorSpan = imageInput.nextElementSibling;
                       if (errorSpan && errorSpan.classList.contains('invalid-feedback')) {
                            errorSpan.textContent = ''; // Clear error message
                       }
                 }


                 if (!isValid) {
                     event.preventDefault(); // Stop submission
                     Swal.fire({
                         icon: 'error',
                         title: 'Validation Error',
                         text: 'Please correct the errors in the form.',
                     });
                 }
            });

             // Toast message logic (giữ nguyên hoặc dùng của template)
             document.addEventListener('DOMContentLoaded', function () {
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
        </script>
    </body>
</html>