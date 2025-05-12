package com.streamflix.dao;

import com.streamflix.model.Payment;
import java.util.Date;
import java.util.List;
import java.math.BigDecimal;

/**
 * Data Access Object interface for Payment entity
 */
public interface PaymentDAO {
    
    /**
     * Find a payment by its ID
     * 
     * @param paymentId the ID of the payment to find
     * @return the payment if found, null otherwise
     */
    Payment findById(int paymentId);
    
    /**
     * Find all payments for a specific user
     * 
     * @param userId the ID of the user
     * @return list of payments for the user
     */
    List<Payment> findByUserId(int userId);
    
    /**
     * Find payments by subscription ID
     * 
     * @param subscriptionId the ID of the subscription
     * @return list of payments for the subscription
     */
    List<Payment> findBySubscriptionId(int subscriptionId);
    
    /**
     * Find payments by date range
     * 
     * @param startDate the start date
     * @param endDate the end date
     * @return list of payments within the date range
     */
    List<Payment> findByDateRange(Date startDate, Date endDate);
    
    /**
     * Find payments by method
     * 
     * @param method the payment method
     * @return list of payments with the specified method
     */
    List<Payment> findByMethod(String method);
    
    /**
     * Save a new payment
     * 
     * @param payment the payment to save
     * @return the saved payment with generated ID
     */
    Payment save(Payment payment);
    
    /**
     * Update an existing payment
     * 
     * @param payment the payment to update
     * @return true if updated successfully, false otherwise
     */
    boolean update(Payment payment);
    
    /**
     * Delete a payment by its ID
     * 
     * @param paymentId the ID of the payment to delete
     * @return true if deleted successfully, false otherwise
     */
    boolean delete(int paymentId);
    
    /**
     * Get total revenue for a specific period
     * 
     * @param startDate the start date
     * @param endDate the end date
     * @return the total revenue amount
     */
    BigDecimal getTotalRevenue(Date startDate, Date endDate);
    
    /**
     * Get count of payments by payment method
     * 
     * @param method the payment method
     * @return the count of payments
     */
    int getCountByPaymentMethod(String method);
}