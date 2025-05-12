<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body class="auth-page">
    <header>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
            </a>
        </div>
    </header>

    <main>
        <div class="auth-container">
            <div class="auth-form-container">
                <h1>Forgot Password</h1>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <p>Enter your email address and we'll send you instructions to reset your password.</p>
                
                <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" class="auth-form">
                    <div class="form-group">
                        <input type="email" id="email" name="email" placeholder="Email" required>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary btn-block">Send Reset Link</button>
                    </div>
                </form>
                
                <div class="auth-footer">
                    <p>Remember your password? <a href="${pageContext.request.contextPath}/auth/login">Sign in</a>.</p>
                </div>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-content">
            <p>Questions? Call 1-800-STREAM-NOW</p>
            
            <div class="footer-links">
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/faq.jsp">FAQ</a>
                    <a href="${pageContext.request.contextPath}/privacy.jsp">Privacy</a>
                </div>
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/help.jsp">Help Center</a>
                    <a href="${pageContext.request.contextPath}/cookie-preferences.jsp">Cookie Preferences</a>
                </div>
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/terms.jsp">Terms of Use</a>
                    <a href="${pageContext.request.contextPath}/corporate-information.jsp">Corporate Information</a>
                </div>
            </div>
            
            <p class="copyright">&copy; 2023 StreamFlix, Inc.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/auth.js"></script>
</body>
</html>
