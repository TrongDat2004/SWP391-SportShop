package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart; // Sửa import
import com.swp391.entity.Product; // Import thêm Product nếu cần kiểm tra stock
import com.swp391.dal.impl.ProductDAO; // Import ProductDAO nếu cần

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList; // Import nếu cần List rỗng
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO(); // Khởi tạo nếu cần check stock

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            System.out.println("User not logged in, redirecting to login.");
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        // Không cần lấy đối tượng Cart riêng nữa

        boolean success = false;
        String type = ""; // Để gửi thông báo về JSP
        action = action != null ? action.toLowerCase() : ""; // Chuyển action về chữ thường để dễ so sánh

        try {
            switch (action) {
                case "add":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity <= 0) { // Kiểm tra số lượng hợp lệ
                         System.err.println("Invalid quantity for add: " + quantity);
                         success = false;
                         type="error"; // Có thể thêm type cụ thể hơn
                    } else {
                        success = cartDAO.addItemToCart(userId, productId, quantity);
                        type = success ? "add" : "stock"; // Nếu fail, giả định là do stock
                    }
                    break;

                case "update":
                    int cartEntryIdUpdate = Integer.parseInt(request.getParameter("cartItemId")); // Giữ tên param từ JSP
                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));

                     if (newQuantity < 1) { // Kiểm tra số lượng tối thiểu là 1
                         System.err.println("Attempting to update quantity to " + newQuantity + ". Deleting item instead.");
                         success = cartDAO.removeItemFromCart(cartEntryIdUpdate);
                         type = success ? "delete" : "error"; // Nếu xoá thành công thì type là delete
                     } else {
                        // Không cần lấy cartItem ở đây nữa, DAO sẽ kiểm tra stock
                        success = cartDAO.updateItemQuantity(cartEntryIdUpdate, newQuantity);
                        type = success ? "update" : "stock"; // Nếu fail, giả định là do stock
                     }
                    break;

                case "delete":
                    int cartEntryIdDelete = Integer.parseInt(request.getParameter("cartItemId")); // Giữ tên param từ JSP
                    success = cartDAO.removeItemFromCart(cartEntryIdDelete);
                    type = success ? "delete" : "error";
                    break;

                case "clear":
                    success = cartDAO.clearCartByUserId(userId);
                    type = success ? "clear" : "error";
                    break;

                default:
                    // Chuyển hướng đến trang giỏ hàng nếu action không hợp lệ trong POST
                     System.out.println("Invalid action in POST: " + action + ". Redirecting to cart.");
                     response.sendRedirect("cart");
                    return; // Dừng thực thi để tránh gửi redirect bên dưới
            }
        } catch (NumberFormatException e) {
             System.err.println("Error parsing number in CartController POST: " + e.getMessage());
             success = false;
             type = "error"; // Lỗi chung
        } catch (Exception e) {
             System.err.println("Unexpected error in CartController POST: " + e.getMessage());
             // e.printStackTrace(); // Gỡ lỗi nếu cần
             success = false;
             type = "error"; // Lỗi chung
        }


        // Chỉ redirect nếu có action cụ thể được xử lý (không phải default)
        if (!action.isEmpty()) {
             System.out.println("Redirecting after POST action: " + action + " with status: " + success + " and type: " + type);
             response.sendRedirect("cart?status=" + success + "&type=" + type);
        }
         // Nếu không có action hoặc lỗi, nó sẽ không redirect ở đây, mà sẽ rơi vào doGet hoặc đã redirect ở trên
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        int userId = account.getUserId();
        // Lấy danh sách các mục trong giỏ hàng trực tiếp từ userId
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        // Tính tổng tiền (có thể tính ở đây hoặc để JSP tự tính)
         BigDecimal total = BigDecimal.ZERO;
         if (cartItems != null) {
             for (Cart item : cartItems) {
                 if (item.getProduct() != null && item.getProduct().getPrice() != null) {
                     total = total.add(item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                 }
             }
         }

        request.setAttribute("cartItems", cartItems != null ? cartItems : new ArrayList<Cart>()); // Truyền danh sách cart mới
        request.setAttribute("total", total); // Có thể truyền tổng tiền nếu muốn
        request.getRequestDispatcher("./view/product/cart.jsp").forward(request, response);
    }
}