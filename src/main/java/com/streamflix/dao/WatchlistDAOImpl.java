package com.streamflix.dao;

import com.streamflix.model.Content;
import com.streamflix.utils.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of the WatchlistDAO interface
 */
public class WatchlistDAOImpl implements WatchlistDAO {

    @Override
    public List<Content> findByProfileId(int profileId) {
        String sql = "SELECT c.* FROM content c " +
                    "JOIN watchlist w ON c.content_id = w.content_id " +
                    "WHERE w.profile_id = ? " +
                    "ORDER BY w.added_at DESC";
        List<Content> contentList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
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
    public boolean addToWatchlist(int profileId, int contentId) {
        String sql = "INSERT INTO watchlist (profile_id, content_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            // Check if already in watchlist
            if (isInWatchlist(profileId, contentId)) {
                return true; // Already in watchlist
            }
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            pstmt.setInt(2, contentId);
            
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
    public boolean removeFromWatchlist(int profileId, int contentId) {
        String sql = "DELETE FROM watchlist WHERE profile_id = ? AND content_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            pstmt.setInt(2, contentId);
            
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
    public boolean isInWatchlist(int profileId, int contentId) {
        String sql = "SELECT 1 FROM watchlist WHERE profile_id = ? AND content_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
            pstmt.setInt(2, contentId);
            rs = pstmt.executeQuery();
            
            result = rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
        
        return result;
    }

    @Override
    public int countWatchlistItems(int profileId) {
        String sql = "SELECT COUNT(*) FROM watchlist WHERE profile_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, profileId);
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