<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favi.jpg" sizes="16x16">
        <title>SportShop | Your Hub for Quality Sports equipment, Gear, and Accessories</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>
    <body>
        <!-- back to top -->
        <button class="back-to-top position-fixed end-0 bottom-0 d-center me-5">
            <span class="text-h4">
                <i class="ph ph-arrow-up"></i>
            </span>
        </button>
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

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8fafc;
                color: #334155;
            }

            .order-history-container {
                padding: 3rem 0;
                margin-top: 50px;
            }

            .section-title {
                margin-bottom: 2.5rem;
                position: relative;
                font-weight: 700;
                color: var(--dark-color);
                display: inline-block;
            }

            .section-title:after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background: linear-gradient(90deg, var(--primary-color), var(--info-color));
                border-radius: 10px;
            }

            .search-container {
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                padding: 1.5rem;
                margin-bottom: 2rem;
            }

            .search-box {
                border-radius: var(--border-radius);
                padding: 0.75rem 1rem;
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
            }

            .search-box:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            }

            .search-btn {
                background-color: var(--primary-color);
                border: none;
                border-radius: var(--border-radius);
                padding: 0.75rem 1.5rem;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .search-btn:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            }

            .search-icon {
                margin-right: 0.5rem;
            }

            .orders-table-container {
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                overflow: hidden;
                margin-bottom: 2rem;
            }

            .orders-table {
                border-collapse: separate;
                border-spacing: 0;
                width: 100%;
            }

            .orders-table thead th {
                background-color: #1e293b;
                color: white;
                text-transform: uppercase;
                font-size: 0.85rem;
                font-weight: 600;
                letter-spacing: 0.5px;
                padding: 1rem;
                border: none;
            }

            .orders-table th:first-child {
                border-top-left-radius: var(--border-radius);
            }

            .orders-table th:last-child {
                border-top-right-radius: var(--border-radius);
            }

            .orders-table tbody tr {
                transition: all 0.3s ease;
                border-bottom: 1px solid #f1f5f9;
            }

            .orders-table tbody tr:hover {
                background-color: #f8fafc;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            }

            .orders-table tbody tr:last-child {
                border-bottom: none;
            }

            .orders-table td {
                padding: 1rem;
                vertical-align: middle;
                font-size: 0.95rem;
            }

            .order-id {
                font-weight: 600;
                color: var(--dark-color);
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


            .total-amount {
                font-weight: 600;
                color: var(--primary-color);
            }

            .payment-method {
                text-transform: capitalize;
                display: flex;
                align-items: center;
            }

            .payment-icon {
                margin-right: 0.5rem;
                font-size: 1.1rem;
            }

            .created-at {
                color: #64748b;
                font-size: 0.9rem;
            }

            .pagination {
                margin-top: 2rem;
            }

            .page-item .page-link {
                border: none;
                margin: 0 0.25rem;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                color: #64748b;
                transition: all 0.3s ease;
            }

            .page-item.active .page-link {
                background-color: var(--primary-color);
                color: white;
                box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            }

            .page-item .page-link:hover {
                background-color: #e2e8f0;
                color: var(--dark-color);
                transform: translateY(-2px);
            }

            .page-item.active .page-link:hover {
                background-color: var(--primary-color);
                color: white;
            }

            .page-item:first-child .page-link,
            .page-item:last-child .page-link {
                border-radius: var(--border-radius);
                width: auto;
                padding: 0.5rem 1rem;
            }

            .mobile-data {
                display: none;
            }

            .shipping-address, .user-details {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            @media (max-width: 1200px) {
                .orders-table thead th:nth-child(5),
                .orders-table thead th:nth-child(6),
                .orders-table thead th:nth-child(7),
                .orders-table thead th:nth-child(8) {
                    display: none;
                }

                .orders-table tbody td:nth-child(5),
                .orders-table tbody td:nth-child(6),
                .orders-table tbody td:nth-child(7),
                .orders-table tbody td:nth-child(8) {
                    display: none;
                }
            }

            @media (max-width: 768px) {
                .order-history-container {
                    padding: 1.5rem 0;
                }

                .section-title {
                    margin-bottom: 1.5rem;
                }

                .search-container {
                    padding: 1rem;
                    margin-bottom: 1.5rem;
                }

                .orders-table thead {
                    display: none;
                }

                .orders-table tbody tr {
                    display: block;
                    border: 1px solid #e2e8f0;
                    border-radius: var(--border-radius);
                    margin-bottom: 1rem;
                    padding: 1rem;
                }

                .orders-table tbody td {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 0.5rem 0;
                    border-bottom: 1px solid #f1f5f9;
                }

                .orders-table tbody td:last-child {
                    border-bottom: none;
                }

                .mobile-data {
                    display: block;
                    font-weight: 600;
                    color: var(--dark-color);
                }

                .created-at {
                    text-align: right;
                }
            }
        </style>

        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>
            <main class="pt-12">
                <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                    <div class="order-history-container">
                        <div class="container">
                            <h2 class="section-title text-center">Your Order History</h2>

                            <div class="search-container">
                                <form class="d-flex" method="get" action="history-order">
                                    <input type="hidden" name="action" value="history">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0">
                                            <i class="fas fa-search text-muted"></i>
                                        </span>
                                        <input type="text" class="form-control border-start-0 search-box" name="search" placeholder="Search by status or payment method..." value="${param.search}">
                                    <button type="submit" class="btn search-btn">
                                        <i class="fas fa-filter search-icon"></i> Search
                                    </button>
                                </div>
                            </form>
                        </div>

                        <div class="orders-table-container">
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger">
                                    ${param.error}
                                </div>
                            </c:if>

                            <c:if test="${not empty param.success}">
                                <div class="alert alert-success">
                                    ${param.success}
                                </div>
                            </c:if>
                            <table class="orders-table">
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
                                                <span class="mobile-data">Order ID:</span>
                                                <span class="order-id">#${order.orderId}</span>
                                            </td>
                                            <td>
                                                <span class="mobile-data">Full Name:</span>
                                                <span class="user-details">${order.fullname}</span>
                                            </td>
                                            <td>
                                                <span class="mobile-data">Shipping Address:</span>
                                                <span class="shipping-address" title="${order.shippingAddress}">${order.shippingAddress}</span>
                                            </td>
                                            <td>
                                                <span class="mobile-data">Total:</span>
                                                <span class="total-amount"><fmt:formatNumber value="${order.total}" type="currency" currencySymbol=""/> VNĐ</span>
                                            </td>
                                            <td>
                                                <span class="mobile-data">Status:</span>
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
                                                    <span class="mobile-data">Payment Method:</span>
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
                                                    <span class="mobile-data">Created At:</span>
                                                    <span class="created-at">${order.createdAt}</span>
                                                </td>
                                                <td>
                                                    <a href="order-details?orderid=${order.orderId}" class="btn btn-dark btn-sm">
                                                        <i class="fas fa-eye"></i> View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <nav aria-label="Pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="history-order?action=history&search=${search}&page=${currentPage - 1}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="history-order?action=history&search=${search}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="history-order?action=history&search=${search}&page=${currentPage + 1}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </div>             
                </section>
            </main>
            <!-- main end -->

            <!-- footer section -->
            <!-- footer section start -->
            <jsp:include page="../common/home/footer.jsp"></jsp:include>
                <!-- footer section end -->
                <script  src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        </body>
    </html>