package com.streamflix.model;

import java.util.Date;

/**
 * Subscription model class
 */
public class Subscription {
    private int subscriptionId;
    private int userId;
    private String plan;
    private Date startDate;
    private Date endDate;
    private String status;
    
    // Default constructor
    public Subscription() {
    }
    
    // Constructor with fields
    public Subscription(int subscriptionId, int userId, String plan, Date startDate, Date endDate, String status) {
        this.subscriptionId = subscriptionId;
        this.userId = userId;
        this.plan = plan;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }
    
    // Constructor without id (for new subscriptions)
    public Subscription(int userId, String plan, Date startDate, Date endDate, String status) {
        this.userId = userId;
        this.plan = plan;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }
    
    // Getters and setters
    public int getSubscriptionId() {
        return subscriptionId;
    }
    
    public void setSubscriptionId(int subscriptionId) {
        this.subscriptionId = subscriptionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getPlan() {
        return plan;
    }
    
    public void setPlan(String plan) {
        this.plan = plan;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    /**
     * Check if subscription is active
     * @return true if active, false otherwise
     */
    public boolean isActive() {
        return "ACTIVE".equals(status) && new Date().before(endDate);
    }
    
    @Override
    public String toString() {
        return "Subscription{" +
                "subscriptionId=" + subscriptionId +
                ", userId=" + userId +
                ", plan='" + plan + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                '}';
    }
}
