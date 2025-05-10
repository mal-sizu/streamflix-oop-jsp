/**
 * main.js - Global JavaScript functionality for StreamFlix
 */

document.addEventListener('DOMContentLoaded', function() {
    // Header scroll effect
    const header = document.querySelector('.main-header');
    
    if (header) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }
    
    // Initialize any tooltips
    initializeTooltips();
    
    // Initialize any dropdowns
    initializeDropdowns();
});

/**
 * Initialize tooltips
 */
function initializeTooltips() {
    const tooltips = document.querySelectorAll('[data-tooltip]');
    
    tooltips.forEach(tooltip => {
        tooltip.addEventListener('mouseenter', function() {
            const tooltipText = this.getAttribute('data-tooltip');
            
            // Create tooltip element
            const tooltipEl = document.createElement('div');
            tooltipEl.className = 'tooltip';
            tooltipEl.textContent = tooltipText;
            
            // Position tooltip
            const rect = this.getBoundingClientRect();
            tooltipEl.style.top = rect.bottom + 10 + 'px';
            tooltipEl.style.left = rect.left + (rect.width / 2) - 60 + 'px';
            
            // Add tooltip to body
            document.body.appendChild(tooltipEl);
            
            // Store reference to tooltip
            this.tooltipEl = tooltipEl;
        });
        
        tooltip.addEventListener('mouseleave', function() {
            if (this.tooltipEl) {
                document.body.removeChild(this.tooltipEl);
                this.tooltipEl = null;
            }
        });
    });
}

/**
 * Initialize dropdowns
 */
function initializeDropdowns() {
    const dropdowns = document.querySelectorAll('.dropdown-toggle');
    
    dropdowns.forEach(dropdown => {
        dropdown.addEventListener('click', function(e) {
            e.preventDefault();
            
            const dropdownMenu = this.nextElementSibling;
            
            // Toggle dropdown
            dropdownMenu.classList.toggle('show');
            
            // Close all other dropdowns
            document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                if (menu !== dropdownMenu) {
                    menu.classList.remove('show');
                }
            });
        });
    });
    
    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
            document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                menu.classList.remove('show');
            });
        }
    });
}

/**
 * Format time (seconds to MM:SS)
 * 
 * @param {number} seconds - Time in seconds
 * @return {string} Formatted time (MM:SS)
 */
function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    seconds = Math.floor(seconds % 60);
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

/**
 * Handle AJAX errors
 * 
 * @param {object} xhr - XMLHttpRequest object
 * @param {string} status - Status of the request
 * @param {string} error - Error message
 */
function handleAjaxError(xhr, status, error) {
    console.error('AJAX Error:', status, error);
    
    // Display error message to user
    const errorMessage = xhr.responseJSON && xhr.responseJSON.message
        ? xhr.responseJSON.message
        : 'An error occurred. Please try again later.';
    
    alert(errorMessage);
}

/**
 * Toggle watchlist item
 * 
 * @param {number} contentId - Content ID
 * @param {Element} element - Button element
 */
function toggleWatchlist(contentId, element) {
    // Check if in watchlist
    $.ajax({
        url: '/watchlist/check',
        data: { id: contentId },
        dataType: 'json',
        success: function(data) {
            if (data.inWatchlist) {
                // Remove from watchlist
                $.ajax({
                    url: '/watchlist/remove',
                    data: { id: contentId },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Update UI
                            updateWatchlistButton(element, false);
                        }
                    },
                    error: handleAjaxError
                });
            } else {
                // Add to watchlist
                $.ajax({
                    url: '/watchlist/add',
                    data: { id: contentId },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            // Update UI
                            updateWatchlistButton(element, true);
                        }
                    },
                    error: handleAjaxError
                });
            }
        },
        error: handleAjaxError
    });
    
    // Prevent default link behavior
    event.preventDefault();
    event.stopPropagation();
}

/**
 * Update watchlist button UI
 * 
 * @param {Element} element - Button element
 * @param {boolean} inWatchlist - Whether item is in watchlist
 */
function updateWatchlistButton(element, inWatchlist) {
    const icon = element.querySelector('i');
    
    if (inWatchlist) {
        icon.classList.remove('fa-plus');
        icon.classList.add('fa-check');
        
        const text = element.querySelector('span');
        if (text) {
            text.textContent = 'In My List';
        }
    } else {
        icon.classList.remove('fa-check');
        icon.classList.add('fa-plus');
        
        const text = element.querySelector('span');
        if (text) {
            text.textContent = 'My List';
        }
    }
}

/**
 * Play content
 * 
 * @param {number} contentId - Content ID
 */
function playContent(contentId) {
    window.location.href = '/player/play?id=' + contentId;
    
    // Prevent default link behavior
    event.preventDefault();
    event.stopPropagation();
}

/**
 * Show rating dialog
 * 
 * @param {number} contentId - Content ID
 */
function showRatingDialog(contentId) {
    const dialog = document.getElementById('ratingDialog');
    if (dialog) {
        dialog.classList.add('show');
        
        // Set content ID in a hidden field
        const contentIdField = document.getElementById('ratingContentId');
        if (contentIdField) {
            contentIdField.value = contentId;
        }
    }
}
