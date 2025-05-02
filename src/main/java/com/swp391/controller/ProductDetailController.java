package com.swp391.controller;

import com.swp391.dal.impl.FeedbackDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.dal.impl.ProductSizeDAO; // Thêm import
import com.swp391.entity.Feedback;
import com.swp391.entity.Product;
import com.swp391.entity.ProductSize; // Thêm import
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "ProductDetailController", urlPatterns = {"/product-detail"})
public class ProductDetailController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAO(); // Thêm DAO size

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int productId = Integer.parseInt(idParam);
                // ProductDAO.findActiveById đã được sửa để lấy cả size
                Product product = productDAO.findActiveById(productId);

                if (product != null) {
                    // Lấy feedback
                    List<Feedback> feedbacks = feedbackDAO.getFeedbackByProduct(productId);

                    // Lấy sizes (đã có trong product object nếu DAO sửa đúng)
                    List<ProductSize> sizes = product.getSizes();

                    request.setAttribute("feedbacks", feedbacks);
                    request.setAttribute("product", product);
                    request.setAttribute("sizes", sizes); // Truyền danh sách size sang JSP

                    request.getRequestDispatcher("./view/product/product-detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid product ID format: " + idParam);
            } catch (Exception e) {
                System.err.println("Error fetching product details: " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.err.println("Product not found or invalid ID provided.");
        // Có thể chuyển hướng đến trang lỗi 404 hoặc trang sản phẩm
        // response.sendRedirect("404.jsp"); // Hoặc trang sản phẩm
        response.sendRedirect("products"); // Chuyển về trang sản phẩm chung
    }
}
