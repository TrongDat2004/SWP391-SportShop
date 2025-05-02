/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.CancelReason;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Loan Anh _ CE181571
 */
public class CancelReasonDAO extends DBContext{
    private Connection conn;

    public CancelReasonDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy tất cả lý do theo role (customer, staff, hoặc both)
    public List<CancelReason> getCancelReasonsByRole(String role) {
        List<CancelReason> reasons = new ArrayList<>();
        String sql = "SELECT * FROM cancel_reasons WHERE role = ? OR role = 'both'";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CancelReason reason = new CancelReason();
                    reason.setId(rs.getInt("id"));
                    reason.setReasonText(rs.getString("reason_text"));
                    reason.setRole(rs.getString("role"));
                    reasons.add(reason);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reasons;
    }
}
