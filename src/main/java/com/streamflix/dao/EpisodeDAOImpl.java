package com.streamflix.dao;

import com.streamflix.model.Episode;
import com.streamflix.utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;

/**
 * Implementation of the EpisodeDAO interface
 */
public class EpisodeDAOImpl implements EpisodeDAO {
    
    private DataSource dataSource;
    
    public EpisodeDAOImpl() {
        this.dataSource = DatabaseUtil.getDataSource();
    }
    
    @Override
    public Episode findById(long episodeId) {
        String sql = "SELECT * FROM episodes WHERE episode_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, episodeId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEpisode(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Episode> findByContentId(long contentId) {
        List<Episode> episodes = new ArrayList<>();
        String sql = "SELECT * FROM episodes WHERE series_id = ? ORDER BY season, episode_number";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, contentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    episodes.add(mapResultSetToEpisode(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return episodes;
    }
    
    @Override
    public List<Episode> findByContentIdAndSeason(long contentId, int seasonNumber) {
        List<Episode> episodes = new ArrayList<>();
        String sql = "SELECT * FROM episodes WHERE series_id = ? AND season = ? ORDER BY episode_number";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, contentId);
            stmt.setInt(2, seasonNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    episodes.add(mapResultSetToEpisode(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return episodes;
    }
    
    @Override
    public Episode save(Episode episode) {
        String sql = "INSERT INTO episodes (series_id, title, season, episode_number, media_url) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setEpisodeParameters(stmt, episode);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        episode.setEpisodeId(generatedKeys.getInt(1));
                        return episode;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public boolean update(Episode episode) {
        String sql = "UPDATE episodes SET series_id = ?, title = ?, season = ?, " +
                     "episode_number = ?, media_url = ? WHERE episode_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setEpisodeParameters(stmt, episode);
            stmt.setInt(6, episode.getEpisodeId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public boolean delete(long episodeId) {
        String sql = "DELETE FROM episodes WHERE episode_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, episodeId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public int getEpisodeCount(long contentId) {
        String sql = "SELECT COUNT(*) FROM episodes WHERE series_id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, contentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    @Override
    public Episode getNextEpisodeToWatch(long contentId, long profileId) {
        String sql = "SELECT e.* FROM episodes e "
                + "LEFT JOIN viewing_history vh ON e.episode_id = vh.episode_id AND vh.profile_id = ? "
                + "WHERE e.series_id = ? AND vh.episode_id IS NULL "
                + "ORDER BY e.season, e.episode_number LIMIT 1";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, profileId);
            stmt.setLong(2, contentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEpisode(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    private Episode mapResultSetToEpisode(ResultSet rs) throws SQLException {
        Episode episode = new Episode();
        episode.setEpisodeId(rs.getInt("episode_id"));
        episode.setSeriesId(rs.getInt("series_id"));
        episode.setTitle(rs.getString("title"));
        episode.setSeason(rs.getInt("season"));
        episode.setEpisodeNumber(rs.getInt("episode_number"));
        episode.setMediaUrl(rs.getString("media_url"));
        return episode;
    }
    
    private void setEpisodeParameters(PreparedStatement stmt, Episode episode) throws SQLException {
        stmt.setInt(1, episode.getSeriesId());
        stmt.setString(2, episode.getTitle());
        stmt.setInt(3, episode.getSeason());
        stmt.setInt(4, episode.getEpisodeNumber());
        stmt.setString(5, episode.getMediaUrl());
    }
}