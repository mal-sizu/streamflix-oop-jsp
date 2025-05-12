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
</head>
<body class="admin-page">
    <jsp:include page="../includes/admin-navbar.jsp" />

    <div class="admin-container">
        <jsp:include page="../includes/admin-sidebar.jsp" />
        
        <main class="admin-content">
            <div class="admin-header">
                <h1>Dashboard</h1>
                <div class="date-filter">
                    <label for="dateRange">Time Period:</label>
                    <select id="dateRange" class="form-control">
                        <option value="today">Today</option>
                        <option value="week" selected>Last 7 Days</option>
                        <option value="month">Last 30 Days</option>
                        <option value="year">Last Year</option>
                    </select>
                </div>
            </div>
            
            <div class="dashboard-stats">
                <div class="stat-card">
                    <div class="stat-icon users">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Users</h3>
                        <p class="stat-value">${stats.totalUsers}</p>
                        <p class="stat-change ${stats.userGrowth >= 0 ? 'positive' : 'negative'}">
                            <i class="fas ${stats.userGrowth >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            ${Math.abs(stats.userGrowth)}% from last period
                        </p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon revenue">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Revenue</h3>
                        <p class="stat-value">$${stats.totalRevenue}</p>
                        <p class="stat-change ${stats.revenueGrowth >= 0 ? 'positive' : 'negative'}">
                            <i class="fas ${stats.revenueGrowth >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            ${Math.abs(stats.revenueGrowth)}% from last period
                        </p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon content">
                        <i class="fas fa-film"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Content</h3>
                        <p class="stat-value">${stats.totalContent}</p>
                        <p class="stat-change ${stats.contentGrowth >= 0 ? 'positive' : 'negative'}">
                            <i class="fas ${stats.contentGrowth >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            ${Math.abs(stats.contentGrowth)}% from last period
                        </p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon views">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Views</h3>
                        <p class="stat-value">${stats.totalViews}</p>
                        <p class="stat-change ${stats.viewsGrowth >= 0 ? 'positive' : 'negative'}">
                            <i class="fas ${stats.viewsGrowth >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'}"></i>
                            ${Math.abs(stats.viewsGrowth)}% from last period
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="dashboard-charts">
                <div class="chart-container">
                    <h2>User Growth</h2>
                    <div class="chart" id="userGrowthChart"></div>
                </div>
                
                <div class="chart-container">
                    <h2>Revenue</h2>
                    <div class="chart" id="revenueChart"></div>
                </div>
            </div>
            
            <div class="dashboard-tables">
                <div class="table-container">
                    <div class="table-header">
                        <h2>Top Content</h2>
                        <a href="${pageContext.request.contextPath}/admin/manage-content.jsp" class="view-all">View All</a>
                    </div>
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Views</th>
                                <th>Rating</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="content" items="${topContent}">
                                <tr>
                                    <td>${content.title}</td>
                                    <td>${content.type}</td>
                                    <td>${content.views}</td>
                                    <td>
                                        <div class="rating">
                                            <span class="rating-value">${content.rating}</span>
                                            <i class="fas fa-star"></i>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="table-container">
                    <div class="table-header">
                        <h2>Recent Users</h2>
                        <a href="${pageContext.request.contextPath}/admin/manage-users.jsp" class="view-all">View All</a>
                    </div>
                    <table class="dashboard-table">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Join Date</th>
                                <th>Plan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${recentUsers}">
                                <tr>
                                    <td>${user.firstName} ${user.lastName}</td>
                                    <td>${user.email}</td>
                                    <td><fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy" /></td>
                                    <td>
                                        <span class="plan-badge ${user.subscription.plan.toLowerCase()}">
                                            ${user.subscription.plan}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script src="${pageContext.request.contextPath}/js/charts.js"></script>
    <script>
        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            initUserGrowthChart();
            initRevenueChart();
        });
        
        // Date range filter
        document.getElementById('dateRange').addEventListener('change', function() {
            // This would update the dashboard data based on the selected date range
            // In a real application, this would make an AJAX call to fetch new data
        });
    </script>
</body>
</html>