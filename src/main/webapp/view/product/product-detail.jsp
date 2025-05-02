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
        <title>SportShop | ${product.name}</title> <%-- Thêm tên sản phẩm vào title --%>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            /* Style hiện đại cho trang chi tiết sản phẩm */
            .product-detail-container {
                display: flex;
                flex-direction: row;
                background-color: #fff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                margin: 40px 0;
                max-width: 1200px;
                margin-left: auto;
                margin-right: auto;
            }
            .product-image {
                flex: 1;
                position: relative;
                background: linear-gradient(135deg, #f5f7fa 0%, #e9ecef 100%);
                overflow: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 400px; /* Đảm bảo có chiều cao tối thiểu */
            }
            .product-image img {
                width: 100%;
                height: auto;
                max-height: 500px; /* Giới hạn chiều cao ảnh */
                object-fit: contain;
                transition: transform 0.5s ease;
                padding: 20px; /* Thêm padding */
            }
            .product-image:hover img {
                transform: scale(1.05);
            }
            .product-info {
                flex: 1;
                padding: 40px;
                position: relative;
                display: flex;
                flex-direction: column;
            } /* Flex column */
            .product-info h1 {
                font-size: 28px;
                font-weight: 700;
                color: #333;
                margin-bottom: 20px;
                line-height: 1.3;
            }
            .product-info .price {
                font-size: 24px;
                font-weight: 700;
                color: #3182ce;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            .product-info .description {
                font-size: 16px;
                line-height: 1.7;
                color: #666;
                margin-bottom: 30px;
                flex-grow: 1; /* Cho description chiếm không gian còn lại */
            }

            /* --- Size Selection Styles --- */
            .size-options {
                margin-bottom: 30px;
            }
            .size-options label {
                font-size: 14px;
                font-weight: 600;
                color: #555;
                display: block;
                margin-bottom: 10px;
            }
            .size-buttons {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }
            .size-button {
                display: inline-block;
                padding: 8px 15px;
                border: 1px solid #e2e8f0;
                border-radius: 20px;
                cursor: pointer;
                transition: all 0.2s ease;
                font-size: 14px;
                background-color: #fff;
                color: #333;
                position: relative;
            }
            .size-button input[type="radio"] {
                position: absolute;
                opacity: 0;
                width: 0;
                height: 0;
            }
            .size-button.selected {
                border-color: #3182ce;
                background-color: #ebf8ff; /* Light blue background */
                color: #2c5282; /* Darker blue text */
                font-weight: 600;
            }
            .size-button.disabled {
                cursor: not-allowed;
                background-color: #f1f3f5;
                color: #adb5bd;
                border-color: #e9ecef;
                text-decoration: line-through; /* Gạch ngang size hết hàng */
            }
            .size-button:not(.disabled):hover {
                border-color: #63b3ed;
            }

            .stock-display { /* Phần hiển thị stock */
                font-size: 14px;
                font-weight: 500;
                color: #2ecc71; /* Mặc định là xanh lá */
                margin-top: 10px; /* Khoảng cách với size */
                margin-bottom: 20px; /* Khoảng cách với quantity */
                min-height: 20px; /* Đảm bảo có không gian dù trống */
                display: flex;
                align-items: center;
            }
            .stock-display::before { /* Chấm tròn màu */
                content: '';
                display: inline-block;
                width: 10px;
                height: 10px;
                background-color: #2ecc71; /* Mặc định xanh */
                border-radius: 50%;
                margin-right: 8px;
                transition: background-color 0.3s ease; /* Hiệu ứng chuyển màu */
            }
            .stock-display.low {
                color: #e67e22;
            }
            .stock-display.low::before {
                background-color: #e67e22;
            }
            .stock-display.out {
                color: #e74c3c;
            }
            .stock-display.out::before {
                background-color: #e74c3c;
            }
            .stock-display.hidden {
                display: none;
            } /* Ẩn đi khi chưa chọn size */


            .product-form {
                display: flex;
                flex-direction: column;
                gap: 20px;
                margin-top: auto; /* Đẩy form xuống dưới */
            }
            .form-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .form-group label {
                font-size: 14px;
                font-weight: 600;
                color: #555;
            }
            .quantity-control {
                display: flex;
                align-items: center;
                gap: 10px;
                width: 140px;
            }
            .quantity-btn {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #f1f3f5;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 16px;
                color: #333;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .quantity-btn:hover {
                background-color: #e9ecef;
            }
            .quantity-btn:disabled {
                background-color: #e9ecef;
                color: #adb5bd;
                cursor: not-allowed;
            } /* Disabled style */
            .quantity-input {
                width: 60px;
                height: 36px;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                text-align: center;
                font-size: 14px;
                font-weight: 600;
            }
            .add-to-cart-btn {
                background: linear-gradient(45deg, #3182ce, #63b3ed);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 50px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                box-shadow: 0 4px 15px rgba(49, 130, 206, 0.3);
                margin-top: 10px; /* Giảm margin */
                width: 100%;
                max-width: 300px;
            }
            .add-to-cart-btn:hover:not(:disabled) {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(49, 130, 206, 0.4);
            }
            .add-to-cart-btn:active:not(:disabled) {
                transform: translateY(0);
            }
            .add-to-cart-btn:disabled {
                background: #bdc3c7;
                cursor: not-allowed;
                box-shadow: none;
            }
            .add-to-cart-btn i {
                font-size: 18px;
            }

            /* Feedback Styles (Giữ nguyên) */
            .feedback-container {
                background-color: #fff;
                border-radius: 8px;
                padding: 30px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                margin-top: 40px;
            } /* Thêm margin-top */
            .feedback-container h3 {
                font-size: 1.5rem;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #f5f7fa;
            }
            .feedback-item {
                padding: 20px;
                border-radius: 8px;
                background-color: #f5f7fa;
                margin-bottom: 20px;
                transition: all 0.3s ease;
            }
            .feedback-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            }
            .feedback-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                flex-wrap: wrap; /* Cho phép xuống dòng */
                gap: 5px;
            }
            .feedback-header strong {
                color: #333;
            }
            .feedback-header small {
                color: #8d99ae;
                font-size: 0.85em;
            }
            .rating {
                color: #ffb703;
                font-weight: 600;
            }
            .feedback-content {
                color: #555;
                line-height: 1.7;
            }
            .no-feedback {
                text-align: center;
                color: #8d99ae;
                font-style: italic;
                padding: 15px;
            }
            .average-rating {
                margin-bottom: 20px;
                font-size: 1.1rem;
                color: #555;
            }
            .average-rating span {
                font-weight: bold;
                color: #333;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .product-detail-container {
                    flex-direction: column;
                }
                .product-image {
                    height: auto;
                    min-height: 300px; /* Giảm chiều cao min */
                }
                .product-info {
                    padding: 30px;
                }
            }
            @media (max-width: 576px) {
                .product-image {
                    min-height: 250px;
                }
                .product-info {
                    padding: 20px;
                }
                .product-info h1 {
                    font-size: 24px;
                }
                .product-info .price {
                    font-size: 20px;
                }
                .add-to-cart-btn {
                    max-width: 100%;
                }
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
            <c:set var="totalRating" value="0" />
            <c:set var="count" value="0" />
            <c:if test="${not empty feedbacks}">
                <c:forEach var="fb" items="${feedbacks}">
                    <c:set var="totalRating" value="${totalRating + fb.rating}" />
                    <c:set var="count" value="${count + 1}" />
                </c:forEach>
            </c:if>
            <c:set var="averageRating" value="${count > 0 ? totalRating / count : 0}" />
            <fmt:formatNumber var="formattedAvgRating" value="${averageRating}" maxFractionDigits="1" />

            <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                <div class="tab-content active" data-tab="all">
                    <div class="row g-0 mb-1">
                        <c:if test="${product != null}">
                            <div class="product-detail-container">
                                <div class="product-image">
                                    <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.name}" id="productImage" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                </div>
                                <div class="product-info">
                                    <h1>${product.name}</h1>
                                    <p class="price"><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" /> VND</p>
                                    <p class="description">${product.description}</p>

                                    <%-- Phần hiển thị rating trung bình --%>
                                    <div class="average-rating">
                                        Average Rating: <span>${formattedAvgRating}</span>/5 ⭐ (${count} reviews)
                                    </div>

                                    <%-- Form thêm vào giỏ hàng --%>
                                    <form method="POST" action="cart" class="product-form" id="addToCartForm">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productSizeId" id="selectedProductSizeId" value=""> <%-- Input ẩn để lưu size ID --%>

                                        <%-- Phần chọn size (Chỉ hiển thị nếu có nhiều hơn 1 size hoặc size không phải "One Size") --%>
                                        <c:if test="${not empty sizes && (sizes.size() > 1 || (sizes.size() == 1 && sizes[0].size != 'One Size' && sizes[0].size != 'N/A'))}">
                                            <div class="size-options">
                                                <label>Select Size:</label>
                                                <div class="size-buttons">
                                                    <c:forEach var="ps" items="${sizes}" varStatus="loop">
                                                        <label class="size-button ${ps.stock <= 0 ? 'disabled' : ''}"
                                                               data-stock="${ps.stock}"
                                                               data-size-id="${ps.productSizeId}"
                                                               id="label-size-${ps.productSizeId}">
                                                            <input type="radio" name="productSizeOption" value="${ps.productSizeId}"
                                                                   ${ps.stock <= 0 ? 'disabled' : ''}
                                                                   onclick="selectSize(this)">
                                                            ${ps.size}
                                                        </label>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>

                                        <%-- Phần hiển thị stock (sẽ cập nhật bằng JS) --%>
                                        <div class="stock-display hidden" id="stockDisplay">
                                            {Stock Status}
                                        </div>

                                        <%-- Phần chọn số lượng (Chỉ hiển thị khi là user) --%>
                                        <c:if test="${userRole != 'admin'}">
                                            <div class="form-group">
                                                <label for="quantity">Quantity:</label>
                                                <div class="quantity-control">
                                                    <button type="button" class="quantity-btn" id="decreaseBtn" onclick="decreaseQuantity()" disabled>-</button>
                                                    <input type="number" name="quantity" id="quantity" min="1" max="1" value="1" class="quantity-input" onchange="validateQuantity()" disabled>
                                                    <button type="button" class="quantity-btn" id="increaseBtn" onclick="increaseQuantity()" disabled>+</button>
                                                </div>
                                            </div>
                                        </c:if>

                                        <%-- Nút Add to Cart (Chỉ hiển thị khi là user) --%>
                                        <c:if test="${userRole != 'admin'}">
                                            <button type="submit" class="add-to-cart-btn" id="addToCartBtn" disabled>
                                                <i class="fas fa-shopping-cart"></i>
                                                Add to Cart
                                            </button>
                                            <p id="error-message" style="color: red; text-align: center; margin-top: 10px;"></p>
                                        </c:if>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${product == null}">
                            <div class="col-12 text-center my-5">
                                <p class="text-danger fs-4">Product not found or unavailable.</p>
                                <a href="products" class="btn btn-primary">Back to Products</a>
                            </div>
                        </c:if>
                    </div>
                </div>

                <%-- Feedback Section --%>
                <c:if test="${product != null}">
                    <div class="feedback-container">
                        <h3>Customer Reviews (${count})</h3>
                        <c:choose>
                            <c:when test="${empty feedbacks}">
                                <p class="no-feedback">No reviews yet. Be the first to review this product!</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="fb" items="${feedbacks}">
                                    <div class="feedback-item">
                                        <div class="feedback-header">
                                            <div>
                                                <strong>${fb.user.username}</strong>
                                                <br><small>Posted on: <fmt:formatDate value="${fb.createdAt}" pattern="yyyy-MM-dd HH:mm" /></small>
                                            </div>
                                            <p class="rating">⭐ ${fb.rating}/5</p>
                                        </div>
                                        <p class="feedback-content">${fb.content}</p>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </section>
        </main>
        <!-- main end -->

        <!-- footer section -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->

            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>
                                                        // --- DOM Element References ---
                                                        const quantityInput = document.getElementById('quantity');
                                                        const decreaseBtn = document.getElementById('decreaseBtn');
                                                        const increaseBtn = document.getElementById('increaseBtn');
                                                        const addToCartBtn = document.getElementById('addToCartBtn');
                                                        const selectedProductSizeIdInput = document.getElementById('selectedProductSizeId');
                                                        const stockDisplay = document.getElementById('stockDisplay');
                                                        const errorMessage = document.getElementById('error-message');
                                                        const sizeButtonsContainer = document.querySelector('.size-buttons');
                                                        const addToCartForm = document.getElementById('addToCartForm');

                                                        // --- Global State Variables ---
                                                        let selectedSizeId = null;
                                                        let currentStock = 0; // Stock for the currently selected size (or the single size)
                                                        let needsSizeSelection = false;

                                                        // --- Helper Functions ---

                                                        function updateStockDisplay(stock) {
                                                            console.log("[updateStockDisplay] Input stock:", stock, typeof stock);
                                                            if (!stockDisplay) {
                                                                console.error("[updateStockDisplay] stockDisplay element not found!");
                                                                return;
                                                            }

                                                            stockDisplay.classList.remove('hidden', 'low', 'out', 'unavailable'); // Reset classes
                                                            stockDisplay.textContent = ''; // Clear nội dung cũ

                                                            // Check for null/undefined FIRST
                                                            if (stock === null || stock === undefined) {
                                                                console.error("[updateStockDisplay] Stock is null or undefined");
                                                                stockDisplay.textContent = 'Stock info unavailable';
                                                                stockDisplay.classList.add('unavailable', 'out');
                                                                stockDisplay.classList.remove('hidden');
                                                                return;
                                                            }

                                                            let parsedStock = parseInt(stock);

                                                            if (isNaN(parsedStock)) {
                                                                console.error("[updateStockDisplay] Stock is NaN after parse. Original:", stock);
                                                                stockDisplay.textContent = 'Stock info error';
                                                                stockDisplay.classList.add('unavailable', 'out');
                                                                stockDisplay.classList.remove('hidden');
                                                                return;
                                                            }

                                                            stock = parsedStock; // Use the parsed number

                                                            // Use simple string concatenation for reliability
                                                            if (stock > 10) {
                                                                stockDisplay.textContent = 'In stock (' + stock + ' items)';
                                                            } else if (stock > 0) {
                                                                stockDisplay.textContent = 'Low stock (' + stock + ' items left)';
                                                                stockDisplay.classList.add('low');
                                                            } else {
                                                                stockDisplay.textContent = 'Out of stock';
                                                                stockDisplay.classList.add('out');
                                                            }
                                                            stockDisplay.classList.remove('hidden'); // Show the display
                                                            console.log("[updateStockDisplay] Display set to:", stockDisplay.textContent);
                                                        }


                                                        function updateQuantityControls(maxStock) {
                                                            console.log("[updateQuantityControls] Setting max:", maxStock);
                                                            if (quantityInput) {
                                                                let currentVal = parseInt(quantityInput.value) || 0; // Get current value or default to 0

                                                                // Ensure maxStock is a valid number, default to 0 if not
                                                                maxStock = parseInt(maxStock);
                                                                if (isNaN(maxStock) || maxStock < 0) {
                                                                    console.warn("[updateQuantityControls] Invalid maxStock provided, defaulting to 0:", maxStock)
                                                                    maxStock = 0;
                                                                }

                                                                quantityInput.max = maxStock; // Set the max attribute
                                                                quantityInput.disabled = (maxStock <= 0); // Disable input if no stock

                                                                // Adjust current value based on the new maxStock
                                                                if (maxStock <= 0) {
                                                                    quantityInput.value = 0; // Set quantity to 0 if out of stock
                                                                } else {
                                                                    // If current value is invalid or exceeds new max, reset to 1
                                                                    if (currentVal <= 0 || currentVal > maxStock) {
                                                                        quantityInput.value = 1;
                                                                    }
                                                                    // If current value is valid and within new max, keep it (or reset to 1 if it was 0)
                                                                    else if (currentVal === 0) { // If it was 0 before, set to 1 now that there's stock
                                                                        quantityInput.value = 1;
                                                                    }
                                                                }
                                                                updateQuantityButtonStates(); // Update +/- buttons state AFTER setting value and max
                                                            } else {
                                                                console.error("[updateQuantityControls] quantityInput element not found!");
                                                            }
                                                        }

                                                        function updateQuantityButtonStates() {
                                                            if (!quantityInput || !decreaseBtn || !increaseBtn) {
                                                                // console.warn("[updateQuantityButtonStates] Quantity control elements not found.");
                                                                return; // Exit if elements aren't ready/found
                                                            }
                                                            const currentVal = parseInt(quantityInput.value) || 0;
                                                            const maxVal = parseInt(quantityInput.max) || 0;
                                                            const isDisabled = quantityInput.disabled; // Check if the input itself is disabled

                                                            console.log("[updateQuantityButtonStates] Val:", currentVal, "Max:", maxVal, "Input Disabled:", isDisabled);

                                                            decreaseBtn.disabled = (currentVal <= 1 || isDisabled); // Disable if value is 1 or less, OR if input is disabled
                                                            increaseBtn.disabled = (currentVal >= maxVal || isDisabled); // Disable if value >= max, OR if input is disabled
                                                        }


                                                        function enableAddToCartButton() {
                                                            console.log("[enableAddToCartButton] Enabling");
                                                            if (addToCartBtn) {
                                                                addToCartBtn.disabled = false;
                                                                addToCartBtn.innerHTML = '<i class="fas fa-shopping-cart"></i> Add to Cart';
                                                            }
                                                            if (errorMessage)
                                                                errorMessage.textContent = '';
                                                        }

                                                        function disableAddToCartButton(message = 'Select Size') {
                                                            console.log("[disableAddToCartButton] Disabling with message:", message);
                                                            if (addToCartBtn) {
                                                                addToCartBtn.disabled = true;
                                                                if (message === 'Out of Stock') {
                                                                    addToCartBtn.innerHTML = '<i class="fas fa-times-circle"></i> Out of Stock';
                                                                } else {
                                                                    addToCartBtn.innerHTML = `<i class="fas fa-hand-pointer"></i> ${message}`;
                                                                }
                                                        }
                                                        }

                                                        function selectSize(radio) {
                                                            console.log("[selectSize] Radio changed, value:", radio.value);
                                                            if (sizeButtonsContainer) {
                                                                sizeButtonsContainer.querySelectorAll('.size-button').forEach(btn => btn.classList.remove('selected'));
                                                            }

                                                            const label = radio.closest('.size-button');
                                                            if (!label) {
                                                                console.error("[selectSize] Cannot find label");
                                                                return;
                                                            }

                                                            if (radio.checked && !label.classList.contains('disabled')) {
                                                                console.log("[selectSize] Size selected:", label.textContent.trim());
                                                                label.classList.add('selected');
                                                                selectedSizeId = parseInt(radio.value);
                                                                let stockAttr = label.getAttribute('data-stock');
                                                                currentStock = parseInt(stockAttr); // Update global stock

                                                                console.log("[selectSize] Selected Size ID:", selectedSizeId, "Stock:", currentStock);

                                                                if (isNaN(selectedSizeId)) {
                                                                    console.error("[selectSize] Invalid ID");
                                                                    selectedSizeId = null;
                                                                    currentStock = 0;
                                                                }
                                                                if (isNaN(currentStock)) {
                                                                    console.error("[selectSize] Invalid Stock");
                                                                    currentStock = 0;
                                                                }

                                                                if (selectedProductSizeIdInput) {
                                                                    selectedProductSizeIdInput.value = selectedSizeId ?? '';
                                                                }

                                                                updateStockDisplay(currentStock);
                                                                updateQuantityControls(currentStock); // <<< Update controls based on selected size's stock

                                                                if (currentStock > 0 && selectedSizeId !== null) {
                                                                    enableAddToCartButton();
                                                                    if (quantityInput)
                                                                        quantityInput.value = 1; // Reset quantity
                                                                } else {
                                                                    disableAddToCartButton(currentStock <= 0 ? 'Out of Stock' : 'Select Size');
                                                                    if (quantityInput)
                                                                        quantityInput.value = 0; // Reset quantity to 0 if out of stock
                                                                }
                                                                updateQuantityButtonStates(); // Ensure buttons are updated after potential quantity reset

                                                            } else {
                                                                console.log("[selectSize] Deselected or disabled.");
                                                                selectedSizeId = null;
                                                                currentStock = 0;
                                                                if (selectedProductSizeIdInput)
                                                                    selectedProductSizeIdInput.value = '';
                                                                if (stockDisplay)
                                                                    stockDisplay.classList.add('hidden');
                                                                updateQuantityControls(0); // Disable controls
                                                                const anySizeAvailable = sizeButtonsContainer && sizeButtonsContainer.querySelector('.size-button:not(.disabled)') !== null;
                                                                disableAddToCartButton(anySizeAvailable ? 'Select Size' : 'Out of Stock');
                                                                if (quantityInput)
                                                                    quantityInput.value = 1; // Reset quantity visually
                                                                updateQuantityButtonStates();
                                                            }
                                                        }

                                                        function increaseQuantity() {
                                                            if (!quantityInput || quantityInput.disabled)
                                                                return;
                                                            const maxQuantity = parseInt(quantityInput.max) || 0;
                                                            let currentValue = parseInt(quantityInput.value) || 0;
                                                            // Only increase if current value is less than max
                                                            if (maxQuantity > 0 && currentValue < maxQuantity) {
                                                                quantityInput.value = currentValue + 1;
                                                                updateQuantityButtonStates();
                                                            }
                                                            console.log("[increaseQuantity] New value:", quantityInput.value);
                                                        }

                                                        function decreaseQuantity() {
                                                            if (!quantityInput || quantityInput.disabled)
                                                                return;
                                                            let currentValue = parseInt(quantityInput.value) || 0;
                                                            if (currentValue > 1) { // Can only decrease if greater than 1
                                                                quantityInput.value = currentValue - 1;
                                                                updateQuantityButtonStates();
                                                            }
                                                            console.log("[decreaseQuantity] New value:", quantityInput.value);
                                                        }


                                                        // --- Logic chính khi trang tải xong ---
                                                        document.addEventListener("DOMContentLoaded", function () {
                                                            console.log("[DOMContentLoaded] Initializing...");
                                                            // Add null checks for essential elements
                                                            if (!quantityInput || !decreaseBtn || !increaseBtn || !addToCartBtn || !selectedProductSizeIdInput || !stockDisplay || !addToCartForm) {
                                                                console.error("[DOMContentLoaded] One or more essential page elements are missing!");
                                                                // Optionally display an error to the user
                                                                if (errorMessage)
                                                                    errorMessage.textContent = "Page error. Please try refreshing.";
                                                                return; // Stop initialization if elements are missing
                                                            }

                                                            applyFallbackToImages();

                                                            const sizesData = [];
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <%-- Ensure fn functions are available --%>
            <c:if test="${not empty sizes}">
                <c:forEach var="ps" items="${sizes}">
                                                            sizesData.push({
                                                                id: parseInt('${ps.productSizeId}'),
                                                                name: '<c:out value="${ps.size}" />', // Use c:out for safety
                                                                stock: parseInt('${ps.stock}')
                                                            });
                </c:forEach>
            </c:if>
                                                            console.log("[DOMContentLoaded] Sizes data:", JSON.stringify(sizesData));

                                                            const hasOnlyOneSize = sizesData.length === 1;
                                                            const isOneSizeOrNA = hasOnlyOneSize && (!sizesData[0].name || sizesData[0].name.trim() === 'One Size' || sizesData[0].name.trim() === 'N/A');
                                                            needsSizeSelection = sizesData.length > 1 || (hasOnlyOneSize && !isOneSizeOrNA);
                                                            console.log("[DOMContentLoaded] Needs Size Selection:", needsSizeSelection);

                                                            if (!needsSizeSelection) {
                                                                console.log("[DOMContentLoaded] Handling non-selectable size.");
                                                                if (hasOnlyOneSize) {
                                                                    const singleSize = sizesData[0];
                                                                    console.log("[DOMContentLoaded] Single size data:", singleSize);
                                                                    selectedSizeId = singleSize.id;
                                                                    currentStock = singleSize.stock; // Set global currentStock

                                                                    if (isNaN(selectedSizeId) || selectedSizeId <= 0) { // More robust ID check
                                                                        console.error("[DOMContentLoaded] Invalid ID for single size:", singleSize.id);
                                                                        selectedSizeId = null;
                                                                        currentStock = 0;
                                                                    }
                                                                    if (isNaN(currentStock) || currentStock < 0) { // Stock cannot be negative
                                                                        console.error("[DOMContentLoaded] Invalid stock for single size:", singleSize.stock);
                                                                        currentStock = 0;
                                                                    }

                                                                    if (selectedProductSizeIdInput && selectedSizeId !== null) {
                                                                        selectedProductSizeIdInput.value = selectedSizeId;
                                                                    }

                                                                    updateStockDisplay(currentStock);       // <-- Update stock display
                                                                    updateQuantityControls(currentStock);   // <-- Update quantity input/max
                                                                    // updateQuantityButtonStates() is called inside updateQuantityControls

                                                                    if (currentStock > 0 && selectedSizeId !== null) {
                                                                        enableAddToCartButton();
                                                                        // Quantity input value is set inside updateQuantityControls
                                                                    } else {
                                                                        disableAddToCartButton('Out of Stock');
                                                                        // Quantity input value is set inside updateQuantityControls
                                                                    }

                                                                } else { // No sizes
                                                                    console.warn("[DOMContentLoaded] No sizes defined.");
                                                                    updateStockDisplay(0);
                                                                    updateQuantityControls(0); // Set max=0, disable input, set value=0
                                                                    disableAddToCartButton('Out of Stock');
                                                                }
                                                            } else { // Needs selection
                                                                console.log("[DOMContentLoaded] Requires size selection.");
                                                                if (stockDisplay)
                                                                    stockDisplay.classList.add('hidden');
                                                                updateQuantityControls(0); // Disable controls initially
                                                                disableAddToCartButton('Select Size');
                                                                if (quantityInput)
                                                                    quantityInput.value = 1; // Reset visual quantity
                                                                updateQuantityButtonStates(); // Ensure buttons disabled
                                                            }

                                                            // --- Form Submit Listener ---
                                                            if (addToCartForm) {
                                                                addToCartForm.addEventListener('submit', function (event) {
                                                                    console.log("[Form Submit] Validating...");
                                                                    if (errorMessage)
                                                                        errorMessage.textContent = '';
                                                                    let isValid = true;
                                                                    const quantityValue = quantityInput ? parseInt(quantityInput.value) : 0;

                                                                    // 1. Check size if needed
                                                                    if (needsSizeSelection && (!selectedSizeId || selectedSizeId <= 0)) {
                                                                        if (errorMessage)
                                                                            errorMessage.textContent = 'Please select a valid size.';
                                                                        console.log("[Form Submit] Fail: Size not selected.");
                                                                        isValid = false;
                                                                    }
                                                                    // 2. Check quantity value (must be > 0 unless stock is 0)
                                                                    else if (!quantityInput || isNaN(quantityValue) || quantityValue <= 0) {
                                                                        // Allow quantity 0 only if stock is 0
                                                                        if (currentStock > 0) {
                                                                            if (errorMessage)
                                                                                errorMessage.textContent = 'Please enter a valid quantity.';
                                                                            console.log("[Form Submit] Fail: Invalid quantity value (<= 0 but stock > 0).");
                                                                            isValid = false;
                                                                        } else {
                                                                            // If stock is 0, quantity 0 might be acceptable depending on logic, but usually indicates an issue.
                                                                            // Still prevent adding to cart if stock is 0.
                                                                            if (errorMessage)
                                                                                errorMessage.textContent = 'This item is out of stock.';
                                                                            console.log("[Form Submit] Fail: Out of stock (currentStock <= 0).");
                                                                            isValid = false;
                                                                        }
                                                                    }
                                                                    // 3. Check if quantity exceeds stock
                                                                    else if (quantityValue > currentStock) {
                                                                        if (errorMessage)
                                                                            errorMessage.textContent = `Only ${currentStock} items available.`;
                                                                        console.log("[Form Submit] Fail: Quantity exceeds stock.");
                                                                        isValid = false;
                                                                    }
                                                                    // 4. Double check stock just before submit (belt and suspenders)
                                                                    else if (currentStock <= 0) {
                                                                        if (errorMessage)
                                                                            errorMessage.textContent = 'This item is out of stock.';
                                                                        console.log("[Form Submit] Fail: Out of stock (checked again).");
                                                                        isValid = false;
                                                                    }


                                                                    if (!isValid) {
                                                                        console.log("[Form Submit] Validation failed. Preventing submission.");
                                                                        event.preventDefault();
                                                                    } else {
                                                                        console.log("[Form Submit] Validation passed. Submitting...");
                                                                        if (addToCartBtn) {
                                                                            addToCartBtn.disabled = true;
                                                                            addToCartBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adding...';
                                                                        }
                                                                    }
                                                                });
                                                            }

                                                            // Add listener for manual quantity input changes
                                                            if (quantityInput) {
                                                                quantityInput.addEventListener('change', updateQuantityButtonStates);
                                                                quantityInput.addEventListener('input', updateQuantityButtonStates); // Also trigger on input for immediate feedback
                                                            }

                                                        }); // End DOMContentLoaded

                                                        // --- Image Fallback Logic ---
                                                        function applyFallbackToImages() {
                                                            const allImages = document.querySelectorAll('img');
                                                            allImages.forEach(applyFallbackToImage);
                                                        }
                                                        function applyFallbackToImage(img) {
                                                            if (!img.hasAttribute('data-fallback-applied')) {
                                                                img.setAttribute('data-fallback-applied', 'true');
                                                                const originalSrc = img.src;
                                                                // Check immediately if broken (might be cached as broken)
                                                                if (img.complete && (typeof img.naturalWidth === "undefined" || img.naturalWidth === 0)) {
                                                                    if (originalSrc !== '${pageContext.request.contextPath}/assets/images/default.jpg') { // Use context path
                                                                        console.log("Applying fallback to already broken image:", originalSrc);
                                                                        img.src = '${pageContext.request.contextPath}/assets/images/default.jpg';
                                                                    }
                                                                }
                                                                // Attach onerror handler
                                                                img.onerror = function () {
                                                                    if (this.src !== '${pageContext.request.contextPath}/assets/images/default.jpg') { // Prevent infinite loop
                                                                        console.log("Applying fallback due to error on:", originalSrc);
                                                                        this.src = '${pageContext.request.contextPath}/assets/images/default.jpg';
                                                                    }
                                                                };
                                                            }
                                                        }

        </script>
    </body>
</html>