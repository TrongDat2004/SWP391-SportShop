/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Category;
import com.swp391.entity.Product;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext implements I_DAO<Product> {

    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            CategoryDAO categoryDao = new CategoryDAO();
            while (resultSet.next()) {
                Category category = categoryDao.findById(resultSet.getInt("category_id"));
                Product product = getFromResultSet(resultSet);
                product.setCategory(category);
                products.add(product);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return products;
    }

    public List<Product> findProductsWithFilters(String searchFilter, String statusFilter, String categoryFilter, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR description LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        // Add pagination
        sql.append("ORDER BY created_at LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            CategoryDAO categoryDao = new CategoryDAO();
            while (resultSet.next()) {
                Category category = categoryDao.findById(resultSet.getInt("category_id"));
                Product product = getFromResultSet(resultSet);
                product.setCategory(category);
                products.add(product);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding filtered products: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return products;
    }

    public int getTotalProductCountWithFilters(String searchFilter, String statusFilter, String categoryFilter) {
        int totalCount = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR description LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append("AND category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                totalCount = resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting total product count: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return totalCount;
    }

    @Override
    public boolean update(Product product) {
        String sql = "UPDATE products SET category_id=?, name=?, description=?, price=?, stock=?, image=?, status=? WHERE product_id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, product.getCategoryId());
            statement.setString(2, product.getName());
            statement.setString(3, product.getDescription());
            statement.setBigDecimal(4, product.getPrice());
            statement.setInt(5, product.getStock());
            statement.setString(6, product.getImage());
            statement.setBoolean(7, product.getStatus());
            statement.setInt(8, product.getProductId());
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public boolean delete(Product product) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, product.getProductId());
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    @Override
    public int insert(Product product) {
        String sql = "INSERT INTO products (category_id, name, description, price, stock, image, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, product.getCategoryId());
            statement.setString(2, product.getName());
            statement.setString(3, product.getDescription());
            statement.setBigDecimal(4, product.getPrice());
            statement.setInt(5, product.getStock());
            statement.setString(6, product.getImage());
            statement.setBoolean(7, product.getStatus());
            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return -1;
    }

    @Override
    public Product getFromResultSet(ResultSet rs) throws SQLException {
        return Product.builder()
                .productId(rs.getInt("product_id"))
                .categoryId(rs.getInt("category_id"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .price(rs.getBigDecimal("price"))
                .stock(rs.getInt("stock"))
                .image(rs.getString("image"))
                .status(rs.getBoolean("status"))
                .createdAt(rs.getTimestamp("created_at").toLocalDateTime())
                .updatedAt(rs.getTimestamp("updated_at").toLocalDateTime())
                .build();
    }

    /**
     * Lấy danh sách sản phẩm đang hoạt động (status = 1) có phân trang
     */
    public List<Product> getActiveProducts(int page, int pageSize, String keyword, Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE status = 1");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }
        sql.append(" ORDER BY created_at DESC LIMIT ?, ?");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                statement.setString(paramIndex++, "%" + keyword + "%");
            }
            if (categoryId != null) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (minPrice != null) {
                statement.setBigDecimal(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                statement.setBigDecimal(paramIndex++, maxPrice);
            }
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex, pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                products.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return products;
    }

    public int countProducts(String keyword, Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice) {
        int totalCount = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE status = 1");

        // Adding conditions to the SQL query based on the parameters
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }

        try {
            // Establishing the connection
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int paramIndex = 1;
            // Set the parameters based on the conditions
            if (keyword != null && !keyword.isEmpty()) {
                statement.setString(paramIndex++, "%" + keyword + "%");
            }
            if (categoryId != null) {
                statement.setInt(paramIndex++, categoryId);
            }
            if (minPrice != null) {
                statement.setBigDecimal(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                statement.setBigDecimal(paramIndex++, maxPrice);
            }

            // Execute the query and get the result
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                totalCount = resultSet.getInt(1); // The count is in the first column of the result
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }

        return totalCount;
    }

    /**
     * Xem chi tiết sản phẩm
     */
    public Product findById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Product findActiveById(int productId) {
        String sql = "SELECT * FROM products WHERE product_id = ? and status = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, productId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}
