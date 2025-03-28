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
                    background-color: #28a745; /* Màu xanh lá */
                    color: white;
                }
                .badge-nopaid {
                    background-color: #dc3545; /* Màu đỏ */
                    color: white;
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
                <h6 class="fw-semibold mb-0">Order Management</h6>
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
                    <div class="order-history-container">
                        <!-- Title -->
                        <h2 class="text-center text-dark mb-4">Order Details</h2>

                        <!-- Order Information -->
                        <div class="card mb-4 shadow-lg rounded-3">
                            <div class="card-body">
                                <h5 class="card-title text-dark mb-3">Order Information</h5>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Order ID:</strong> ${order.orderId}</li>
                                    <li class="list-group-item"><strong>Customer:</strong> ${order.fullname}</li>
                                    <li class="list-group-item"><strong>Email:</strong> ${order.email}</li>
                                    <li class="list-group-item"><strong>Phone Number:</strong> ${order.phone}</li>
                                    <li class="list-group-item"><strong>Shipping Address:</strong> ${order.shippingAddress}</li>
                                    <li class="list-group-item"><strong>Order Date:</strong> ${order.createdAt}</li>
                                    <li class="list-group-item">
                                        <strong>Total Amount:</strong> 
                                        <fmt:formatNumber value="${order.total}" pattern="#,##0"/> VND
                                    </li>
                                    <li class="list-group-item">
                                        <strong>Status:</strong> 
                                        <span class="badge bg-${
                                              order.status == 'completed' ? 'success' : 
                                                  (order.status == 'pending' ? 'warning' : 
                                                  (order.status == 'paid' ? 'primary' : 
                                                  (order.status == 'nopaid' ? 'secondary' : 'danger')))}">
                                                  ${order.status}
                                              </span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <c:set var="account" value="${sessionScope.account}" />
                            <c:set var="userRole" value="${account != null ? account.role : null}" />

                            <c:if test="${account.userId != order.userId}">


                                <!-- Change Order Status Form -->
                                <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                                    <div class="card mb-4 shadow-lg rounded-3 mt-3">
                                        <div class="card-body">
                                            <form action="${pageContext.request.contextPath}/admin/manage-order" method="post">
                                                <input type="hidden" name="orderId" value="${order.orderId}" />
                                                <div class="mb-3">
                                                    <label for="status" class="form-label">Change Status</label>
                                                    <select name="status" id="status" class="form-control">
                                                        <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Pending</option>
                                                        <option value="accepted" ${order.status == 'accepted' ? 'selected' : ''}>Accepted</option>
                                                        <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Canceled</option>
                                                        <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Completed</option>
                                                        <option value="paid" ${order.status == 'paid' ? 'selected' : ''}>Paid</option>
                                                        <option value="nopaid" ${order.status == 'nopaid' ? 'selected' : ''}>No Paid</option>
                                                    </select>
                                                </div>
                                                <button type="submit" class="btn btn-primary">Update Status</button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:if>
                            <h4 class="text-dark mb-3 mt-3">Product List</h4>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover shadow-sm rounded">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>#</th>
                                            <th>Product Name</th>
                                            <th>Quantity</th>
                                            <th>Price</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${details}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>${item.product.name}</td>
                                                <td>${item.quantity}</td>
                                                <td><fmt:formatNumber value="${item.price}" pattern="#,##0"/> VND</td>
                                                <td><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0"/> VND</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Back Button -->
                            <div class="text-center mt-4">
                                <a href="manage-order" class="btn btn-outline-primary px-4 py-2 rounded-3">Back to Order List</a>
                            </div>
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