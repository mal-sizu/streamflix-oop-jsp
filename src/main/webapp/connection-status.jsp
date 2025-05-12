<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Connection Status - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .connection-status {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .connection-success {
            background-color: #e8f5e9;
            border-left: 5px solid #4caf50;
        }
        
        .connection-error {
            background-color: #ffebee;
            border-left: 5px solid #f44336;
        }
        
        .status-icon {
            font-size: 48px;
            margin-bottom: 20px;
        }
        
        .success-icon {
            color: #4caf50;
        }
        
        .error-icon {
            color: #f44336;
        }
        
        .connection-details {
            margin-top: 20px;
            padding: 15px;
            background-color: rgba(0, 0, 0, 0.05);
            border-radius: 4px;
        }
        
        .action-buttons {
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-right: 10px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
        }
        
        .btn-primary {
            background-color: #e50914;
            color: white;
            border: none;
        }
        
        .btn-secondary {
            background-color: #333;
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
        </div>
    </header>
    
    <main>
        <div class="container">
            <c:choose>
                <c:when test="${connectionSuccessful}">
                    <div class="connection-status connection-success">
                        <div class="status-icon success-icon">
                            <i class="fas fa-check-circle"></i> ✓
                        </div>
                        <h1>Connection Successful</h1>
                        <p>${message}</p>
                        
                        <div class="connection-details">
                            <h3>Database Connection Information</h3>
                            <p>The application has successfully established a connection to the SQL Server database.</p>
                            <p>Your StreamFlix application is properly configured and ready to use.</p>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Go to Homepage</a>
                            <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" class="btn btn-secondary">Admin Dashboard</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="connection-status connection-error">
                        <div class="status-icon error-icon">
                            <i class="fas fa-times-circle"></i> ✗
                        </div>
                        <h1>Connection Failed</h1>
                        <p>${message}</p>
                        
                        <div class="connection-details">
                            <h3>Troubleshooting Steps</h3>
                            <ol>
                                <li>Verify that SQL Server is running on your machine</li>
                                <li>Check the connection string in context.xml</li>
                                <li>Ensure the database name, username, and password are correct</li>
                                <li>Confirm that the SQL Server port (default 1433) is accessible</li>
                                <li>Make sure the JDBC driver is properly included in your project</li>
                            </ol>
                        </div>
                        
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/connection-test" class="btn btn-primary">Try Again</a>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Go to Homepage</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <footer>
        <div class="footer-content">
            <p>&copy; 2023 StreamFlix. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>