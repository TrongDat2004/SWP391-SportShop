/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller;

import com.swp391.utils.EmailUtils;
import jakarta.mail.MessagingException;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author HP
 */
@WebServlet(name = "ContactController", urlPatterns = {"/contact"})
public class ContactController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ContactController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ContactController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("./view/profile/contact.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get information from the form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Check if any field is empty
        if (name == null || email == null || message == null
                || name.trim().isEmpty() || email.trim().isEmpty() || message.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all the required fields!");
            request.getRequestDispatcher("./view/profile/contact.jsp").forward(request, response);
            return;
        }

        String adminEmail = "Datnhtce181703@fpt.edu.vn";
        String subject = "New Customer Inquiry";

        // Email content
        String emailContent = "<html>"
                + "<body>"
                + "<h2>Customer Inquiry Details:</h2>"
                + "<p><strong>Full Name:</strong> " + name + "</p>"
                + "<p><strong>Email:</strong> " + email + "</p>"
                + "<p><strong>Message:</strong></p>"
                + "<p>" + message + "</p>"
                + "<br><p>Please respond as soon as possible.</p>"
                + "<hr>"
                + "<p>This is an automated email from the system. Please do not reply to this email.</p>"
                + "</body></html>";

        boolean emailSent;
        try {
            emailSent = EmailUtils.sendMail(adminEmail, subject, emailContent);
            if (emailSent) {
                request.setAttribute("success", "Your message has been sent successfully!");
            } else {
                request.setAttribute("error", "An error occurred while sending the email. Please try again later!");
            }
            request.getRequestDispatcher("./view/profile/contact.jsp").forward(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(ContactController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Failed to send email. Please try again!");
            request.getRequestDispatcher("./view/profile/contact.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
