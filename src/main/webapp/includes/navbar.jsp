<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
    <div class="container">
        <div class="header-left">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home.jsp">
                    <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
                </a>
            </div>
            
            <nav class="main-nav">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home.jsp" class="nav-link">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/content/list?type=MOVIE" class="nav-link">Movies</a></li>
                    <li><a href="${pageContext.request.contextPath}/content/list?type=SERIES" class="nav-link">TV Series</a></li>
                    <li><a href="${pageContext.request.contextPath}/trending.jsp" class="nav-link">Trending</a></li>
                    <li><a href="${pageContext.request.contextPath}/watchlist/view" class="nav-link">My List</a></li>
                </ul>
            </nav>
        </div>
        
        <div class="header-right">
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/search/results" method="get">
                    <input type="text" name="query" id="searchInput" placeholder="Titles, people, genres" autocomplete="off">
                    <button type="submit"><i class="fa fa-search"></i></button>
                </form>
                <div id="searchResults" class="search-results"></div>
            </div>
            
            <div class="profile-menu">
                <div class="profile-toggle">
                    <c:if test="${not empty sessionScope.currentProfile}">
                        <img src="${sessionScope.currentProfile.avatarUrl}" alt="${sessionScope.currentProfile.profileName}">
                    </c:if>
                    <c:if test="${empty sessionScope.currentProfile}">
                        <img src="${pageContext.request.contextPath}/images/avatars/default.jpg" alt="Select Profile">
                    </c:if>
                    <span class="caret"></span>
                </div>
                
                <div class="profile-dropdown">
                    <c:if test="${not empty sessionScope.user}">
                        <c:if test="${not empty sessionScope.currentProfile}">
                            <div class="dropdown-profile-info">
                                <img src="${sessionScope.currentProfile.avatarUrl}" alt="${sessionScope.currentProfile.profileName}">
                                <span>${sessionScope.currentProfile.profileName}</span>
                            </div>
                        </c:if>
                        
                        <ul class="dropdown-menu">
                            <c:if test="${not empty sessionScope.user.profiles}">
                                <li class="dropdown-subtitle">Switch Profile</li>
                                <c:forEach var="profile" items="${sessionScope.user.profiles}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/profile/switch?id=${profile.profileId}">
                                            <img src="${profile.avatarUrl}" alt="${profile.profileName}">
                                            <span>${profile.profileName}</span>
                                        </a>
                                    </li>
                                </c:forEach>
                            </c:if>
                            
                            <li><a href="${pageContext.request.contextPath}/profile/manage">Manage Profiles</a></li>
                            <li class="divider"></li>
                            <li><a href="${pageContext.request.contextPath}/account.jsp">Account</a></li>
                            <li><a href="${pageContext.request.contextPath}/subscription.jsp">Subscription</a></li>
                            <li><a href="${pageContext.request.contextPath}/help.jsp">Help Center</a></li>
                            <li class="divider"></li>
                            <li><a href="${pageContext.request.contextPath}/auth/logout">Sign out of StreamFlix</a></li>
                        </ul>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Search AJAX Script -->
<script>
$(document).ready(function() {
    var searchInput = $("#searchInput");
    var searchResults = $("#searchResults");
    
    searchInput.on("keyup", function() {
        var query = $(this).val();
        
        if (query.length >= 2) {
            $.ajax({
                url: "${pageContext.request.contextPath}/search/ajax",
                data: { query: query },
                dataType: "json",
                success: function(data) {
                    var resultsHtml = "";
                    
                    if (data.length > 0) {
                        for (var i = 0; i < data.length; i++) {
                            resultsHtml += '<div class="search-result-item">' +
                                '<a href="${pageContext.request.contextPath}/content/view?id=' + data[i].id + '">' +
                                '<img src="' + data[i].thumbnailUrl + '" alt="' + data[i].title + '">' +
                                '<div class="result-info">' +
                                '<h4>' + data[i].title + '</h4>' +
                                '<span class="result-type">' + data[i].type + '</span>' +
                                '</div>' +
                                '</a>' +
                                '</div>';
                        }
                    } else {
                        resultsHtml = '<div class="no-results">No results found</div>';
                    }
                    
                    searchResults.html(resultsHtml);
                    searchResults.show();
                }
            });
        } else {
            searchResults.hide();
        }
    });
    
    // Hide search results when clicking outside
    $(document).on("click", function(event) {
        if (!$(event.target).closest(".search-bar").length) {
            searchResults.hide();
        }
    });
});
</script>
