package com.streamflix.dao;

import com.streamflix.model.Subscription;
import com.streamflix.model.User;
import com.streamflix.utils.DatabaseUtil;

import java.sql.*;
import java.util.*;
import java.util.Date;

/**
 * Implementation of SubscriptionDAO interface
 */
public class SubscriptionDAOImpl implements SubscriptionDAO {

    @Override
    public Subscription findById(int id) {
        String sql = "SELECT * FROM subscriptions WHERE subscription_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSubscription(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public List<Subscription> findAll() {
        List<Subscription> subscriptions = new ArrayList<>();
        String sql = "SELECT * FROM subscriptions";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                subscriptions.add(mapResultSetToSubscription(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subscriptions;
    }

    @Override
    public List<Subscription> findByUserId(int userId) {
        List<Subscription> subscriptions = new ArrayList<>();
        String sql = "SELECT * FROM subscriptions WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    subscriptions.add(mapResultSetToSubscription(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subscriptions;
    }

    @Override
    public Subscription findActiveByUserId(int userId) {
        String sql = "SELECT * FROM subscriptions WHERE user_id = ? AND status = 'ACTIVE' AND end_date >= CURRENT_DATE ORDER BY end_date DESC LIMIT 1";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSubscription(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public Subscription save(Subscription subscription) {
        String sql = "INSERT INTO subscriptions (user_id, plan, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, subscription.getUserId());
            stmt.setString(2, subscription.getPlan());
            stmt.setTimestamp(3, new Timestamp(subscription.getStartDate().getTime()));
            stmt.setTimestamp(4, new Timestamp(subscription.getEndDate().getTime()));
            stmt.setString(5, subscription.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        subscription.setSubscriptionId(generatedKeys.getInt(1));
                        return subscription;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subscription;
    }

    @Override
    public boolean update(Subscription subscription) {
        String sql = "UPDATE subscriptions SET user_id = ?, plan = ?, start_date = ?, end_date = ?, status = ? WHERE subscription_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, subscription.getUserId());
            stmt.setString(2, subscription.getPlan());
            stmt.setTimestamp(3, new Timestamp(subscription.getStartDate().getTime()));
            stmt.setTimestamp(4, new Timestamp(subscription.getEndDate().getTime()));
            stmt.setString(5, subscription.getStatus());
            stmt.setInt(6, subscription.getSubscriptionId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM subscriptions WHERE subscription_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countActiveSubscriptions() {
        String sql = "SELECT COUNT(*) FROM subscriptions WHERE status = 'ACTIVE' AND end_date >= CURRENT_DATE";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    @Override
    public Map<String, Integer> countByPlan() {
        Map<String, Integer> planCounts = new HashMap<>();
        String sql = "SELECT plan, COUNT(*) as count FROM subscriptions WHERE status = 'ACTIVE' AND end_date >= CURRENT_DATE GROUP BY plan";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                planCounts.put(rs.getString("plan"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return planCounts;
    }

    @Override
    public List<Subscription> findAllWithUserDetails() {
        List<Subscription> subscriptions = new ArrayList<>();
        String sql = "SELECT s.*, u.name, u.email FROM subscriptions s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "ORDER BY s.end_date DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Subscription subscription = mapResultSetToSubscription(rs);
                // You might want to add user details to the subscription object
                // or create a DTO that combines subscription and user details
                subscriptions.add(subscription);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return subscriptions;
    }
    
    /**
     * Map ResultSet to Subscription object
     */
    private Subscription mapResultSetToSubscription(ResultSet rs) throws SQLException {
        Subscription subscription = new Subscription();
        subscription.setSubscriptionId(rs.getInt("subscription_id"));
        subscription.setUserId(rs.getInt("user_id"));
        subscription.setPlan(rs.getString("plan"));
        subscription.setStartDate(new Date(rs.getTimestamp("start_date").getTime()));
        subscription.setEndDate(new Date(rs.getTimestamp("end_date").getTime()));
        subscription.setStatus(rs.getString("status"));
        return subscription;
    }
}