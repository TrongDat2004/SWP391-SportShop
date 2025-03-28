<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="assets/images/favi.jpg" sizes="16x16">
        <title>SportShop | Your Hub for Quality Sports Equipment, Gear, and Accessories</title>
        <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            /* === About Section === */
            .about-section {
                text-align: center;
                padding: 60px 20px;
                background: linear-gradient(to right, #007bff, #00c6ff);
                color: white;
                border-radius: 10px;
            }
            .about-section h1 {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 20px;
            }

            /* === Team Section === */
            .team-section {
                padding: 60px 20px;
            }
            .team-section h2 {
                font-size: 2rem;
                font-weight: bold;
                color: #007bff;
                margin-bottom: 40px;
            }

            /* === Team Member Cards === */
            .team-member {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease-in-out;
            }
            .team-member:hover {
                transform: translateY(-10px);
            }
            .team-member img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                border: 4px solid #007bff;
                margin-bottom: 15px;
            }
            .team-member h5 {
                font-size: 1.2rem;
                font-weight: bold;
            }
            .team-member p {
                color: #6c757d;
            }
        </style>
    </head>
    <body>
        <!-- Back to top button -->
        <button class="back-to-top position-fixed end-0 bottom-0 d-center me-5">
            <span class="text-h4">
                <i class="ph ph-arrow-up"></i>
            </span>
        </button>

        <!-- Include header -->
        <jsp:include page="../common/home/header.jsp"></jsp:include>
        <jsp:include page="../common/home/cartbox.jsp"></jsp:include>

            <main class="pt-12">
                <section class="product-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                    <div class="about-section">
                        <h1>About Us</h1>
                        <p>Welcome to our center! We specialize in providing high-quality services with dedication and innovation.</p>
                    </div>

                    <div class="team-section text-center">
                        <h2>Our Team</h2>
                        <div class="row mt-4">
                            <div class="col-md-6 team-member">
                                <img src="assets/images/dat.png" alt="Team Member">
                                <h5>Nguyễn Hồ Trọng Đạt</h5>
                                <p>Manager</p>
                            </div>
                            <div class="col-md-6 team-member">
                                <img src="assets/images/thien.jpg" alt="Team Member">
                                <h5>Trần Phúc Thiện</h5>
                                <p>Developer</p>
                            </div>
                            <div class="col-md-6 team-member mt-4">
                                <img src="assets/images/anh.jpg" alt="Team Member">
                                <h5>Nguyễn Loan Anh</h5>
                                <p>Developer</p>
                            </div>
                            <div class="col-md-6 team-member mt-4">
                                <img src="assets/images/phuc.jpg" alt="Team Member">
                                <h5>Trương Hoàng Phúc</h5>
                                <p>Developer</p>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Include footer -->
        <jsp:include page="../common/home/footer.jsp"></jsp:include>

            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>