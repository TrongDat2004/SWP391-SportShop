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
                /* Style hiện đại cho khu vực tìm kiếm và lọc */
                .product-filter-container {
                    background-color: #f8f9fa;
                    border-radius: 16px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    padding: 24px;
                    margin-bottom: 32px;
                }

                /* Form tìm kiếm */
                .search-form {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 15px;
                    margin-bottom: 24px;
                    align-items: center;
                    justify-content: center;
                }

                .search-form .form-group {
                    flex: 1;
                    min-width: 200px;
                }

                .search-form .price-group {
                    display: flex;
                    gap: 10px;
                    flex: 2;
                    min-width: 300px;
                }

                .search-form .btn-filter {
                    background: linear-gradient(45deg, #3182ce, #63b3ed);
                    border: none;
                    padding: 10px 30px;
                    border-radius: 30px;
                    color: white;
                    font-weight: 600;
                    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
                    transition: all 0.3s ease;
                }

                .search-form .btn-filter:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 15px rgba(49, 130, 206, 0.4);
                }

                .form-control {
                    border-radius: 30px;
                    padding: 12px 20px;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    border-color: #63b3ed;
                    box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.2);
                }

                /* Tabs */
                .category-tabs {
                    display: flex;
                    justify-content: center;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-top: 15px;
                }

                .tab-btn {
                    background-color: white;
                    border: 1px solid #e2e8f0;
                    border-radius: 30px;
                    padding: 10px 20px;
                    font-weight: 500;
                    color: #4a5568;
                    transition: all 0.3s ease;
                    cursor: pointer;
                }

                .tab-btn:hover {
                    background-color: #f7fafc;
                    transform: translateY(-2px);
                }

                .tab-btn.active {
                    background: linear-gradient(45deg, #3182ce, #63b3ed);
                    color: white;
                    border: none;
                    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
                }

                /* Responsive adjustments */
                @media (max-width: 768px) {
                    .search-form {
                        flex-direction: column;
                        align-items: stretch;
                    }

                    .search-form .form-group,
                    .search-form .price-group {
                        width: 100%;
                        min-width: 100%;
                    }

                    .category-tabs {
                        justify-content: center;
                    }
                }
            </style>
            <main class="pt-12">
                <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                    <div class="container-fluid">
                        <div class="product-filter-container">
                            <form method="GET" action="products" class="search-form">
                                <div class="form-group">
                                    <input type="text" name="keyword" class="form-control" placeholder="Search for products..." value="${keyword}">
                            </div>
                            <div class="price-group">
                                <input type="number" name="minPrice" class="form-control" placeholder="Minimum price" value="${minPrice}">
                                <input type="number" name="maxPrice" class="form-control" placeholder="Maximum price" value="${maxPrice}">
                            </div>
                            <button type="submit" class="btn-filter">Filter</button>
                        </form>

                        <div class="category-tabs">
                            <button class="tab-btn <c:if test="${categoryId == null || categoryId == 0}">active</c:if>"
                                    data-tab="all" data-href-load="products?keyword=${keyword}&minPrice=${minPrice}&maxPrice=${maxPrice}">
                                All
                            </button>
                            <c:forEach var="category" items="${categories}">
                                <button class="tab-btn <c:if test="${category.categoryId == categoryId}">active</c:if>"
                                        data-tab="${category.categoryId}" 
                                        data-href-load="products?categoryId=${category.categoryId}&keyword=${keyword}&minPrice=${minPrice}&maxPrice=${maxPrice}">
                                    ${category.name}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </div>       

                <!-- tab content 1 -->
                <div class="tab-content active" data-tab="all">
                    <div class="row g-0 mb-1">
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="product" items="${products}">
                                    <div class="col-lg-4 col-xs-6 mb-4">
                                        <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                            <div class="product-thumb-wrapper position-relative">
                                                <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                                    <a href="product-detail?id=${product.productId}" class="product-thumb-link d-block">
                                                        <img class="w-100" src="${product.image}" alt="${product.name}">
                                                    </a>
                                                </div>
                                            </div>
                                            <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                            <div class="product-info-wrapper">
                                                <div class="mb-xxl-7 mb-md-5 mb-3">
                                                    <a href="product-detail?id=${product.productId}">
                                                        <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                            ${product.name}
                                                        </h4>
                                                    </a>
                                                </div>
                                                <div class="d-between flex-wrap gap-4">
                                                    <div class="d-grid">
                                                        <!-- Product Price -->
                                                        <span class="text-sm fw-normal text-n50 text-decoration-underline">${product.price} VNĐ</span>
                                                        <span class="text-xl fw-semibold text-secondary2">${product.price} VNĐ</span>
                                                    </div>
                                                    <!-- Add to Cart Button -->
                                                    <c:if test="${userRole != 'admin'}">
                                                        <form method="POST" action="cart" class="product-form">
                                                            <input type="hidden" name="productId" value="${product.productId}">
                                                            <input type="hidden" name="action" value="add">
                                                            <input type="hidden" name="quantity" id="quantity" min="1" max="${product.stock}" value="1" class="quantity-input">
                                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD TO CART</button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center mt-4">
                                    <img src="https://craftzone.in/assets/img/no-product.png" alt="No products found" style="width: 30%; height: auto; margin-bottom: 10px;">
                                    <p class="text-danger">No products found!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <c:if test="${not empty products}">
                    <div class="col-12">
                        <nav>
                            <ul class="pagination justify-content-center mt-4">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="products?page=${currentPage - 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}" varStatus="status">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="products?page=${i}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="products?page=${currentPage + 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if >
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
                var tabButtons = document.querySelectorAll(".tab-btn");

                tabButtons.forEach(function (button) {
                    button.addEventListener("click", function (e) {
                        var url = this.getAttribute("data-href-load");
                        window.location.href = url;
                    });
                });
            });
        </script>

        <script>
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