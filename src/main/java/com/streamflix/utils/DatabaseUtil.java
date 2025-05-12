package com.streamflix.utils;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import org.apache.commons.dbcp2.BasicDataSource;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for database operations with connection pooling.
 * Supports both JNDI (production) and BasicDataSource (development fallback).
 */
public class DatabaseUtil {
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());
    private static DataSource dataSource;
    
    // Development configuration (fallback)
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/streamflix";
    private static final String DB_USERNAME = "cinephile";
    private static final String DB_PASSWORD = "streamflix2025!";  
      
    // Connection pool settings
    private static final int INITIAL_SIZE = 5;
    private static final int MAX_TOTAL = 20;
    private static final int MAX_IDLE = 10;
    private static final int MIN_IDLE = 5;
    private static final long MAX_WAIT_MILLIS = 10000;
    
    static {
        initializeDataSource();
    }

    private static void initializeDataSource() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/StreamFlixDB");
            LOGGER.info("Successfully initialized JNDI DataSource");
        } catch (NamingException e) {
            LOGGER.log(Level.SEVERE, "JNDI lookup failed. Initializing BasicDataSource", e);
            setupDevelopmentDataSource();
        }
    }

    private static void setupDevelopmentDataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName(DB_DRIVER);
        ds.setUrl(DB_URL);
        ds.setUsername(DB_USERNAME);
        ds.setPassword(DB_PASSWORD);
        
        // Pool configuration
        ds.setInitialSize(INITIAL_SIZE);
        ds.setMaxTotal(MAX_TOTAL);
        ds.setMaxIdle(MAX_IDLE);
        ds.setMinIdle(MIN_IDLE);
        ds.setMaxWaitMillis(MAX_WAIT_MILLIS);
        
        // Validation settings
        ds.setValidationQuery("SELECT 1");
        ds.setTestOnBorrow(true);
        ds.setTestWhileIdle(true);
        
        dataSource = ds;
        LOGGER.info("BasicDataSource configured successfully");
    }
    
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource not initialized");
        }
        Connection conn = dataSource.getConnection();
        if (conn == null) {
            throw new SQLException("Failed to obtain connection from pool");
        }
        return conn;
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection", e);
            }
        }
    }
    
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Connection test failed", e);
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    /**
     * Returns the configured DataSource instance.
     * This can be useful for operations that need direct access to the DataSource.
     * 
     * @return The configured DataSource instance
     */
    public static DataSource getDataSource() {
        if (dataSource == null) {
            initializeDataSource();
        }
        return dataSource;
    }

}