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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ProductController", urlPatterns = {"/products"}) // Ensure this is correctly mapped
public class ProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private static final Logger LOGGER = Logger.getLogger(ProductController.class.getName());
    private static final List<String> VALID_SORT_OPTIONS = List.of("default", "price_asc", "price_desc", "name_asc", "name_desc");


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8"); // Good practice for handling parameters

            // --- Pagination ---
            int page = 1;
            int pageSize = 9; // Define your page size
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid page number format: {0}. Defaulting to 1.", pageParam);
                    page = 1;
                }
            }

            // --- Filtering Parameters ---
            String keyword = request.getParameter("keyword");
            if (keyword == null) {
                keyword = "";
            } else {
                keyword = keyword.trim();
            }

            Integer categoryId = null;
            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdParam);
                    if (categoryId == 0) categoryId = null; // Treat 0 as 'All Categories'
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid category ID format: {0}. Ignoring category filter.", categoryIdParam);
                    categoryId = null;
                }
            }

            // --- Price Filtering Parameters ---
            String minPriceParam = request.getParameter("minPrice");
            String maxPriceParam = request.getParameter("maxPrice");
            String priceRangeParam = request.getParameter("priceRange");
            String selectedPriceRange = (priceRangeParam == null || priceRangeParam.isEmpty()) ? "all" : priceRangeParam; // Store raw value for JSP dropdown
            String priceErrorMessage = null;

            BigDecimal minPrice = null;
            BigDecimal maxPrice = null;
            boolean useManualPrices = false;

            

            // 2. If NO valid manual prices were set, process the price RANGE dropdown
            if (!useManualPrices && selectedPriceRange != null && !selectedPriceRange.equalsIgnoreCase("all")) {
                String[] parts = selectedPriceRange.split("_");
                if (parts.length == 2) {
                    try {
                        // These will become the actual min/max for filtering if range is used
                        minPrice = new BigDecimal(parts[0]);
                        maxPrice = new BigDecimal(parts[1]);

                        if (minPrice.compareTo(BigDecimal.ZERO) < 0) {
                            LOGGER.log(Level.WARNING, "Minimum price in range {0} is negative. Correcting range.", selectedPriceRange);
                            minPrice = BigDecimal.ZERO; // Correct negative range min
                        }
                        // Basic check within range parsing itself
                        if (minPrice.compareTo(maxPrice) > 0) {
                            LOGGER.log(Level.WARNING, "Min price greater than max price in range {0}. Ignoring range.", selectedPriceRange);
                             minPrice = null; // Ignore invalid range
                             maxPrice = null;
                             selectedPriceRange = "all"; // Reset dropdown selection for JSP
                        }

                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid number format in price range parameter: {0}. Ignoring price filter.", selectedPriceRange);
                        minPrice = null; // Reset on error
                        maxPrice = null;
                        selectedPriceRange = "all"; // Reset dropdown selection for JSP
                    }
                } else {
                    LOGGER.log(Level.WARNING, "Invalid price range format: {0}. Expected 'min_max' or 'all'. Ignoring price filter.", selectedPriceRange);
                    selectedPriceRange = "all"; // Reset dropdown selection for JSP
                }
            } else if (useManualPrices) {
                 // If manual prices ARE used, ensure the dropdown shows "All Prices" or is reset
                 selectedPriceRange = "all";
            }


            // --- Sorting Parameter ---
            String sortBy = request.getParameter("sortBy");
            if (sortBy == null || sortBy.trim().isEmpty() || !VALID_SORT_OPTIONS.contains(sortBy.trim().toLowerCase())) {
                 if (sortBy != null && !sortBy.trim().isEmpty()){
                      LOGGER.log(Level.WARNING, "Invalid sortBy value: {0}. Defaulting to 'default'.", sortBy);
                 }
                 sortBy = "default";
            } else {
                sortBy = sortBy.trim().toLowerCase();
            }

            // --- Data Fetching (Pass final minPrice, maxPrice to DAO) ---
            // Assuming your DAO methods now accept BigDecimal minPrice, maxPrice
            int totalProducts = productDAO.countProducts(keyword, categoryId, minPrice, maxPrice); // Pass parsed values
            List<Product> products = productDAO.getActiveProducts(page, pageSize, keyword, categoryId, minPrice, maxPrice, sortBy); // Pass parsed values

            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            if (totalPages == 0 && totalProducts > 0) totalPages = 1; // Handle case of 1 to pageSize products
            if (page > totalPages && totalPages > 0) {
                 page = totalPages; // Adjust page if it exceeds max after filtering
                 // Optionally re-fetch products for the corrected page if needed, though often acceptable to show empty list if first fetch was beyond bounds
            } else if (totalPages == 0){
                 page = 1; // If no products, stay on page 1
            }


            // --- Fetch Categories ---
            List<Category> categories = categoryDAO.findAllActiveCategories(); // Assuming this method exists

            // --- Set Attributes for JSP ---
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            // request.setAttribute("pageSize", pageSize); // Only if JSP needs it

            // Filters/Sort state to repopulate form/links
            request.setAttribute("keyword", keyword);
            request.setAttribute("categoryId", categoryId); // Can be null if 'All' was selected
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("selectedPriceRange", selectedPriceRange); // Set state for the dropdown

            // Values for manual input fields (pass back original params)
            request.setAttribute("minPrice", minPriceParam); // Use original string param
            request.setAttribute("maxPrice", maxPriceParam); // Use original string param

            // Error message if validation failed
            if (priceErrorMessage != null) {
                request.setAttribute("priceErrorMessage", priceErrorMessage);
            }


            // --- Forward to JSP ---
            // Ensure this path is correct for your project structure
            request.getRequestDispatcher("./view/product/product-list.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing product list request", e);
            // Set an error attribute for a generic error page
            request.setAttribute("errorMessage", "An unexpected error occurred while retrieving products. Please try again later.");
            // Forward to a generic error page (create one if you don't have it)
            request.getRequestDispatcher("/view/common/error.jsp").forward(request, response);
            // Or rethrow if you have a higher-level error handler
            // throw new ServletException("Error retrieving product list.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Filtering/display is generally done via GET for bookmarkability
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying and filtering products with manual and range price options";
    }
}
