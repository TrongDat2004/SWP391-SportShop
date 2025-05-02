/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.home;

import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.dal.impl.SliderDAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.entity.Slider;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final String HOME_PAGE = "view/home/shop.jsp";
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
      private final SliderDAO sliderDAO = new SliderDAO();//thêm dòng này

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getLatestActiveProducts();
        List<Category> categories = categoryDAO.findAllActiveCategories();
         List<Slider> activeSliders = sliderDAO.getActiveSliders();//thêm dòng này
        request.setAttribute("Active", activeSliders);//thêm dòng này
        request.setAttribute("products", products);
         request.setAttribute("categories", categories);
        request.getRequestDispatcher(HOME_PAGE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.doGet(request, response);
    }
}
