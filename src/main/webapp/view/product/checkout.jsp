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
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favi.jpg" sizes="16x16"> <%-- Sửa path --%>
        <title>SportShop | Checkout</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            /* Style checkout */
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
                margin-bottom: 1.5rem; /* Thêm margin bottom */
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
                padding: 1rem 1.25rem;
                transition: background-color 0.3s ease;
            } /* Giảm padding ngang */
            .cart-item:hover {
                background-color: rgba(67, 97, 238, 0.05);
            }
            .cart-item:last-child {
                border-bottom: none;
            }
            .cart-item .item-info {
                display: flex;
                align-items: center;
            } /* Flex container for image and text */
            .cart-item .item-image {
                width: 50px;
                height: 50px;
                object-fit: cover;
                border-radius: 5px;
                margin-right: 1rem;
                border: 1px solid #eee;
            }
            .cart-item .item-details h5 {
                font-weight: 600;
                margin-bottom: 0.25rem;
                color: var(--dark-color);
                font-size: 0.95rem;
            } /* Giảm size chữ */
            .cart-item .item-details p {
                color: #6c757d;
                margin-bottom: 0;
                font-size: 0.85rem;
            } /* Giảm size chữ */
            .cart-item .item-details .item-size {
                display: block;
                font-size: 0.8rem;
                color: #888;
            } /* Style cho size */
            .cart-item .price-badge {
                background-color: var(--primary-color);
                font-weight: 500;
                font-size: 0.9rem;
                padding: 0.4rem 0.8rem;
                color: white;
                border-radius: 50px;
                white-space: nowrap; /* Ngăn xuống dòng */
            } /* Thêm color: white */
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
                margin-bottom: 0.3rem; /* Giảm margin */
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
                pointer-events: none; /* Để click xuyên qua icon */
            }
            .form-icon .form-control {
                padding-left: 2.8rem;
            } /* Tăng padding left */
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
                color: white;
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
                display: flex;
                align-items: center;
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
                box-shadow: 0 0 5px rgba(67, 97, 238, 0.2); /* Thêm shadow nhẹ */
            }
            .payment-method-option:checked + .payment-method-label:after {
                content: '✓';
                position: absolute;
                right: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--primary-color);
                font-weight: bold;
                font-size: 1.2rem;
            }
            .payment-icon {
                font-size: 1.5rem;
                margin-right: 0.75rem;
                vertical-align: middle;
                width: 25px; /* Đảm bảo icon thẳng hàng */
                text-align: center;
            }
            #voucherMessage {
                font-size: 0.85rem;
                margin-top: 0.25rem;
                display: block;
                min-height: 1.2em;
            }
            @media (max-width: 768px) {
                .checkout-container {
                    padding: 1.5rem 0;
                }
                .checkout-header {
                    margin-bottom: 1.5rem;
                }
                .form-icon .form-control {
                    padding-left: 1rem;
                } /* Giảm padding lại */
                .form-icon i {
                    display: none;
                }
            }
            .sticky-lg-top {
                position: -webkit-sticky;
                position: sticky;
                top: 100px; /* Điều chỉnh khoảng cách top */
                z-index: 1020; /* Đảm bảo nằm trên */
            }
        </style>
    </head>
    <body>
        <!-- back to top, header, cart box -->
        <button class="back-to-top position-fixed end-0 bottom-0 d-center me-5"><span class="text-h4"><i class="ph ph-arrow-up"></i></span></button>
                <jsp:include page="../common/home/header.jsp"></jsp:include>
                <jsp:include page="../common/home/cartbox.jsp"></jsp:include>

            <main class="pt-12">
                <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                    <div class="checkout-container">
                        <div class="container">
                            <div class="checkout-header text-center">
                                <h2 class="mb-4">Complete Your Order</h2>
                                <p class="text-muted">Review your order and provide shipping details.</p>
                            </div>
                        <c:if test="${userRole == 'admin'}">
                            <div class="alert alert-danger text-center" role="alert">Admins cannot place orders. Please use a customer account.</div>
                        </c:if>
                        <c:if test="${userRole != 'admin'}">
                            <c:choose>
                                <c:when test="${empty cartItems}">
                                    <div class="alert alert-warning text-center" role="alert"> Your cart is empty. <a href="products" class="alert-link">Continue shopping</a>. </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-4">
                                        <%-- Cột tóm tắt đơn hàng --%>
                                        <div class="col-lg-5 order-lg-2"> <%-- Chuyển sang phải trên màn lớn --%>
                                            <div class="card sticky-lg-top">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h4 class="mb-0">Your Cart Summary</h4>
                                                    <span class="badge bg-light text-dark rounded-pill">${cartItems.size()} items</span>
                                                </div>
                                                <div class="card-body p-0" style="max-height: 350px; overflow-y: auto;">
                                                    <ul class="list-group list-group-flush">
                                                        <c:forEach var="item" items="${cartItems}">
                                                            <li class="list-group-item cart-item d-flex justify-content-between align-items-center">
                                                                <div class="item-info"> <%-- Bọc ảnh và text --%>
                                                                    <img src="${pageContext.request.contextPath}/${item.product.image}" alt="${item.product.name}" class="item-image" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                                                    <div class="item-details">
                                                                        <h5>${item.product.name}</h5>
                                                                        <%-- HIỂN THỊ SIZE Ở ĐÂY --%>
                                                                        <c:if test="${item.productSize != null && item.productSize.size != 'One Size' && item.productSize.size != 'N/A'}">
                                                                            <span class="item-size">Size: ${item.productSize.size}</span>
                                                                        </c:if>
                                                                        <p>
                                                                            <small class="text-muted">Qty: ${item.quantity} × <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/> VND</small>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <span class="price-badge badge rounded-pill"> <fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/> VND </span>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                                <div class="card-body border-top">
                                                    <div class="d-flex justify-content-between mb-2"> <span>Subtotal</span> <span><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> VND</span> </div>
                                                    <div class="d-flex justify-content-between mb-2"> <span>Shipping Fee</span> <span class="text-success">Free</span> </div>
                                                    <div class="d-flex justify-content-between mb-2" id="discountRow" style="display: none;"> <span>Discount</span> <span class="text-danger" id="discountAmount">- 0 VND</span> </div>
                                                    <hr>
                                                    <div class="mb-3">
                                                        <label for="voucherCode" class="form-label">Voucher Code</label>
                                                        <div class="input-group">
                                                            <input type="text" class="form-control" id="voucherCode" placeholder="Enter voucher code">
                                                            <button type="button" class="btn btn-outline-secondary" id="applyVoucher">Apply</button>
                                                        </div>
                                                        <small id="voucherMessage" class="text-muted"></small>
                                                    </div>
                                                    <hr>
                                                    <div class="d-flex justify-content-between fw-bold fs-5"> <span>Total Payment</span> <span class="total-price" id="finalTotal"><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> VND</span> </div>
                                                </div>
                                            </div>
                                        </div>

                                        <%-- Cột thông tin giao hàng và thanh toán --%>
                                        <div class="col-lg-7 order-lg-1"> <%-- Chuyển sang trái trên màn lớn --%>
                                            <div class="card shipping-info-card">
                                                <div class="card-header"> <h4 class="mb-0">Shipping & Payment</h4> </div>
                                                <div class="card-body">
                                                    <form action="checkout" method="post" id="checkoutForm">
                                                        <h5 class="mb-3">Shipping Address</h5>
                                                        <div class="mb-3 form-icon"> <i class="fas fa-user"></i> <input type="text" class="form-control" id="fullName" name="fullname" value="${not empty account.firstName ? account.firstName : ''} ${not empty account.lastName ? account.lastName : ''}" placeholder="Full Name" required> </div>
                                                        <div class="row g-3">
                                                            <div class="col-md-6 mb-3 form-icon"> <i class="fas fa-envelope"></i> <input type="email" class="form-control" id="email" name="email" value="${account.email}" placeholder="Email Address" required> </div>
                                                            <div class="col-md-6 mb-3 form-icon"> <i class="fas fa-phone"></i> <input type="tel" class="form-control" id="phone" name="phone" value="${account.phone}" placeholder="Phone Number" required pattern="[0-9]{10,11}" title="Please enter a valid phone number (10-11 digits)"> </div>
                                                        </div>
                                                        <div class="mb-4 form-icon"> <i class="fas fa-map-marker-alt"></i> <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" placeholder="Street Address, City, Province" value="${account.address}" required> </div>

                                                        <h5 class="mb-3">Payment Method</h5>
                                                        <div class="payment-methods">
                                                            <input type="radio" class="payment-method-option" id="cash" name="paymentMethod" value="cash" checked>
                                                            <label for="cash" class="payment-method-label"> <i class="fas fa-money-bill-wave payment-icon text-success"></i> <span>Cash on Delivery (COD)</span> </label>
                                                            <input type="radio" class="payment-method-option" id="banking" name="paymentMethod" value="banking">
                                                            <label for="banking" class="payment-method-label"> <i class="fas fa-credit-card payment-icon text-primary"></i> <span>VnPay Gateway</span> </label>
                                                        </div>
                                                        <button type="submit" class="btn btn-checkout w-100 mt-4"> <i class="fas fa-lock me-2"></i> Place Order Now </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if> <%-- End check userRole --%>
                    </div>
                </div>
            </section>
        </main>
        <!-- main end -->

        <!-- footer section start -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->

            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script>
            // --- Voucher AJAX Logic ---
            document.addEventListener("DOMContentLoaded", function () {
                const applyVoucherBtn = document.getElementById("applyVoucher");
                const voucherInput = document.getElementById("voucherCode");
                const voucherMessage = document.getElementById("voucherMessage");
                const finalTotalElement = document.getElementById("finalTotal");
                const discountRow = document.getElementById("discountRow");
                const discountAmountElement = document.getElementById("discountAmount");
                const originalTotal = parseFloat("${total}"); // Lấy tổng tiền gốc từ JSP

                applyVoucherBtn.addEventListener("click", function () {
                    const voucherCode = voucherInput.value.trim();
                    voucherMessage.textContent = "";
                    voucherMessage.className = 'text-muted';
                    discountRow.style.display = 'none';

                    if (voucherCode === "") {
                        voucherMessage.textContent = "Please enter a voucher code.";
                        voucherMessage.className = 'text-danger';
                        finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(originalTotal);
                        discountRow.style.display = 'none';
                        return;
                    }
                    voucherMessage.textContent = "Checking...";
                    voucherMessage.className = 'text-info';
                    applyVoucherBtn.disabled = true;

                    fetch('check-voucher', {// Dùng fetch API
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'voucherCode=' + encodeURIComponent(voucherCode)
                    })
                            .then(response => {
                                applyVoucherBtn.disabled = false;
                                if (!response.ok) {
                                    throw new Error('Network response was not ok: ' + response.statusText);
                                }
                                return response.json();
                            })
                            .then(data => {
                                voucherMessage.textContent = data.message;
                                if (data.voucherApplied) {
                                    voucherMessage.className = 'text-success';
                                    finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.finalTotal);
                                    discountAmountElement.textContent = '- ' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.discount);
                                    discountRow.style.display = 'flex';
                                } else {
                                    voucherMessage.className = 'text-danger';
                                    finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.originalTotal);
                                    discountRow.style.display = 'none';
                                    if (data.redirect) {
                                        window.location.href = data.redirect;
                                    }
                                }
                            })
                            .catch(error => {
                                applyVoucherBtn.disabled = false;
                                voucherMessage.textContent = "Error: " + error.message;
                                voucherMessage.className = 'text-danger';
                                finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(originalTotal);
                                discountRow.style.display = 'none';
                                console.error('Fetch error:', error);
                            });
                });

                // --- Image Fallback ---
                applyFallbackToImages();
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
                                    } else {
                                        const imgElements = node.querySelectorAll('img');
                                        imgElements.forEach(applyFallbackToImage);
                                    }
                                }
                            });
                        }
                    });
                });
                observer.observe(document.documentElement, {childList: true, subtree: true});
                function applyFallbackToImages() {
                    const allImages = document.querySelectorAll('img');
                    allImages.forEach(applyFallbackToImage);
                }
                function applyFallbackToImage(img) {
                    if (!img.hasAttribute('data-fallback-applied')) {
                        img.setAttribute('data-fallback-applied', 'true');
                        const originalSrc = img.src;
                        if (img.complete && (typeof img.naturalWidth === "undefined" || img.naturalWidth === 0)) {
                            if (originalSrc !== 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg') {
                                img.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                            }
                        }
                        img.onerror = function () {
                            if (this.src !== 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg') {
                                this.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                            }
                        };
                    }
                }
            });
        </script>
    </body>
</html>