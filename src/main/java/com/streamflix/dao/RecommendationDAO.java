package com.streamflix.dao;

import com.streamflix.model.Content;
import java.util.List;

/**
 * Interface for Recommendation data access operations
 */
public interface RecommendationDAO {
    
    /**
     * Get personalized recommendations for a user based on their viewing history and preferences
     * 
     * @param userId the user ID
     * @param limit the maximum number of recommendations to return
     * @return list of recommended content
     */
    List<Content> getPersonalizedRecommendations(int userId, int limit);
    
    /**
     * Get recommendations based on content similarity to a specific content item
     * 
     * @param contentId the content ID to find similar content for
     * @param limit the maximum number of recommendations to return
     * @return list of similar content
     */
    List<Content> getSimilarContent(int contentId, int limit);
    
    /**
     * Get trending content recommendations
     * 
     * @param limit the maximum number of recommendations to return
     * @return list of trending content
     */
    List<Content> getTrendingContent(int limit);
    
    /**
     * Get recommendations based on genre
     * 
     * @param genre the genre to get recommendations for
     * @param limit the maximum number of recommendations to return
     * @return list of content in the specified genre
     */
    List<Content> getRecommendationsByGenre(String genre, int limit);
    
    /**
     * Get recommendations based on user ratings
     * 
     * @param userId the user ID
     * @param limit the maximum number of recommendations to return
     * @return list of highly rated content that the user might enjoy
     */
    List<Content> getRecommendationsByRatings(int userId, int limit);
    
    /**
     * Get new releases recommendations
     * 
     * @param limit the maximum number of recommendations to return
     * @return list of newly released content
     */
    List<Content> getNewReleases(int limit);
    
    /**
     * Get recommendations for content that is popular among users with similar preferences
     * 
     * @param userId the user ID
     * @param limit the maximum number of recommendations to return
     * @return list of content popular among similar users
     */
    List<Content> getRecommendationsFromSimilarUsers(int userId, int limit);
}