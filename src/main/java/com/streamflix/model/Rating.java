package com.streamflix.model;

import java.util.Date;

/**
 * Rating model class
 */
public class Rating {
    private int ratingId;
    private int profileId;
    private int contentId;
    private int score;
    private String reviewText;
    private Date createdAt;
    private Profile profile; // For joining with Profile data
    
    // Default constructor
    public Rating() {
    }
    
    // Constructor with fields
    public Rating(int ratingId, int profileId, int contentId, int score, String reviewText, Date createdAt) {
        this.ratingId = ratingId;
        this.profileId = profileId;
        this.contentId = contentId;
        this.score = score;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }
    
    // Constructor without id and date (for new ratings)
    public Rating(int profileId, int contentId, int score, String reviewText) {
        this.profileId = profileId;
        this.contentId = contentId;
        this.score = score;
        this.reviewText = reviewText;
    }
    
    // Getters and setters
    public int getRatingId() {
        return ratingId;
    }
    
    public void setRatingId(int ratingId) {
        this.ratingId = ratingId;
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
    
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public String getReviewText() {
        return reviewText;
    }
    
    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Profile getProfile() {
        return profile;
    }
    
    public void setProfile(Profile profile) {
        this.profile = profile;
    }
    
    @Override
    public String toString() {
        return "Rating{" +
                "ratingId=" + ratingId +
                ", profileId=" + profileId +
                ", contentId=" + contentId +
                ", score=" + score +
                ", reviewText='" + reviewText + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
