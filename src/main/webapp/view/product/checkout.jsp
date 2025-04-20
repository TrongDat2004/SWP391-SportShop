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
        <title>SportShop | Checkout</title> <%-- Sửa title --%>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <%-- Giữ nguyên các CSS styles --%>
        <style>
             /* Style checkout (giữ nguyên) */
             :root { --primary-color: #4299e1; --secondary-color: #3a0ca3; --success-color: #4cc9f0; --light-color: #f8f9fa; --dark-color: #212529; --border-radius: 10px; --box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
             body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f7fa; color: #333; }
             .checkout-container { padding: 3rem 0; margin-top: 50px; }
             .checkout-header { margin-bottom: 3rem; position: relative; }
             .checkout-header h2 { font-weight: 700; color: var(--dark-color); position: relative; display: inline-block; }
             .checkout-header h2:after { content: ''; position: absolute; bottom: -10px; left: 0; width: 50%; height: 3px; background: linear-gradient(90deg, var(--primary-color), var(--success-color)); border-radius: 10px; }
             .card { border: none; border-radius: var(--border-radius); box-shadow: var(--box-shadow); overflow: hidden; transition: transform 0.3s ease; }
             .card:hover { transform: translateY(-5px); }
             .card-header { background-color: var(--primary-color); color: white; font-weight: 600; padding: 1rem; border: none; }
             .cart-item { border-left: none; border-right: none; border-top: none; border-bottom: 1px solid rgba(0,0,0,0.08); padding: 1.25rem; transition: background-color 0.3s ease; }
             .cart-item:hover { background-color: rgba(67, 97, 238, 0.05); }
             .cart-item:last-child { border-bottom: none; }
             .cart-item h5 { font-weight: 600; margin-bottom: 0.5rem; color: var(--dark-color); }
             .cart-item p { color: #6c757d; margin-bottom: 0; }
             .price-badge { background-color: var(--primary-color); font-weight: 500; font-size: 0.9rem; padding: 0.5rem 1rem; color: white; } /* Thêm color: white */
             .total-section { background-color: #f8f9fa; padding: 1rem; border-radius: 0 0 var(--border-radius) var(--border-radius); }
             .total-price { font-size: 1.5rem; font-weight: 700; color: var(--success-color); }
             .form-label { font-weight: 500; color: var(--dark-color); }
             .form-control, .form-select { border: 1px solid #e1e5eb; border-radius: var(--border-radius); padding: 0.75rem 1rem; font-size: 0.95rem; transition: all 0.3s ease; }
             .form-control:focus, .form-select:focus { border-color: var(--primary-color); box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25); }
             .form-icon { position: relative; }
             .form-icon i { position: absolute; top: 50%; left: 1rem; transform: translateY(-50%); color: #6c757d; }
             .form-icon .form-control { padding-left: 2.5rem; } /* Tăng padding left để icon không che chữ */
             .btn-checkout { background: linear-gradient(45deg, var(--primary-color), var(--success-color)); border: none; border-radius: var(--border-radius); padding: 0.75rem 1.5rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s ease; position: relative; overflow: hidden; z-index: 1; color: white; }
             .btn-checkout:before { content: ''; position: absolute; top: 0; left: 0; width: 0; height: 100%; background: linear-gradient(45deg, var(--success-color), var(--primary-color)); transition: all 0.3s ease; z-index: -1; }
             .btn-checkout:hover:before { width: 100%; }
             .payment-method-option { display: none; }
             .payment-method-label { display: flex; align-items: center; cursor: pointer; padding: 1rem; background-color: #fff; border: 1px solid #e1e5eb; border-radius: var(--border-radius); margin-bottom: 1rem; transition: all 0.3s ease; position: relative; } /* Dùng flex */
             .payment-method-label:hover { border-color: var(--primary-color); }
             .payment-method-option:checked + .payment-method-label { border-color: var(--primary-color); background-color: rgba(67, 97, 238, 0.05); }
             .payment-method-option:checked + .payment-method-label:after { /* Dùng after thay vì before */ content: '✓'; position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); color: var(--primary-color); font-weight: bold; font-size: 1.2rem; }
             .payment-icon { font-size: 1.5rem; margin-right: 0.75rem; /* Tăng margin */ vertical-align: middle; }
              #voucherMessage { font-size: 0.85rem; margin-top: 0.25rem; display: block; min-height: 1.2em; /* Đảm bảo có không gian */ } /* Style cho tin nhắn voucher */
             @media (max-width: 768px) {
                 .checkout-container { padding: 1.5rem 0; }
                 .checkout-header { margin-bottom: 1.5rem; }
                 .shipping-info-card { margin-top: 2rem; }
                 .form-icon .form-control { padding-left: 0.75rem; } /* Điều chỉnh lại padding cho mobile */
                 .form-icon i { display: none; } /* Ẩn icon trên mobile nếu muốn */
             }
        </style>
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
                <div class="checkout-container">
                    <div class="container">
                        <div class="checkout-header text-center">
                            <h2 class="mb-4">Complete Your Order</h2>
                            <p class="text-muted">Review your order and provide shipping details.</p>
                        </div>
                        <%-- Kiểm tra nếu người dùng là admin thì không cho checkout --%>
                        <c:if test="${userRole == 'admin'}">
                             <div class="alert alert-danger text-center" role="alert">
                                Admins cannot place orders. Please use a customer account.
                            </div>
                         </c:if>
                        <c:if test="${userRole != 'admin'}">
                            <c:choose>
                                <c:when test="${empty cartItems}">
                                    <div class="alert alert-warning text-center" role="alert">
                                        Your cart is empty. <a href="products" class="alert-link">Continue shopping</a>.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-4">
                                        <%-- Cột tóm tắt đơn hàng --%>
                                        <div class="col-lg-6 order-lg-2"> <%-- Đổi thứ tự cột trên màn hình lớn --%>
                                            <div class="card mb-4 sticky-lg-top" style="top: 100px;"> <%-- Làm cho cột này "dính" khi cuộn --%>
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h4 class="mb-0">Your Cart Summary</h4>
                                                    <span class="badge bg-light text-dark rounded-pill">${cartItems.size()} items</span>
                                                </div>
                                                <div class="card-body p-0" style="max-height: 300px; overflow-y: auto;"> <%-- Thêm cuộn nếu nhiều item --%>
                                                    <ul class="list-group list-group-flush">
                                                        <c:forEach var="item" items="${cartItems}">
                                                            <li class="list-group-item cart-item d-flex justify-content-between align-items-center">
                                                                <div class="d-flex align-items-center">
                                                                     <%-- Hiển thị ảnh nhỏ --%>
                                                                    <div class="me-3">
                                                                         <img src="${item.product.image}" alt="${item.product.name}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                                                    </div>
                                                                    <div>
                                                                        <h5 class="mb-1">${item.product.name}</h5>
                                                                        <p class="mb-0">
                                                                            <small class="text-muted">Qty: ${item.quantity} × <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true"/> VND</small>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <span class="price-badge badge rounded-pill">
                                                                    <fmt:formatNumber value="${item.product.price * item.quantity}" type="number" groupingUsed="true"/> VND
                                                                </span>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                                <%-- Phần tính tổng và voucher --%>
                                                <div class="card-body border-top">
                                                     <div class="d-flex justify-content-between mb-2">
                                                         <span>Subtotal</span>
                                                         <%-- Hiển thị tổng tiền ban đầu (total) --%>
                                                         <span><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> VND</span>
                                                     </div>
                                                     <div class="d-flex justify-content-between mb-2">
                                                         <span>Shipping Fee</span>
                                                         <span class="text-success">Free</span>
                                                     </div>
                                                     <div class="d-flex justify-content-between mb-2" id="discountRow" style="display: none;"> <%-- Ẩn ban đầu --%>
                                                         <span>Discount</span>
                                                         <span class="text-danger" id="discountAmount">- 0 VND</span>
                                                     </div>
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
                                                     <div class="d-flex justify-content-between fw-bold fs-5">
                                                         <span>Total Payment</span>
                                                         <%-- ID này sẽ được cập nhật bằng JS --%>
                                                         <span class="total-price" id="finalTotal"><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> VND</span>
                                                     </div>
                                                 </div>
                                            </div>
                                        </div>

                                        <%-- Cột thông tin giao hàng và thanh toán --%>
                                        <div class="col-lg-6 order-lg-1"> <%-- Đổi thứ tự cột trên màn hình lớn --%>
                                            <div class="card shipping-info-card">
                                                <div class="card-header">
                                                    <h4 class="mb-0">Shipping & Payment</h4>
                                                </div>
                                                <div class="card-body">
                                                    <form action="checkout" method="post">
                                                        <h5 class="mb-3">Shipping Address</h5>
                                                        <div class="mb-3 form-icon">
                                                            <i class="fas fa-user"></i>
                                                            <input type="text" class="form-control" id="fullName" name="fullname" value="${account.firstName} ${account.lastName}" placeholder="Full Name" required>
                                                        </div>

                                                        <div class="row g-3">
                                                            <div class="col-md-6 mb-3 form-icon">
                                                                <i class="fas fa-envelope"></i>
                                                                <input type="email" class="form-control" id="email" name="email" value="${account.email}" placeholder="Email Address" required>
                                                            </div>
                                                            <div class="col-md-6 mb-3 form-icon">
                                                                 <i class="fas fa-phone"></i>
                                                                <input type="tel" class="form-control" id="phone" name="phone" value="${account.phone}" placeholder="Phone Number" required pattern="[0-9]{10,11}" title="Please enter a valid phone number (10-11 digits)">
                                                            </div>
                                                        </div>

                                                        <div class="mb-4 form-icon">
                                                            <i class="fas fa-map-marker-alt"></i>
                                                            <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" placeholder="Street Address, City, Province" value="${account.address}" required>
                                                        </div>

                                                        <h5 class="mb-3">Payment Method</h5>
                                                        <div class="payment-methods">
                                                            <input type="radio" class="payment-method-option" id="cash" name="paymentMethod" value="cash" checked>
                                                            <label for="cash" class="payment-method-label">
                                                                <i class="fas fa-money-bill-wave payment-icon text-success"></i>
                                                                <span>Cash on Delivery (COD)</span>
                                                            </label>

                                                            <input type="radio" class="payment-method-option" id="banking" name="paymentMethod" value="banking">
                                                            <label for="banking" class="payment-method-label">
                                                                <i class="fas fa-credit-card payment-icon text-primary"></i>
                                                                 <span>VnPay Gateway</span> <%-- Đổi tên cho rõ ràng --%>
                                                            </label>
                                                        </div>

                                                        <button type="submit" class="btn btn-checkout w-100 mt-4">
                                                            <i class="fas fa-lock me-2"></i>
                                                            Place Order Now
                                                        </button>
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

        <script  src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <%-- Script xử lý voucher và ảnh lỗi (giữ nguyên và cải thiện) --%>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const applyVoucherBtn = document.getElementById("applyVoucher");
                const voucherInput = document.getElementById("voucherCode");
                const voucherMessage = document.getElementById("voucherMessage");
                const finalTotalElement = document.getElementById("finalTotal");
                const discountRow = document.getElementById("discountRow"); // Lấy dòng discount
                const discountAmountElement = document.getElementById("discountAmount"); // Lấy span hiển thị số tiền giảm

                // Lưu lại tổng tiền gốc ban đầu
                const originalTotalText = finalTotalElement.textContent;
                const originalTotal = parseFloat(originalTotalText.replace(/[^\d.-]/g, '')) || ${total}; // Lấy từ JSP hoặc tính toán nếu cần

                applyVoucherBtn.addEventListener("click", function () {
                    const voucherCode = voucherInput.value.trim();
                    voucherMessage.textContent = ""; // Xóa tin nhắn cũ
                    voucherMessage.className = 'text-muted'; // Reset class
                    discountRow.style.display = 'none'; // Ẩn dòng discount

                    if (voucherCode === "") {
                        voucherMessage.textContent = "Please enter a voucher code.";
                        voucherMessage.className = 'text-danger';
                        // Reset về tổng tiền gốc nếu xóa code
                        finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(originalTotal);
                        discountRow.style.display = 'none';
                        return;
                    }

                    // Hiển thị loading (tùy chọn)
                    voucherMessage.textContent = "Checking voucher...";
                    voucherMessage.className = 'text-info';
                    applyVoucherBtn.disabled = true; // Vô hiệu hóa nút khi đang check

                    const xhr = new XMLHttpRequest();
                    xhr.open("POST", "check-voucher", true);
                    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

                    xhr.onload = function () {
                         applyVoucherBtn.disabled = false; // Kích hoạt lại nút
                        if (xhr.status === 200) {
                            try {
                                const response = JSON.parse(xhr.responseText);
                                if (response.success) { // Kiểm tra trạng thái success tổng thể
                                    voucherMessage.textContent = response.message; // Hiển thị tin nhắn từ server
                                    if (response.voucherApplied) {
                                        voucherMessage.className = 'text-success';
                                        // Cập nhật tổng tiền cuối cùng
                                        finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(response.finalTotal);
                                         // Hiển thị dòng discount
                                         discountAmountElement.textContent = '- ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(response.discount);
                                         discountRow.style.display = 'flex'; // Hiện dòng giảm giá
                                    } else {
                                        voucherMessage.className = 'text-danger';
                                        // Nếu voucher không hợp lệ, quay về tổng tiền gốc
                                        finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(response.originalTotal); // Dùng originalTotal từ response
                                        discountRow.style.display = 'none'; // Ẩn dòng giảm giá
                                    }
                                } else {
                                    // Xử lý lỗi cụ thể từ server (ví dụ: chưa đăng nhập)
                                    voucherMessage.textContent = response.message || "Error processing voucher.";
                                    voucherMessage.className = 'text-danger';
                                     finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(originalTotal); // Reset về gốc
                                     discountRow.style.display = 'none';
                                    if(response.redirect) {
                                        window.location.href = response.redirect; // Chuyển hướng nếu cần
                                    }
                                }
                            } catch (error) {
                                voucherMessage.textContent = "Error parsing server response.";
                                voucherMessage.className = 'text-danger';
                                finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(originalTotal);
                                discountRow.style.display = 'none';
                                console.error("JSON Parse Error:", error);
                            }
                        } else {
                            voucherMessage.textContent = "Server error (" + xhr.status + "), please try again.";
                            voucherMessage.className = 'text-danger';
                            finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(originalTotal);
                            discountRow.style.display = 'none';
                        }
                    };

                    xhr.onerror = function() {
                         applyVoucherBtn.disabled = false; // Kích hoạt lại nút
                         voucherMessage.textContent = "Network error. Please check your connection.";
                         voucherMessage.className = 'text-danger';
                         finalTotalElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(originalTotal);
                         discountRow.style.display = 'none';
                    };

                    xhr.send("voucherCode=" + encodeURIComponent(voucherCode));
                });

                // Xử lý ảnh lỗi (giữ nguyên hoặc cải thiện)
                 applyFallbackToImages();
                 if (document.readyState === "complete" || document.readyState === "interactive") { applyFallbackToImages(); }
                 const observer = new MutationObserver(function (mutations) { mutations.forEach(function (mutation) { if (mutation.addedNodes && mutation.addedNodes.length > 0) { mutation.addedNodes.forEach(function (node) { if (node.nodeType === 1) { if (node.tagName === 'IMG') { applyFallbackToImage(node); } else { const imgElements = node.querySelectorAll('img'); imgElements.forEach(applyFallbackToImage); } } }); } }); });
                 observer.observe(document.documentElement, { childList: true, subtree: true });
                 function applyFallbackToImages() { const allImages = document.querySelectorAll('img'); allImages.forEach(applyFallbackToImage); }
                 function applyFallbackToImage(img) { if (!img.hasAttribute('data-fallback-applied')) { img.setAttribute('data-fallback-applied', 'true'); const originalSrc = img.src; if (img.complete && (typeof img.naturalWidth === "undefined" || img.naturalWidth === 0)) { if (originalSrc !== 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg') { img.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'; } } img.onerror = function () { if (this.src !== 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg') { this.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'; } }; } }

            });
        </script>
    </body>
</html>