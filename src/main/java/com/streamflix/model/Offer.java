package com.streamflix.model;

import java.util.Date;

/**
 * Offer model class
 */
public class Offer {
    private int offerId;
    private String code;
    private String description;
    private int discountPercent;
    private Date validFrom;
    private Date validTo;
    
    // Default constructor
    public Offer() {
    }
    
    // Constructor with fields
    public Offer(int offerId, String code, String description, int discountPercent, Date validFrom, Date validTo) {
        this.offerId = offerId;
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.validFrom = validFrom;
        this.validTo = validTo;
    }
    
    // Constructor without id (for new offers)
    public Offer(String code, String description, int discountPercent, Date validFrom, Date validTo) {
        this.code = code;
        this.description = description;
        this.discountPercent = discountPercent;
        this.validFrom = validFrom;
        this.validTo = validTo;
    }
    
    // Getters and setters
    public int getOfferId() {
        return offerId;
    }
    
    public void setOfferId(int offerId) {
        this.offerId = offerId;
    }
    
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getDiscountPercent() {
        return discountPercent;
    }
    
    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }
    
    public Date getValidFrom() {
        return validFrom;
    }
    
    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }
    
    public Date getValidTo() {
        return validTo;
    }
    
    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }
    
    /**
     * Check if offer is valid at the current time
     * @return true if valid, false otherwise
     */
    public boolean isValid() {
        Date now = new Date();
        return now.after(validFrom) && now.before(validTo);
    }
    
    @Override
    public String toString() {
        return "Offer{" +
                "offerId=" + offerId +
                ", code='" + code + '\'' +
                ", description='" + description + '\'' +
                ", discountPercent=" + discountPercent +
                ", validFrom=" + validFrom +
                ", validTo=" + validTo +
                '}';
    }
}
