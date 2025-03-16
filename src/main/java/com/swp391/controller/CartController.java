/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart;
import com.swp391.entity.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account != null) {
            System.out.println("User is logged in: " + account.getUsername());
        } else {
            response.sendRedirect("authen?action=login");
            return;
        }
        int userId = account.getUserId();
        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            cart = cartDAO.createCart(userId);
        }
        boolean success = false;
        action = action != null ? action : "";
        String type = "";
        switch (action) {
            case "add":
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                success = cartDAO.addItemToCart(cart.getCartId(), productId, quantity);
                type = "add";
                break;

            case "update":
                int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                int newQuantity = Integer.parseInt(request.getParameter("quantity"));

                CartItem cartItem = cartDAO.getCartItemById(cartItemId);
                if (cartItem != null) {
                    int stock = cartItem.getProduct().getStock();
                    if (newQuantity > stock) {
                        success = false;
                    } else {
                        success = cartDAO.updateItemQuantity(cartItemId, newQuantity);
                    }
                }
                type = "update";
                break;

            case "delete":
                int deleteItemId = Integer.parseInt(request.getParameter("cartItemId"));
                success = cartDAO.removeItemFromCart(deleteItemId);
                type = "delete";
                break;

            case "clear":
                success = cartDAO.clearCart(cart.getCartId());
                type = "clear";
                break;
            default:
                List<CartItem> cartItems = (cart != null) ? cartDAO.getCartItems(cart.getCartId()) : null;

                request.setAttribute("cartItems", cartItems);
                request.getRequestDispatcher("./view/product/cart.jsp").forward(request, response);
                break;
        }
        if (!success) {
            type = "stock";
            success = false;
        }
        response.sendRedirect("cart?status=" + success + "&type=" + type);
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
        List<CartItem> cartItems = (cart != null) ? cartDAO.getCartItems(cart.getCartId()) : null;

        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("./view/product/cart.jsp").forward(request, response);
    }
}
