package com.streamflix.dao;

import com.streamflix.model.User;
import java.util.List;

/**
 * Interface for User data access operations
 */
public interface UserDAO {
    
    /**
     * Find user by ID
     * 
     * @param userId the user ID
     * @return the user if found, null otherwise
     */
    User findById(int userId);
    
    /**
     * Find user by email
     * 
     * @param email the user's email
     * @return the user if found, null otherwise
     */
    User findByEmail(String email);
    
    /**
     * Save a new user
     * 
     * @param user the user to save
     * @return the saved user with ID populated
     */
    User save(User user);
    
    /**
     * Update an existing user
     * 
     * @param user the user to update
     * @return true if successful, false otherwise
     */
    boolean update(User user);
    
    /**
     * Delete a user
     * 
     * @param userId the ID of the user to delete
     * @return true if successful, false otherwise
     */
    boolean delete(int userId);
    
    /**
     * Find all users
     * 
     * @return list of all users
     */
    List<User> findAll();
    
    /**
     * Find users by role
     * 
     * @param role the role to search for
     * @return list of users with the specified role
     */
    List<User> findByRole(String role);
    
    /**
     * Update user password
     * 
     * @param userId the user ID
     * @param passwordHash the new password hash
     * @return true if successful, false otherwise
     */
    boolean updatePassword(int userId, String passwordHash);
}
