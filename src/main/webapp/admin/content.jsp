<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Content Management - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body class="admin-page">
    <div class="admin-container">
        <c:set var="activePage" value="content" scope="request" />
        <jsp:include page="includes/sidebar.jsp" />
        
        <div class="admin-content">
            <div class="admin-header">
                <h1>Content Management</h1>
                <div class="admin-actions">
                    <a href="${pageContext.request.contextPath}/admin/content-form.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add New Content
                    </a>
                </div>
            </div>
            
            <div class="content-filters">
                <div class="filter-group">
                    <label for="contentTypeFilter">Type:</label>
                    <select id="contentTypeFilter">
                        <option value="all">All Types</option>
                        <option value="movie">Movies</option>
                        <option value="series">TV Series</option>
                        <option value="documentary">Documentaries</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="genreFilter">Genre:</label>
                    <select id="genreFilter">
                        <option value="all">All Genres</option>
                        <c:forEach items="${genres}" var="genre">
                            <option value="${genre.id}">${genre.name}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="yearFilter">Year:</label>
                    <select id="yearFilter">
                        <option value="all">All Years</option>
                        <c:forEach items="${years}" var="year">
                            <option value="${year}">${year}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group search">
                    <input type="text" id="contentSearch" placeholder="Search titles...">
                    <button id="searchBtn" class="btn btn-small">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <div class="content-table-container">
                <table class="admin-table content-table">
                    <thead>
                        <tr>
                            <th class="thumbnail-col">Thumbnail</th>
                            <th class="title-col">Title</th>
                            <th>Type</th>
                            <th>Year</th>
                            <th>Genres</th>
                            <th>Rating</th>
                            <th>Views</th>
                            <th class="actions-col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${contentList}" var="content">
                            <tr>
                                <td class="thumbnail-col">
                                    <img src="${content.thumbnailUrl}" alt="${content.title}" class="content-thumbnail">
                                </td>
                                <td class="title-col">${content.title}</td>
                                <td>
                                    <span class="badge ${content.type.toLowerCase()}">${content.type}</span>
                                </td>
                                <td>${content.releaseYear}</td>
                                <td>
                                    <div class="genre-tags">
                                        <c:forEach items="${content.genres}" var="genre" varStatus="status">
                                            ${genre.name}${!status.last ? ', ' : ''}
                                        </c:forEach>
                                    </div>
                                </td>
                                <td>
                                    <div class="rating-display">
                                        <span class="rating-value">${content.averageRating}</span>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="star">
                                                <i class="fas fa-star ${star <= content.averageRating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </td>
                                <td>${content.viewCount}</td>
                                <td class="actions-col">
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/content-form.jsp?id=${content.id}" class="btn-icon" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/content-details.jsp?id=${content.id}" class="btn-icon" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn-icon delete-btn" data-id="${content.id}" title="Delete">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}${queryParams}" class="page-link">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <a href="?page=${pageNum}${queryParams}" class="page-link ${pageNum == currentPage ? 'active' : ''}">
                            ${pageNum}
                        </a>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}${queryParams}" class="page-link">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Confirm Deletion</h2>
                <span class="close-modal">&times;</span>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this content? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button id="cancelDelete" class="btn btn-outline">Cancel</button>
                <button id="confirmDelete" class="btn btn-danger">Delete</button>
            </div>
        </div>
    </div>
    
    <script>
        // Filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const typeFilter = document.getElementById('contentTypeFilter');
            const genreFilter = document.getElementById('genreFilter');
            const yearFilter = document.getElementById('yearFilter');
            const searchInput = document.getElementById('contentSearch');
            const searchBtn = document.getElementById('searchBtn');
            
            // Apply filters when changed
            function applyFilters() {
                const type = typeFilter.value;
                const genre = genreFilter.value;
                const year = yearFilter.value;
                const search = searchInput.value.trim();
                
                let url = '${pageContext.request.contextPath}/admin/content.jsp?';
                
                if (type !== 'all') url += `&type=${type}`;
                if (genre !== 'all') url += `&genre=${genre}`;
                if (year !== 'all') url += `&year=${year}`;
                if (search !== '') url += `&search=${encodeURIComponent(search)}`;
                
                window.location.href = url;
            }
            
            typeFilter.addEventListener('change', applyFilters);
            genreFilter.addEventListener('change', applyFilters);
            yearFilter.addEventListener('change', applyFilters);
            searchBtn.addEventListener('click', applyFilters);
            
            // Also apply filters when pressing Enter in search box
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilters();
                }
            });
            
            // Set filter values from URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('type')) typeFilter.value = urlParams.get('type');
            if (urlParams.has('genre')) genreFilter.value = urlParams.get('genre');
            if (urlParams.has('year')) yearFilter.value = urlParams.get('year');
            if (urlParams.has('search')) searchInput.value = urlParams.get('search');
            
            // Delete modal functionality
            const deleteModal = document.getElementById('deleteModal');
            const closeModal = document.querySelector('.close-modal');
            const cancelDelete = document.getElementById('cancelDelete');
            const confirmDelete = document.getElementById('confirmDelete');
            const deleteButtons = document.querySelectorAll('.delete-btn');
            
            let contentIdToDelete = null;
            
            // Open modal when delete button is clicked
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    contentIdToDelete = this.getAttribute('data-id');
                    deleteModal.style.display = 'block';
                });
            });
            
            // Close modal functions
            function closeDeleteModal() {
                deleteModal.style.display = 'none';
                contentIdToDelete = null;
            }
            
            closeModal.addEventListener('click', closeDeleteModal);
            cancelDelete.addEventListener('click', closeDeleteModal);
            
            // Handle delete confirmation
            confirmDelete.addEventListener('click', function() {
                if (contentIdToDelete) {
                    window.location.href = `${pageContext.request.contextPath}/admin/content/delete?id=${contentIdToDelete}`;
                }
            });
            
            // Close modal if clicked outside
            window.addEventListener('click', function(event) {
                if (event.target === deleteModal) {
                    closeDeleteModal();
                }
            });
        });
    </script>
</body>
</html>