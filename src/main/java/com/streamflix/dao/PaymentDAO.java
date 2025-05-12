package com.streamflix.dao;

import com.streamflix.model.Payment;
import java.util.Date;
import java.util.List;

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
    Payment findById(long paymentId);
    
    /**
     * Find all payments for a specific user
     * 
     * @param userId the ID of the user
     * @return list of payments for the user
     */
    List<Payment> findByUserId(long userId);
    
    /**
     * Find payments by subscription ID
     * 
     * @param subscriptionId the ID of the subscription
     * @return list of payments for the subscription
     */
    List<Payment> findBySubscriptionId(long subscriptionId);
    
    /**
     * Find payments by date range
     * 
     * @param startDate the start date
     * @param endDate the end date
     * @return list of payments within the date range
     */
    List<Payment> findByDateRange(Date startDate, Date endDate);
    
    /**
     * Find payments by status
     * 
     * @param status the payment status
     * @return list of payments with the specified status
     */
    List<Payment> findByStatus(String status);
    
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
    boolean delete(long paymentId);
    
    /**
     * Get total revenue for a specific period
     * 
     * @param startDate the start date
     * @param endDate the end date
     * @return the total revenue amount
     */
    double getTotalRevenue(Date startDate, Date endDate);
    
    /**
     * Get count of payments by payment method
     * 
     * @param paymentMethod the payment method
     * @return the count of payments
     */
    int getCountByPaymentMethod(String paymentMethod);
}