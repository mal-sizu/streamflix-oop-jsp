package com.streamflix.dao;

import com.streamflix.model.Content;
import com.streamflix.model.Episode;
import com.streamflix.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of the ContentDAO interface
 */
public class ContentDAOImpl implements ContentDAO {

    @Override
    public Content findById(int contentId) {
        String sql = "SELECT * FROM content WHERE content_id = ?";
        Content content = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                content = mapResultSetToContent(rs);
                
                // Get average rating
                String ratingSQL = "SELECT AVG(score) as avg_rating FROM ratings WHERE content_id = ?";
                try (PreparedStatement ratingStmt = conn.prepareStatement(ratingSQL)) {
                    ratingStmt.setInt(1, contentId);
                    ResultSet ratingRs = ratingStmt.executeQuery();
                    if (ratingRs.next()) {
                        content.setAverageRating(ratingRs.getDouble("avg_rating"));
                    }
                }
                
                // Load episodes if this is a series
                if ("SERIES".equals(content.getType())) {
                    loadEpisodes(conn, content);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return content;
    }

    @Override
    public Content save(Content content) {
        String sql = "INSERT INTO content (type, title, description, genre, language, release_date, thumbnail_url, media_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, content.getType());
            pstmt.setString(2, content.getTitle());
            pstmt.setString(3, content.getDescription());
            pstmt.setString(4, content.getGenre());
            pstmt.setString(5, content.getLanguage());
            pstmt.setDate(6, content.getReleaseDate() != null ? new Date(content.getReleaseDate().getTime()) : null);
            pstmt.setString(7, content.getThumbnailUrl());
            pstmt.setString(8, content.getMediaUrl());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating content failed, no rows affected.");
            }
            
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                content.setContentId(rs.getInt(1));
                
                // If this is a series with episodes, save those too
                if ("SERIES".equals(content.getType()) && content.getEpisodes() != null) {
                    for (Episode episode : content.getEpisodes()) {
                        episode.setSeriesId(content.getContentId());
                        saveEpisode(conn, episode);
                    }
                }
            } else {
                throw new SQLException("Creating content failed, no ID obtained.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return content;
    }

    @Override
    public boolean update(Content content) {
        String sql = "UPDATE content SET type = ?, title = ?, description = ?, genre = ?, " +
                     "language = ?, release_date = ?, thumbnail_url = ?, media_url = ? " +
                     "WHERE content_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, content.getType());
            pstmt.setString(2, content.getTitle());
            pstmt.setString(3, content.getDescription());
            pstmt.setString(4, content.getGenre());
            pstmt.setString(5, content.getLanguage());
            pstmt.setDate(6, content.getReleaseDate() != null ? new Date(content.getReleaseDate().getTime()) : null);
            pstmt.setString(7, content.getThumbnailUrl());
            pstmt.setString(8, content.getMediaUrl());
            pstmt.setInt(9, content.getContentId());
            
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
            
            // Update episodes if this is a series with episodes
            if (success && "SERIES".equals(content.getType()) && content.getEpisodes() != null) {
                // First delete existing episodes (not ideal for production, but simpler for this example)
                String deleteEpisodesSQL = "DELETE FROM episodes WHERE series_id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteEpisodesSQL)) {
                    deleteStmt.setInt(1, content.getContentId());
                    deleteStmt.executeUpdate();
                }
                
                // Then save the new episodes
                for (Episode episode : content.getEpisodes()) {
                    episode.setSeriesId(content.getContentId());
                    saveEpisode(conn, episode);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        
        return success;
    }

    @Override
    public boolean delete(int contentId) {
        String sql = "DELETE FROM content WHERE content_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            // Start transaction
            conn.setAutoCommit(false);
            
            // Delete episodes if this is a series
            String deleteEpisodesSQL = "DELETE FROM episodes WHERE series_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteEpisodesSQL)) {
                deleteStmt.setInt(1, contentId);
                deleteStmt.executeUpdate();
            }
            
            // Delete ratings
            String deleteRatingsSQL = "DELETE FROM ratings WHERE content_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteRatingsSQL)) {
                deleteStmt.setInt(1, contentId);
                deleteStmt.executeUpdate();
            }
            
            // Delete watchlist entries
            String deleteWatchlistSQL = "DELETE FROM watchlist WHERE content_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteWatchlistSQL)) {
                deleteStmt.setInt(1, contentId);
                deleteStmt.executeUpdate();
            }
            
