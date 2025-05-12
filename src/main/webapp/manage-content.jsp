<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Content - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-page">
    <jsp:include page="includes/admin-navbar.jsp" />

    <div class="admin-container">
        <jsp:include page="includes/admin-sidebar.jsp" />
        
        <main class="admin-content">
            <div class="admin-header">
                <h1>Manage Content</h1>
                <div class="admin-actions">
                    <a href="${pageContext.request.contextPath}/admin/add-content.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Content
                    </a>
                </div>
            </div>
            
            <div class="admin-filters">
                <div class="filter-group">
                    <label for="contentTypeFilter">Content Type:</label>
                    <select id="contentTypeFilter" class="form-control">
                        <option value="all">All Types</option>
                        <option value="MOVIE">Movies</option>
                        <option value="SERIES">TV Series</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="genreFilter">Genre:</label>
                    <select id="genreFilter" class="form-control">
                        <option value="all">All Genres</option>
                        <c:forEach var="genre" items="${genres}">
                            <option value="${genre.id}">${genre.name}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="statusFilter">Status:</label>
                    <select id="statusFilter" class="form-control">
                        <option value="all">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="INACTIVE">Inactive</option>
                        <option value="COMING_SOON">Coming Soon</option>
                    </select>
                </div>
                
                <div class="search-group">
                    <input type="text" id="contentSearch" placeholder="Search content..." class="form-control">
                    <button id="searchBtn" class="btn btn-secondary">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <div class="content-table-container">
                <table class="content-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Thumbnail</th>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Genre</th>
                            <th>Release Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="content" items="${contentList}">
                            <tr>
                                <td>${content.contentId}</td>
                                <td>
                                    <div class="content-thumbnail">
                                        <img src="${content.thumbnailUrl}" alt="${content.title}">
                                    </div>
                                </td>
                                <td>${content.title}</td>
                                <td>${content.type}</td>
                                <td>${content.genre.name}</td>
                                <td><fmt:formatDate value="${content.releaseDate}" pattern="MMM dd, yyyy" /></td>
                                <td>
                                    <span class="status-badge status-${content.status.toLowerCase()}">
                                        ${content.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/admin/edit-content.jsp?id=${content.contentId}" class="btn btn-sm btn-edit" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/content/view?id=${content.contentId}" class="btn btn-sm btn-view" title="View" target="_blank">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn btn-sm btn-delete" onclick="deleteContent(${content.contentId})" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage - 1}" class="page-link">
                        <i class="fas fa-chevron-left"></i> Previous
                    </a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                    <a href="?page=${pageNum}" class="page-link ${pageNum == currentPage ? 'active' : ''}">
                        ${pageNum}
                    </a>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage + 1}" class="page-link">
                        Next <i class="fas fa-chevron-right"></i>
                    </a>
                </c:if>
            </div>
        </main>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Deletion</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this content? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <form id="deleteForm" action="${pageContext.request.contextPath}/admin/content/delete" method="post">
                    <input type="hidden" id="deleteContentId" name="contentId">
                    <button type="button" class="btn btn-secondary" id="cancelDelete">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        function deleteContent(contentId) {
            document.getElementById('deleteContentId').value = contentId;
            document.getElementById('deleteModal').style.display = 'block';
        }
        
        document.querySelector('.close').addEventListener('click', function() {
            document.getElementById('deleteModal').style.display = 'none';
        });
        
        document.getElementById('cancelDelete').addEventListener('click', function() {
            document.getElementById('deleteModal').style.display = 'none';
        });
        
        // Filter functionality
        document.getElementById('contentTypeFilter').addEventListener('change', filterContent);
        document.getElementById('genreFilter').addEventListener('change', filterContent);
        document.getElementById('statusFilter').addEventListener('change', filterContent);
        document.getElementById('searchBtn').addEventListener('click', filterContent);
        
        function filterContent() {
            // Implementation would be in admin.js
        }
    </script>
</body>
</html>