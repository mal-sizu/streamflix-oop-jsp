package com.streamflix.dao;

import com.streamflix.model.Profile;
import java.util.List;

/**
 * Interface for Profile data access operations
 */
public interface ProfileDAO {
    
    /**
     * Find profile by ID
     * 
     * @param profileId the profile ID
     * @return the profile if found, null otherwise
     */
    Profile findById(int profileId);
    
    /**
     * Find profiles by user ID
     * 
     * @param userId the user ID
     * @return list of profiles for the user
     */
    List<Profile> findByUserId(int userId);
    
    /**
     * Save a new profile
     * 
     * @param profile the profile to save
     * @return the saved profile with ID populated
     */
    Profile save(Profile profile);
    
    /**
     * Update an existing profile
     * 
     * @param profile the profile to update
     * @return true if successful, false otherwise
     */
    boolean update(Profile profile);
    
    /**
     * Delete a profile
     * 
     * @param profileId the ID of the profile to delete
     * @return true if successful, false otherwise
     */
    boolean delete(int profileId);
    
    /**
     * Count profiles for a user
     * 
     * @param userId the user ID
     * @return the number of profiles
     */
    int countByUserId(int userId);
}
