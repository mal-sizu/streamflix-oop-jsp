<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:if test="${not empty content}">
            ${content.title} 
            <c:if test="${not empty episode}">
                - S${episode.season}E${episode.episodeNumber} - ${episode.title}
            </c:if>
            - StreamFlix
        </c:if>
        <c:if test="${empty content}">
            StreamFlix Player
        </c:if>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/player.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="player-page">
    <div class="player-container">
        <div class="player-header">
            <div class="player-back">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
            <div class="player-title">
                <h1>
                    ${content.title}
                    <c:if test="${not empty episode}">
                        <span>S${episode.season}E${episode.episodeNumber} - ${episode.title}</span>
                    </c:if>
                </h1>
            </div>
        </div>
        
        <div class="video-container">
            <video id="videoPlayer" controls autoplay>
                <c:if test="${not empty episode}">
                    <source src="${episode.mediaUrl}" type="video/mp4">
                </c:if>
                <c:if test="${empty episode && not empty content.mediaUrl}">
                    <source src="${content.mediaUrl}" type="video/mp4">
                </c:if>
                Your browser does not support the video tag.
            </video>
            
            <div class="video-controls">
                <button class="btn-play-pause">
                    <i class="fas fa-pause"></i>
                </button>
                
                <div class="progress-container">
                    <div class="progress-bar">
                        <div class="progress"></div>
                    </div>
                    <div class="time">
                        <span class="current-time">00:00</span>
                        <span class="duration">00:00</span>
                    </div>
                </div>
                
                <div class="controls-right">
                    <button class="btn-volume">
                        <i class="fas fa-volume-up"></i>
                    </button>
                    
                    <div class="volume-slider">
                        <div class="volume-progress">
                            <div class="volume-level"></div>
                        </div>
                    </div>
                    
                    <button class="btn-subtitles">
                        <i class="fas fa-closed-captioning"></i>
                    </button>
                    
                    <div class="quality-selection">
                        <button class="btn-quality">HD</button>
                        <div class="quality-options">
                            <button data-quality="low">Low</button>
                            <button data-quality="medium">Medium</button>
                            <button data-quality="high" class="active">HD</button>
                        </div>
                    </div>
                    
                    <button class="btn-pip" title="Picture in Picture">
                        <i class="fas fa-external-link-alt"></i>
                    </button>
                    
                    <button class="btn-fullscreen">
                        <i class="fas fa-expand"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <c:if test="${content.type eq 'SERIES' && not empty content.episodes}">
            <div class="episodes-container">
                <h2>Episodes</h2>
                
                <div class="season-selector">
                    <select id="seasonSelect">
                        <c:set var="seasons" value="${[]}"/>
                        <c:forEach var="ep" items="${content.episodes}">
                            <c:if test="${not seasons.contains(ep.season)}">
                                <c:set var="seasons" value="${seasons + [ep.season]}"/>
                                <option value="${ep.season}" ${episode.season eq ep.season ? 'selected' : ''}>
                                    Season ${ep.season}
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="episodes-list">
                    <c:forEach var="ep" items="${content.episodes}">
                        <c:if test="${empty episode.season || ep.season eq episode.season}">
                            <div class="episode-item ${ep.episodeId eq episode.episodeId ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/player/episode?contentId=${content.contentId}&season=${ep.season}&episode=${ep.episodeNumber}">
                                    <div class="episode-number">${ep.episodeNumber}</div>
                                    <div class="episode-details">
                                        <h3>${ep.title}</h3>
                                        <div class="episode-duration">45 min</div>
                                    </div>
                                </a>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </c:if>
        
        <div class="content-details">
            <div class="content-info">
                <div class="content-metadata">
                    <span class="release-year">${content.releaseDate.year + 1900}</span>
                    <span class="content-rating">TV-MA</span>
                    <span class="content-duration">
                        <c:if test="${content.type eq 'SERIES'}">
                            ${content.episodes.size()} Episodes
                        </c:if>
                        <c:if test="${content.type eq 'MOVIE'}">
                            2h 15m
                        </c:if>
                    </span>
                    <span class="content-genre">${content.genre}</span>
                </div>
                
                <div class="content-description">
                    <p>${content.description}</p>
                </div>
                
                <div class="actions">
                    <button class="btn-watchlist" onclick="toggleWatchlist(${content.contentId})">
                        <i class="fas fa-plus"></i>
                        <span>My List</span>
                    </button>
                    
                    <button class="btn-rate" onclick="showRatingDialog(${content.contentId})">
                        <i class="fas fa-star"></i>
                        <span>Rate</span>
                    </button>
                    
                    <button class="btn-share">
                        <i class="fas fa-share-alt"></i>
                        <span>Share</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
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

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/player.js"></script>
    <script>
        let contentId = ${content.contentId};
        let currentPosition = 0;
        let duration = 0;
        let volumeLevel = 1;
        let isMuted = false;
        let isPaused = false;
        
        $(document).ready(function() {
            const video = document.getElementById('videoPlayer');
            const playPauseBtn = $('.btn-play-pause');
            const progressBar = $('.progress');
            const currentTimeEl = $('.current-time');
            const durationEl = $('.duration');
            const volumeBtn = $('.btn-volume');
            const volumeLevel = $('.volume-level');
            const fullscreenBtn = $('.btn-fullscreen');
            const pipBtn = $('.btn-pip');
            
            // Initialize player
            video.addEventListener('loadedmetadata', function() {
                duration = video.duration;
                durationEl.text(formatTime(duration));
                
                // Restore previous position if available
                const savedPosition = localStorage.getItem(`streamflix_${contentId}_position`);
                if (savedPosition) {
                    video.currentTime = parseFloat(savedPosition);
                }
            });
            
            // Update progress
            video.addEventListener('timeupdate', function() {
                currentPosition = video.currentTime;
                currentTimeEl.text(formatTime(currentPosition));
                const percentage = (currentPosition / duration) * 100;
                progressBar.css('width', `${percentage}%`);
                
                // Save position every 5 seconds
                if (Math.floor(currentPosition) % 5 === 0) {
                    localStorage.setItem(`streamflix_${contentId}_position`, currentPosition);
                }
            });
            
            // Play/Pause
            playPauseBtn.on('click', function() {
                if (video.paused) {
                    video.play();
                    playPauseBtn.html('<i class="fas fa-pause"></i>');
                    isPaused = false;
                } else {
                    video.pause();
                    playPauseBtn.html('<i class="fas fa-play"></i>');
                    isPaused = true;
                }
            });
            
            // Progress bar click
            $('.progress-bar').on('click', function(e) {
                const offset = $(this).offset();
                const width = $(this).width();
                const clickX = e.pageX - offset.left;
                const percentage = clickX / width;
                
                video.currentTime = duration * percentage;
            });
            
            // Volume control
            volumeBtn.on('click', function() {
                if (video.volume === 0) {
                    video.volume = volumeLevel || 1;
                    volumeBtn.html('<i class="fas fa-volume-up"></i>');
                    $('.volume-level').css('width', `${volumeLevel * 100}%`);
                    isMuted = false;
                } else {
                    volumeLevel = video.volume;
                    video.volume = 0;
                    volumeBtn.html('<i class="fas fa-volume-mute"></i>');
                    $('.volume-level').css('width', '0%');
                    isMuted = true;
                }
            });
            
            // Volume slider
            $('.volume-progress').on('click', function(e) {
                const offset = $(this).offset();
                const width = $(this).width();
                const clickX = e.pageX - offset.left;
                const percentage = clickX / width;
                
                video.volume = percentage;
                volumeLevel = percentage;
                $('.volume-level').css('width', `${percentage * 100}%`);
                
                if (percentage === 0) {
                    volumeBtn.html('<i class="fas fa-volume-mute"></i>');
                    isMuted = true;
                } else {
                    volumeBtn.html('<i class="fas fa-volume-up"></i>');
                    isMuted = false;
                }
            });
            
            // Fullscreen
            fullscreenBtn.on('click', function() {
                if (!document.fullscreenElement) {
                    $('.player-container')[0].requestFullscreen();
                    fullscreenBtn.html('<i class="fas fa-compress"></i>');
                } else {
                    document.exitFullscreen();
                    fullscreenBtn.html('<i class="fas fa-expand"></i>');
                }
            });
            
            // Picture in Picture
            pipBtn.on('click', function() {
                if (document.pictureInPictureElement) {
                    document.exitPictureInPicture();
                } else if (document.pictureInPictureEnabled) {
                    video.requestPictureInPicture();
                }
            });
            
            // Quality selection
            $('.btn-quality').on('click', function() {
                $('.quality-options').toggleClass('show');
            });
            
            $('.quality-options button').on('click', function() {
                $('.quality-options button').removeClass('active');
                $(this).addClass('active');
                $('.btn-quality').text($(this).text());
                $('.quality-options').removeClass('show');
                
                // Implement quality change logic here
                const quality = $(this).data('quality');
                // For demo, we're not actually changing the video quality
            });
            
            // Season selector
            $('#seasonSelect').on('change', function() {
                const season = $(this).val();
                window.location.href = "${pageContext.request.contextPath}/content/view?id=${content.contentId}&season=" + season;
            });
            
            // Rating dialog
            $('.btn-rate').on('click', function() {
                $('#ratingDialog').addClass('show');
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
                        },
                        error: function() {
                            alert("Error submitting rating. Please try again.");
                        }
                    });
                } else {
                    alert("Please select a rating.");
                }
            });
            
            function highlightStars(rating) {
                $('.star-rating i').removeClass('active');
                $('.star-rating i').each(function() {
                    if ($(this).data('rating') <= rating) {
                        $(this).addClass('active');
                    }
                });
            }
            
            // Format time (seconds to MM:SS)
            function formatTime(seconds) {
                const minutes = Math.floor(seconds / 60);
                seconds = Math.floor(seconds % 60);
                return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            }
        });
        
        // Toggle watchlist
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
                                    $('.btn-watchlist i').removeClass('fa-check').addClass('fa-plus');
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
                                    $('.btn-watchlist i').removeClass('fa-plus').addClass('fa-check');
                                }
                            }
                        });
                    }
                }
            });
        }
    </script>
</body>
</html>