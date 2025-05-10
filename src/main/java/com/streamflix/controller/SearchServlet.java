package com.streamflix.controller;

import com.streamflix.dao.ContentDAO;
import com.streamflix.dao.ContentDAOImpl;
import com.streamflix.model.Content;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet for handling search operations
 */
public class SearchServlet extends HttpServlet {

    private ContentDAO contentDAO;
    
    @Override
    public void init() throws ServletException {
        contentDAO = new ContentDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/form";
        }
        
        switch (action) {
            case "/form":
                showSearchForm(request, response);
                break;
            case "/results":
                searchContent(request, response);
                break;
            case "/filter":
                filterContent(request, response);
                break;
            case "/ajax":
                ajaxSearch(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/search/form");
                break;
        }
    }
    
    /**
     * Show search form
     */
    private void showSearchForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
    
    /**
     * Search content based on query
     */
    private void searchContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        
        if (query != null && !query.trim().isEmpty()) {
            List<Content> results = contentDAO.search(query);
            request.setAttribute("results", results);
            request.setAttribute("query", query);
        }
        
        request.getRequestDispatcher("/results.jsp").forward(request, response);
    }
    
    /**
     * Filter content based on criteria
     */
    private void filterContent(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        String genre = request.getParameter("genre");
        String language = request.getParameter("language");
        
        List<Content> results = null;
        
        if (type != null && !type.isEmpty()) {
            results = contentDAO.findByType(type);
        } else if (genre != null && !genre.isEmpty()) {
            results = contentDAO.findByGenre(genre);
        } else if (language != null && !language.isEmpty()) {
            results = contentDAO.findByLanguage(language);
        } else {
            results = contentDAO.findAll();
        }
        
        request.setAttribute("results", results);
        request.setAttribute("type", type);
        request.setAttribute("genre", genre);
        request.setAttribute("language", language);
        
        request.getRequestDispatcher("/results.jsp").forward(request, response);
    }
    
    /**
     * AJAX search for auto-complete
     */
    private void ajaxSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            if (query != null && !query.trim().isEmpty()) {
                List<Content> results = contentDAO.search(query);
                
                JSONArray jsonArray = new JSONArray();
                
                for (Content content : results) {
                    JSONObject jsonContent = new JSONObject();
                    jsonContent.put("id", content.getContentId());
                    jsonContent.put("title", content.getTitle());
                    jsonContent.put("type", content.getType());
                    jsonContent.put("thumbnailUrl", content.getThumbnailUrl());
                    
                    jsonArray.put(jsonContent);
                }
                
                out.print(jsonArray.toString());
            } else {
                out.print("[]");
            }
        }
    }
}
