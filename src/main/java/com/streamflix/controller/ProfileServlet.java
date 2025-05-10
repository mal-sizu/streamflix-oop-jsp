package com.streamflix.controller;

import com.streamflix.dao.ProfileDAO;
import com.streamflix.dao.ProfileDAOImpl;
import com.streamflix.model.Profile;
import com.streamflix.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling profile operations
 */
public class ProfileServlet extends HttpServlet {

    private ProfileDAO profileDAO;
    
    @Override
    public void init() throws ServletException {
        profileDAO = new ProfileDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/select";
        }
        
        switch (action) {
            case "/select":
                showProfileSelection(request, response);
                break;
            case "/manage":
                showManageProfiles(request, response);
                break;
            case "/add":
                showAddProfileForm(request, response);
                break;
            case "/edit":
                showEditProfileForm(request, response);
                break;
            case "/delete":
                deleteProfile(request, response);
                break;
            case "/switch":
                switchProfile(request, response);
                break;
            case "/parental-controls":
                showParentalControls(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/select");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/select";
        }
        
        switch (action) {
            case "/add":
                addProfile(request, response);
                break;
            case "/update":
                updateProfile(request, response);
                break;
            case "/parental-controls":
                updateParentalControls(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/select");
                break;
        }
    }
    
    /**
     * Show profile selection screen
     */
    private void showProfileSelection(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            List<Profile> profiles = profileDAO.findByUserId(user.getUserId());
            
            request.setAttribute("profiles", profiles);
            request.getRequestDispatcher("/manage-profiles.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Show manage profiles screen
     */
    private void showManageProfiles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            List<Profile> profiles = profileDAO.findByUserId(user.getUserId());
            
            request.setAttribute("profiles", profiles);
            request.setAttribute("manageMode", true);
            request.getRequestDispatcher("/manage-profiles.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Show add profile form
     */
    private void showAddProfileForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Show edit profile form
     */
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            int profileId = Integer.parseInt(request.getParameter("id"));
            Profile profile = profileDAO.findById(profileId);
            
            if (profile != null) {
                // Verify the profile belongs to the current user
                User user = (User) session.getAttribute("user");
                if (profile.getUserId() == user.getUserId()) {
                    request.setAttribute("profile", profile);
                    request.getRequestDispatcher("/profile.jsp").forward(request, response);
                    return;
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/profile/manage");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Delete a profile
     */
    private void deleteProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            int profileId = Integer.parseInt(request.getParameter("id"));
            Profile profile = profileDAO.findById(profileId);
            
            if (profile != null) {
                // Verify the profile belongs to the current user
                User user = (User) session.getAttribute("user");
                if (profile.getUserId() == user.getUserId()) {
                    profileDAO.delete(profileId);
                    
                    // If the deleted profile is the current profile, remove it from session
                    if (session.getAttribute("currentProfile") != null) {
                        Profile currentProfile = (Profile) session.getAttribute("currentProfile");
                        if (currentProfile.getProfileId() == profileId) {
                            session.removeAttribute("currentProfile");
                        }
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/profile/manage");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Switch to a different profile
     */
    private void switchProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            int profileId = Integer.parseInt(request.getParameter("id"));
            Profile profile = profileDAO.findById(profileId);
            
            if (profile != null) {
                // Verify the profile belongs to the current user
                User user = (User) session.getAttribute("user");
                if (profile.getUserId() == user.getUserId()) {
                    session.setAttribute("currentProfile", profile);
                    response.sendRedirect(request.getContextPath() + "/home.jsp");
                    return;
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/profile/select");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Show parental controls settings
     */
    private void showParentalControls(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/parental-controls.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Add a new profile
     */
    private void addProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            String profileName = request.getParameter("profileName");
            String avatarUrl = request.getParameter("avatarUrl");
            int ageLimit = Integer.parseInt(request.getParameter("ageLimit"));
            
            // Validate input
            if (profileName == null || profileName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Profile name is required");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            
            // Check if user already has too many profiles
            List<Profile> existingProfiles = profileDAO.findByUserId(user.getUserId());
            if (existingProfiles.size() >= 5) {
                request.setAttribute("errorMessage", "Maximum number of profiles reached (5)");
                response.sendRedirect(request.getContextPath() + "/profile/manage");
                return;
            }
            
            // Create and save profile
            Profile profile = new Profile(user.getUserId(), profileName, avatarUrl, ageLimit);
            profile = profileDAO.save(profile);
            
            if (profile.getProfileId() > 0) {
                // Success
                response.sendRedirect(request.getContextPath() + "/profile/manage");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to create profile");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Update an existing profile
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            int profileId = Integer.parseInt(request.getParameter("profileId"));
            String profileName = request.getParameter("profileName");
            String avatarUrl = request.getParameter("avatarUrl");
            int ageLimit = Integer.parseInt(request.getParameter("ageLimit"));
            
            // Validate input
            if (profileName == null || profileName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Profile name is required");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }
            
            // Get existing profile
            Profile profile = profileDAO.findById(profileId);
            
            if (profile != null && profile.getUserId() == user.getUserId()) {
                // Update profile
                profile.setProfileName(profileName);
                profile.setAvatarUrl(avatarUrl);
                profile.setAgeLimit(ageLimit);
                
                boolean success = profileDAO.update(profile);
                
                if (success) {
                    // If this is the current profile, update the session
                    if (session.getAttribute("currentProfile") != null) {
                        Profile currentProfile = (Profile) session.getAttribute("currentProfile");
                        if (currentProfile.getProfileId() == profileId) {
                            session.setAttribute("currentProfile", profile);
                        }
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/profile/manage");
                } else {
                    request.setAttribute("errorMessage", "Failed to update profile");
                    request.setAttribute("profile", profile);
                    request.getRequestDispatcher("/profile.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/profile/manage");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    /**
     * Update parental controls
     */
    private void updateParentalControls(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null && session.getAttribute("currentProfile") != null) {
            Profile profile = (Profile) session.getAttribute("currentProfile");
            
            int ageLimit = Integer.parseInt(request.getParameter("ageLimit"));
            
            // Update profile
            profile.setAgeLimit(ageLimit);
            
            boolean success = profileDAO.update(profile);
            
            if (success) {
                // Update the session
                session.setAttribute("currentProfile", profile);
                request.setAttribute("successMessage", "Parental controls updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update parental controls");
            }
            
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/parental-controls.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}