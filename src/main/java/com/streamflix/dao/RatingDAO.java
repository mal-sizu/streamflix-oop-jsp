package com.streamflix.dao;

import com.streamflix.model.Rating;
import java.util.List;
import java.util.Map;

/**
 * Interface for Rating data access operations
 */
public interface RatingDAO {
    
    /**
     * Find rating by ID
     * 
     * @param ratingId the rating ID
     * @return the rating if found, null otherwise
     */
    Rating findById(int ratingId);
    
    /**
     * Find ratings by content ID
     * 
     * @param contentId the content ID
     * @return list of ratings for the content
     */
    List<Rating> findByContentId(int contentId);
    
    /**
     * Find ratings by content ID with profile data
     * 
     * @param contentId the content ID
     * @return list of ratings with profile data for the content
     */
    List<Rating> findByContentIdWithProfiles(int contentId);
    
    /**
     * Find ratings by content ID with profile data, with pagination
     * 
     * @param contentId the content ID
     * @param skip number of records to skip
     * @param limit maximum number of records to return
     * @return list of ratings with profile data for the content
     */
    List<Rating> findByContentIdWithProfiles(int contentId, int skip, int limit);
    
    /**
     * Find ratings by profile ID
     * 
     * @param profileId the profile ID
     * @return list of ratings by the profile
     */
    List<Rating> findByProfileId(int profileId);
    
    /**
     * Find a rating by profile and content
     * 
     * @param profileId the profile ID
     * @param contentId the content ID
     * @return the rating if found, null otherwise
     */
    Rating findByProfileAndContent(int profileId, int contentId);
    
    /**
     * Save a new rating
     * 
     * @param rating the rating to save
     * @return the saved rating with ID populated
     */
    Rating save(Rating rating);
    
    /**
     * Update an existing rating
     * 
     * @param rating the rating to update
     * @return true if successful, false otherwise
     */
    boolean update(Rating rating);
    
    /**
     * Delete a rating
     * 
     * @param ratingId the ID of the rating to delete
     * @return true if successful, false otherwise
     */
    boolean delete(int ratingId);
    
    /**
     * Get average rating for a content
     * 
     * @param contentId the content ID
     * @return the average rating (0-5)
     */
    double getAverageRating(int contentId);
    
    /**
     * Get rating distribution for a content (count of each score 1-5)
     * 
     * @param contentId the content ID
     * @return map of score to count
     */
    Map<Integer, Integer> getRatingDistribution(int contentId);
}
