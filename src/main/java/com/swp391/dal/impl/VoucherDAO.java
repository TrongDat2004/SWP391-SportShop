package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Voucher;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBContext implements I_DAO<Voucher> {

    @Override
    public List<Voucher> findAll() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM voucher";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                vouchers.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error fetching vouchers: " + e.getMessage());
        }
        return vouchers;
    }

    public List<Voucher> findVouchersWithFilters(String searchFilter, String statusFilter, int page, int pageSize) {
        List<Voucher> vouchers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM voucher WHERE 1 = 1");

        if (searchFilter != null && !searchFilter.isEmpty()) {
            sql.append(" AND (code LIKE ? OR discount_amount LIKE ?)");
        }

        if (statusFilter != null && !statusFilter.equals("all")) {
            sql.append(" AND status = ?");
        }

        int offset = (page - 1) * pageSize;
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchFilter != null && !searchFilter.isEmpty()) {
                stmt.setString(index++, "%" + searchFilter + "%");
                stmt.setString(index++, "%" + searchFilter + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                stmt.setInt(index++, statusFilter.equals("true") ? 1 : 0);
            }
            stmt.setInt(index++, pageSize);
            stmt.setInt(index++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    vouchers.add(getFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching vouchers with filters: " + e.getMessage());
        }

        return vouchers;
    }

    public int getTotalVoucherCountWithFilters(String searchFilter, String statusFilter) {
        int totalCount = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM voucher WHERE 1 = 1");

        if (searchFilter != null && !searchFilter.isEmpty()) {
            sql.append(" AND (code LIKE ? OR discount_amount LIKE ?)");
        }

        if (statusFilter != null && !statusFilter.equals("all")) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchFilter != null && !searchFilter.isEmpty()) {
                stmt.setString(index++, "%" + searchFilter + "%");
                stmt.setString(index++, "%" + searchFilter + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                stmt.setInt(index++, statusFilter.equals("true") ? 1 : 0);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalCount = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching total voucher count: " + e.getMessage());
        }

        return totalCount;
    }

    @Override
    public Voucher getFromResultSet(ResultSet rs) throws SQLException {
        return Voucher.builder()
                .voucherId(rs.getInt("voucher_id"))
                .code(rs.getString("code"))
                .discountAmount(rs.getBigDecimal("discount_amount"))
                .startDate(rs.getDate("start_date").toLocalDate())
                .expirationDate(rs.getDate("expiration_date").toLocalDate())
                .status(rs.getInt("status"))
                .maxUsage(rs.getInt("max_usage"))
                .createdAt(rs.getTimestamp("created_at").toLocalDateTime())
                .build();
    }

    @Override
    public boolean update(Voucher voucher) {
        String sql = "UPDATE voucher SET code = ?, discount_amount = ?, status = ?, start_date = ?, expiration_date = ?, max_usage=?  WHERE voucher_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, voucher.getCode());
            stmt.setBigDecimal(2, voucher.getDiscountAmount());
            stmt.setInt(3, voucher.getStatus());
            stmt.setDate(4, Date.valueOf(voucher.getStartDate()));
            stmt.setDate(5, Date.valueOf(voucher.getExpirationDate()));
            stmt.setInt(6, voucher.getMaxUsage());
            stmt.setInt(6, voucher.getVoucherId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating voucher: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean delete(Voucher voucher) {
        String sql = "DELETE FROM voucher WHERE voucher_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, voucher.getVoucherId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting voucher: " + e.getMessage());
            return false;
        }
    }

    @Override
    public int insert(Voucher voucher) {
        String sql = "INSERT INTO voucher (code, discount_amount, status, start_date, expiration_date, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, voucher.getCode());
            stmt.setBigDecimal(2, voucher.getDiscountAmount());
            stmt.setInt(3, voucher.getStatus());
            stmt.setDate(4, Date.valueOf(voucher.getStartDate()));
            stmt.setDate(5, Date.valueOf(voucher.getExpirationDate()));
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating voucher failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating voucher failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting voucher: " + e.getMessage());
            return -1;
        }
    }

    public Voucher findById(int voucherId) {
        String sql = "SELECT * FROM voucher WHERE voucher_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, voucherId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error finding voucher: " + e.getMessage());
        }
        return null;
    }

    public Voucher findByCode(String code) {
        String sql = "SELECT * FROM voucher WHERE code = ? AND status = 1 AND start_date <= ? AND expiration_date >= ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return getFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking voucher validity: " + e.getMessage());
        }
        return null;
    }

    public boolean isVoucherCodeExist(String code) {
        String query = "SELECT COUNT(*) FROM voucher WHERE code = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isVoucherCodeExist(String code, int voucherId) {
        String query = "SELECT COUNT(*) FROM voucher WHERE code = ? AND id != ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, code);
            stmt.setInt(2, voucherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isValidVoucher(String code) {
        String sql = "SELECT COUNT(*) FROM voucher WHERE code = ? AND status = 1 AND start_date <= CURDATE() AND expiration_date >= CURDATE()";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);

            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasUsedVoucher(int userId, int voucherId) {
        String sql = "SELECT COUNT(*) FROM UserVoucher WHERE user_id = ? AND voucher_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, voucherId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
