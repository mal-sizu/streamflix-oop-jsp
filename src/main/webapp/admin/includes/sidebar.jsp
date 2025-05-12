<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="admin-sidebar">
    <div class="sidebar-header">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                <span class="logo-text">StreamFlix</span>
                <span class="logo-badge">Admin</span>
            </a>
        </div>
    </div>
    
    <nav class="sidebar-nav">
        <ul>
            <li class="${activePage == 'dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li class="${activePage == 'users' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/users.jsp">
                    <i class="fas fa-users"></i>
                    <span>Users</span>
                </a>
            </li>
            <li class="${activePage == 'content' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/content.jsp">
                    <i class="fas fa-film"></i>
                    <span>Content</span>
                </a>
            </li>
            <li class="${activePage == 'categories' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/categories.jsp">
                    <i class="fas fa-tags"></i>
                    <span>Categories</span>
                </a>
            </li>
            <li class="${activePage == 'reviews' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/reviews.jsp">
                    <i class="fas fa-star"></i>
                    <span>Reviews</span>
                </a>
            </li>
            <li class="${activePage == 'subscriptions' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/subscriptions.jsp">
                    <i class="fas fa-credit-card"></i>
                    <span>Subscriptions</span>
                </a>
            </li>
            <li class="${activePage == 'reports' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/reports.jsp">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reports</span>
                </a>
            </li>
            <li class="${activePage == 'settings' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/settings.jsp">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/home.jsp" target="_blank">
            <i class="fas fa-external-link-alt"></i>
            <span>View Site</span>
        </a>
    </div>
</div>