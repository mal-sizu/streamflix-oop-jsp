package com.streamflix.dao;

import com.streamflix.model.Offer;
import java.util.List;

/**
 * Data Access Object interface for Offer entity
 */
public interface OfferDAO {
    
    /**
     * Find an offer by its ID
     * 
     * @param offerId the ID of the offer to find
     * @return the offer if found, null otherwise
     */
    Offer findById(long offerId);
    
    /**
     * Find all available offers
     * 
     * @return list of all active offers
     */
    List<Offer> findAllActive();
    
    /**
     * Find offers by subscription type
     * 
     * @param subscriptionType the type of subscription
     * @return list of offers for the specified subscription type
     */
    List<Offer> findBySubscriptionType(String subscriptionType);
    
    /**
     * Save a new offer
     * 
     * @param offer the offer to save
     * @return the saved offer with generated ID
     */
    Offer save(Offer offer);
    
    /**
     * Update an existing offer
     * 
     * @param offer the offer to update
     * @return true if updated successfully, false otherwise
     */
    boolean update(Offer offer);
    
    /**
     * Delete an offer by its ID
     * 
     * @param offerId the ID of the offer to delete
     * @return true if deleted successfully, false otherwise
     */
    boolean delete(long offerId);
    
    /**
     * Find promotional offers (with discount)
     * 
     * @return list of promotional offers
     */
    List<Offer> findPromotionalOffers();
    
    /**
     * Find offers by price range
     * 
     * @param minPrice the minimum price
     * @param maxPrice the maximum price
     * @return list of offers within the specified price range
     */
    List<Offer> findByPriceRange(double minPrice, double maxPrice);
}