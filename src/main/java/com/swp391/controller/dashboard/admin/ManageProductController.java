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
            String pathProduct = "./uploads/product/";
            String uploadPath = getServletContext().getRealPath(pathProduct);
            Upload upload = new Upload();
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            Part mainImgParth = request.getPart("image");
            String fileNameImg = pathProduct + upload.uploadImg(mainImgParth, uploadPath);

            if (name.isEmpty() || price.compareTo(BigDecimal.ZERO) <= 0 || stock < 0) {
                response.sendRedirect("/admin/manage-product?action=create&error=Invalid input");
                return;
            }

            Product product = new Product(0, categoryId, name, description, price, stock, fileNameImg, status, null, null, null);
            int result = productDAO.insert(product);
            if (result > 1) {
                response.sendRedirect(request.getContextPath()+"/admin/manage-product?statusM=1&typeM=add");
            } else {
                response.sendRedirect(request.getContextPath()+"/admin/manage-product?statusM=0&typeM=add");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()+"/admin/manage-product?action=create&error=Invalid input");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathProduct = "./uploads/product/";
            String uploadPath = getServletContext().getRealPath(pathProduct);
            Upload upload = new Upload();
            int id = Integer.parseInt(request.getParameter("productId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("image");
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            Part mainImgParth = request.getPart("image");
            String saveFile = upload.uploadImg(mainImgParth, uploadPath);
            String fileNameImg = pathProduct + saveFile;
            if (saveFile == null) {
                fileNameImg = request.getParameter("oldImage");
            }

            if (name.isEmpty() || price.compareTo(BigDecimal.ZERO) <= 0 || stock < 0) {
                response.sendRedirect(request.getContextPath()+"/admin/manage-product?action=edit&id=" + id + "&error=Invalid input");
                return;
            }

            Product product = new Product(id, categoryId, name, description, price, stock, fileNameImg, status, null, null, null);
            boolean result = productDAO.update(product);
            if (result) {
                response.sendRedirect(request.getContextPath()+"/admin/manage-product?statusM=1&typeM=update");
            } else {
                response.sendRedirect(request.getContextPath()+"/admin/manage-product?statusM=0&typeM=update");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath()+"/admin/manage-product?action=edit&id=" + request.getParameter("id") + "&error=Invalid input");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.findById(id);
        if (product != null) {
            productDAO.delete(product);
        }
        response.sendRedirect(request.getContextPath()+"/admin/manage-product");
    }

}
