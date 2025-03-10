/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.entity.Account;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author HP
 */
@WebServlet(name="CartCountController", urlPatterns={"/cart-count"})
public class CartCountController extends HttpServlet {
   
     private CartDAO cartDAO = new CartDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Account account = (Account) request.getSession().getAttribute(GlobalConfig.SESSION_ACCOUNT);
        int count = 0;

        if (account != null) {
            count = cartDAO.getCartProductCount(account.getUserId()); 
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"count\": " + count + "}");
    }
}
