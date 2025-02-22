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

@WebServlet(name="ManageAccountController", urlPatterns={"/admin/manage-account"})
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
            out.println("<h1>Servlet DashboardController at " + request.getContextPath () + "</h1>");
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
                request.getRequestDispatcher("/view/admin/edit-account.jsp").forward(request, response);
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
        int accountId = Integer.parseInt(request.getParameter("id"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));

        Account account = new Account();
        account.setUserId(accountId);
        account.setFirstName(firstName);
        account.setLastName(lastName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setAddress(address);
        account.setRole(role);
        account.setStatus(status);

        AccountDAO accountDAO = new AccountDAO();
        boolean updated = accountDAO.update(account);

        if (updated) {
            setToastMessage(request, "Account updated successfully", "success");
            response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=edit&id=" + accountId);
        } else {
            setToastMessage(request, "Failed to update account", "error");
            request.setAttribute("account", account);
            request.getRequestDispatcher("/view/admin/edit-account.jsp").forward(request, response);
        }
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
        try {
            // Lấy thông tin từ request
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            // Tạo đối tượng Account mới
            Account newAccount = Account.builder()
                .username(username)
                .email(email)
                .password(password)
                .firstName(firstName)
                .lastName(lastName)
                .phone(phone)
                .address(address)
                .role(role)
                .status(status)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

            // Thêm account vào database
            AccountDAO accountDAO = new AccountDAO();
            boolean isSuccess = accountDAO.insert(newAccount) > 0;

            // Xử lý kết quả
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
        
        // Chuyển hướng về trang list
        response.sendRedirect(request.getContextPath() + "/admin/manage-account?action=list");
    }
}
