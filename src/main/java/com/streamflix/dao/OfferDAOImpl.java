package com.streamflix.dao;

import com.streamflix.model.Offer;
import com.streamflix.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;

/**
 * Implementation of the OfferDAO interface
 */
public class OfferDAOImpl implements OfferDAO {
    
    private DataSource dataSource;
    
    public OfferDAOImpl() {
        this.dataSource = DatabaseUtil.getDataSource();
    }
    
    @Override
    public Offer findById(long offerId) {
        String sql = "SELECT * FROM offers WHERE offer_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, offerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOffer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Offer> findAllActive() {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT * FROM offers WHERE is_active = true ORDER BY price";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return offers;
    }
    
    @Override
    public List<Offer> findBySubscriptionType(String subscriptionType) {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT * FROM offers WHERE subscription_type = ? AND is_active = true ORDER BY price";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, subscriptionType);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    offers.add(mapResultSetToOffer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return offers;
    }
    
    @Override
    public Offer save(Offer offer) {
        String sql = "INSERT INTO offers (name, description, subscription_type, price, duration_months, "
                + "max_profiles, resolution, is_active, discount_percentage, features) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setOfferParameters(stmt, offer);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        offer.setOfferId(generatedKeys.getLong(1));
                        return offer;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public boolean update(Offer offer) {
        String sql = "UPDATE offers SET name = ?, description = ?, subscription_type = ?, price = ?, "
                + "duration_months = ?, max_profiles = ?, resolution = ?, is_active = ?, "
                + "discount_percentage = ?, features = ? WHERE offer_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setOfferParameters(stmt, offer);
            stmt.setLong(11, offer.getOfferId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean delete(long offerId) {
        String sql = "DELETE FROM offers WHERE offer_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, offerId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public List<Offer> findPromotionalOffers() {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT * FROM offers WHERE discount_percentage > 0 AND is_active = true ORDER BY discount_percentage DESC";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return offers;
    }
    
    @Override
    public List<Offer> findByPriceRange(double minPrice, double maxPrice) {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT * FROM offers WHERE price BETWEEN ? AND ? AND is_active = true ORDER BY price";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, minPrice);
            stmt.setDouble(2, maxPrice);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    offers.add(mapResultSetToOffer(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return offers;
    }
    
    private Offer mapResultSetToOffer(ResultSet rs) throws SQLException {
        Offer offer = new Offer();
        offer.setOfferId(rs.getLong("offer_id"));
        offer.setName(rs.getString("name"));
        offer.setDescription(rs.getString("description"));
        offer.setSubscriptionType(rs.getString("subscription_type"));
        offer.setPrice(rs.getDouble("price"));
        offer.setDurationMonths(rs.getInt("duration_months"));
        offer.setMaxProfiles(rs.getInt("max_profiles"));
        offer.setResolution(rs.getString("resolution"));
        offer.setActive(rs.getBoolean("is_active"));
        offer.setDiscountPercentage(rs.getDouble("discount_percentage"));
        offer.setFeatures(rs.getString("features"));
        return offer;
    }
    
    private void setOfferParameters(PreparedStatement stmt, Offer offer) throws SQLException {
        stmt.setString(1, offer.getName());
        stmt.setString(2, offer.getDescription());
        stmt.setString(3, offer.getSubscriptionType());
        stmt.setDouble(4, offer.getPrice());
        stmt.setInt(5, offer.getDurationMonths());
        stmt.setInt(6, offer.getMaxProfiles());
        stmt.setString(7, offer.getResolution());
        stmt.setBoolean(8, offer.isActive());
        stmt.setDouble(9, offer.getDiscountPercentage());
        stmt.setString(10, offer.getFeatures());
    }
}