package com.streamflix.dao;

import com.streamflix.model.Subscription;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object interface for Subscription entity
 */
public interface SubscriptionDAO {
    
    /**
     * Find subscription by ID
     * @param id Subscription ID
     * @return Subscription object if found, null otherwise
     */
    Subscription findById(int id);
    
    /**
     * Find all subscriptions
     * @return List of all subscriptions
     */
    List<Subscription> findAll();
    
    /**
     * Find subscriptions by user ID
     * @param userId User ID
     * @return List of subscriptions for the user
     */
    List<Subscription> findByUserId(int userId);
    
    /**
     * Find active subscription for a user
     * @param userId User ID
     * @return Active subscription if exists, null otherwise
     */
    Subscription findActiveByUserId(int userId);
    
    /**
     * Save a new subscription
     * @param subscription Subscription to save
     * @return Saved subscription with generated ID
     */
    Subscription save(Subscription subscription);
    
    /**
     * Update an existing subscription
     * @param subscription Subscription to update
     * @return true if successful, false otherwise
     */
    boolean update(Subscription subscription);
    
    /**
     * Delete a subscription
     * @param id Subscription ID to delete
     * @return true if successful, false otherwise
     */
    boolean delete(int id);
    
    /**
     * Count active subscriptions
     * @return Number of active subscriptions
     */
    int countActiveSubscriptions();
    
    /**
     * Count subscriptions by plan
     * @return Map of plan names to counts
     */
    Map<String, Integer> countByPlan();
    
    /**
     * Find all subscriptions with user details
     * @return List of subscriptions with user details
     */
    List<Subscription> findAllWithUserDetails();
}