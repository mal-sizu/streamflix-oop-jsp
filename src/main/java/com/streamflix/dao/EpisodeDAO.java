package com.streamflix.dao;

import com.streamflix.model.Episode;
import java.util.List;

/**
 * Data Access Object interface for Episode entity
 */
public interface EpisodeDAO {
    
    /**
     * Find an episode by its ID
     * 
     * @param episodeId the ID of the episode to find
     * @return the episode if found, null otherwise
     */
    Episode findById(long episodeId);
    
    /**
     * Find all episodes for a specific content (TV series)
     * 
     * @param contentId the ID of the content
     * @return list of episodes for the content
     */
    List<Episode> findByContentId(long contentId);
    
    /**
     * Find episodes by season number for a specific content
     * 
     * @param contentId the ID of the content
     * @param seasonNumber the season number
     * @return list of episodes for the specified season
     */
    List<Episode> findByContentIdAndSeason(long contentId, int seasonNumber);
    
    /**
     * Save a new episode
     * 
     * @param episode the episode to save
     * @return the saved episode with generated ID
     */
    Episode save(Episode episode);
    
    /**
     * Update an existing episode
     * 
     * @param episode the episode to update
     * @return true if updated successfully, false otherwise
     */
    boolean update(Episode episode);
    
    /**
     * Delete an episode by its ID
     * 
     * @param episodeId the ID of the episode to delete
     * @return true if deleted successfully, false otherwise
     */
    boolean delete(long episodeId);
    
    /**
     * Get the total number of episodes for a content
     * 
     * @param contentId the ID of the content
     * @return the count of episodes
     */
    int getEpisodeCount(long contentId);
    
    /**
     * Get the next episode to watch based on user's viewing history
     * 
     * @param contentId the ID of the content
     * @param profileId the ID of the user profile
     * @return the next episode to watch, or null if all episodes watched
     */
    Episode getNextEpisodeToWatch(long contentId, long profileId);
}