package com.streamflix.controller;

import com.streamflix.dao.RatingDAO;
import com.streamflix.dao.RatingDAOImpl;
import com.streamflix.model.Profile;
import com.streamflix.model.Rating;
import com.streamflix.utils.ValidationUtil;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Servlet for handling rating and review operations
 */
public class RatingServlet extends HttpServlet {

    private RatingDAO ratingDAO;
    
    @Override
    public void init() throws ServletException {
        ratingDAO = new RatingDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/view";
        }
        
        switch (action) {
            case "/view":
                viewRatings(request, response);
                break;
            case "/list":
                listRatings(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/submit";
        }
        
        switch (action) {
            case "/submit":
                submitRating(request, response);
                break;
            case "/delete":
                deleteRating(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                break;
        }
    }
    
    /**
     * View ratings for a content
     */
    private void viewRatings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("contentId"));
        
        // Get ratings with profile data
        List<Rating> ratings = ratingDAO.findByContentIdWithProfiles(contentId);
        
        // Get rating statistics
        Map<Integer, Integer> distribution = ratingDAO.getRatingDistribution(contentId);
        
        // Store in request
        request.setAttribute("ratings", ratings);
        request.setAttribute("ratingDistribution", distribution);
        
        // Forward to ratings page
        request.getRequestDispatcher("/rate-review.jsp").forward(request, response);
    }
    
    /**
     * List ratings for AJAX requests
     */
    private void listRatings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("contentId"));
        int skip = request.getParameter("skip") != null ? Integer.parseInt(request.getParameter("skip")) : 0;
        int limit = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 10;
        
        // Get ratings with profile data
        List<Rating> ratings = ratingDAO.findByContentIdWithProfiles(contentId, skip, limit);
        
        // Create JSON response
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        JSONArray jsonArray = new JSONArray();
        
        for (Rating rating : ratings) {
            JSONObject jsonRating = new JSONObject();
            jsonRating.put("ratingId", rating.getRatingId());
            jsonRating.put("score", rating.getScore());
            jsonRating.put("reviewText", rating.getReviewText());
            jsonRating.put("createdAt", rating.getCreatedAt().getTime());
            
            JSONObject jsonProfile = new JSONObject();
            jsonProfile.put("profileId", rating.getProfile().getProfileId());
            jsonProfile.put("profileName", rating.getProfile().getProfileName());
            jsonProfile.put("avatarUrl", rating.getProfile().getAvatarUrl());
            
            jsonRating.put("profile", jsonProfile);
            
            jsonArray.put(jsonRating);
        }
        
        out.print(jsonArray.toString());
    }
    
    /**
     * Submit a rating
     */
    private void submitRating(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            
            int contentId = Integer.parseInt(request.getParameter("contentId"));
            int score = Integer.parseInt(request.getParameter("score"));
            String reviewText = request.getParameter("reviewText");
            
            // Validate input
            if (!ValidationUtil.isInRange(score, 1, 5)) {
                sendError(response, "Invalid score. Must be between 1 and 5.");
                return;
            }
            
            if (reviewText != null) {
                // Sanitize review text
                reviewText = ValidationUtil.sanitizeHtml(reviewText);
                
                // Check if text is too long
                if (!ValidationUtil.isValidLength(reviewText, 0, 1000)) {
                    sendError(response, "Review text too long. Maximum 1000 characters.");
                    return;
                }
            }
            
            // Check if user already rated this content
            Rating existingRating = ratingDAO.findByProfileAndContent(profile.getProfileId(), contentId);
            
            if (existingRating != null) {
                // Update existing rating
                existingRating.setScore(score);
                existingRating.setReviewText(reviewText);
                
                boolean success = ratingDAO.update(existingRating);
                
                if (success) {
                    sendSuccess(response, "Rating updated successfully");
                } else {
                    sendError(response, "Failed to update rating");
                }
            } else {
                // Create new rating
                Rating rating = new Rating(profile.getProfileId(), contentId, score, reviewText);
                
                rating = ratingDAO.save(rating);
                
                if (rating.getRatingId() > 0) {
                    sendSuccess(response, "Rating submitted successfully");
                } else {
                    sendError(response, "Failed to submit rating");
                }
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"User not logged in\"}");
        }
    }
    
    /**
     * Delete a rating
     */
    private void deleteRating(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            
            int ratingId = Integer.parseInt(request.getParameter("ratingId"));
            
            // Verify the rating belongs to this profile
            Rating rating = ratingDAO.findById(ratingId);
            
            if (rating != null && rating.getProfileId() == profile.getProfileId()) {
                boolean success = ratingDAO.delete(ratingId);
                
                if (success) {
                    sendSuccess(response, "Rating deleted successfully");
                } else {
                    sendError(response, "Failed to delete rating");
                }
            } else {
                sendError(response, "Unauthorized to delete this rating");
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"User not logged in\"}");
        }
    }
    
    /**
     * Send success JSON response
     */
    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":true,\"message\":\"" + message + "\"}");
    }
    
    /**
     * Send error JSON response
     */
    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":false,\"error\":\"" + message + "\"}");
    }
}
