package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.SliderDAO;
import com.swp391.entity.Slider;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

@WebServlet(name = "SliderController", urlPatterns = {"/slider"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class SliderController extends HttpServlet {

    private final SliderDAO sliderDAO = new SliderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Slider slider = sliderDAO.getSliderById(id);
                    if (slider != null) {
                        request.setAttribute("slider", slider);
                        request.getRequestDispatcher("view/admin/slider-edit.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("slider?status=false&type=no_found");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect("slider?status=false&type=invalid_id");
                }
                break;
            case "delete":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                     Slider sliderToDelete = sliderDAO.getSliderById(id);
                     if (sliderToDelete != null && sliderToDelete.getImageUrl() != null && !sliderToDelete.getImageUrl().isEmpty()) {
                         String oldFilePath = getServletContext().getRealPath("") + File.separator + sliderToDelete.getImageUrl().replace("/", File.separator);
                         File oldFile = new File(oldFilePath);
                         if (oldFile.exists() && !oldFile.isDirectory()) {
                             oldFile.delete();
                             System.out.println("Deleted image file associated with slider ID " + id + ": " + oldFilePath);
                         }
                     }
                    sliderDAO.deleteSlider(id);
                    response.sendRedirect("slider?status=true&type=delete");
                } catch (NumberFormatException e) {
                     response.sendRedirect("slider?status=false&type=invalid_id");
                } catch (Exception e) {
                     System.err.println("Error deleting slider or its image: " + e.getMessage());
                     response.sendRedirect("slider?status=false&type=delete_error");
                 }
                break;
            case "add":
                request.getRequestDispatcher("view/admin/slider-add.jsp").forward(request, response);
                break;

            default:
                List<Slider> sliders = sliderDAO.getAllSliders();
                request.setAttribute("sliderList", sliders);
                request.getRequestDispatcher("view/admin/slider-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        int bannerId = 0;
        try {
             String bannerIdParam = request.getParameter("bannerId");
             if (bannerIdParam != null && !bannerIdParam.isEmpty()) {
                 bannerId = Integer.parseInt(bannerIdParam);
             }
        } catch (NumberFormatException e) {
            System.err.println("Invalid bannerId format: " + e.getMessage());
        }

        String name = request.getParameter("name");

        int productId = 0;
        try {
            String productIdParam = request.getParameter("productId");
            if (productIdParam != null && !productIdParam.isEmpty()) {
                 productId = Integer.parseInt(productIdParam);
            } else {
                 System.err.println("Warning: productId not provided or empty.");
                 productId = 0; // Hoặc giá trị mặc định phù hợp
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid productId format: " + e.getMessage());
             productId = 0;
        }

        boolean status = Boolean.parseBoolean(request.getParameter("status"));

        String imageUrl = null;
        String existingImageUrl = request.getParameter("existingImageUrl");

        try {
            Part filePart = request.getPart("imageFile");

            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                String sliderUploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "slider";

                File uploadDir = new File(sliderUploadPath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    if (!created) {
                       System.err.println("Failed to create upload directory: " + sliderUploadPath);
                       throw new IOException("Could not create upload directory: " + sliderUploadPath);
                    }
                }

                String uniqueName = System.currentTimeMillis() + "_" + fileName;
                String filePath = sliderUploadPath + File.separator + uniqueName;

                filePart.write(filePath);

                imageUrl = "uploads/slider/" + uniqueName;

                if (bannerId > 0 && existingImageUrl != null && !existingImageUrl.isEmpty()) {
                    String oldFilePath = getServletContext().getRealPath("") + File.separator + existingImageUrl.replace("/", File.separator);
                    File oldFile = new File(oldFilePath);
                    if (oldFile.exists() && !oldFile.isDirectory()) {
                        boolean deleted = oldFile.delete();
                         if(deleted) {
                             System.out.println("Deleted old image: " + oldFilePath);
                         } else {
                             System.err.println("Failed to delete old image: " + oldFilePath);
                         }
                    }
                }

            } else {
                imageUrl = existingImageUrl;
                System.out.println("No new image uploaded or empty file, keeping existing: " + imageUrl);
            }
        } catch (Exception e) {
            System.err.println("Error processing image upload: " + e.getMessage());
            imageUrl = existingImageUrl;
            request.setAttribute("error", "Error uploading image: " + e.getMessage());
        }

        if (name == null || name.trim().isEmpty() || imageUrl == null || imageUrl.trim().isEmpty()) {
            String errorMsg = "";
            if (name == null || name.trim().isEmpty()) errorMsg += "Slider Name is required. ";
            if (imageUrl == null || imageUrl.trim().isEmpty()) errorMsg += "Slider Image is required (upload failed or no existing image).";

            request.setAttribute("error", errorMsg.trim());

            Slider sliderData = new Slider(bannerId, name, (imageUrl != null ? imageUrl : existingImageUrl), productId, status);
            request.setAttribute("slider", sliderData);

            if (bannerId > 0) {
                 request.getRequestDispatcher("view/admin/slider-edit.jsp").forward(request, response);
            } else {
                 request.getRequestDispatcher("view/admin/slider-add.jsp").forward(request, response);
            }
            return;
        }


        Slider slider = new Slider(bannerId, name, imageUrl, productId, status);

        try {
            if (bannerId > 0) {
                System.out.println("Updating slider (ID: " + bannerId + "): " + slider.getName() + ", Image: " + slider.getImageUrl());
                sliderDAO.updateSlider(slider);
                response.sendRedirect("slider?status=true&type=update");
            } else {
                System.out.println("Adding new slider: " + slider.getName() + ", Image: " + slider.getImageUrl());
                sliderDAO.addSlider(slider);
                response.sendRedirect("slider?status=true&type=add");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("slider?status=false&type=dberror&message=" + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Database operation failed", "UTF-8"));
        }
    }

    @Override
    public String getServletInfo() {
        return "Slider management controller for admin dashboard";
    }
}