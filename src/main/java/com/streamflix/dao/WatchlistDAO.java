package com.streamflix.dao;

import com.streamflix.model.Content;
import java.util.List;

/**
 * Interface for Watchlist data access operations
 */
public interface WatchlistDAO {
    
    /**
     * Find watchlist items by profile ID
     * 
     * @param profileId the profile ID
     * @return list of content in the watchlist
     */
    List<Content> findByProfileId(int profileId);
    
    /**
     * Add content to watchlist
     * 
     * @param profileId the profile ID
     * @param contentId the content ID
     * @return true if successful, false otherwise
     */
    boolean addToWatchlist(int profileId, int contentId);
    
    /**
     * Remove content from watchlist
     * 
     * @param profileId the profile ID
     * @param contentId the content ID
     * @return true if successful, false otherwise
     */
    boolean removeFromWatchlist(int profileId, int contentId);
    
    /**
     * Check if content is in watchlist
     * 
     * @param profileId the profile ID
     * @param contentId the content ID
     * @return true if in watchlist, false otherwise
     */
    boolean isInWatchlist(int profileId, int contentId);
    
    /**
     * Count items in watchlist
     * 
     * @param profileId the profile ID
     * @return the count of items
     */
    int countWatchlistItems(int profileId);
}
