package com.streamflix.util;

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
    
    static {
        try {
            // Try to get DataSource from JNDI first
            try {
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:comp/env");
                dataSource = (DataSource) envContext.lookup("jdbc/streamflix");
            } catch (NamingException e) {
                // If JNDI lookup fails, create a connection pool manually
                setupDataSource();
            }
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }
    
    /**
     * Set up a basic connection pool if JNDI is not configured
     */
    private static void setupDataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/streamflix?useSSL=false&serverTimezone=UTC");
        ds.setUsername("root"); // Change according to your MySQL setup
        ds.setPassword("password"); // Change according to your MySQL setup
        
        // Connection pool settings
        ds.setInitialSize(5);
        ds.setMaxTotal(20);
        ds.setMaxIdle(10);
        ds.setMinIdle(5);
        ds.setMaxWaitMillis(10000);
        
        dataSource = ds;
    }
    
    /**
     * Get a connection from the pool
     * 
     * @return a database connection
     * @throws SQLException if a connection cannot be obtained
     */
    public static Connection getConnection() throws SQLException {
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
                // Log exception
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}
