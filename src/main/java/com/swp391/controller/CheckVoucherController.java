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
import java.time.LocalDate;

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
            // Trả về lỗi chưa đăng nhập dạng JSON
            out.print("{\"success\": false, \"message\": \"You must be logged in to apply a voucher.\", \"redirect\": \"authen?action=login\"}");
            out.flush();
            return;
        }

        int userId = account.getUserId();
        List<Cart> cartItems = cartDAO.getCartItemsByUserId(userId); // Lấy cart từ DB

        if (cartItems == null || cartItems.isEmpty()) {
             out.print("{\"success\": false, \"message\": \"Your cart is empty!\"}");
             out.flush();
             return;
        }

        // Tính tổng tiền gốc từ cartItems
        BigDecimal originalTotal = cartItems.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getPrice() != null)
                .map(item -> item.getProduct().getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);


        String voucherCode = request.getParameter("voucherCode");
        BigDecimal discountAmount = BigDecimal.ZERO;
        boolean voucherAppliedSuccessfully = false; // Đổi tên biến
        String message = "";
        Voucher appliedVoucher = null; // Lưu voucher nếu hợp lệ

        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            message = "Please enter a voucher code.";
            session.removeAttribute("SESSION_VOUCHER"); // Xóa voucher cũ nếu có
        } else {
            // 1. Tìm voucher theo code, kiểm tra status=1 và ngày tháng cơ bản
            Voucher voucher = voucherDAO.findByCodeForCheck(voucherCode.trim());

            if (voucher == null) {
                message = "Invalid or expired voucher code.";
                session.removeAttribute("SESSION_VOUCHER");
            } else {
                // 2. Kiểm tra số lượt đã sử dụng so với max_usage
                int currentUsageCount = voucherDAO.countOrdersUsingVoucher(voucher.getVoucherId());

                if (voucher.getMaxUsage() != null && currentUsageCount >= voucher.getMaxUsage()) {
                    message = "This voucher has reached its maximum usage limit.";
                    session.removeAttribute("SESSION_VOUCHER");
                } else {
                    // // 3. (Tùy chọn) Kiểm tra giới hạn dùng 1 lần/user nếu cần
                    // // Yêu cầu giữ lại bảng UserVoucher và phương thức hasUsedVoucher
                    // boolean hasUserUsed = voucherDAO.hasUsedVoucher(userId, voucher.getVoucherId()); // Giả sử giữ lại phương thức này
                    // if (hasUserUsed) {
                    //     message = "You have already used this voucher.";
                    //     session.removeAttribute("SESSION_VOUCHER");
                    // } else {

                        // >>> Voucher HỢP LỆ để áp dụng <<<
                        discountAmount = voucher.getDiscountAmount(); // Lấy số tiền giảm
                        appliedVoucher = voucher; // Lưu lại voucher hợp lệ
                        session.setAttribute("SESSION_VOUCHER", appliedVoucher); // Lưu vào session để dùng khi checkout
                        voucherAppliedSuccessfully = true;
                        message = "Voucher applied successfully!";
                    // } // Đóng dấu ngoặc của kiểm tra hasUserUsed (nếu có)
                }
            }
        }

        // Tính toán lại tổng tiền cuối cùng
        BigDecimal finalTotal = originalTotal.subtract(discountAmount);
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO; // Đảm bảo không âm
        }

        // Xây dựng JSON response
        StringBuilder jsonResponse = new StringBuilder("{");
        jsonResponse.append("\"success\": true,"); // Request xử lý thành công (dù voucher hợp lệ hay không)
        jsonResponse.append("\"originalTotal\": ").append(originalTotal).append(",");
        jsonResponse.append("\"discount\": ").append(discountAmount).append(",");
        jsonResponse.append("\"finalTotal\": ").append(finalTotal).append(",");
        jsonResponse.append("\"voucherApplied\": ").append(voucherAppliedSuccessfully).append(",");
        jsonResponse.append("\"message\": \"").append(escapeJson(message)).append("\""); // Escape message phòng trường hợp có ký tự đặc biệt

        // (Tùy chọn) Gửi thêm thông tin voucher nếu áp dụng thành công
        if (appliedVoucher != null) {
            jsonResponse.append(",\"appliedVoucher\": {");
            jsonResponse.append("\"id\": ").append(appliedVoucher.getVoucherId()).append(",");
            jsonResponse.append("\"code\": \"").append(escapeJson(appliedVoucher.getCode())).append("\"");
            // Thêm các trường khác của voucher nếu cần ở client
            jsonResponse.append("}");
        }

        jsonResponse.append("}");

        out.print(jsonResponse.toString());
        out.flush();
    }

    // Helper method để escape ký tự đặc biệt trong JSON string
    private String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
