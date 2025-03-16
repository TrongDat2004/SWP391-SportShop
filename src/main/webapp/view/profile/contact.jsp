<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contact Us | SportShop</title>
        <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
        <style>
            .contact-section {
                margin-top: 92px;
                text-align: center;
                padding: 50px 20px;
                background: linear-gradient(to right, #007bff, #00c6ff);
                color: white;
                border-radius: 10px;
            }
            .contact h1 {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .contact-info p {
                font-size: 18px;
                margin: 10px 0;
            }
            .contact-info i {
                margin-right: 10px;
            }
            .contact-form {
                max-width: 600px;
                margin: 40px auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }
            .contact-form input, .contact-form textarea {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: none;
                border-radius: 5px;
                box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
            }
            .contact-form button {
                width: 100%;
                padding: 12px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                cursor: pointer;
                transition: 0.3s;
            }
            .contact-form button:hover {
                background: #0056b3;
            }
            .map iframe {
                width: 100%;
                height: 400px;
                border: none;
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
                <section class="contact-section px-xl-20 px-lg-10 px-sm-7 pt-120 pb-120">
                    <h1>Contact Us</h1>
                    <p>Feel free to reach out to us for any inquiries or support.</p>
                    <div class="contact-info">
                        <p><i class="fa fa-map-marker-alt"></i> 600 Nguyễn Văn Cừ, An Bình, Ninh Kiều, Cần Thơ</p>
                        <p><i class="fa fa-phone"></i> 0292 7301 988</p>
                        <p><i class="fa fa-envelope"></i> support@sportshop.com</p>
                    </div>
                </section>
                <div class="contact-form">
                    <h2>Send Us a Message</h2>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        ${success}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        ${error}
                    </div>
                </c:if>

                <form action="contact" method="post">
                    <input type="text" name="name" placeholder="Your Name" required>
                    <input type="email" name="email" placeholder="Your Email" required>
                    <textarea name="message" rows="4" placeholder="Your Message" required></textarea>
                    <button type="submit">Send Message</button>
                </form>
            </div>
            <section class="map">
                <iframe src="https://www.google.com/maps/embed?..." allowfullscreen loading="lazy"></iframe>
            </section>
        </main>
        <jsp:include page="../common/home/footer.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>