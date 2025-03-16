package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Account;
import com.swp391.entity.Feedback;
import com.swp391.entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Feedback entities
 */
public class FeedbackDAO extends DBContext {

    public boolean addFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedbacks (user_id, order_id, content, rating, is_visible, created_at, updated_at, product_id) VALUES (?, ?, ?, ?, ?, NOW(), NOW(), ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, feedback.getUserId());
            statement.setInt(2, feedback.getOrderId());
            statement.setString(3, feedback.getContent());
            statement.setInt(4, feedback.getRating());
            statement.setBoolean(5, feedback.isIsVisible());
            statement.setInt(6, feedback.getProductId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE feedbacks SET content = ?, rating = ?, is_visible = ?, updated_at = NOW() WHERE feedback_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, feedback.getContent());
            statement.setInt(2, feedback.getRating());
            statement.setBoolean(3, feedback.isIsVisible());
            statement.setInt(4, feedback.getFeedbackId());
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedbacks WHERE feedback_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, feedbackId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changeVisibility(int feedbackId, boolean isVisible) {
        String sql = "UPDATE feedbacks SET is_visible = ?, updated_at = NOW() WHERE feedback_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setBoolean(1, isVisible);
            statement.setInt(2, feedbackId);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Feedback> getFeedbackByProduct(int productId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT * FROM feedbacks WHERE product_id = ? AND is_visible = 1 ORDER BY created_at DESC";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, productId);
            ResultSet resultSet = statement.executeQuery();
            AccountDAO accountDao = new AccountDAO();
            while (resultSet.next()) {
                Feedback f = mapToFeedback(resultSet);
                Account a = accountDao.findById(f.getUserId());
                f.setUser(a);
                feedbacks.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }

    public Feedback getFeedbackByOrderAndProduct(int orderId, int productId) {
        String query = "SELECT * FROM Feedbacks WHERE order_id = ? AND product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapToFeedback(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all feedbacks with filtering and pagination
     * 
     * @param productId filter by product ID (optional)
     * @param rating filter by rating (optional)
     * @param visibility filter by visibility status (optional)
     * @param page page number (starting from 1)
     * @param pageSize number of items per page
     * @return List of feedbacks matching the criteria
     */
    public List<Feedback> getAllFeedbacks(Integer productId, Integer rating, Boolean visibility, int page, int pageSize) {
        List<Feedback> feedbacks = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT f.*, a.username FROM feedbacks f JOIN account a ON f.user_id = a.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add filters if provided
        if (productId != null) {
            sqlBuilder.append(" AND f.product_id = ?");
            params.add(productId);
        }
        if (rating != null) {
            sqlBuilder.append(" AND f.rating = ?");
            params.add(rating);
        }
        if (visibility != null) {
            sqlBuilder.append(" AND f.is_visible = ?");
            params.add(visibility);
        }
        
        // Add order by and pagination
        sqlBuilder.append(" ORDER BY f.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (PreparedStatement statement = connection.prepareStatement(sqlBuilder.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet resultSet = statement.executeQuery();
            AccountDAO accountDao = new AccountDAO();
            ProductDAO productDao = new ProductDAO();
            
            while (resultSet.next()) {
                Feedback feedback = mapToFeedback(resultSet);
                Account account = accountDao.findById(feedback.getUserId());
                feedback.setUser(account);
                
                Product product = productDao.findById(feedback.getProductId());
                
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }

    /**
     * Count total feedbacks matching the filters
     * 
     * @param productId filter by product ID (optional)
     * @param rating filter by rating (optional)
     * @param visibility filter by visibility status (optional)
     * @return Total count of feedbacks matching the criteria
     */
    public int countAllFeedbacks(Integer productId, Integer rating, Boolean visibility) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM feedbacks WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (productId != null) {
            sqlBuilder.append(" AND product_id = ?");
            params.add(productId);
        }
        if (rating != null) {
            sqlBuilder.append(" AND rating = ?");
            params.add(rating);
        }
        if (visibility != null) {
            sqlBuilder.append(" AND is_visible = ?");
            params.add(visibility);
        }
        
        try (PreparedStatement statement = connection.prepareStatement(sqlBuilder.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Get feedback by ID
     * 
     * @param feedbackId ID of the feedback
     * @return Feedback object or null if not found
     */
    public Feedback getFeedbackById(int feedbackId) {
        String sql = "SELECT * FROM feedbacks WHERE feedback_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, feedbackId);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return mapToFeedback(resultSet);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Feedback mapToFeedback(ResultSet resultSet) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setFeedbackId(resultSet.getInt("feedback_id"));
        feedback.setUserId(resultSet.getInt("user_id"));
        feedback.setOrderId(resultSet.getInt("order_id"));
        feedback.setContent(resultSet.getString("content"));
        feedback.setRating(resultSet.getInt("rating"));
        feedback.setIsVisible(resultSet.getBoolean("is_visible"));
        feedback.setCreatedAt(resultSet.getTimestamp("created_at"));
        feedback.setUpdatedAt(resultSet.getTimestamp("updated_at"));
        feedback.setProductId(resultSet.getInt("product_id"));
        return feedback;
    }
}