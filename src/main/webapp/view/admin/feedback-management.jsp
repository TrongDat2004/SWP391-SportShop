<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Feedback Management</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>

            <style>
                .star-rating {
                    color: #ffc107;
                }
                .feedback-card {
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,.1);
                    margin-bottom: 20px;
                    transition: all 0.3s ease;
                }
                .inactive-feedback {
                    opacity: 0.6;
                    background-color: #f8f9fa;
                }
                .feedback-content {
                    white-space: pre-line;
                }
                .toggle-visibility {
                    cursor: pointer;
                }
            </style>
        </head>
        <body>
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>
            <div class="container py-4">
                <div class="row mb-4">
                    <div class="col">
                        <h2><i class="fas fa-comments me-2"></i>Feedback Management</h2>
                        <p class="text-muted">Manage customer feedback and reviews</p>
                    </div>
                </div>

                <!-- Notification messages -->
            <c:if test="${param.message != null}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${param.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="card mb-4">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/feedback" method="get" id="filterForm">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Product</label>
                                <select class="form-select" name="productId" onchange="this.form.submit()">
                                    <option value="">All Products</option>
                                    <c:forEach items="${products}" var="product">
                                        <option value="${product.productId}" ${selectedProductId == product.productId ? 'selected' : ''}>
                                            ${product.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Rating</label>
                                <select class="form-select" name="rating" onchange="this.form.submit()">
                                    <option value="">All Ratings</option>
                                    <option value="5" ${selectedRating == 5 ? 'selected' : ''}>5 Stars</option>
                                    <option value="4" ${selectedRating == 4 ? 'selected' : ''}>4 Stars</option>
                                    <option value="3" ${selectedRating == 3 ? 'selected' : ''}>3 Stars</option>
                                    <option value="2" ${selectedRating == 2 ? 'selected' : ''}>2 Stars</option>
                                    <option value="1" ${selectedRating == 1 ? 'selected' : ''}>1 Star</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="visibility" onchange="this.form.submit()">
                                    <option value="true" ${selectedVisibility == true ? 'selected' : ''}>Active</option>
                                    <option value="false" ${selectedVisibility == false ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-filter me-1"></i> Filter
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/feedback" class="btn btn-outline-secondary">
                                    <i class="fas fa-redo me-1"></i> Reset
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Results summary -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <p class="m-0">Showing <strong>${feedbacks.size()}</strong> of <strong>${totalFeedbacks}</strong> feedbacks</p>
            </div>

            <!-- Feedback List -->
            <div class="row">
                <c:choose>
                    <c:when test="${not empty feedbacks}">
                        <c:forEach items="${feedbacks}" var="feedback">
                            <div class="col-12">
                                <div class="card feedback-card ${!feedback.isVisible ? 'inactive-feedback' : ''}">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="star-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fa${i <= feedback.rating ? 's' : 'r'} fa-star"></i>
                                                </c:forEach>
                                            </span>
                                            <span class="ms-2">${feedback.rating}/5</span>
                                        </div>
                                        <div>
                                            <form action="${pageContext.request.contextPath}/admin/feedback" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="toggleVisibility">
                                                <input type="hidden" name="feedbackId" value="${feedback.feedbackId}">
                                                <input type="hidden" name="isVisible" value="${feedback.isVisible}">
                                                <button type="submit" class="btn btn-sm ${feedback.isVisible ? 'btn-warning' : 'btn-success'}" 
                                                        title="${feedback.isVisible ? 'Disable' : 'Enable'} this feedback">
                                                    <i class="fas fa-${feedback.isVisible ? 'eye-slash' : 'eye'} me-1"></i>
                                                    ${feedback.isVisible ? 'Disable' : 'Enable'}
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <p><strong>Product:</strong> 
                                                    <a href="${pageContext.request.contextPath}/product-detail?id=${feedback.productId}" target="_blank">
                                                        View Product
                                                    </a>
                                                </p>
                                                <p><strong>Order ID:</strong> #${feedback.orderId}</p>
                                                <p><strong>User:</strong> ${feedback.user.username}</p>
                                                <p><strong>Date:</strong> <fmt:formatDate value="${feedback.createdAt}" pattern="dd-MM-yyyy HH:mm" /></p>
                                            </div>
                                            <div class="col-md-9">
                                                <h5>Feedback</h5>
                                                <p class="feedback-content">${feedback.content}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-comment-slash fa-3x mb-3 text-muted"></i>
                            <h4>No feedback found</h4>
                            <p class="text-muted">Try adjusting your filter criteria or check back later</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/feedback?page=${currentPage - 1}${not empty selectedProductId ? '&productId='.concat(selectedProductId) : ''}${not empty selectedRating ? '&rating='.concat(selectedRating) : ''}${selectedVisibility != null ? '&visibility='.concat(selectedVisibility) : ''}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/feedback?page=${i}${not empty selectedProductId ? '&productId='.concat(selectedProductId) : ''}${not empty selectedRating ? '&rating='.concat(selectedRating) : ''}${selectedVisibility != null ? '&visibility='.concat(selectedVisibility) : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/feedback?page=${currentPage + 1}${not empty selectedProductId ? '&productId='.concat(selectedProductId) : ''}${not empty selectedRating ? '&rating='.concat(selectedRating) : ''}${selectedVisibility != null ? '&visibility='.concat(selectedVisibility) : ''}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
        <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
    </body>
</html>