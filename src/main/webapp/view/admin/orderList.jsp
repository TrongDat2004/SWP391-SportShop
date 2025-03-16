<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management || Clothing</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
            <style>
                :root {
                    --primary-color: #4361ee;
                    --secondary-color: #3a0ca3;
                    --success-color: #10b981;
                    --warning-color: #fbbf24;
                    --danger-color: #ef4444;
                    --info-color: #3b82f6;
                    --pending-color: #f59e0b;
                    --accepted-color: #3b82f6;
                    --completed-color: #10b981;
                    --cancelled-color: #ef4444;
                    --light-color: #f8f9fa;
                    --dark-color: #1e293b;
                    --border-radius: 10px;
                    --box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                }
                .fixed-width-btn {
                    min-width: 120px;
                    text-align: center;
                }
                .badge {
                    font-size: 0.85rem;
                    font-weight: 600;
                    padding: 0.5rem 0.75rem;
                    border-radius: 50px;
                    text-transform: capitalize;
                }

                .badge-pending {
                    background-color: var(--pending-color);
                    color: white;
                }

                .badge-accepted {
                    background-color: var(--accepted-color);
                    color: white;
                }

                .badge-completed {
                    background-color: var(--completed-color);
                    color: white;
                }

                .badge-cancelled {
                    background-color: var(--cancelled-color);
                    color: white;
                }

                .badge-paid {
                    background-color: #28a745;
                    color: white;
                }

                .badge-nopaid {
                    background-color: #dc3545;
                    color: white;
                }
            </style>
        </head>

        <body>
            <!-- Sidebar -->
        <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

            <!-- Header -->
        <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

        <c:url value="/admin/manage-order" var="paginationUrl">
            <c:param name="action" value="list" />
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
                    <form action="${pageContext.request.contextPath}/admin/manage-order" method="get">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <input type="text" class="form-control" name="search" value="${search}" placeholder="Search...">
                            </div>
                            <div class="col-md-3">
                                <select name="status" class="form-control">
                                    <option value="">All Status</option>
                                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="completed" ${status == 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="canceled" ${status == 'canceled' ? 'selected' : ''}>Canceled</option>
                                    <option value="paid" ${status == 'paid' ? 'selected' : ''}>Paid</option>
                                    <option value="nopaid" ${status == 'nopaid' ? 'selected' : ''}>No paid</option>
                                </select>
                            </div>
                            <div class="col-md-3"><button type="submit" class="btn btn-primary w-100">Search</button></div>
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
                                    <th>Order ID</th>
                                    <th>Full Name</th>
                                    <th>Shipping Address</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th>Created At</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>
                                            <span class="order-id">#${order.orderId}</span>
                                        </td>
                                        <td>
                                            <span class="user-details">${order.fullname}</span>
                                        </td>
                                        <td>
                                            <span class="shipping-address" title="${order.shippingAddress}">${order.shippingAddress}</span>
                                        </td>
                                        <td>
                                            <span class="total-amount"><fmt:formatNumber value="${order.total}" type="currency" currencySymbol=""/> VNĐ</span>
                                        </td>
                                        <td>
                                            <span class="badge
                                                  ${order.status == 'pending' ? 'badge-pending' :
                                                    order.status == 'accepted' ? 'badge-accepted' :
                                                    order.status == 'cancelled' ? 'badge-cancelled' :
                                                    order.status == 'paid' ? 'badge-paid' :
                                                    order.status == 'nopaid' ? 'badge-nopaid' :
                                                    'badge-completed'}">
                                                      ${order.status == 'pending' ? 'Pending' :
                                                        order.status == 'accepted' ? 'Confirmed' :
                                                        order.status == 'cancelled' ? 'Cancelled' :
                                                        order.status == 'paid' ? 'Paid' :
                                                        order.status == 'nopaid' ? 'Not Paid' :
                                                        'Completed'}
                                                  </span>
                                            </td>

                                            <td>
                                                <span class="payment-method">
                                                    <i class="payment-icon
                                                       ${order.paymentMethod == 'cash' ? 'fas fa-money-bill-wave text-success' :
                                                         order.paymentMethod == 'credit_card' ? 'far fa-credit-card text-primary' :
                                                         'fab fa-paypal text-info'}">
                                                    </i>
                                                    ${order.paymentMethod == 'cash' ? 'Cash' :
                                                      order.paymentMethod == 'banking' ? 'banking' : 'banking'}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="created-at">${order.createdAt}</span>
                                            </td>
                                            <td>
                                                <a href="manage-order?action=order-details&orderid=${order.orderId}" class="btn btn-dark btn-sm">
                                                    <i class="fas fa-eye"></i> View Details
                                                </a>
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
