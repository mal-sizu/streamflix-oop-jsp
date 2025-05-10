package com.streamflix.controller;

import com.streamflix.dao.WatchlistDAO;
import com.streamflix.dao.WatchlistDAOImpl;
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
 * Servlet for handling watchlist operations
 */
public class WatchlistServlet extends HttpServlet {

    private WatchlistDAO watchlistDAO;
    
    @Override
    public void init() throws ServletException {
        watchlistDAO = new WatchlistDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/view";
        }
        
        switch (action) {
            case "/view":
                viewWatchlist(request, response);
                break;
            case "/add":
                addToWatchlist(request, response);
                break;
            case "/remove":
                removeFromWatchlist(request, response);
                break;
            case "/check":
                checkInWatchlist(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/watchlist/view");
                break;
        }
    }
    
    /**
     * View watchlist
     */
    private void viewWatchlist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            List<Content> watchlist = watchlistDAO.findByProfileId(profile.getProfileId());
            
            request.setAttribute("watchlist", watchlist);
            request.getRequestDispatcher("/watchlist.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Add to watchlist
     */
    private void addToWatchlist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            int contentId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = watchlistDAO.addToWatchlist(profile.getProfileId(), contentId);
            
            // Check if this is an AJAX request
            String xRequestedWith = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            if (isAjax) {
                // Send JSON response
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":" + success + "}");
                out.flush();
            } else {
                // Redirect to previous page or watchlist
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/watchlist/view");
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Remove from watchlist
     */
    private void removeFromWatchlist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            int contentId = Integer.parseInt(request.getParameter("id"));
            
            boolean success = watchlistDAO.removeFromWatchlist(profile.getProfileId(), contentId);
            
            // Check if this is an AJAX request
            String xRequestedWith = request.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            if (isAjax) {
                // Send JSON response
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":" + success + "}");
                out.flush();
            } else {
                // Redirect to previous page or watchlist
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(request.getContextPath() + "/watchlist/view");
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Check if content is in watchlist
     */
    private void checkInWatchlist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            int contentId = Integer.parseInt(request.getParameter("id"));
            
            boolean inWatchlist = watchlistDAO.isInWatchlist(profile.getProfileId(), contentId);
            
            // Send JSON response
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"inWatchlist\":" + inWatchlist + "}");
            out.flush();
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"User not logged in\"}");
            out.flush();
        }
    }
}
