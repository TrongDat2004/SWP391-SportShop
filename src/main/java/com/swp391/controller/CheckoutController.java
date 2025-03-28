/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart;
import com.swp391.entity.CartItem;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Voucher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author HP
 */
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
        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            response.sendRedirect("cart?status=false&type=empty_checkout");
        }

        List<CartItem> cartItems = (cart != null) ? cartDAO.getCartItems(cart.getCartId()) : null;

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        BigDecimal total = cartItems.stream()
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

        if (account != null) {
            System.out.println("User is logged in: " + account.getUsername());
        } else {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            response.sendRedirect("cart?status=false&type=empty_checkout");
        }

        List<CartItem> cartItems = (cart != null) ? cartDAO.getCartItems(cart.getCartId()) : null;

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        Voucher voucher = (Voucher) session.getAttribute("SESSION_VOUCHER");
        
        // Tính tổng tiền
        BigDecimal total = cartItems.stream()
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal discountAmount = BigDecimal.ZERO;

        if (voucher != null) {
            discountAmount = voucher.getDiscountAmount();
            total = total.subtract(discountAmount);
        }
        // Tạo đơn hàng với thông tin đầy đủ
        Order order = Order.builder()
                .userId(userId)
                .status("pending")
                .total(total)
                .shippingAddress(shippingAddress)
                .paymentMethod(paymentMethod)
                .email(email)
                .fullname(fullname)
                .phone(phone)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        // Tạo danh sách sản phẩm trong đơn hàng
        List<OrderItem> orderItems = cartItems.stream().map(item
                -> OrderItem.builder()
                        .orderId(null) 
                        .productId(item.getProduct().getProductId())
                        .quantity(item.getQuantity())
                        .price(item.getProduct().getPrice())
                        .createdAt(LocalDateTime.now())
                        .updatedAt(LocalDateTime.now())
                        .build()
        ).collect(Collectors.toList());

        boolean success = orderDAO.processOrder(order, orderItems, voucher);

        if (!success) {
            response.sendRedirect("cart?status=false&type=order_fail");
            return;
        }

        cartDAO.clearCartByUserId(userId);
        if (paymentMethod.equals("banking")) {
            session.setAttribute("orderId", order.getOrderId());
            response.sendRedirect("vnpay?action=pay&amount=" + total);
        } else {
            response.sendRedirect("orderStatus?status=true&orderId=" + order.getOrderId());
        }
    }

}
