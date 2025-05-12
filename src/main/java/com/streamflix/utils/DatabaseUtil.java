package com.streamflix.utils;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import org.apache.commons.dbcp2.BasicDataSource;

/**
 * Utility class for managing database connections
 */
public class DatabaseUtil {
    private static DataSource dataSource;
    
    // SQL Server Database Configuration
    private static final String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=StreamFlixDB;encrypt=true;trustServerCertificate=true";
    private static final String DB_USERNAME = "sa";
    private static final String DB_PASSWORD = "YourStrongPassword";
    
    // Connection Pool Configuration
    private static final int INITIAL_SIZE = 5;
    private static final int MAX_TOTAL = 20;
    private static final int MAX_IDLE = 10;
    private static final int MIN_IDLE = 5;
    private static final long MAX_WAIT_MILLIS = 10000;
    
    static {
        try {
            // Try to get DataSource from JNDI first (for production)
            try {
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:comp/env");
                dataSource = (DataSource) envContext.lookup("jdbc/streamflix");
                System.out.println("Using JNDI DataSource");
            } catch (NamingException e) {
                // If JNDI lookup fails, create a connection pool manually (for development)
                System.out.println("JNDI lookup failed. Setting up BasicDataSource: " + e.getMessage());
                setupDataSource();
            }
        } catch (Exception e) {
            System.err.println("Error initializing database connection: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }
    
    /**
     * Set up a basic connection pool if JNDI is not configured
     */
    private static void setupDataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName(DB_DRIVER);
        ds.setUrl(DB_URL);
        ds.setUsername(DB_USERNAME);
        ds.setPassword(DB_PASSWORD);
        
        // Connection pool settings
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
        System.out.println("BasicDataSource set up successfully");
    }
    
    /**
     * Get a connection from the pool
     * 
     * @return a database connection
     * @throws SQLException if a connection cannot be obtained
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is not initialized");
        }
        return dataSource.getConnection();
    }
    
    /**
     * Close connection and return it to the pool
     * 
     * @param conn the connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}