package com.swp391.controller;

import com.swp391.config.GlobalConfig;
import com.swp391.dal.impl.CartDAO;
import com.swp391.dal.impl.VoucherDAO;
import com.swp391.entity.Account;
import com.swp391.entity.Cart; // Sửa import
import com.swp391.entity.Voucher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CheckVoucherController", urlPatterns = {"/check-voucher"})
public class CheckVoucherController extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        Account account = (Account) session.getAttribute(GlobalConfig.SESSION_ACCOUNT);

        if (account == null) {
            out.print("{\"success\": false, \"message\": \"You are not logged in!\", \"redirect\": \"authen?action=login\"}");
            out.flush();
            return;
        }

        int userId = account.getUserId();
        // Lấy cart items trực tiếp từ userId
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId);

        if (cartItems == null || cartItems.isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Your cart is empty!\"}");
            out.flush();
            return;
        }

        // Tính tổng tiền từ cartItems
        BigDecimal totalAmount = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null)
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        String voucherCode = request.getParameter("voucherCode");
        BigDecimal discountAmount = BigDecimal.ZERO; // Sử dụng BigDecimal
        boolean isValidVoucherApplied = false; // Đổi tên biến cho rõ ràng
        String message = "No valid voucher applied."; // Tin nhắn mặc định

        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            Voucher voucher = voucherDAO.findByCode(voucherCode); // Lấy voucher bằng code

            if (voucher != null && voucherDAO.isValidVoucher(voucherCode)) { // Kiểm tra voucher tồn tại và hợp lệ (còn hạn, status=1)
                boolean hasUsed = voucherDAO.hasUsedVoucher(userId, voucher.getVoucherId());
                int countUse = voucherDAO.countUsersByVoucher(voucher.getVoucherId());

                if (countUse >= voucher.getMaxUsage()) {
                    message = "This voucher has reached its maximum usage limit.";
                    session.removeAttribute("SESSION_VOUCHER"); // Xóa khỏi session nếu hết lượt
                } else if (hasUsed) {
                    message = "You have already used this voucher.";
                    session.removeAttribute("SESSION_VOUCHER"); // Xóa khỏi session nếu đã dùng
                } else {
                    // Voucher hợp lệ và chưa sử dụng bởi user này, và còn lượt dùng
                    discountAmount = voucher.getDiscountAmount();
                    session.setAttribute("SESSION_VOUCHER", voucher); // Lưu voucher hợp lệ vào session
                    isValidVoucherApplied = true;
                    message = "Voucher applied successfully!";
                }
            } else {
                // Voucher không tồn tại hoặc không hợp lệ (hết hạn, status=0)
                message = "Invalid or expired voucher code.";
                session.removeAttribute("SESSION_VOUCHER"); // Xóa khỏi session nếu không hợp lệ
            }
        } else {
             message = "Please enter a voucher code.";
             session.removeAttribute("SESSION_VOUCHER"); // Xóa khỏi session nếu không nhập code
        }


        BigDecimal finalTotal = totalAmount.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO; // Đảm bảo không âm
        }


        // Trả về JSON response
        out.print("{"
                + "\"success\": true," // Luôn trả về success=true vì request xử lý được, kết quả check nằm trong các trường khác
                + "\"originalTotal\": " + totalAmount + ","
                + "\"discount\": " + discountAmount + ","
                + "\"finalTotal\": " + finalTotal + ","
                + "\"voucherApplied\": " + isValidVoucherApplied + "," // Cho biết voucher có được áp dụng thực sự không
                + "\"message\": \"" + message + "\"" // Tin nhắn phản hồi
                + "}");

        out.flush();
    }
}