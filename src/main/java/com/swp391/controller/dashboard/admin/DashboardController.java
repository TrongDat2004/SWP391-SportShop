/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.OrderDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 *
 * @author HP
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/admin/dashboard"})
public class DashboardController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (startDate == null || endDate == null) {
            LocalDate now = LocalDate.now();
            startDate = now.minusMonths(6).toString(); 
            endDate = now.toString();
        }

        List<Map<String, Object>> revenueData = orderDAO.getRevenueStatistics(startDate, endDate);
        List<Map<String, Object>> orderStats = orderDAO.getOrderCountByStatus(startDate, endDate);
        request.setAttribute("orderStats", orderStats);
         request.setAttribute("revenueData", revenueData);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        RequestDispatcher dispatcher = request.getRequestDispatcher("../view/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
