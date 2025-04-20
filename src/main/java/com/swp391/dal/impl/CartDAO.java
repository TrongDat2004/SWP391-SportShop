package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Cart; // Đổi từ CartItem thành Cart
import com.swp391.entity.Product;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

    // Phương thức này vẫn hữu ích để kiểm tra trước khi thêm/cập nhật
    private int getProductStock(int productId) {
        String sql = "SELECT stock FROM products WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock");
            }
        } catch (SQLException e) {
            System.err.println("Error getting product stock: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return 0;
    }

    // Bỏ: public Cart getCartByUserId(int userId) - Không còn bảng carts riêng
    // Bỏ: public Cart createCart(int userId) - Không còn bảng carts riêng

    /**
     * Lấy tổng số lượng sản phẩm trong giỏ hàng của người dùng.
     * @param userId ID của người dùng
     * @return Tổng số lượng sản phẩm
     */
    public int getCartProductCount(int userId) {
        // Truy vấn trực tiếp bảng cart mới
        String sql = "SELECT SUM(quantity) AS total_quantity FROM cart WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Trả về tổng số lượng, nếu không có trả về 0
                return rs.getInt("total_quantity");
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart product count: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return 0;
    }


    /**
     * Lấy một mục trong giỏ hàng dựa vào userId và productId.
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     * @return Đối tượng Cart nếu tìm thấy, null nếu không.
     */
     private Cart getCartEntry(int userId, int productId) {
        String sql = "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, p.stock as product_stock " +
                     "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                     "WHERE c.user_id = ? AND c.product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Product product = Product.builder()
                        .productId(rs.getInt("product_id"))
                        .name(rs.getString("product_name"))
                        .price(rs.getBigDecimal("product_price"))
                        .image(rs.getString("product_image"))
                        .stock(rs.getInt("product_stock"))
                        .build();

                return Cart.builder()
                        .cartEntryId(rs.getInt("cart_entry_id"))
                        .userId(rs.getInt("user_id"))
                        .productId(rs.getInt("product_id"))
                        .quantity(rs.getInt("quantity"))
                        .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                        .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                        .product(product)
                        .build();
            }
        } catch (SQLException e) {
             System.err.println("Error getting cart entry: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return null;
    }

    /**
     * Thêm hoặc cập nhật sản phẩm vào giỏ hàng của người dùng.
     * Sử dụng INSERT ... ON DUPLICATE KEY UPDATE để hiệu quả.
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     * @param quantity Số lượng cần thêm
     * @return true nếu thành công, false nếu thất bại (ví dụ: hết hàng)
     */
    public boolean addItemToCart(int userId, int productId, int quantity) {
        int currentStock = getProductStock(productId);
        Cart existingEntry = getCartEntry(userId, productId);
        int quantityToAdd = quantity;
        int finalQuantity = quantityToAdd;

        if (existingEntry != null) {
            finalQuantity = existingEntry.getQuantity() + quantityToAdd;
        }

        // Kiểm tra tồn kho trước khi thực hiện hành động DB
        if (currentStock < finalQuantity) {
             System.err.println("Cannot add/update item. Stock not enough. Required: " + finalQuantity + ", Available: " + currentStock);
             return false; // Không đủ hàng
        }

        // Sử dụng INSERT ... ON DUPLICATE KEY UPDATE
        String sql = "INSERT INTO cart (user_id, product_id, quantity, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), updated_at = VALUES(updated_at)";

        LocalDateTime now = LocalDateTime.now();
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantityToAdd); // Luôn insert/update với số lượng được yêu cầu thêm
            stmt.setTimestamp(4, Timestamp.valueOf(now)); // created_at (chỉ áp dụng khi insert mới)
            stmt.setTimestamp(5, Timestamp.valueOf(now)); // updated_at (luôn cập nhật)

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
             System.err.println("Error adding/updating item to cart: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return false;
    }


    /**
     * Lấy thông tin chi tiết một mục trong giỏ hàng bằng ID của mục đó.
     * @param cartEntryId ID của mục trong giỏ hàng (cart_entry_id)
     * @return Đối tượng Cart nếu tìm thấy, null nếu không.
     */
    public Cart getCartEntryById(int cartEntryId) {
        String sql = "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, p.stock as product_stock " +
                     "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                     "WHERE c.cart_entry_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartEntryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                 Product product = Product.builder()
                        .productId(rs.getInt("product_id"))
                        .name(rs.getString("product_name"))
                        .price(rs.getBigDecimal("product_price"))
                        .image(rs.getString("product_image"))
                        .stock(rs.getInt("product_stock"))
                        .build();

                return Cart.builder()
                        .cartEntryId(rs.getInt("cart_entry_id"))
                        .userId(rs.getInt("user_id"))
                        .productId(rs.getInt("product_id"))
                        .quantity(rs.getInt("quantity"))
                        .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                        .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                        .product(product)
                        .build();
            }
        } catch (SQLException e) {
             System.err.println("Error getting cart entry by ID: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return null;
    }

    /**
     * Cập nhật số lượng cho một mục trong giỏ hàng.
     * @param cartEntryId ID của mục cần cập nhật
     * @param newQuantity Số lượng mới
     * @return true nếu cập nhật thành công, false nếu không.
     */
    public boolean updateItemQuantity(int cartEntryId, int newQuantity) {
         // Kiểm tra số lượng mới phải > 0
         if (newQuantity <= 0) {
             System.err.println("Error updating quantity: New quantity must be positive.");
             return removeItemFromCart(cartEntryId); // Nếu số lượng <= 0 thì xóa luôn
         }

        // Lấy thông tin sản phẩm để kiểm tra stock
        Cart cartEntry = getCartEntryById(cartEntryId);
        if (cartEntry == null || cartEntry.getProduct() == null) {
             System.err.println("Error updating quantity: Cart entry or product not found.");
            return false;
        }
        int currentStock = cartEntry.getProduct().getStock();

        // Kiểm tra tồn kho
        if (currentStock < newQuantity) {
             System.err.println("Error updating quantity: Stock not enough. Required: " + newQuantity + ", Available: " + currentStock);
             return false; // Không đủ hàng
        }

        // Tiến hành cập nhật
        String sql = "UPDATE cart SET quantity = ?, updated_at = ? WHERE cart_entry_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newQuantity);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, cartEntryId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
             System.err.println("Error updating item quantity: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return false;
    }

    /**
     * Xóa một mục khỏi giỏ hàng bằng ID của mục đó.
     * @param cartEntryId ID của mục cần xóa
     * @return true nếu xóa thành công, false nếu không.
     */
    public boolean removeItemFromCart(int cartEntryId) { // Đổi tên tham số nhưng giữ tên phương thức cho Controller dễ dùng
        String sql = "DELETE FROM cart WHERE cart_entry_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartEntryId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
             System.err.println("Error removing item from cart: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return false;
    }

    // Bỏ: public boolean clearCart(int cartId) - Không cần nữa

    /**
     * Xóa tất cả các mục trong giỏ hàng của một người dùng.
     * @param userId ID của người dùng
     * @return true nếu xóa thành công hoặc không có gì để xóa, false nếu có lỗi.
     */
    public boolean clearCartByUserId(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?"; // Đơn giản hóa câu lệnh
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate(); // executeUpdate trả về số dòng bị ảnh hưởng, có thể > 0 hoặc = 0
            return true; // Coi như thành công nếu không có lỗi SQL
        } catch (SQLException e) {
            System.err.println("Clear cart by user ID error: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return false;
    }


    /**
     * Lấy tất cả các mục trong giỏ hàng của một người dùng, bao gồm thông tin sản phẩm.
     * @param userId ID của người dùng
     * @return Danh sách các đối tượng Cart, hoặc danh sách rỗng nếu không có.
     */
     public List<Cart> getCartItemsByUserId(int userId) { // Đổi tên phương thức này cho rõ ràng hơn
        List<Cart> items = new ArrayList<>();
         // Lấy thông tin từ bảng cart và join với products
         String sql = "SELECT c.cart_entry_id, c.user_id, c.product_id, c.quantity, c.created_at, c.updated_at, " +
                      "p.name as product_name, p.price as product_price, p.image as product_image, p.stock as product_stock " +
                      "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                      "WHERE c.user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                 Product product = Product.builder()
                        .productId(rs.getInt("product_id"))
                        .name(rs.getString("product_name"))
                        .price(rs.getBigDecimal("product_price"))
                        .image(rs.getString("product_image"))
                        .stock(rs.getInt("product_stock"))
                        .build();

                Cart cartEntry = Cart.builder()
                        .cartEntryId(rs.getInt("cart_entry_id"))
                        .userId(rs.getInt("user_id"))
                        .productId(rs.getInt("product_id"))
                        .quantity(rs.getInt("quantity"))
                        .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                        .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                        .product(product)
                        .build();
                items.add(cartEntry);
            }
        } catch (SQLException e) {
             System.err.println("Error getting cart items by user ID: " + e.getMessage());
            // e.printStackTrace(); // Gỡ lỗi nếu cần
        }
        return items;
    }

    // Bỏ: public List<CartItem> getCartItems(int cartId) - Dùng getCartItemsByUserId thay thế
    // Bỏ: public List<CartItem> getCartItemsByUserId(int userId) - Phương thức cũ bị thừa hoặc sai logic, đã thay bằng phương thức mới cùng tên ở trên.
}