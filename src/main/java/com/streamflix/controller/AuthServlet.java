package com.streamflix.controller;

import com.streamflix.dao.UserDAO;
import com.streamflix.dao.UserDAOImpl;
import com.streamflix.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling user authentication operations
 */
public class AuthServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/login";
        }
        
        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/forgot-password":
                showForgotPasswordForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/login";
        }
        
        switch (action) {
            case "/login":
                processLogin(request, response);
                break;
            case "/register":
                processRegistration(request, response);
                break;
            case "/reset-password":
                processPasswordReset(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                break;
        }
    }
    
    /**
     * Show login form
     */
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    /**
     * Show registration form
     */
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    /**
     * Show forgot password form
     */
    private void showForgotPasswordForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
    
    /**
     * Process login
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Check if user exists
        User user = userDAO.findByEmail(email);
        if (user == null) {
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Check password
        if (!BCrypt.checkpw(password, user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Create session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        
        // Set session timeout (30 minutes by default, 7 days if remember me)
        if (rememberMe != null && rememberMe.equals("on")) {
            session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7 days
        }
        
        // Redirect to home page or admin dashboard
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }
    
    /**
     * Process registration
     */
    private void processRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        User existingUser = userDAO.findByEmail(email);
        if (existingUser != null) {
            request.setAttribute("errorMessage", "Email already registered");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
        User newUser = new User(email, passwordHash, name, "MEMBER");
        
        // Save user
        newUser = userDAO.save(newUser);
        
        if (newUser.getUserId() > 0) {
            // Success - redirect to login
            request.setAttribute("successMessage", "Registration successful. Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            // Error
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Process password reset
     */
    private void processPasswordReset(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email is required");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Check if user exists
        User user = userDAO.findByEmail(email);
        if (user == null) {
            // For security, don't reveal that the email doesn't exist
            request.setAttribute("successMessage", "If your email is registered, you will receive a password reset link shortly.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // In a real application, send email with reset link
        // For this demo, we'll just redirect to a page with a success message
        request.setAttribute("successMessage", "If your email is registered, you will receive a password reset link shortly.");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    /**
     * Logout user
     */
    private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
