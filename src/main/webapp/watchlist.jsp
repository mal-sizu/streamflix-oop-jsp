<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My List - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/watchlist.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">My List</h1>
            
            <c:if test="${empty watchlist}">
                <div class="empty-watchlist">
                    <div class="empty-message">
                        <i class="fas fa-list-ul"></i>
                        <h2>Your watchlist is empty</h2>
                        <p>Add movies and shows to your list to watch them later.</p>
                        <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">Browse Content</a>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty watchlist}">
                <div class="watchlist-container">
                    <div class="watchlist-filters">
                        <div class="filter-group">
                            <label>Show:</label>
                            <select id="typeFilter">
                                <option value="all">All</option>
                                <option value="MOVIE">Movies</option>
                                <option value="SERIES">TV Shows</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label>Sort By:</label>
                            <select id="sortFilter">
                                <option value="dateAdded">Date Added</option>
                                <option value="name">Name</option>
                                <option value="releaseDate">Release Date</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="watchlist-grid">
                        <c:forEach var="content" items="${watchlist}">
                            <div class="watchlist-item" data-type="${content.type}">
                                <div class="watchlist-card">
                                    <div class="card-thumbnail">
                                        <img src="${content.thumbnailUrl}" alt="${content.title}">
                                        <div class="card-overlay">
                                            <div class="card-actions">
                                                <button class="btn-play" onclick="playContent(${content.contentId})">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn-remove" onclick="removeFromWatchlist(${content.contentId}, this)">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="card-info">
                                        <h3 class="card-title">
                                            <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}">
                                                ${content.title}
                                            </a>
                                        </h3>
                                        
                                        <div class="card-meta">
                                            <span class="card-year">${content.releaseDate.year + 1900}</span>
                                            <span class="card-type">${content.type}</span>
                                            <span class="card-genre">${content.genre}</span>
                                        </div>
                                        
                                        <p class="card-description">
                                            ${content.description.length() > 100 ? content.description.substring(0, 100).concat('...') : content.description}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

    <jsp:include page="includes/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script>
        function playContent(contentId) {
            window.location.href = "${pageContext.request.contextPath}/player/play?id=" + contentId;
        }
        
        function removeFromWatchlist(contentId, element) {
            if(confirm('Remove this title from your list?')) {
                $.ajax({
                    url: "${pageContext.request.contextPath}/watchlist/remove",
                    data: { id: contentId },
                    dataType: "json",
                    success: function(response) {
                        if (response.success) {
                            // Remove the item from the UI
                            $(element).closest('.watchlist-item').fadeOut(300, function() {
                                $(this).remove();
                                
                                // Check if watchlist is now empty
                                if ($('.watchlist-item').length === 0) {
                                    location.reload(); // Reload to show empty state
                                }
                            });
                        } else {
                            alert("Error removing from watchlist. Please try again.");
                        }
                    },
                    error: function() {
                        alert("Error removing from watchlist. Please try again.");
                    }
                });
            }
        }
        
        $(document).ready(function() {
            // Type filter
            $('#typeFilter').on('change', function() {
                const type = $(this).val();
                
                if (type === 'all') {
                    $('.watchlist-item').show();
                } else {
                    $('.watchlist-item').hide();
                    $(`.watchlist-item[data-type="${type}"]`).show();
                }
            });
            
            // Sort filter
            $('#sortFilter').on('change', function() {
                const sortBy = $(this).val();
                const $grid = $('.watchlist-grid');
                const $items = $grid.children('.watchlist-item').get();
                
                $items.sort(function(a, b) {
                    if (sortBy === 'name') {
                        const titleA = $(a).find('.card-title').text().trim().toLowerCase();
                        const titleB = $(b).find('.card-title').text().trim().toLowerCase();
                        return titleA.localeCompare(titleB);
                    } else if (sortBy === 'releaseDate') {
                        const yearA = parseInt($(a).find('.card-year').text());
                        const yearB = parseInt($(b).find('.card-year').text());
                        return yearB - yearA; // Newest first
                    }
                    
                    // Default: date added - we'll use DOM order as proxy
                    return $(a).index() - $(b).index();
                });
                
                // Re-append items to the grid
                $.each($items, function(i, item) {
                    $grid.append(item);
                });
            });
        });
    </script>
</body>
</html>
