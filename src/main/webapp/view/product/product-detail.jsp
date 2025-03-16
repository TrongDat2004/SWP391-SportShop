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

        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>
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
                }

                .product-image img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                    transition: transform 0.5s ease;
                }

                .product-image:hover img {
                    transform: scale(1.05);
                }

                .product-info {
                    flex: 1;
                    padding: 40px;
                    position: relative;
                }

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
                }

                .product-info .stock {
                    font-size: 14px;
                    font-weight: 500;
                    color: #2ecc71;
                    margin-bottom: 30px;
                    display: flex;
                    align-items: center;
                }

                .product-info .stock:before {
                    content: '';
                    display: inline-block;
                    width: 10px;
                    height: 10px;
                    background-color: #2ecc71;
                    border-radius: 50%;
                    margin-right: 8px;
                }

                .product-info .stock.low {
                    color: #e67e22;
                }

                .product-info .stock.low:before {
                    background-color: #e67e22;
                }

                .product-info .stock.out {
                    color: #e74c3c;
                }

                .product-info .stock.out:before {
                    background-color: #e74c3c;
                }

                .product-form {
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
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
                    margin-top: 20px;
                    width: 100%;
                    max-width: 300px;
                }

                .add-to-cart-btn:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 8px 20px rgba(49, 130, 206, 0.4);
                }

                .add-to-cart-btn:active {
                    transform: translateY(0);
                }

                .add-to-cart-btn i {
                    font-size: 18px;
                }

                /* Responsive */
                @media (max-width: 992px) {
                    .product-detail-container {
                        flex-direction: column;
                    }

                    .product-image {
                        height: 400px;
                    }

                    .product-info {
                        padding: 30px;
                    }
                }

                @media (max-width: 576px) {
                    .product-image {
                        height: 300px;
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
                }
                .feedback-container {
                    background-color: #fff; /* var(--white) */
                    border-radius: 8px; /* var(--radius) */
                    padding: 30px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); /* var(--shadow) */
                }

                .feedback-container h3 {
                    font-size: 1.5rem;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                    border-bottom: 2px solid #f5f7fa; /* var(--light-gray) */
                }

                .feedback-item {
                    padding: 20px;
                    border-radius: 8px; /* var(--radius) */
                    background-color: #f5f7fa; /* var(--light-gray) */
                    margin-bottom: 20px;
                    transition: all 0.3s ease; /* var(--transition) */
                }

                .feedback-item:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); /* var(--shadow) */
                }

                .feedback-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 10px;
                }

                .feedback-header small {
                    color: #8d99ae; /* var(--dark-gray) */
                }

                .rating {
                    color: #ffb703; /* var(--warning) */
                    font-weight: 600;
                }

                .feedback-content {
                    color: #333; /* var(--text-color) */
                    line-height: 1.7;
                }
                .no-feedback {
                    text-align: center;
                    color: #8d99ae;
                    font-style: italic;
                    padding: 15px;
                }

            </style>
            <main class="pt-12">
            <c:set var="totalRating" value="0" />
            <c:set var="count" value="0" />

            <c:forEach var="fb" items="${feedbacks}">
                <c:set var="totalRating" value="${totalRating + fb.rating}" />
                <c:set var="count" value="${count + 1}" />
            </c:forEach>

            <c:set var="averageRating" value="${count > 0 ? totalRating / count : 0}" />
            <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                <!-- tab content 1 -->
                <div class="tab-content active" data-tab="all">
                    <div class="row g-0 mb-1">
                        <c:if test="${product != null}">
                            <div class="product-detail-container">
                                <div class="product-image">
                                    <img src="${product.image}" alt="${product.name}" id="productImage" onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                </div>
                                <div class="product-info">
                                    <h1>${product.name}</h1>
                                    <p class="price"><span>${product.price}</span> VND</p>
                                    <p class="description">${product.description}</p>

                                    <c:choose>
                                        <c:when test="${product.stock > 10}">
                                            <p class="stock">In stock (${product.stock} items)</p>
                                        </c:when>
                                        <c:when test="${product.stock > 0 && product.stock <= 10}">
                                            <p class="stock low">Low stock (${product.stock} items left)</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="stock out">Out of stock</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <form method="POST" action="cart" class="product-form">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" name="action" value="add">

                                        <div class="form-group">
                                            <label for="quantity">Quantity:</label>
                                            <div class="quantity-control">
                                                <button type="button" class="quantity-btn" onclick="decreaseQuantity()">-</button>
                                                <input type="number" name="quantity" id="quantity" min="1" max="${product.stock}" value="1" class="quantity-input">
                                                <button type="button" class="quantity-btn" onclick="increaseQuantity()">+</button>
                                            </div>
                                        </div>
                                        <div class="average-rating">
                                            <h3>Average Rating: <span>${averageRating}</span>/5 ⭐</h3>
                                        </div>
                                        <c:if test="${userRole != 'admin'}">
                                            <button type="submit" class="add-to-cart-btn" ${product.stock <= 0 ? 'disabled' : ''}>
                                                <i class="fas fa-shopping-cart"></i>
                                                Add to Cart
                                            </button>
                                        </c:if>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="feedback-container">
                    <h3>Customer Reviews: <span>${averageRating}</span>/5 ⭐</h3>
                    <c:choose>
                        <c:when test="${empty feedbacks}">
                            <p class="no-feedback">No reviews yet. Be the first to review this product!</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="fb" items="${feedbacks}">
                                <div class="feedback-item">
                                    <div class="feedback-header">
                                        <p><strong>${fb.user.username}</strong> <small>Posted on: ${fb.createdAt}</small></p>
                                        <p class="rating">⭐ ${fb.rating}/5</p>
                                    </div>
                                    <p class="feedback-content">${fb.content}</p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </section>
        </main>
        <!-- main end -->

        <!-- footer section -->
        <!-- footer section start -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->
            <script  src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>
                                                    document.addEventListener("DOMContentLoaded", function () {
                                                        const productImage = document.getElementById('productImage');
                                                        if (productImage) {
                                                            productImage.addEventListener('error', function () {
                                                                this.src = 'https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg';
                                                            });
                                                        }
                                                    });

                                                    function increaseQuantity() {
                                                        const quantityInput = document.getElementById('quantity');
                                                        const maxQuantity = parseInt(quantityInput.getAttribute('max'));
                                                        const currentValue = parseInt(quantityInput.value);

                                                        if (currentValue < maxQuantity) {
                                                            quantityInput.value = currentValue + 1;
                                                        }
                                                    }

                                                    function decreaseQuantity() {
                                                        const quantityInput = document.getElementById('quantity');
                                                        const currentValue = parseInt(quantityInput.value);

                                                        if (currentValue > 1) {
                                                            quantityInput.value = currentValue - 1;
                                                        }
                                                    }
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
    </body>

</html>