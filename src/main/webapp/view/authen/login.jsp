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
        <meta property="og:image" content="${pageContext.request.contextPath}/assets/images/logo.png">
        <meta property="og:url" content="">
        <meta property="og:type" content="website">

        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="CycleCity | Quality Bicycles and Cycling Gear">
        <meta name="twitter:description" content="Explore the latest in bicycles, cycling gear, and accessories at CycleCity. Gear up for your next adventure!">
        <meta name="twitter:image" content="${pageContext.request.contextPath}/assets/images/logo.png">
        <meta name="twitter:site" content="@CycleCity">

        <title>CycleCity | Your Hub for Quality Bicycles, Gear, and Accessories</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon">

        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <!-- Add iziToast CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
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
        <!-- main start -->
        <main class="pt-12">

            <!-- hero section start -->
            <section class="inner-hero-section px-xl-20 px-lg-10 px-sm-7" style="background-image: url(assets/images/inner-page-banner.png);">
                <div class="container-fluid">
                    <span class="text-animation-word text-h1 text-n100 mb-3">Login</span>
                    <ul class="breadcrumb d-inline-flex align-items-center gap-lg-2 gap-1">
                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                        <li class="breadcrumb-item active"><a href="">Login</a></li>
                    </ul>
                </div>
            </section>
            <!-- hero section end -->

            <!-- login section start -->
            <section class="login-section pt-120 pb-120 px-xl-20 px-lg-10 px-sm-7">
                <div class="container-fluid">
                    <div class="row g-6 justify-content-center">
                        <div class="col-xl-5 col-lg-7 col-md-9">
                            <div class="register-form p-xl-15 p-lg-10 p-md-8 p-6 radius-16 border border-n100-1 bg-n20">
                                <div class="register-logo mb-lg-15 mb-md-10 mb-8 mx-auto">
                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/logo.png" alt="logo">
                                </div>
                                <form action="${pageContext.request.contextPath}/authen?action=login" method="POST" class="d-grid gap-lg-6 gap-4 mb-lg-10 mb-md-8 mb-6">
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Email or Username</label>
                                        <input type="text" name="username" class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" placeholder="Enter Your Email or Username" required>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Enter Password</label>
                                        <div class="d-flex align-items-center py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2">
                                            <input type="password" name="password" class="w-100 border-0" placeholder="Enter Password" required>
                                            <button type="button" class="text-xl password-toggle">
                                                <i class="ph ph-eye-slash"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn-secondary py-lg-4 py-2 px-lg-6 px-4 radius-8 w-100">Login</button>
                                </form>

                                <div class="text-center">
                                    <span class="text-n50">Don't have an account?</span>
                                    <a href="${pageContext.request.contextPath}/authen?action=sign-up" class="text-secondary2 fw-medium">Register</a>
                                </div>
                                <div class="text-center mt-3">
                                    <a href="${pageContext.request.contextPath}/authen?action=enter-email" class="text-secondary2 fw-medium">Forgot Password?</a>
                                </div>
                                <div class="mt-lg-8 mt-6">
                                    <a href="#" class="d-center gap-2 px-lg-8 px-md-6 px-4 py-lg-4 py-2 w-100 radius-8 border border-n100-1 bg-n0 text-n100">
                                        <img src="${pageContext.request.contextPath}/assets/images/google.png" alt="google">
                                        <span>Login with google</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- login section end -->

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
        <!-- Add iziToast JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var toastMessage = "${sessionScope.toastMessage}";
                var toastType = "${sessionScope.toastType}";
                if (toastMessage) {
                    iziToast.show({
                        title: toastType === 'success' ? 'Success' : 'Error',
                        message: toastMessage,
                        position: 'topRight',
                        color: toastType === 'success' ? 'green' : 'red',
                        timeout: 5000,
                        onClosing: function() {
                            fetch('${pageContext.request.contextPath}/remove-toast', {
                                method: 'POST'
                            });
                        }
                    });
                }
            });
        </script>
    </body>

</html>