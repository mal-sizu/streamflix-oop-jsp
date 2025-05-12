package com.streamflix.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Payment model class
 */
public class Payment {
    private int paymentId;
    private int subscriptionId;
    private BigDecimal amount;
    private Date paymentDate;
    private String method;
    
    // Default constructor
    public Payment() {
    }
    
    // Constructor with fields
    public Payment(int paymentId, int subscriptionId, BigDecimal amount, Date paymentDate, String method) {
        this.paymentId = paymentId;
        this.subscriptionId = subscriptionId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.method = method;
    }
    
    // Constructor without id (for new payments)
    public Payment(int subscriptionId, BigDecimal amount, Date paymentDate, String method) {
        this.subscriptionId = subscriptionId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.method = method;
    }
    
    // Getters and setters
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    
    public int getSubscriptionId() {
        return subscriptionId;
    }
    
    public void setSubscriptionId(int subscriptionId) {
        this.subscriptionId = subscriptionId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public Date getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public String getMethod() {
        return method;
    }
    
    public void setMethod(String method) {
        this.method = method;
    }
    
    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", subscriptionId=" + subscriptionId +
                ", amount=" + amount +
                ", paymentDate=" + paymentDate +
                ", method='" + method + '\'' +
                '}';
    }
}
