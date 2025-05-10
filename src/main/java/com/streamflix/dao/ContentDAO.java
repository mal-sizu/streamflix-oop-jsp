package com.streamflix.dao;

import com.streamflix.model.Content;
import java.util.List;

/**
 * Interface for Content data access operations
 */
public interface ContentDAO {
    
    /**
     * Find content by ID
     * 
     * @param contentId the content ID
     * @return the content if found, null otherwise
     */
    Content findById(int contentId);
    
    /**
     * Save new content
     * 
     * @param content the content to save
     * @return the saved content with ID populated
     */
    Content save(Content content);
    
    /**
     * Update existing content
     * 
     * @param content the content to update
     * @return true if successful, false otherwise
     */
    boolean update(Content content);
    
    /**
     * Delete content
     * 
     * @param contentId the ID of the content to delete
     * @return true if successful, false otherwise
     */
    boolean delete(int contentId);
    
    /**
     * Find all content
     * 
     * @return list of all content
     */
    List<Content> findAll();
    
    /**
     * Find content by type (MOVIE or SERIES)
     * 
     * @param type the content type
     * @return list of content with the specified type
     */
    List<Content> findByType(String type);
    
    /**
     * Find content by genre
     * 
     * @param genre the content genre
     * @return list of content with the specified genre
     */
    List<Content> findByGenre(String genre);
    
    /**
     * Find content by language
     * 
     * @param language the content language
     * @return list of content with the specified language
     */
    List<Content> findByLanguage(String language);
    
    /**
     * Search content by title or description
     * 
     * @param query the search query
     * @return list of content matching the query
     */
    List<Content> search(String query);
    
    /**
     * Find content with episodes for series
     * 
     * @param contentId the content ID
     * @return the content with episodes loaded
     */
    Content findWithEpisodes(int contentId);
    
    /**
     * Find recent content
     * 
     * @param limit the maximum number of results
     * @return list of recent content
     */
    List<Content> findRecent(int limit);
    
    /**
     * Find top-rated content
     * 
     * @param limit the maximum number of results
     * @return list of top-rated content
     */
    List<Content> findTopRated(int limit);
}
