/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.ProductSize;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ProductSizeDAO extends DBContext {

    public List<ProductSize> findByProductId(int productId) {
        List<ProductSize> sizes = new ArrayList<>();
        String sql = "SELECT * FROM product_sizes WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                sizes.add(mapResultSetToProductSize(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error finding product sizes by product ID: " + e.getMessage());
        }
        return sizes;
    }
    
    public List<ProductSize> findByProductId(int productId, Connection conn) throws SQLException {
        List<ProductSize> sizes = new ArrayList<>();
        String sql = "SELECT * FROM product_sizes WHERE product_id = ?";
         System.out.println("[ProductSizeDAO] Executing: " + sql + " with productId=" + productId);
        // Không dùng try-with-resources cho Connection
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sizes.add(mapResultSetToProductSize(rs)); // Dùng lại hàm map đã có
                }
            }
        } catch (SQLException e) {
             System.err.println("[ProductSizeDAO] Error finding sizes by productId within transaction: " + e.getMessage());
             throw e; // Ném lỗi để rollback
        }
        System.out.println("[ProductSizeDAO] Found " + sizes.size() + " sizes for productId=" + productId);
        return sizes;
    }

    public ProductSize findById(int productSizeId) {
        String sql = "SELECT * FROM product_sizes WHERE product_size_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productSizeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProductSize(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error finding product size by ID: " + e.getMessage());
        }
        return null;
    }

    public int getStock(int productSizeId) {
        String sql = "SELECT stock FROM product_sizes WHERE product_size_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productSizeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock");
            }
        } catch (SQLException e) {
            System.err.println("Error getting stock for product size ID: " + e.getMessage());
        }
        return 0; // Trả về 0 nếu không tìm thấy hoặc lỗi
    }

    public boolean hasOneSize(int productId, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM product_sizes WHERE product_id = ? AND LOWER(TRIM(size)) = 'one size'";
        System.out.println("[ProductSizeDAO] Checking for 'One Size' for productId=" + productId);
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    boolean exists = rs.getInt(1) > 0;
                     System.out.println("[ProductSizeDAO] Has 'One Size': " + exists);
                    return exists;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ProductSizeDAO] Error checking for 'One Size': " + e.getMessage());
            throw e;
        }
        return false;
    }
    
    public boolean hasSpecificSizes(int productId, Connection conn) throws SQLException {
        // Lấy tất cả trừ chính nó ra và khác 'one size'
         String sql = "SELECT COUNT(*) FROM product_sizes WHERE product_id = ? AND LOWER(TRIM(size)) != 'one size'";
         System.out.println("[ProductSizeDAO] Checking for specific sizes for productId=" + productId);
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                     boolean exists = rs.getInt(1) > 0;
                     System.out.println("[ProductSizeDAO] Has specific sizes: " + exists);
                    return exists;
                }
            }
        } catch (SQLException e) {
            System.err.println("[ProductSizeDAO] Error checking for specific sizes: " + e.getMessage());
            throw e;
        }
        return false;
    }

     /**
      * Kiểm tra xem một tên size (không phân biệt hoa thường) đã tồn tại cho sản phẩm chưa,
      * loại trừ một size ID cụ thể (hữu ích khi update).
      * @param productId ID sản phẩm
      * @param sizeName Tên size cần kiểm tra
      * @param excludeSizeId ID của size cần loại trừ khỏi việc kiểm tra (dùng khi update, để -1 nếu insert)
      * @param conn Connection
      * @return true nếu tên size đã tồn tại, false nếu chưa
      * @throws SQLException
      */
     public boolean sizeNameExists(int productId, String sizeName, int excludeSizeId, Connection conn) throws SQLException {
         String sql = "SELECT COUNT(*) FROM product_sizes WHERE product_id = ? AND LOWER(TRIM(size)) = LOWER(TRIM(?))";
         if (excludeSizeId > 0) {
             sql += " AND product_size_id != ?";
         }
          System.out.println("[ProductSizeDAO] Checking if size name '" + sizeName + "' exists for productId=" + productId + ", excluding ID: " + excludeSizeId);
         try (PreparedStatement stmt = conn.prepareStatement(sql)) {
             stmt.setInt(1, productId);
             stmt.setString(2, sizeName);
              if (excludeSizeId > 0) {
                  stmt.setInt(3, excludeSizeId);
              }
             try (ResultSet rs = stmt.executeQuery()) {
                 if (rs.next()) {
                      boolean exists = rs.getInt(1) > 0;
                       System.out.println("[ProductSizeDAO] Size name exists check result: " + exists);
                     return exists;
                 }
             }
         } catch (SQLException e) {
             System.err.println("[ProductSizeDAO] Error checking size name existence: " + e.getMessage());
             throw e;
         }
         return false;
     }
    
    public boolean updateStock(int productSizeId, int quantityChange, Connection conn) throws SQLException {
        // Dùng UPDATE ... WHERE stock >= ? để đảm bảo không trừ quá số lượng
        String sql = "UPDATE product_sizes SET stock = stock + ?, updated_at = ? WHERE product_size_id = ?";
        if (quantityChange < 0) { // Nếu là giảm kho, thêm điều kiện kiểm tra
            sql = "UPDATE product_sizes SET stock = stock + ?, updated_at = ? WHERE product_size_id = ? AND stock >= ?";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantityChange);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, productSizeId);
            if (quantityChange < 0) {
                stmt.setInt(4, -quantityChange); // Điều kiện stock >= số lượng cần giảm
            }
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0; // Thành công nếu có dòng nào được cập nhật
        }
        // Không bắt lỗi ở đây để transaction bên ngoài xử lý rollback
    }

    // *** Các hàm CRUD cơ bản cho Admin (nếu cần quản lý qua UI) ***
    public int insert(ProductSize size, Connection conn) throws SQLException { /* ... sửa để trả về int ID như trước ... */
         String sql = "INSERT INTO product_sizes (product_id, size, stock, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";
         try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
             stmt.setInt(1, size.getProductId());
             stmt.setString(2, size.getSize());
             stmt.setInt(3, size.getStock());
             stmt.setTimestamp(4, Timestamp.valueOf(size.getCreatedAt() != null ? size.getCreatedAt() : LocalDateTime.now()));
             stmt.setTimestamp(5, Timestamp.valueOf(size.getUpdatedAt() != null ? size.getUpdatedAt() : LocalDateTime.now()));
             int rowsAffected = stmt.executeUpdate();
             if (rowsAffected > 0) {
                 try (ResultSet rs = stmt.getGeneratedKeys()) {
                      if (rs.next()) { return rs.getInt(1); }
                 }
             }
         } catch (SQLException e) { throw e; } // Ném lỗi lên
          return -1;
     }

    public boolean update(ProductSize size, Connection conn) throws SQLException {
        String sql = "UPDATE product_sizes SET size = ?, stock = ?, updated_at = ? WHERE product_size_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, size.getSize());
            stmt.setInt(2, size.getStock());
            stmt.setTimestamp(3, Timestamp.valueOf(size.getUpdatedAt() != null ? size.getUpdatedAt() : LocalDateTime.now()));
            stmt.setInt(4, size.getProductSizeId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int productSizeId, Connection conn) throws SQLException {
        String sql = "DELETE FROM product_sizes WHERE product_size_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productSizeId);
            return stmt.executeUpdate() > 0;
        }
    }

     // --- Hàm xóa theo Product ID (có thể cần hoặc không tùy vào CASCADE của products -> product_sizes) ---
    /**
     * Xóa TẤT CẢ size của một sản phẩm. Hữu ích khi chuyển sang "One Size" hoặc xóa sản phẩm.
     * @param productId ID sản phẩm
     * @param conn Connection
     * @return true nếu thành công (không có lỗi)
     * @throws SQLException
     */
    public boolean deleteAllByProductId(int productId, Connection conn) throws SQLException {
        String sql = "DELETE FROM product_sizes WHERE product_id = ?";
         System.out.println("[ProductSizeDAO] Deleting ALL sizes for productId=" + productId);
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.executeUpdate(); // Không cần check số dòng ảnh hưởng
            return true;
        } catch (SQLException e) {
            System.err.println("[ProductSizeDAO] Error deleting all sizes for productId=" + productId + ": " + e.getMessage());
            throw e;
        }
    }

    /**
     * Xóa tất cả các size CỤ THỂ (khác "One Size") của một sản phẩm.
     * @param productId ID sản phẩm
     * @param conn Connection
     * @return true nếu thành công
     * @throws SQLException
     */
     public boolean deleteSpecificSizesByProductId(int productId, Connection conn) throws SQLException {
         String sql = "DELETE FROM product_sizes WHERE product_id = ? AND LOWER(TRIM(size)) != 'one size'";
          System.out.println("[ProductSizeDAO] Deleting specific sizes for productId=" + productId);
         try (PreparedStatement stmt = conn.prepareStatement(sql)) {
             stmt.setInt(1, productId);
             stmt.executeUpdate();
             return true;
         } catch (SQLException e) {
             System.err.println("[ProductSizeDAO] Error deleting specific sizes for productId=" + productId + ": " + e.getMessage());
             throw e;
         }
     }

     /**
      * Xóa size "One Size" của một sản phẩm (nếu có).
      * @param productId ID sản phẩm
      * @param conn Connection
      * @return true nếu thành công
      * @throws SQLException
      */
      public boolean deleteOneSizeByProductId(int productId, Connection conn) throws SQLException {
          String sql = "DELETE FROM product_sizes WHERE product_id = ? AND LOWER(TRIM(size)) = 'one size'";
           System.out.println("[ProductSizeDAO] Deleting 'One Size' for productId=" + productId);
          try (PreparedStatement stmt = conn.prepareStatement(sql)) {
              stmt.setInt(1, productId);
              stmt.executeUpdate();
              return true;
          } catch (SQLException e) {
              System.err.println("[ProductSizeDAO] Error deleting 'One Size' for productId=" + productId + ": " + e.getMessage());
              throw e;
          }
      }

    
    public boolean deleteByProductId(int productId, Connection conn) throws SQLException {
        String sql = "DELETE FROM product_sizes WHERE product_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            // Không cần quan tâm số dòng bị ảnh hưởng, cứ xóa là được
            stmt.executeUpdate();
            return true;
        }
    }

    private ProductSize mapResultSetToProductSize(ResultSet rs) throws SQLException {
        return ProductSize.builder()
                .productSizeId(rs.getInt("product_size_id"))
                .productId(rs.getInt("product_id"))
                .size(rs.getString("size"))
                .stock(rs.getInt("stock"))
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                .build();
    }
}
