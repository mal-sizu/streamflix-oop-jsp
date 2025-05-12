/**
 * StreamFlix - Video Player JavaScript
 * Handles video playback, controls, progress tracking, and related functionality
 */

$(document).ready(function() {
    // Get references to DOM elements
    const videoPlayer = document.getElementById('videoPlayer');
    const playPauseBtn = $('.btn-play-pause');
    const progressBar = $('.progress');
    const progressContainer = $('.progress-bar');
    const currentTimeDisplay = $('.current-time');
    const durationDisplay = $('.duration');
    const volumeBtn = $('.btn-volume');
    const volumeSlider = $('.volume-slider');
    const volumeLevel = $('.volume-level');
    const fullscreenBtn = $('.btn-fullscreen');
    const pipBtn = $('.btn-pip');
    const subtitlesBtn = $('.btn-subtitles');
    const qualityBtn = $('.btn-quality');
    const qualityOptions = $('.quality-options');
    const videoControls = $('.video-controls');
    const videoContainer = $('.video-container');
    
    // Initialize player state
    let isPlaying = true;
    let isMuted = false;
    let isFullscreen = false;
    let hideControlsTimeout;
    let lastPlaybackPosition = 0;
    let contentId = $('#videoPlayer').data('content-id');
    
    // Set initial volume
    videoPlayer.volume = 0.8;
    updateVolumeUI(videoPlayer.volume);
    
    // Initialize video duration once metadata is loaded
    $(videoPlayer).on('loadedmetadata', function() {
        durationDisplay.text(formatTime(videoPlayer.duration));
        // Set initial progress position if resuming
        if (lastPlaybackPosition > 0 && lastPlaybackPosition < videoPlayer.duration) {
            videoPlayer.currentTime = lastPlaybackPosition;
        }
    });
    
    // Play/Pause button click handler
    playPauseBtn.on('click', function() {
        togglePlayPause();
    });
    
    // Click on video to toggle play/pause
    $(videoPlayer).on('click', function(e) {
        // Only toggle if clicked directly on video (not controls)
        if (e.target === videoPlayer) {
            togglePlayPause();
        }
    });
    
    // Update progress bar as video plays
    $(videoPlayer).on('timeupdate', function() {
        // Update progress bar
        const percentage = (videoPlayer.currentTime / videoPlayer.duration) * 100;
        progressBar.css('width', percentage + '%');
        
        // Update current time display
        currentTimeDisplay.text(formatTime(videoPlayer.currentTime));
        
        // Save progress to server every 5 seconds
        if (Math.floor(videoPlayer.currentTime) % 5 === 0 && videoPlayer.currentTime > 0) {
            savePlaybackProgress();
        }
    });
    
    // Click on progress bar to seek
    progressContainer.on('click', function(e) {
        const offset = $(this).offset();
        const width = $(this).width();
        const clickPosition = (e.pageX - offset.left) / width;
        
        // Set video time to clicked position
        videoPlayer.currentTime = clickPosition * videoPlayer.duration;
    });
    
    // Volume button click handler
    volumeBtn.on('click', function() {
        toggleMute();
    });
    
    // Volume slider click handler
    volumeSlider.on('click', function(e) {
        const offset = $(this).offset();
        const width = $(this).width();
        const clickPosition = (e.pageX - offset.left) / width;
        
        // Set volume based on clicked position (0-1)
        videoPlayer.volume = clickPosition;
        updateVolumeUI(clickPosition);
    });
    
    // Fullscreen button click handler
    fullscreenBtn.on('click', function() {
        toggleFullscreen();
    });
    
    // Picture-in-Picture button click handler
    pipBtn.on('click', function() {
        togglePictureInPicture();
    });
    
    // Subtitles button click handler
    subtitlesBtn.on('click', function() {
        toggleSubtitles();
    });
    
    // Quality button click handler
    qualityBtn.on('click', function() {
        qualityOptions.toggleClass('active');
    });
    
    // Quality option selection
    qualityOptions.find('button').on('click', function() {
        const quality = $(this).data('quality');
        changeVideoQuality(quality);
        
        // Update active class
        qualityOptions.find('button').removeClass('active');
        $(this).addClass('active');
        
        // Update quality button text
        qualityBtn.text($(this).text());
        
        // Hide quality options
        qualityOptions.removeClass('active');
    });
    
    // Hide controls when mouse is inactive
    videoContainer.on('mousemove', function() {
        showControls();
        
        // Clear previous timeout
        clearTimeout(hideControlsTimeout);
        
        // Set new timeout to hide controls after 3 seconds
        hideControlsTimeout = setTimeout(function() {
            if (isPlaying) {
                videoControls.addClass('hidden');
            }
        }, 3000);
    });
    
    // Show controls when mouse enters video container
    videoContainer.on('mouseenter', function() {
        showControls();
    });
    
    // Hide controls when mouse leaves video container
    videoContainer.on('mouseleave', function() {
        if (isPlaying) {
            videoControls.addClass('hidden');
        }
    });
    
    // Handle keyboard shortcuts
    $(document).on('keydown', function(e) {
        // Only handle shortcuts if video player is in focus
        if ($(videoPlayer).is(':focus') || videoContainer.is(':hover')) {
            switch(e.which) {
                case 32: // Space bar - Play/Pause
                    togglePlayPause();
                    e.preventDefault();
                    break;
                case 37: // Left arrow - Rewind 10 seconds
                    videoPlayer.currentTime = Math.max(0, videoPlayer.currentTime - 10);
                    e.preventDefault();
                    break;
                case 39: // Right arrow - Forward 10 seconds
                    videoPlayer.currentTime = Math.min(videoPlayer.duration, videoPlayer.currentTime + 10);
                    e.preventDefault();
                    break;
                case 38: // Up arrow - Volume up
                    videoPlayer.volume = Math.min(1, videoPlayer.volume + 0.1);
                    updateVolumeUI(videoPlayer.volume);
                    e.preventDefault();
                    break;
                case 40: // Down arrow - Volume down
                    videoPlayer.volume = Math.max(0, videoPlayer.volume - 0.1);
                    updateVolumeUI(videoPlayer.volume);
                    e.preventDefault();
                    break;
                case 70: // F - Fullscreen
                    toggleFullscreen();
                    e.preventDefault();
                    break;
                case 77: // M - Mute
                    toggleMute();
                    e.preventDefault();
                    break;
            }
        }
    });
    
    // Save playback progress when video ends
    $(videoPlayer).on('ended', function() {
        // Mark as completed
        savePlaybackProgress(true);
        
        // Show next episode or related content if available
        showNextContent();
    });
    
    // Load initial playback position from server
    loadPlaybackPosition();
    
    /**
     * Toggle play/pause state of the video
     */
    function togglePlayPause() {
        if (videoPlayer.paused) {
            videoPlayer.play();
            playPauseBtn.find('i').removeClass('fa-play').addClass('fa-pause');
            isPlaying = true;
            
            // Hide controls after delay
            clearTimeout(hideControlsTimeout);
            hideControlsTimeout = setTimeout(function() {
                videoControls.addClass('hidden');
            }, 3000);
        } else {
            videoPlayer.pause();
            playPauseBtn.find('i').removeClass('fa-pause').addClass('fa-play');
            isPlaying = false;
            
            // Always show controls when paused
            showControls();
        }
    }
    
    /**
     * Toggle mute state of the video
     */
    function toggleMute() {
        if (videoPlayer.muted) {
            videoPlayer.muted = false;
            volumeBtn.find('i').removeClass('fa-volume-mute').addClass('fa-volume-up');
            updateVolumeUI(videoPlayer.volume);
        } else {
            videoPlayer.muted = true;
            volumeBtn.find('i').removeClass('fa-volume-up').addClass('fa-volume-mute');
            updateVolumeUI(0);
        }
    }
    
    /**
     * Toggle fullscreen mode
     */
    function toggleFullscreen() {
        if (!document.fullscreenElement) {
            videoContainer[0].requestFullscreen().catch(err => {
                console.error(`Error attempting to enable fullscreen: ${err.message}`);
            });
            fullscreenBtn.find('i').removeClass('fa-expand').addClass('fa-compress');
        } else {
            document.exitFullscreen();
            fullscreenBtn.find('i').removeClass('fa-compress').addClass('fa-expand');
        }
    }
    
    /**
     * Toggle picture-in-picture mode
     */
    function togglePictureInPicture() {
        if (document.pictureInPictureElement) {
            document.exitPictureInPicture();
        } else if (document.pictureInPictureEnabled) {
            videoPlayer.requestPictureInPicture();
        }
    }
    
    /**
     * Toggle subtitles/captions
     */
    function toggleSubtitles() {
        // Get all text tracks
        const tracks = videoPlayer.textTracks;
        
        if (tracks.length > 0) {
            // Find the first subtitle/caption track
            for (let i = 0; i < tracks.length; i++) {
                if (tracks[i].kind === 'subtitles' || tracks[i].kind === 'captions') {
                    if (tracks[i].mode === 'showing') {
                        tracks[i].mode = 'hidden';
                        subtitlesBtn.removeClass('active');
                    } else {
                        tracks[i].mode = 'showing';
                        subtitlesBtn.addClass('active');
                    }
                    break;
                }
            }
        }
    }
    
    /**
     * Change video quality
     * @param {string} quality - The quality level (low, medium, high)
     */
    function changeVideoQuality(quality) {
        // In a real implementation, this would switch video sources
        // For this demo, we'll just log the quality change
        console.log(`Changing video quality to: ${quality}`);
        
        // Save current playback position
        const currentTime = videoPlayer.currentTime;
        const isPaused = videoPlayer.paused;
        
        // In a real implementation, we would change the video source here
        // videoPlayer.src = getVideoSourceForQuality(quality);
        
        // Restore playback position and state
        videoPlayer.currentTime = currentTime;
        if (!isPaused) {
            videoPlayer.play();
        }
    }
    
    /**
     * Update volume UI based on current volume
     * @param {number} volume - Volume level (0-1)
     */
    function updateVolumeUI(volume) {
        // Update volume level indicator
        volumeLevel.css('width', (volume * 100) + '%');
        
        // Update volume icon based on level
        if (volume === 0 || videoPlayer.muted) {
            volumeBtn.find('i').removeClass('fa-volume-up fa-volume-down').addClass('fa-volume-mute');
        } else if (volume < 0.5) {
            volumeBtn.find('i').removeClass('fa-volume-up fa-volume-mute').addClass('fa-volume-down');
        } else {
            volumeBtn.find('i').removeClass('fa-volume-down fa-volume-mute').addClass('fa-volume-up');
        }
    }
    
    /**
     * Show video controls
     */
    function showControls() {
        videoControls.removeClass('hidden');
    }
    
    /**
     * Format time in seconds to MM:SS format
     * @param {number} seconds - Time in seconds
     * @returns {string} Formatted time string
     */
    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        seconds = Math.floor(seconds % 60);
        return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
    
    /**
     * Save playback progress to server
     * @param {boolean} completed - Whether the video was completed
     */
    function savePlaybackProgress(completed = false) {
        if (!contentId) return;
        
        const progress = {
            contentId: contentId,
            position: videoPlayer.currentTime,
            duration: videoPlayer.duration,
            completed: completed || false
        };
        
        $.ajax({
            url: contextPath + '/content/save-progress',
            method: 'POST',
            data: progress,
            dataType: 'json'
        });
    }
    
    /**
     * Load playback position from server
     */
    function loadPlaybackPosition() {
        if (!contentId) return;
        
        $.ajax({
            url: contextPath + '/content/get-progress',
            method: 'GET',
            data: { id: contentId },
            dataType: 'json',
            success: function(data) {
                if (data && data.position) {
                    lastPlaybackPosition = data.position;
                    
                    // If video is already loaded, set the position
                    if (videoPlayer.readyState > 0) {
                        videoPlayer.currentTime = lastPlaybackPosition;
                    }
                }
            }
        });
    }
    
    /**
     * Show next episode or related content
     */
    function showNextContent() {
        // Check if there's a next episode or related content
        if ($('.next-episode').length) {
            // Show next episode panel
            $('.next-episode-panel').addClass('active');
            
            // Auto-play next episode after 10 seconds if not interrupted
            const nextEpisodeTimer = setTimeout(function() {
                window.location.href = $('.next-episode-btn').attr('href');
            }, 10000);
            
            // Cancel auto-play if user interacts
            $('.cancel-autoplay').on('click', function() {
                clearTimeout(nextEpisodeTimer);
                $('.next-episode-panel').removeClass('active');
            });
        } else {
            // Show related content recommendations
            $('.related-content').addClass('active');
        }
    }
});

/**
 * Toggle watchlist status for content
 * @param {number} contentId - The ID of the content
 */
function toggleWatchlist(contentId) {
    $.ajax({
        url: contextPath + "/watchlist/check",
        data: { id: contentId },
        dataType: "json",
        success: function(data) {
            if (data.inWatchlist) {
                // Remove from watchlist
                $.ajax({
                    url: contextPath + "/watchlist/remove",
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
                    url: contextPath + "/watchlist/add",
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