package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import com.swp391.entity.ProductSize;
import java.math.BigDecimal; // Ensure BigDecimal is imported
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductDAO extends DBContext implements I_DAO<Product> {

    // DAOs for related entities
    private CategoryDAO categoryDao = new CategoryDAO(); // Assuming it exists for Category mapping
    private ProductSizeDAO productSizeDAO = new ProductSizeDAO(); // DAO for handling sizes
    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    // === Existing Methods (findAll, findProductsWithFilters, getTotalProductCountWithFilters, update, delete, insert) remain largely unchanged ===
    // ... (Keep your existing implementations for these methods) ...

    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name, c.description as category_description "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = getFromResultSet(rs); // Fetch product and basic category info
                if (product != null) {
                    // Fetch associated sizes for this product
                    List<ProductSize> sizes = productSizeDAO.findByProductId(product.getProductId());
                    product.setSizes(sizes); // Set the sizes list on the product object
                    products.add(product);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all products with sizes", ex);
        }
        return products;
    }

    public List<Product> findProductsWithFilters(String searchFilter, String statusFilter, String categoryFilter, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name as category_name, c.description as category_description "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters using table alias 'p.'
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND p.status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND p.category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        // Add pagination (ORDER BY first, then LIMIT/OFFSET)
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        sql.append("ORDER BY p.created_at DESC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = getFromResultSet(rs);
                    if (product != null) {
                        // Optionally fetch sizes here if needed for admin list view
                        // List<ProductSize> sizes = productSizeDAO.findByProductId(product.getProductId());
                        // product.setSizes(sizes);
                        products.add(product);
                    }
                }
            }
        } catch (SQLException ex) {
             LOGGER.log(Level.SEVERE, "Error finding filtered products (admin)", ex);
        }
        return products;
    }

    public int getTotalProductCountWithFilters(String searchFilter, String statusFilter, String categoryFilter) {
        int totalCount = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products p WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters using table alias 'p.'
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.description LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND p.status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND p.category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting total product count (admin)", ex);
        }
        return totalCount;
    }

    @Override
    public boolean update(Product product) {
        // Ensure column names match your DB (e.g., updated_at vs updatedDate)
        String sql = "UPDATE products SET category_id=?, name=?, description=?, price=?, image=?, status=?, updated_at=? WHERE product_id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Set category_id, allowing NULL
            if (product.getCategory() != null) {
                 stmt.setInt(1, product.getCategory().getCategoryId());
            } else if (product.getCategoryId() != null) {
                 stmt.setInt(1, product.getCategoryId());
            } else {
                 stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setBigDecimal(4, product.getPrice());
            stmt.setString(5, product.getImage());
            stmt.setBoolean(6, product.getStatus());
            stmt.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now())); // Set updated_at timestamp
            stmt.setInt(8, product.getProductId()); // WHERE clause
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating product", ex);
        }
        return false;
    }

    @Override
    public boolean delete(Product product) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, product.getProductId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting product", ex);
        }
        return false;
    }

    @Override
    public int insert(Product product) {
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        String sql = "INSERT INTO products (category_id, name, description, price, image, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Set category_id, allowing NULL
             if (product.getCategory() != null) {
                 stmt.setInt(1, product.getCategory().getCategoryId());
            } else if (product.getCategoryId() != null) {
                 stmt.setInt(1, product.getCategoryId());
            } else {
                 stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setBigDecimal(4, product.getPrice());
            stmt.setString(5, product.getImage());
            stmt.setBoolean(6, product.getStatus()); // Assuming status is a boolean/bit
            LocalDateTime now = LocalDateTime.now();
            stmt.setTimestamp(7, Timestamp.valueOf(now)); // created_at
            stmt.setTimestamp(8, Timestamp.valueOf(now)); // updated_at

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the new product ID
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting product", ex);
        }
        return -1; // Indicate failure
    }

    /**
     * Maps a row from a ResultSet to a Product object.
     * Handles potential NULLs for category and timestamps.
     * Assumes DB column names like 'product_id', 'created_at', 'updated_at', 'category_id'. Adjust if needed.
     */
    @Override
    public Product getFromResultSet(ResultSet rs) throws SQLException {
        Product.ProductBuilder builder = (Product.ProductBuilder) Product.builder();

        builder.productId(rs.getInt("product_id"));
        builder.name(rs.getString("name"));
        builder.description(rs.getString("description"));
        builder.price(rs.getBigDecimal("price")); // Ensure price column type is DECIMAL/NUMERIC
        builder.image(rs.getString("image"));
        builder.status(rs.getBoolean("status")); // Assuming status column type is BOOLEAN/BIT/TINYINT(1)

        Timestamp createdAtTs = rs.getTimestamp("created_at");
        builder.createdAt(createdAtTs != null ? createdAtTs.toLocalDateTime() : null);
        Timestamp updatedAtTs = rs.getTimestamp("updated_at");
        builder.updatedAt(updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null);

        Integer categoryId = null;
        Category category = null;
        Object categoryIdObj = rs.getObject("category_id");
        if (categoryIdObj != null) {
            categoryId = (Integer) categoryIdObj;
            builder.categoryId(categoryId);

            String categoryName = null;
            String categoryDesc = null;
            // Attempt to get category details if JOINed (using try-catch for safety if columns aren't always present)
            try { categoryName = rs.getString("category_name"); } catch (SQLException e) { /* column might not be in this query */ }
            try { categoryDesc = rs.getString("category_description"); } catch (SQLException e) { /* column might not be in this query */ }

            if (categoryId != null) { // Build category object only if ID is non-null
                 category = Category.builder()
                        .categoryId(categoryId)
                        .name(categoryName) // Will be null if category_name wasn't selected
                        .description(categoryDesc) // Will be null if category_description wasn't selected
                        .build();
                 builder.category(category);
            }
        } else {
             builder.categoryId(null);
             builder.category(null);
        }

        // Sizes are typically NOT mapped here; fetched separately.
        return builder.build();
    }


    // === Methods specific to Frontend Product Listing (Used by ProductController) ===

    /**
     * Fetches a paginated list of ACTIVE products based on user filters (keyword, category, price range) and sorting preference.
     *
     * @param page The current page number (1-based).
     * @param pageSize The number of products per page.
     * @param keyword The search term (can be empty or null).
     * @param categoryId The ID of the category to filter by (can be null for all categories).
     * @param minPrice The minimum price filter (can be null). *** MODIFIED ***
     * @param maxPrice The maximum price filter (can be null). *** MODIFIED ***
     * @param sortBy The sorting criteria ("default", "price_asc", "price_desc", "name_asc", "name_desc").
     * @return A list of active products matching the criteria.
     */
    public List<Product> getActiveProducts(int page, int pageSize, String keyword, Integer categoryId,
                                           BigDecimal minPrice, BigDecimal maxPrice, // <-- Added price parameters
                                           String sortBy) {
        List<Product> products = new ArrayList<>();
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        StringBuilder sql = new StringBuilder("SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.category_id WHERE p.status = 1");
        List<Object> params = new ArrayList<>();

        // --- Append WHERE clauses for filters ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        // *** NEW: Add price range filters ***
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice); // Add BigDecimal directly
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice); // Add BigDecimal directly
        }
        // *** END NEW ***

        // --- Append ORDER BY clause ---
        String orderByClause = switch (sortBy != null ? sortBy.toLowerCase() : "default") {
            case "price_asc" -> " ORDER BY p.price ASC, p.product_id ASC"; // Added secondary sort
            case "price_desc" -> " ORDER BY p.price DESC, p.product_id ASC"; // Added secondary sort
            case "name_asc" -> " ORDER BY p.name ASC, p.product_id ASC";    // Added secondary sort
            case "name_desc" -> " ORDER BY p.name DESC, p.product_id ASC";   // Added secondary sort
            default -> " ORDER BY p.created_at DESC, p.product_id ASC"; // Default sort by newest (Ensure created_at column exists)
        };
        sql.append(orderByClause);

        // --- Append LIMIT and OFFSET for pagination (MUST be last) ---
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        // --- Execute Query ---
        LOGGER.log(Level.INFO, "Executing SQL (getActiveProducts): {0}", sql.toString());
        LOGGER.log(Level.INFO, "With parameters: {0}", params);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            // Set parameters using setObject for flexibility
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = getFromResultSet(rs); // Map row to Product object
                     if (product != null) {
                         products.add(product);
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting active products with sorting/filtering", ex);
        }
        return products;
    }

    /**
     * Counts the total number of ACTIVE products matching user filters (keyword, category, price range).
     *
     * @param keyword The search term (can be empty or null).
     * @param categoryId The ID of the category to filter by (can be null for all categories).
     * @param minPrice The minimum price filter (can be null). *** MODIFIED ***
     * @param maxPrice The maximum price filter (can be null). *** MODIFIED ***
     * @return The total count of matching active products.
     */
    public int countProducts(String keyword, Integer categoryId,
                             BigDecimal minPrice, BigDecimal maxPrice) { // <-- Added price parameters
        int totalCount = 0;
        // Count active products
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products p WHERE p.status = 1");
        List<Object> params = new ArrayList<>();

        // --- Append WHERE clauses for filters (Must match getActiveProducts) ---
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        // *** NEW: Add price range filters ***
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice);
        }
        // *** END NEW ***

        // --- Execute Query ---
        LOGGER.log(Level.INFO, "Executing SQL (countProducts): {0}", sql.toString());
        LOGGER.log(Level.INFO, "With parameters: {0}", params);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1); // Count is in the first column
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting active products", ex);
        }
        return totalCount;
    }


    // === Other Utility Methods (getLatestActiveProducts, findById, findActiveById) remain unchanged ===

    public List<Product> getLatestActiveProducts() {
        List<Product> products = new ArrayList<>();
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        String sql = "SELECT p.*, c.name as category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.status = 1 ORDER BY p.created_at DESC LIMIT 6"; // Get latest 6 active

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                 Product product = getFromResultSet(rs);
                 if (product != null) {
                    products.add(product);
                 }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting latest active products", ex);
        }
        return products;
    }

    public Product findById(int productId) {
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        String sql = "SELECT p.*, c.name as category_name, c.description as category_description "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product product = getFromResultSet(rs); // Get product + category info
                    if (product != null) {
                        // Fetch all sizes for this product
                        List<ProductSize> sizes = productSizeDAO.findByProductId(productId);
                        product.setSizes(sizes); // Attach sizes to the product
                        return product;
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding product by ID with sizes", ex);
        }
        return null; // Not found or error
    }

    public Product findActiveById(int productId) {
        // Ensure column names match your DB (e.g., created_at vs createdDate)
        String sql = "SELECT p.*, c.name as category_name, c.description as category_description "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ? AND p.status = 1"; // Ensure product is active
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Product product = getFromResultSet(rs); // Get product + category info
                     if (product != null) {
                        // Fetch all sizes for this active product
                        List<ProductSize> sizes = productSizeDAO.findByProductId(productId);
                        product.setSizes(sizes); // Attach sizes
                        return product;
                     }
                }
            }
        } catch (SQLException ex) {
             LOGGER.log(Level.SEVERE, "Error finding active product by ID with sizes", ex);
        }
        return null; // Not found, not active, or error
    }
}
