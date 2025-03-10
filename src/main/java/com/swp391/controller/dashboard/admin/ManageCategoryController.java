package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.CategoryDAO;
import com.swp391.entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageCategoryController", urlPatterns = {"/admin/manage-category"})
public class ManageCategoryController extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

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
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
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
                insertCategory(request, response);
                break;
            case "edit":
                updateCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    // List Categories with pagination and filters
    private void listCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        // Fetch filtered and paginated categories
        List<Category> categories = categoryDAO.findCategoriesWithFilters(searchFilter, statusFilter, page, pageSize);
        int totalCount = categoryDAO.getTotalCategoryCountWithFilters(searchFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        request.setAttribute("status", statusFilter);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("../view/admin/category-list.jsp").forward(request, response);
    }

    // Show Add Category Form
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("../view/admin/category-add.jsp").forward(request, response);
    }

    // Show Edit Category Form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.findById(id);
        if (category != null) {
            request.setAttribute("category", category);
            request.getRequestDispatcher("../view/admin/category-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect("404.jsp");
        }
    }

    // Insert Category
    private void insertCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            // Validate input
            if (name == null || name.isEmpty() || description == null || description.isEmpty()) {
                response.sendRedirect("/admin/manage-category?action=create&error=Invalid input");
                return;
            }

            Category category = new Category(0, name, description, status, null, null);
            int result = categoryDAO.insert(category);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=1&typeM=add");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=0&typeM=add");
            }
        } catch (Exception e) {
            System.out.println(e);
            response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=create&error=Error occurred");
        }
    }

    // Update Category
    private void updateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            // Validate input
            if (name == null || name.isEmpty() || description == null || description.isEmpty()) {
                response.sendRedirect("/admin/manage-category?action=edit&categoryId=" + categoryId + "&error=Invalid input");
                return;
            }

            Category category = new Category(categoryId, name, description, status, null, null);
            boolean result = categoryDAO.update(category);
            if (result) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=1&typeM=edit");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=0&typeM=edit");
            }
        } catch (Exception e) {
            System.err.println(e);
            response.sendRedirect(request.getContextPath() + "/admin/manage-category?action=list&error=Error occurred");
        }
    }

    // Delete Category
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDAO.findById(categoryId);
            if (category != null) {
                boolean result = categoryDAO.delete(category);
                if (result) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=1&typeM=delete");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=0&typeM=delete");
                }
            } else {
                response.sendRedirect("404.jsp");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-category?statusM=0&typeM=delete");
        }
    }
}
