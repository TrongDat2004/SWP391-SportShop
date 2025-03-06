package com.swp391.controller;

import com.swp391.dal.impl.ProductDAO;
import com.swp391.entity.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/product-detail"})
public class ProductDetailController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int productId = Integer.parseInt(idParam);
                Product product = productDAO.findActiveById(productId);
                if (product != null) {
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("./view/product/product-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid product ID: " + e.getMessage());
            }
        }
        response.sendRedirect("404.jsp");
    }
}
