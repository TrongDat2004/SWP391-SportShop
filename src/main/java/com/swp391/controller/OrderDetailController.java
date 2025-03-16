/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author HP
 */
@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-details"})
public class OrderDetailController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        String idParam = request.getParameter("orderid");
        if (idParam != null) {
            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.getOrderById(orderId, userId);
            if (order != null) {
                List<OrderItem> details = orderDAO.getOrderItemsByOrderId(orderId);
                request.setAttribute("order", order);
                request.setAttribute("details", details);
                request.getRequestDispatcher("./view/order/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("history-order?status=false&type=no_found");
            }
        } else {
            response.sendRedirect("history-order?status=false&type=no_order_id");
        }
    }

}
