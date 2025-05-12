package com.streamflix.dao;

import com.streamflix.model.Content;
import com.streamflix.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Implementation of the RecommendationDAO interface
 */
public class RecommendationDAOImpl implements RecommendationDAO {
    
    private static final Logger LOGGER = Logger.getLogger(RecommendationDAOImpl.class.getName());
    
    /**
     * Helper method to map a ResultSet to a Content object
     * 
     * @param rs the ResultSet containing content data
     * @return the mapped Content object
     * @throws SQLException if a database error occurs
     */
    private Content mapResultSetToContent(ResultSet rs) throws SQLException {
        Content content = new Content();
        content.setContentId(rs.getInt("content_id"));
        content.setTitle(rs.getString("title"));
        content.setDescription(rs.getString("description"));
        content.setType(rs.getString("type"));
        content.setGenre(rs.getString("genre"));
        content.setLanguage(rs.getString("language"));
        content.setReleaseDate(rs.getDate("release_date"));
        content.setThumbnailUrl(rs.getString("thumbnail_url"));
        content.setMediaUrl(rs.getString("media_url"));
        content.setAverageRating(rs.getDouble("average_rating"));
        return content;
    }
    
    @Override
    public List<Content> getPersonalizedRecommendations(int userId, int limit) {
        List<Content> recommendations = new ArrayList<>();
        String sql = "SELECT c.* FROM content c " +
                     "JOIN (" +
                     "  SELECT content.genre, COUNT(*) as genre_count " +
                     "  FROM viewing_history " +
                     "  JOIN content ON viewing_history.content_id = content.content_id " +
                     "  WHERE viewing_history.profile_id IN (SELECT profile_id FROM profiles WHERE user_id = ?) " +
                     "  GROUP BY content.genre " +
                     "  ORDER BY genre_count DESC " +
                     "  LIMIT 3" +
                     ") AS top_genres ON c.genre = top_genres.genre " +
                     "LEFT JOIN viewing_history vh ON c.content_id = vh.content_id AND vh.profile_id IN (SELECT profile_id FROM profiles WHERE user_id = ?) " +
                     "WHERE vh.content_id IS NULL " +
                     "ORDER BY RAND() " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    recommendations.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting personalized recommendations", e);
        }
        
        return recommendations;
    }
    
    @Override
    public List<Content> getSimilarContent(int contentId, int limit) {
        List<Content> similarContent = new ArrayList<>();
        String sql = "SELECT c.* FROM content c " +
                     "JOIN content source ON c.genre = source.genre " +
                     "WHERE source.content_id = ? AND c.content_id != ? " +
                     "ORDER BY c.release_date DESC, c.average_rating DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, contentId);
            pstmt.setInt(2, contentId);
            pstmt.setInt(3, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    similarContent.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting similar content", e);
        }
        
        return similarContent;
    }
    
    @Override
    public List<Content> getTrendingContent(int limit) {
        List<Content> trendingContent = new ArrayList<>();
        String sql = "SELECT c.* FROM content c " +
                     "JOIN (" +
                     "  SELECT content_id, COUNT(*) as view_count " +
                     "  FROM viewing_history " +
                     "  WHERE viewed_date >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                     "  GROUP BY content_id " +
                     "  ORDER BY view_count DESC " +
                     "  LIMIT ?" +
                     ") AS trending ON c.content_id = trending.content_id " +
                     "ORDER BY trending.view_count DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    trendingContent.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting trending content", e);
        }
        
        return trendingContent;
    }
    
    @Override
    public List<Content> getRecommendationsByGenre(String genre, int limit) {
        List<Content> genreRecommendations = new ArrayList<>();
        String sql = "SELECT * FROM content WHERE genre = ? ORDER BY release_date DESC, average_rating DESC LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, genre);
            pstmt.setInt(2, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    genreRecommendations.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recommendations by genre", e);
        }
        
        return genreRecommendations;
    }
    
    @Override
    public List<Content> getRecommendationsByRatings(int userId, int limit) {
        List<Content> ratingBasedRecommendations = new ArrayList<>();
        String sql = "SELECT c.* FROM content c " +
                     "JOIN ratings r ON c.content_id = r.content_id " +
                     "WHERE r.user_id = ? AND r.score >= 4 " +
                     "JOIN content rec ON c.genre = rec.genre " +
                     "LEFT JOIN viewing_history vh ON rec.content_id = vh.content_id AND vh.profile_id IN (SELECT profile_id FROM profiles WHERE user_id = ?) " +
                     "WHERE vh.content_id IS NULL AND rec.content_id != r.content_id " +
                     "ORDER BY rec.average_rating DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ratingBasedRecommendations.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recommendations by ratings", e);
        }
        
        return ratingBasedRecommendations;
    }
    
    @Override
    public List<Content> getNewReleases(int limit) {
        List<Content> newReleases = new ArrayList<>();
        String sql = "SELECT * FROM content WHERE release_date >= DATE_SUB(NOW(), INTERVAL 30 DAY) ORDER BY release_date DESC LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    newReleases.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting new releases", e);
        }
        
        return newReleases;
    }
    
    @Override
    public List<Content> getRecommendationsFromSimilarUsers(int userId, int limit) {
        List<Content> similarUserRecommendations = new ArrayList<>();
        String sql = "SELECT c.* FROM content c " +
                     "JOIN viewing_history vh ON c.content_id = vh.content_id " +
                     "JOIN profiles p ON vh.profile_id = p.profile_id " +
                     "JOIN users u ON p.user_id = u.user_id " +
                     "WHERE u.user_id IN (" +
                     "  SELECT DISTINCT u2.user_id FROM users u2 " +
                     "  JOIN profiles p2 ON u2.user_id = p2.user_id " +
                     "  JOIN viewing_history vh2 ON p2.profile_id = vh2.profile_id " +
                     "  JOIN viewing_history vh3 ON vh2.content_id = vh3.content_id " +
                     "  JOIN profiles p3 ON vh3.profile_id = p3.profile_id " +
                     "  WHERE p3.user_id = ? AND u2.user_id != ? " +
                     "  GROUP BY u2.user_id " +
                     "  HAVING COUNT(DISTINCT vh2.content_id) >= 3" +
                     ") " +
                     "AND c.content_id NOT IN (" +
                     "  SELECT DISTINCT vh4.content_id FROM viewing_history vh4 " +
                     "  JOIN profiles p4 ON vh4.profile_id = p4.profile_id " +
                     "  WHERE p4.user_id = ?" +
                     ") " +
                     "GROUP BY c.content_id " +
                     "ORDER BY COUNT(DISTINCT u.user_id) DESC " +
                     "LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, userId);
            pstmt.setInt(4, limit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    similarUserRecommendations.add(mapResultSetToContent(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recommendations from similar users", e);
        }
        
        return similarUserRecommendations;
    }
}