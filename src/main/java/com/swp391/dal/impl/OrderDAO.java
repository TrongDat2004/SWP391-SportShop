/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.*; // Import các entity cần thiết
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO extends DBContext {

    // Không cần conn ở đây nữa, mỗi method sẽ tự lấy connection
    // private Connection conn;
    // Khởi tạo các DAO cần dùng
    private final ProductDAO productDAO = new ProductDAO();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO(); // Giả sử có VoucherDAO

    public OrderDAO() {
        // conn = getConnection(); // Bỏ dòng này
    }

    /**
     * Xử lý đặt hàng, bao gồm lưu Order, OrderItems, cập nhật stock theo size,
     * và sử dụng voucher. Thực hiện trong một transaction.
     *
     * @param order Thông tin đơn hàng
     * @param orderItems Danh sách các sản phẩm trong đơn hàng (phải chứa
     * productSizeId)
     * @param userVoucher Voucher được áp dụng (có thể null)
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean processOrder(Order order, List<OrderItem> orderItems, Voucher userVoucher) {
        String insertOrderSQL = "INSERT INTO Orders (user_id, status, total, shipping_address, payment_method, email, fullname, phone, applied_voucher_id, discount_amount, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        // Thêm product_size_id vào câu lệnh INSERT
        String insertOrderItemSQL = "INSERT INTO Order_Items (order_id, product_id, product_size_id, quantity, price, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String updateStockSQL = "UPDATE product_sizes SET stock = stock - ? WHERE product_size_id = ? AND stock >= ?";

        Connection conn = null; // Khai báo connection ở đây
        boolean success = false;

        try {
            conn = getConnection(); // Lấy connection
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1️⃣ Thêm đơn hàng vào bảng Orders
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getStatus());
                psOrder.setBigDecimal(3, order.getTotal());
                psOrder.setString(4, order.getShippingAddress());
                psOrder.setString(5, order.getPaymentMethod());
                psOrder.setString(6, order.getEmail());
                psOrder.setString(7, order.getFullname());
                psOrder.setString(8, order.getPhone());
                if (userVoucher != null && userVoucher.getVoucherId() != null) {
                    // Nếu có voucher được áp dụng
                    psOrder.setInt(9, userVoucher.getVoucherId()); // Lưu ID voucher
                    // Lấy discount amount từ voucher HOẶC từ đối tượng Order nếu đã tính trước
                    // Giả sử lấy từ Voucher object được truyền vào
                    psOrder.setBigDecimal(10, userVoucher.getDiscountAmount() != null ? userVoucher.getDiscountAmount() : BigDecimal.ZERO);
                } else {
                    // Nếu không có voucher
                    psOrder.setNull(9, Types.INTEGER);     // applied_voucher_id là NULL
                    psOrder.setBigDecimal(10, BigDecimal.ZERO); // discount_amount là 0
                }

                LocalDateTime now = LocalDateTime.now();
                // Các tham số thời gian bị dịch chuyển chỉ số
                psOrder.setTimestamp(11, Timestamp.valueOf(order.getCreatedAt() != null ? order.getCreatedAt() : now));
                psOrder.setTimestamp(12, Timestamp.valueOf(order.getUpdatedAt() != null ? order.getUpdatedAt() : now));

                psOrder.executeUpdate();

                // Lấy ID đơn hàng vừa tạo
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        order.setOrderId(rs.getInt(1));
                    } else {
                        System.err.println("Failed to retrieve generated order ID.");
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2️⃣ Thêm từng sản phẩm vào OrderItems và cập nhật stock trong product_sizes
            try (PreparedStatement psOrderItem = conn.prepareStatement(insertOrderItemSQL); PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {

                LocalDateTime itemNow = LocalDateTime.now(); // Thời gian cho item
                for (OrderItem item : orderItems) {
                    if (item.getProductSizeId() == null || item.getProductSizeId() <= 0) {
                        System.err.println("Error processing order: OrderItem missing valid productSizeId for productId " + item.getProductId());
                        conn.rollback();
                        return false;
                    }

                    psUpdateStock.setInt(1, item.getQuantity());        // Số lượng cần trừ
                    psUpdateStock.setInt(2, item.getProductSizeId());   // ID của size cần cập nhật
                    psUpdateStock.setInt(3, item.getQuantity());        // Đảm bảo stock >= số lượng cần trừ
                    int stockRowsAffected = psUpdateStock.executeUpdate();

                    if (stockRowsAffected == 0) {
                        // Cập nhật stock thất bại (hết hàng hoặc lỗi) -> Rollback
                        System.err.println("Failed to update stock or insufficient stock for productSizeId: " + item.getProductSizeId());
                        conn.rollback();
                        return false;
                    }
                    psUpdateStock.clearParameters();

                    psOrderItem.setInt(1, order.getOrderId());
                    psOrderItem.setInt(2, item.getProductId());
                    psOrderItem.setInt(3, item.getProductSizeId());
                    psOrderItem.setInt(4, item.getQuantity());
                    psOrderItem.setBigDecimal(5, item.getPrice());
                    psOrderItem.setTimestamp(6, Timestamp.valueOf(item.getCreatedAt() != null ? item.getCreatedAt() : itemNow));
                    psOrderItem.setTimestamp(7, Timestamp.valueOf(item.getUpdatedAt() != null ? item.getUpdatedAt() : itemNow));
                    psOrderItem.addBatch();
                }

                int[] itemResults = psOrderItem.executeBatch();
                for (int res : itemResults) {
                    if (res == Statement.EXECUTE_FAILED) {
                        System.err.println("Failed to insert one or more order items.");
                        conn.rollback();
                        return false;
                    }
                }
            }
            // Nếu mọi thứ ổn -> Commit
            conn.commit();
            success = true;

        } catch (SQLException e) {
            System.err.println("SQL Exception during order processing: " + e.getMessage());
            e.printStackTrace(); // In stack trace để debug
            if (conn != null) {
                try {
                    System.err.println("Rolling back transaction.");
                    conn.rollback(); // Nếu có lỗi → Rollback toàn bộ giao dịch
                } catch (SQLException rollbackEx) {
                    System.err.println("Error during transaction rollback: " + rollbackEx.getMessage());
                    rollbackEx.printStackTrace();
                }
            }
            success = false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset lại trạng thái AutoCommit
                    conn.close(); // Đóng connection
                } catch (SQLException e) {
                    System.err.println("Error closing connection or resetting autoCommit: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return success;
    }

    // getOrderHistory và getTotalOrderCount: Giữ nguyên, chỉ lấy thông tin Order cơ bản.
    public List<Order> getOrderHistory(int userId, String search, int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ? ";
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (status LIKE ? OR payment_method LIKE ? OR order_id LIKE ?) "; // Thêm tìm theo order_id
            params.add("%" + search + "%");
            params.add("%" + search + "%");
            params.add("%" + search + "%"); // Cho tìm theo order_id
        }
        sql += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order history: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalOrderCount(int userId, String search) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Orders WHERE user_id = ? ";
        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (status LIKE ? OR payment_method LIKE ? OR order_id LIKE ?) ";
            params.add("%" + search + "%");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting total order count: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        return Order.builder()
                .orderId(rs.getInt("order_id"))
                .userId(rs.getInt("user_id"))
                .total(rs.getBigDecimal("total"))
                .paymentMethod(rs.getString("payment_method"))
                .status(rs.getString("status"))
                .shippingAddress(rs.getString("shipping_address"))
                .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                .email(rs.getString("email"))
                .fullname(rs.getString("fullname"))
                .phone(rs.getString("phone"))
                .appliedVoucherId(rs.getObject("applied_voucher_id") != null ? rs.getInt("applied_voucher_id") : null)
                .discountAmount(rs.getBigDecimal("discount_amount"))
                .build();
    }

    // getOrderById: Giữ nguyên
    public Order getOrderById(int orderId, int userId) {
        Order order = null;
        String query = "SELECT * FROM Orders WHERE order_id = ? and user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order by ID for user: " + e.getMessage());
            e.printStackTrace();
        }
        return order;
    }

    // hasPurchasedProduct: Giữ nguyên (kiểm tra product_id chung là đủ)
    public boolean hasPurchasedProduct(int orderId, int productId) {
        String query = "SELECT COUNT(*) FROM Order_Items WHERE order_id = ? AND product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking if product purchased: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // getOrderByIdAdmin: Giữ nguyên
    public Order getOrderByIdAdmin(int orderId) {
        Order order = null;
        String query = "SELECT * FROM Orders WHERE order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order by ID (admin): " + e.getMessage());
            e.printStackTrace();
        }
        return order;
    }

    /**
     * Lấy danh sách các mục trong đơn hàng, bao gồm thông tin sản phẩm và size.
     *
     * @param orderId ID của đơn hàng
     * @return Danh sách OrderItem
     */
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        // Join thêm product_sizes để lấy tên size
        String query = "SELECT oi.*, p.name as product_name, p.image as product_image, ps.size as product_size_name "
                + "FROM Order_Items oi "
                + "JOIN Products p ON oi.product_id = p.product_id "
                + "LEFT JOIN product_sizes ps ON oi.product_size_id = ps.product_size_id "
                + // LEFT JOIN phòng trường hợp size bị xóa
                "WHERE oi.order_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Lấy thông tin Product cơ bản
                    Product product = Product.builder()
                            .productId(rs.getInt("product_id"))
                            .name(rs.getString("product_name"))
                            .image(rs.getString("product_image"))
                            // Không cần lấy hết thông tin product ở đây nếu không dùng
                            .build();

                    // Lấy thông tin ProductSize cơ bản
                    ProductSize productSize = ProductSize.builder()
                            .productSizeId(rs.getInt("product_size_id"))
                            .productId(rs.getInt("product_id"))
                            .size(rs.getString("product_size_name")) // Lấy tên size đã join
                            // Không cần lấy stock ở đây
                            .build();

                    OrderItem orderItem = OrderItem.builder()
                            .orderItemId(rs.getInt("order_item_id"))
                            .orderId(rs.getInt("order_id"))
                            .productId(rs.getInt("product_id"))
                            .productSizeId(rs.getInt("product_size_id")) // Lấy productSizeId
                            .quantity(rs.getInt("quantity"))
                            .price(rs.getBigDecimal("price"))
                            .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
                            .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
                            .product(product)
                            .productSize(productSize) // Gán thông tin size
                            .build();
                    orderItems.add(orderItem);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order items by order ID: " + e.getMessage());
            e.printStackTrace();
        }
        return orderItems;
    }

    // updateOrderStatus: Giữ nguyên (chỉ cập nhật status của Order)
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ?, updated_at = ? WHERE order_Id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now())); // Cập nhật thời gian
            stmt.setInt(3, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // getAllOrdersAdmin, getTotalOrderCountAdmin: Giữ nguyên, chỉ lấy thông tin Order.
    // getRevenueStatistics, getOrderCountByStatus: Giữ nguyên, chỉ thao tác trên Order.
    /**
     * Cập nhật tồn kho sản phẩm (hoàn kho) khi hủy đơn.
     *
     * @param orderItems Danh sách các mục hàng trong đơn bị hủy
     * @param conn Connection để thực hiện trong transaction
     * @return true nếu thành công
     * @throws SQLException
     */
    private boolean updateProductStockOnCancel(List<OrderItem> orderItems, Connection conn) throws SQLException {
        // Giả sử ProductSizeDAO đã được khởi tạo: private final ProductSizeDAO productSizeDAO = new ProductSizeDAO();
        if (productSizeDAO == null) {
             throw new SQLException("ProductSizeDAO is not initialized in OrderDAO.");
        }
        // ProductSizeDAO đã được khởi tạo ở trên
        for (OrderItem item : orderItems) {
            if (item.getProductSizeId() == null || item.getProductSizeId() <= 0) {
                System.err.println("Error updating stock on cancel: OrderItem missing valid productSizeId for productId " + item.getProductId());
                // Quyết định có nên throw exception hay chỉ log lỗi
                throw new SQLException("Missing productSizeId in order item during cancellation.");
            }
            // Cộng lại số lượng vào kho
            boolean updated = productSizeDAO.updateStock(item.getProductSizeId(), item.getQuantity(), conn);
            if (!updated) {
                System.err.println("Failed to revert stock for productSizeId: " + item.getProductSizeId() + " on order cancellation.");
                throw new SQLException("Failed to revert stock for productSizeId: " + item.getProductSizeId());
            } else {
                 System.out.println("Reverted stock for productSizeId: " + item.getProductSizeId() + ", Quantity: " + item.getQuantity());
            }
        }
        return true;
    }

    /**
     * Hủy đơn hàng và hoàn lại tồn kho.
     *
     * @param orderId ID đơn hàng cần hủy
     * @return true nếu hủy thành công, false nếu không.
     */
    public boolean cancelOrder(int orderId) {
        String updateOrderQuery = "UPDATE Orders SET status = 'cancelled', updated_at = ? WHERE order_id = ? AND status NOT IN ('completed', 'cancelled')";

        Connection conn = null;
        boolean success = false;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Cập nhật trạng thái đơn hàng thành 'cancelled'
            try (PreparedStatement updatePs = conn.prepareStatement(updateOrderQuery)) {
//                updatePs.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
//                updatePs.setInt(2, orderId);
                int rowsAffected = updatePs.executeUpdate();
                 if (rowsAffected == 0) {
                    System.err.println("Order not found, already completed/cancelled, or status prevents cancellation (ID: " + orderId + ")");
                    conn.rollback();
                    return false;
                }
            }

            // 2. Lấy danh sách các item trong đơn hàng vừa hủy
            // Cần lấy thông tin trước khi commit để đảm bảo lấy đúng item của đơn đó
            List<OrderItem> orderItems = getOrderItemsByOrderId(orderId); // Dùng connection hiện tại để lấy nếu cần
            if (orderItems.isEmpty()) {
                // Nếu đơn hàng không có item nào (bất thường), có thể commit luôn hoặc log lỗi
                System.err.println("Warning: Order ID " + orderId + " has no items to revert stock for.");
                // Tạm thời cho phép commit
            } else {
                // 3. Hoàn lại stock cho từng item
                // Gọi hàm mới updateProductStockOnCancel
                if (!updateProductStockOnCancel(orderItems, conn)) {
                    // Nếu hoàn kho thất bại -> Rollback
//                    System.err.println("Failed to update product stock during cancellation for order ID: " + orderId);
//                    conn.rollback();
                    return false;
                }
            }

            // 4. Commit transaction nếu mọi thứ thành công
            conn.commit();
            System.out.println("Order cancelled successfully and stock reverted for ID: " + orderId);
            success = true;

        } catch (SQLException e) {
            System.err.println("SQL Exception during order cancellation: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    System.err.println("Rolling back transaction due to error.");
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Error during transaction rollback: " + rollbackEx.getMessage());
                    rollbackEx.printStackTrace();
                }
            }
            success = false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection or resetting autoCommit: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }
        return success;
    }

    // Các phương thức thống kê giữ nguyên
    public List<Map<String, Object>> getRevenueStatistics(String startDate, String endDate) {
        List<Map<String, Object>> revenueList = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(o.created_at, '%Y-%m') AS month, "
                + "SUM(o.total) AS revenue, COUNT(o.order_id) AS totalOrders "
                + "FROM Orders o WHERE o.status = 'Completed' " // Chỉ tính đơn Completed
                + "AND o.created_at BETWEEN ? AND ? "
                + "GROUP BY month "
                + "ORDER BY month ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("month", rs.getString("month"));
                    data.put("revenue", rs.getBigDecimal("revenue"));
                    data.put("totalOrders", rs.getInt("totalOrders"));
                    revenueList.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting revenue statistics: " + e.getMessage());
            e.printStackTrace();
        }
        return revenueList;
    }

    public List<Map<String, Object>> getOrderCountByStatus(String startDate, String endDate) {
        List<Map<String, Object>> orderStatusList = new ArrayList<>();
        String query = "SELECT status, COUNT(order_id) AS totalOrders "
                + "FROM Orders WHERE created_at BETWEEN ? AND ? "
                + "GROUP BY status ORDER BY totalOrders DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("status", rs.getString("status"));
                    data.put("totalOrders", rs.getInt("totalOrders"));
                    orderStatusList.add(data);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting order count by status: " + e.getMessage());
            e.printStackTrace();
        }
        return orderStatusList;
    }

    public List<Order> getAllOrdersAdmin(String search, String statusFilter, int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Orders WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (order_id LIKE ? OR status LIKE ? OR payment_method LIKE ? OR fullname LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ? ");
            params.add(statusFilter);
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting all orders (admin): " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalOrderCountAdmin(String search, String statusFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (order_id LIKE ? OR status LIKE ? OR payment_method LIKE ? OR fullname LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            String searchPattern = "%" + search + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ? ");
            params.add(statusFilter);
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting total order count (admin): " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}

