<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="cart-box">
            <div class="cart-box-overlay"></div>
            <div class="cart-content-wrapper">
                <div class="position-relative overflow-hidden h-100">
                    <div class="cart-box-top">
                        <!-- title and close button -->
                        <div class="d-between gap-3 py-3xl-5 py-lg-3 py-2 px-xl-8 px-md-6 px-4">
                            <span class="text-n100 text-base fw-semibold">Shopping Cart (1)</span>
                            <button class="cart-close-btn text-xl">
                                <i class="ph ph-x"></i>
                            </button>
                        </div>
                        <!-- free shipping progress -->
                        <div class="free-shipping-progress py-3xl-5 py-lg-3 py-2 px-xl-8 px-md-6 px-4 bg-n20  mb-4xl-10 mb-lg-8 mb-md-6 mb-4">
                            <div class="progress-bar">
                                <div class="progress-bar-inner" style="width: 50%;">
                                    <span class="car-icon">
                                        <i class="ph ph-truck"></i>
                                    </span>
                                </div>
                            </div>
                            <!-- <span class="text-n100 text-sm fw-normal">Spend $100.00 more to enjoy <span class="text-secondary2">FREE
                                         SHIPPING!</span></span> -->
                            <span class="text-n100 text-sm fw-normal">Spend $53.00 more to enjoy <span class="text-secondary2">FREE
                                    SHIPPING!</span></span>
                            <!-- <span class="text-n100 text-sm fw-normal">Congratulations! You've got <span class="text-secondary2">FREE
                                         SHIPPING!</span></span> -->
                        </div>
                    </div>
                    <div class="cart-box-bottom">
                        <!-- cart items -->
                        <div class="cart-items-wrapper">
                            <div class="cart-items  d-flex flex-column gap-lg-6 gap-4 px-xl-8 px-md-6 px-4">
                                <div class="cart-item d-flex justify-content-between gap-4">
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="cart-item-thumb">
                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/review-img-1.png" alt="cart item">
                                        </div>
                                        <div class="cart-item-info">
                                            <span class="d-block text-n100 text-base fw-medium">Giant Defy Advanced</span>
                                            <span class="d-block text-n100 text-sm">Green / S2</span>
                                            <span class="d-block text-secondary2 text-base my-lg-2 my-1">$299.00 </span>
                                            <!-- select product quantity -->
                                            <div class="quantity d-inline-flex align-items-center py-1 px-2 border border-n100-1 bg-n20 radius-4">
                                                <button class="quantityDecrement text-n100"><i class="ph ph-minus"></i></button>
                                                <input type="text" value="1" class="quantityValue border-0 p-0 outline-0 bg-n20">
                                                <button class="quantityIncrement text-n100"><i class="ph ph-plus"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-column gap-1 align-items-baseline justify-content-start">
                                        <button class="cart-item-remove text-xl">
                                            <i class="ph ph-trash"></i>
                                        </button>
                                        <button class="cart-item-edit text-xl">
                                            <i class="ph ph-pencil-simple-line"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="cart-item d-flex justify-content-between gap-4">
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="cart-item-thumb">
                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/review-img-1.png" alt="cart item">
                                        </div>
                                        <div class="cart-item-info">
                                            <span class="d-block text-n100 text-base fw-medium">Giant Defy Advanced</span>
                                            <span class="d-block text-n100 text-sm">Green / S2</span>
                                            <span class="d-block text-secondary2 text-base my-lg-2 my-1">$299.00 </span>
                                            <!-- select product quantity -->
                                            <div class="quantity d-inline-flex align-items-center py-1 px-2 border border-n100-1 bg-n20 radius-4">
                                                <button class="quantityDecrement text-n100"><i class="ph ph-minus"></i></button>
                                                <input type="text" value="1" class="quantityValue border-0 p-0 outline-0 bg-n20">
                                                <button class="quantityIncrement text-n100"><i class="ph ph-plus"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-column gap-1 align-items-baseline justify-content-start">
                                        <button class="cart-item-remove text-xl">
                                            <i class="ph ph-trash"></i>
                                        </button>
                                        <button class="cart-item-edit text-xl">
                                            <i class="ph ph-pencil-simple-line"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="cart-item d-flex justify-content-between gap-4">
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="cart-item-thumb">
                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/review-img-1.png" alt="cart item">
                                        </div>
                                        <div class="cart-item-info">
                                            <span class="d-block text-n100 text-base fw-medium">Giant Defy Advanced</span>
                                            <span class="d-block text-n100 text-sm">Green / S2</span>
                                            <span class="d-block text-secondary2 text-base my-lg-2 my-1">$299.00 </span>
                                            <!-- select product quantity -->
                                            <div class="quantity d-inline-flex align-items-center py-1 px-2 border border-n100-1 bg-n20 radius-4">
                                                <button class="quantityDecrement text-n100"><i class="ph ph-minus"></i></button>
                                                <input type="text" value="1" class="quantityValue border-0 p-0 outline-0 bg-n20">
                                                <button class="quantityIncrement text-n100"><i class="ph ph-plus"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-column gap-1 align-items-baseline justify-content-start">
                                        <button class="cart-item-remove text-xl">
                                            <i class="ph ph-trash"></i>
                                        </button>
                                        <button class="cart-item-edit text-xl">
                                            <i class="ph ph-pencil-simple-line"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="cart-item d-flex justify-content-between gap-4">
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="cart-item-thumb">
                                            <img class="w-100" src="${pageContext.request.contextPath}/assets/images/review-img-1.png" alt="cart item">
                                        </div>
                                        <div class="cart-item-info">
                                            <span class="d-block text-n100 text-base fw-medium">Giant Defy Advanced</span>
                                            <span class="d-block text-n100 text-sm">Green / S2</span>
                                            <span class="d-block text-secondary2 text-base my-lg-2 my-1">$299.00 </span>
                                            <!-- select product quantity -->
                                            <div class="quantity d-inline-flex align-items-center py-1 px-2 border border-n100-1 bg-n20 radius-4">
                                                <button class="quantityDecrement text-n100"><i class="ph ph-minus"></i></button>
                                                <input type="text" value="1" class="quantityValue border-0 p-0 outline-0 bg-n20">
                                                <button class="quantityIncrement text-n100"><i class="ph ph-plus"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="d-flex flex-column gap-1 align-items-baseline justify-content-start">
                                        <button class="cart-item-remove text-xl">
                                            <i class="ph ph-trash"></i>
                                        </button>
                                        <button class="cart-item-edit text-xl">
                                            <i class="ph ph-pencil-simple-line"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="cart-box-form">
                            <!-- cart actions -->
                            <span class="d-block border-bottom border-n100-1 my-4"></span>
                            <div class="cart-actions d-flex align-items-center justify-content-around px-lg-20">
                                <button class="add-note text-xl tooltip-btn tooltip-top position-relative" data-tooltip="Add Note">
                                    <i class="ph ph-notepad"></i>
                                </button>
                                <button class="add-gift-wrap text-xl tooltip-btn tooltip-top position-relative" data-tooltip="Add Gift">
                                    <i class="ph ph-gift"></i>
                                </button>
                                <button class="add-estimate text-xl tooltip-btn tooltip-top position-relative" data-tooltip="Estimate Shipping">
                                    <i class="ph ph-calculator"></i>
                                </button>
                            </div>

                            <!-- note form start-->
                            <form action="#" class="note-form-wrapper p-xl-8 p-md-6 p-4 bg-n0">
                                <span class="d-flex align-items-center gap-2 text-n100 text-base fw-medium mb-4">
                                    <span class="d-flex text-xl"><i class="ph-fill ph-note-pencil"></i></span> Add order
                                    note</span>
                                <textarea class="note-form border-n100-1 p-4 w-100" rows="3" placeholder="Add Note"></textarea>
                                <button type="submit" class="text-base fw-bold text-n100 bg-n0 hover-text-n0 hover-bg-secondary2 py-3 px-lg-5 px-3 border border-n100-1 w-100 mt-4">
                                    Save Note
                                </button>
                                <button type="reset" class="note-cancel-btn text-base fw-bold text-n100 bg-n0 hover-text-n0 hover-bg-secondary2 py-3 px-lg-5 px-3 border border-n100-1 w-100 mt-4">
                                    Cancel
                                </button>
                            </form>
                            <!-- note form end -->

                            <!-- gift wrap start -->
                            <form action="#" class="gift-form-wrapper p-xl-8 p-md-6 p-4 bg-n0">
                                <span class="d-center text-xl mb-3"><i class="ph-fill ph-gift"></i></span>
                                <span class="d-block text-sm text-center">
                                    Please wrap the product carefully. Fee is only $5.00. (You can choose or not)
                                </span>
                                <button type="submit" class="text-base fw-bold text-n100 bg-n0 hover-text-n0 hover-bg-secondary2 py-3 px-lg-5 px-3 border border-n100-1 w-100 mt-4">
                                    Add a Gift Wrap
                                </button>
                                <button type="reset" class="gift-cancel-btn text-base fw-bold text-n100 bg-n0 hover-text-n0 hover-bg-secondary2 py-3 px-lg-5 px-3 border border-n100-1 w-100 mt-4">
                                    Cancel
                                </button>
                            </form>
                            <!-- gift wrap end -->
                            <span class="d-block border-bottom border-n100-1 mt-4"></span>

                            <div class="checkout-wrapper p-xl-8 p-md-6 p-4 bg-n20">
                                <!-- cart total -->
                                <div class="cart-total-wrapper mb-xxl-6 mb-4">
                                    <div class="cart-total d-flex justify-content-between">
                                        <span class="text-n100 text-base fw-medium">Subtotal</span>
                                        <span class="text-n100 text-base fw-medium">$299.00</span>
                                    </div>
                                    <div class="cart-total d-flex justify-content-between">
                                        <span class="text-n100 text-base fw-medium">Shipping</span>
                                        <span class="text-n100 text-base fw-medium">$0.00</span>
                                    </div>
                                </div>
                                <div>
                                    <label class="input-checkbox mb-lg-6 mb-4">
                                        <input type="checkbox" hidden="">
                                        <span class="checkbox"></span>
                                        <span class="text-base text-n50">I agree with <a href="terms-conditions.html" class="text-decoration-underline">Terms &
                                                Conditions</a></span>
                                    </label>
                                    <div class="d-grid gap-4">
                                        <a href="cart.html" class="d-block text-center text-n100 fw-medium py-lg-3 py-2 px-lg-6 px-4 border border-n100 bg-n0 hover-text-n0 hover-bg-n100">View
                                            Cart</a>
                                        <a href="checkout.html" class="d-block text-center text-n0 fw-medium py-lg-3 py-2 px-lg-6 px-4 border-0 bg-secondary2 hover-text-n0 hover-bg-n100">Checkout</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>