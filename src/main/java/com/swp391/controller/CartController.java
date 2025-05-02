package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
// import com.swp391.dal.impl.ProductDAO; // Không cần ProductDAO trực tiếp ở đây nữa
import com.swp391.entity.Account;
import com.swp391.entity.Cart;
// import com.swp391.entity.Product; // Không cần Product trực tiếp ở đây nữa

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    // private final ProductDAO productDAO = new ProductDAO(); // Bỏ nếu không dùng

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            System.err.println("User not logged in for cart action, redirecting to login.");
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        boolean success = false;
        String type = "error"; // Default type là error
        String redirectUrl = "cart"; // Default redirect về trang cart

        action = action != null ? action.toLowerCase() : "";

        try {
            switch (action) {
                case "add":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    // Lấy thêm productSizeId từ form (quan trọng)
                    int productSizeId = Integer.parseInt(request.getParameter("productSizeId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));

                    if (quantity <= 0) {
                        System.err.println("Invalid quantity for add: " + quantity);
                        type = "invalid_input";
                    } else if (productSizeId <= 0) {
                        System.err.println("Invalid productSizeId for add: " + productSizeId);
                        type = "invalid_input";
                    } else {
                        success = cartDAO.addItemToCart(userId, productId, productSizeId, quantity); // <<< Truyền thêm productSizeId
                        type = success ? "add" : "stock"; // Nếu fail, có thể do stock
                    }
                    // Redirect về trang sản phẩm sau khi thêm thành công (tùy chọn)
                    // redirectUrl = success ? request.getHeader("Referer") : "cart"; // Quay lại trang trước đó nếu thành công
                    redirectUrl = "cart"; // Luôn về cart để xem kết quả
                    break;

                case "update":
                    int cartEntryIdUpdate = Integer.parseInt(request.getParameter("cartItemId"));
                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));

                    if (newQuantity < 1) {
                        System.out.println("Attempting to update quantity to " + newQuantity + ". Deleting item instead for cartEntryId: " + cartEntryIdUpdate);
                        success = cartDAO.removeItemFromCart(cartEntryIdUpdate);
                        type = success ? "delete" : "error";
                    } else {
                        success = cartDAO.updateItemQuantity(cartEntryIdUpdate, newQuantity); // DAO đã check stock size
                        type = success ? "update" : "stock";
                    }
                    redirectUrl = "cart";
                    break;

                case "delete":
                    int cartEntryIdDelete = Integer.parseInt(request.getParameter("cartItemId"));
                    success = cartDAO.removeItemFromCart(cartEntryIdDelete);
                    type = success ? "delete" : "error";
                    redirectUrl = "cart";
                    break;

                case "clear":
                    success = cartDAO.clearCartByUserId(userId);
                    type = success ? "clear" : "error";
                    redirectUrl = "cart";
                    break;

                default:
                    System.err.println("Invalid action in CartController POST: " + action);
                    redirectUrl = "cart"; // Về trang cart nếu action lạ
                    success = false;
                    type = "error";
                // Không cần return ở đây, sẽ đi xuống redirect bên dưới
                }
        } catch (NumberFormatException e) {
            System.err.println("Error parsing number in CartController POST: " + e.getMessage());
            success = false;
            type = "invalid_input";
            redirectUrl = "cart";
        } catch (Exception e) {
            System.err.println("Unexpected error in CartController POST: " + e.getMessage());
            e.printStackTrace(); // In stack trace để debug
            success = false;
            type = "error";
            redirectUrl = "cart";
        }

        // Redirect sau khi xử lý action
        // Thêm dấu ? hoặc & tùy thuộc vào redirectUrl đã có tham số chưa
        String separator = redirectUrl.contains("?") ? "&" : "?";
        System.out.println("Redirecting from CartController POST to: " + redirectUrl + separator + "status=" + success + "&type=" + type);
        response.sendRedirect(redirectUrl + separator + "status=" + success + "&type=" + type);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            System.out.println("User not logged in for cart GET, redirecting to login.");
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        BigDecimal total = BigDecimal.ZERO;
        if (cartItems != null) {
            for (Cart item : cartItems) {
                if (item.getProduct() != null && item.getProduct().getPrice() != null) {
                    total = total.add(item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                }
            }
        }

        request.setAttribute("cartItems", cartItems != null ? cartItems : new ArrayList<Cart>());
        request.setAttribute("total", total);
        request.getRequestDispatcher("./view/product/cart.jsp").forward(request, response);
    }
}
