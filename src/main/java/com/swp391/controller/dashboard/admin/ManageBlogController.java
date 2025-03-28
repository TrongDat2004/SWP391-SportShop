package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.BlogDAO;
import com.swp391.entity.Blog;
import com.swp391.utils.Upload;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ManageBlogController", urlPatterns = {"/ManageBlogController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ManageBlogController extends HttpServlet {

    private BlogDAO blogDAO;
    private String filePath = "/upload/blog/";

    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBlog(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            default:
                listBlogs(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addBlog(request, response);
        } else if ("update".equals(action)) {
            updateBlog(request, response);
        }
    }

    private void listBlogs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Blog> blogs = blogDAO.getAllBlogs();
        request.setAttribute("blogs", blogs);
        request.getRequestDispatcher("./view/admin/blog-list.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("blog_id"));
        Blog existingBlog = blogDAO.getBlogById(id);
        request.setAttribute("blog", existingBlog);
        request.getRequestDispatcher("./view/admin/blog-form.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("./view/admin/blog-form.jsp").forward(request, response);
    }

    private void addBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        Part filePart = request.getPart("image");

        // Validate input
        Map<String, String> errors = validateBlog(title, content, status, filePart, false);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("title", title);
            request.setAttribute("content", content);
            request.setAttribute("status", status);
            request.getRequestDispatcher("./view/admin/blog-form.jsp").forward(request, response);
            return;
        }

        // Process file upload
        String uploadPath = getServletContext().getRealPath(filePath);
        Upload upload = new Upload();
        String namePathSaveDB = filePath + upload.uploadImg(filePart, uploadPath);

        Blog blog = new Blog();
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(1);
        blog.setStatus(status);
        blog.setImage(namePathSaveDB);

        blogDAO.addBlog(blog);
        response.sendRedirect("ManageBlogController");
    }

    private void updateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("blog_id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        Part filePart = request.getPart("image");

        // Validate input
        Map<String, String> errors = validateBlog(title, content, status, null, true);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("blogId", id);
            request.setAttribute("title", title);
            request.setAttribute("content", content);
            request.setAttribute("status", status);
            request.getRequestDispatcher("./view/admin/blog-form.jsp").forward(request, response);
            return;
        }

        String uploadPath = getServletContext().getRealPath(filePath);
        Upload upload = new Upload();
        String nameUpload = upload.uploadImg(filePart, uploadPath);
        String namePathSaveDB = filePath + nameUpload;
        if (nameUpload == null) {
            namePathSaveDB = request.getParameter("oldImage");
        }
        

        Blog blog = new Blog();
        blog.setBlogId(id);
        blog.setTitle(title);
        blog.setContent(content);
        blog.setAuthorId(1);
        blog.setStatus(status);
        blog.setImage(namePathSaveDB);

        blogDAO.updateBlog(blog);
        response.sendRedirect("ManageBlogController");
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("blog_id"));
        blogDAO.deleteBlog(id);
        response.sendRedirect("ManageBlogController");
    }

    private Map<String, String> validateBlog(String title, String content, String status, Part filePart, boolean isEdit) {
        Map<String, String> errors = new HashMap<>();

        if (title == null || title.trim().isEmpty()) {
            errors.put("title", "Title cannot be empty.");
        }

        if (content == null || content.trim().isEmpty()) {
            errors.put("content", "Content cannot be empty.");
        }

        if (status == null || (!status.equals("hidden") && !status.equals("published"))) {
            errors.put("status", "Invalid status. Choose 'draft' or 'published'.");
        }
        if (!isEdit) {
            if (filePart == null || filePart.getSize() == 0) {
                errors.put("image", "Please upload an image.");
            } else {
                String fileName = filePart.getSubmittedFileName();
                if (!fileName.matches(".*\\.(jpg|jpeg|png|gif)$")) {
                    errors.put("image", "Only image files (JPG, JPEG, PNG, GIF) are allowed.");
                }
            }
        }
        return errors;
    }
}
