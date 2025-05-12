package com.streamflix.dao;

import com.streamflix.model.Offer;
import com.streamflix.utils.DatabaseUtil;

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
        String sql = "SELECT * FROM offers WHERE valid_to >= CURRENT_DATE ORDER BY discount_percent";
        
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
        // Since the Offer model doesn't have a subscriptionType field,
        // we'll return an empty list or implement a different logic if needed
        return new ArrayList<>();
    }
    
    @Override
    public Offer save(Offer offer) {
        String sql = "INSERT INTO offers (code, description, discount_percent, valid_from, valid_to) "
                + "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setOfferParameters(stmt, offer);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        offer.setOfferId(generatedKeys.getInt(1));
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
        String sql = "UPDATE offers SET code = ?, description = ?, discount_percent = ?, "
                + "valid_from = ?, valid_to = ? WHERE offer_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setOfferParameters(stmt, offer);
            stmt.setInt(6, offer.getOfferId());
            
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
        String sql = "SELECT * FROM offers WHERE discount_percent > 0 AND valid_to >= CURRENT_DATE ORDER BY discount_percent DESC";
        
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
        // Since the Offer model doesn't have a price field,
        // we'll return an empty list or implement a different logic if needed
        return new ArrayList<>();
    }
    
    private Offer mapResultSetToOffer(ResultSet rs) throws SQLException {
        Offer offer = new Offer();
        offer.setOfferId(rs.getInt("offer_id"));
        offer.setCode(rs.getString("code"));
        offer.setDescription(rs.getString("description"));
        offer.setDiscountPercent(rs.getInt("discount_percent"));
        offer.setValidFrom(rs.getTimestamp("valid_from"));
        offer.setValidTo(rs.getTimestamp("valid_to"));
        return offer;
    }
    
    private void setOfferParameters(PreparedStatement stmt, Offer offer) throws SQLException {
        stmt.setString(1, offer.getCode());
        stmt.setString(2, offer.getDescription());
        stmt.setInt(3, offer.getDiscountPercent());
        stmt.setTimestamp(4, new Timestamp(offer.getValidFrom().getTime()));
        stmt.setTimestamp(5, new Timestamp(offer.getValidTo().getTime()));
    }
}