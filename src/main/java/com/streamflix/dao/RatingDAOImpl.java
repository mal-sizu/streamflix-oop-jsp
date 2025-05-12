package com.streamflix.dao;

import com.streamflix.model.Profile;
import com.streamflix.model.Rating;
import com.streamflix.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Implementation of the RatingDAO interface
 */
public class RatingDAOImpl implements RatingDAO {

    @Override
    public Rating findById(int ratingId) {
        String sql = "SELECT * FROM ratings WHERE rating_id = ?";
        Rating rating = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, ratingId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                rating = mapResultSetToRating(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return rating;
    }

    @Override
    public List<Rating> findByContentId(int contentId) {
        String sql = "SELECT * FROM ratings WHERE content_id = ? ORDER BY created_at DESC";
        List<Rating> ratings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ratings.add(mapResultSetToRating(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return ratings;
    }

    @Override
    public List<Rating> findByContentIdWithProfiles(int contentId) {
        String sql = "SELECT r.*, p.profile_id, p.profile_name, p.avatar_url " +
                     "FROM ratings r " +
                     "JOIN profiles p ON r.profile_id = p.profile_id " +
                     "WHERE r.content_id = ? " +
                     "ORDER BY r.created_at DESC";
        List<Rating> ratings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                
                // Add profile data
                Profile profile = new Profile();
                profile.setProfileId(rs.getInt("profile_id"));
                profile.setProfileName(rs.getString("profile_name"));
                profile.setAvatarUrl(rs.getString("avatar_url"));
                
                rating.setProfile(profile);
                
                ratings.add(rating);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return ratings;
    }

    @Override
    public List<Rating> findByContentIdWithProfiles(int contentId, int skip, int limit) {
        String sql = "SELECT r.*, p.profile_id, p.profile_name, p.avatar_url " +
                     "FROM ratings r " +
                     "JOIN profiles p ON r.profile_id = p.profile_id " +
                     "WHERE r.content_id = ? " +
                     "ORDER BY r.created_at DESC " +
                     "LIMIT ? OFFSET ?";
        List<Rating> ratings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            pstmt.setInt(2, limit);
            pstmt.setInt(3, skip);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Rating rating = mapResultSetToRating(rs);
                
                // Add profile data
                Profile profile = new Profile();
                profile.setProfileId(rs.getInt("profile_id"));
                profile.setProfileName(rs.getString("profile_name"));
                profile.setAvatarUrl(rs.getString("avatar_url"));
                
                rating.setProfile(profile);
                
                ratings.add(rating);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return ratings;
    }

    @Override
    public List<Rating> findByProfileId(int profileId) {
        String sql = "SELECT * FROM ratings WHERE profile_id = ? ORDER BY created_at DESC";
        List<Rating> ratings = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ratings.add(mapResultSetToRating(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return ratings;
    }
    
    @Override
    public Rating findByProfileAndContent(int profileId, int contentId) {
        String sql = "SELECT * FROM ratings WHERE profile_id = ? AND content_id = ?";
        Rating rating = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            pstmt.setInt(2, contentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                rating = mapResultSetToRating(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return rating;
    }

    @Override
    public Rating save(Rating rating) {
        String sql = "INSERT INTO ratings (profile_id, content_id, score, review_text) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, rating.getProfileId());
            pstmt.setInt(2, rating.getContentId());
            pstmt.setInt(3, rating.getScore());
            pstmt.setString(4, rating.getReviewText());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating rating failed, no rows affected.");
            }
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                rating.setRatingId(rs.getInt(1));
            } else {
                throw new SQLException("Creating rating failed, no ID obtained.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return rating;
    }

    @Override
    public boolean update(Rating rating) {
        String sql = "UPDATE ratings SET score = ?, review_text = ? WHERE rating_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, rating.getScore());
            pstmt.setString(2, rating.getReviewText());
            pstmt.setInt(3, rating.getRatingId());
            
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
    public boolean delete(int ratingId) {
        String sql = "DELETE FROM ratings WHERE rating_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, ratingId);
            
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
    public double getAverageRating(int contentId) {
        String sql = "SELECT AVG(score) as avg_rating FROM ratings WHERE content_id = ?";
        double averageRating = 0.0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                averageRating = rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return averageRating;
    }

    @Override
    public Map<Integer, Integer> getRatingDistribution(int contentId) {
        String sql = "SELECT score, COUNT(*) as count FROM ratings WHERE content_id = ? GROUP BY score ORDER BY score";
        Map<Integer, Integer> distribution = new HashMap<>();
        
        // Initialize with 0 counts for all scores
        for (int i = 1; i <= 5; i++) {
            distribution.put(i, 0);
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int score = rs.getInt("score");
                int count = rs.getInt("count");
                distribution.put(score, count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return distribution;
    }
    
    /**
     * Maps a ResultSet to a Rating object
     * 
     * @param rs the ResultSet to map
     * @return a Rating object
     * @throws SQLException if an error occurs
     */
    private Rating mapResultSetToRating(ResultSet rs) throws SQLException {
        Rating rating = new Rating();
        rating.setRatingId(rs.getInt("rating_id"));
        rating.setProfileId(rs.getInt("profile_id"));
        rating.setContentId(rs.getInt("content_id"));
        rating.setScore(rs.getInt("score"));
        rating.setReviewText(rs.getString("review_text"));
        rating.setCreatedAt(rs.getTimestamp("created_at"));
        return rating;
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
