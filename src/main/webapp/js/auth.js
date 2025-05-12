/**
 * auth.js - JavaScript functionality for authentication pages
 */

$(document).ready(function() {
    // Form validation
    $('.auth-form').on('submit', function(e) {
        let isValid = true;
        
        // Check required fields
        $(this).find('input[required], select[required], textarea[required]').each(function() {
            if ($(this).val().trim() === '') {
                isValid = false;
                showError($(this), 'This field is required.');
            } else {
                removeError($(this));
            }
        });
        
        // Check email fields
        $(this).find('input[type="email"]').each(function() {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if ($(this).val() !== '' && !emailRegex.test($(this).val())) {
                isValid = false;
                showError($(this), 'Please enter a valid email address.');
            }
        });
        
        // Check password fields for register form
        if ($(this).attr('action').includes('register')) {
            const passwordField = $(this).find('input[name="password"]');
            const confirmPasswordField = $(this).find('input[name="confirmPassword"]');
            
            // Check password strength
            if (passwordField.val().length > 0 && passwordField.val().length < 8) {
                isValid = false;
                showError(passwordField, 'Password must be at least 8 characters long.');
            }
            
            // Check password complexity
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/;
            if (passwordField.val().length > 0 && !passwordRegex.test(passwordField.val())) {
                isValid = false;
                showError(passwordField, 'Password must include at least one uppercase letter, one lowercase letter, and one number.');
            }
            
            // Check if passwords match
            if (passwordField.val() !== confirmPasswordField.val()) {
                isValid = false;
                showError(confirmPasswordField, 'Passwords do not match.');
            }
        }
        
        if (!isValid) {
            e.preventDefault();
        }
    });
    
    // Clear validation errors on input
    $('.auth-form input').on('input', function() {
        removeError($(this));
    });
    
    // Show password toggle
    $('.password-toggle').on('click', function() {
        const passwordField = $(this).siblings('input');
        
        if (passwordField.attr('type') === 'password') {
            passwordField.attr('type', 'text');
            $(this).html('<i class="fas fa-eye-slash"></i>');
        } else {
            passwordField.attr('type', 'password');
            $(this).html('<i class="fas fa-eye"></i>');
        }
    });
    
    // Remember me checkbox styling
    $('.form-checkbox input[type="checkbox"]').on('change', function() {
        if ($(this).is(':checked')) {
            $(this).parent().addClass('checked');
        } else {
            $(this).parent().removeClass('checked');
        }
    });
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        $('.alert').fadeOut(500);
    }, 5000);
    
    // Focus first input field
    $('.auth-form input:first').focus();
    
    /**
     * Show error message for an input field
     * 
     * @param {jQuery} field - The input field
     * @param {string} message - The error message
     */
    function showError(field, message) {
        field.addClass('is-invalid');
        
        // Add error message if not exists
        if (field.next('.error-message').length === 0) {
            field.after('<div class="error-message">' + message + '</div>');
        } else {
            field.next('.error-message').text(message);
        }
    }
    
    /**
     * Remove error message for an input field
     * 
     * @param {jQuery} field - The input field
     */
    function removeError(field) {
        field.removeClass('is-invalid');
        field.next('.error-message').remove();
    }
    
    // Password strength meter
    const passwordField = $('input[name="password"]');
    
    if (passwordField.length > 0) {
        passwordField.after('<div class="password-strength"><div class="strength-meter"></div><div class="strength-text"></div></div>');
        
        passwordField.on('input', function() {
            const password = $(this).val();
            const strength = calculatePasswordStrength(password);
            
            // Update strength meter
            $('.strength-meter').removeClass('weak medium strong');
            
            if (password.length === 0) {
                $('.strength-meter').width('0%');
                $('.strength-text').text('');
            } else if (strength < 40) {
                $('.strength-meter').width('33%').addClass('weak');
                $('.strength-text').text('Weak');
            } else if (strength < 80) {
                $('.strength-meter').width('66%').addClass('medium');
                $('.strength-text').text('Medium');
            } else {
                $('.strength-meter').width('100%').addClass('strong');
                $('.strength-text').text('Strong');
            }
        });
    }
    
    /**
     * Calculate password strength
     * 
     * @param {string} password - The password to check
     * @return {number} - Strength score (0-100)
     */
    function calculatePasswordStrength(password) {
        let score = 0;
        
        // Length check
        if (password.length > 6) {
            score += 10;
        }
        if (password.length > 8) {
            score += 10;
        }
        if (password.length > 10) {
            score += 10;
        }
        
        // Character type checks
        if (/[A-Z]/.test(password)) { // Has uppercase
            score += 10;
        }
        if (/[a-z]/.test(password)) { // Has lowercase
            score += 10;
        }
        if (/[0-9]/.test(password)) { // Has number
            score += 10;
        }
        if (/[^A-Za-z0-9]/.test(password)) { // Has special char
            score += 10;
        }
        
        // Complexity checks
        if (/[A-Z].*[A-Z]/.test(password)) { // Has 2+ uppercase
            score += 5;
        }
        if (/[a-z].*[a-z].*[a-z]/.test(password)) { // Has 3+ lowercase
            score += 5;
        }
        if (/[0-9].*[0-9]/.test(password)) { // Has 2+ numbers
            score += 5;
        }
        if (/[^A-Za-z0-9].*[^A-Za-z0-9]/.test(password)) { // Has 2+ special chars
            score += 5;
        }
        
        // Combination checks
        if (/[A-Z].*[0-9]|[0-9].*[A-Z]/.test(password)) { // Has uppercase and number
            score += 5;
        }
        if (/[a-z].*[0-9]|[0-9].*[a-z]/.test(password)) { // Has lowercase and number
            score += 5;
        }
        if (/[A-Za-z].*[^A-Za-z0-9]|[^A-Za-z0-9].*[A-Za-z]/.test(password)) { // Has letter and special char
            score += 5;
        }
        
        return score;
    }
});
