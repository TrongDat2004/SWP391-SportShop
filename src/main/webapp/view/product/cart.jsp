<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <!-- head -->
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="CycleCity offers a wide range of bicycles, gear, and accessories for every type of cyclist. Explore our collection and gear up for your next adventure!">
        <meta name="keywords" content="bicycles, bikes, cycling gear, bike accessories, mountain bikes, road bikes, CycleCity">
        <meta name="author" content="CycleCity Team">

        <meta property="og:title" content="CycleCity | Quality Bicycles and Cycling Gear">
        <meta property="og:description" content="Discover the best selection of bicycles, gear, and accessories at CycleCity. Shop now for top brands and quality service.">
        <meta property="og:image" content="../assets/images/logo.png">
        <meta property="og:url" content="">
        <meta property="og:type" content="website">

        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="CycleCity | Quality Bicycles and Cycling Gear">
        <meta name="twitter:description" content="Explore the latest in bicycles, cycling gear, and accessories at CycleCity. Gear up for your next adventure!">
        <meta name="twitter:image" content="../assets/images/logo.png">
        <meta name="twitter:site" content="@CycleCity">

        <title>CycleCity | Your Hub for Quality Bicycles, Gear, and Accessories</title>
        <link rel="shortcut icon" href="assets/images/favicon.png" type="image/x-icon">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
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
        <!-- header -->
        <!-- mouse -->
        <div class="cursor"></div>
        <div class="cursor-follower"></div>


        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>
            <style>
                /* Style hiện đại cho giỏ hàng */
                .shopping-cart-section {
                    padding: 60px 0;
                    background-color: #f8f9fa;
                }

                .cart-container {
                    background-color: #fff;
                    border-radius: 20px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                    padding: 30px;
                    margin-bottom: 30px;
                }

                .cart-header {
                    border-bottom: 1px solid #eaeaea;
                    margin-bottom: 20px;
                    padding-bottom: 15px;
                }

                .cart-header h2 {
                    font-size: 24px;
                    color: #333;
                    font-weight: 700;
                    margin-bottom: 0;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .cart-header h2 i {
                    color: #3182ce;
                }

                .cart-empty {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    padding: 60px 20px;
                    text-align: center;
                }

                .cart-empty-icon {
                    font-size: 60px;
                    color: #cbd5e0;
                    margin-bottom: 20px;
                }

                .cart-empty-message {
                    font-size: 18px;
                    color: #64748b;
                    margin-bottom: 30px;
                }

                .continue-shopping-btn {
                    background: linear-gradient(45deg, #3182ce, #63b3ed);
                    color: white;
                    border: none;
                    padding: 12px 25px;
                    border-radius: 50px;
                    font-weight: 600;
                    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
                    transition: all 0.3s ease;
                    text-decoration: none;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                }

                .continue-shopping-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 15px rgba(49, 130, 206, 0.4);
                }

                .cart-table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0 15px;
                }

                .cart-table thead th {
                    background-color: #f8f9fa;
                    color: #4a5568;
                    font-weight: 600;
                    font-size: 14px;
                    padding: 15px;
                    text-align: left;
                    border: none;
                }

                .cart-table tbody tr {
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                    border-radius: 10px;
                    transition: all 0.3s ease;
                }

                .cart-table tbody tr:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                }

                .cart-table tbody td {
                    padding: 15px;
                    vertical-align: middle;
                    border-top: 1px solid #f1f1f1;
                    border-bottom: 1px solid #f1f1f1;
                }

                .cart-table tbody td:first-child {
                    border-left: 1px solid #f1f1f1;
                    border-top-left-radius: 10px;
                    border-bottom-left-radius: 10px;
                }

                .cart-table tbody td:last-child {
                    border-right: 1px solid #f1f1f1;
                    border-top-right-radius: 10px;
                    border-bottom-right-radius: 10px;
                }

                .product-image {
                    width: 80px;
                    height: 80px;
                    border-radius: 10px;
                    object-fit: cover;
                    border: 1px solid #f1f1f1;
                }

                .product-name {
                    font-weight: 600;
                    color: #1a202c;
                    text-decoration: none;
                    transition: color 0.2s;
                }

                .product-name:hover {
                    color: #3182ce;
                }

                .price-tag {
                    font-weight: 600;
                    color: #3182ce;
                }

                .quantity-control {
                    display: flex;
                    align-items: center;
                    max-width: 130px;
                }

                .quantity-btn {
                    width: 32px;
                    height: 32px;
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

                .quantity-input {
                    width: 45px;
                    height: 32px;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    text-align: center;
                    font-size: 14px;
                    font-weight: 500;
                    margin: 0 5px;
                }

                .update-btn {
                    padding: 6px 12px;
                    border-radius: 50px;
                    font-size: 12px;
                    font-weight: 500;
                    background-color: #3182ce;
                    color: white;
                    border: none;
                    margin-left: 5px;
                    transition: all 0.2s ease;
                }

                .update-btn:hover {
                    background-color: #2b6cb0;
                }

                .delete-btn {
                    padding: 6px 12px;
                    border-radius: 50px;
                    font-size: 12px;
                    font-weight: 500;
                    background-color: #e53e3e;
                    color: white;
                    border: none;
                    transition: all 0.2s ease;
                }

                .delete-btn:hover {
                    background-color: #c53030;
                }



                .cart-footer {
                    margin-top: 30px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                .clear-cart-btn {
                    background-color: transparent;
                    color: #e53e3e;
                    border: 1px solid #e53e3e;
                    padding: 12px 25px;
                    border-radius: 50px;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                }

                .clear-cart-btn:hover {
                    background-color: #e53e3e;
                    color: white;
                }
                .clear-cart-btn[href] {
                    background-color: #4299e1; /* Xanh dương */
                    color: white;
                    border: 1px solid #3182ce;
                }

                .clear-cart-btn[href]:hover {
                    background-color: #3182ce;
                }

                .cart-total {
                    background: linear-gradient(45deg, #f6f8fb, #f1f5f9);
                    padding: 20px;
                    border-radius: 15px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                }

                .total-row {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 10px;
                    padding-bottom: 10px;
                    border-bottom: 1px solid #eaeaea;
                }

                .total-row:last-child {
                    border-bottom: none;
                    padding-bottom: 0;
                    margin-bottom: 0;
                }

                .total-row .label {
                    font-weight: 500;
                    color: #64748b;
                }

                .total-row .value {
                    font-weight: 700;
                    color: #1a202c;
                }

                .total-row.grand-total {
                    margin-top: 10px;
                    padding-top: 10px;
                    border-top: 2px solid #eaeaea;
                    font-size: 18px;
                }

                .checkout-btn {
                    background: linear-gradient(45deg, #3182ce, #63b3ed);
                    color: white;
                    border: none;
                    padding: 15px 30px;
                    border-radius: 50px;
                    font-weight: 600;
                    box-shadow: 0 4px 15px rgba(49, 130, 206, 0.3);
                    transition: all 0.3s ease;
                    display: inline-flex;
                    align-items: center;
                    gap: 10px;
                    width: 100%;
                    justify-content: center;
                    margin-top: 20px;
                }

                .checkout-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(49, 130, 206, 0.4);
                }

                /* Responsive */
                @media (max-width: 768px) {
                    .cart-table thead {
                        display: none;
                    }

                    .cart-table tbody, .cart-table tbody tr, .cart-table tbody td {
                        display: block;
                        width: 100%;
                    }

                    .cart-table tbody tr {
                        margin-bottom: 20px;
                        padding: 10px;
                    }

                    .cart-table tbody td {
                        text-align: right;
                        padding: 10px;
                        position: relative;
                        padding-left: 50%;
                    }

                    .cart-table tbody td:before {
                        content: attr(data-label);
                        position: absolute;
                        left: 10px;
                        width: 45%;
                        font-weight: 600;
                        text-align: left;
                    }

                    .cart-table tbody td:first-child,
                    .cart-table tbody td:last-child {
                        border-radius: 0;
                    }

                    .quantity-control {
                        margin-left: auto;
                    }

                    .cart-footer {
                        flex-direction: column;
                    }

                    .clear-cart-btn,
                    .checkout-btn {
                        width: 100%;
                    }
                }
            </style>
            <main class="pt-12">
                <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                    <div class="container mt-10">
                        <div class="cart-container">
                            <div class="cart-header">
                                <h2><i class="fas fa-shopping-cart"></i> Your cart</h2>
                            </div>
                        <c:choose>
                            <c:when test="${empty cartItems}">
                                <div class="cart-empty">
                                    <div class="cart-empty-icon">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                    <p class="cart-empty-message">Your cart is empty</p>
                                    <a href="products" class="continue-shopping-btn">
                                        <i class="fas fa-arrow-left"></i> Continue Shopping
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="cart-table">
                                        <thead>
                                            <tr>
                                                <th width="5%">#</th>
                                                <th width="10%">Image</th>
                                                <th width="25%">Product</th>
                                                <th width="15%">Unit Price</th>
                                                <th width="20%">Quantity</th>
                                                <th width="15%">Total</th>
                                                <th width="10%">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="total" value="0" />
                                            <c:forEach var="item" items="${cartItems}" varStatus="loop">
                                                <c:set var="itemTotal" value="${item.quantity * item.product.price}" />
                                                <c:set var="total" value="${total + itemTotal}" />
                                                <tr>
                                                    <td data-label="#">${loop.index + 1}</td>
                                                    <td data-label="Image">
                                                        <img src="${item.product.image}" alt="${item.product.name}" class="product-image"
                                                             onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                                    </td>
                                                    <td data-label="Product">
                                                        <a href="product?id=${item.product.productId}" class="product-name">${item.product.name}</a>
                                                    </td>
                                                    <td data-label="Unit Price">
                                                        <span class="price-tag"><fmt:formatNumber value="${item.product.price}" type="number"
                                                                          groupingUsed="true" /> VNĐ</span>
                                                    </td>
                                                    <td data-label="Quantity">
                                                        <form action="cart" method="post" class="update-form">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                            <div class="quantity-control">
                                                                <button type="button" class="quantity-btn" onclick="decreaseQuantity(this)">-</button>
                                                                <input type="number" name="quantity" value="${item.quantity}" min="1"
                                                                       class="quantity-input" id="quantity-${item.cartItemId}">
                                                                <button type="button" class="quantity-btn" onclick="increaseQuantity(this)">+</button>
                                                                <button type="submit" class="update-btn">
                                                                    <i class="fas fa-sync-alt"></i>
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </td>
                                                    <td data-label="Total">
                                                        <span class="price-tag"><fmt:formatNumber value="${itemTotal}" type="number"
                                                                          groupingUsed="true" /> VNĐ</span>
                                                    </td>
                                                    <td data-label="Action">
                                                        <form action="cart" method="post" class="delete-form" onsubmit="return confirmDelete(event, this);">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                            <button type="submit" class="delete-btn">
                                                                <i class="fas fa-trash-alt"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="cart-footer">
                                    <form action="cart" method="post" onsubmit="return confirmClearCart(event, this);">
                                        <input type="hidden" name="action" value="clear">
                                        <button type="submit" class="clear-cart-btn">
                                            <i class="fas fa-trash-alt"></i> Clear Cart
                                        </button>
                                        <a href="products" class="clear-cart-btn">Continue Shopping</a>
                                    </form>

                                    <div class="cart-total">
                                        <div class="total-row">
                                            <span class="label">Total Products:</span>
                                            <span class="value">${cartItems.size()}</span>
                                        </div>
                                        <div class="total-row">
                                            <span class="label">Subtotal:</span>
                                            <span class="value"><fmt:formatNumber value="${total}" type="number"
                                                              groupingUsed="true" /> VNĐ</span>
                                        </div>
                                        <div class="total-row">
                                            <span class="label">Shipping Fee:</span>
                                            <span class="value">0 VNĐ</span>
                                        </div>
                                        <div class="total-row grand-total">
                                            <span class="label">Total Payment:</span>
                                            <span class="value"><fmt:formatNumber value="${total}" type="number"
                                                              groupingUsed="true" /> VNĐ</span>
                                        </div>

                                        <a href="checkout" class="checkout-btn">
                                            <i class="fas fa-check"></i> Proceed to Checkout
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>
            <!-- product section end -->

            <!-- gallery slider -->
            <!-- gallery slider start -->
            <div class="overflow-hidden position-relative z-0">
                <div class="swiper gallery-slider">
                    <div class="swiper-wrapper align-items-center z-1">
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-1.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-2.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-3.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-4.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-5.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-6.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-7.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-8.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide w-fit z-1">
                            <div class="gallery-item position-relative">
                                <img src="${pageContext.request.contextPath}/assets/images/gallery-9.png" alt="gallery logo">
                                <div class="overlay position-absolute top-0 start-0 w-100 h-100 d-center">
                                    <a href="#" class="icon-52px bg-n0 text-secondary2 text-xl hover-bg-primary2 hover-text-n0">
                                        <i class="ph ph-instagram-logo"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- gallery slider end -->

            <!-- call to action -->
            <!-- call to action section start -->
            <section class="call-to-action-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120 bg-n100">
                <div class="container-fluid">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="text-center mb-lg-8 mb-6">
                                <h2 class="text-animation-word display-four text-n0 text-uppercase mb-lg-5 mb-3">
                                    JOIN THE
                                    <span class="text-secondary2 text-decoration-underline">CYCLECITY</span>
                                    COMMUNITY
                                </h2>
                                <p class="text-sm text-n30 fw-normal ch-100 mx-auto">
                                    Stay updated with the latest in cycling. Sign up for our newsletter to receive exclusive
                                    offers, product updates, and tips straight to your inbox. Join our biking community
                                    today!
                                </p>
                            </div>
                            <form action="#" class="d-center flex-wrap flex-sm-nowrap cta-form mx-auto">
                                <input type="email" placeholder="Enter your email address" class="bg-transparent text-n0  py-lg-4 py-3 px-lg-6 px-4 border border-n20-1 focus-primary">
                                <button type="submit" class="text-n100 fw-medium text-capitalize bg-n0 font-instrument py-lg-4 py-3 px-lg-6 px-4 hover-text-n0 box-style box-primary2">Subscribe</button>
                            </form>
                        </div>
                    </div>
                </div>
            </section>
            <!-- call to action section end -->

        </main>
        <!-- main end -->

        <!-- footer section -->
        <!-- footer section start -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->
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
            <c:when test="${status == 'false' and type == 'empty_checkout'}">
                <c:set var="alertType" value="error" />
                <c:set var="alertMessage" value="Your cart is empty! Please add items before proceeding to checkout." />
            </c:when>
            <c:when test="${status == 'false' and type == 'order_fail'}">
                <c:set var="alertType" value="error" />
                <c:set var="alertMessage" value="Order failed! Some items may be out of stock. Please review your cart and try again." />
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