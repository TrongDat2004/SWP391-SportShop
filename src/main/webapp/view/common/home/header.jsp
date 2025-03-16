<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="account" value="${sessionScope.account}" />
<c:set var="userRole" value="${account != null ? account.role : null}" />
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
                                600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ
                            </span>
                        </a>
                        <a href="tel:+1234567890" class="d-flex align-items-center gap-2 text-n0 hover-text-secondary2">
                            <span class="text-base"><i class="ph ph-phone-call"></i></span>
                            <span class="text-sm text-nowrap">
                                0292 7301 988
                            </span>
                        </a>
                    </div>
                    <div class="d-flex align-items-center gap-xl-6 gap-4">
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
                        <a href="home">
                            <img class="w-100 d-block d-sm-none" src="assets/images/favi.jpg" alt="logo">
                            <img class="w-100 d-none d-sm-block" src="assets/images/logof.jpg" alt="logo">
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
                            <li class="menu-link">
                                <a href="${pageContext.request.contextPath}/home" class="slide-vertical" data-splitting="">Home</a>
                            </li>
                            <li class="menu-link">
                                <a href="${pageContext.request.contextPath}/products" class="slide-vertical" data-splitting="">Products</a>
                            </li>
                            <li class="menu-link">
                                <a href="blogs" class="slide-vertical" data-splitting="">Blogs</a>
                            </li>
                            <li class="menu-link">
                                <a href="about" class="slide-vertical" data-splitting="">About us</a>
                            </li>
                            <li class="menu-link">
                                <a href="contact" class="slide-vertical" data-splitting="">Contact</a>
                            </li>
                        </ul>
                    </nav>
                    <!-- search bar area -->
                    <div class="search-bar search-form-wrapper">
                        <form method="GET" action="products" class="header-search-form d-flex align-items-center gap-3 py-lg-3 py-2 px-xxl-6 px-md-4 px-3 radius-pill border border-n100-6 bg-n20 w-100 focus-secondary2">
                            <input type="text" name="keyword" placeholder="Search products" class="w-100 border-0 outline-0 bg-transparent">
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
                            <a href="${pageContext.request.contextPath}/authen?action=login" class="user-btn icon-36px text-n100 hover-text-secondary2">
                                <span class="text-2xl">
                                    <i class="ph ph-user"></i>
                                </span>
                            </a>
                            <div class="dropdown-content">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account}">
                                        <a href="${pageContext.request.contextPath}/profile">Profile</a>
                                        <c:if test="${userRole != 'admin'}">
                                            <a href="${pageContext.request.contextPath}/history-order">History order</a>
                                        </c:if>
                                        <c:if test="${userRole == 'admin' || userRole == 'staff'}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard">Go to dashboard</a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/authen?action=logout">Logout</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/authen?action=login">Login</a>
                                        <a href="${pageContext.request.contextPath}/authen?action=sign-up">Register</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- cart btn -->
                        <button onclick="window.location.href = 'cart'" class="cart-btn icon-36px position-relative text-n100 hover-text-secondary2">
                            <span class="badge radius-pill text-n0 text-sm fw-medium bg-secondary2 position-absolute top-50 start-100 translate-middle z-1 mt-n3" id="cart-count">0</span>
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