<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favi.jpg" sizes="16x16">
        <title>Manage Sizes - ${product.name} || Admin</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
         <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            .size-row { border-bottom: 1px solid #eee; padding: 10px 0; }
            .size-row:last-child { border-bottom: none; }
            .form-control-sm { height: calc(1.5em + 0.5rem + 2px); padding: 0.25rem 0.5rem; font-size: .875rem; }
            .btn-sm { padding: 0.25rem 0.5rem; font-size: .875rem; }
            .delete-icon { cursor: pointer; color: #dc3545; }
             .delete-icon:hover { color: #a71d2a; }
        </style>
    </head>
    <body>
        <!-- Sidebar & Header -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h4 class="fw-semibold mb-0">Manage Sizes & Stock</h4>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium"><a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary"><i class="fas fa-tachometer-alt text-primary"></i> Dashboard</a></li>
                    <li><i class="fas fa-chevron-right text-muted"></i></li>
                    <li class="fw-medium"><a href="${pageContext.request.contextPath}/admin/manage-product" class="hover-text-primary">Product List</a></li>
                     <li><i class="fas fa-chevron-right text-muted"></i></li>
                     <li class="fw-medium text-dark">Manage Sizes (${product.name})</li>
                </ul>
            </div>

            <!-- Display Error/Success Messages -->
             <c:if test="${not empty sessionScope.toastMessage}">
                 <div class="alert alert-${sessionScope.toastType == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                      ${sessionScope.toastMessage}
                     <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                 </div>
                  <% session.removeAttribute("toastMessage"); session.removeAttribute("toastType"); %>
             </c:if>


            <div class="card">
                 <div class="card-header d-flex justify-content-between align-items-center">
                     <h5 class="card-title mb-0">Product: ${product.name} (ID: ${product.productId})</h5>
                     <a href="${pageContext.request.contextPath}/admin/manage-product" class="btn btn-sm btn-outline-secondary"> <i class="fas fa-arrow-left me-1"></i> Back to List</a>
                 </div>
                <div class="card-body p-24">
                    <form action="${pageContext.request.contextPath}/admin/manage-product" method="POST" id="manageSizesForm">
                        <input type="hidden" name="action" value="saveSizes">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <div id="sizeList">
                            <div class="row fw-bold border-bottom pb-2 mb-2 d-none d-md-flex"> <%-- Header Row (ẩn trên mobile) --%>
                                <div class="col-md-5">Size Name</div>
                                <div class="col-md-5">Stock Quantity</div>
                                <div class="col-md-2 text-center">Delete</div>
                            </div>
                            <c:forEach var="size" items="${sizes}" varStatus="loop">
                                <div class="row g-2 align-items-center size-row" id="size-row-${size.productSizeId}">
                                     <input type="hidden" name="sizeId" value="${size.productSizeId}">
                                     <div class="col-12 col-md-5 mb-2 mb-md-0">
                                         <label class="form-label d-md-none">Size Name:</label> <%-- Label cho mobile --%>
                                         <input type="text" class="form-control form-control-sm" name="size" value="${size.size}" required>
                                     </div>
                                     <div class="col-10 col-md-5 mb-2 mb-md-0">
                                         <label class="form-label d-md-none">Stock:</label> <%-- Label cho mobile --%>
                                         <input type="number" class="form-control form-control-sm" name="stock" value="${size.stock}" required min="0">
                                     </div>
                                     <div class="col-2 col-md-2 text-center">
                                         <label class="form-label d-md-none">Delete:</label> <%-- Label cho mobile --%>
                                         <input type="checkbox" class="form-check-input delete-checkbox" name="deleteSize" value="${size.productSizeId}" title="Mark to delete this size">
                                         <%-- Hoặc dùng icon để xóa ngay lập tức với JS
                                          <i class="fas fa-trash-alt delete-icon" onclick="removeSizeRow(${size.productSizeId})"></i>
                                          --%>
                                     </div>
                                </div>
                            </c:forEach>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between align-items-center mt-3">
                             <button type="button" class="btn btn-sm btn-success" id="addSizeBtn">
                                 <i class="fas fa-plus me-1"></i> Add New Size
                             </button>
                             <button type="submit" class="btn btn-primary">
                                 <i class="fas fa-save me-1"></i> Save Changes
                             </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS -->
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
         <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
             document.getElementById('addSizeBtn').addEventListener('click', function() {
                 const sizeList = document.getElementById('sizeList');
                 const newRow = document.createElement('div');
                 newRow.className = 'row g-2 align-items-center size-row dynamic-size-row'; // Thêm class để dễ quản lý
                 newRow.innerHTML = `
                     <input type="hidden" name="sizeId" value=""> <%-- ID trống cho size mới --%>
                     <div class="col-12 col-md-5 mb-2 mb-md-0">
                         <label class="form-label d-md-none">Size Name:</label>
                         <input type="text" class="form-control form-control-sm" name="size" placeholder="Enter size name (e.g., M, L, 42)" required>
                     </div>
                     <div class="col-10 col-md-5 mb-2 mb-md-0">
                         <label class="form-label d-md-none">Stock:</label>
                         <input type="number" class="form-control form-control-sm" name="stock" value="0" required min="0">
                     </div>
                     <div class="col-2 col-md-2 text-center">
                         <label class="form-label d-md-none">Remove:</label>
                         <button type="button" class="btn btn-sm btn-outline-danger p-1" onclick="removeDynamicRow(this)" title="Remove this new size">
                              <i class="fas fa-times"></i>
                         </button>
                         <%-- Không có checkbox xóa cho hàng mới --%>
                     </div>
                 `;
                 sizeList.appendChild(newRow);
             });

              // Hàm xóa hàng size mới được thêm (chưa lưu vào DB)
              function removeDynamicRow(button) {
                   const row = button.closest('.dynamic-size-row');
                   if(row) {
                       row.remove();
                   }
              }

              // Xác nhận trước khi submit
             document.getElementById('manageSizesForm').addEventListener('submit', function(event){
                  const deleteCheckboxes = document.querySelectorAll('.delete-checkbox:checked');
                  let message = "Are you sure you want to save these changes?";
                  if (deleteCheckboxes.length > 0) {
                      message += `<br><br><strong class='text-danger'>Warning:</strong> ${deleteCheckboxes.length} size(s) marked for deletion will be permanently removed!`;
                  }

                 event.preventDefault(); // Ngăn submit mặc định

                 Swal.fire({
                     title: 'Confirm Save',
                     html: message,
                     icon: 'question',
                     showCancelButton: true,
                     confirmButtonColor: '#3085d6',
                     cancelButtonColor: '#6c757d',
                     confirmButtonText: 'Yes, save changes!',
                     cancelButtonText: 'Cancel'
                 }).then((result) => {
                     if (result.isConfirmed) {
                         this.submit(); // Submit form nếu xác nhận
                     }
                 });
             });

               // Toast message logic
              document.addEventListener('DOMContentLoaded', function () {
                 var toastMessage = "${sessionScope.toastMessage}";
                 var toastType = "${sessionScope.toastType}";
                 if (toastMessage) {
                      Swal.fire({
                         icon: toastType, title: toastMessage, toast: true, position: 'top-end',
                         showConfirmButton: false, timer: 3000, timerProgressBar: true
                     });
                      <% session.removeAttribute("toastMessage"); session.removeAttribute("toastType"); %>
                 }
             });

        </script>
    </body>
</html>