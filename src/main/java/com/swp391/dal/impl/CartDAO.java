package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Cart;
import com.swp391.entity.Product;
import com.swp391.entity.ProductSize; // Thêm import
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

    private final ProductSizeDAO productSizeDAO = new ProductSizeDAO(); // Cần DAO này để check stock

    /**
     * Lấy tồn kho của một size sản phẩm cụ thể.
     *
     * @param productSizeId ID của size sản phẩm
     * @return Số lượng tồn kho, hoặc 0 nếu không tìm thấy/lỗi.
     */
    private int getProductSizeStock(int productSizeId) {
        return productSizeDAO.getStock(productSizeId);
    }

    /**
     * Lấy tổng số lượng sản phẩm trong giỏ hàng của người dùng.
     *
     * @param userId ID của người dùng
     * @return Tổng số lượng sản phẩm
     */
    public int getCartProductCount(int userId) {
        String sql = "SELECT SUM(quantity) AS total_quantity FROM cart WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_quantity");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart product count: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy một mục trong giỏ hàng dựa vào userId, productId, và productSizeId.
     *
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     * @param productSizeId ID size sản phẩm
     * @return Đối tượng Cart nếu tìm thấy, null nếu không.
     */
    private Cart getCartEntry(int userId, int productId, int productSizeId) {
        String sql = "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, "
                + "ps.size as product_size_name, ps.stock as product_size_stock "
                + // Lấy thêm size name và stock size
                "FROM cart c "
                + "JOIN products p ON c.product_id = p.product_id "
                + "LEFT JOIN product_sizes ps ON c.product_size_id = ps.product_size_id "
                + // LEFT JOIN phòng trường hợp size bị xóa
                "WHERE c.user_id = ? AND c.product_id = ? AND c.product_size_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.setInt(3, productSizeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCart(rs); // Dùng hàm map chung
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart entry: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thêm hoặc cập nhật sản phẩm với size cụ thể vào giỏ hàng của người dùng.
     *
     * @param userId ID người dùng
     * @param productId ID sản phẩm
     * @param productSizeId ID size sản phẩm
     * @param quantity Số lượng cần thêm
     * @return true nếu thành công, false nếu thất bại (ví dụ: hết hàng)
     */
    public boolean addItemToCart(int userId, int productId, int productSizeId, int quantity) {
        if (quantity <= 0) {
            System.err.println("Quantity must be positive to add to cart.");
            return false;
        }
        if (productSizeId <= 0) {
            System.err.println("Invalid productSizeId to add to cart.");
            return false;
        }

        int currentStock = getProductSizeStock(productSizeId); // Lấy stock của size này
        Cart existingEntry = getCartEntry(userId, productId, productSizeId); // Lấy entry hiện có cho size này
        int quantityInCart = (existingEntry != null) ? existingEntry.getQuantity() : 0;
        int requiredStock = quantityInCart + quantity;

        // Kiểm tra tồn kho trước khi thực hiện hành động DB
        if (currentStock < requiredStock) {
            System.err.println("Cannot add/update item. Stock not enough for sizeId " + productSizeId
                    + ". Required: " + requiredStock + ", Available: " + currentStock);
            return false; // Không đủ hàng
        }

        // Sử dụng INSERT ... ON DUPLICATE KEY UPDATE
        // UNIQUE KEY là (user_id, product_id, product_size_id)
        String sql = "INSERT INTO cart (user_id, product_id, product_size_id, quantity, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), updated_at = VALUES(updated_at)";

        LocalDateTime now = LocalDateTime.now();
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.setInt(3, productSizeId); // Thêm product_size_id
            stmt.setInt(4, quantity);      // Số lượng thêm vào (phần VALUES)
            stmt.setTimestamp(5, Timestamp.valueOf(now)); // created_at (chỉ khi insert)
            stmt.setTimestamp(6, Timestamp.valueOf(now)); // updated_at (luôn cập nhật)

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error adding/updating item to cart: " + e.getMessage());
            // Kiểm tra lỗi ràng buộc khóa ngoại nếu có
            if (e.getSQLState().startsWith("23")) { // Lỗi FK constraint
                System.err.println("Potential FK violation: product_id=" + productId + ", product_size_id=" + productSizeId);
            }
        }
        return false;
    }

    /**
     * Lấy thông tin chi tiết một mục trong giỏ hàng bằng ID của mục đó.
     *
     * @param cartEntryId ID của mục trong giỏ hàng (cart_entry_id)
     * @return Đối tượng Cart nếu tìm thấy, null nếu không.
     */
    public Cart getCartEntryById(int cartEntryId) {
        String sql = "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, "
                + "ps.size as product_size_name, ps.stock as product_size_stock "
                + "FROM cart c "
                + "JOIN products p ON c.product_id = p.product_id "
                + "LEFT JOIN product_sizes ps ON c.product_size_id = ps.product_size_id "
                + "WHERE c.cart_entry_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartEntryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCart(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart entry by ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Cập nhật số lượng cho một mục trong giỏ hàng.
     *
     * @param cartEntryId ID của mục cần cập nhật
     * @param newQuantity Số lượng mới
     * @return true nếu cập nhật thành công, false nếu không (hết hàng, không
     * tìm thấy entry).
     */
    public boolean updateItemQuantity(int cartEntryId, int newQuantity) {
        if (newQuantity <= 0) {
            System.err.println("New quantity must be positive. Removing item instead.");
            return removeItemFromCart(cartEntryId);
        }

        // Lấy thông tin mục giỏ hàng (bao gồm productSizeId)
        Cart cartEntry = getCartEntryById(cartEntryId);
        if (cartEntry == null || cartEntry.getProductSizeId() == null) {
            System.err.println("Error updating quantity: Cart entry or product size ID not found for cartEntryId: " + cartEntryId);
            return false;
        }

        // Lấy tồn kho của size cụ thể này
        int currentStock = getProductSizeStock(cartEntry.getProductSizeId());

        // Kiểm tra tồn kho
        if (currentStock < newQuantity) {
            System.err.println("Error updating quantity: Stock not enough for sizeId " + cartEntry.getProductSizeId()
                    + ". Required: " + newQuantity + ", Available: " + currentStock);
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
        }
        return false;
    }

    /**
     * Xóa một mục khỏi giỏ hàng bằng ID của mục đó.
     *
     * @param cartEntryId ID của mục cần xóa
     * @return true nếu xóa thành công, false nếu không.
     */
    public boolean removeItemFromCart(int cartEntryId) {
        String sql = "DELETE FROM cart WHERE cart_entry_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartEntryId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error removing item from cart: " + e.getMessage());
        }
        return false;
    }

    /**
     * Xóa tất cả các mục trong giỏ hàng của một người dùng.
     *
     * @param userId ID của người dùng
     * @return true nếu xóa thành công hoặc không có gì để xóa, false nếu có
     * lỗi.
     */
    public boolean clearCartByUserId(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.err.println("Error clearing cart by user ID: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy tất cả các mục trong giỏ hàng của một người dùng, bao gồm thông tin
     * sản phẩm và size.
     *
     * @param userId ID của người dùng
     * @return Danh sách các đối tượng Cart, hoặc danh sách rỗng nếu không có.
     */
    public List<Cart> getCartItemsByUserId(int userId) {
        List<Cart> items = new ArrayList<>();
        String sql = "SELECT c.*, p.name as product_name, p.price as product_price, p.image as product_image, "
                + "ps.size as product_size_name, ps.stock as product_size_stock "
                + "FROM cart c "
                + "JOIN products p ON c.product_id = p.product_id "
                + "LEFT JOIN product_sizes ps ON c.product_size_id = ps.product_size_id "
                + // LEFT JOIN
                "WHERE c.user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToCart(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting cart items by user ID: " + e.getMessage());
        }
        return items;
    }

    // Hàm helper để map ResultSet sang đối tượng Cart (bao gồm Product và ProductSize)
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Product product = Product.builder()
                .productId(rs.getInt("product_id"))
                .name(rs.getString("product_name"))
                .price(rs.getBigDecimal("product_price"))
                .image(rs.getString("product_image"))
                // Không cần set stock của product ở đây nữa
                .build();

        ProductSize productSize = null;
        int productSizeId = rs.getInt("product_size_id");
        if (!rs.wasNull()) { // Chỉ tạo ProductSize nếu ID không null
            productSize = ProductSize.builder()
                    .productSizeId(productSizeId)
                    .productId(rs.getInt("product_id")) // Lấy từ cart hoặc join cũng được
                    .size(rs.getString("product_size_name")) // Lấy từ join
                    .stock(rs.getInt("product_size_stock")) // Lấy stock của size từ join
                    .build();
        }

        return Cart.builder()
                .cartEntryId(rs.getInt("cart_entry_id"))
                .userId(rs.getInt("user_id"))
                .productId(rs.getInt("product_id"))
                .productSizeId(productSizeId) // Gán productSizeId
                .quantity(rs.getInt("quantity"))
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                .product(product)
                .productSize(productSize) // Gán đối tượng ProductSize (có thể null)
                .build();
    }
}
