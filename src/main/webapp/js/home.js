/**
 * StreamFlix - Home Page JavaScript
 * Handles content browsing, sliders, and user interactions
 */

$(document).ready(function() {
    // Initialize content sliders
    initializeContentSliders();
    
    // Handle hover effects on content cards
    $('.content-card').hover(
        function() {
            $(this).find('.content-overlay').addClass('active');
        },
        function() {
            $(this).find('.content-overlay').removeClass('active');
        }
    );
});

/**
 * Initialize all content sliders on the page
 */
function initializeContentSliders() {
    $('.content-slider').each(function() {
        const slider = $(this);
        const cardWidth = slider.find('.content-card').first().outerWidth(true);
        const visibleCards = Math.floor(slider.width() / cardWidth);
        const totalCards = slider.find('.content-card').length;
        
        // Only add navigation if there are more cards than visible space
        if (totalCards > visibleCards) {
            // Add navigation buttons if not already present
            if (!slider.next('.slider-nav').length) {
                slider.after(
                    '<div class="slider-nav">' +
                    '   <button class="slider-prev"><i class="fa fa-chevron-left"></i></button>' +
                    '   <button class="slider-next"><i class="fa fa-chevron-right"></i></button>' +
                    '</div>'
                );
                
                // Handle next button click
                slider.next('.slider-nav').find('.slider-next').on('click', function() {
                    const scrollPosition = slider.scrollLeft();
                    slider.animate({
                        scrollLeft: scrollPosition + (cardWidth * Math.floor(visibleCards / 2))
                    }, 300);
                });
                
                // Handle previous button click
                slider.next('.slider-nav').find('.slider-prev').on('click', function() {
                    const scrollPosition = slider.scrollLeft();
                    slider.animate({
                        scrollLeft: scrollPosition - (cardWidth * Math.floor(visibleCards / 2))
                    }, 300);
                });
            }
        }
    });
}

/**
 * Play content with the given ID
 * @param {number} contentId - The ID of the content to play
 */
function playContent(contentId) {
    // Redirect to the player page with the content ID
    window.location.href = contextPath + "/player/play?id=" + contentId;
}

/**
 * Toggle content in watchlist
 * @param {number} contentId - The ID of the content to toggle in watchlist
 */
function toggleWatchlist(contentId) {
    // Check if content is already in watchlist
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
                            $(".btn-watchlist[onclick='toggleWatchlist(" + contentId + ")']").find('i')
                                .removeClass("fa-check")
                                .addClass("fa-plus");
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
                            $(".btn-watchlist[onclick='toggleWatchlist(" + contentId + ")']").find('i')
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

// Handle window resize to adjust sliders
$(window).on('resize', function() {
    // Reinitialize sliders after resize
    initializeContentSliders();
});