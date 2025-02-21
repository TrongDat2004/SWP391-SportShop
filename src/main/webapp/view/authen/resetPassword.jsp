<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description"
            content="CycleCity offers a wide range of bicycles, gear, and accessories for every type of cyclist. Explore our collection and gear up for your next adventure!">
        <meta name="keywords"
            content="bicycles, bikes, cycling gear, bike accessories, mountain bikes, road bikes, CycleCity">
        <meta name="author" content="CycleCity Team">

        <meta property="og:title" content="CycleCity | Quality Bicycles and Cycling Gear">
        <meta property="og:description"
            content="Discover the best selection of bicycles, gear, and accessories at CycleCity. Shop now for top brands and quality service.">
        <meta property="og:image" content="${pageContext.request.contextPath}/assets/images/logo.png">
        <meta property="og:url" content="">
        <meta property="og:type" content="website">

        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="CycleCity | Quality Bicycles and Cycling Gear">
        <meta name="twitter:description"
            content="Explore the latest in bicycles, cycling gear, and accessories at CycleCity. Gear up for your next adventure!">
        <meta name="twitter:image" content="${pageContext.request.contextPath}/assets/images/logo.png">
        <meta name="twitter:site" content="@CycleCity">

        <title>CycleCity | Reset Password</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.png"
            type="image/x-icon">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <style>
            .iziToast-wrapper {
                z-index: 99999 !important;
            }

            .iziToast {
                min-width: 300px;
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

        <!-- include header -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>

        <!-- mouse -->
        <div class="cursor"></div>
        <div class="cursor-follower"></div>

        <!-- main start -->
        <main class="pt-12">
            <!-- hero section start -->
            <section class="inner-hero-section px-xl-20 px-lg-10 px-sm-7"
                style="background-image: url(assets/images/inner-page-banner.png);">
                <div class="container-fluid">
                    <span class="text-animation-word text-h1 text-n100 mb-3">Reset Password</span>
                    <ul class="breadcrumb d-inline-flex align-items-center gap-lg-2 gap-1">
                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                        <li class="breadcrumb-item active"><a href="">Reset Password</a></li>
                    </ul>
                </div>
            </section>
            <!-- hero section end -->

            <!-- reset password section start -->
            <section class="login-section pt-120 pb-120 px-xl-20 px-lg-10 px-sm-7">
                <div class="container-fluid">
                    <div class="row g-6 justify-content-center">
                        <div class="col-xl-5 col-lg-7 col-md-9">
                            <div class="register-form p-xl-15 p-lg-10 p-md-8 p-6 radius-16 border border-n100-1 bg-n20">
                                <div class="register-logo mb-lg-15 mb-md-10 mb-8 mx-auto">
                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/logo.png"
                                        alt="logo">
                                </div>
                                <form action="${pageContext.request.contextPath}/authen?action=reset-password"
                                    method="POST" class="d-grid gap-lg-6 gap-4 mb-lg-10 mb-md-8 mb-6">
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">New Password</label>
                                        <div
                                            class="d-flex align-items-center py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2">
                                            <input type="password" name="newPassword" class="w-100 border-0"
                                                placeholder="Enter New Password" required>
                                            <button type="button" class="text-xl password-toggle">
                                                <i class="ph ph-eye-slash"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Confirm
                                            Password</label>
                                        <div
                                            class="d-flex align-items-center py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2">
                                            <input type="password" name="confirmPassword" class="w-100 border-0"
                                                placeholder="Confirm Password" required>
                                            <button type="button" class="text-xl password-toggle">
                                                <i class="ph ph-eye-slash"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button type="submit"
                                        class="btn-secondary py-lg-4 py-2 px-lg-6 px-4 radius-8 w-100">Reset
                                        Password</button>
                                </form>

                                <div class="text-center">
                                    <span class="text-n50">Remember your password?</span>
                                    <a href="${pageContext.request.contextPath}/authen?action=login"
                                        class="text-secondary2 fw-medium">Login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- reset password section end -->

            <!-- ... existing gallery slider and call to action sections ... -->
        </main>
        <!-- main end -->

        <!-- footer section -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>

        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
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