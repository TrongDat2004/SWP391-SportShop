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
        <style>
            :root {
                --primary: #3a86ff;
                --secondary: #ff006e;
                --dark: #2b2d42;
                --light: #f8f9fa;
                --gray: #8d99ae;
                --success: #06d6a0;
                --warning: #ffbe0b;
                --danger: #ef476f;
                --transition: all 0.3s ease;
                --shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
                --radius: 12px;
            }

            /* Header */
            .blog-header {
                background-color: #fff;
                text-align: center;
                box-shadow: var(--shadow);
                margin-bottom: 3rem;
                padding: 10px 0px;
            }

            .blog-header h1 {
                font-size: 2.5rem;
                color: var(--primary);
                margin-bottom: 0.5rem;
                font-weight: 700;
            }

            .blog-header p {
                color: var(--gray);
                font-size: 1.1rem;
                max-width: 700px;
                margin: 0 auto;
            }

            .search-container {
                max-width: 600px;
                margin: 2rem auto 0;
                position: relative;
            }

            .search-container input {
                width: 100%;
                padding: 0.8rem 1.5rem;
                border: 1px solid #e0e0e0;
                border-radius: 50px;
                font-size: 1rem;
                transition: var(--transition);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
            }

            .search-container input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 2px 15px rgba(58, 134, 255, 0.15);
            }

            .search-container button {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: var(--primary);
                border: none;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                cursor: pointer;
                transition: var(--transition);
            }

            .search-container button:hover {
                background: #2a75ff;
                transform: translateY(-50%) scale(1.05);
            }

            /* Blog Cards */
            .blog-section {
                padding: 2rem 0 4rem;
            }

            .blog-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            .blog-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .blog-card {
                background: white;
                border-radius: var(--radius);
                overflow: hidden;
                box-shadow: var(--shadow);
                transition: var(--transition);
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .blog-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .blog-image {
                width: 100%;
                height: 220px;
                overflow: hidden;
            }

            .blog-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.6s ease;
            }

            .blog-card:hover .blog-image img {
                transform: scale(1.05);
            }

            .blog-content {
                padding: 1.5rem;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .blog-category {
                color: var(--primary);
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.8rem;
            }

            .blog-title {
                font-size: 1.4rem;
                font-weight: 700;
                margin-bottom: 1rem;
                color: var(--dark);
                line-height: 1.3;
                transition: var(--transition);
            }

            .blog-card:hover .blog-title {
                color: var(--primary);
            }

            .blog-excerpt {
                color: var(--gray);
                font-size: 0.95rem;
                margin-bottom: 1.5rem;
                flex-grow: 1;
            }

            .blog-metadata {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.85rem;
                color: var(--gray);
                padding-top: 1rem;
                border-top: 1px solid #f0f0f0;
            }

            .blog-date {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .blog-author {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .read-more {
                display: inline-block;
                background-color: var(--primary);
                color: white;
                padding: 0.6rem 1.5rem;
                border-radius: 50px;
                font-weight: 600;
                font-size: 0.9rem;
                text-decoration: none;
                transition: var(--transition);
                text-align: center;
                margin-top: auto;
                border: none;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(58, 134, 255, 0.2);
            }

            .read-more:hover {
                background-color: #2a75ff;
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(58, 134, 255, 0.25);
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 0.3rem;
                list-style: none;
                padding: 0;
                margin: 2rem 0 0;
            }

            .page-item {
                margin: 0 2px;
            }

            .page-link {
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 40px;
                height: 40px;
                padding: 0 0.8rem;
                border-radius: 50px;
                background-color: white;
                color: var(--dark);
                text-decoration: none;
                font-weight: 600;
                transition: var(--transition);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            .page-item.active .page-link {
                background-color: var(--primary);
                color: white;
                box-shadow: 0 3px 10px rgba(58, 134, 255, 0.2);
            }

            .page-link:hover {
                background-color: #f0f0f0;
                transform: translateY(-2px);
            }

            .page-item.active .page-link:hover {
                background-color: var(--primary);
                transform: translateY(-2px);
            }

            /* No results */
            .no-results {
                text-align: center;
                padding: 3rem 0;
            }

            .no-results i {
                font-size: 4rem;
                color: var(--gray);
                margin-bottom: 1.5rem;
            }

            .no-results h3 {
                font-size: 1.8rem;
                color: var(--dark);
                margin-bottom: 1rem;
            }

            .no-results p {
                color: var(--gray);
                max-width: 600px;
                margin: 0 auto 1.5rem;
            }

            /* Featured Tag */
            .featured-tag {
                position: absolute;
                top: 15px;
                right: 15px;
                background-color: var(--warning);
                color: var(--dark);
                font-weight: 600;
                font-size: 0.8rem;
                padding: 0.3rem 0.8rem;
                border-radius: 30px;
                z-index: 1;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .blog-grid {
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    gap: 1.5rem;
                }

                .blog-header h1 {
                    font-size: 2rem;
                }

                .blog-title {
                    font-size: 1.2rem;
                }
            }

            @media (max-width: 480px) {
                .blog-grid {
                    grid-template-columns: 1fr;
                }

                .blog-header {
                    padding: 1.5rem 0;
                }

                .blog-header h1 {
                    font-size: 1.8rem;
                }

                .page-link {
                    min-width: 35px;
                    height: 35px;
                }
            }
        </style>
    </head>

    <body>
        <!-- back to top -->
        <button class="back-to-top position-fixed end-0 bottom-0 d-center me-5">
            <span class="text-h4">
                <i class="fa-solid fa-arrow-up"></i>
            </span>
        </button>

        <!-- header section start -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
            <!-- header section end -->

            <!-- cart box -->
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>

            <main class="pt-12" style="margin-top: 130px">
                <section class="shopping-cart-section px-xl-20 px-lg-10 px-sm-7">
                    <!-- Blog Header -->
                    <div class="blog-header">
                        <div class="container">
                            <h1>Latest Sports News</h1>
                            <p>Stay updated with the latest sports news, trends, and products</p>

                            <!-- Search Box -->
                            <form action="blogs" method="GET" class="search-container">
                                <input type="text" name="search" placeholder="Search for articles..." value="${search}">
                            <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                        </form>
                    </div>
                </div>


                <!-- Blog Section -->
                <section class="blog-section py-5">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-md-8">
                                <div class="card shadow-lg border-0 rounded-3">
                                    <img src=".${blog.image}" class="card-img-top rounded-top" alt="Blog Image">
                                    <div class="card-body">
                                        <h2 class="card-title text-center text-dark fw-bold">${blog.title}</h2>
                                        <hr class="my-3">
                                        <p class="card-text text-justify" style="font-size: 1.1rem; line-height: 1.6;">
                                            ${blog.content}
                                        </p>
                                        <div class="text-center mt-4">
                                            <a href="blogs" class="btn btn-outline-primary px-4 py-2 fw-semibold">Quay lại</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </section>
        </main>
        <!-- main end -->

        <!-- footer section -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>