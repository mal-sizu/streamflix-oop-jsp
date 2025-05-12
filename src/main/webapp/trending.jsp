<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamFlix - Trending Content</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/partials/header.jsp" />
    
    <main class="container">
        <h1 class="page-title">Trending Now</h1>
        
        <section class="content-grid">
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
        </section>
        
        <div class="ajax-loader" id="trending-loader" style="display: none;">
            <i class="fas fa-spinner fa-spin"></i> Loading more content...
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script>
        // JavaScript for infinite scrolling or pagination could be added here
        document.addEventListener('DOMContentLoaded', function() {
            // Example code for loading more content when user scrolls to bottom
            window.addEventListener('scroll', function() {
                if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 500) {
                    // Load more content when user is near bottom of page
                    loadMoreTrendingContent();
                }
            });
            
            function loadMoreTrendingContent() {
                const loader = document.getElementById('trending-loader');
                const contentGrid = document.querySelector('.content-grid');
                
                // Don't load more if already loading
                if (loader.style.display === 'block') return;
                
                loader.style.display = 'block';
                
                // AJAX request to get more trending content
                fetch('${pageContext.request.contextPath}/recommendation/trending', {
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.trendingContent && data.trendingContent.length > 0) {
                        // Append new content to the grid
                        data.trendingContent.forEach(content => {
                            const contentCard = document.createElement('div');
                            contentCard.className = 'content-card';
                            contentCard.innerHTML = `
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
                            `;
                            contentGrid.appendChild(contentCard);
                        });
                    }
                    loader.style.display = 'none';
                })
                .catch(error => {
                    console.error('Error loading more content:', error);
                    loader.style.display = 'none';
                });
            }
        });
    </script>
</body>
</html>