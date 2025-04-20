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

        <title>SportShop | Register</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favi.jpg" type="image/x-icon">
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">

        <style>
            .error-message {
                color: red;
                font-size: 0.8em;
                margin-top: 5px;
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
        <!-- header -->

        <!-- header section start -->
        <jsp:include page="/view/common/home/header.jsp" />
        <!-- header section end -->

        <!-- cart box -->
        <jsp:include page="/view/common/home/cartbox.jsp" />
        <!-- cart box -->
        <!-- main start -->
        <main style="padding-top: 140px;">

            <!-- hero section start -->
            <section class="inner-hero-section px-xl-20 px-lg-10 px-sm-7" style="background-image: url(${pageContext.request.contextPath}/assets/images/inner-page-banner.png);">
                <div class="container-fluid">
                    <span class="text-animation-word text-h1 text-n100 mb-3">Register</span>
                    <ul class="breadcrumb d-inline-flex align-items-center gap-lg-2 gap-1">
                        <li class="breadcrumb-item"><a href="home">Home</a></li>
                        <li class="breadcrumb-item active"><a href="">Register</a></li>
                    </ul>
                </div>
            </section>
            <!-- hero section end -->

            <!-- register section start -->
            <section class="register-section pt-120 pb-120 px-xl-20 px-lg-10 px-sm-7">
                <div class="container-fluid">
                    <div class="row g-6 justify-content-center">
                        <div class="col-xl-5 col-lg-7 col-md-9">
                            <div class="register-form p-xl-15 p-lg-10 p-md-8 p-6 radius-16 border border-n100-1 bg-n20">
                                <div class="register-logo mb-lg-15 mb-md-10 mb-8 mx-auto">
                                    <img class="w-100" src="${pageContext.request.contextPath}/assets/images/logof.jpg" alt="logo">
                                </div>
                                <form action="${pageContext.request.contextPath}/authen?action=sign-up" method="POST" class="d-grid gap-lg-6 gap-4 mb-lg-10 mb-md-8 mb-6" onsubmit="return validateForm()">
                                    <!-- Hiển thị thông báo lỗi -->
                                    <% String errorMessage = (String) request.getAttribute("errorMessage");
                                       if (errorMessage != null) { %>
                                        <div class="alert alert-danger">
                                            <%= errorMessage %>
                                        </div>
                                    <% } %>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Username</label>
                                        <input type="text" name="username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" 
                                               class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" 
                                               placeholder="Enter Your Username" required>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">First Name</label>
                                        <input type="text" name="firstName" value="<%= request.getAttribute("firstName") != null ? request.getAttribute("firstName") : "" %>" 
                                               class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" 
                                               placeholder="Enter Your First Name" required>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Last Name</label>
                                        <input type="text" name="lastName" value="<%= request.getAttribute("lastName") != null ? request.getAttribute("lastName") : "" %>" 
                                               class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" 
                                               placeholder="Enter Your Last Name" required>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Gender</label>
                                        <select name="gender" class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" required>
                                            <option value="true" <%= "true".equals(request.getAttribute("gender")) ? "selected" : "" %>>Male</option>
                                            <option value="false" <%= "false".equals(request.getAttribute("gender")) ? "selected" : "" %>>Female</option>
                                        </select>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Email</label>
                                        <input type="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" 
                                               class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" 
                                               placeholder="Enter Your Email" required>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Mobile</label>
                                        <input type="tel" name="mobile" value="<%= request.getAttribute("mobile") != null ? request.getAttribute("mobile") : "" %>" 
                                               class="py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2" 
                                               placeholder="Enter Your Mobile Number" required>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Password</label>
                                        <div class="d-flex align-items-center py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2">
                                            <input type="password" name="password" class="w-100 border-0" placeholder="Enter Password" required>
                                            <button type="button" class="text-xl password-toggle">
                                                <i class="ph ph-eye-slash"></i>
                                            </button>
                                        </div>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <div class="d-grid gap-lg-4 gap-2">
                                        <label class="text-n100 font-noto-sans text-base fw-normal">Confirm Password</label>
                                        <div class="d-flex align-items-center py-lg-4 py-2 px-lg-6 px-4 w-100 bg-n0 text-n100 radius-8 border border-n100-1 focus-secondary2">
                                            <input type="password" name="confirmPassword" class="w-100 border-0" placeholder="Confirm Password" required>
                                            <button type="button" class="text-xl password-toggle">
                                                <i class="ph ph-eye-slash"></i>
                                            </button>
                                        </div>
                                        <span class="error-message" style="display: none;"></span>
                                    </div>
                                    <button type="submit" class="btn-secondary py-lg-4 py-2 px-lg-6 px-4 radius-8 w-100">Register</button>
                                </form>

                                <div class="text-center mb-lg-4 mb-2">
                                    <span class="text-n50">Already have an account?</span>
                                    <a href="${pageContext.request.contextPath}/authen?action=login" class="text-secondary2 fw-medium">Login</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- main end -->

        <!-- footer section -->
        <!-- footer section start -->
        <jsp:include page="/view/common/home/footer.jsp" />
        <!-- footer section end -->
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>
    </body>
</html>