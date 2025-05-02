/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CancelDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cancel;
import com.swp391.entity.CancelReason;
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
    private CancelDAO cancelDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cancelDAO = new CancelDAO();
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

                // 🔥 Thêm danh sách lý do hủy
                List<CancelReason> cancelReasons = cancelDAO.getAllCancelReasons();
                request.setAttribute("cancelReasons", cancelReasons);
                request.getRequestDispatcher("./view/order/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("history-order?status=false&type=no_found");
            }
        } else {
            response.sendRedirect("history-order?status=false&type=no_order_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            this.cancelOrder(request, response);
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {

        int orderIdR = 0;
        
        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);
            if (account == null) {
                response.sendRedirect("authen?action=login");
                return;
            }

            int userId = account.getUserId();
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String reason = request.getParameter("cancelReason");
            String customReason = request.getParameter("customReason");
            String finalReason = "Other".equals(reason) ? customReason : reason;

            if (finalReason == null || finalReason.trim().isEmpty()) {
                request.setAttribute("toastMessage", "Please provide a reason for cancellation!");
                request.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/order-details?orderid=" + orderId);
                return;
            }

            Order order = this.orderDAO.getOrderById(orderId, userId);
            if (order == null) {
                session.setAttribute("toastMessage",  "Order not found or access denied!");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/user/order-history");
                return;
            }

            String cancelledBy = "customer".equalsIgnoreCase(account.getRole()) ? "customer" : "staff";

            // Tạo đối tượng Cancel
            Cancel cancel = Cancel.builder()
                    .orderId(orderId)
                    .userId(userId)
                    .cancelledBy(cancelledBy)
                    .cancelReason(finalReason)
                    .status(order.getStatus())
                    .total(order.getTotal())
                    .shippingAddress(order.getShippingAddress())
                    .paymentMethod(order.getPaymentMethod())
                    .email(account.getEmail())
                    .fullname(account.getFirstName() + " " + account.getLastName())
                    .phone(account.getPhone())
                    .build();

            boolean saved = this.cancelDAO.insertCancel(cancel);
            boolean updated = this.orderDAO.updateOrderStatus(orderId, "cancelled");
            
            if (saved && updated) {
                request.getSession().setAttribute("toastMessage",  "Order cancelled successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.setAttribute("toastMessage",  "Unable to cancel the order!");
                request.setAttribute("toastType", "error");
            }
            orderIdR = orderId;

        } catch (NumberFormatException e) {
            request.setAttribute("toastMessage",  "Invalid Order ID!");
            request.setAttribute("toastType", "error");
        } catch (Exception e) {
            request.setAttribute("toastMessage",  "An error occurred: " + e.getMessage());
            request.setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/order-details?orderid=" + orderIdR);
    }

}
