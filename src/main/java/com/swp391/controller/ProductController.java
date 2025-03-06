/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class ProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int page = 1;
            int pageSize = 2;

            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
            Integer categoryId = request.getParameter("categoryId") != null && !request.getParameter("categoryId").isEmpty()
                    ? Integer.parseInt(request.getParameter("categoryId")) : null;
            BigDecimal minPrice = request.getParameter("minPrice") != null && !request.getParameter("minPrice").isEmpty()
                    ? new BigDecimal(request.getParameter("minPrice")) : null;
            BigDecimal maxPrice = request.getParameter("maxPrice") != null && !request.getParameter("maxPrice").isEmpty()
                    ? new BigDecimal(request.getParameter("maxPrice")) : null;

            int totalProducts = productDAO.countProducts(keyword, categoryId, minPrice, maxPrice);
            List<Product> products = productDAO.getActiveProducts(page, pageSize, keyword, categoryId, minPrice, maxPrice);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            List<Category> categories = categoryDAO.findAllActiveCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("keyword", keyword);
            request.setAttribute("categoryId", categoryId);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.getRequestDispatcher("./view/product/product-list.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }
}
