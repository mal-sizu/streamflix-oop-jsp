package com.streamflix.filter;

import com.streamflix.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter to check if user is an admin
 */
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        boolean isAdmin = false;
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            isAdmin = user.isAdmin();
        }
        
        if (isAdmin) {
            // User is an admin, continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not an admin, redirect to home page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home.jsp");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code
    }
}
