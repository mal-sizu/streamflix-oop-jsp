package com.streamflix.controller;

import com.streamflix.dao.ContentDAO;
import com.streamflix.dao.ContentDAOImpl;
import com.streamflix.model.Content;
import com.streamflix.model.Episode;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for handling video player operations
 */
public class PlayerServlet extends HttpServlet {

    private ContentDAO contentDAO;
    
    @Override
    public void init() throws ServletException {
        contentDAO = new ContentDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/play";
        }
        
        switch (action) {
            case "/play":
                playContent(request, response);
                break;
            case "/episode":
                playEpisode(request, response);
                break;
            case "/pip":
                playInPictureInPicture(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                break;
        }
    }
    
    /**
     * Play content (movie)
     */
    private void playContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("id"));
        Content content = contentDAO.findById(contentId);
        
        if (content != null) {
            request.setAttribute("content", content);
            request.getRequestDispatcher("/player.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Content not found");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Play episode (series)
     */
    private void playEpisode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contentId = Integer.parseInt(request.getParameter("contentId"));
        int season = Integer.parseInt(request.getParameter("season"));
        int episodeNumber = Integer.parseInt(request.getParameter("episode"));
        
        Content content = contentDAO.findWithEpisodes(contentId);
        
        if (content != null && content.getEpisodes() != null) {
            Episode selectedEpisode = null;
            
            for (Episode episode : content.getEpisodes()) {
                if (episode.getSeason() == season && episode.getEpisodeNumber() == episodeNumber) {
                    selectedEpisode = episode;
                    break;
                }
            }
            
            if (selectedEpisode != null) {
                request.setAttribute("content", content);
                request.setAttribute("episode", selectedEpisode);
                request.getRequestDispatcher("/player.jsp").forward(request, response);
                return;
            }
        }
        
        request.setAttribute("errorMessage", "Episode not found");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    
    /**
     * Play in Picture-in-Picture mode
     */
    private void playInPictureInPicture(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Similar to playContent or playEpisode, but with PiP flag
        request.setAttribute("pipMode", true);
        
        if (request.getParameter("episodeId") != null) {
            // Play episode in PiP
            playEpisode(request, response);
        } else {
            // Play content in PiP
            playContent(request, response);
        }
    }
}
