package com.streamflix.controller;

import com.streamflix.dao.SubscriptionDAO;
import com.streamflix.dao.SubscriptionDAOImpl;
import com.streamflix.dao.UserDAO;
import com.streamflix.dao.UserDAOImpl;
import com.streamflix.model.Subscription;
import com.streamflix.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Servlet for handling subscription operations
 */
public class SubscriptionServlet extends HttpServlet {

    private SubscriptionDAO subscriptionDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        subscriptionDAO = new SubscriptionDAOImpl();
        userDAO = new UserDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/view";
        }
        
        switch (action) {
            case "/view":
                viewSubscription(request, response, user);
                break;
            case "/plans":
                showPlans(request, response);
                break;
            case "/history":
                viewSubscriptionHistory(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/subscription/view");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/subscribe";
        }
        
        switch (action) {
            case "/subscribe":
                subscribe(request, response, user);
                break;
            case "/cancel":
                cancelSubscription(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/subscription/view");
                break;
        }
    }
    
    /**
     * View current subscription
     */
    private void viewSubscription(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        Subscription subscription = subscriptionDAO.findActiveByUserId(user.getUserId());
        
        request.setAttribute("subscription", subscription);
        request.getRequestDispatcher("/subscription-details.jsp").forward(request, response);
    }
    
    /**
     * Show available subscription plans
     */
    private void showPlans(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You could fetch plans from database if they are stored there
        // For now, we'll just forward to the plans page
        request.getRequestDispatcher("/subscription-plans.jsp").forward(request, response);
    }
    
    /**
     * View subscription history
     */
    private void viewSubscriptionHistory(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        List<Subscription> subscriptions = subscriptionDAO.findByUserId(user.getUserId());
        
        request.setAttribute("subscriptions", subscriptions);
        request.getRequestDispatcher("/subscription-history.jsp").forward(request, response);
    }
    
    /**
     * Subscribe to a plan
     */
    private void subscribe(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        String plan = request.getParameter("plan");
        
        // Validate plan
        if (plan == null || plan.isEmpty()) {
            request.setAttribute("errorMessage", "Please select a valid plan");
            showPlans(request, response);
            return;
        }
        
        // Check if user already has an active subscription
        Subscription activeSubscription = subscriptionDAO.findActiveByUserId(user.getUserId());
        if (activeSubscription != null) {
            request.setAttribute("errorMessage", "You already have an active subscription");
            viewSubscription(request, response, user);
            return;
        }
        
        // Create new subscription
        Date startDate = new Date();
        
        // Calculate end date based on plan
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        
        switch (plan) {
            case "BASIC":
            case "STANDARD":
            case "PREMIUM":
                calendar.add(Calendar.MONTH, 1);
                break;
            case "BASIC_ANNUAL":
            case "STANDARD_ANNUAL":
            case "PREMIUM_ANNUAL":
                calendar.add(Calendar.YEAR, 1);
                break;
            default:
                calendar.add(Calendar.MONTH, 1);
                break;
        }
        
        Date endDate = calendar.getTime();
        
        // Create subscription object
        Subscription subscription = new Subscription(user.getUserId(), plan, startDate, endDate, "ACTIVE");
        
        // Save to database
        subscription = subscriptionDAO.save(subscription);
        
        if (subscription.getSubscriptionId() > 0) {
            // Success
            request.setAttribute("successMessage", "Successfully subscribed to " + plan + " plan");
            
            // Update user role if needed
            if (!"MEMBER".equals(user.getRole())) {
                user.setRole("MEMBER");
                userDAO.update(user);
                
                // Update session
                HttpSession session = request.getSession(false);
                session.setAttribute("user", user);
            }
            
            viewSubscription(request, response, user);
        } else {
            // Error
            request.setAttribute("errorMessage", "Failed to process subscription");
            showPlans(request, response);
        }
    }
    
    /**
     * Cancel subscription
     */
    private void cancelSubscription(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        int subscriptionId = Integer.parseInt(request.getParameter("subscriptionId"));
        
        // Get subscription
        Subscription subscription = subscriptionDAO.findById(subscriptionId);
        
        if (subscription == null) {
            request.setAttribute("errorMessage", "Subscription not found");
            viewSubscription(request, response, user);
            return;
        }
        
        // Check if subscription belongs to user
        if (subscription.getUserId() != user.getUserId()) {
            request.setAttribute("errorMessage", "You don't have permission to cancel this subscription");
            viewSubscription(request, response, user);
            return;
        }
        
        // Check if subscription is already canceled
        if (!"ACTIVE".equals(subscription.getStatus())) {
            request.setAttribute("errorMessage", "Subscription is already canceled");
            viewSubscription(request, response, user);
            return;
        }
        
        // Cancel subscription
        subscription.setStatus("CANCELED");
        boolean success = subscriptionDAO.update(subscription);
        
        if (success) {
            // Success
            request.setAttribute("successMessage", "Subscription canceled successfully");
        } else {
            // Error
            request.setAttribute("errorMessage", "Failed to cancel subscription");
        }
        
        viewSubscription(request, response, user);
    }
    
    /**
     * Renew subscription
     */
    private void renewSubscription(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        String plan = request.getParameter("plan");
        
        // Validate plan
        if (plan == null || plan.isEmpty()) {
            request.setAttribute("errorMessage", "Please select a valid plan");
            showPlans(request, response);
            return;
        }
        
        // Get current subscription
        Subscription currentSubscription = subscriptionDAO.findActiveByUserId(user.getUserId());
        
        // Set start date as the day after current subscription ends
        Date startDate;
        if (currentSubscription != null && currentSubscription.isActive()) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(currentSubscription.getEndDate());
            calendar.add(Calendar.DAY_OF_MONTH, 1);
            startDate = calendar.getTime();
        } else {
            startDate = new Date(); // Start today if no active subscription
        }
        
        // Calculate end date based on plan
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        
        switch (plan) {
            case "BASIC":
            case "STANDARD":
            case "PREMIUM":
                calendar.add(Calendar.MONTH, 1);
                break;
            case "BASIC_ANNUAL":
            case "STANDARD_ANNUAL":
            case "PREMIUM_ANNUAL":
                calendar.add(Calendar.YEAR, 1);
                break;
            default:
                calendar.add(Calendar.MONTH, 1);
                break;
        }
        
        Date endDate = calendar.getTime();
        
        // Create subscription object
        Subscription subscription = new Subscription(user.getUserId(), plan, startDate, endDate, "ACTIVE");
        
        // Save to database
        subscription = subscriptionDAO.save(subscription);
        
        if (subscription.getSubscriptionId() > 0) {
            // Success
            request.setAttribute("successMessage", "Successfully renewed subscription to " + plan + " plan");
            viewSubscription(request, response, user);
        } else {
            // Error
            request.setAttribute("errorMessage", "Failed to renew subscription");
            showPlans(request, response);
        }
    }
}