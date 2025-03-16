/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.VoucherDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart;
import com.swp391.entity.CartItem;
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
import java.util.List;

/**
 *
 * @author HP
 */
@WebServlet(name = "CheckVoucherController", urlPatterns = {"/check-voucher"})
public class CheckVoucherController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        // If the user is not logged in, return JSON error response
        if (account == null) {
            out.print("{\"success\": false, \"message\": \"You are not logged in!\", \"redirect\": \"authen?action=login\"}");
            out.flush();
            return;
        }

        int userId = account.getUserId();
        CartDAO cartDao = new CartDAO();
        Cart cart = cartDao.getCartByUserId(userId);

        // If the cart does not exist, return JSON error response
        if (cart == null) {
            out.print("{\"success\": false, \"message\": \"Your cart is empty!\"}");
            out.flush();
            return;
        }

        List<CartItem> cartItems = cartDao.getCartItems(cart.getCartId());

        if (cartItems == null || cartItems.isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Your cart is empty!\"}");
            out.flush();
            return;
        }

        BigDecimal totalAmount = cartItems.stream()
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        String voucherCode = request.getParameter("voucherCode");
        VoucherDAO voucherDAO = new VoucherDAO();
        double discountAmount = 0;
        boolean isValidVoucher = false;

        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            boolean isValid = voucherDAO.isValidVoucher(voucherCode);
            if (isValid) {
                Voucher voucher = voucherDAO.findByCode(voucherCode);
                boolean hasUsed = voucherDAO.hasUsedVoucher(userId, voucher.getVoucherId());

                if (!hasUsed) {
                    discountAmount = voucher.getDiscountAmount().doubleValue();
                    session.setAttribute("SESSION_VOUCHER", voucher); 
                    isValidVoucher = true;
                } else {
                    session.removeAttribute("SESSION_VOUCHER"); 
                }
            } else {
                session.removeAttribute("SESSION_VOUCHER"); 
            }
        }

        double finalTotal = totalAmount.doubleValue() - discountAmount;

        // Return JSON response
        out.print("{"
                + "\"success\": true,"
                + "\"originalTotal\": " + totalAmount + ","
                + "\"discount\": " + discountAmount + ","
                + "\"finalTotal\": " + finalTotal + ","
                + "\"voucherApplied\": " + isValidVoucher + ","
                + "\"message\": \"" + (isValidVoucher ? "Voucher applied successfully!" : "No valid voucher applied.") + "\""
                + "}");

        out.flush();
    }
}
