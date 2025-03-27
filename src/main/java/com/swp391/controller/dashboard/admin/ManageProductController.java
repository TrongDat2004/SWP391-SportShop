/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.utils.Upload;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.List;

/**
 *
 * @author HP
 */
@WebServlet(name = "ManageProductController", urlPatterns = {"/admin/manage-product"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50)
public class ManageProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

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
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
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
                insertProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String categoryFilter = request.getParameter("category");

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
        CategoryDAO categoryDao = new CategoryDAO();
        List<Category> categories = categoryDao.findAll();
        List<Product> productList = productDAO.findProductsWithFilters(searchFilter, statusFilter, categoryFilter, page, pageSize);

        int totalCount = productDAO.getTotalProductCountWithFilters(searchFilter, statusFilter, categoryFilter);

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        request.setAttribute("categories", categories);
        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("../view/admin/product-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CategoryDAO categoryDao = new CategoryDAO();
        List<Category> categories = categoryDao.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("../view/admin/product-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.findById(id);
        if (product != null) {
            CategoryDAO categoryDao = new CategoryDAO();
            List<Category> categories = categoryDao.findAll();
            request.setAttribute("categories", categories);
            request.setAttribute("product", product);
            request.getRequestDispatcher("../view/admin/product-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect("404.jsp");
        }
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathProduct = "uploads/product/";
            String uploadPath = getServletContext().getRealPath(pathProduct);
            Upload upload = new Upload();

            String categoryIdStr = request.getParameter("categoryId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String statusStr = request.getParameter("status");
            Part mainImgPart = request.getPart("image");

            StringBuilder errorMsg = new StringBuilder();

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                if (categoryId <= 0) {
                    errorMsg.append("Category ID must be positive. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid Category ID. ");
                categoryId = -1;
            }

            if (name == null || name.trim().isEmpty()) {
                errorMsg.append("Product name is required. ");
            }

            if (description == null || description.trim().isEmpty()) {
                errorMsg.append("Description is required. ");
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    errorMsg.append("Price must be greater than 0. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid price format. ");
                price = BigDecimal.ZERO;
            }

            int stock;
            try {
                stock = Integer.parseInt(stockStr);
                if (stock < 0) {
                    errorMsg.append("Stock cannot be negative. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid stock format. ");
                stock = -1;
            }

            boolean status;
            try {
                status = Boolean.parseBoolean(statusStr);
            } catch (Exception e) {
                errorMsg.append("Invalid status value. ");
                status = false;
            }

            String fileNameImg = null;
            if (mainImgPart == null || mainImgPart.getSize() == 0) {
                errorMsg.append("Product image is required. ");
            } else {
                String fileName = upload.uploadImg(mainImgPart, uploadPath);
                if (fileName == null) {
                    errorMsg.append("Failed to upload image. ");
                } else {
                    String contentType = mainImgPart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        errorMsg.append("File must be an image. ");
                    } else {
                        fileNameImg = pathProduct + fileName;
                    }
                }
            }

            if (errorMsg.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=create&error=" + URLEncoder.encode(errorMsg.toString(), "UTF-8"));
                return;
            }

            Product product = new Product(0, categoryId, name.trim(), description.trim(), price, stock, fileNameImg, status, null, null, null);
            int result = productDAO.insert(product);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?statusM=1&typeM=add");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?statusM=0&typeM=add");
            }
        } catch (ServletException | IOException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=create&error=" + URLEncoder.encode("Server error: " + e.getMessage(), "UTF-8"));
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathProduct = "uploads/product/";
            String uploadPath = getServletContext().getRealPath(pathProduct);
            Upload upload = new Upload();

            String idStr = request.getParameter("productId");
            String categoryIdStr = request.getParameter("categoryId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String statusStr = request.getParameter("status");
            String oldImage = request.getParameter("oldImage");
            Part mainImgPart = request.getPart("image");

            StringBuilder errorMsg = new StringBuilder();

            int id;
            try {
                id = Integer.parseInt(idStr);
                if (id <= 0) {
                    errorMsg.append("Invalid Product ID. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid Product ID format. ");
                id = -1;
            }

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                if (categoryId <= 0) {
                    errorMsg.append("Category ID must be positive. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid Category ID. ");
                categoryId = -1;
            }

            if (name == null || name.trim().isEmpty()) {
                errorMsg.append("Product name is required. ");
            } else if (name.length() > 100) {
                errorMsg.append("Product name must not exceed 100 characters. ");
            }

            if (description == null || description.trim().isEmpty()) {
                errorMsg.append("Description is required. ");
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    errorMsg.append("Price must be greater than 0. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid price format. ");
                price = BigDecimal.ZERO;
            }

            int stock;
            try {
                stock = Integer.parseInt(stockStr);
                if (stock < 0) {
                    errorMsg.append("Stock cannot be negative. ");
                }
            } catch (NumberFormatException e) {
                errorMsg.append("Invalid stock format. ");
                stock = -1;
            }

            boolean status;
            try {
                status = Boolean.parseBoolean(statusStr);
            } catch (Exception e) {
                errorMsg.append("Invalid status value. ");
                status = false;
            }

            String fileNameImg = oldImage;
            if (mainImgPart != null && mainImgPart.getSize() > 0) {
                String fileName = upload.uploadImg(mainImgPart, uploadPath);
                if (fileName == null) {
                    errorMsg.append("Failed to upload new image. ");
                } else {
                    String contentType = mainImgPart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        errorMsg.append("File must be an image. ");
                    } else {
                        fileNameImg = pathProduct + fileName;
                    }
                }
            } else if (oldImage == null || oldImage.trim().isEmpty()) {
                errorMsg.append("Product image is required. ");
            }

            if (errorMsg.length() > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=edit&id=" + id + "&error=" + URLEncoder.encode(errorMsg.toString(), "UTF-8"));
                return;
            }

            Product product = new Product(id, categoryId, name.trim(), description.trim(), price, stock, fileNameImg, status, null, null, null);
            boolean result = productDAO.update(product);
            if (result) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?statusM=1&typeM=update");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-product?statusM=0&typeM=update");
            }
        } catch (ServletException | IOException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=edit&id=" + request.getParameter("productId") + "&error=" + URLEncoder.encode("Server error: " + e.getMessage(), "UTF-8"));
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.findById(id);
        if (product != null) {
            productDAO.delete(product);
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }

}
