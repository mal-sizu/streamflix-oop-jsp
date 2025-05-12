package com.streamflix.controller;

import com.streamflix.dao.RecommendationDAO;
import com.streamflix.dao.RecommendationDAOImpl;
import com.streamflix.model.Content;
import com.streamflix.model.Profile;
import com.streamflix.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet for handling content recommendations
 */
public class RecommendationServlet extends HttpServlet {

    private RecommendationDAO recommendationDAO;
    
    @Override
    public void init() throws ServletException {
        recommendationDAO = new RecommendationDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/view";
        }
        
        switch (action) {
            case "/view":
                viewRecommendations(request, response);
                break;
            case "/similar":
                getSimilarContent(request, response);
                break;
            case "/trending":
                getTrendingContent(request, response);
                break;
            case "/personalized":
                getPersonalizedRecommendations(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/recommendation/view");
                break;
        }
    }
    
    /**
     * View all recommendations for the current profile
     */
    private void viewRecommendations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            
            // Get different types of recommendations
            List<Content> personalizedRecommendations = recommendationDAO.getPersonalizedRecommendations(profile.getProfileId());
            List<Content> trendingContent = recommendationDAO.getTrendingContent();
            List<Content> newReleases = recommendationDAO.getNewReleases();
            
            // Set attributes for the JSP
            request.setAttribute("personalizedRecommendations", personalizedRecommendations);
            request.setAttribute("trendingContent", trendingContent);
            request.setAttribute("newReleases", newReleases);
            
            request.getRequestDispatcher("/recommendations.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Get similar content based on a specific content ID
     */
    private void getSimilarContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("id"));
        List<Content> similarContent = recommendationDAO.getSimilarContent(contentId);
        
        // Check if this is an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
        
        if (isAjax) {
            // Send JSON response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            // Build JSON response (simplified for example)
            StringBuilder jsonBuilder = new StringBuilder("{");
            jsonBuilder.append("\"similarContent\":[\n");
            
            for (int i = 0; i < similarContent.size(); i++) {
                Content content = similarContent.get(i);
                jsonBuilder.append("{\n");
                jsonBuilder.append("\"id\":").append(content.getContentId()).append(",\n");
                jsonBuilder.append("\"title\":\"").append(content.getTitle()).append("\",\n");
                jsonBuilder.append("\"thumbnailUrl\":\"").append(content.getThumbnailUrl()).append("\",\n");
                jsonBuilder.append("\"type\":\"").append(content.getType()).append("\",\n");
                jsonBuilder.append("\"genre\":\"").append(content.getGenre()).append("\",\n");
                jsonBuilder.append("\"rating\":").append(content.getRating());
                jsonBuilder.append("\n}");
                
                if (i < similarContent.size() - 1) {
                    jsonBuilder.append(",\n");
                }
            }
            
            jsonBuilder.append("\n]\n}");
            
            out.print(jsonBuilder.toString());
            out.flush();
        } else {
            // Forward to JSP
            request.setAttribute("similarContent", similarContent);
            request.setAttribute("contentId", contentId);
            request.getRequestDispatcher("/similar-content.jsp").forward(request, response);
        }
    }
    
    /**
     * Get trending content
     */
    private void getTrendingContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Content> trendingContent = recommendationDAO.getTrendingContent();
        
        // Check if this is an AJAX request
        String xRequestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
        
        if (isAjax) {
            // Send JSON response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            // Build JSON response (simplified for example)
            StringBuilder jsonBuilder = new StringBuilder("{");
            jsonBuilder.append("\"trendingContent\":[\n");
            
            for (int i = 0; i < trendingContent.size(); i++) {
                Content content = trendingContent.get(i);
                jsonBuilder.append("{\n");
                jsonBuilder.append("\"id\":").append(content.getContentId()).append(",\n");
                jsonBuilder.append("\"title\":\"").append(content.getTitle()).append("\",\n");
                jsonBuilder.append("\"thumbnailUrl\":\"").append(content.getThumbnailUrl()).append("\",\n");
                jsonBuilder.append("\"type\":\"").append(content.getType()).append("\",\n");
                jsonBuilder.append("\"genre\":\"").append(content.getGenre()).append("\",\n");
                jsonBuilder.append("\"rating\":").append(content.getRating());
                jsonBuilder.append("\n}");
                
                if (i < trendingContent.size() - 1) {
                    jsonBuilder.append(",\n");
                }
            }
            
            jsonBuilder.append("\n]\n}");
            
            out.print(jsonBuilder.toString());
            out.flush();
        } else {
            // Forward to JSP
            request.setAttribute("trendingContent", trendingContent);
            request.getRequestDispatcher("/trending.jsp").forward(request, response);
        }
    }
    
    /**
     * Get personalized recommendations for the current profile
     */
    private void getPersonalizedRecommendations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            List<Content> personalizedRecommendations = recommendationDAO.getPersonalizedRecommendations(profile.getProfileId());
            
            // Check if this is an AJAX request
            String xRequestedWith = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            if (isAjax) {
                // Send JSON response
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                
                // Build JSON response (simplified for example)
                StringBuilder jsonBuilder = new StringBuilder("{");
                jsonBuilder.append("\"personalizedRecommendations\":[\n");
                
                for (int i = 0; i < personalizedRecommendations.size(); i++) {
                    Content content = personalizedRecommendations.get(i);
                    jsonBuilder.append("{\n");
                    jsonBuilder.append("\"id\":").append(content.getContentId()).append(",\n");
                    jsonBuilder.append("\"title\":\"").append(content.getTitle()).append("\",\n");
                    jsonBuilder.append("\"thumbnailUrl\":\"").append(content.getThumbnailUrl()).append("\",\n");
                    jsonBuilder.append("\"type\":\"").append(content.getType()).append("\",\n");
                    jsonBuilder.append("\"genre\":\"").append(content.getGenre()).append("\",\n");
                    jsonBuilder.append("\"rating\":").append(content.getRating());
                    jsonBuilder.append("\n}");
                    
                    if (i < personalizedRecommendations.size() - 1) {
                        jsonBuilder.append(",\n");
                    }
                }
                
                jsonBuilder.append("\n]\n}");
                
                out.print(jsonBuilder.toString());
                out.flush();
            } else {
                // Forward to JSP
                request.setAttribute("personalizedRecommendations", personalizedRecommendations);
                request.getRequestDispatcher("/personalized.jsp").forward(request, response);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"User not logged in\"}");
            out.flush();
        }
    }
}