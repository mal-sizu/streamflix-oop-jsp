package com.streamflix.utils;

import java.util.regex.Pattern;

/**
 * Comprehensive validation utility class.
 * Handles data validation, sanitization, and security checks.
 */
public class ValidationUtil {
    // Regex patterns as constants for maintainability
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String PASSWORD_REGEX = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$";
    private static final String PHONE_REGEX = "^\\+?[0-9. ()-]{10,15}$";
    private static final String NAME_REGEX = "^[\\p{L} .'-]+$";
    private static final String USERNAME_REGEX = "^[a-zA-Z0-9_-]{3,16}$";
    
    // Compiled patterns for better performance
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(PASSWORD_REGEX);
    private static final Pattern PHONE_PATTERN = Pattern.compile(PHONE_REGEX);
    private static final Pattern NAME_PATTERN = Pattern.compile(NAME_REGEX);
    private static final Pattern USERNAME_PATTERN = Pattern.compile(USERNAME_REGEX);

    /**
     * Validates email format
     * @param email Email address to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidEmail(String email) {
        return isNotEmpty(email) && EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validates password complexity:
     * - Minimum 8 characters
     * - At least 1 digit
     * - At least 1 lowercase letter
     * - At least 1 uppercase letter
     * @param password Password to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        return isNotEmpty(password) && PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * Validates international phone number format
     * @param phoneNumber Phone number to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidPhoneNumber(String phoneNumber) {
        return isNotEmpty(phoneNumber) && PHONE_PATTERN.matcher(phoneNumber).matches();
    }

    /**
     * Validates human names (supports international characters)
     * @param name Name to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidName(String name) {
        return isNotEmpty(name) && NAME_PATTERN.matcher(name).matches();
    }

    /**
     * Validates username format:
     * - 3-16 characters
     * - Alphanumeric, underscores, and dashes
     * @param username Username to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidUsername(String username) {
        return isNotEmpty(username) && USERNAME_PATTERN.matcher(username).matches();
    }

    /**
     * Checks if a string contains non-whitespace content
     * @param str String to check
     * @return true if not null and contains non-whitespace characters
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Validates numeric range (inclusive)
     * @param value Number to check
     * @param min Minimum allowed value
     * @param max Maximum allowed value
     * @return true if within range, false otherwise
     */
    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    /**
     * Validates string length range (inclusive)
     * @param str String to validate
     * @param minLength Minimum allowed length
     * @param maxLength Maximum allowed length
     * @return true if within range, false otherwise
     */
    public static boolean isValidLength(String str, int minLength, int maxLength) {
        return str != null && str.length() >= minLength && str.length() <= maxLength;
    }

    /**
     * Sanitizes input to prevent XSS attacks
     * @param input User input to sanitize
     * @return Sanitized string with HTML entities encoded
     */
    public static String sanitizeInput(String input) {
        if (input == null) return null;
        
        return input.replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;")
                   .replaceAll("/", "&#x2F;");
    }

    /**
     * Alias for sanitizeInput() with HTML-specific name
     * @param input User input to sanitize
     * @return Sanitized string with HTML entities encoded
     */
    public static String sanitizeHtml(String input) {
        return sanitizeInput(input);
    }
}