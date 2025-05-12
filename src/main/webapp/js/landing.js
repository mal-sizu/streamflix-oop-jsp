/**
 * StreamFlix - Landing Page JavaScript
 * Handles landing page interactions including accordion functionality and registration form
 */

$(document).ready(function() {
    // Accordion functionality for FAQ section
    $('.accordion-btn').on('click', function() {
        // Toggle active class on the clicked button
        $(this).toggleClass('active');
        
        // Toggle the visibility of the content panel
        const content = $(this).next('.accordion-content');
        
        // If the content is already visible, hide it, otherwise show it
        if (content.css('max-height') !== '0px') {
            content.css('max-height', '0px');
        } else {
            // Set the max height to the scroll height to show all content
            content.css('max-height', content.prop('scrollHeight') + 'px');
        }
    });
    
    // Email validation for registration forms
    $('form[action*="/auth/register"]').on('submit', function(e) {
        const emailInput = $(this).find('input[type="email"]');
        const email = emailInput.val().trim();
        
        // Simple email validation regex
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (!emailRegex.test(email)) {
            // Prevent form submission
            e.preventDefault();
            
            // Show error message
            if (!emailInput.next('.error-message').length) {
                emailInput.after('<div class="error-message">Please enter a valid email address</div>');
            }
            
            // Highlight the input field
            emailInput.addClass('error');
        } else {
            // Remove error styling if previously applied
            emailInput.removeClass('error');
            emailInput.next('.error-message').remove();
        }
    });
    
    // Clear error styling when user starts typing again
    $('input[type="email"]').on('input', function() {
        $(this).removeClass('error');
        $(this).next('.error-message').remove();
    });
    
    // Smooth scroll for anchor links
    $('a[href^="#"]').on('click', function(e) {
        e.preventDefault();
        
        const target = $(this.hash);
        if (target.length) {
            $('html, body').animate({
                scrollTop: target.offset().top - 70 // Offset for fixed header
            }, 800);
        }
    });
});