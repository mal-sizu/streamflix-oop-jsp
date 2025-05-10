<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamFlix - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="hero-banner">
            <div class="hero-content">
                <h1 class="hero-title">Welcome to StreamFlix</h1>
                <p class="hero-description">Discover the best movies and TV shows for your entertainment</p>
                <div class="hero-actions">
                    <a href="#trending" class="btn btn-primary">Explore Trending</a>
                </div>
            </div>
        </div>

        <!-- Featured Content Slider -->
        <section class="content-section">
            <h2 class="section-title">Featured</h2>
            <div class="content-slider">
                <c:forEach var="content" items="${featuredContent}">
                    <div class="content-card">
                        <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}">
                            <div class="content-thumbnail">
                                <img src="${content.thumbnailUrl}" alt="${content.title}">
                                <div class="content-overlay">
                                    <div class="content-type">${content.type}</div>
                                    <div class="content-actions">
                                        <button class="btn-play" onclick="playContent(${content.contentId})">
                                            <i class="fa fa-play"></i>
                                        </button>
                                        <button class="btn-watchlist" onclick="toggleWatchlist(${content.contentId})">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="content-info">
                                <h3 class="content-title">${content.title}</h3>
                                <div class="content-meta">
                                    <span class="content-year">${content.releaseYear}</span>
                                    <span class="content-genre">${content.genre}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Trending Content -->
        <section id="trending" class="content-section">
            <h2 class="section-title">Trending Now</h2>
            <div class="content-slider">
                <c:forEach var="content" items="${trendingContent}">
                    <div class="content-card">
                        <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}">
                            <div class="content-thumbnail">
                                <img src="${content.thumbnailUrl}" alt="${content.title}">
                                <div class="content-overlay">
                                    <div class="content-type">${content.type}</div>
                                    <div class="content-actions">
                                        <button class="btn-play" onclick="playContent(${content.contentId})">
                                            <i class="fa fa-play"></i>
                                        </button>
                                        <button class="btn-watchlist" onclick="toggleWatchlist(${content.contentId})">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="content-info">
                                <h3 class="content-title">${content.title}</h3>
                                <div class="content-meta">
                                    <span class="content-year">${content.releaseYear}</span>
                                    <span class="content-genre">${content.genre}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Movies -->
        <section class="content-section">
            <h2 class="section-title">Movies</h2>
            <div class="content-slider">
                <c:forEach var="movie" items="${movies}">
                    <div class="content-card">
                        <a href="${pageContext.request.contextPath}/content/view?id=${movie.contentId}">
                            <div class="content-thumbnail">
                                <img src="${movie.thumbnailUrl}" alt="${movie.title}">
                                <div class="content-overlay">
                                    <div class="content-type">${movie.type}</div>
                                    <div class="content-actions">
                                        <button class="btn-play" onclick="playContent(${movie.contentId})">
                                            <i class="fa fa-play"></i>
                                        </button>
                                        <button class="btn-watchlist" onclick="toggleWatchlist(${movie.contentId})">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="content-info">
                                <h3 class="content-title">${movie.title}</h3>
                                <div class="content-meta">
                                    <span class="content-year">${movie.releaseYear}</span>
                                    <span class="content-genre">${movie.genre}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- TV Series -->
        <section class="content-section">
            <h2 class="section-title">TV Series</h2>
            <div class="content-slider">
                <c:forEach var="series" items="${tvSeries}">
                    <div class="content-card">
                        <a href="${pageContext.request.contextPath}/content/view?id=${series.contentId}">
                            <div class="content-thumbnail">
                                <img src="${series.thumbnailUrl}" alt="${series.title}">
                                <div class="content-overlay">
                                    <div class="content-type">${series.type}</div>
                                    <div class="content-actions">
                                        <button class="btn-play" onclick="playContent(${series.contentId})">
                                            <i class="fa fa-play"></i>
                                        </button>
                                        <button class="btn-watchlist" onclick="toggleWatchlist(${series.contentId})">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="content-info">
                                <h3 class="content-title">${series.title}</h3>
                                <div class="content-meta">
                                    <span class="content-year">${series.releaseYear}</span>
                                    <span class="content-genre">${series.genre}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Continue Watching -->
        <c:if test="${not empty continueWatching}">
            <section class="content-section">
                <h2 class="section-title">Continue Watching</h2>
                <div class="content-slider">
                    <c:forEach var="content" items="${continueWatching}">
                        <div class="content-card">
                            <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}">
                                <div class="content-thumbnail">
                                    <img src="${content.thumbnailUrl}" alt="${content.title}">
                                    <div class="content-overlay">
                                        <div class="content-type">${content.type}</div>
                                        <div class="content-actions">
                                            <button class="btn-play" onclick="playContent(${content.contentId})">
                                                <i class="fa fa-play"></i>
                                            </button>
                                            <button class="btn-watchlist" onclick="toggleWatchlist(${content.contentId})">
                                                <i class="fa fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="progress-bar">
                                        <div class="progress" style="width: ${content.progressPercentage}%"></div>
                                    </div>
                                </div>
                                <div class="content-info">
                                    <h3 class="content-title">${content.title}</h3>
                                    <div class="content-meta">
                                        <span class="content-year">${content.releaseYear}</span>
                                        <span class="content-genre">${content.genre}</span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/home.js"></script>
    <script>
        function playContent(contentId) {
            window.location.href = "${pageContext.request.contextPath}/player/play?id=" + contentId;
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
                                    $(".btn-watchlist[onclick='toggleWatchlist(" + contentId + ")'] i")
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
                                    $(".btn-watchlist[onclick='toggleWatchlist(" + contentId + ")'] i")
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
