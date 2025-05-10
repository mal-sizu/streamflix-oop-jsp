package com.streamflix.controller;

import com.streamflix.dao.ContentDAO;
import com.streamflix.dao.ContentDAOImpl;
import com.streamflix.model.Content;
import com.streamflix.model.Episode;
import com.streamflix.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Servlet for handling content operations
 */
public class ContentServlet extends HttpServlet {

    private ContentDAO contentDAO;
    
    @Override
    public void init() throws ServletException {
        contentDAO = new ContentDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/list";
        }
        
        switch (action) {
            case "/list":
                listContent(request, response);
                break;
            case "/view":
                viewContent(request, response);
                break;
            case "/add":
                showAddForm(request, response);
                break;
            case "/edit":
                showEditForm(request, response);
                break;
            case "/delete":
                deleteContent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/content/list");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/list";
        }
        
        switch (action) {
            case "/add":
                addContent(request, response);
                break;
            case "/edit":
                updateContent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/content/list");
                break;
        }
    }
    
    /**
     * List all content
     */
    private void listContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Content> contentList = contentDAO.findAll();
        request.setAttribute("contentList", contentList);
        request.getRequestDispatcher("/manage-content.jsp").forward(request, response);
    }
    
    /**
     * View content details
     */
    private void viewContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("id"));
        Content content = contentDAO.findWithEpisodes(contentId);
        
        if (content != null) {
            request.setAttribute("content", content);
            
            if ("MOVIE".equals(content.getType())) {
                request.getRequestDispatcher("/movie-details.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/tv-series-details.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Content not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Show form to add new content
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                request.getRequestDispatcher("/admin/add-content.jsp").forward(request, response);
                return;
            }
        }
        
        // If not admin, redirect to home
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
    
    /**
     * Show form to edit content
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                int contentId = Integer.parseInt(request.getParameter("id"));
                Content content = contentDAO.findWithEpisodes(contentId);
                
                if (content != null) {
                    request.setAttribute("content", content);
                    request.getRequestDispatcher("/admin/edit-content.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Content not found");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
                return;
            }
        }
        
        // If not admin, redirect to home
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
    
    /**
     * Delete content
     */
    private void deleteContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                int contentId = Integer.parseInt(request.getParameter("id"));
                boolean success = contentDAO.delete(contentId);
                
                if (success) {
                    request.setAttribute("successMessage", "Content deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete content");
                }
                
                response.sendRedirect(request.getContextPath() + "/content/list");
                return;
            }
        }
        
        // If not admin, redirect to home
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
    
    /**
     * Add new content
     */
    private void addContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                try {
                    // Parse request parameters
                    String type = request.getParameter("type");
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    String genre = request.getParameter("genre");
                    String language = request.getParameter("language");
                    String releaseDateStr = request.getParameter("releaseDate");
                    String thumbnailUrl = request.getParameter("thumbnailUrl");
                    String mediaUrl = request.getParameter("mediaUrl");
                    
                    // Validate input
                    if (title == null || title.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Title is required");
                        request.getRequestDispatcher("/admin/add-content.jsp").forward(request, response);
                        return;
                    }
                    
                    // Parse release date
                    Date releaseDate = null;
                    if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                        try {
                            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                            releaseDate = format.parse(releaseDateStr);
                        } catch (ParseException e) {
                            request.setAttribute("errorMessage", "Invalid date format");
                            request.getRequestDispatcher("/admin/add-content.jsp").forward(request, response);
                            return;
                        }
                    }
                    
                    // Create content object
                    Content content = new Content(type, title, description, genre, language, releaseDate, thumbnailUrl, mediaUrl);
                    
                    // If this is a series, process episodes
                    if ("SERIES".equals(type)) {
                        String[] seasons = request.getParameterValues("season");
                        String[] episodeNumbers = request.getParameterValues("episodeNumber");
                        String[] episodeTitles = request.getParameterValues("episodeTitle");
                        String[] episodeMediaUrls = request.getParameterValues("episodeMediaUrl");
                        
                        if (seasons != null && episodeNumbers != null && episodeTitles != null && episodeMediaUrls != null) {
                            List<Episode> episodes = new ArrayList<>();
                            
                            for (int i = 0; i < seasons.length; i++) {
                                if (i < episodeNumbers.length && i < episodeTitles.length && i < episodeMediaUrls.length) {
                                    Episode episode = new Episode();
                                    episode.setSeason(Integer.parseInt(seasons[i]));
                                    episode.setEpisodeNumber(Integer.parseInt(episodeNumbers[i]));
                                    episode.setTitle(episodeTitles[i]);
                                    episode.setMediaUrl(episodeMediaUrls[i]);
                                    episodes.add(episode);
                                }
                            }
                            
                            content.setEpisodes(episodes);
                        }
                    }
                    
                    // Save content
                    content = contentDAO.save(content);
                    
                    if (content.getContentId() > 0) {
                        // Success
                        request.setAttribute("successMessage", "Content added successfully");
                        response.sendRedirect(request.getContextPath() + "/content/list");
                    } else {
                        // Error
                        request.setAttribute("errorMessage", "Failed to add content");
                        request.getRequestDispatcher("/admin/add-content.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error: " + e.getMessage());
                    request.getRequestDispatcher("/admin/add-content.jsp").forward(request, response);
                }
                return;
            }
        }
        
        // If not admin, redirect to home
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
    
    /**
     * Update existing content
     */
    private void updateContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                try {
                    // Parse request parameters
                    int contentId = Integer.parseInt(request.getParameter("contentId"));
                    String type = request.getParameter("type");
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    String genre = request.getParameter("genre");
                    String language = request.getParameter("language");
                    String releaseDateStr = request.getParameter("releaseDate");
                    String thumbnailUrl = request.getParameter("thumbnailUrl");
                    String mediaUrl = request.getParameter("mediaUrl");
                    
                    // Validate input
                    if (title == null || title.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Title is required");
                        showEditForm(request, response);
                        return;
                    }
                    
                    // Parse release date
                    Date releaseDate = null;
                    if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                        try {
                            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                            releaseDate = format.parse(releaseDateStr);
                        } catch (ParseException e) {
                            request.setAttribute("errorMessage", "Invalid date format");
                            showEditForm(request, response);
                            return;
                        }
                    }
                    
                    // Get existing content
                    Content content = contentDAO.findById(contentId);
                    if (content == null) {
                        request.setAttribute("errorMessage", "Content not found");
                        request.getRequestDispatcher("/error.jsp").forward(request, response);
                        return;
                    }
                    
                    // Update content object
                    content.setType(type);
                    content.setTitle(title);
                    content.setDescription(description);
                    content.setGenre(genre);
                    content.setLanguage(language);
                    content.setReleaseDate(releaseDate);
                    content.setThumbnailUrl(thumbnailUrl);
                    content.setMediaUrl(mediaUrl);
                    
                    // If this is a series, process episodes
                    if ("SERIES".equals(type)) {
                        String[] episodeIds = request.getParameterValues("episodeId");
                        String[] seasons = request.getParameterValues("season");
                        String[] episodeNumbers = request.getParameterValues("episodeNumber");
                        String[] episodeTitles = request.getParameterValues("episodeTitle");
                        String[] episodeMediaUrls = request.getParameterValues("episodeMediaUrl");
                        
                        if (seasons != null && episodeNumbers != null && episodeTitles != null && episodeMediaUrls != null) {
                            List<Episode> episodes = new ArrayList<>();
                            
                            for (int i = 0; i < seasons.length; i++) {
                                if (i < episodeNumbers.length && i < episodeTitles.length && i < episodeMediaUrls.length) {
                                    Episode episode = new Episode();
                                    
                                    // Set episode ID if it exists
                                    if (episodeIds != null && i < episodeIds.length && !episodeIds[i].isEmpty()) {
                                        episode.setEpisodeId(Integer.parseInt(episodeIds[i]));
                                    }
                                    
                                    episode.setSeriesId(contentId);
                                    episode.setSeason(Integer.parseInt(seasons[i]));
                                    episode.setEpisodeNumber(Integer.parseInt(episodeNumbers[i]));
                                    episode.setTitle(episodeTitles[i]);
                                    episode.setMediaUrl(episodeMediaUrls[i]);
                                    episodes.add(episode);
                                }
                            }
                            
                            content.setEpisodes(episodes);
                        }
                    }
                    
                    // Update content
                    boolean success = contentDAO.update(content);
                    
                    if (success) {
                        // Success
                        request.setAttribute("successMessage", "Content updated successfully");
                        response.sendRedirect(request.getContextPath() + "/content/list");
                    } else {
                        // Error
                        request.setAttribute("errorMessage", "Failed to update content");
                        showEditForm(request, response);
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Error: " + e.getMessage());
                    showEditForm(request, response);
                }
                return;
            }
        }
        
        // If not admin, redirect to home
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}