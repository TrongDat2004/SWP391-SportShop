/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.FeedbackDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Feedback;
import com.swp391.entity.Order;
import com.swp391.entity.Product;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * FeedbackController handles user feedback submissions for orders and products.
 */
@WebServlet(name = "FeedbackController", urlPatterns = {"/feedback"})
public class FeedbackController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FeedbackController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FeedbackController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderid"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();

        OrderDAO orderDAO = new OrderDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        ProductDAO productDao = new ProductDAO();
        Product product = productDao.findActiveById(productId);
        Order order = orderDAO.getOrderById(orderId, userId);

        if (product == null) {
            response.sendRedirect("history-order?error=This product no longer exists.");
            return;
        }

        if (order == null || !"completed".equals(order.getStatus())) {
            response.sendRedirect("history-order?error=Invalid order");
            return;
        }

        Feedback existingFeedback = feedbackDAO.getFeedbackByOrderAndProduct(orderId, productId);
        request.setAttribute("product", product);
        request.setAttribute("orderId", orderId);
        request.setAttribute("order", order);
        request.setAttribute("productId", productId);
        request.setAttribute("feedback", existingFeedback);
        RequestDispatcher dispatcher = request.getRequestDispatcher("./view/order/feedback.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");
        ProductDAO productDao = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Product product = productDao.findActiveById(productId);
        Order order = orderDAO.getOrderById(orderId, userId);

        if (product == null) {
            response.sendRedirect("history-order?error=This product no longer exists.");
            return;
        }

        if (order == null || !"completed".equalsIgnoreCase(order.getStatus())) {
            response.sendRedirect("history-order?error=You can only review completed orders.");
            return;
        }

        boolean hasPurchased = orderDAO.hasPurchasedProduct(orderId, productId);
        if (!hasPurchased) {
            response.sendRedirect("history-order?error=You cannot review a product you have not purchased.");
            return;
        }

        Feedback existingFeedback = feedbackDAO.getFeedbackByOrderAndProduct(orderId, productId);
        Timestamp now = new Timestamp(System.currentTimeMillis());

        if (existingFeedback == null) {
            Feedback newFeedback = Feedback.builder()
                    .feedbackId(0)
                    .userId(userId)
                    .orderId(orderId)
                    .productId(productId)
                    .content(content)
                    .rating(rating)
                    .isVisible(true)
                    .createdAt(now)
                    .updatedAt(now)
                    .build();
            feedbackDAO.addFeedback(newFeedback);
        } else {
            existingFeedback.setContent(content);
            existingFeedback.setRating(rating);
            feedbackDAO.updateFeedback(existingFeedback);
        }

        response.sendRedirect("history-order?success=Feedback has been saved.");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles feedback submission and retrieval.";
    }

}
