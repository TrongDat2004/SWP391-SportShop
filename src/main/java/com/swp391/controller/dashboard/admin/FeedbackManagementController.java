package com.swp391.controller.dashboard.admin;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.FeedbackDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Feedback;
import com.swp391.entity.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * FeedbackManagementController handles the administration of feedback.
 * It allows admins to view, filter, and toggle visibility of feedback.
 */
@WebServlet(name = "FeedbackManagementController", urlPatterns = {"/admin/feedback"})
public class FeedbackManagementController extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays the feedback management page with filters and pagination.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        ProductDAO productDAO = new ProductDAO();

        // Get filter parameters
        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String visibilityStr = request.getParameter("visibility");
        String pageStr = request.getParameter("page");

        // Parse parameters
        Integer productId = productIdStr != null && !productIdStr.isEmpty() ? Integer.parseInt(productIdStr) : null;
        Integer rating = ratingStr != null && !ratingStr.isEmpty() ? Integer.parseInt(ratingStr) : null;
        Boolean visibility = visibilityStr != null ? "true".equals(visibilityStr) : null;
        int page = pageStr != null && !pageStr.isEmpty() ? Integer.parseInt(pageStr) : 1;
        int pageSize = 10;

        // Get filtered feedback with pagination
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks(productId, rating, visibility, page, pageSize);
        int totalFeedbacks = feedbackDAO.countAllFeedbacks(productId, rating, visibility);
        int totalPages = (int) Math.ceil((double) totalFeedbacks / pageSize);

        // Get all products for the filter dropdown
        List<Product> products = productDAO.findAll();

        // Set attributes for the JSP
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("products", products);
        request.setAttribute("selectedProductId", productId);
        request.setAttribute("selectedRating", rating);
        request.setAttribute("selectedVisibility", visibility);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFeedbacks", totalFeedbacks);

        // Forward to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/feedback-management.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Handles actions like toggling visibility of feedback.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        boolean isVisible = Boolean.parseBoolean(request.getParameter("isVisible"));
        
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        
        String message;
        
        if ("toggleVisibility".equals(action)) {
            boolean success = feedbackDAO.changeVisibility(feedbackId, !isVisible);
            message = success ? 
                    "Feedback visibility has been " + (isVisible ? "disabled" : "enabled") + "." : 
                    "Failed to change feedback visibility.";
        } else {
            message = "Unknown action.";
        }
        
        // Redirect back to the feedback management page with the message
        response.sendRedirect(request.getContextPath() + "/admin/feedback?message=" + message);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Manages feedback visibility and filters";
    }
}