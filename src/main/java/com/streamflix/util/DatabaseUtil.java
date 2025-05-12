package com.streamflix.util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for database operations.
 * Provides connection pooling for efficient database access.
 */
public class DatabaseUtil {
    
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());
    private static DataSource dataSource;
    
    static {
        try {
            // Initialize the DataSource from JNDI
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/StreamFlixDB");
            LOGGER.info("Database connection pool initialized successfully");
        } catch (NamingException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize database connection pool", e);
        }
    }
    
    /**
     * Gets a connection from the connection pool.
     * 
     * @return A database connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is not initialized. Check server configuration.");
        }
        Connection conn = dataSource.getConnection();
        if (conn == null) {
            throw new SQLException("Failed to obtain database connection from pool.");
        }
        return conn;
    }
    
    /**
     * Closes a database connection safely.
     * 
     * @param connection The connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database connection", e);
            }
        }
    }
    
    /**
     * Checks if the database connection is available.
     * 
     * @return true if connection can be established, false otherwise
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection test failed", e);
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}