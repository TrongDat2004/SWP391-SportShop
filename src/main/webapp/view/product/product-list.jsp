<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Giữ lại các giá trị filter và sort từ request để điền lại form và tạo link --%>
<c:set var="account" value="${sessionScope.account}" />
<c:set var="userRole" value="${account != null ? account.role : null}" />
<%-- Lấy các tham số filter và sort từ requestScope (do Controller đặt) --%>
<c:set var="keyword" value="${requestScope.keyword}" />
<%-- Lấy categoryId đã xử lý (có thể null) từ requestScope --%>
<c:set var="categoryId" value="${requestScope.categoryId}" />
<c:set var="sortBy" value="${requestScope.sortBy}" />
<%-- Lấy giá trị priceRange đã chọn từ requestScope (DO CONTROLLER SET) --%>
<c:set var="selectedPriceRange" value="${requestScope.selectedPriceRange}" />

<%-- Giá trị categoryId từ request có thể là chuỗi, cần đảm bảo nó là số nếu dùng để so sánh số --%>
<c:set var="categoryIdNum" value="${not empty categoryId ? categoryId : 0}" />
<%-- Lấy danh sách categories và products từ request attribute (do Servlet set) --%>
<c:set var="categories" value="${requestScope.categories}" />
<c:set var="products" value="${requestScope.products}" />
<c:set var="currentPage" value="${requestScope.currentPage}" />
<c:set var="totalPages" value="${requestScope.totalPages}" />


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
        <style>
            /* Style hiện đại cho khu vực tìm kiếm và lọc */
            .product-filter-container {
                background-color: #f8f9fa;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                padding: 24px;
                margin-bottom: 32px;
            }

            /* Form tìm kiếm và lọc */
            .filter-form-container {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: flex-end; /* Align items to the bottom for consistent button height */
                justify-content: center;
                position: relative;
            }

            .filter-form-container .form-group {
                flex: 1;
                min-width: 180px; /* Adjust min-width as needed */
            }
             .filter-form-container .form-group label {
                  display: block; margin-bottom: 5px; font-size: 0.9em; color: #555;
             }

            /* No specific price group needed anymore, using generic form-group */

            .filter-form-container .sort-group { /* Can reuse form-group now */
                flex: 1;
                min-width: 180px;
            }
            .filter-form-container .sort-group label {
                 display: block; margin-bottom: 5px; font-size: 0.9em; color: #555;
            }

            .filter-form-container .filter-button-group {
                 flex-basis: 100%; /* Take full width on small screens */
                 text-align: center;
                 margin-top: 10px;
            }

            @media (min-width: 992px) {
                 .filter-form-container .filter-button-group {
                     flex-basis: auto; /* Let it shrink to content width */
                     margin-top: 0; /* Align with other inputs */
                     margin-left: 15px;
                 }
            }

            .filter-form-container .btn-filter {
                background: linear-gradient(45deg, #3182ce, #63b3ed); border: none;
                padding: 10px 30px; border-radius: 30px; color: white; font-weight: 600;
                box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3); transition: all 0.3s ease;
                height: 45px; /* Match input height */
                line-height: 25px; /* Adjust line-height for vertical centering */
                cursor: pointer;
            }
            .filter-form-container .btn-filter:hover {
                transform: translateY(-2px); box-shadow: 0 6px 15px rgba(49, 130, 206, 0.4);
            }

            .form-control, .form-select {
                border-radius: 30px; padding: 10px 20px; border: 1px solid #e2e8f0;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03); transition: all 0.3s ease;
                height: 45px; width: 100%;
            }
            .form-control:focus, .form-select:focus {
                border-color: #63b3ed; box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.2); outline: none;
            }

            /* REMOVED CSS related to price error messages and is-invalid for price inputs */

            /* Tabs */
            .category-tabs { display: flex; justify-content: center; flex-wrap: wrap; gap: 10px; margin-top: 25px; } /* Increased margin-top */
            .tab-btn {
                background-color: white; border: 1px solid #e2e8f0; border-radius: 30px;
                padding: 10px 20px; font-weight: 500; color: #4a5568; transition: all 0.3s ease;
                cursor: pointer; text-decoration: none; display: inline-block;
            }
            .tab-btn:hover { background-color: #f7fafc; transform: translateY(-2px); text-decoration: none; color: #2d3748; }
            .tab-btn.active {
                background: linear-gradient(45deg, #3182ce, #63b3ed); color: white; border: none;
                box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
            }

            /* Responsive adjustments */
            @media (max-width: 991px) {
                 .filter-form-container { flex-direction: column; align-items: stretch; }
                 .filter-form-container .form-group { width: 100%; min-width: 100%; }
                 .filter-form-container .filter-button-group { width: 100%; margin-left: 0; }
                 .category-tabs { justify-content: center; }
                 /* Adjust order if needed, but likely okay now */
            }
        </style>
    </head>

    <body>
        <!-- back to top -->
        <button class="back-to-top position-fixed end-0 bottom-0 d-center me-5">
            <span class="text-h4"> <i class="ph ph-arrow-up"></i> </span>
        </button>
        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>

            <main class="pt-12">
                <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                    <div class="container-fluid">
                        <div class="product-filter-container">
                            <form method="GET" action="products" class="filter-form-container">
                                <%-- Order 3: Price Range Dropdown --%>
                                <div class="form-group" style="order: 1;">
                                    <label for="priceRangeSelect">Price Range</label>
                                    <select name="priceRange" id="priceRangeSelect" class="form-select">
                                        <option value="all" ${empty selectedPriceRange || selectedPriceRange == 'all' ? 'selected' : ''}>All Price</option>
                                        <option value="0_500000" ${selectedPriceRange == '0_500000' ? 'selected' : ''}>Up to 500.000 VNĐ</option>
                                        <option value="500000_1000000" ${selectedPriceRange == '500000_1000000' ? 'selected' : ''}>500.000 - 1.000.000 VNĐ</option>
                                        <option value="1000000_2000000" ${selectedPriceRange == '1000000_2000000' ? 'selected' : ''}>1.000.000 - 2.000.000 VNĐ</option>
                                        <option value="2000000_5000000" ${selectedPriceRange == '2000000_5000000' ? 'selected' : ''}>2.000.000 - 5.000.000 VNĐ</option>
                                        <option value="5000000_999999999" ${selectedPriceRange == '5000000_999999999' ? 'selected' : ''}>Over 5.000.000 VNĐ</option>
                                        <%-- Add more ranges as needed --%>
                                    </select>
                                </div>

                                <%-- Order 4: Sort By Dropdown --%>
                                <div class="form-group sort-group" style="order: 2;">
                                    <label for="sortBySelect">Sort By</label>
                                    <select name="sortBy" id="sortBySelect" class="form-select">
                                        <option value="default" ${sortBy == 'default' ? 'selected' : ''}>Default</option>
                                        <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                                        <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                                        <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Name: A to Z</option>
                                        <option value="name_desc" ${sortBy == 'name_desc' ? 'selected' : ''}>Name: Z to A</option>
                                        
                                    </select>
                                </div>

                                <%-- Order 5: Apply Button --%>
                                <div class="filter-button-group" style="order: 3;">
                                     <button type="submit" class="btn-filter">Apply</button>
                                </div>

                                <%-- Hidden field for category ID (still needed for category tabs) --%>
                                <input type="hidden" name="categoryId" value="${categoryId}">
                            </form>

                            <div class="category-tabs">
                                <%-- Update links to use priceRange parameter --%>
                                <a href="products?keyword=${keyword}&priceRange=${selectedPriceRange}&sortBy=${sortBy}"
                                   class="tab-btn ${empty categoryId || categoryId == 0 ? 'active' : ''}">
                                    All
                                </a>
                                <c:forEach var="category" items="${categories}">
                                    <a href="products?categoryId=${category.categoryId}&keyword=${keyword}&priceRange=${selectedPriceRange}&sortBy=${sortBy}"
                                       class="tab-btn ${category.categoryId == categoryIdNum ? 'active' : ''}">
                                        ${category.name}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Product listing area -->
                        <div class="row g-4 mb-4">
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach var="product" items="${products}">
                                        <div class="col-lg-4 col-md-6 col-sm-6">
                                            <div class="product-card2 h-100 d-flex flex-column position-relative p-xl-7 p-lg-5 p-4 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                                <div class="product-thumb-wrapper position-relative mb-4">
                                                    <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                                        <a href="product-detail?id=${product.productId}" class="product-thumb-link d-block">
                                                            <img class="w-100 object-fit-contain"
                                                                 src="${pageContext.request.contextPath}/${product.image}"
                                                                 alt="${product.name}" style="height: 280px;"
                                                                 onerror="this.src='https://thudaumot.binhduong.gov.vn/Portals/0/images/default.jpg'">
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="product-info-wrapper mt-auto">
                                                    <div class="mb-3">
                                                        <a href="product-detail?id=${product.productId}" class="text-decoration-none">
                                                            <h4 class="text-n100 mb-2 hover-text-secondary2 fs-6" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-overflow: ellipsis; line-height: 1.4; min-height: 2.8em;">
                                                                ${product.name}
                                                            </h4>
                                                        </a>
                                                    </div>
                                                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                                                        <div class="d-grid">
                                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VNĐ" pattern="#,##0 VNĐ" var="formattedPrice"/>
                                                            <span class="text-xl fw-semibold text-secondary2">${formattedPrice}</span>
                                                        </div>
                                                        <a href="product-detail?id=${product.productId}" class="outline-btn text-n100 fw-medium box-style box-secondary2 py-2 px-3">View Details</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                     <%-- Simplified 'no products' message --%>
                                     <div class="col-12 text-center mt-5">
                                        <img src="https://craftzone.in/assets/img/no-product.png" alt="No products found" style="max-width: 300px; height: auto; margin-bottom: 15px;">
                                        <p class="text-danger fs-5">No products found matching your criteria!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Pagination -->
                        <%-- Show pagination if more than one page --%>
                        <c:if test="${not empty products && totalPages > 1}">
                            <div class="col-12">
                                <nav aria-label="Product navigation">
                                    <ul class="pagination justify-content-center mt-5">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <%-- Update links to use priceRange parameter --%>
                                            <a class="page-link" href="products?page=${currentPage - 1}&keyword=${keyword}&categoryId=${categoryId}&priceRange=${selectedPriceRange}&sortBy=${sortBy}" aria-label="Previous">
                                                <span aria-hidden="true">«</span>
                                            </a>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}" varStatus="status">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="products?page=${i}&keyword=${keyword}&categoryId=${categoryId}&priceRange=${selectedPriceRange}&sortBy=${sortBy}">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="products?page=${currentPage + 1}&keyword=${keyword}&categoryId=${categoryId}&priceRange=${selectedPriceRange}&sortBy=${sortBy}" aria-label="Next">
                                                <span aria-hidden="true">»</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </section>
            </main>
            <!-- main end -->

            <!-- footer section -->
            <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <!-- footer section end -->

        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <%-- Script xử lý ảnh lỗi (Keep as is) --%>
        <script>
             // ... (Script ảnh lỗi giữ nguyên) ...
             
             const filterForm = document.querySelector('.filter-form-container');
             const minPriceInput = document.getElementById('minPriceInput');
             const maxPriceInput = document.getElementById('maxPriceInput');

             if (filterForm && minPriceInput && maxPriceInput) {
                 filterForm.addEventListener('submit', function(event) {
                     const minPrice = parseFloat(minPriceInput.value);
                     const maxPrice = parseFloat(maxPriceInput.value);

                     // Check if both are numbers and min > max
                     if (!isNaN(minPrice) && !isNaN(maxPrice) && minPrice > maxPrice) {
                         // You could show an error message here using iziToast or similar
                         alert('Minimum price cannot be greater than maximum price.');
                         event.preventDefault(); // Stop form submission
                     }
                 });
             }
        </script>
    </body>
</html>
