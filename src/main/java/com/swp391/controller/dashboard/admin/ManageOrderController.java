/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import com.swp391.entity.Account; // Import Account
import com.swp391.config.GlobalConfig; // Import GlobalConfig
import com.swp391.dal.impl.CancelDAO;
import com.swp391.entity.Cancel;
import com.swp391.entity.CancelReason;
import jakarta.servlet.http.HttpSession; // Import HttpSession

@WebServlet(name = "ManageOrderController", urlPatterns = {"/admin/manage-order"})
public class ManageOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO(); // Khởi tạo DAO
    private final CancelDAO cancelDAO = new CancelDAO(); // Thêm DAO cho cancel

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "list" : action; // Default action

        switch (action) {
            case "order-details":
                viewOrderDetail(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // Thêm xử lý action nếu có form khác
        action = (action == null) ? "updateStatus" : action;

        switch (action) {
            case "updateStatus": // Action mặc định nếu không có action param
                updateOrderStatus(request, response);
                break;
            // Thêm các case khác nếu cần
            default:
                listOrders(request, response); // Hoặc trả về lỗi
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 10; // Số lượng đơn hàng trên mỗi trang
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1; // Reset về trang 1 nếu param không hợp lệ
            }
        }

        int offset = (page - 1) * pageSize;

        List<Order> orders = orderDAO.getAllOrdersAdmin(search, statusFilter, offset, pageSize);
        int totalOrders = orderDAO.getTotalOrderCountAdmin(search, statusFilter);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        // Lấy account hiện tại để không hiển thị đơn của chính admin (nếu cần)
        HttpSession session = request.getSession();
        Account currentAdmin = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        request.setAttribute("orders", orders);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("search", search); // Giữ lại giá trị tìm kiếm
        request.setAttribute("statusFilter", statusFilter); // Giữ lại giá trị lọc status
        request.setAttribute("currentAdmin", currentAdmin); // Truyền admin hiện tại

        request.getRequestDispatcher("../view/admin/orderList.jsp").forward(request, response);
    }

    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("orderid");
        String redirectUrl = request.getContextPath() + "/admin/manage-order"; // Default redirect về list
        String message = "";
        String type = "error";

        if (idParam != null) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.getOrderByIdAdmin(orderId); // DAO đã sửa để lấy đúng
                if (order != null) {
                    // DAO đã sửa để lấy item kèm size
                    List<OrderItem> details = orderDAO.getOrderItemsByOrderId(orderId);

                    // ===== Thêm đoạn này để lấy lý do hủy =====
                    List<CancelReason> cancelReasons = cancelDAO.getAllCancelReasons();
                request.setAttribute("cancelReasons", cancelReasons);
                    // =========================================
                    request.setAttribute("order", order);
                    request.setAttribute("details", details);
                    request.getRequestDispatcher("../view/admin/order-detail.jsp").forward(request, response);
                    return; // Dừng thực thi vì đã forward
                } else {
                    message = "Order not found.";
                }
            } catch (NumberFormatException e) {
                message = "Invalid order ID format.";
            } catch (Exception e) {
                message = "Error retrieving order details: " + e.getMessage();
                e.printStackTrace();
            }
        } else {
            message = "Order ID is missing.";
        }

        // Nếu có lỗi hoặc không tìm thấy, set session và redirect
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
        response.sendRedirect(redirectUrl);
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        String reason = request.getParameter("reason"); // Lý do hủy
        String customReason = request.getParameter("customReason");
        String redirectUrl = request.getContextPath() + "/admin/manage-order"; // Default về list
        String message = "Failed to update order status.";
        String type = "error";

        try {
            int orderId = Integer.parseInt(orderIdStr);

            if ("cancelled".equals(status)) {
                // Lấy thông tin đơn hàng
                Order order = orderDAO.getOrderByIdAdmin(orderId);
                if (order == null) {
                    message = "Order not found!";
                    request.getSession().setAttribute("toastMessage", message);
                    request.getSession().setAttribute("toastType", type);
                    response.sendRedirect(redirectUrl);
                    return;
                }

                // Xử lý lý do hủy
                String finalReason = "Other".equals(reason) ? customReason : reason;

                // Tạo đối tượng Cancel
                Cancel cancel = Cancel.builder()
                        .orderId(orderId)
                        .userId(order.getUserId())
                        .cancelledBy("admin") // Vì admin thực hiện hủy
                        .cancelReason(finalReason)
                        .status(order.getStatus())
                        .total(order.getTotal())
                        .shippingAddress(order.getShippingAddress())
                        .paymentMethod(order.getPaymentMethod())
                        .email(order.getEmail())
                        .fullname(order.getFullname())
                        .phone(order.getPhone())
                        .build();

                // Lưu thông tin vào bảng `cancel`
                boolean saved = cancelDAO.insertCancel(cancel);

                // Cập nhật trạng thái đơn hàng
                boolean updated = orderDAO.updateOrderStatus(orderId, "cancelled");

                if (saved && updated) {
                    message = "Order cancelled successfully!";
                    type = "success";
                } else {
                    message = "Failed to cancel the order.";
                }
            } else {
                // Các trạng thái khác (không phải cancelled)
                boolean success = orderDAO.updateOrderStatus(orderId, status);
                message = success ? "Order status updated successfully!" : "Failed to update order status.";
                type = success ? "success" : "error";
            }

        } catch (NumberFormatException e) {
            message = "Invalid order ID format.";
        } catch (Exception e) {
            message = "Error updating order status: " + e.getMessage();
            e.printStackTrace();
        }

        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
        response.sendRedirect(redirectUrl);
    }

    @Override
    public String getServletInfo() {
        return "Handles administrative tasks for managing orders.";
    }
}