            // Finally delete the content
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, contentId);
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
    public List<Content> findAll() {
        String sql = "SELECT * FROM content";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public List<Content> findByType(String type) {
        String sql = "SELECT * FROM content WHERE type = ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public List<Content> findByGenre(String genre) {
        String sql = "SELECT * FROM content WHERE genre = ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, genre);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public List<Content> findByLanguage(String language) {
        String sql = "SELECT * FROM content WHERE language = ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, language);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public List<Content> search(String query) {
        String sql = "SELECT * FROM content WHERE title LIKE ? OR description LIKE ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + query + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public Content findWithEpisodes(int contentId) {
        Content content = findById(contentId);
        
        if (content != null && "SERIES".equals(content.getType())) {
            Connection conn = null;
            try {
                conn = DatabaseUtil.getConnection();
                loadEpisodes(conn, content);
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (conn != null) {
                    DatabaseUtil.closeConnection(conn);
                }
            }
        }
        
        return content;
    }

    @Override
    public List<Content> findRecent(int limit) {
        String sql = "SELECT * FROM content ORDER BY release_date DESC LIMIT ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }

    @Override
    public List<Content> findTopRated(int limit) {
        String sql = "SELECT c.*, AVG(r.score) as avg_rating " +
                     "FROM content c " +
                     "JOIN ratings r ON c.content_id = r.content_id " +
                     "GROUP BY c.content_id " +
                     "ORDER BY avg_rating DESC " +
                     "LIMIT ?";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Content content = mapResultSetToContent(rs);
                content.setAverageRating(rs.getDouble("avg_rating"));
                contentList.add(content);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return contentList;
    }
    
    /**
     * Maps a ResultSet to a Content object
     * 
     * @param rs the ResultSet to map
     * @return a Content object
     * @throws SQLException if an error occurs
     */
    private Content mapResultSetToContent(ResultSet rs) throws SQLException {
        Content content = new Content();
        content.setContentId(rs.getInt("content_id"));
        content.setType(rs.getString("type"));
        content.setTitle(rs.getString("title"));
        content.setDescription(rs.getString("description"));
        content.setGenre(rs.getString("genre"));
        content.setLanguage(rs.getString("language"));
        content.setReleaseDate(rs.getDate("release_date"));
        content.setThumbnailUrl(rs.getString("thumbnail_url"));
        content.setMediaUrl(rs.getString("media_url"));
        return content;
    }
    
    /**
     * Load episodes for a series
     * 
     * @param conn the database connection
     * @param content the content to load episodes for
     * @throws SQLException if an error occurs
     */
    private void loadEpisodes(Connection conn, Content content) throws SQLException {
        String sql = "SELECT * FROM episodes WHERE series_id = ? ORDER BY season, episode_number";
        List<Episode> episodes = new ArrayList<>();
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, content.getContentId());
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Episode episode = new Episode();
                episode.setEpisodeId(rs.getInt("episode_id"));
                episode.setSeriesId(rs.getInt("series_id"));
                episode.setSeason(rs.getInt("season"));
                episode.setEpisodeNumber(rs.getInt("episode_number"));
                episode.setTitle(rs.getString("title"));
                episode.setMediaUrl(rs.getString("media_url"));
                episodes.add(episode);
            }
        }
        
        content.setEpisodes(episodes);
    }
    
    /**
     * Save an episode
     * 
     * @param conn the database connection
     * @param episode the episode to save
     * @return the saved episode with ID populated
     * @throws SQLException if an error occurs
     */
    private Episode saveEpisode(Connection conn, Episode episode) throws SQLException {
        String sql = "INSERT INTO episodes (series_id, season, episode_number, title, media_url) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, episode.getSeriesId());
            pstmt.setInt(2, episode.getSeason());
            pstmt.setInt(3, episode.getEpisodeNumber());
            pstmt.setString(4, episode.getTitle());
            pstmt.setString(5, episode.getMediaUrl());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating episode failed, no rows affected.");
            }
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    episode.setEpisodeId(rs.getInt(1));
                } else {
                    throw new SQLException("Creating episode failed, no ID obtained.");
                }
            }
        }
        
        return episode;
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