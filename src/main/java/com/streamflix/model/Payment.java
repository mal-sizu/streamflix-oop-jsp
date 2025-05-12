package com.streamflix.model;

import java.util.Date;

/**
 * Payment model class
 */
public class Payment {
    private long paymentId;
    private long subscriptionId;
    private double amount;
    private Date paymentDate;
    private String paymentMethod;
    private String transactionId;
    private String status;
    private String billingAddress;
    private String cardLastFour;
    
    // Default constructor
    public Payment() {
    }
    
    // Constructor with fields
    public Payment(long paymentId, long subscriptionId, double amount, Date paymentDate, 
                  String paymentMethod, String transactionId, String status, 
                  String billingAddress, String cardLastFour) {
        this.paymentId = paymentId;
        this.subscriptionId = subscriptionId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.status = status;
        this.billingAddress = billingAddress;
        this.cardLastFour = cardLastFour;
    }
    
    // Constructor without id (for new payments)
    public Payment(long subscriptionId, double amount, Date paymentDate, 
                  String paymentMethod, String transactionId, String status, 
                  String billingAddress, String cardLastFour) {
        this.subscriptionId = subscriptionId;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.status = status;
        this.billingAddress = billingAddress;
        this.cardLastFour = cardLastFour;
    }
    
    // Getters and setters
    public long getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(long paymentId) {
        this.paymentId = paymentId;
    }
    
    public long getSubscriptionId() {
        return subscriptionId;
    }
    
    public void setSubscriptionId(long subscriptionId) {
        this.subscriptionId = subscriptionId;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public Date getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getBillingAddress() {
        return billingAddress;
    }
    
    public void setBillingAddress(String billingAddress) {
        this.billingAddress = billingAddress;
    }
    
    public String getCardLastFour() {
        return cardLastFour;
    }
    
    public void setCardLastFour(String cardLastFour) {
        this.cardLastFour = cardLastFour;
    }
    
    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", subscriptionId=" + subscriptionId +
                ", amount=" + amount +
                ", paymentDate=" + paymentDate +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", transactionId='" + transactionId + '\'' +
                ", status='" + status + '\'' +
                ", billingAddress='" + billingAddress + '\'' +
                ", cardLastFour='" + cardLastFour + '\'' +
                '}';
    }
}
