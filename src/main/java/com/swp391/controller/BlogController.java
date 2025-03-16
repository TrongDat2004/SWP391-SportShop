/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.dal.impl.BlogDAO;
import com.swp391.entity.Blog;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author HP
 */
@WebServlet(name = "BlogController", urlPatterns = {"/blogs"})
public class BlogController extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();

    private static final int PAGE_SIZE = 3; 


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            viewDetail(request, response);
        } else {
            viewList(request, response);
        }
    }

    private void viewList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ignored) {
        }

        List<Blog> blogs = blogDAO.getPublishedBlogs(search, page, PAGE_SIZE);
        int totalBlogs = blogDAO.countPublishedBlogs(search);
        int totalPages = (int) Math.ceil((double) totalBlogs / PAGE_SIZE);

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.getRequestDispatcher("./view/blog/blogList.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int blogId;
        try {
            blogId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("blogs");
            return;
        }

        Blog blog = blogDAO.getBlogById(blogId);
        if (blog == null || !"published".equals(blog.getStatus())) {
            response.sendRedirect("blogs");
            return;
        }

        request.setAttribute("blog", blog);
        request.getRequestDispatcher("./view/blog/blogDetail.jsp").forward(request, response);
    }
}
