<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <div class="search-results-container">
                <div class="search-header">
                    <h1 class="page-title">
                        <c:if test="${not empty query}">
                            Search Results: "${query}"
                        </c:if>
                        <c:if test="${empty query}">
                            Browse Content
                        </c:if>
                    </h1>
                    
                    <div class="search-stats">
                        <c:if test="${not empty results}">
                            ${results.size()} results
                        </c:if>
                        <c:if test="${empty results}">
                            No results found
                        </c:if>
                    </div>
                </div>
                
                <div class="search-filters">
                    <form action="${pageContext.request.contextPath}/search/results" method="get" class="filters-form">
                        <c:if test="${not empty query}">
                            <input type="hidden" name="query" value="${query}">
                        </c:if>
                        
                        <div class="filter-group">
                            <label for="typeFilter">Type:</label>
                            <select name="type" id="typeFilter">
                                <option value="">All Types</option>
                                <option value="MOVIE" ${param.type eq 'MOVIE' ? 'selected' : ''}>Movies</option>
                                <option value="SERIES" ${param.type eq 'SERIES' ? 'selected' : ''}>TV Series</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="genreFilter">Genre:</label>
                            <select name="genre" id="genreFilter">
                                <option value="">All Genres</option>
                                <option value="Action" ${param.genre eq 'Action' ? 'selected' : ''}>Action</option>
                                <option value="Adventure" ${param.genre eq 'Adventure' ? 'selected' : ''}>Adventure</option>
                                <option value="Comedy" ${param.genre eq 'Comedy' ? 'selected' : ''}>Comedy</option>
                                <option value="Drama" ${param.genre eq 'Drama' ? 'selected' : ''}>Drama</option>
                                <option value="Fantasy" ${param.genre eq 'Fantasy' ? 'selected' : ''}>Fantasy</option>
                                <option value="Horror" ${param.genre eq 'Horror' ? 'selected' : ''}>Horror</option>
                                <option value="Mystery" ${param.genre eq 'Mystery' ? 'selected' : ''}>Mystery</option>
                                <option value="Romance" ${param.genre eq 'Romance' ? 'selected' : ''}>Romance</option>
                                <option value="Sci-Fi" ${param.genre eq 'Sci-Fi' ? 'selected' : ''}>Sci-Fi</option>
                                <option value="Thriller" ${param.genre eq 'Thriller' ? 'selected' : ''}>Thriller</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="languageFilter">Language:</label>
                            <select name="language" id="languageFilter">
                                <option value="">All Languages</option>
                                <option value="English" ${param.language eq 'English' ? 'selected' : ''}>English</option>
                                <option value="Spanish" ${param.language eq 'Spanish' ? 'selected' : ''}>Spanish</option>
                                <option value="French" ${param.language eq 'French' ? 'selected' : ''}>French</option>
                                <option value="German" ${param.language eq 'German' ? 'selected' : ''}>German</option>
                                <option value="Japanese" ${param.language eq 'Japanese' ? 'selected' : ''}>Japanese</option>
                                <option value="Korean" ${param.language eq 'Korean' ? 'selected' : ''}>Korean</option>
                                <option value="Chinese" ${param.language eq 'Chinese' ? 'selected' : ''}>Chinese</option>
                                <option value="Hindi" ${param.language eq 'Hindi' ? 'selected' : ''}>Hindi</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="sortFilter">Sort By:</label>
                            <select name="sort" id="sortFilter">
                                <option value="relevance" ${param.sort eq 'relevance' || empty param.sort ? 'selected' : ''}>Relevance</option>
                                <option value="date" ${param.sort eq 'date' ? 'selected' : ''}>Release Date</option>
                                <option value="rating" ${param.sort eq 'rating' ? 'selected' : ''}>Rating</option>
                                <option value="title" ${param.sort eq 'title' ? 'selected' : ''}>Title</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn-apply-filters">Apply Filters</button>
                    </form>
                </div>
                
                <c:if test="${empty results}">
                    <div class="no-results">
                        <div class="no-results-message">
                            <i class="fas fa-search"></i>
                            <h2>No results found</h2>
                            <p>
                                <c:if test="${not empty query}">
                                    We couldn't find any matches for "${query}".
                                </c:if>
                                <c:if test="${empty query}">
                                    No content matches the selected filters.
                                </c:if>
                            </p>
                            <div class="no-results-suggestions">
                                <h3>Suggestions:</h3>
                                <ul>
                                    <li>Try different keywords</li>
                                    <li>Check your spelling</li>
                                    <li>Try more general terms</li>
                                    <li>Try fewer filters</li>
                                </ul>
                            </div>
                            <a href="${pageContext.request.contextPath}/search/form" class="btn btn-primary">New Search</a>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty results}">
                    <div class="results-grid">
                        <c:forEach var="content" items="${results}">
                            <div class="content-card">
                                <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}">
                                    <div class="content-thumbnail">
                                        <img src="${content.thumbnailUrl}" alt="${content.title}">
                                        <div class="content-overlay">
                                            <div class="content-type">${content.type}</div>
                                            <div class="content-actions">
                                                <button class="btn-play" onclick="playContent(${content.contentId})">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn-watchlist" onclick="toggleWatchlist(${content.contentId})">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="content-info">
                                        <h3 class="content-title">${content.title}</h3>
                                        <div class="content-meta">
                                            <span class="content-year">
                                                <fmt:formatDate value="${content.releaseDate}" pattern="yyyy" />
                                            </span>
                                            <span class="content-genre">${content.genre}</span>
                                        </div>
                                        <div class="content-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fa${i <= content.averageRating ? 's' : 'r'} fa-star"></i>
                                            </c:forEach>
                                            <span class="rating-value">${content.averageRating}</span>
                                        </div>
                                        <p class="content-description">
                                            ${content.description.length() > 100 ? content.description.substring(0, 100).concat('...') : content.description}
                                        </p>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script>
        function playContent(contentId) {
            window.location.href = "${pageContext.request.contextPath}/player/play?id=" + contentId;
            
            // Prevent default link click behavior
            event.preventDefault();
            event.stopPropagation();
        }
        
        function toggleWatchlist(contentId) {
            $.ajax({
                url: "${pageContext.request.contextPath}/watchlist/check",
                data: { id: contentId },
                dataType: "json",
                success: function(data) {
                    if (data.inWatchlist) {
                        // Remove from watchlist
                        $.ajax({
                            url: "${pageContext.request.contextPath}/watchlist/remove",
                            data: { id: contentId },
                            dataType: "json",
                            success: function(response) {
                                if (response.success) {
                                    // Update UI
                                    $(`.btn-watchlist[onclick="toggleWatchlist(${contentId})"] i`)
                                        .removeClass("fa-check")
                                        .addClass("fa-plus");
                                }
                            }
                        });
                    } else {
                        // Add to watchlist
                        $.ajax({
                            url: "${pageContext.request.contextPath}/watchlist/add",
                            data: { id: contentId },
                            dataType: "json",
                            success: function(response) {
                                if (response.success) {
                                    // Update UI
                                    $(`.btn-watchlist[onclick="toggleWatchlist(${contentId})"] i`)
                                        .removeClass("fa-plus")
                                        .addClass("fa-check");
                                }
                            }
                        });
                    }
                }
            });
            
            // Prevent default link click behavior
            event.preventDefault();
            event.stopPropagation();
        }
    </script>
</body>
</html>
