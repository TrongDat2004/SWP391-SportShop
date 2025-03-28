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

        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
        <!-- header section end -->

        <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>
        
        <main class="pt-12">
            <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                <div class="order-history-container">
                    <!-- Title -->
                    <h2 class="text-center text-dark mb-4 mt-20">Order Details</h2>

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
                                          order.status == 'Completed' ? 'success' : 
                                              (order.status == 'Pending' ? 'warning' : 
                                              (order.status == 'Paid' ? 'primary' : 
                                              (order.status == 'NoPaid' ? 'secondary' : 'danger')))}">
                                        ${order.status}
                                    </span>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                        <form action="${pageContext.request.contextPath}/order-details" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <button type="submit" class="btn btn-danger btn-sm" 
                                    onclick="return confirm('Are you sure you want to cancel this order?')">
                                Cancel
                            </button>
                        </form>
                    </c:if>

                    <!-- Product List -->
                    <h4 class="text-dark mb-3">Product List</h4>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover shadow-sm rounded">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Product Name</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                    <th></th>
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
                                        <td>
                                            <c:if test="${order.status == 'completed'}">
                                                <a href="feedback?orderid=${order.orderId}&productId=${item.product.productId}" class="btn btn-dark btn-sm">
                                                    <i class="fas fa-eye"></i> Feedback
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Back Button -->
                    <div class="text-center mt-4 mb-5">
                        <a href="history-order" class="btn btn-outline-primary px-4 py-2 rounded-3">Back to Order List</a>
                    </div>
                </div>
            </section>
        </main>

        <!-- footer section start -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
        <!-- footer section end -->

        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
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
            });
        </script>
    </body>
</html>