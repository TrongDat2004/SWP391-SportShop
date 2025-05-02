package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Voucher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        BigDecimal total = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null)
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("account", account);
        request.setAttribute("total", total);
        request.getRequestDispatcher("./view/product/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            System.err.println("User not logged in during checkout POST, redirecting to login.");
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        if (cartItems == null || cartItems.isEmpty()) {
            System.err.println("Cart is empty during checkout POST for user " + userId + ". Redirecting.");
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        Voucher voucher = (Voucher) session.getAttribute("SESSION_VOUCHER");

        BigDecimal subtotal = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null)
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal discountAmount = BigDecimal.ZERO;
        BigDecimal finalTotal = subtotal;

        if (voucher != null) {
            // TODO: Thêm kiểm tra voucher hợp lệ ở đây nếu cần
            discountAmount = voucher.getDiscountAmount();
            finalTotal = subtotal.subtract(discountAmount);
            if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                finalTotal = BigDecimal.ZERO;
            }
        } else {
            session.removeAttribute("SESSION_VOUCHER");
        }

        Order order = Order.builder()
                .userId(userId)
                .status("pending".equalsIgnoreCase(paymentMethod) ? "pending" : ("cash".equalsIgnoreCase(paymentMethod) ? "pending" : "nopaid")) // Cập nhật status ban đầu
                .total(finalTotal)
                .shippingAddress(shippingAddress)
                .paymentMethod(paymentMethod)
                .email(email)
                .fullname(fullname)
                .phone(phone)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .appliedVoucherId(voucher != null ? voucher.getVoucherId() : null)
                
                .build();

        // Tạo danh sách OrderItem, LẤY productSizeId TỪ Cart item
        List<OrderItem> orderItems = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProductSizeId() != null && item.getProductSizeId() > 0) // Đảm bảo product và sizeId hợp lệ
                .map(item -> OrderItem.builder()
                .orderId(null)
                .productId(item.getProduct().getProductId())
                .productSizeId(item.getProductSizeId()) // <<< LẤY Ở ĐÂY
                .quantity(item.getQuantity())
                .price(item.getProduct().getPrice())
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                // Không cần set Product và ProductSize object ở đây, DAO sẽ không dùng
                .build()
                ).collect(Collectors.toList());

        // Kiểm tra nếu có item nào không hợp lệ bị lọc ra
        if (orderItems.size() != cartItems.size()) {
            System.err.println("Error during checkout: Some cart items were invalid (missing product or sizeId).");
            response.sendRedirect("cart?status=false&type=invalid_item");
            return;
        }

        boolean success = orderDAO.processOrder(order, orderItems, voucher);

        if (!success) {
            System.err.println("Order processing failed for user " + userId + ". Possible stock issue or DB error.");
            // Gửi thông báo lỗi cụ thể hơn nếu có thể, ví dụ dựa vào exception nếu DAO ném ra
            response.sendRedirect("cart?status=false&type=order_fail");
            return;
        }

        cartDAO.clearCartByUserId(userId);
        session.removeAttribute("SESSION_VOUCHER");

        System.out.println("Order placed successfully. Order ID: " + order.getOrderId() + ", Payment Method: " + paymentMethod);

        if ("banking".equalsIgnoreCase(paymentMethod)) {
            session.setAttribute("orderId", order.getOrderId());
            response.sendRedirect("vnpay?action=pay&amount=" + finalTotal);
        } else {
            response.sendRedirect("orderStatus?status=true&orderId=" + order.getOrderId());
        }
    }
}

