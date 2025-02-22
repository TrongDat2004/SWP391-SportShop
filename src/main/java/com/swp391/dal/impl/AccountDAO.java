package com.swp391.dal.impl;


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.sql.*;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.HashMap;
import com.swp391.entity.Account;
import com.swp391.dal.I_DAO;
import com.swp391.config.GlobalConfig;
import com.swp391.dal.DBContext;
import java.time.LocalDateTime;

/**
 *
 * @author ADMIN
 */
public class AccountDAO extends DBContext implements I_DAO<Account> {

    @Override
    public List<Account> findAll() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM account";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    @Override
    public boolean update(Account account) {
        String sql = "UPDATE account SET username = ?, email = ?, password = ?, avatar = ?, first_name = ?, " +
                "last_name = ?, phone = ?, address = ?, role = ?, status = ? WHERE user_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getUsername());
            statement.setString(2, account.getEmail());
            statement.setString(3, account.getPassword());
            statement.setString(4, account.getAvatar());
            statement.setString(5, account.getFirstName());
            statement.setString(6, account.getLastName());
            statement.setString(7, account.getPhone());
            statement.setString(8, account.getAddress());
            statement.setString(9, account.getRole());
            statement.setObject(10, account.getStatus());
            statement.setInt(11, account.getUserId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Account t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
        // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Account account) {
        String sql = "INSERT INTO account (username, email, password, avatar, first_name, last_name, " +
                "phone, address, role, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, account.getUsername());
            statement.setString(2, account.getEmail());
            statement.setString(3, account.getPassword());
            statement.setString(4, account.getAvatar());
            statement.setString(5, account.getFirstName());
            statement.setString(6, account.getLastName());
            statement.setString(7, account.getPhone());
            statement.setString(8, account.getAddress());
            statement.setString(9, account.getRole());
            statement.setObject(10, account.getStatus());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating account failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating account failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting account: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Account getFromResultSet(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setUserId(rs.getInt("user_id"));
        account.setUsername(rs.getString("username"));
        account.setEmail(rs.getString("email"));
        account.setPassword(rs.getString("password"));
        account.setAvatar(rs.getString("avatar"));
        account.setFirstName(rs.getString("first_name"));
        account.setLastName(rs.getString("last_name"));
        account.setPhone(rs.getString("phone"));
        account.setAddress(rs.getString("address"));
        account.setRole(rs.getString("role"));
        account.setStatus(rs.getBoolean("status"));
        account.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        account.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return account;
    }

    public List<Account> findAllNonAdminAccounts(int page, int pageSize) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM account WHERE role_id != ? ORDER BY id LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            statement.setInt(2, pageSize);
            statement.setInt(3, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding non-admin accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    public int getTotalNonAdminAccounts() {
        String sql = "SELECT COUNT(*) FROM account WHERE role_id != ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setObject(1, GlobalConfig.ROLE_ADMIN);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting non-admin accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public Account findByEmailOrUsernameAndPass(Account t) {
        String sql = "SELECT * FROM account WHERE (email = ? OR username = ?) AND password = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getEmail());
            statement.setString(2, t.getUsername());
            statement.setString(3, t.getPassword());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public Account findByEmail(Account t) {
        String sql = "SELECT * FROM account WHERE email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, t.getEmail());
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean activateAccount(int accountId) {
        String sql = "UPDATE account SET Status = 'Active' WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error activating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updatePassword(Account account) {
        String sql = "UPDATE account SET Password = ? WHERE Email = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getPassword());
            statement.setString(2, account.getEmail());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating password: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean updateProfileImage(Account account) {
        String sql = "UPDATE account SET avatar = ? WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, account.getAvatar());
            statement.setInt(2, account.getUserId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating profile image: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Account findById(int accountId) {
        String sql = "SELECT * FROM account WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding account by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean deactivateAccount(int accountId) {
        String sql = "UPDATE account SET status = false WHERE user_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, accountId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deactivating account: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public Map<Integer, String> findFullNames(Set<Integer> accountIds) {
        String sql = "SELECT id, full_name FROM account WHERE id IN (" +
                accountIds.stream().map(String::valueOf).collect(Collectors.joining(",")) + ")";
        Map<Integer, String> authorNames = new HashMap<>();

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                authorNames.put(resultSet.getInt("id"), resultSet.getString("full_name"));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting full names: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return authorNames;
    }

    public List<Account> findAccountsWithFilters(String roleFilter,
            String statusFilter, String searchFilter, int page, int pageSize) {
        List<Account> accounts = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM account WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role = ? ");
            params.add(roleFilter);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (email LIKE ? OR username LIKE ? OR CONCAT(first_name, ' ', last_name) LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Add pagination
        sql.append("ORDER BY created_at LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                accounts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding filtered accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return accounts;
    }

    public int getTotalFilteredAccounts(String roleFilter, 
            String statusFilter, String searchFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM account WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Add filters
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append("AND role = ? ");
            params.add(roleFilter);
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND status = ? ");
            params.add(Boolean.parseBoolean(statusFilter));
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND (email LIKE ? OR username LIKE ? OR CONCAT(first_name, ' ', last_name) LIKE ?) ");
            String searchPattern = "%" + searchFilter.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting filtered accounts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public static void main(String[] args) {
        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.findAll();
        for (Account account : accounts) {
            System.out.println(account);
        }
    }

}
