package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.OrderDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart; // Sửa import
import com.swp391.entity.Order;
import com.swp391.entity.OrderItem;
import com.swp391.entity.Voucher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList; // Import thêm
import java.util.List;
import java.util.stream.Collectors;


@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
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
        // Lấy trực tiếp từ userId
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        if (cartItems == null || cartItems.isEmpty()) { // Kiểm tra cả null và empty
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        // Tính tổng tiền
        BigDecimal total = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null) // Đảm bảo product và price không null
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("account", account);
        request.setAttribute("total", total); // Truyền tổng tiền ban đầu
        request.getRequestDispatcher("./view/product/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) { // Kiểm tra lại phòng trường hợp session hết hạn giữa chừng
             System.out.println("User not logged in during checkout POST, redirecting to login.");
             response.sendRedirect("authen?action=login");
             return;
        }

        int userId = account.getUserId();
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        // Lấy lại cart items để đảm bảo tính nhất quán
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        if (cartItems == null || cartItems.isEmpty()) { // Kiểm tra lại giỏ hàng
            System.out.println("Cart is empty during checkout POST for user " + userId + ". Redirecting.");
            response.sendRedirect("cart?status=false&type=empty_checkout");
            return;
        }

        Voucher voucher = (Voucher) session.getAttribute("SESSION_VOUCHER");

        // Tính lại tổng tiền (quan trọng, vì giá có thể thay đổi hoặc voucher áp dụng)
        BigDecimal subtotal = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null)
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal discountAmount = BigDecimal.ZERO;
        BigDecimal finalTotal = subtotal; // Tổng cuối cùng ban đầu bằng subtotal

        if (voucher != null) {
             // Nên kiểm tra lại voucher có hợp lệ không ở đây nếu cần
             // Ví dụ: voucherDAO.isValidVoucher(voucher.getCode()) && !voucherDAO.hasUsedVoucher(...)
             discountAmount = voucher.getDiscountAmount();
             finalTotal = subtotal.subtract(discountAmount);
             if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                finalTotal = BigDecimal.ZERO; // Đảm bảo tổng không âm
             }
         } else {
             // Đảm bảo session voucher bị xoá nếu không hợp lệ hoặc không có
              session.removeAttribute("SESSION_VOUCHER");
         }

        // Tạo đơn hàng với tổng tiền cuối cùng
        Order order = Order.builder()
                .userId(userId)
                .status("pending") // Trạng thái ban đầu
                .total(finalTotal) // Sử dụng tổng tiền cuối cùng
                .shippingAddress(shippingAddress)
                .paymentMethod(paymentMethod)
                .email(email)
                .fullname(fullname)
                .phone(phone)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        // Tạo danh sách sản phẩm trong đơn hàng từ cartItems
        List<OrderItem> orderItems = cartItems.stream()
                .filter(item -> item.getProduct() != null) // Đảm bảo product không null
                .map(item -> OrderItem.builder()
                    .orderId(null) // Sẽ được set trong DAO khi có order ID
                    .productId(item.getProduct().getProductId())
                    .quantity(item.getQuantity())
                    .price(item.getProduct().getPrice()) // Lấy giá tại thời điểm đặt hàng
                    .createdAt(LocalDateTime.now())
                    .updatedAt(LocalDateTime.now())
                    .build()
                ).collect(Collectors.toList());

        // Gọi DAO để xử lý đơn hàng (lưu order, orderItems, cập nhật stock, dùng voucher)
        boolean success = orderDAO.processOrder(order, orderItems, voucher);

        if (!success) {
            System.err.println("Order processing failed for user " + userId);
            // Gửi thông báo lỗi cụ thể hơn nếu có thể
            response.sendRedirect("cart?status=false&type=order_fail");
            return;
        }

        // Xóa giỏ hàng sau khi đặt hàng thành công
        cartDAO.clearCartByUserId(userId);
         session.removeAttribute("SESSION_VOUCHER"); // Xoá voucher khỏi session sau khi dùng

        System.out.println("Order placed successfully. Order ID: " + order.getOrderId() + ", Payment Method: " + paymentMethod);

        // Xử lý chuyển hướng thanh toán
        if ("banking".equalsIgnoreCase(paymentMethod)) { // Dùng equalsIgnoreCase cho an toàn
            session.setAttribute("orderId", order.getOrderId()); // Lưu orderId để xử lý callback VNPAY
            // Redirect tới cổng thanh toán VNPAY
            response.sendRedirect("vnpay?action=pay&amount=" + finalTotal);
        } else {
            // Nếu là COD hoặc phương thức khác, chuyển đến trang trạng thái đơn hàng
            response.sendRedirect("orderStatus?status=true&orderId=" + order.getOrderId());
        }
    }
}