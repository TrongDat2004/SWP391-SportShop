/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author HP
 */
@WebServlet(name = "ManageOrderController", urlPatterns = {"/admin/manage-order"})
public class ManageOrderController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ManageOrderController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageOrderController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        OrderDAO orderDAO = new OrderDAO();
        action = action != null ? action : "";
        switch (action) {
            case "order-details":
                String idParam = request.getParameter("orderid");
                if (idParam != null) {
                    int orderId = Integer.parseInt(idParam);
                    Order order = orderDAO.getOrderByIdAdmin(orderId);
                    if (order != null) {
                        List<OrderItem> details = orderDAO.getOrderItemsByOrderId(orderId);
                        request.setAttribute("order", order);
                        request.setAttribute("details", details);
                        request.getRequestDispatcher("../view/admin/order-detail.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/manage-order?status=false&type=no_found");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-order?status=false&type=no_order_id");
                }
                break;
            default:
                int page = 1;
                int pageSize = 10;
                String search = request.getParameter("search");
                String statusFilter = request.getParameter("status");

                if (request.getParameter("page") != null) {
                    page = Integer.parseInt(request.getParameter("page"));
                }

                int offset = (page - 1) * pageSize;

                List<Order> orders = orderDAO.getAllOrdersAdmin(search, statusFilter, offset, pageSize);

                int totalOrders = orderDAO.getTotalOrderCountAdmin(search, statusFilter);
                int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

                request.setAttribute("orders", orders);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
                request.setAttribute("search", search);
                request.setAttribute("status", statusFilter);

                request.getRequestDispatcher("../view/admin/orderList.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        try {
            if (orderId != null && status != null && Arrays.asList("pending", "accepted", "cancelled", "completed", "paid", "nopaid").contains(status)) {
                orderDAO.updateOrderStatus(Integer.parseInt(orderId), status);
                response.sendRedirect(request.getContextPath() + "/admin/manage-order?statusM=1&typeM=update");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-order?statusM=0&typeM=update");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/manage-order?statusM=0&typeM=update&error=invalidOrderId");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
