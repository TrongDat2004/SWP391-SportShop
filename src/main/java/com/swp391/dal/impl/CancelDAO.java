/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Cancel;
import com.swp391.entity.CancelReason;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import lombok.Builder;

/**
 *
 * @author Nguyen Loan Anh _ CE181571
 */
public class CancelDAO extends DBContext {

    public CancelDAO() {
        super();
    }

    // Phương thức lưu thông tin hủy đơn hàng
    public boolean insertCancel(Cancel cancel) {
        String sql = "INSERT INTO cancel (order_id, user_id, cancelled_by, cancel_reason, status, total, "
                + "shipping_address, payment_method, email, fullname, phone, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = this.getConnection(); // Lấy kết nối từ DBContext
                 PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cancel.getOrderId());
            ps.setInt(2, cancel.getUserId());
            ps.setString(3, cancel.getCancelledBy());
            ps.setString(4, cancel.getCancelReason());
            ps.setString(5, cancel.getStatus());
            ps.setBigDecimal(6, cancel.getTotal());
            ps.setString(7, cancel.getShippingAddress());
            ps.setString(8, cancel.getPaymentMethod());
            ps.setString(9, cancel.getEmail());
            ps.setString(10, cancel.getFullname());
            ps.setString(11, cancel.getPhone());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Phương thức lấy danh sách lý do hủy
    public List<CancelReason> getAllCancelReasons() {
        List<CancelReason> cancelReasons = new ArrayList<>();
        String sql = "SELECT * FROM cancel_reasons";

        try (Connection conn = this.getConnection(); // Lấy kết nối từ DBContext
                 PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CancelReason reason = CancelReason.builder()
                        .id(rs.getInt("id"))
                        .reasonText(rs.getString("reason_text"))
                        .role(rs.getString("role"))
                        .build();
                cancelReasons.add(reason);
            }

            // 🔥 In danh sách lý do ra console sau khi truy vấn
            System.out.println("Danh sách lý do hủy:");
            for (CancelReason reason : cancelReasons) {
                System.out.println(reason);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cancelReasons;
    }
}

//    public boolean saveCancel(Cancel cancel) {
//        String sql = "INSERT INTO cancel (order_id, user_id, cancelled_by, cancel_reason, status, total, shipping_address, payment_method, email, fullname, phone) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, cancel.getOrderId());
//            ps.setInt(2, cancel.getUserId());
//            ps.setString(3, cancel.getCancelledBy());
//            ps.setString(4, cancel.getCancelReason());
//            ps.setString(5, cancel.getStatus());
//            ps.setBigDecimal(6, cancel.getTotal());
//            ps.setString(7, cancel.getShippingAddress());
//            ps.setString(8, cancel.getPaymentMethod());
//            ps.setString(9, cancel.getEmail());
//            ps.setString(10, cancel.getFullname());
//            ps.setString(11, cancel.getPhone());
//            int affected = ps.executeUpdate();
//            return affected > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
