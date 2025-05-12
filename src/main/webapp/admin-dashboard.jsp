<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body class="admin-page">
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div class="sidebar-header">
                <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
                <h3>Admin Panel</h3>
            </div>
            
            <nav class="sidebar-nav">
                <ul>
                    <li class="active">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i> Users
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/content">
                            <i class="fas fa-film"></i> Content
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/subscriptions">
                            <i class="fas fa-credit-card"></i> Subscriptions
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/stats">
                            <i class="fas fa-chart-bar"></i> Statistics
                        </a>
                    </li>
                    <li class="separator"></li>
                    <li>
                        <a href="${pageContext.request.contextPath}/home.jsp">
                            <i class="fas fa-home"></i> View Site
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/auth/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>
        
        <!-- Main Content -->
        <main class="admin-content">
            <header class="admin-header">
                <div class="admin-header-title">
                    <h1>Dashboard</h1>
                    <p>Welcome back, ${sessionScope.user.name}</p>
                </div>
                
                <div class="admin-header-actions">
                    <div class="admin-profile">
                        <span>${sessionScope.user.name}</span>
                        <img src="${pageContext.request.contextPath}/images/avatars/admin.jpg" alt="Admin">
                    </div>
                </div>
            </header>
            
            <!-- Stats Cards -->
            <section class="stats-cards">
                <div class="stat-card">
                    <div class="stat-icon bg-blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Users</h3>
                        <p class="stat-value">${totalUsers}</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon bg-orange">
                        <i class="fas fa-film"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Content</h3>
                        <p class="stat-value">${totalContent}</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon bg-green">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Subscriptions</h3>
                        <p class="stat-value">${activeSubscriptions}</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon bg-red">
                        <i class="fas fa-tv"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Content by Type</h3>
                        <p class="stat-value">${moviesCount} Movies / ${seriesCount} Series</p>
                    </div>
                </div>
            </section>
            
            <!-- Recent Content -->
            <section class="admin-card">
                <div class="card-header">
                    <h2>Recently Added Content</h2>
                    <a href="${pageContext.request.contextPath}/admin/content" class="btn btn-sm">View All</a>
                </div>
                
                <div class="card-body">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Genre</th>
                                <th>Release Date</th>
                                <th>Rating</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="content" items="${recentContent}">
                                <tr>
                                    <td>${content.title}</td>
                                    <td><span class="badge ${content.type eq 'MOVIE' ? 'bg-blue' : 'bg-orange'}">${content.type}</span></td>
                                    <td>${content.genre}</td>
                                    <td><fmt:formatDate value="${content.releaseDate}" pattern="MMM d, yyyy" /></td>
                                    <td>
                                        <div class="star-rating small">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fa${i <= content.averageRating ? 's' : 'r'} fa-star"></i>
                                            </c:forEach>
                                            <span>(${content.averageRating})</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="btn-icon btn-sm" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/content/edit?id=${content.contentId}" class="btn-icon btn-sm" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>
            
            <!-- Top Rated Content -->
            <section class="admin-card">
                <div class="card-header">
                    <h2>Top Rated Content</h2>
                    <a href="${pageContext.request.contextPath}/admin/stats" class="btn btn-sm">View Stats</a>
                </div>
                
                <div class="card-body">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Genre</th>
                                <th>Release Date</th>
                                <th>Rating</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="content" items="${topRatedContent}">
                                <tr>
                                    <td>${content.title}</td>
                                    <td><span class="badge ${content.type eq 'MOVIE' ? 'bg-blue' : 'bg-orange'}">${content.type}</span></td>
                                    <td>${content.genre}</td>
                                    <td><fmt:formatDate value="${content.releaseDate}" pattern="MMM d, yyyy" /></td>
                                    <td>
                                        <div class="star-rating small">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fa${i <= content.averageRating ? 's' : 'r'} fa-star"></i>
                                            </c:forEach>
                                            <span>(${content.averageRating})</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="btn-icon btn-sm" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/content/edit?id=${content.contentId}" class="btn-icon btn-sm" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>
            
            <!-- Quick Actions -->
            <section class="admin-card">
                <div class="card-header">
                    <h2>Quick Actions</h2>
                </div>
                
                <div class="card-body">
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/content/add" class="quick-action-item">
                            <i class="fas fa-plus-circle"></i>
                            <span>Add Content</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/user/add" class="quick-action-item">
                            <i class="fas fa-user-plus"></i>
                            <span>Add User</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/generate-report" class="quick-action-item">
                            <i class="fas fa-chart-line"></i>
                            <span>Generate Report</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/send-newsletter" class="quick-action-item">
                            <i class="fas fa-envelope"></i>
                            <span>Send Newsletter</span>
                        </a>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
