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
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
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
        StringBuilder errorMsg = new StringBuilder();
        try {
            String code = request.getParameter("code");
            String discount = request.getParameter("discountAmount");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("expiryDate");
            String statusStr = request.getParameter("status");
            String maxUsageStr = request.getParameter("maxUsage");

            if (code == null || code.trim().isEmpty()) {
                errorMsg.append("Voucher code is required. ");
            } else if (code.trim().startsWith("_")) {
                errorMsg.append("Voucher code cannot start with '_'. ");
            } else if (code.trim().length() < 3 || code.trim().length() > 20) {
                errorMsg.append("Voucher code must be between 3 and 20 characters. ");
            } else if (!code.matches("^[a-zA-Z0-9][a-zA-Z0-9_]*$")) {
                errorMsg.append("Voucher code can only contain letters, numbers, and underscores (but not start with '_'). ");
            } else if (voucherDAO.isVoucherCodeExist(code.trim())) {
                errorMsg.append("Voucher code already exists. ");
            }

            BigDecimal discountAmount = null;
            if (discount == null || discount.trim().isEmpty()) {
                errorMsg.append("Discount amount is required. ");
            } else {
                try {
                    discountAmount = new BigDecimal(discount.trim());
                    if (discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
                        errorMsg.append("Discount amount must be greater than 0. ");
                    } else if (discountAmount.compareTo(new BigDecimal("10000000")) > 0) {
                        errorMsg.append("Discount amount cannot exceed 10,000,000. ");
                    }
                } catch (NumberFormatException e) {
                    errorMsg.append("Invalid discount amount format. ");
                }
            }

            LocalDate start = null;
            LocalDate end = null;
            if (startDate == null || startDate.trim().isEmpty()) {
                errorMsg.append("Start date is required. ");
            } else {
                try {
                    start = LocalDate.parse(startDate.trim());
                    if (start.isBefore(LocalDate.now())) {
                        errorMsg.append("Start date cannot be in the past. ");
                    }
                } catch (DateTimeParseException e) {
                    errorMsg.append("Invalid start date format. ");
                }
            }

            if (endDate == null || endDate.trim().isEmpty()) {
                errorMsg.append("Expiry date is required. ");
            } else {
                try {
                    end = LocalDate.parse(endDate.trim());
                    if (start != null && start.isAfter(end)) {
                        errorMsg.append("Start date cannot be after expiry date. ");
                    }
                } catch (DateTimeParseException e) {
                    errorMsg.append("Invalid expiry date format. ");
                }
            }

            int status;
            try {
                status = Integer.parseInt(statusStr);
                if (status < 0 || status > 1) {
                    errorMsg.append("Status must be 0 (inactive) or 1 (active). ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid status value. ");
                status = -1;
            }

            // Validate maxUsage
            int maxUsage;
            try {
                maxUsage = Integer.parseInt(maxUsageStr);
                if (maxUsage < 1) {
                    errorMsg.append("Max usage must be at least 1. ");
                } else if (maxUsage > 10000) { // Giới hạn ví dụ
                    errorMsg.append("Max usage cannot exceed 10,000. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid max usage value. ");
                maxUsage = -1;
            }

            // Nếu có lỗi, redirect với thông báo chi tiết
            if (errorMsg.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=" + URLEncoder.encode(errorMsg.toString(), "UTF-8"));
                return;
            }

            // Tạo và insert voucher
            Voucher voucher = new Voucher(0, code.trim(), discountAmount, start, end, status, maxUsage, LocalDateTime.now());
            int result = voucherDAO.insert(voucher);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=1&typeM=add");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=add");
            }
        } catch (Exception e) {
            System.out.println(e);
            response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=add&error=" + URLEncoder.encode("Server error: " + e.getMessage(), "UTF-8"));
        }
    }

    // Update Voucher
    private void updateVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder errorMsg = new StringBuilder();
        String voucherIdStr = request.getParameter("voucherId");
        try {

            String code = request.getParameter("code");
            String discount = request.getParameter("discountAmount");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("expiryDate");
            String statusStr = request.getParameter("status");
            String maxUsageStr = request.getParameter("maxUsage");

            // Validate voucherId
            int voucherId;
            try {
                voucherId = Integer.parseInt(voucherIdStr);
                if (voucherId <= 0) {
                    errorMsg.append("Invalid voucher ID. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Voucher ID must be a valid number. ");
                voucherId = -1;
            }

            // Validate code
            if (code == null || code.trim().isEmpty()) {
                errorMsg.append("Voucher code is required. ");
            } else if (code.trim().startsWith("_")) {
                errorMsg.append("Voucher code cannot start with '_'. ");
            } else if (code.trim().length() < 3 || code.trim().length() > 20) {
                errorMsg.append("Voucher code must be between 3 and 20 characters. ");
            } else if (!code.matches("^[a-zA-Z0-9][a-zA-Z0-9_]*$")) {
                errorMsg.append("Voucher code can only contain letters, numbers, and underscores (but not start with '_'). ");
            } else if (voucherDAO.isVoucherCodeExist(code.trim(), voucherId)) {
                errorMsg.append("Voucher code already exists. ");
            }

            // Validate discount amount
            BigDecimal discountAmount = null;
            if (discount == null || discount.trim().isEmpty()) {
                errorMsg.append("Discount amount is required. ");
            } else {
                try {
                    discountAmount = new BigDecimal(discount.trim());
                    if (discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
                        errorMsg.append("Discount amount must be greater than 0. ");
                    } else if (discountAmount.compareTo(new BigDecimal("10000000")) > 0) {
                        errorMsg.append("Discount amount cannot exceed 10,000,000. ");
                    }
                } catch (NumberFormatException e) {
                    errorMsg.append("Invalid discount amount format. ");
                }
            }

            // Validate startDate and endDate
            LocalDate start = null;
            LocalDate end = null;
            if (startDate == null || startDate.trim().isEmpty()) {
                errorMsg.append("Start date is required. ");
            } else {
                try {
                    start = LocalDate.parse(startDate.trim());
                } catch (DateTimeParseException e) {
                    errorMsg.append("Invalid start date format. ");
                }
            }

            if (endDate == null || endDate.trim().isEmpty()) {
                errorMsg.append("Expiry date is required. ");
            } else {
                try {
                    end = LocalDate.parse(endDate.trim());
                    if (start != null && start.isAfter(end)) {
                        errorMsg.append("Start date cannot be after expiry date. ");
                    }
                } catch (DateTimeParseException e) {
                    errorMsg.append("Invalid expiry date format. ");
                }
            }

            // Validate status
            int status;
            try {
                status = Integer.parseInt(statusStr);
                if (status < 0 || status > 1) {
                    errorMsg.append("Status must be 0 (inactive) or 1 (active). ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid status value. ");
                status = -1;
            }

            // Validate maxUsage
            int maxUsage;
            try {
                maxUsage = Integer.parseInt(maxUsageStr);
                if (maxUsage < 1) {
                    errorMsg.append("Max usage must be at least 1. ");
                } else if (maxUsage > 10000) {
                    errorMsg.append("Max usage cannot exceed 10,000. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid max usage value. ");
                maxUsage = -1;
            }

            // Nếu có lỗi, redirect với thông báo chi tiết
            if (errorMsg.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&id=" + voucherIdStr + "&error=" + URLEncoder.encode(errorMsg.toString(), "UTF-8"));
                return;
            }

            // Tạo và update voucher
            Voucher voucher = new Voucher(voucherId, code.trim(), discountAmount, start, end, status, maxUsage, null);
            boolean result = voucherDAO.update(voucher);
            if (result) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=1&typeM=edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?statusM=0&typeM=edit");
            }
        } catch (Exception e) {
            System.out.println(e);
            response.sendRedirect(request.getContextPath() + "/admin/manage-voucher?action=edit&id=" + voucherIdStr + "&error=" + URLEncoder.encode("Server error: " + e.getMessage(), "UTF-8"));
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
