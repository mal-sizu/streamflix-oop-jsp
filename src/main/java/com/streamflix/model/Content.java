package com.streamflix.model;

import java.util.Date;
import java.util.List;

/**
 * Content model class for both movies and series
 */
public class Content {
    private int contentId;
    private String type; // "MOVIE" or "SERIES"
    private String title;
    private String description;
    private String genre;
    private String language;
    private Date releaseDate;
    private String thumbnailUrl;
    private String mediaUrl;
    private List<Episode> episodes;
    private double averageRating;
    
    // Default constructor
    public Content() {
    }
    
    // Constructor with fields
    public Content(int contentId, String type, String title, String description, String genre, 
                  String language, Date releaseDate, String thumbnailUrl, String mediaUrl) {
        this.contentId = contentId;
        this.type = type;
        this.title = title;
        this.description = description;
        this.genre = genre;
        this.language = language;
        this.releaseDate = releaseDate;
        this.thumbnailUrl = thumbnailUrl;
        this.mediaUrl = mediaUrl;
    }
    
    // Constructor without id (for new content)
    public Content(String type, String title, String description, String genre, 
                  String language, Date releaseDate, String thumbnailUrl, String mediaUrl) {
        this.type = type;
        this.title = title;
        this.description = description;
        this.genre = genre;
        this.language = language;
        this.releaseDate = releaseDate;
        this.thumbnailUrl = thumbnailUrl;
        this.mediaUrl = mediaUrl;
    }
    
    // Getters and setters
    public int getContentId() {
        return contentId;
    }
    
    public void setContentId(int contentId) {
        this.contentId = contentId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getGenre() {
        return genre;
    }
    
    public void setGenre(String genre) {
        this.genre = genre;
    }
    
    public String getLanguage() {
        return language;
    }
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    public Date getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public String getThumbnailUrl() {
        return thumbnailUrl;
    }
    
    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }
    
    public String getMediaUrl() {
        return mediaUrl;
    }
    
    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }
    
    public List<Episode> getEpisodes() {
        return episodes;
    }
    
    public void setEpisodes(List<Episode> episodes) {
        this.episodes = episodes;
    }
    
    public double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
    
    public boolean isMovie() {
        return "MOVIE".equals(type);
    }
    
    public boolean isSeries() {
        return "SERIES".equals(type);
    }
    
    @Override
    public String toString() {
        return "Content{" +
                "contentId=" + contentId +
                ", type='" + type + '\'' +
                ", title='" + title + '\'' +
                ", genre='" + genre + '\'' +
                ", language='" + language + '\'' +
                ", releaseDate=" + releaseDate +
                '}';
    }
}