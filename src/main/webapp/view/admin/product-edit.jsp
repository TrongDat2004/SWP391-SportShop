<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%> <%-- Thêm fmt nếu cần --%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favi.jpg" sizes="16x16"> <%-- Sửa path --%>
        <title>Edit Product - ${product.name} || Admin</title> <%-- Sửa title --%>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                .form-label {
                    font-weight: 500;
                    margin-bottom: 0.5rem;
                }
                .card {
                    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
                }
                #currentImage, #newImagePreview {
                    border: 1px solid #ddd;
                    padding: 5px;
                    border-radius: 5px;
                    object-fit: cover;
                }
                .image-preview-container {
                    display: flex;
                    gap: 20px;
                    align-items: flex-start;
                } /* Flex container for previews */
                .image-preview-container div {
                    text-align: center;
                }
            </style>
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
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" ></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li><i class="fas fa-chevron-right text-muted"></i>-</li>
                    <li class="fw-medium"> <a href="${pageContext.request.contextPath}/admin/manage-product" class="hover-text-primary"> Product List </a> </li>
                    <li><i class="fas fa-chevron-right text-muted"></i>-</li>
                    <li class="fw-medium text-dark">Edit Product</li>
                </ul>
            </div>

            <!-- Display Error Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Error!</strong> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Edit Product Form -->
            <c:if test="${product != null}">
                <div class="card">
                    <div class="card-body p-24">
                        <form action="${pageContext.request.contextPath}/admin/manage-product" method="POST" enctype="multipart/form-data" id="editProductForm">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="oldImage" value="${product.image}"> <%-- Gửi ảnh cũ để server biết --%>

                            <div class="row g-3">
                                <div class="col-md-6 mb-3">
                                    <label for="productName" class="form-label">Product Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="productName" name="name" value="${product.name}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="categoryId" class="form-label">Category <span class="text-danger">*</span></label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">-- Select Category --</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}" ${category.categoryId == product.categoryId ? 'selected' : ''}>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12 mb-3">
                                    <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="description" name="description" rows="4" required>${product.description}</textarea>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">Price (VND) <span class="text-danger">*</span></label>

                                    <c:set var="formattedPrice" value="0" /> 
                                    <c:if test="${product.price != null}">
                                        <fmt:formatNumber value="${product.price}"
                                                          maxFractionDigits="0"
                                                          groupingUsed="false"
                                                          var="formattedPrice" />
                                    </c:if>

                                    <input type="number"
                                           step="1000"
                                           min="0"
                                           class="form-control"
                                           id="price"
                                           name="price"
                                           value="${formattedPrice}"
                                           required>
                                    <div class="invalid-feedback">Price must be a non-negative number.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                    <select class="form-select" id="status" name="status" required>
                                        <option value="true" ${product.status ? 'selected' : ''}>Active</option>
                                        <option value="false" ${!product.status ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-12 mb-3">
                                    <label for="productImage" class="form-label">Change Product Image</label>
                                    <input type="file" class="form-control" id="productImage" name="image" accept="image/*" onchange="previewNewImage(event)">

                                    <div class="image-preview-container mt-3">
                                        <!-- Current Image Preview -->
                                        <div>
                                            <label class="form-label d-block">Current Image</label>
                                            <img src="${pageContext.request.contextPath}/${product.image}" id="currentImage" alt="Current Image" width="150" height="150" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                        </div>
                                        <!-- New Image Preview -->
                                        <div>
                                            <label class="form-label d-block">New Image Preview</label>
                                            <img id="newImagePreview" src="#" alt="New Image Preview" width="150" height="150" style="display:none;">
                                        </div>
                                    </div>
                                </div>

                                <!-- Submit Button -->
                                <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/manage-product" class="btn btn-secondary"><i class="fas fa-times me-1"></i> Cancel</a>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i> Update Product</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>
            <c:if test="${product == null}">
                <div class="alert alert-danger">Product not found. <a href="${pageContext.request.contextPath}/admin/manage-product">Go back to list</a></div>
            </c:if>
        </div>

        <!-- JS here -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <%-- Thêm SweetAlert nếu chưa có --%>
        <script>
                                        // New Image Preview Function
                                        function previewNewImage(event) {
                                            const reader = new FileReader();
                                            const newImagePreview = document.getElementById('newImagePreview');
                                            reader.onload = function () {
                                                newImagePreview.src = reader.result;
                                                newImagePreview.style.display = 'block'; // Show preview
                                            }
                                            if (event.target.files[0]) {
                                                reader.readAsDataURL(event.target.files[0]);
                                            } else {
                                                newImagePreview.src = '#';
                                                newImagePreview.style.display = 'none'; // Hide if no file selected
                                            }
                                        }

                                        // Simple Client-side Validation
                                        document.getElementById('editProductForm').addEventListener('submit', function (event) {
                                            let isValid = true;
                                            const priceInput = document.getElementById('price');

                                            // Validate Price
                                            if (parseFloat(priceInput.value) < 0) {
                                                priceInput.classList.add('is-invalid');
                                                isValid = false;
                                            } else {
                                                priceInput.classList.remove('is-invalid');
                                            }

                                            // Optional: Validate new image file type/size if selected
                                            const imageInput = document.getElementById('productImage');
                                            if (imageInput.files.length > 0) {
                                                const file = imageInput.files[0];
                                                if (!file.type.startsWith('image/')) {
                                                    alert('Please select a valid image file.');
                                                    isValid = false;
                                                }
                                                // Add size validation if needed
                                                // if (file.size > MAX_SIZE_BYTES) { ... }
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