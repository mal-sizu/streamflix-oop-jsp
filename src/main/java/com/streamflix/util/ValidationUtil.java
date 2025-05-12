package com.streamflix.util;

import java.util.regex.Pattern;

/**
 * Utility class for data validation.
 * Provides methods to validate user input and data integrity.
 */
public class ValidationUtil {
    
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    
    // Password validation pattern (at least 8 chars, 1 uppercase, 1 lowercase, 1 number)
    private static final Pattern PASSWORD_PATTERN = 
        Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$");
    
    // Phone number validation pattern
    private static final Pattern PHONE_PATTERN = 
        Pattern.compile("^\\+?[0-9. ()-]{10,15}$");
    
    /**
     * Validates an email address format.
     * 
     * @param email The email address to validate
     * @return true if the email is valid, false otherwise
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * Validates a password according to security requirements.
     * 
     * @param password The password to validate
     * @return true if the password is valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }
    
    /**
     * Validates a phone number format.
     * 
     * @param phoneNumber The phone number to validate
     * @return true if the phone number is valid, false otherwise
     */
    public static boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phoneNumber).matches();
    }
    
    /**
     * Validates that a string is not null or empty.
     * 
     * @param value The string to check
     * @return true if the string has content, false otherwise
     */
    public static boolean hasValue(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    /**
     * Validates that a number is within a specified range.
     * 
     * @param value The number to check
     * @param min The minimum allowed value
     * @param max The maximum allowed value
     * @return true if the number is within range, false otherwise
     */
    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }
    
    /**
     * Sanitizes a string input to prevent XSS attacks.
     * 
     * @param input The input string to sanitize
     * @return The sanitized string
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        
        // Replace potentially dangerous characters
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }
}