/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.VoucherDAO;
import com.swp391.entity.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "ManageVoucherController", urlPatterns = {"/admin/manage-voucher"})
public class ManageVoucherController extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteVoucher(request, response);
                break;
            default:
                listVouchers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                insertVoucher(request, response);
                break;
            case "edit":
                updateVoucher(request, response);
                break;
            default:
                listVouchers(request, response);
                break;
        }
    }

    // List Vouchers with pagination and filters
    private void listVouchers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        int page = 1;
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (statusFilter == null) {
            statusFilter = "all";
        }

        List<Voucher> vouchers = voucherDAO.findVouchersWithFilters(searchFilter, statusFilter, page, pageSize);
        int totalCount = voucherDAO.getTotalVoucherCountWithFilters(searchFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        request.setAttribute("status", statusFilter);
        request.setAttribute("vouchers", vouchers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("../view/admin/voucher-list.jsp").forward(request, response);
    }

    // Show Add Voucher Form
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("../view/admin/voucher-add.jsp").forward(request, response);
    }

    // Show Edit Voucher Form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Voucher voucher = voucherDAO.findById(id);
        if (voucher != null) {
            request.setAttribute("voucher", voucher);
            request.getRequestDispatcher("../view/admin/voucher-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect("404.jsp");
        }
    }

    // Insert Voucher
    private void insertVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String code = request.getParameter("code");
            String discount = request.getParameter("discountAmount");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("expiryDate");
            int status = Integer.parseInt(request.getParameter("status"));
            int maxUsage = Integer.parseInt(request.getParameter("maxUsage"));

            // Validate input
            if (code == null || code.isEmpty() || discount == null || discount.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=Invalid input");
                return;
            }

            // Check if voucher code already exists
            if ( voucherDAO.isVoucherCodeExist(code)) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=Voucher code already exists");
                return;
            }

            // Validate date ranges
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            if (start.isAfter(end)) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=Start date cannot be after expiry date");
                return;
            }

            // Validate discount amount
            BigDecimal discountAmount = new BigDecimal(discount);
            if (discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=Discount amount must be greater than 0");
                return;
            }

            Voucher voucher = new Voucher(0, code, discountAmount, start, end, status, maxUsage, LocalDateTime.now());

            int result = voucherDAO.insert(voucher);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=1&typeM=add");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=add");
            }
        } catch (Exception e) {
            System.out.println(e);
            response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=Error occurred");
        }
    }

    // Update Voucher
    private void updateVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            String code = request.getParameter("code");
            String discount = request.getParameter("discountAmount");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("expiryDate");
            int status = Integer.parseInt(request.getParameter("status"));
            int maxUsage = Integer.parseInt(request.getParameter("maxUsage"));

            // Validate input
            if (code == null || code.isEmpty() || discount == null || discount.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&voucherId=" + voucherId + "&error=Invalid input");
                return;
            }

            // Check if voucher code already exists (exclude current voucher)
            if (voucherDAO.isVoucherCodeExist(code, voucherId)) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&voucherId=" + voucherId + "&error=Voucher code already exists");
                return;
            }

            // Validate date ranges
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            if (start.isAfter(end)) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&voucherId=" + voucherId + "&error=Start date cannot be after expiry date");
                return;
            }

            // Validate discount amount
            BigDecimal discountAmount = new BigDecimal(discount);
            if (discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&voucherId=" + voucherId + "&error=Discount amount must be greater than 0");
                return;
            }

            Voucher voucher = new Voucher(voucherId, code, discountAmount, start, end, status, maxUsage, null);
            boolean result = voucherDAO.update(voucher);
            if (result) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=1&typeM=edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=edit");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=list&error=Error occurred");
        }
    }

    // Delete Voucher
    private void deleteVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int voucherId = Integer.parseInt(request.getParameter("id"));
            Voucher voucher = voucherDAO.findById(voucherId);
            if (voucher != null) {
                boolean result = voucherDAO.delete(voucher);
                if (result) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=1&typeM=delete");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=delete");
                }
            } else {
                response.sendRedirect("404.jsp");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=delete");
        }
    }
}
