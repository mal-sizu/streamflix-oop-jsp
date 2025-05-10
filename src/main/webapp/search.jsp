<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <div class="search-container">
                <h1 class="page-title">Search</h1>
                
                <form action="${pageContext.request.contextPath}/search/results" method="get" class="search-form">
                    <div class="search-input-wrapper">
                        <input type="text" name="query" id="searchInput" placeholder="Search for titles, people, genres" 
                               value="${param.query}" autocomplete="off" autofocus>
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </div>
                    
                    <div id="liveSearchResults" class="live-search-results"></div>
                </form>
                
                <div class="search-filters">
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
                </div>
            </div>
            
            <div class="popular-searches">
                <h2>Popular Searches</h2>
                <div class="popular-search-tags">
                    <a href="${pageContext.request.contextPath}/search/results?query=action" class="search-tag">Action</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=comedy" class="search-tag">Comedy</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=thriller" class="search-tag">Thriller</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=sci-fi" class="search-tag">Sci-Fi</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=romance" class="search-tag">Romance</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=adventure" class="search-tag">Adventure</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=fantasy" class="search-tag">Fantasy</a>
                    <a href="${pageContext.request.contextPath}/search/results?query=drama" class="search-tag">Drama</a>
                </div>
            </div>
            
            <div class="trending-content">
                <h2>Trending Now</h2>
                <div class="content-grid">
                    <c:forEach var="content" items="${trendingContent}">
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
                                        <span class="content-year">${content.releaseDate.year + 1900}</span>
                                        <span class="content-genre">${content.genre}</span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Live search
            var searchTimeout;
            
            $('#searchInput').on('keyup', function() {
                clearTimeout(searchTimeout);
                
                const query = $(this).val();
                
                if (query.length >= 2) {
                    searchTimeout = setTimeout(function() {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/search/ajax",
                            data: { query: query },
                            dataType: "json",
                            success: function(data) {
                                let resultsHtml = "";
                                
                                if (data.length > 0) {
                                    for (let i = 0; i < Math.min(data.length, 5); i++) {
                                        resultsHtml += `
                                            <div class="search-result-item">
                                                <a href="${pageContext.request.contextPath}/content/view?id=${data[i].id}">
                                                    <img src="${data[i].thumbnailUrl}" alt="${data[i].title}">
                                                    <div class="result-info">
                                                        <h4>${data[i].title}</h4>
                                                        <span class="result-type">${data[i].type}</span>
                                                    </div>
                                                </a>
                                            </div>
                                        `;
                                    }
                                }
                                
                                $('#liveSearchResults').html(resultsHtml);
                                
                                if (resultsHtml !== "") {
                                    $('#liveSearchResults').show();
                                } else {
                                    $('#liveSearchResults').hide();
                                }
                            }
                        });
                    }, 300);
                } else {
                    $('#liveSearchResults').hide();
                }
            });
            
            // Hide live search results when clicking outside
            $(document).on('click', function(event) {
                if (!$(event.target).closest('.search-input-wrapper').length) {
                    $('#liveSearchResults').hide();
                }
            });
            
            // Filter updates
            $('.search-filters select').on('change', function() {
                // We'll handle this on the Apply Filters button click
            });
            
            // Apply filters
            $('.btn-apply-filters').on('click', function() {
                const query = $('#searchInput').val();
                const type = $('#typeFilter').val();
                const genre = $('#genreFilter').val();
                const language = $('#languageFilter').val();
                const sort = $('#sortFilter').val();
                
                let url = "${pageContext.request.contextPath}/search/results?";
                
                if (query) url += `query=${encodeURIComponent(query)}&`;
                if (type) url += `type=${encodeURIComponent(type)}&`;
                if (genre) url += `genre=${encodeURIComponent(genre)}&`;
                if (language) url += `language=${encodeURIComponent(language)}&`;
                if (sort) url += `sort=${encodeURIComponent(sort)}&`;
                
                // Remove trailing &
                url = url.replace(/&$/, '');
                
                window.location.href = url;
            });
        });
        
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