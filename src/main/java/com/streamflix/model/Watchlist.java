package com.streamflix.model;

import java.util.Date;

/**
 * Watchlist model class
 */
public class Watchlist {
    private int watchlistId;
    private int profileId;
    private int contentId;
    private Date addedAt;
    private Content content; // For joining with Content data
    
    // Default constructor
    public Watchlist() {
    }
    
    // Constructor with fields
    public Watchlist(int watchlistId, int profileId, int contentId, Date addedAt) {
        this.watchlistId = watchlistId;
        this.profileId = profileId;
        this.contentId = contentId;
        this.addedAt = addedAt;
    }
    
    // Constructor without id and date (for new watchlist items)
    public Watchlist(int profileId, int contentId) {
        this.profileId = profileId;
        this.contentId = contentId;
    }
    
    // Getters and setters
    public int getWatchlistId() {
        return watchlistId;
    }
    
    public void setWatchlistId(int watchlistId) {
        this.watchlistId = watchlistId;
    }
    
    public int getProfileId() {
        return profileId;
    }
    
    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }
    
    public int getContentId() {
        return contentId;
    }
    
    public void setContentId(int contentId) {
        this.contentId = contentId;
    }
    
    public Date getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }
    
    public Content getContent() {
        return content;
    }
    
    public void setContent(Content content) {
        this.content = content;
    }
    
    @Override
    public String toString() {
        return "Watchlist{" +
                "watchlistId=" + watchlistId +
                ", profileId=" + profileId +
                ", contentId=" + contentId +
                ", addedAt=" + addedAt +
                '}';
    }
}
