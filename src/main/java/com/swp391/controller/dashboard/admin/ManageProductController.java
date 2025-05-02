/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.swp391.controller.dashboard.admin;

import com.swp391.dal.impl.CategoryDAO;
import com.swp391.dal.impl.ProductDAO;
import com.swp391.dal.impl.ProductSizeDAO; // Import DAO mới
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.entity.ProductSize; // Import entity mới
import com.swp391.utils.Upload;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.xml.bind.ValidationException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Connection; // Import connection
import java.sql.SQLException; // Import SQLException
import java.util.ArrayList; // Import ArrayList
import java.util.List;

@WebServlet(name = "ManageProductController", urlPatterns = {"/admin/manage-product"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50)
public class ManageProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO(); // Thêm DAO này
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAO(); // Thêm DAO này

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "list" : action; // Gán default action

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
            case "manageSizes": // Thêm action quản lý size
                showManageSizesForm(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "list" : action; // Gán default action

        switch (action) {
            case "add":
                insertProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
             case "saveSizes": // Thêm action lưu size
                saveProductSizes(request, response);
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
        int pageSize = 10; // Có thể lấy từ config hoặc request
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); if (page < 1) page = 1; }
            catch (NumberFormatException e) { page = 1; }
        }

        List<Category> categories = categoryDAO.findAll(); // Dùng categoryDAO đã khởi tạo
        // DAO đã được sửa để không trả về stock trong Product object
        List<Product> productList = productDAO.findProductsWithFilters(searchFilter, statusFilter, categoryFilter, page, pageSize);
        int totalCount = productDAO.getTotalProductCountWithFilters(searchFilter, statusFilter, categoryFilter);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        request.setAttribute("categories", categories);
        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchFilter", searchFilter); // Truyền lại filter để giữ giá trị trên form
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("categoryFilter", categoryFilter);

        request.getRequestDispatcher("../view/admin/product-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAll(); // Dùng categoryDAO đã khởi tạo
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("../view/admin/product-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            // findById đã được sửa để không lấy stock
            Product product = productDAO.findById(id);
            if (product != null) {
                List<Category> categories = categoryDAO.findAll(); // Dùng categoryDAO đã khởi tạo
                request.setAttribute("categories", categories);
                request.setAttribute("product", product);
                request.getRequestDispatcher("../view/admin/product-edit.jsp").forward(request, response);
            } else {
                 request.getSession().setAttribute("toastMessage", "Product not found!");
                 request.getSession().setAttribute("toastType", "error");
                 response.sendRedirect(request.getContextPath() + "/admin/manage-product");
            }
         } catch (NumberFormatException e) {
             request.getSession().setAttribute("toastMessage", "Invalid product ID format!");
             request.getSession().setAttribute("toastType", "error");
             response.sendRedirect(request.getContextPath() + "/admin/manage-product");
         }
    }

     // Hiển thị form quản lý size
     private void showManageSizesForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.findById(productId); // Lấy thông tin cơ bản sản phẩm
             if (product == null) {
                 request.getSession().setAttribute("toastMessage", "Product not found!");
                 request.getSession().setAttribute("toastType", "error");
                 response.sendRedirect(request.getContextPath() + "/admin/manage-product");
                 return;
             }
            List<ProductSize> sizes = productSizeDAO.findByProductId(productId); // Lấy các size hiện có

            request.setAttribute("product", product);
            request.setAttribute("sizes", sizes);
            request.getRequestDispatcher("../view/admin/product-manage-sizes.jsp").forward(request, response);

         } catch (NumberFormatException e) {
             request.getSession().setAttribute("toastMessage", "Invalid product ID format!");
             request.getSession().setAttribute("toastType", "error");
             response.sendRedirect(request.getContextPath() + "/admin/manage-product");
         }
     }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String statusStr = request.getParameter("status");
        Part mainImgPart = request.getPart("image");
        // Bỏ đọc stockStr

        StringBuilder errorMsg = new StringBuilder();
        int categoryId = -1;
        BigDecimal price = BigDecimal.ZERO;
        boolean status = true; // Default status
        String fileNameImg = null;

        try { categoryId = Integer.parseInt(categoryIdStr); }
        catch (NumberFormatException e) { errorMsg.append("Invalid Category ID. "); }

        if (name == null || name.trim().isEmpty()) errorMsg.append("Product name is required. ");
        if (description == null || description.trim().isEmpty()) errorMsg.append("Description is required. ");

        try { price = new BigDecimal(priceStr); if (price.compareTo(BigDecimal.ZERO) <= 0) errorMsg.append("Price must be positive. "); }
        catch (NumberFormatException | NullPointerException e) { errorMsg.append("Invalid price format. "); }

        try { status = Boolean.parseBoolean(statusStr); }
        catch (Exception e) { errorMsg.append("Invalid status value. "); }

        // Xử lý upload ảnh
         String pathProduct = "/uploads/product/"; // Dùng / ở đầu cho đường dẫn tương đối web
         String uploadPath = getServletContext().getRealPath(pathProduct);
         Upload upload = new Upload();
         if (mainImgPart == null || mainImgPart.getSize() == 0) {
             errorMsg.append("Product image is required. ");
         } else {
             String fileName = upload.uploadImg(mainImgPart, uploadPath);
             if (fileName == null) {
                 errorMsg.append("Failed to upload image. Check path or permissions. ");
                 System.err.println("Failed upload, path: " + uploadPath); // Log lỗi path
             } else {
                 String contentType = mainImgPart.getContentType();
                 if (!contentType.startsWith("image/")) {
                     errorMsg.append("File must be an image. ");
                 } else {
                     fileNameImg = pathProduct + fileName; // Lưu path tương đối web
                 }
             }
         }

        if (errorMsg.length() > 0) {
            request.setAttribute("errorMessage", errorMsg.toString());
            // Load lại categories cho form add
             List<Category> categories = categoryDAO.findAll();
             request.setAttribute("categories", categories);
             request.setAttribute("productName", name); // Giữ lại giá trị đã nhập
             request.setAttribute("productDesc", description);
             request.setAttribute("productPrice", priceStr);
             request.setAttribute("selectedCategory", categoryIdStr);
             request.setAttribute("selectedStatus", statusStr);
            request.getRequestDispatcher("../view/admin/product-add.jsp").forward(request, response);
            return;
        }

        Product product = Product.builder()
                .categoryId(categoryId)
                .name(name.trim())
                .description(description.trim())
                .price(price)
                .image(fileNameImg)
                .status(status)
                // Không set stock ở đây
                .build();

        int newProductId = productDAO.insert(product);

        if (newProductId > 0) {
            // Thêm size mặc định "One Size" với stock = 0 sau khi tạo sản phẩm
            // Bạn có thể thay đổi logic này nếu muốn
            Connection conn = null;
             try {
                 conn = productDAO.getConnection(); // Lấy connection từ DAO (cần public method này trong DBContext)
                 conn.setAutoCommit(false);
                 ProductSize defaultSize = ProductSize.builder()
                         .productId(newProductId)
                         .size("One Size") // Hoặc "N/A"
                         .stock(0) // Stock ban đầu là 0
                         .createdAt(java.time.LocalDateTime.now())
                         .updatedAt(java.time.LocalDateTime.now())
                         .build();
                 productSizeDAO.insert(defaultSize, conn);
                 conn.commit();
                 request.getSession().setAttribute("toastMessage", "Product added successfully! Please manage sizes.");
                 request.getSession().setAttribute("toastType", "success");
                 // Chuyển hướng đến trang quản lý size của sản phẩm mới
                  response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=manageSizes&id=" + newProductId);
             } catch (SQLException e) {
                  if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
                  e.printStackTrace(); // Log lỗi
                  request.getSession().setAttribute("toastMessage", "Product added, but failed to add default size.");
                  request.getSession().setAttribute("toastType", "warning");
                  response.sendRedirect(request.getContextPath() + "/admin/manage-product"); // Về list chung
             } finally {
                  if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) {}
             }
            // response.sendRedirect(request.getContextPath() + "/admin/manage-product?statusM=1&typeM=add");
        } else {
             request.getSession().setAttribute("toastMessage", "Failed to add product.");
             request.getSession().setAttribute("toastType", "error");
             response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=add"); // Quay lại form add
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
         String idStr = request.getParameter("productId");
         String name = request.getParameter("name");
         String description = request.getParameter("description");
         String categoryIdStr = request.getParameter("categoryId");
         String priceStr = request.getParameter("price");
         String statusStr = request.getParameter("status");
         String oldImage = request.getParameter("oldImage");
         Part mainImgPart = request.getPart("image");
         // Bỏ đọc stockStr

         StringBuilder errorMsg = new StringBuilder();
         int id = -1;
         int categoryId = -1;
         BigDecimal price = BigDecimal.ZERO;
         boolean status = false;
         String fileNameImg = oldImage; // Mặc định giữ ảnh cũ

         try { id = Integer.parseInt(idStr); }
         catch (NumberFormatException e) { errorMsg.append("Invalid Product ID. "); }

         try { categoryId = Integer.parseInt(categoryIdStr); }
         catch (NumberFormatException e) { errorMsg.append("Invalid Category ID. "); }

         if (name == null || name.trim().isEmpty()) errorMsg.append("Product name is required. ");
         if (description == null || description.trim().isEmpty()) errorMsg.append("Description is required. ");

         try { price = new BigDecimal(priceStr); if (price.compareTo(BigDecimal.ZERO) <= 0) errorMsg.append("Price must be positive. "); }
         catch (NumberFormatException | NullPointerException e) { errorMsg.append("Invalid price format. "); }

         try { status = Boolean.parseBoolean(statusStr); }
         catch (Exception e) { errorMsg.append("Invalid status value. "); }

         // Xử lý upload ảnh mới (nếu có)
          String pathProduct = "/uploads/product/";
          String uploadPath = getServletContext().getRealPath(pathProduct);
          Upload upload = new Upload();
          if (mainImgPart != null && mainImgPart.getSize() > 0) {
               String fileName = upload.uploadImg(mainImgPart, uploadPath);
               if (fileName == null) {
                    errorMsg.append("Failed to upload new image. ");
               } else {
                    String contentType = mainImgPart.getContentType();
                    if (!contentType.startsWith("image/")) {
                         errorMsg.append("New file must be an image. ");
                    } else {
                         fileNameImg = pathProduct + fileName; // Cập nhật ảnh mới
                         // TODO: Có thể thêm logic xóa ảnh cũ (oldImage) khỏi server ở đây
                    }
               }
          } else if (oldImage == null || oldImage.trim().isEmpty()) {
               // Trường hợp không có ảnh mới và cũng không có ảnh cũ -> lỗi
               errorMsg.append("Product image is required. ");
          }


         if (errorMsg.length() > 0) {
             request.setAttribute("errorMessage", errorMsg.toString());
             // Load lại categories và product cho form edit
             Product product = productDAO.findById(id); // Lấy lại product để hiển thị form
             List<Category> categories = categoryDAO.findAll();
             request.setAttribute("categories", categories);
             request.setAttribute("product", product); // Truyền lại product cũ nếu có lỗi
             request.getRequestDispatcher("../view/admin/product-edit.jsp").forward(request, response);
             return;
         }

         Product product = Product.builder()
                 .productId(id)
                 .categoryId(categoryId)
                 .name(name.trim())
                 .description(description.trim())
                 .price(price)
                 .image(fileNameImg) // Ảnh mới hoặc cũ
                 .status(status)
                 // Không set stock ở đây
                 .build();

         boolean result = productDAO.update(product);

         if (result) {
              request.getSession().setAttribute("toastMessage", "Product updated successfully!");
              request.getSession().setAttribute("toastType", "success");
              response.sendRedirect(request.getContextPath() + "/admin/manage-product"); // Về list
         } else {
              request.getSession().setAttribute("toastMessage", "Failed to update product.");
              request.getSession().setAttribute("toastType", "error");
              response.sendRedirect(request.getContextPath() + "/admin/manage-product?action=edit&id=" + id); // Quay lại form edit
         }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
         String message = "Failed to delete product.";
         String type = "error";
         try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = Product.builder().productId(id).build(); // Chỉ cần ID để xóa
            // DAO delete đã bao gồm cascade xóa product_sizes
            boolean deleted = productDAO.delete(product);
            if (deleted) {
                 message = "Product deleted successfully!";
                 type = "success";
            } else {
                 message = "Product not found or could not be deleted.";
            }
         } catch (NumberFormatException e) {
              message = "Invalid product ID format.";
         } catch (Exception e) { // Bắt các lỗi khác (ví dụ: lỗi DB)
              message = "Error deleting product: " + e.getMessage();
              e.printStackTrace();
         }
         request.getSession().setAttribute("toastMessage", message);
         request.getSession().setAttribute("toastType", type);
         response.sendRedirect(request.getContextPath() + "/admin/manage-product");
    }

    // Lưu thay đổi sizes từ form quản lý size
     private void saveProductSizes(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
     Connection conn = null;
     String redirectUrl = request.getContextPath() + "/admin/manage-product";
     int productId = -1;
     String errorMessage = null;

     try {
         productId = Integer.parseInt(request.getParameter("productId"));
         redirectUrl = request.getContextPath() + "/admin/manage-product?action=manageSizes&id=" + productId;

         String[] sizeIdsStr = request.getParameterValues("sizeId");
         String[] sizes = request.getParameterValues("size");
         String[] stocks = request.getParameterValues("stock");
         String[] deleteIdsStr = request.getParameterValues("deleteSize");

         conn = productDAO.getConnection();
         conn.setAutoCommit(false);

         // --- Xử lý xóa trước ---
         List<Integer> idsToDelete = new ArrayList<>();
         if (deleteIdsStr != null) { /* ... parse deleteIdsStr vào idsToDelete ... */ }
         // Lấy trạng thái trước khi xóa để kiểm tra logic xóa One Size cuối cùng
          boolean hadOnlyOneSizeBeforeDelete = productSizeDAO.hasOneSize(productId, conn) && !productSizeDAO.hasSpecificSizes(productId, conn);
          if (hadOnlyOneSizeBeforeDelete) {
              ProductSize oneSize = productSizeDAO.findByProductId(productId, conn).get(0); // Lấy One Size duy nhất
               if (idsToDelete.contains(oneSize.getProductSizeId())) {
                   throw new ValidationException("Cannot delete 'One Size' when it's the only size.");
               }
          }
         // Thực hiện xóa
         for (int idToDel : idsToDelete) { productSizeDAO.delete(idToDel, conn); }


         // --- Xử lý thêm/sửa ---
         boolean requestContainsOneSize = false;
         boolean requestContainsSpecificSize = false;
         List<String> namesInRequest = new ArrayList<>();

         if (sizes != null && stocks != null && sizes.length == stocks.length) {
             for (int i = 0; i < sizes.length; i++) {
                 String sizeNameInput = sizes[i].trim();
                 int stock = 0;
                 int sizeId = -1;

                 if (sizeNameInput.isEmpty()) continue;

                 // Lấy sizeId và stock
                 if (sizeIdsStr != null && i < sizeIdsStr.length && !sizeIdsStr[i].isEmpty()) {
                     try { sizeId = Integer.parseInt(sizeIdsStr[i]); } catch (NumberFormatException e) { sizeId = -1; }
                 }
                 try { stock = Integer.parseInt(stocks[i]); if (stock < 0) stock = 0; }
                 catch (NumberFormatException e) { stock = 0; }

                 // Bỏ qua nếu hàng này đã xóa
                 if (sizeId > 0 && idsToDelete.contains(sizeId)) continue;

                 // ** KIỂM TRA TRÙNG TÊN TRONG REQUEST **
                 String lowerCaseSizeName = sizeNameInput.toLowerCase();
                 if (namesInRequest.contains(lowerCaseSizeName)) {
                     throw new ValidationException("Duplicate size name '" + sizeNameInput + "' found in the form.");
                 }
                 namesInRequest.add(lowerCaseSizeName);

                 // ** KIỂM TRA TRÙNG TÊN VỚI DB (cho size MỚI hoặc khi ĐỔI TÊN size cũ) **
                  boolean nameExistsInDb = productSizeDAO.sizeNameExists(productId, sizeNameInput, sizeId, conn);
                  if (nameExistsInDb) {
                       throw new ValidationException("Size name '" + sizeNameInput + "' already exists for this product.");
                  }


                 // Ghi nhận loại size trong request
                 if ("one size".equals(lowerCaseSizeName)) {
                     requestContainsOneSize = true;
                 } else {
                     requestContainsSpecificSize = true;
                 }

                 // *** KIỂM TRA LOGIC ONE SIZE vs SPECIFIC ***
                  if (requestContainsOneSize && requestContainsSpecificSize) {
                       throw new ValidationException("Cannot have both 'One Size' and specific sizes in the same update.");
                  }

                 // --- THỰC HIỆN INSERT/UPDATE ---
                 ProductSize sizeToSave = ProductSize.builder()
                         .productSizeId(sizeId > 0 ? sizeId : null)
                         .productId(productId)
                         .size(sizeNameInput) // Giữ case gốc
                         .stock(stock)
                         .build();

                 if (sizeId > 0) { // Update
                      System.out.println("[SaveSizes] Updating DB - sizeId: " + sizeId + " -> Name: " + sizeNameInput + ", Stock: " + stock);
                     sizeToSave.setUpdatedAt(java.time.LocalDateTime.now());
                     productSizeDAO.update(sizeToSave, conn);
                 } else { // Insert
                      System.out.println("[SaveSizes] Inserting DB - Name: " + sizeNameInput + ", Stock: " + stock);
                      sizeToSave.setCreatedAt(java.time.LocalDateTime.now());
                      sizeToSave.setUpdatedAt(java.time.LocalDateTime.now());
                     int newId = productSizeDAO.insert(sizeToSave, conn);
                      if(newId <= 0) { throw new SQLException("Failed to insert new size: " + sizeNameInput); }
                 }
             } // end for
         } // end if sizes != null


         // --- Bước cuối: Đảm bảo còn ít nhất 1 size ---
         List<ProductSize> finalSizes = productSizeDAO.findByProductId(productId, conn);
         if (finalSizes.isEmpty()) {
              System.out.println("[SaveSizes] Final list is empty. Adding default 'One Size'.");
              ProductSize defaultSize = ProductSize.builder()
                     .productId(productId).size("One Size").stock(0)
                     .createdAt(java.time.LocalDateTime.now()).updatedAt(java.time.LocalDateTime.now()).build();
              productSizeDAO.insert(defaultSize, conn);
         }

         conn.commit();
         request.getSession().setAttribute("toastMessage", "Product sizes updated successfully!");
         request.getSession().setAttribute("toastType", "success");
         redirectUrl = request.getContextPath() + "/admin/manage-product"; // Về list

     } catch (ValidationException e) {
         if (conn != null) try { conn.rollback(); System.err.println("Rolled back due to ValidationException."); } catch (SQLException ex) { ex.printStackTrace(); }
         errorMessage = e.getMessage();
         request.getSession().setAttribute("toastMessage", errorMessage);
         request.getSession().setAttribute("toastType", "error");
         System.err.println("[SaveSizes] Validation Error Caught: " + errorMessage);
     } catch (NumberFormatException e) {
          if (conn != null) try { conn.rollback(); System.err.println("Rolled back due to NumberFormatException."); } catch (SQLException ex) { ex.printStackTrace(); }
          errorMessage = "Invalid input format for ID or stock.";
         request.getSession().setAttribute("toastMessage", errorMessage);
         request.getSession().setAttribute("toastType", "error");
         e.printStackTrace();
     } catch (SQLException e) {
          if (conn != null) try { conn.rollback(); System.err.println("Rolled back due to SQLException."); } catch (SQLException ex) { ex.printStackTrace(); }
          errorMessage = "Database error saving sizes: " + e.getMessage();
         request.getSession().setAttribute("toastMessage", errorMessage);
         request.getSession().setAttribute("toastType", "error");
         e.printStackTrace();
     } catch (Exception e) {
          if (conn != null) try { conn.rollback(); System.err.println("Rolled back due to unexpected Exception."); } catch (SQLException ex) { ex.printStackTrace(); }
           errorMessage = "An unexpected error occurred: " + e.getMessage();
          request.getSession().setAttribute("toastMessage", errorMessage);
          request.getSession().setAttribute("toastType", "error");
          e.printStackTrace();
     }
     finally {
         if (conn != null) {
             try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
         }
     }
      System.out.println("[SaveSizes] Redirecting to: " + redirectUrl);
     response.sendRedirect(redirectUrl);
 }

}