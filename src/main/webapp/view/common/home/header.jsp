<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .user-dropdown {
        position: relative;
        display: inline-block;
    }
    
    .dropdown-content {
        display: none;
        position: absolute;
        
        background-color: #fff;
        min-width: 160px;
        box-shadow: 0px 8px 16px rgba(0,0,0,0.1);
        z-index: 1;
        border-radius: 4px;
        padding: 8px 0;
    }
    
    .dropdown-content a {
        color: #333;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        transition: all 0.3s ease;
    }
    
    .dropdown-content a:hover {
        background-color: #f5f5f5;
        color: #000;
    }
    
    .user-dropdown:hover .dropdown-content {
        display: block;
    }
</style>
<header class="header-section position-fixed top-0 start-50 translate-middle-x" data-lenis-prevent="">
    <!-- top navbar -->
    <div class="top-navbar bg-n100 py-3 d-none d-lg-block">
        <div class="row g-0 justify-content-center">
            <div class="col-3xl-11 px-3xl-0 px-xxl-8 px-sm-6 px-0">
                <div class="d-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center gap-xl-6 gap-4">
                        <a href="#" class="d-flex align-items-center gap-2 text-n0 hover-text-secondary2">
                            <span class="text-base"><i class="ph ph-map-pin"></i></span>
                            <span class="text-sm text-nowrap">
                                1200 Main St. Santa Rosa, CA 93541, USA
                            </span>
                        </a>
                        <a href="tel:+1234567890" class="d-flex align-items-center gap-2 text-n0 hover-text-secondary2">
                            <span class="text-base"><i class="ph ph-phone-call"></i></span>
                            <span class="text-sm text-nowrap">
                                +123 456 7890
                            </span>
                        </a>
                    </div>
                    <div class="d-flex align-items-center gap-xl-6 gap-4">
                        <div class="language-option custom-select-container">
                            <!-- selected item  -->
                            <div class="custom-select">
                                <span class="selected-option fw-medium text-n0">
                                    <img src="${pageContext.request.contextPath}/assets/images/flags/ac.png" alt="language" class="option-flag">
                                    AC
                                </span>
                                <ul class="options-list">
                                    <li data-value="ac">
                                        <img src="${pageContext.request.contextPath}/assets/images/flags/ac.png" alt="language" class="option-flag">
                                        AC
                                    </li>
                                    <li data-value="ad">
                                        <img src="${pageContext.request.contextPath}/assets/images/flags/ad.png" alt="language" class="option-flag">
                                        AD
                                    </li>
                                    <li data-value="az">
                                        <img src="${pageContext.request.contextPath}/assets/images/flags/az.png" alt="language" class="option-flag">
                                        AZ
                                    </li>
                                    <li data-value="ba">
                                        <img src="${pageContext.request.contextPath}/assets/images/flags/ba.png" alt="language" class="option-flag">
                                        BA
                                    </li>
                                    <li data-value="bq">
                                        <img src="${pageContext.request.contextPath}/assets/images/flags/bq.png" alt="language" class="option-flag">
                                        BQ
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-sm text-nowrap fw-medium text-n0">Follow Us:</span>
                            <ul class="d-flex align-items-center gap-4">
                                <li><a href="#" class="text-n0 text-xl hover-text-secondary2"><i class="ph ph-facebook-logo"></i></a></li>
                                <li><a href="#" class="text-n0 text-xl hover-text-secondary2"><i class="ph ph-x-logo"></i></a></li>
                                <li><a href="#" class="text-n0 text-xl hover-text-secondary2"><i class="ph ph-dribbble-logo"></i></a></li>
                                <li><a href="#" class="text-n0 text-xl hover-text-secondary2"><i class="ph ph-instagram-logo"></i></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header section start -->
    <div class="container-fluid">
        <div class="row g-0 justify-content-center">
            <div class="col-3xl-11 px-3xl-0 px-xxl-8 px-sm-6 px-0">
                <!-- navbar area -->
                <div class="d-flex align-items-center justify-content-between gap-4xl-10 gap-3xl-8 gap-xxl-6 gap-4 px-lg-0 px-sm-4 py-lg-5 py-3">
                    <div class="logo">
                        <a href="index.html">
                            <img class="w-100 d-block d-sm-none" src="assets/images/favicon.png" alt="logo">
                            <img class="w-100 d-none d-sm-block" src="assets/images/logo.png" alt="logo">
                        </a>
                    </div>
                    <nav class="navbar-area">

                        <!-- navbar close btn -->
                        <button class="menu-close-btn d-block d-lg-none">
                            <span class="icon-32px text-2xl text-n0 bg-n100 mb-4">
                                <i class="ph ph-x"></i>
                            </span>
                        </button>

                        <ul class="nav-menu-items d-lg-flex d-grid align-items-lg-center gap-lg-0 gap-lg-4 gap-1">
                            <li class="menu-item">
                                <a href="${pageContext.request.contextPath}/home" class="" style="color: #000" data-splitting="">Home</a>
                                <!-- <button class="slide-vertical" data-splitting="">Home
                                    <span class="menu-icon"><i class="ph-fill ph-caret-down"></i></span>
                                </button> -->
                                <!-- <ul class="sub-menu">
                                    <li class="menu-link">
                                        <a href="index.html" class="slide-horizontal" data-splitting="">Home One</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="index-two.html" class="slide-horizontal" data-splitting="">Home
                                            Two</a>
                                    </li>
                                </ul> -->
                            </li>
                            <li class="menu-link">
                                <a href="about-us.html" class="slide-vertical" data-splitting="">About Us</a>
                            </li>
                            <li class="menu-item">
                                <button class="slide-vertical" data-splitting="">Services
                                    <span class="menu-icon"><i class="ph-fill ph-caret-down"></i></span>
                                </button>
                                <ul class="sub-menu">
                                    <li class="menu-link">
                                        <a href="services.html" class="slide-horizontal" data-splitting="">Services</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="service-details.html" class="slide-horizontal" data-splitting="">Service
                                            Details</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="menu-item">
                                <button class="slide-vertical" data-splitting="">Shop
                                    <span class="menu-icon"><i class="ph-fill ph-caret-down"></i></span>
                                </button>
                                <div class="mega-menu">
                                    <div class="row gx-4xl-20 gx-3xl-10 gx-xxl-8 gx-lg-8 gy-lg-0 g-6 justify-content-between">
                                        <div class="col-3xl-7">
                                            <div class="row g-6 row-cols-lg-5 gy-lg-0 gy-2 justify-content-between">
                                                <div class="col-lg-auto col-12">
                                                    <div class="mega-menu-item d-grid gap-lg-6">
                                                        <div class="menu-title-wrapper d-between">
                                                            <div>
                                                                <div class="menu-item-thumb icon-48px radius-unset d-none d-lg-block mb-3 overflow-hidden">
                                                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/bikes.png" alt="mega menu">
                                                                </div>
                                                                <span class="menu-title text-h5 text-uppercase">Bikes</span>
                                                                <span class="hr-line-40px radius-4 bg-secondary2 d-lg-block d-none h-2"></span>
                                                            </div>
                                                            <span class="menu-icon d-lg-none"><i class="ph-fill ph-caret-down"></i></span>
                                                        </div>
                                                        <ul class="mega-sub-menu">
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Bikes </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> City </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Electric </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Gravel </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Kids </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Mountain </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="shop.html"> Road </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="col-lg-auto col-12">
                                                    <div class="mega-menu-item d-grid gap-lg-6">
                                                        <div class="menu-title-wrapper d-between">
                                                            <div>
                                                                <div class="menu-item-thumb icon-48px radius-unset d-none d-lg-block mb-3 overflow-hidden">
                                                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/accessories.png" alt="mega menu">
                                                                </div>
                                                                <span class="menu-title text-h5 text-uppercase">ACCESSORIES</span>
                                                                <span class="hr-line-40px radius-4 bg-secondary2 d-lg-block d-none h-2"></span>
                                                            </div>
                                                            <span class="menu-icon d-lg-none"><i class="ph-fill ph-caret-down"></i></span>
                                                        </div>
                                                        <ul class="mega-sub-menu">
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Accessories </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Lights & Reflectors </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Locks & Security </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Bags & Racks </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Pumps & Inflation </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Water Bottles </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="accessories.html"> Bike Computers </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="col-lg-auto col-12">
                                                    <div class="mega-menu-item d-grid gap-lg-6">
                                                        <div class="menu-title-wrapper d-between">
                                                            <div>
                                                                <div class="menu-item-thumb icon-48px radius-unset d-none d-lg-block mb-3 overflow-hidden">
                                                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/parts.png" alt="mega menu">
                                                                </div>
                                                                <span class="menu-title text-h5 text-uppercase">PARTS</span>
                                                                <span class="hr-line-40px radius-4 bg-secondary2 d-lg-block d-none h-2"></span>
                                                            </div>
                                                            <span class="menu-icon d-lg-none"><i class="ph-fill ph-caret-down"></i></span>
                                                        </div>
                                                        <ul class="mega-sub-menu">
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Parts </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Brakes </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Chains & Drivetrains </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Tires & Tubes </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Wheels & Rims </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Pedals & Cleats </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Handlebars & Stems </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="col-lg-auto col-12">
                                                    <div class="mega-menu-item d-grid gap-lg-6">
                                                        <div class="menu-title-wrapper d-between">
                                                            <div>
                                                                <div class="menu-item-thumb icon-48px radius-unset d-none d-lg-block mb-3 overflow-hidden">
                                                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/gear.png" alt="mega menu">
                                                                </div>
                                                                <span class="menu-title text-h5 text-uppercase">GEAR</span>
                                                                <span class="hr-line-40px radius-4 bg-secondary2 d-lg-block d-none h-2"></span>
                                                            </div>
                                                            <span class="menu-icon d-lg-none"><i class="ph-fill ph-caret-down"></i></span>
                                                        </div>
                                                        <ul class="mega-sub-menu">
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Gears </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Helmets </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Jerseys </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Shorts & Bibs </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Gloves </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Shoes </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Protective Gear </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <div class="col-lg-auto col-12">
                                                    <div class="mega-menu-item d-grid gap-lg-6">
                                                        <div class="menu-title-wrapper d-between">
                                                            <div>
                                                                <div class="menu-item-thumb icon-48px radius-unset d-none d-lg-block mb-3 overflow-hidden">
                                                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/electronics.png" alt="mega menu">
                                                                </div>
                                                                <span class="menu-title text-h5 text-uppercase">ELECTRONICS</span>
                                                                <span class="hr-line-40px radius-4 bg-secondary2 d-lg-block d-none h-2"></span>
                                                            </div>
                                                            <span class="menu-icon d-lg-none"><i class="ph-fill ph-caret-down"></i></span>
                                                        </div>
                                                        <ul class="mega-sub-menu">
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Electronics </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Cycling Computers </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Heart Rate Monitors </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Cameras & Mounts </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Energy Bars </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Electrolyte Drinks </a>
                                                            </li>
                                                            <li class="mega-menu-link">
                                                                <a href="#"> Water Bottles </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-3xl-5 d-none d-3xl-block">
                                            <div class="d-lg-flex d-none justify-content-center justify-content-between gap-4xl-20 gap-3xl-10 gap-xxl-8 gap-lg-6">
                                                <div class="product-card">
                                                    <div class="card-thumb-wrapper p-3xl-6 p-xl-4 p-lg-3 mb-3xl-5 mb-xl-3 mb-lg-2 bg-n20">
                                                        <div class="card-thumb mb-3xl-6 mb-xl-4 mb-lg-3">
                                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-thumb-1.png" alt="product thumb">
                                                        </div>
                                                        <a href="shop.html" class="outline-btn box-style box-secondary2 text-sm fw-bold py-1 w-100">Shop
                                                            Now</a>
                                                    </div>
                                                    <div class="card-info px-4 text-center">
                                                        <a href="shop-details.html" class="text-h6 text-n100 hover-text-secondary2 mb-2">
                                                            Merida Scultura Sukura
                                                        </a>
                                                        <div class="d-center gap-2 mb-1">
                                                            <ul class="rating d-flex align-items-center gap-1">
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                            </ul>
                                                            <span class="text-n50 text-sm">1 Reviews</span>
                                                        </div>
                                                        <div class="d-center gap-1 mb-lg-3 mb-2">
                                                            <span class="text-n50 text-sm">Brand: </span>
                                                            <a href="#" class="text-n100 text-sm fw-bold hover-text-secondary2">
                                                                Schwmin
                                                            </a>
                                                        </div>
                                                        <span class="text-h6 text-secondary2">$321</span>
                                                    </div>
                                                </div>
                                                <div class="product-card">
                                                    <div class="card-thumb-wrapper p-3xl-6 p-xl-4 p-lg-3 mb-3xl-5 mb-xl-3 mb-lg-2 bg-n20">
                                                        <div class="card-thumb mb-3xl-6 mb-xl-4 mb-lg-3">
                                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/product-thumb-2.png" alt="product thumb">
                                                        </div>
                                                        <a href="shop.html" class="outline-btn box-style box-secondary2 text-sm fw-bold py-1 w-100">Shop
                                                            Now</a>
                                                    </div>
                                                    <div class="card-info px-4 text-center">
                                                        <a href="shop-details.html" class="text-h6 text-n100 hover-text-secondary2 mb-2">
                                                            Urban Wanderer
                                                        </a>
                                                        <div class="d-center gap-2 mb-1">
                                                            <ul class="rating d-flex align-items-center gap-1">
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                                <li><span><i class="ph-fill ph-star"></i></span>
                                                                </li>
                                                            </ul>
                                                            <span class="text-n50 text-sm">1 Reviews</span>
                                                        </div>
                                                        <div class="d-center gap-1 mb-lg-3 mb-2">
                                                            <span class="text-n50 text-sm">Brand: </span>
                                                            <a href="#" class="text-n100 text-sm fw-bold hover-text-secondary2">
                                                                Schwmin
                                                            </a>
                                                        </div>
                                                        <span class="text-h6 text-secondary2">$321</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </li>
                            <li class="menu-item">
                                <button class="slide-vertical" data-splitting="">Pages
                                    <span class="menu-icon"><i class="ph-fill ph-caret-down"></i></span>
                                </button>
                                <ul class="sub-menu">
                                    <li class="menu-link">
                                        <a href="shop-details.html" class="slide-horizontal" data-splitting="">Shop
                                            Details</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="faqs.html" class="slide-horizontal" data-splitting="">Faqs</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="cart.html" class="slide-horizontal" data-splitting="">Cart</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="checkout.html" class="slide-horizontal" data-splitting="">Checkout</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="terms-conditions.html" class="slide-horizontal" data-splitting="">Terms
                                            & Conditions</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="privacy-policy.html" class="slide-horizontal" data-splitting="">Privacy
                                            Policy</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="warranty-policy.html" class="slide-horizontal" data-splitting="">Warranty
                                            Policy</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="shipping-delivery.html" class="slide-horizontal" data-splitting="">
                                            Shipping & Delivery
                                        </a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="how-to-order.html" class="slide-horizontal" data-splitting="">
                                            How to Order
                                        </a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="exchange-return.html" class="slide-horizontal" data-splitting="">
                                            Exchange & Return Policy
                                        </a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="terms-of-offers.html" class="slide-horizontal" data-splitting="">
                                            Terms of Offers
                                        </a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="error-page.html" class="slide-horizontal" data-splitting="">
                                            Error Page
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="menu-item">
                                <button class="slide-vertical" data-splitting="">News
                                    <span class="menu-icon"><i class="ph-fill ph-caret-down"></i></span>
                                </button>
                                <ul class="sub-menu">
                                    <li class="menu-link">
                                        <a href="blogs.html" class="slide-horizontal" data-splitting="">News</a>
                                    </li>
                                    <li class="menu-link">
                                        <a href="blog-details.html" class="slide-horizontal" data-splitting="">News
                                            Details</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="menu-link">
                                <a href="contact-us.html" class="slide-vertical" data-splitting="">Contact</a>
                            </li>
                        </ul>
                    </nav>
                    <!-- search bar area -->
                    <div class="search-bar search-form-wrapper">
                        <form action="#" class="header-search-form d-flex align-items-center gap-3 py-lg-3 py-2 px-xxl-6 px-md-4 px-3 radius-pill border border-n100-6 bg-n20 w-100 focus-secondary2">
                            <input type="text" placeholder="Search Bikes, Gear & Accessories" class="w-100 border-0 outline-0 bg-transparent">
                            <button type="submit" class="text-xl">
                                <i class="ph ph-magnifying-glass"></i>
                            </button>
                        </form>
                        <button type="button" class="search-close-btn text-2xl position-absolute top-0 end-0 translate-middle me-5 mt-10 p-sm-2 p-1 bg-primary2 text-n0 d-xl-none">
                            <i class="ph ph-x"></i>
                        </button>
                    </div>

                    <div class="nav-btns d-flex align-items-center gap-xl-4 gap-lg-3 gap-4">
                        <!-- toggle search bar -->
                        <button type="submit" class="toggle-search-btn text-xl d-xl-none">
                            <i class="ph ph-magnifying-glass"></i>
                        </button>

                        <!-- user profile -->
                        <div class="user-dropdown">
                            <a href="/SWP391-Sport-Shop-DatNguyen/authen?action=login" class="user-btn icon-36px text-n100 hover-text-secondary2">
                                <span class="text-2xl">
                                    <i class="ph ph-user"></i>
                                </span>
                            </a>
                            <div class="dropdown-content">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account}">
                                        <a href="${pageContext.request.contextPath}/profile">Profile</a>
                                        <a href="${pageContext.request.contextPath}/authen?action=logout">Logout</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/authen?action=login">Login</a>
                                        <a href="${pageContext.request.contextPath}/authen?action=register">Register</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- wishlist btn -->
                        <a href="wishlist.html" class="wishlist-btn icon-36px position-relative text-n100 hover-text-secondary2">
                            <span class="badge radius-pill text-n0 text-sm fw-medium bg-secondary2 position-absolute top-50 start-100 translate-middle z-1 mt-n3">0</span>
                            <span class="text-2xl">
                                <i class="ph ph-heart"></i>
                            </span>
                        </a>

                        <!-- cart btn -->
                        <button class="cart-btn icon-36px position-relative text-n100 hover-text-secondary2">
                            <span class="badge radius-pill text-n0 text-sm fw-medium bg-secondary2 position-absolute top-50 start-100 translate-middle z-1 mt-n3">0</span>
                            <span class="text-2xl">
                                <i class="ph ph-shopping-cart"></i>
                            </span>
                        </button>

                        <button class="menu-toggle-btn text-2xl d-block d-lg-none">
                            <i class="ph ph-list"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>