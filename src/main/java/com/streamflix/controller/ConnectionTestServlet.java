package com.streamflix.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.streamflix.utils.DatabaseUtil;

/**
 * Servlet to test and display database connection status.
 */
@WebServlet("/connection-test")
public class ConnectionTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Handles GET requests to test the database connection.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        boolean connectionSuccessful = false;
        String message = "";
        
        try {
            // Test the database connection
            Connection conn = DatabaseUtil.getConnection();
            
            if (conn != null && !conn.isClosed()) {
                connectionSuccessful = true;
                message = "Successfully connected to the StreamFlix database!";
                
                // Get database metadata for additional information
                String dbProductName = conn.getMetaData().getDatabaseProductName();
                String dbVersion = conn.getMetaData().getDatabaseProductVersion();
                message += "<br>Database: " + dbProductName + " " + dbVersion;
                
                // Close the connection
                DatabaseUtil.closeConnection(conn);
            } else {
                message = "Failed to connect to the database. Connection is null or closed.";
            }
        } catch (SQLException e) {
            message = "Database connection error: " + e.getMessage();
        }
        
        // Set attributes for the JSP
        request.setAttribute("connectionSuccessful", connectionSuccessful);
        request.setAttribute("message", message);
        
        // Forward to the JSP page
        request.getRequestDispatcher("/connection-status.jsp").forward(request, response);
    }
}