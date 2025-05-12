<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamFlix - Recommendations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/partials/header.jsp" />
    
    <main class="container">
        <h1 class="page-title">Recommended For You</h1>
        
        <!-- Personalized Recommendations Section -->
        <section class="content-section">
            <h2 class="section-title">Personalized For You</h2>
            <div class="content-slider">
                <c:if test="${empty personalizedRecommendations}">
                    <p class="no-content-message">No personalized recommendations available yet. Watch more content to get personalized recommendations!</p>
                </c:if>
                <c:forEach items="${personalizedRecommendations}" var="content">
                    <div class="content-card">
                        <div class="thumbnail">
                            <img src="${content.thumbnailUrl}" alt="${content.title}">
                            <div class="overlay">
                                <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="play-button">
                                    <i class="fas fa-play"></i>
                                </a>
                                <div class="content-info">
                                    <span class="content-type">${content.type}</span>
                                    <span class="content-genre">${content.genre}</span>
                                    <span class="content-rating">${content.rating}/10</span>
                                </div>
                            </div>
                        </div>
                        <h3 class="content-title">${content.title}</h3>
                    </div>
                </c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/recommendation/personalized" class="view-all-link">View All</a>
        </section>
        
        <!-- Trending Content Section -->
        <section class="content-section">
            <h2 class="section-title">Trending Now</h2>
            <div class="content-slider">
                <c:if test="${empty trendingContent}">
                    <p class="no-content-message">No trending content available at the moment.</p>
                </c:if>
                <c:forEach items="${trendingContent}" var="content">
                    <div class="content-card">
                        <div class="thumbnail">
                            <img src="${content.thumbnailUrl}" alt="${content.title}">
                            <div class="overlay">
                                <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="play-button">
                                    <i class="fas fa-play"></i>
                                </a>
                                <div class="content-info">
                                    <span class="content-type">${content.type}</span>
                                    <span class="content-genre">${content.genre}</span>
                                    <span class="content-rating">${content.rating}/10</span>
                                </div>
                            </div>
                        </div>
                        <h3 class="content-title">${content.title}</h3>
                    </div>
                </c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/recommendation/trending" class="view-all-link">View All</a>
        </section>
        
        <!-- New Releases Section -->
        <section class="content-section">
            <h2 class="section-title">New Releases</h2>
            <div class="content-slider">
                <c:if test="${empty newReleases}">
                    <p class="no-content-message">No new releases available at the moment.</p>
                </c:if>
                <c:forEach items="${newReleases}" var="content">
                    <div class="content-card">
                        <div class="thumbnail">
                            <img src="${content.thumbnailUrl}" alt="${content.title}">
                            <div class="overlay">
                                <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="play-button">
                                    <i class="fas fa-play"></i>
                                </a>
                                <div class="content-info">
                                    <span class="content-type">${content.type}</span>
                                    <span class="content-genre">${content.genre}</span>
                                    <span class="content-rating">${content.rating}/10</span>
                                </div>
                            </div>
                        </div>
                        <h3 class="content-title">${content.title}</h3>
                    </div>
                </c:forEach>
            </div>
        </section>
    </main>
    
    <jsp:include page="/WEB-INF/partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>