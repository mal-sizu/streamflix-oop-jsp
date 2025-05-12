package com.streamflix.controller;

import com.streamflix.dao.ContentDAO;
import com.streamflix.dao.ContentDAOImpl;
import com.streamflix.dao.UserDAO;
import com.streamflix.dao.UserDAOImpl;
import com.streamflix.dao.SubscriptionDAO;
import com.streamflix.dao.SubscriptionDAOImpl;
import com.streamflix.model.Content;
import com.streamflix.model.User;
import com.streamflix.model.Subscription;
import com.streamflix.utils.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for handling admin operations
 */
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private ContentDAO contentDAO;
    private SubscriptionDAO subscriptionDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
        contentDAO = new ContentDAOImpl();
        subscriptionDAO = new SubscriptionDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/dashboard";
        }
        
        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/users":
                listUsers(request, response);
                break;
            case "/user/edit":
                showEditUserForm(request, response);
                break;
            case "/user/delete":
                deleteUser(request, response);
                break;
            case "/content":
                listContent(request, response);
                break;
            case "/stats":
                showStats(request, response);
                break;
            case "/subscriptions":
                listSubscriptions(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }
        
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/dashboard";
        }
        
        switch (action) {
            case "/user/update":
                updateUser(request, response);
                break;
            case "/user/add":
                addUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }
    
    /**
     * Check if the current user is an admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            return user.isAdmin();
        }
        
        return false;
    }
    
    /**
     * Show admin dashboard
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Dashboard statistics
        int totalUsers = userDAO.findAll().size();
        int totalContent = contentDAO.findAll().size();
        
        // Count by type
        int moviesCount = contentDAO.findByType("MOVIE").size();
        int seriesCount = contentDAO.findByType("SERIES").size();
        
        // Recent content
        List<Content> recentContent = contentDAO.findRecent(5);
        
        // Top rated content
        List<Content> topRatedContent = contentDAO.findTopRated(5);
        
        // Active subscriptions
        int activeSubscriptions = subscriptionDAO.countActiveSubscriptions();
        
        // Set attributes
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalContent", totalContent);
        request.setAttribute("moviesCount", moviesCount);
        request.setAttribute("seriesCount", seriesCount);
        request.setAttribute("recentContent", recentContent);
        request.setAttribute("topRatedContent", topRatedContent);
        request.setAttribute("activeSubscriptions", activeSubscriptions);
        
        // Forward to dashboard
        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
    
    /**
     * List all users
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all users
        List<User> users = userDAO.findAll();
        
        // Set attributes
        request.setAttribute("users", users);
        
        // Forward to users list
        request.getRequestDispatcher("/manage-users.jsp").forward(request, response);
    }
    
    /**
     * Show edit user form
     */
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        
        // Get user
        User user = userDAO.findById(userId);
        
        if (user != null) {
            // Set attributes
            request.setAttribute("user", user);
            
            // Forward to edit form
            request.getRequestDispatcher("/admin/edit-user.jsp").forward(request, response);
        } else {
            // User not found
            request.setAttribute("errorMessage", "User not found");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
    
    /**
     * Update user
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        
        // Validate input
        if (!ValidationUtil.isValidName(name)) {
            request.setAttribute("errorMessage", "Invalid name");
            showEditUserForm(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Invalid email");
            showEditUserForm(request, response);
            return;
        }
        
        // Get existing user
        User user = userDAO.findById(userId);
        
        if (user != null) {
            // Update user
            user.setName(name);
            user.setEmail(email);
            user.setRole(role);
            
            boolean success = userDAO.update(user);
            
            if (success) {
                // Success
                request.setAttribute("successMessage", "User updated successfully");
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to update user");
                showEditUserForm(request, response);
            }
        } else {
            // User not found
            request.setAttribute("errorMessage", "User not found");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
    
    /**
     * Add new user
     */
    private void addUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // Validate input
        if (!ValidationUtil.isValidName(name)) {
            request.setAttribute("errorMessage", "Invalid name");
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Invalid email");
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Invalid password. Must be at least 8 characters with at least one digit, one lowercase and one uppercase letter.");
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        User existingUser = userDAO.findByEmail(email);
        
        if (existingUser != null) {
            request.setAttribute("errorMessage", "Email already registered");
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
            return;
        }
        
        // Create password hash
        String passwordHash = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
        
        // Create user
        User user = new User(email, passwordHash, name, role);
        
        user = userDAO.save(user);
        
        if (user.getUserId() > 0) {
            // Success
            request.setAttribute("successMessage", "User created successfully");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            // Error
            request.setAttribute("errorMessage", "Failed to create user");
            request.getRequestDispatcher("/admin/add-user.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete user
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        
        // Get user
        User user = userDAO.findById(userId);
        
        if (user != null) {
            // Prevent deleting own account
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");
            
            if (user.getUserId() == currentUser.getUserId()) {
                request.setAttribute("errorMessage", "Cannot delete your own account");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Delete user
            boolean success = userDAO.delete(userId);
            
            if (success) {
                // Success
                request.setAttribute("successMessage", "User deleted successfully");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to delete user");
            }
        } else {
            // User not found
            request.setAttribute("errorMessage", "User not found");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    
    /**
     * List all content
     */
    private void listContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all content
        List<Content> contentList = contentDAO.findAll();
        
        // Set attributes
        request.setAttribute("contentList", contentList);
        
        // Forward to content list
        request.getRequestDispatcher("/manage-content.jsp").forward(request, response);
    }
    
    /**
     * Show stats and analytics
     */
    private void showStats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Content by type
        Map<String, Integer> contentByType = new HashMap<>();
        contentByType.put("Movies", contentDAO.findByType("MOVIE").size());
        contentByType.put("Series", contentDAO.findByType("SERIES").size());
        
        // Users by role
        Map<String, Integer> usersByRole = new HashMap<>();
        usersByRole.put("Admins", userDAO.findByRole("ADMIN").size());
        usersByRole.put("Members", userDAO.findByRole("MEMBER").size());
        
        // Subscription statistics
        Map<String, Integer> subscriptionsByPlan = subscriptionDAO.countByPlan();
        
        // Set attributes
        request.setAttribute("contentByType", contentByType);
        request.setAttribute("usersByRole", usersByRole);
        request.setAttribute("subscriptionsByPlan", subscriptionsByPlan);
        
        // Forward to stats page
        request.getRequestDispatcher("/admin/stats.jsp").forward(request, response);
    }
    
    /**
     * List all subscriptions
     */
    private void listSubscriptions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all subscriptions
        List<Subscription> subscriptions = subscriptionDAO.findAllWithUserDetails();
        
        // Set attributes
        request.setAttribute("subscriptions", subscriptions);
        
        // Forward to subscriptions list
        request.getRequestDispatcher("/admin/subscriptions.jsp").forward(request, response);
    }
}
