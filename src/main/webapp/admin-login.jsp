<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-page">
    <div class="admin-login-container">
        <div class="admin-login-card">
            <div class="admin-login-header">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="StreamFlix Logo" class="admin-logo">
                <h1>Admin Portal</h1>
            </div>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/login" method="post" class="admin-login-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required class="form-control">
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </div>
            </form>
            
            <div class="admin-login-footer">
                <a href="${pageContext.request.contextPath}/index.jsp">Return to StreamFlix</a>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>