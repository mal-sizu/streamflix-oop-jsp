<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <style>
        .error-container {
            min-height: 80vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 2rem;
        }
        
        .error-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        .error-title {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        
        .error-message {
            font-size: 1.25rem;
            color: var(--text-secondary);
            margin-bottom: 2rem;
            max-width: 600px;
        }
        
        .error-code {
            background-color: var(--surface-color);
            padding: 0.5rem 1rem;
            border-radius: 4px;
            margin-bottom: 2rem;
            font-family: monospace;
        }
        
        .error-actions {
            display: flex;
            gap: 1rem;
        }
    </style>
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            
            <h1 class="error-title">
                <c:choose>
                    <c:when test="${not empty errorMessage}">
                        ${errorMessage}
                    </c:when>
                    <c:when test="${not empty pageContext.exception}">
                        ${pageContext.exception.message}
                    </c:when>
                    <c:when test="${not empty requestScope['javax.servlet.error.status_code']}">
                        Error ${requestScope['javax.servlet.error.status_code']}
                    </c:when>
                    <c:otherwise>
                        Something went wrong
                    </c:otherwise>
                </c:choose>
            </h1>
            
            <p class="error-message">
                <c:choose>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 404}">
                        The page you're looking for doesn't exist. It might have been moved or removed.
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 500}">
                        Our servers are experiencing issues. Please try again later.
                    </c:when>
                    <c:when test="${requestScope['javax.servlet.error.status_code'] == 403}">
                        You don't have permission to access this page.
                    </c:when>
                    <c:otherwise>
                        We're sorry, but something went wrong. Please try again or contact support if the problem persists.
                    </c:otherwise>
                </c:choose>
            </p>
            
            <c:if test="${not empty pageContext.exception and not empty sessionScope.user and sessionScope.user.role eq 'ADMIN'}">
                <div class="error-code">
                    <p>Error details (admins only):</p>
                    <p>${pageContext.exception.class.name}</p>
                    <p>${pageContext.exception.message}</p>
                </div>
            </c:if>
            
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">Go to Home</a>
                <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
                <a href="${pageContext.request.contextPath}/help.jsp" class="btn btn-secondary">Get Help</a>
            </div>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>
