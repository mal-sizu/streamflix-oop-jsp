package com.streamflix.dao;

import com.streamflix.model.Payment;
import com.streamflix.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.sql.DataSource;

/**
 * Implementation of the PaymentDAO interface
 */
public class PaymentDAOImpl implements PaymentDAO {
    
    private DataSource dataSource;
    
    public PaymentDAOImpl() {
        this.dataSource = DatabaseUtil.getDataSource();
    }
    
    @Override
    public Payment findById(long paymentId) {
        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, paymentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Payment> findByUserId(long userId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* FROM payments p JOIN subscriptions s ON p.subscription_id = s.subscription_id "
                + "WHERE s.user_id = ? ORDER BY p.payment_date DESC";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    @Override
    public List<Payment> findBySubscriptionId(long subscriptionId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE subscription_id = ? ORDER BY payment_date DESC";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, subscriptionId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    @Override
    public List<Payment> findByDateRange(Date startDate, Date endDate) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE payment_date BETWEEN ? AND ? ORDER BY payment_date DESC";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    @Override
    public List<Payment> findByStatus(String status) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE status = ? ORDER BY payment_date DESC";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return payments;
    }
    
    @Override
    public Payment save(Payment payment) {
        String sql = "INSERT INTO payments (subscription_id, amount, payment_date, payment_method, "
                + "transaction_id, status, billing_address, card_last_four) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setPaymentParameters(stmt, payment);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentId(generatedKeys.getLong(1));
                        return payment;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public boolean update(Payment payment) {
        String sql = "UPDATE payments SET subscription_id = ?, amount = ?, payment_date = ?, "
                + "payment_method = ?, transaction_id = ?, status = ?, billing_address = ?, "
                + "card_last_four = ? WHERE payment_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setPaymentParameters(stmt, payment);
            stmt.setLong(9, payment.getPaymentId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean delete(long paymentId) {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, paymentId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public double getTotalRevenue(Date startDate, Date endDate) {
        String sql = "SELECT SUM(amount) FROM payments WHERE payment_date BETWEEN ? AND ? AND status = 'COMPLETED'";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    @Override
    public int getCountByPaymentMethod(String paymentMethod) {
        String sql = "SELECT COUNT(*) FROM payments WHERE payment_method = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, paymentMethod);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getLong("payment_id"));
        payment.setSubscriptionId(rs.getLong("subscription_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setStatus(rs.getString("status"));
        payment.setBillingAddress(rs.getString("billing_address"));
        payment.setCardLastFour(rs.getString("card_last_four"));
        return payment;
    }
    
    private void setPaymentParameters(PreparedStatement stmt, Payment payment) throws SQLException {
        stmt.setLong(1, payment.getSubscriptionId());
        stmt.setDouble(2, payment.getAmount());
        stmt.setTimestamp(3, new java.sql.Timestamp(payment.getPaymentDate().getTime()));
        stmt.setString(4, payment.getPaymentMethod());
        stmt.setString(5, payment.getTransactionId());
        stmt.setString(6, payment.getStatus());
        stmt.setString(7, payment.getBillingAddress());
        stmt.setString(8, payment.getCardLastFour());
    }
}