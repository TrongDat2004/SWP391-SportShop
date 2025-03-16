/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Blog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext {

    private Connection conn;

    public BlogDAO() {
        conn = connection;
    }

    // Get all blogs
    public List<Blog> getAllBlogs() {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs ORDER BY created_at DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                blogs.add(mapResultSetToBlog(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }

    // Get blog by ID
    public Blog getBlogById(int id) {
        String sql = "SELECT * FROM blogs WHERE blog_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBlog(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add new blog
    public boolean addBlog(Blog blog) {
        String sql = "INSERT INTO blogs (title, content, author_id, status, created_at, updated_at, image) VALUES (?, ?, ?, ?, NOW(), NOW(), ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getContent());
            stmt.setInt(3, blog.getAuthorId());
            stmt.setString(4, blog.getStatus());
            stmt.setString(5, blog.getImage());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update blog
    public boolean updateBlog(Blog blog) {
        String sql = "UPDATE blogs SET title=?, content=?, status=?, updated_at=NOW(), image=? WHERE blog_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getStatus());
            stmt.setString(4, blog.getImage());
            stmt.setInt(5, blog.getBlogId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete blog
    public boolean deleteBlog(int id) {
        String sql = "DELETE FROM blogs WHERE blog_id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Blog> getPublishedBlogs(String search, int page, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs WHERE status = 'published' ";

        if (search != null && !search.trim().isEmpty()) {
            sql += "AND title LIKE ? ";
        }

        sql += "ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
            }
            stmt.setInt(index++, pageSize);
            stmt.setInt(index, (page - 1) * pageSize);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    blogs.add(mapResultSetToBlog(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return blogs;
    }

    public int countPublishedBlogs(String search) {
        String sql = "SELECT COUNT(*) FROM blogs WHERE status = 'published' ";
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND title LIKE ?";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(1, "%" + search + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Helper method to map ResultSet to Blog object
    private Blog mapResultSetToBlog(ResultSet rs) throws SQLException {
        return new Blog(
                rs.getInt("blog_id"),
                rs.getString("title"),
                rs.getString("content"),
                rs.getInt("author_id"),
                rs.getString("status"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at"),
                rs.getString("image")
        );
    }
}
