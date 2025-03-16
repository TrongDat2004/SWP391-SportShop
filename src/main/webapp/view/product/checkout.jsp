<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="account" value="${sessionScope.account}" />
<c:set var="userRole" value="${account != null ? account.role : null}" />
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
        <!-- include header -->
        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>
            <style>
                :root {
                    --primary-color: #4299e1;
                    --secondary-color: #3a0ca3;
                    --success-color: #4cc9f0;
                    --light-color: #f8f9fa;
                    --dark-color: #212529;
                    --border-radius: 10px;
                    --box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f5f7fa;
                    color: #333;
                }

                .checkout-container {
                    padding: 3rem 0;
                    margin-top: 50px;
                }

                .checkout-header {
                    margin-bottom: 3rem;
                    position: relative;
                }

                .checkout-header h2 {
                    font-weight: 700;
                    color: var(--dark-color);
                    position: relative;
                    display: inline-block;
                }

                .checkout-header h2:after {
                    content: '';
                    position: absolute;
                    bottom: -10px;
                    left: 0;
                    width: 50%;
                    height: 3px;
                    background: linear-gradient(90deg, var(--primary-color), var(--success-color));
                    border-radius: 10px;
                }

                .card {
                    border: none;
                    border-radius: var(--border-radius);
                    box-shadow: var(--box-shadow);
                    overflow: hidden;
                    transition: transform 0.3s ease;
                }

                .card:hover {
                    transform: translateY(-5px);
                }

                .card-header {
                    background-color: var(--primary-color);
                    color: white;
                    font-weight: 600;
                    padding: 1rem;
                    border: none;
                }

                .cart-item {
                    border-left: none;
                    border-right: none;
                    border-top: none;
                    border-bottom: 1px solid rgba(0,0,0,0.08);
                    padding: 1.25rem;
                    transition: background-color 0.3s ease;
                }

                .cart-item:hover {
                    background-color: rgba(67, 97, 238, 0.05);
                }

                .cart-item:last-child {
                    border-bottom: none;
                }

                .cart-item h5 {
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                    color: var(--dark-color);
                }

                .cart-item p {
                    color: #6c757d;
                    margin-bottom: 0;
                }

                .price-badge {
                    background-color: var(--primary-color);
                    font-weight: 500;
                    font-size: 0.9rem;
                    padding: 0.5rem 1rem;
                }

                .total-section {
                    background-color: #f8f9fa;
                    padding: 1rem;
                    border-radius: 0 0 var(--border-radius) var(--border-radius);
                }

                .total-price {
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: var(--success-color);
                }

                .form-label {
                    font-weight: 500;
                    color: var(--dark-color);
                }

                .form-control, .form-select {
                    border: 1px solid #e1e5eb;
                    border-radius: var(--border-radius);
                    padding: 0.75rem 1rem;
                    font-size: 0.95rem;
                    transition: all 0.3s ease;
                }

                .form-control:focus, .form-select:focus {
                    border-color: var(--primary-color);
                    box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
                }

                .form-icon {
                    position: relative;
                }

                .form-icon i {
                    position: absolute;
                    top: 50%;
                    left: 1rem;
                    transform: translateY(-50%);
                    color: #6c757d;
                }

                .form-icon .form-control {
                    padding-left: 0.7rem;
                }

                .btn-checkout {
                    background: linear-gradient(45deg, var(--primary-color), var(--success-color));
                    border: none;
                    border-radius: var(--border-radius);
                    padding: 0.75rem 1.5rem;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    transition: all 0.3s ease;
                    position: relative;
                    overflow: hidden;
                    z-index: 1;
                }

                .btn-checkout:before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 0;
                    height: 100%;
                    background: linear-gradient(45deg, var(--success-color), var(--primary-color));
                    transition: all 0.3s ease;
                    z-index: -1;
                }

                .btn-checkout:hover:before {
                    width: 100%;
                }

                .payment-method-option {
                    display: none;
                }

                .payment-method-label {
                    display: block;
                    cursor: pointer;
                    padding: 1rem;
                    background-color: #fff;
                    border: 1px solid #e1e5eb;
                    border-radius: var(--border-radius);
                    margin-bottom: 1rem;
                    transition: all 0.3s ease;
                    position: relative;
                }

                .payment-method-label:hover {
                    border-color: var(--primary-color);
                }

                .payment-method-option:checked + .payment-method-label {
                    border-color: var(--primary-color);
                    background-color: rgba(67, 97, 238, 0.05);
                }

                .payment-method-option:checked + .payment-method-label:before {
                    content: '✓';
                    position: absolute;
                    right: 1rem;
                    top: 50%;
                    transform: translateY(-50%);
                    color: var(--primary-color);
                    font-weight: bold;
                }

                .payment-icon {
                    font-size: 1.5rem;
                    margin-right: 0.5rem;
                    vertical-align: middle;
                }

                @media (max-width: 768px) {
                    .checkout-container {
                        padding: 1.5rem 0;
                    }

                    .checkout-header {
                        margin-bottom: 1.5rem;
                    }

                    .shipping-info-card {
                        margin-top: 2rem;
                    }
                }
            </style>
            <main class="pt-12">
                <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                    <div class="checkout-container">
                        <div class="container">
                            <div class="checkout-header text-center">
                                <h2 class="mb-4">Complete Your Order</h2>
                                <p class="text-muted">Fill in the payment details to place your order</p>
                            </div>
                        <c:if test="${userRole != 'admin'}">
                            <div class="row g-4">
                                <div class="col-lg-6">
                                    <div class="card mb-4">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h4 class="mb-0">Your Cart</h4>
                                            <span class="badge bg-light text-dark">${cartItems.size()} items</span>
                                        </div>
                                        <div class="card-body p-0">
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="item" items="${cartItems}">
                                                    <li class="list-group-item cart-item d-flex justify-content-between align-items-center">
                                                        <div class="d-flex align-items-center">
                                                            <div class="cart-item-img me-3">
                                                                <div style="width: 60px; height: 60px; background-color: #f1f3f9; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                                    <i class="fas fa-box text-primary" style="font-size: 24px;"></i>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <h5>${item.product.name}</h5>
                                                                <p>
                                                                    <span class="badge bg-light text-dark me-2">x${item.quantity}</span>
                                                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol=""/> VND
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <span class="price-badge badge rounded-pill">
                                                            <fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol=""/> VND
                                                        </span>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="total-section d-flex justify-content-between align-items-center">
                                            <h4 class="mb-0">Total:</h4>
                                            <div class="total-price">
                                                <fmt:formatNumber value="${total}" type="currency" currencySymbol=""/> VND
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card">
                                        <div class="card-header">
                                            <h4 class="mb-0">Order Summary</h4>
                                        </div>
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Subtotal</span>
                                                <span><fmt:formatNumber value="${total}" type="currency" currencySymbol=""/> VND</span>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Shipping Fee</span>
                                                <span>Free</span>
                                            </div>
                                            <div class="mb-3">
                                                <label for="voucherCode" class="form-label">Voucher Code</label>
                                                <div class="input-group">
                                                    <input type="text" class="form-control" id="voucherCode" placeholder="Enter voucher code">
                                                    <button type="button" class="btn btn-dark" id="applyVoucher">Apply</button>
                                                </div>
                                                <small id="voucherMessage" class=""></small>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <strong>Total Payment</strong>
                                                <strong class="total-price" id="finalTotal"><fmt:formatNumber value="${total}" type="currency" currencySymbol=""/> VND</strong>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card shipping-info-card">
                                        <div class="card-header">
                                            <h4 class="mb-0">Shipping Information</h4>
                                        </div>
                                        <div class="card-body">
                                            <form action="checkout" method="post">
                                                <div class="mb-3 form-icon">
                                                    <label for="fullName" class="form-label">Full Name</label>
                                                    <input type="text" class="form-control" id="fullName" name="fullname" value="${account.firstName} ${account.lastName}" required>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="mb-3 form-icon">
                                                            <label for="email" class="form-label">Email</label>
                                                            <input type="email" class="form-control" id="email" name="email" value="${account.email}" required>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="mb-3 form-icon">
                                                            <label for="phone" class="form-label">Phone Number</label>
                                                            <input type="text" class="form-control" id="phone" name="phone" value="${account.phone}" required>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="mb-3 form-icon">
                                                    <label for="shippingAddress" class="form-label">Shipping Address</label>
                                                    <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" placeholder="Full Address" value="${account.address}" required>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label">Payment Method</label>

                                                    <div class="payment-methods">
                                                        <input type="radio" class="payment-method-option" id="cash" name="paymentMethod" value="cash" checked>
                                                        <label for="cash" class="payment-method-label">
                                                            <i class="fas fa-money-bill-wave payment-icon text-success"></i>
                                                            Cash on Delivery (COD)
                                                        </label>

                                                        <input type="radio" class="payment-method-option" id="credit_card" name="paymentMethod" value="banking">
                                                        <label for="credit_card" class="payment-method-label">
                                                            <i class="fas fa-credit-card payment-icon text-primary"></i>
                                                            Credit / Debit Card
                                                        </label>
                                                    </div>
                                                </div>

                                                <button type="submit" class="btn btn-checkout w-100">
                                                    <i class="fas fa-lock me-2"></i>
                                                    Place Order Now
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>           
            </section>
        </main>
        <!-- main end -->

        <!-- footer section -->
        <!-- footer section start -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const applyVoucherBtn = document.getElementById("applyVoucher");
                    const voucherInput = document.getElementById("voucherCode");
                    const voucherMessage = document.getElementById("voucherMessage");
                    const totalPriceElement = document.querySelector("#finalTotal"); // Phần hiển thị tổng tiền

                    applyVoucherBtn.addEventListener("click", function () {
                        const voucherCode = voucherInput.value.trim();
                        if (voucherCode === "") {
                            voucherMessage.textContent = "Please enter a voucher code.";
                            return;
                        }

                        // Gửi request kiểm tra mã voucher qua AJAX
                        const xhr = new XMLHttpRequest();
                        xhr.open("POST", "check-voucher", true);
                        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                        xhr.onload = function () {
                            if (xhr.status === 200) {
                                try {
                                    const response = JSON.parse(xhr.responseText);
                                    if (response.voucherApplied) {
                                        voucherMessage.textContent = "Voucher applied successfully. Discount - " + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(response.discount);
                                        ;
                                        voucherMessage.style.color = "green";

                                        // Cập nhật tổng tiền
                                        totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(response.finalTotal);
                                    } else {
                                        voucherMessage.textContent = "Invalid voucher code.";
                                        voucherMessage.style.color = "red";
                                    }
                                } catch (error) {
                                    voucherMessage.textContent = "Error processing voucher.";
                                }
                            } else {
                                voucherMessage.textContent = "Server error, please try again.";
                            }
                        };

                        xhr.send("voucherCode=" + encodeURIComponent(voucherCode));
                    });
                });
            </script>

            <script  src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>

                function increaseQuantity(button) {
                    const inputElement = button.previousElementSibling;
                    const currentValue = parseInt(inputElement.value);
                    inputElement.value = currentValue + 1;
                }

                function decreaseQuantity(button) {
                    const inputElement = button.nextElementSibling;
                    const currentValue = parseInt(inputElement.value);
                    if (currentValue > 1) {
                        inputElement.value = currentValue - 1;
                    }
                }

                document.addEventListener("DOMContentLoaded", function () {
                    const productImages = document.querySelectorAll('.product-image');
                    productImages.forEach(function (img) {
                        img.addEventListener('error', function () {
                            this.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                        });
                    });
                });
                document.addEventListener("DOMContentLoaded", function () {
                    applyFallbackToImages();
                });

                if (document.readyState === "complete" || document.readyState === "interactive") {
                    applyFallbackToImages();
                }

                const observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (mutation.addedNodes && mutation.addedNodes.length > 0) {
                            mutation.addedNodes.forEach(function (node) {
                                if (node.nodeType === 1) {
                                    if (node.tagName === 'IMG') {
                                        applyFallbackToImage(node);
                                    }
                                    const imgElements = node.querySelectorAll('img');
                                    imgElements.forEach(applyFallbackToImage);
                                }
                            });
                        }
                    });
                });

                observer.observe(document.documentElement, {
                    childList: true,
                    subtree: true
                });

                function applyFallbackToImages() {
                    const allImages = document.querySelectorAll('img');
                    allImages.forEach(applyFallbackToImage);
                }

                function applyFallbackToImage(img) {
                    if (!img.hasAttribute('data-fallback-applied')) {
                        img.setAttribute('data-fallback-applied', 'true');

                        if (img.complete && (img.naturalWidth === 0 || img.naturalHeight === 0)) {
                            img.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                        }


                        img.onerror = function () {
                            this.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                        };
                    }
                }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
                function confirmDelete(event, form) {
                    event.preventDefault();
                    Swal.fire({
                        title: "Are you sure?",
                        text: "Do you want to remove this item from the cart?",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#d33",
                        cancelButtonColor: "#3085d6",
                        confirmButtonText: "Yes, delete it!",
                        cancelButtonText: "Cancel"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                }

                function confirmClearCart(event, form) {
                    event.preventDefault();
                    Swal.fire({
                        title: "Are you sure?",
                        text: "Do you want to clear the entire cart?",
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#d33",
                        cancelButtonColor: "#3085d6",
                        confirmButtonText: "Yes, clear it!",
                        cancelButtonText: "Cancel"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            form.submit();
                        }
                    });
                }
        </script>
        <c:set var="status" value="${param.status}" />
        <c:set var="type" value="${param.type}" />

        <c:set var="alertType" value="" />
        <c:set var="alertMessage" value="" />

        <c:choose>
            <c:when test="${status == 'true'}">
                <c:choose>
                    <c:when test="${type == 'add'}">
                        <c:set var="alertType" value="success" />
                        <c:set var="alertMessage" value="The product has been added to your cart!" />
                    </c:when>
                    <c:when test="${type == 'update'}">
                        <c:set var="alertType" value="success" />
                        <c:set var="alertMessage" value="Cart item quantity updated successfully!" />
                    </c:when>
                    <c:when test="${type == 'delete'}">
                        <c:set var="alertType" value="success" />
                        <c:set var="alertMessage" value="Product removed from the cart!" />
                    </c:when>
                    <c:when test="${type == 'clear'}">
                        <c:set var="alertType" value="success" />
                        <c:set var="alertMessage" value="Your cart has been cleared!" />
                    </c:when>
                </c:choose>
            </c:when>
            <c:when test="${status == 'false' and type == 'update'}">
                <c:set var="alertType" value="error" />
                <c:set var="alertMessage" value="Not enough stock available to update quantity!" />
            </c:when>
            <c:when test="${status == 'false' and type == 'stock'}">
                <c:set var="alertType" value="error" />
                <c:set var="alertMessage" value="Not enough stock available to update quantity!" />
            </c:when>
            <c:otherwise>
                <c:if test="${not empty type}">
                    <c:set var="alertType" value="error" />
                    <c:set var="alertMessage" value="Not enough stock available!" />
                </c:if>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty alertType and not empty alertMessage}">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    Swal.fire({
                        icon: '${alertType}',
                        title: '${alertMessage}',
                        showConfirmButton: false,
                        timer: 2000
                    });

                    if (window.history.replaceState) {
                        const newUrl = window.location.origin + window.location.pathname;
                        window.history.replaceState({}, document.title, newUrl);
                    }
                });
            </script>
        </c:if>

    </body>

</html>