/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.entity.Category;
import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext implements I_DAO<Category> {

    @Override
    public List<Category> findAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error fetching categories: " + ex.getMessage());
        }
        return categories;
    }

    @Override
    public Category getFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setStatus(rs.getBoolean("status"));
        category.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        category.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return category;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, status = ?, updated_at = ? WHERE category_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setBoolean(3, category.getStatus());

            // Check if the updatedAt value is not null before using it
            if (category.getUpdatedAt() != null) {
                statement.setTimestamp(4, Timestamp.valueOf(category.getUpdatedAt()));
            } else {
                // If updatedAt is null, you can either set it to the current time or handle it differently
                statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            }

            statement.setInt(5, category.getCategoryId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating category: " + ex.getMessage());
            return false;
        }
    }

    @Override
    public boolean delete(Category category) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, category.getCategoryId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting category: " + ex.getMessage());
            return false;
        }
    }

    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO categories (name, description, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setBoolean(3, category.getStatus());

            // Check if createdAt is null, if so, set the current timestamp
            if (category.getCreatedAt() != null) {
                statement.setTimestamp(4, Timestamp.valueOf(category.getCreatedAt()));
            } else {
                // Set the current timestamp if createdAt is null
                statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            }

            // Check if updatedAt is null, if so, set the current timestamp
            if (category.getUpdatedAt() != null) {
                statement.setTimestamp(5, Timestamp.valueOf(category.getUpdatedAt()));
            } else {
                // Set the current timestamp if updatedAt is null
                statement.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            }

            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating category failed, no ID obtained.");
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting category: " + ex.getMessage());
            return -1;
        }
    }

    // Get all active categories (status = true)
    public List<Category> findAllActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 1";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                categories.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error fetching active categories: " + ex.getMessage());
        }
        return categories;
    }

    // Find category by ID
    public Category findById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return getFromResultSet(resultSet);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error finding category by ID: " + ex.getMessage());
        }
        return null;
    }

    // Get all categories with pagination
    public List<Category> findAll(int page, int pageSize) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories LIMIT ? OFFSET ?";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, pageSize);
            statement.setInt(2, (page - 1) * pageSize);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    categories.add(getFromResultSet(resultSet));
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error fetching categories with pagination: " + ex.getMessage());
        }
        return categories;
    }

    // Get total number of categories (for pagination)
    public int getTotalCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting categories: " + ex.getMessage());
        }
        return 0;
    }

    public List<Category> findCategoriesWithFilters(String search, String status, int page, int pageSize) {
        List<Category> categories = new ArrayList<>();
        String searchPattern = "%" + (search != null ? search : "") + "%";
        int offset = (page - 1) * pageSize;

        // Base SQL query
        StringBuilder sql = new StringBuilder("SELECT * FROM Categories WHERE (name LIKE ? OR description LIKE ?)");

        // Parse the status to boolean and add the filter if true or false is provided
        if (status != null && !status.isEmpty()) {
            boolean statusBool = Boolean.parseBoolean(status);
            sql.append(" AND status = ?");
        }

        sql.append(" ORDER BY name LIMIT ? OFFSET ?");

        try (Connection connection = getConnection(); PreparedStatement stmt = connection.prepareStatement(sql.toString())) {

            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            // Set the status filter if it's provided
            if (status != null && !status.isEmpty()) {
                boolean statusBool = Boolean.parseBoolean(status);
                stmt.setBoolean(3, statusBool);
                stmt.setInt(4, pageSize);
                stmt.setInt(5, offset);
            } else {
                stmt.setInt(3, pageSize);
                stmt.setInt(4, offset);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public int getTotalCategoryCountWithFilters(String search, String status) {
        int count = 0;
        String searchPattern = "%" + (search != null ? search : "") + "%";

        // Base SQL query
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Categories WHERE (name LIKE ? OR description LIKE ?)");

        // Parse the status to boolean and add the filter if true or false is provided
        if (status != null && !status.isEmpty()) {
            boolean statusBool = Boolean.parseBoolean(status);
            sql.append(" AND status = ?");
        }

        try (Connection connection = getConnection(); PreparedStatement stmt = connection.prepareStatement(sql.toString())) {

            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            // Set the status filter if it's provided
            if (status != null && !status.isEmpty()) {
                boolean statusBool = Boolean.parseBoolean(status);
                stmt.setBoolean(3, statusBool);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

}
