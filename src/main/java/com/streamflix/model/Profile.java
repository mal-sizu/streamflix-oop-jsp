package com.streamflix.model;

/**
 * Profile model class
 */
public class Profile {
    private int profileId;
    private int userId;
    private String profileName;
    private String avatarUrl;
    private int ageLimit;
    
    // Default constructor
    public Profile() {
    }
    
    // Constructor with fields
    public Profile(int profileId, int userId, String profileName, String avatarUrl, int ageLimit) {
        this.profileId = profileId;
        this.userId = userId;
        this.profileName = profileName;
        this.avatarUrl = avatarUrl;
        this.ageLimit = ageLimit;
    }
    
    // Constructor without id (for new profiles)
    public Profile(int userId, String profileName, String avatarUrl, int ageLimit) {
        this.userId = userId;
        this.profileName = profileName;
        this.avatarUrl = avatarUrl;
        this.ageLimit = ageLimit;
    }
    
    // Getters and setters
    public int getProfileId() {
        return profileId;
    }
    
    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getProfileName() {
        return profileName;
    }
    
    public void setProfileName(String profileName) {
        this.profileName = profileName;
    }
    
    public String getAvatarUrl() {
        return avatarUrl;
    }
    
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    public int getAgeLimit() {
        return ageLimit;
    }
    
    public void setAgeLimit(int ageLimit) {
        this.ageLimit = ageLimit;
    }
    
    @Override
    public String toString() {
        return "Profile{" +
                "profileId=" + profileId +
                ", userId=" + userId +
                ", profileName='" + profileName + '\'' +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", ageLimit=" + ageLimit +
                '}';
    }
}
