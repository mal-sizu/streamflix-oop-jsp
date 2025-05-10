package com.streamflix.model;

/**
 * Episode model class for TV series
 */
public class Episode {
    private int episodeId;
    private int seriesId;
    private int season;
    private int episodeNumber;
    private String title;
    private String mediaUrl;
    
    // Default constructor
    public Episode() {
    }
    
    // Constructor with fields
    public Episode(int episodeId, int seriesId, int season, int episodeNumber, String title, String mediaUrl) {
        this.episodeId = episodeId;
        this.seriesId = seriesId;
        this.season = season;
        this.episodeNumber = episodeNumber;
        this.title = title;
        this.mediaUrl = mediaUrl;
    }
    
    // Constructor without id (for new episodes)
    public Episode(int seriesId, int season, int episodeNumber, String title, String mediaUrl) {
        this.seriesId = seriesId;
        this.season = season;
        this.episodeNumber = episodeNumber;
        this.title = title;
        this.mediaUrl = mediaUrl;
    }
    
    // Getters and setters
    public int getEpisodeId() {
        return episodeId;
    }
    
    public void setEpisodeId(int episodeId) {
        this.episodeId = episodeId;
    }
    
    public int getSeriesId() {
        return seriesId;
    }
    
    public void setSeriesId(int seriesId) {
        this.seriesId = seriesId;
    }
    
    public int getSeason() {
        return season;
    }
    
    public void setSeason(int season) {
        this.season = season;
    }
    
    public int getEpisodeNumber() {
        return episodeNumber;
    }
    
    public void setEpisodeNumber(int episodeNumber) {
        this.episodeNumber = episodeNumber;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getMediaUrl() {
        return mediaUrl;
    }
    
    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }
    
    @Override
    public String toString() {
        return "Episode{" +
                "episodeId=" + episodeId +
                ", seriesId=" + seriesId +
                ", season=" + season +
                ", episodeNumber=" + episodeNumber +
                ", title='" + title + '\'' +
                '}';
    }
}
