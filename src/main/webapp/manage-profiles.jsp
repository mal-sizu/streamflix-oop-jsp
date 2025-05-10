<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamFlix - Manage Profiles</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profiles.css">
</head>
<body class="profiles-page">
    <header>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
            </a>
        </div>
    </header>

    <main>
        <div class="profiles-container">
            <h1>
                <c:if test="${manageMode}">
                    Manage Profiles
                </c:if>
                <c:if test="${empty manageMode}">
                    Who's watching?
                </c:if>
            </h1>
            
            <div class="profiles-list">
                <c:forEach var="profile" items="${profiles}">
                    <div class="profile-item">
                        <c:if test="${manageMode}">
                            <a href="${pageContext.request.contextPath}/profile/edit?id=${profile.profileId}" class="profile-edit-link">
                                <div class="profile-avatar">
                                    <img src="${profile.avatarUrl}" alt="${profile.profileName}">
                                    <div class="profile-edit-overlay">
                                        <i class="fas fa-pencil-alt"></i>
                                    </div>
                                </div>
                                <div class="profile-name">${profile.profileName}</div>
                            </a>
                        </c:if>
                        
                        <c:if test="${empty manageMode}">
                            <a href="${pageContext.request.contextPath}/profile/switch?id=${profile.profileId}" class="profile-select-link">
                                <div class="profile-avatar">
                                    <img src="${profile.avatarUrl}" alt="${profile.profileName}">
                                </div>
                                <div class="profile-name">${profile.profileName}</div>
                            </a>
                        </c:if>
                    </div>
                </c:forEach>
                
                <c:if test="${profiles.size() < 5}">
                    <div class="profile-item add-profile">
                        <a href="${pageContext.request.contextPath}/profile/add" class="profile-add-link">
                            <div class="profile-avatar">
                                <div class="profile-add-icon">
                                    <i class="fas fa-plus"></i>
                                </div>
                            </div>
                            <div class="profile-name">Add Profile</div>
                        </a>
                    </div>
                </c:if>
            </div>
            
            <div class="profiles-actions">
                <c:if test="${manageMode}">
                    <a href="${pageContext.request.contextPath}/profile/select" class="btn btn-secondary">Done</a>
                </c:if>
                <c:if test="${empty manageMode}">
                    <a href="${pageContext.request.contextPath}/profile/manage" class="btn btn-secondary">Manage Profiles</a>
                </c:if>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-content minimal">
            <p class="copyright">&copy; 2023 StreamFlix, Inc.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/profiles.js"></script>
</body>
</html>
