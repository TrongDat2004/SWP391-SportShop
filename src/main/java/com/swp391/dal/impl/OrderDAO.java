/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Product;
import com.swp391.entity.Voucher;
import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO extends DBContext {

    private Connection conn;

    public OrderDAO() {
        conn = getConnection();
    }

    public boolean processOrder(Order order, List<OrderItem> orderItems, Voucher userVoucher) {
        String insertOrderSQL = "INSERT INTO Orders (user_id, status, total, shipping_address, payment_method, email, fullname, phone, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertOrderItemSQL = "INSERT INTO Order_Items (order_id, product_id, quantity, price, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        String updateStockSQL = "UPDATE Products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

        String sqlSaveCodeVoucher = "INSERT INTO uservoucher (user_id, voucher_id, used_at) VALUES (?, ?, ?)";

        try {
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
                psOrder.setTimestamp(9, Timestamp.valueOf(order.getCreatedAt()));
                psOrder.setTimestamp(10, Timestamp.valueOf(order.getUpdatedAt()));
                psOrder.executeUpdate();

                // Lấy ID đơn hàng vừa tạo
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    order.setOrderId(rs.getInt(1));
                } else {
                    conn.rollback(); // Nếu không lấy được orderId → Rollback toàn bộ
                    return false;
                }
            }

            // 2️⃣ Thêm từng sản phẩm vào OrderItems và cập nhật stock
            try (PreparedStatement psOrderItem = conn.prepareStatement(insertOrderItemSQL); PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {

                for (OrderItem item : orderItems) {
                    // Thêm vào OrderItems
                    psOrderItem.setInt(1, order.getOrderId());
                    psOrderItem.setInt(2, item.getProductId());
                    psOrderItem.setInt(3, item.getQuantity());
                    psOrderItem.setBigDecimal(4, item.getPrice());
                    psOrderItem.setTimestamp(5, Timestamp.valueOf(item.getCreatedAt()));
                    psOrderItem.setTimestamp(6, Timestamp.valueOf(item.getUpdatedAt()));
                    psOrderItem.addBatch();

                    // Giảm stock của sản phẩm
                    psUpdateStock.setInt(1, item.getQuantity());
                    psUpdateStock.setInt(2, item.getProductId());
                    psUpdateStock.setInt(3, item.getQuantity());
                    psUpdateStock.addBatch();
                }

                int[] itemResults = psOrderItem.executeBatch();
                int[] stockResults = psUpdateStock.executeBatch();

                // Kiểm tra nếu có sản phẩm nào không giảm stock được → Rollback
                for (int res : stockResults) {
                    if (res == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // Kiểm tra nếu có lỗi khi thêm OrderItem → Rollback
                for (int res : itemResults) {
                    if (res == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            }
            if (userVoucher != null) {
                try (PreparedStatement stmt = conn.prepareStatement(sqlSaveCodeVoucher)) {
                    stmt.setInt(1, order.getUserId());
                    stmt.setInt(2, userVoucher.getVoucherId());
                    stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                    stmt.executeUpdate();
                }
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                conn.rollback(); // Nếu có lỗi → Rollback toàn bộ giao dịch
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true); // Reset lại trạng thái AutoCommit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<Order> getOrderHistory(int userId, String search, int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ? ";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (status LIKE ? OR payment_method LIKE ?) ";
        }
        sql += " ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            int index = 2;
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
            }
            stmt.setInt(index++, limit);
            stmt.setInt(index, offset);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getTotalOrderCount(int userId, String search) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Orders WHERE user_id = ? ";

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (status LIKE ? OR payment_method LIKE ?) ";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(2, "%" + search + "%");
                stmt.setString(3, "%" + search + "%");
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
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
                .build();
    }

    public Order getOrderById(int orderId, int userId) {
        Order order = null;
        String query = "SELECT * FROM Orders WHERE order_id = ? and user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return order;
    }

    public boolean hasPurchasedProduct(int orderId, int productId) {
        String query = "SELECT COUNT(*) FROM Order_Items WHERE order_id = ? AND product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Order getOrderByIdAdmin(int orderId) {
        Order order = null;
        String query = "SELECT * FROM Orders WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return order;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String query = "SELECT oi.*, p.name, p.description FROM Order_Items oi "
                + "JOIN Products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            ProductDAO productDAO = new ProductDAO();
            while (rs.next()) {
                Product product = productDAO.findActiveById(rs.getInt("product_id"));
                OrderItem orderItem = OrderItem.builder()
                        .orderItemId(rs.getInt("order_item_id"))
                        .orderId(rs.getInt("order_id"))
                        .productId(rs.getInt("product_id"))
                        .quantity(rs.getInt("quantity"))
                        .price(rs.getBigDecimal("price"))
                        .createdAt(rs.getTimestamp("created_at").toLocalDateTime())
                        .updatedAt(rs.getTimestamp("updated_at").toLocalDateTime())
                        .product(product)
                        .build();
                orderItems.add(orderItem);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderItems;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_Id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getAllOrdersAdmin(String search, String statusFilter, int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Orders WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (status LIKE ? OR payment_method LIKE ? OR fullname LIKE ? OR email LIKE ?) ");
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ? ");
        }

        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                stmt.setString(index++, statusFilter);
            }

            stmt.setInt(index++, limit);
            stmt.setInt(index, offset);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Map<String, Object>> getRevenueStatistics(String startDate, String endDate) {
        List<Map<String, Object>> revenueList = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(o.created_at, '%Y-%m') AS month, "
                + "SUM(o.total) AS revenue, COUNT(o.order_id) AS totalOrders "
                + "FROM Orders o WHERE o.status = 'Completed' "
                + "AND o.created_at BETWEEN ? AND ? "
                + "GROUP BY month "
                + "ORDER BY month ASC";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("month", rs.getString("month"));
                data.put("revenue", rs.getBigDecimal("revenue"));
                data.put("totalOrders", rs.getInt("totalOrders"));
                revenueList.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueList;
    }

    public List<Map<String, Object>> getOrderCountByStatus(String startDate, String endDate) {
        List<Map<String, Object>> orderStatusList = new ArrayList<>();
        String query = "SELECT status, COUNT(order_id) AS totalOrders "
                + "FROM Orders WHERE created_at BETWEEN ? AND ? "
                + "GROUP BY status ORDER BY totalOrders DESC";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("status", rs.getString("status"));
                data.put("totalOrders", rs.getInt("totalOrders"));
                orderStatusList.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderStatusList;
    }

    public int getTotalOrderCountAdmin(String search, String statusFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (status LIKE ? OR payment_method LIKE ? OR fullname LIKE ? OR email LIKE ?) ");
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ? ");
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int index = 1;

            if (search != null && !search.trim().isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
            }

            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                stmt.setString(index++, statusFilter);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

}
