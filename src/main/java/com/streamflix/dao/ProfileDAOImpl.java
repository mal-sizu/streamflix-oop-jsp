package com.streamflix.dao;

import com.streamflix.model.Profile;
import com.streamflix.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of the ProfileDAO interface
 */
public class ProfileDAOImpl implements ProfileDAO {

    @Override
    public Profile findById(int profileId) {
        String sql = "SELECT * FROM profiles WHERE profile_id = ?";
        Profile profile = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                profile = mapResultSetToProfile(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return profile;
    }

    @Override
    public List<Profile> findByUserId(int userId) {
        String sql = "SELECT * FROM profiles WHERE user_id = ?";
        List<Profile> profiles = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                profiles.add(mapResultSetToProfile(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return profiles;
    }

    @Override
    public Profile save(Profile profile) {
        String sql = "INSERT INTO profiles (user_id, profile_name, avatar_url, age_limit) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, profile.getUserId());
            pstmt.setString(2, profile.getProfileName());
            pstmt.setString(3, profile.getAvatarUrl());
            pstmt.setInt(4, profile.getAgeLimit());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating profile failed, no rows affected.");
            }
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                profile.setProfileId(rs.getInt(1));
            } else {
                throw new SQLException("Creating profile failed, no ID obtained.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return profile;
    }

    @Override
    public boolean update(Profile profile) {
        String sql = "UPDATE profiles SET profile_name = ?, avatar_url = ?, age_limit = ? WHERE profile_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, profile.getProfileName());
            pstmt.setString(2, profile.getAvatarUrl());
            pstmt.setInt(3, profile.getAgeLimit());
            pstmt.setInt(4, profile.getProfileId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return success;
    }

    @Override
    public boolean delete(int profileId) {
        String sql = "DELETE FROM profiles WHERE profile_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // Delete watchlist entries
            String deleteWatchlistSQL = "DELETE FROM watchlist WHERE profile_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteWatchlistSQL)) {
                deleteStmt.setInt(1, profileId);
                deleteStmt.executeUpdate();
            }
            
            // Delete ratings
            String deleteRatingsSQL = "DELETE FROM ratings WHERE profile_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteRatingsSQL)) {
                deleteStmt.setInt(1, profileId);
                deleteStmt.executeUpdate();
            }
            
            // Finally delete the profile
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
            // Commit transaction
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            // Rollback transaction on error
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException resetEx) {
                resetEx.printStackTrace();
            }
            closeResources(conn, pstmt, null);
        }
        
        return success;
    }

    @Override
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM profiles WHERE user_id = ?";
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return count;
    }
    
    /**
     * Maps a ResultSet to a Profile object
     * 
     * @param rs the ResultSet to map
     * @return a Profile object
     * @throws SQLException if an error occurs
     */
    private Profile mapResultSetToProfile(ResultSet rs) throws SQLException {
        Profile profile = new Profile();
        profile.setProfileId(rs.getInt("profile_id"));
        profile.setUserId(rs.getInt("user_id"));
        profile.setProfileName(rs.getString("profile_name"));
        profile.setAvatarUrl(rs.getString("avatar_url"));
        profile.setAgeLimit(rs.getInt("age_limit"));
        return profile;
    }
    
    /**
     * Close database resources
     * 
     * @param conn the Connection
     * @param stmt the Statement
     * @param rs the ResultSet
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DatabaseUtil.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
