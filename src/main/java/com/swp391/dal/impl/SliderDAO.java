/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.entity.Slider;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author $ LienXuanThinh - CE182117
 */
public class SliderDAO {

    private final DBContext db;

    public SliderDAO() {
        db = new DBContext();
    }

        public List<Slider> getActiveSliders() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT * FROM slider WHERE status = 1 ORDER BY created_at DESC";
        System.out.println("--- DEBUG DAO: Đang thực thi SQL: " + sql + " ---"); // Log SQL

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0; // Đếm số lượng bản ghi tìm thấy

        try {
            conn = db.getConnection();
            System.out.println("--- DEBUG DAO: Kết nối CSDL thành công: " + (conn != null) + " ---"); // Kiểm tra kết nối
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            System.out.println("--- DEBUG DAO: Đã thực thi query. ---");

            while (rs.next()) {
                count++; // Tăng bộ đếm
                list.add(mapResultSetToSlider(rs));
            }
            System.out.println("--- DEBUG DAO: Tìm thấy " + count + " slider active trong DB. ---"); // In ra số lượng tìm thấy

        } catch (Exception e) {
            System.err.println("--- ERROR DAO: Lỗi trong getActiveSliders: " + e.getMessage() + " ---");
            e.printStackTrace(); // In chi tiết lỗi
        } finally {
            // Đóng resource (quan trọng)
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("--- DEBUG DAO: Đã đóng resources CSDL. ---");
        }

        System.out.println("--- DEBUG DAO: Trả về danh sách kích thước: " + list.size() + " ---"); // Log kích thước trả về
        return list;
    }

    public List<Slider> getAllSliders() {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT * FROM slider ORDER BY created_at DESC";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToSlider(rs));
            }
        } catch (Exception e) {
            System.err.println("Error in getActiveSliders: " + e.getMessage());
        }

        return list;
    }

    public void addSlider(Slider s) {
        String sql = "INSERT INTO slider (name, image_url, product_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Adding slider: " + s);
            ps.setString(1, s.getName());
            ps.setString(2, s.getImageUrl());
            ps.setInt(3, s.getProductId());
            ps.setBoolean(4, s.isStatus());

            int rows = ps.executeUpdate();
            System.out.println("Rows affected: " + rows);
        } catch (Exception e) {
            System.err.println("Error in addSlider:");
            e.printStackTrace();
        }
    }

    public void updateSlider(Slider s) {
        String sql = "UPDATE slider SET name=?, image_url=?, product_id=?, status=? WHERE banner_id=?";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setString(2, s.getImageUrl());
            ps.setInt(3, s.getProductId());
            ps.setBoolean(4, s.isStatus());
            ps.setInt(5, s.getBannerId());

            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error in updateSlider: " + e.getMessage());
        }
    }

    public void deleteSlider(int id) {
        String sql = "DELETE FROM slider WHERE banner_id=?";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error in deleteSlider: " + e.getMessage());
        }
    }

    public Slider getSliderById(int id) {
        String sql = "SELECT * FROM slider WHERE banner_id=?";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSlider(rs);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getSliderById: " + e.getMessage());
        }

        return null;
    }

    private Slider mapResultSetToSlider(ResultSet rs) throws SQLException {
        Slider slider = new Slider();
        slider.setBannerId(rs.getInt("banner_id"));
        slider.setName(rs.getString("name"));
        slider.setImageUrl(rs.getString("image_url"));
        slider.setProductId(rs.getInt("product_id"));
        slider.setStatus(rs.getBoolean("status"));
        slider.setCreatedAt(rs.getTimestamp("created_at"));
        slider.setUpdatedAt(rs.getTimestamp("updated_at"));
        return slider;
    }
}
