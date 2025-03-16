/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Cart;
import com.swp391.entity.CartItem;
import com.swp391.entity.Product;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

    private int getProductStock(int productId) {
        String sql = "SELECT stock FROM products WHERE product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Cart getCartByUserId(int userId) {
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Cart(rs.getInt("cart_id"), rs.getInt("user_id"),
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("updated_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getCartProductCount(int userId) {
        String sql = "SELECT SUM(quantity) AS total_quantity FROM cart_items "
                + "WHERE cart_id = (SELECT cart_id FROM carts WHERE user_id = ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_quantity");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Cart createCart(int userId) {
        String sql = "INSERT INTO carts (user_id, created_at, updated_at) VALUES (?, ?, ?)";
        LocalDateTime now = LocalDateTime.now();
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, userId);
            stmt.setTimestamp(2, Timestamp.valueOf(now));
            stmt.setTimestamp(3, Timestamp.valueOf(now));
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return new Cart(rs.getInt(1), userId, now, now);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private CartItem getCartItem(int cartId, int productId) {
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            ProductDAO productDao = new ProductDAO();
            if (rs.next()) {
                Product product = productDao.findActiveById(rs.getInt("product_id"));
                return new CartItem(rs.getInt("cart_item_id"), rs.getInt("cart_id"),
                        rs.getInt("product_id"), rs.getInt("quantity"),
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("updated_at").toLocalDateTime(), product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addItemToCart(int cartId, int productId, int quantity) {
        int stock = getProductStock(productId);
        if (stock < quantity) {
            return false; // Không đủ hàng
        }

        CartItem existingItem = getCartItem(cartId, productId);
        if (existingItem != null) {
            int newQuantity = existingItem.getQuantity() + quantity;
            if (stock < newQuantity) {
                return false;
            }
            return updateItemQuantity(existingItem.getCartItemId(), newQuantity);
        } else {
            String sql = "INSERT INTO cart_items (cart_id, product_id, quantity, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";
            LocalDateTime now = LocalDateTime.now();
            try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, cartId);
                stmt.setInt(2, productId);
                stmt.setInt(3, quantity);
                stmt.setTimestamp(4, Timestamp.valueOf(now));
                stmt.setTimestamp(5, Timestamp.valueOf(now));
                stmt.executeUpdate();
                return true;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public CartItem getCartItemById(int cartItemId) {
        CartItem cartItem = null;
        String sql = "SELECT ci.cart_item_id, ci.cart_id, ci.product_id, ci.quantity, "
                + "p.name, p.price, p.stock "
                + "FROM Cart_Items ci "
                + "JOIN Products p ON ci.product_id = p.product_id "
                + "WHERE ci.cart_item_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartItemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setStock(rs.getInt("stock"));

                cartItem = new CartItem();
                cartItem.setCartItemId(rs.getInt("cart_item_id"));
                cartItem.setCartId(rs.getInt("cart_id"));
                cartItem.setProduct(product);
                cartItem.setQuantity(rs.getInt("quantity"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItem;
    }

    public boolean updateItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ?, updated_at = ? WHERE cart_item_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(3, cartItemId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeItemFromCart(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Clear cart: " + e);
        }
        return false;
    }

    public boolean clearCartByUserId(int userId) {
        String sql = "DELETE ci FROM cart_items ci "
                + "JOIN carts c ON ci.cart_id = c.cart_id "
                + "WHERE c.user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Clear cart error: " + e);
        }
        return false;
    }

    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE cart_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            ResultSet rs = stmt.executeQuery();
            ProductDAO productDao = new ProductDAO();
            while (rs.next()) {
                Product product = productDao.findActiveById(rs.getInt("product_id"));
                items.add(new CartItem(rs.getInt("cart_item_id"), rs.getInt("cart_id"),
                        rs.getInt("product_id"), rs.getInt("quantity"),
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("updated_at").toLocalDateTime(), product));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<CartItem> getCartItemsByUserId(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT c.cart_id, c.product_id, c.quantity, "
                + "p.name, p.price, p.stock, p.image "
                + "FROM Cart c "
                + "JOIN Products p ON c.product_id = p.product_id "
                + "WHERE c.user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product product = Product.builder()
                        .productId(rs.getInt("product_id"))
                        .name(rs.getString("name"))
                        .price(rs.getBigDecimal("price"))
                        .stock(rs.getInt("stock"))
                        .image(rs.getString("image"))
                        .build();

                return this.getCartItems(rs.getInt("cart_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
}
