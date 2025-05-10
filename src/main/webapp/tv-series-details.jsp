<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${content.title} - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/details.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="content-hero" style="background-image: linear-gradient(to bottom, rgba(0,0,0,0.7), rgba(0,0,0,0.9)), url('${content.thumbnailUrl}');">
            <div class="container">
                <div class="content-details">
                    <div class="content-poster">
                        <img src="${content.thumbnailUrl}" alt="${content.title}">
                    </div>
                    
                    <div class="content-info">
                        <h1 class="content-title">${content.title}</h1>
                        
                        <div class="content-meta">
                            <span class="release-year">
                                <fmt:formatDate value="${content.releaseDate}" pattern="yyyy" />
                            </span>
                            <span class="content-rating">TV-MA</span>
                            <span class="content-duration">${content.episodes.size()} Episodes</span>
                            <span class="content-quality">HD</span>
                        </div>
                        
                        <div class="content-rating">
                            <div class="rating-stars">
                                <c:set var="fullStars" value="${Math.floor(content.averageRating)}" />
                                <c:set var="hasHalfStar" value="${content.averageRating - fullStars >= 0.5}" />
                                
                                <c:forEach begin="1" end="${fullStars}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                                
                                <c:if test="${hasHalfStar}">
                                    <i class="fas fa-star-half-alt"></i>
                                </c:if>
                                
                                <c:forEach begin="1" end="${5 - fullStars - (hasHalfStar ? 1 : 0)}">
                                    <i class="far fa-star"></i>
                                </c:forEach>
                                
                                <span class="rating-value">${content.averageRating}/5</span>
                            </div>
                        </div>
                        
                        <p class="content-description">${content.description}</p>
                        
                        <div class="content-genre">
                            <strong>Genre:</strong> ${content.genre}
                        </div>
                        
                        <div class="content-language">
                            <strong>Language:</strong> ${content.language}
                        </div>
                        
                        <div class="content-actions">
                            <a href="${pageContext.request.contextPath}/player/episode?contentId=${content.contentId}&season=1&episode=1" class="btn btn-primary btn-play">
                                <i class="fas fa-play"></i> Play
                            </a>
                            
                            <button class="btn btn-secondary btn-watchlist" id="watchlistBtn" onclick="toggleWatchlist(${content.contentId})">
                                <i class="fas fa-plus"></i> <span>My List</span>
                            </button>
                            
                            <button class="btn btn-secondary btn-rate" onclick="showRatingDialog()">
                                <i class="fas fa-star"></i> Rate
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Episodes Section -->
        <section class="content-section">
            <div class="container">
                <div class="series-header">
                    <h2 class="section-title">Episodes</h2>
                    
                    <div class="season-selector">
                        <select id="seasonSelect">
                            <c:set var="seasons" value="${[]}"/>
                            <c:forEach var="episode" items="${content.episodes}">
                                <c:if test="${not seasons.contains(episode.season)}">
                                    <c:set var="seasons" value="${seasons + [episode.season]}"/>
                                    <option value="${episode.season}" ${param.season eq episode.season ? 'selected' : ''}>
                                        Season ${episode.season}
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <div class="episodes-list">
                    <c:set var="currentSeason" value="${param.season ne null ? param.season : seasons[0]}"/>
                    <c:forEach var="episode" items="${content.episodes}">
                        <c:if test="${episode.season eq currentSeason}">
                            <div class="episode-item">
                                <div class="episode-thumbnail">
                                    <img src="${content.thumbnailUrl}" alt="Episode ${episode.episodeNumber}">
                                    <div class="episode-overlay">
                                        <button class="btn-play" onclick="playEpisode(${content.contentId}, ${episode.season}, ${episode.episodeNumber})">
                                            <i class="fas fa-play"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="episode-info">
                                    <div class="episode-header">
                                        <h3 class="episode-title">
                                            <span class="episode-number">${episode.episodeNumber}.</span> ${episode.title}
                                        </h3>
                                        <span class="episode-duration">45m</span>
                                    </div>
                                    
                                    <p class="episode-description">
                                        Episode description would go here. Since we don't have descriptions in our database, this is a placeholder.
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </section>
        
        <!-- Ratings & Reviews -->
        <section class="content-section">
            <div class="container">
                <h2 class="section-title">Ratings & Reviews</h2>
                
                <div class="ratings-summary">
                    <div class="rating-average">
                        <div class="rating-value">${content.averageRating}</div>
                        <div class="rating-stars">
                            <c:set var="fullStars" value="${Math.floor(content.averageRating)}" />
                            <c:set var="hasHalfStar" value="${content.averageRating - fullStars >= 0.5}" />
                            
                            <c:forEach begin="1" end="${fullStars}">
                                <i class="fas fa-star"></i>
                            </c:forEach>
                            
                            <c:if test="${hasHalfStar}">
                                <i class="fas fa-star-half-alt"></i>
                            </c:if>
                            
                            <c:forEach begin="1" end="${5 - fullStars - (hasHalfStar ? 1 : 0)}">
                                <i class="far fa-star"></i>
                            </c:forEach>
                        </div>
                        <div class="rating-count">${ratings.size()} ratings</div>
                    </div>
                    
                    <div class="rating-distribution">
                        <c:forEach var="i" begin="5" end="1" step="-1">
                            <div class="rating-bar">
                                <span class="rating-label">${i} stars</span>
                                <div class="progress-bar">
                                    <c:set var="percentage" value="${ratingDistribution[i] / (ratings.size() > 0 ? ratings.size() : 1) * 100}" />
                                    <div class="progress" style="width: ${percentage}%"></div>
                                </div>
                                <span class="rating-count">${ratingDistribution[i]}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="reviews-container">
                    <h3>User Reviews</h3>
                    
                    <c:if test="${empty ratings}">
                        <div class="no-reviews">
                            <p>No reviews yet. Be the first to rate this title!</p>
                            <button class="btn btn-primary" onclick="showRatingDialog()">Write a Review</button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty ratings}">
                        <div class="reviews-list">
                            <c:forEach var="rating" items="${ratings}" varStatus="loop">
                                <c:if test="${loop.index < 5}">
                                    <div class="review-item">
                                        <div class="review-header">
                                            <div class="reviewer-info">
                                                <img src="${rating.profile.avatarUrl}" alt="${rating.profile.profileName}" class="reviewer-avatar">
                                                <span class="reviewer-name">${rating.profile.profileName}</span>
                                            </div>
                                            
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="fas fa-star ${star <= rating.score ? 'active' : ''}"></i>
                                                </c:forEach>
                                            </div>
                                            
                                            <div class="review-date">
                                                <fmt:formatDate value="${rating.createdAt}" pattern="MMM d, yyyy" />
                                            </div>
                                        </div>
                                        
                                        <div class="review-content">
                                            <p>${rating.reviewText}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                            
                            <c:if test="${ratings.size() > 5}">
                                <div class="more-reviews">
                                    <button class="btn btn-secondary" id="loadMoreReviews">
                                        Show More Reviews (${ratings.size() - 5} more)
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
        
        <!-- Similar Content -->
        <section class="content-section">
            <div class="container">
                <h2 class="section-title">More Like This</h2>
                
                <div class="content-slider">
                    <c:forEach var="similar" items="${similarContent}">
                        <div class="content-card">
                            <a href="${pageContext.request.contextPath}/content/view?id=${similar.contentId}">
                                <div class="content-thumbnail">
                                    <img src="${similar.thumbnailUrl}" alt="${similar.title}">
                                    <div class="content-overlay">
                                        <div class="content-type">${similar.type}</div>
                                        <div class="content-actions">
                                            <button class="btn-play" onclick="playContent(${similar.contentId})">
                                                <i class="fas fa-play"></i>
                                            </button>
                                            <button class="btn-watchlist" onclick="toggleWatchlist(${similar.contentId})">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="content-info">
                                    <h3 class="content-title">${similar.title}</h3>
                                    <div class="content-meta">
                                        <span class="content-year">
                                            <fmt:formatDate value="${similar.releaseDate}" pattern="yyyy" />
                                        </span>
                                        <span class="content-genre">${similar.genre}</span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
    </main>
    
    <!-- Rating Dialog -->
    <div id="ratingDialog" class="dialog">
        <div class="dialog-content">
            <div class="dialog-header">
                <h3>Rate "${content.title}"</h3>
                <button class="btn-close">&times;</button>
            </div>
            
            <div class="dialog-body">
                <div class="star-rating">
                    <i class="fas fa-star" data-rating="1"></i>
                    <i class="fas fa-star" data-rating="2"></i>
                    <i class="fas fa-star" data-rating="3"></i>
                    <i class="fas fa-star" data-rating="4"></i>
                    <i class="fas fa-star" data-rating="5"></i>
                </div>
                
                <div class="rating-form">
                    <textarea id="reviewText" placeholder="Write your review (optional)"></textarea>
                    <button id="submitRating" class="btn btn-primary">Submit</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script>
        let contentId = ${content.contentId};
        let inWatchlist = false;
        
        $(document).ready(function() {
            // Check if content is in watchlist
            $.ajax({
                url: "${pageContext.request.contextPath}/watchlist/check",
                data: { id: contentId },
                dataType: "json",
                success: function(data) {
                    inWatchlist = data.inWatchlist;
                    updateWatchlistButton();
                }
            });
            
            // Season selector
            $('#seasonSelect').on('change', function() {
                const season = $(this).val();
                window.location.href = "${pageContext.request.contextPath}/content/view?id=${content.contentId}&season=" + season;
            });
            
            // Load more reviews
            $('#loadMoreReviews').on('click', function() {
                $.ajax({
                    url: "${pageContext.request.contextPath}/rating/list",
                    data: { contentId: contentId, skip: 5 },
                    dataType: "json",
                    success: function(data) {
                        // Remove the "Show More" button
                        $('.more-reviews').remove();
                        
                        // Append new reviews
                        $.each(data, function(index, rating) {
                            let reviewHtml = `
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <img src="${rating.profile.avatarUrl}" alt="${rating.profile.profileName}" class="reviewer-avatar">
                                            <span class="reviewer-name">${rating.profile.profileName}</span>
                                        </div>
                                        
                                        <div class="review-rating">`;
                            
                            // Add stars
                            for (let i = 1; i <= 5; i++) {
                                reviewHtml += `<i class="fas fa-star ${i <= rating.score ? 'active' : ''}"></i>`;
                            }
                            
                            reviewHtml += `
                                        </div>
                                        
                                        <div class="review-date">
                                            ${new Date(rating.createdAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })}
                                        </div>
                                    </div>
                                    
                                    <div class="review-content">
                                        <p>${rating.reviewText}</p>
                                    </div>
                                </div>
                            `;
                            
                            $('.reviews-list').append(reviewHtml);
                        });
                    }
                });
            });
            
            // Rating dialog
            $('.btn-rate').on('click', function() {
                showRatingDialog();
            });
            
            $('.btn-close').on('click', function() {
                $('#ratingDialog').removeClass('show');
            });
            
            // Star rating
            let selectedRating = 0;
            
            $('.star-rating i').on('mouseover', function() {
                const rating = $(this).data('rating');
                highlightStars(rating);
            });
            
            $('.star-rating i').on('mouseout', function() {
                highlightStars(selectedRating);
            });
            
            $('.star-rating i').on('click', function() {
                selectedRating = $(this).data('rating');
                highlightStars(selectedRating);
            });
            
            $('#submitRating').on('click', function() {
                if (selectedRating > 0) {
                    const reviewText = $('#reviewText').val();
                    
                    // Submit rating via AJAX
                    $.ajax({
                        url: "${pageContext.request.contextPath}/rating/submit",
                        method: "POST",
                        data: {
                            contentId: contentId,
                            score: selectedRating,
                            reviewText: reviewText
                        },
                        success: function(response) {
                            $('#ratingDialog').removeClass('show');
                            alert("Thank you for your rating!");
                            location.reload(); // Reload to show the new rating
                        },
                        error: function() {
                            alert("Error submitting rating. Please try again.");
                        }
                    });
                } else {
                    alert("Please select a rating.");
                }
            });
        });
        
        function highlightStars(rating) {
            $('.star-rating i').removeClass('active');
            $('.star-rating i').each(function() {
                if ($(this).data('rating') <= rating) {
                    $(this).addClass('active');
                }
            });
        }
        
        function showRatingDialog() {
            $('#ratingDialog').addClass('show');
        }
        
        function toggleWatchlist(id) {
            if (inWatchlist) {
                // Remove from watchlist
                $.ajax({
                    url: "${pageContext.request.contextPath}/watchlist/remove",
                    data: { id: id },
                    dataType: "json",
                    success: function(response) {
                        if (response.success) {
                            inWatchlist = false;
                            updateWatchlistButton();
                        }
                    }
                });
            } else {
                // Add to watchlist
                $.ajax({
                    url: "${pageContext.request.contextPath}/watchlist/add",
                    data: { id: id },
                    dataType: "json",
                    success: function(response) {
                        if (response.success) {
                            inWatchlist = true;
                            updateWatchlistButton();
                        }
                    }
                });
            }
            
            // Prevent default link click behavior
            event.preventDefault();
            event.stopPropagation();
        }
        
        function updateWatchlistButton() {
            if (inWatchlist) {
                $('#watchlistBtn i').removeClass('fa-plus').addClass('fa-check');
                $('#watchlistBtn span').text('In My List');
            } else {
                $('#watchlistBtn i').removeClass('fa-check').addClass('fa-plus');
                $('#watchlistBtn span').text('My List');
            }
        }
        
        function playContent(id) {
            // For movies, go to player directly
            window.location.href = "${pageContext.request.contextPath}/player/play?id=" + id;
            
            // Prevent default link click behavior
            event.preventDefault();
            event.stopPropagation();
        }
        
        function playEpisode(contentId, season, episode) {
            window.location.href = "${pageContext.request.contextPath}/player/episode?contentId=" + contentId + "&season=" + season + "&episode=" + episode;
            
            // Prevent default link click behavior
            event.preventDefault();
            event.stopPropagation();
        }
    </script>
</body>
</html>