<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <!-- cart box -->
        <!-- include newsletter popup -->
        <!-- main start -->
        <main class="pt-12">
            <!-- hero section start -->
            <section class="inner-hero-section px-xl-20 px-lg-10 px-sm-7" style="background-image: url(assets/images/inner-page-banner.png);">
                <div class="container-fluid">
                    <span class="text-animation-word text-h1 text-n100 mb-3">Bikes</span>
                    <ul class="breadcrumb d-inline-flex align-items-center gap-lg-2 gap-1">
                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                        <li class="breadcrumb-item active"><a href="">Bikes</a></li>
                    </ul>
                </div>
            </section>
            <!-- hero section end -->

            <!-- product section start -->
            <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                <div class="container-fluid">
                    <div class="row g-6 mb-lg-8 mb-6">
                        <div class="col-12">
                            <!-- tab btn area -->
                            <!-- here using tab option for demonstration purpose, remove tab option for production and use only filter btn -->
                            <ul class="tab-btn-area d-flex align-items-center gap-2 flex-wrap">
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1 active" data-tab="all">All</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="city">City</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="electric">Electric</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="gravel">Gravel</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="kids">Kids</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="mountain">Mountain</button>
                                </li>
                                <li>
                                    <button class="tab-btn filter-btn text-base text-n100 py-lg-2 py-1 px-lg-5 px-sm-3 px-2 radius-pill border border-n100-1" data-tab="road">Road</button>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <!-- tab content 1 -->
                    <div class="tab-content active" data-tab="all">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-1.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">City
                                                    Commuter
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-2.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Urban Explorer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-3.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Urban Wanderer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-4.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Electro Cruise
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-5.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Watt Wheels
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-6.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Electro Boost
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-7.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Gravel Master
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-8.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-9.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Terra Roamer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-10.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">Electro
                                                    Cruise
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-11.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Gravel Master
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-12.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-13.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Terra Roamer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-14.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Junior Journeymen
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-15.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Tiny Trailblazers
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-16.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rugged Rascals
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-5.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-9.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Terra Roamer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 2 -->
                    <div class="tab-content" data-tab="city">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-1.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">City
                                                    Commuter
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-2.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Urban Explorer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-3.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Urban Wanderer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 3 -->
                    <div class="tab-content" data-tab="electric">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-4.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Electro Cruise
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-5.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Watt Wheels
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-6.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Electro Boost
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 4 -->
                    <div class="tab-content" data-tab="gravel">
                        <div class="row g-0 mb-1">

                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-10.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">Electro
                                                    Cruise
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-11.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Gravel Master
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-12.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 5 -->
                    <div class="tab-content" data-tab="kids">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-10.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">Electro
                                                    Cruise
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-11.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Gravel Master
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-12.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 6 -->
                    <div class="tab-content" data-tab="mountain">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-13.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Terra Roamer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-14.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Junior Journeymen
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-15.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Tiny Trailblazers
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- tab content 7 -->
                    <div class="tab-content" data-tab="road">
                        <div class="row g-0 mb-1">
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-16.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rugged Rascals
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-5.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Rough Rider
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-xs-6">
                                <!-- product item -->
                                <div class="product-card2 position-relative p-xl-10 p-lg-8 p-6 bg-n0 border border-n100-5 box-style box-n20 card-tilt">
                                    <div class="product-type py-lg-3 py-2 ps-lg-4 ps-2 pe-lg-6 pe-4 bg-secondary2 position-absolute top-0 start-0 parallelogram-path z-2">
                                        <span class="text-sm fw-medium text-n0">New</span>
                                    </div>
                                    <div class="product-thumb-wrapper position-relative">
                                        <button class="single-wishlist-btn text-secondary2 text-xl icon-52px bg-n0 position-absolute top-0 right-0 z-3 tooltip-btn tooltip-left" data-tooltip="Add to wishlist">
                                            <i class="ph ph-heart"></i>
                                        </button>
                                        <div class="product-thumb hover-cursor" data-hover-text="View Product">
                                            <a href="shop-details.html" class="product-thumb-link d-block">
                                                <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-9.png" alt="product thumb">
                                            </a>
                                        </div>
                                    </div>
                                    <span class="d-block h-1px w-100 bg-n100-1 mb-lg-6 mb-4 mt-lg-10 mt-6"></span>
                                    <div class="product-info-wrapper">
                                        <div class="mb-xxl-7 mb-md-5 mb-3">
                                            <a href="shop-details.html">
                                                <h4 class="text-n100 mb-2 hover-text-secondary2">
                                                    Terra Roamer
                                                </h4>
                                            </a>
                                            <span class="text-sm fw-normal text-n50">Enduro</span>
                                        </div>
                                        <div class="d-between flex-wrap gap-4">
                                            <div class="d-grid">
                                                <span class="text-sm fw-normal text-n50 text-decoration-underline">$21,599.00
                                                    USD</span>
                                                <span class="text-xl fw-semibold text-secondary2">$ 14,599.00 USD</span>
                                            </div>
                                            <button class="outline-btn text-n100 fw-medium box-style box-secondary2">ADD
                                                TO CART </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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

    </body>

</html>