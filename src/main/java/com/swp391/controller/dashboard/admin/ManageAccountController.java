/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.swp391.dal.impl.AccountDAO;
import com.swp391.entity.Account;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import java.time.LocalDateTime;

@WebServlet(name = "ManageAccountController", urlPatterns = {"/admin/manage-account"})
public class ManageAccountController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "deactivate":
                deactivateAccount(request, response);
                break;
            case "activate":
                activateAccount(request, response);
                break;
            case "list":
            default:
                listAccounts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "add":
                addAccount(request, response);
                break;
            case "update":
                updateAccount(request, response);
                break;
            default:
                listAccounts(request, response);
                break;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DashboardController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DashboardController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.findById(accountId);
            if (account != null) {
                request.setAttribute("account", account);
                request.getRequestDispatcher("/view/admin/account-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String roleFilter = request.getParameter("role");
        String genderFilter = request.getParameter("gender");

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
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

        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.findAccountsWithFilters(
                roleFilter, statusFilter, searchFilter, page, pageSize);

        int totalAccounts = accountDAO.getTotalFilteredAccounts(
                roleFilter, statusFilter, searchFilter);

        int totalPages = (int) Math.ceil((double) totalAccounts / pageSize);

        // Set attributes for JSP
        request.setAttribute("accounts", accounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalAccounts", totalAccounts);

        // Set filter values for maintaining state
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("genderFilter", genderFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.getRequestDispatcher("../view/admin/account-list.jsp").forward(request, response);
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StringBuilder errorMsg = new StringBuilder();
        try {
            String idStr = request.getParameter("id");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String statusStr = request.getParameter("status");
            String role = request.getParameter("role");

            int accountId;
            try {
                accountId = Integer.parseInt(idStr);
                if (accountId <= 0) {
                    errorMsg.append("Invalid Account ID. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Account ID must be a valid number. ");
                accountId = -1;
            }

            if (firstName == null || firstName.trim().isEmpty()) {
                errorMsg.append("First name is required. ");
            } else if (firstName.length() > 50) {
                errorMsg.append("First name must not exceed 50 characters. ");
            }

            if (lastName == null || lastName.trim().isEmpty()) {
                errorMsg.append("Last name is required. ");
            } else if (lastName.length() > 50) {
                errorMsg.append("Last name must not exceed 50 characters. ");
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                errorMsg.append("Phone number is required. ");
            } else if (!phone.matches("^0\\d{9}$")) {
                errorMsg.append("Phone number must be a 10-digit number starting with 0. ");
            }

            if (address == null || address.trim().isEmpty()) {
                errorMsg.append("Address is required. ");
            } else if (address.length() > 200) {
                errorMsg.append("Address must not exceed 200 characters. ");
            }

            boolean status;
            try {
                status = Boolean.parseBoolean(statusStr);
            } catch (Exception e) {
                errorMsg.append("Invalid status value. ");
                status = false;
            }

            if (errorMsg.length() > 0) {
                request.getSession().setAttribute("toastMessage", errorMsg.toString());
                request.getSession().setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=edit&id=" + idStr);
                return;
            }

            AccountDAO accountDAO = new AccountDAO();
            Account account = accountDAO.findById(accountId);

            if (account != null) {
                account.setFirstName(firstName.trim());
                account.setLastName(lastName.trim());
                account.setPhone(phone.trim());
                account.setAddress(address.trim());
                account.setStatus(status);
                account.setRole(role);

                account.setUpdatedAt(LocalDateTime.now());

                boolean isSuccess = accountDAO.update(account);

                if (isSuccess) {
                    request.getSession().setAttribute("toastMessage", "Account updated successfully!");
                    request.getSession().setAttribute("toastType", "success");
                } else {
                    request.getSession().setAttribute("toastMessage", "Failed to update account!");
                    request.getSession().setAttribute("toastType", "error");
                }
            } else {
                request.getSession().setAttribute("toastMessage", "Account not found!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=list");
    }

    private void deactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            boolean deactivated = accountDAO.deactivateAccount(accountId);

            if (deactivated) {
                setToastMessage(request, "Account deactivated successfully", "success");
            } else {
                setToastMessage(request, "Failed to deactivate account", "error");
            }
        } else {
            setToastMessage(request, "Invalid account ID", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void activateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountIdStr = request.getParameter("id");
        if (accountIdStr != null && !accountIdStr.isEmpty()) {
            int accountId = Integer.parseInt(accountIdStr);
            AccountDAO accountDAO = new AccountDAO();
            boolean activated = accountDAO.activateAccount(accountId);

            if (activated) {
                setToastMessage(request, "Account activated successfully", "success");
            } else {
                setToastMessage(request, "Failed to activate account", "error");
            }
        } else {
            setToastMessage(request, "Invalid account ID", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-account");
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        request.getSession().setAttribute("toastMessage", message);
        request.getSession().setAttribute("toastType", type);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/account-add.jsp");
        dispatcher.forward(request, response);
    }

    private void addAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StringBuilder errorMsg = new StringBuilder();
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String statusStr = request.getParameter("status");

            if (username == null || username.trim().isEmpty()) {
                errorMsg.append("Username is required. ");
            } else if (username.length() < 3 || username.length() > 50) {
                errorMsg.append("Username must be between 3 and 50 characters. ");
            } else if (!username.matches("^[a-zA-Z0-9_]+$")) {
                errorMsg.append("Username can only contain letters, numbers, and underscores. ");
            }

            if (email == null || email.trim().isEmpty()) {
                errorMsg.append("Email is required. ");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                errorMsg.append("Invalid email format. ");
            } else if (email.length() > 100) {
                errorMsg.append("Email must not exceed 100 characters. ");
            }
            if (password == null || password.trim().isEmpty()) {
                errorMsg.append("Password is required. ");
            } else if (password.length() < 6) {
                errorMsg.append("Password must be at least 6 characters. ");
                request.setAttribute("passwordError", "Password must be at least 6 characters.");
            } else if (password.length() > 50) {
                errorMsg.append("Password must not exceed 50 characters. ");
                request.setAttribute("passwordError", "Password must not exceed 50 characters.");
            }
            if (firstName == null || firstName.trim().isEmpty()) {
                errorMsg.append("First name is required. ");
            } else if (firstName.length() > 50) {
                errorMsg.append("First name must not exceed 50 characters. ");
            }

            if (lastName == null || lastName.trim().isEmpty()) {
                errorMsg.append("Last name is required. ");
            } else if (lastName.length() > 50) {
                errorMsg.append("Last name must not exceed 50 characters. ");
            }

            if (phone == null || phone.trim().isEmpty()) {
                errorMsg.append("Phone number is required. ");
            } else if (!phone.matches("^0\\d{9}$")) {
                errorMsg.append("Phone number must be a 10-digit number starting with 0. ");
                request.setAttribute("phoneError", "Phone number must be a 10-digit number starting with 0.");
            }

            if (address == null || address.trim().isEmpty()) {
                errorMsg.append("Address is required. ");
            } else if (address.length() > 200) {
                errorMsg.append("Address must not exceed 200 characters. ");
            }

            boolean status;
            try {
                status = Boolean.parseBoolean(statusStr);
            } catch (Exception e) {
                errorMsg.append("Invalid status value. ");
                status = false;
            }
            boolean hasError = false;

            AccountDAO accountDAO = new AccountDAO();
            boolean usernameExists = accountDAO.isUsernameExist(username);
            boolean emailExists = accountDAO.isEmailExist(email);

            if (usernameExists || emailExists || errorMsg.length() > 0) {
                if (usernameExists) {
                    request.setAttribute("usernameError", "Email already exists! Please enter another email.");
                }
                if (emailExists) {
                    request.setAttribute("emailError", "Username already exists! Please enter another username.");
                }
                if (errorMsg.length() > 0) {
                    request.setAttribute("generalError", errorMsg.toString());
                }

                // Keep other input values
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.setAttribute("role", role);
                request.setAttribute("status", status ? "true" : "false");

                // Do not set username to keep it empty in case of duplicate
                request.getRequestDispatcher("/view/admin/account-add.jsp").forward(request, response);
                return;
            }

            // Create and insert new account
            Account newAccount = Account.builder()
                    .username(username.trim())
                    .email(email.trim())
                    .password(hashMD5(password))
                    .firstName(firstName.trim())
                    .lastName(lastName.trim())
                    .phone(phone.trim())
                    .address(address.trim())
                    .role(role.trim())
                    .status(status)
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build();

            boolean isSuccess = accountDAO.insert(newAccount) > 0;

            if (isSuccess) {
                request.getSession().setAttribute("toastMessage", "Account added successfully!");
                request.getSession().setAttribute("toastType", "success");
            } else {
                request.getSession().setAttribute("toastMessage", "Failed to add account!");
                request.getSession().setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Error: " + e.getMessage());
            request.getSession().setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=list");
    }

    private String hashMD5(String input) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
        byte[] array = md.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : array) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

}
