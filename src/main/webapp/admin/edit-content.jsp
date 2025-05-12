<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Content - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-page">
    <jsp:include page="../includes/admin-navbar.jsp" />

    <div class="admin-container">
        <jsp:include page="../includes/admin-sidebar.jsp" />
        
        <main class="admin-content">
            <div class="admin-header">
                <h1>Edit Content: ${content.title}</h1>
                <div class="admin-actions">
                    <a href="${pageContext.request.contextPath}/admin/manage-content.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Content List
                    </a>
                </div>
            </div>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    ${errorMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    ${successMessage}
                </div>
            </c:if>
            
            <div class="content-form-container">
                <form action="${pageContext.request.contextPath}/admin/content/update" method="post" enctype="multipart/form-data" class="content-form">
                    <input type="hidden" name="contentId" value="${content.contentId}">
                    
                    <div class="form-section">
                        <h2>Basic Information</h2>
                        
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" value="${content.title}" required class="form-control">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="contentType">Content Type</label>
                                <select id="contentType" name="contentType" required class="form-control">
                                    <option value="MOVIE" ${content.type eq 'MOVIE' ? 'selected' : ''}>Movie</option>
                                    <option value="SERIES" ${content.type eq 'SERIES' ? 'selected' : ''}>TV Series</option>
                                </select>
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="genre">Genre</label>
                                <select id="genre" name="genreId" required class="form-control">
                                    <c:forEach var="genre" items="${genres}">
                                        <option value="${genre.id}" ${content.genre.id eq genre.id ? 'selected' : ''}>
                                            ${genre.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="releaseDate">Release Date</label>
                                <input type="date" id="releaseDate" name="releaseDate" 
                                       value="<fmt:formatDate value='${content.releaseDate}' pattern='yyyy-MM-dd' />" 
                                       required class="form-control">
                            </div>
                            
                            <div class="form-group col-6 ${content.type eq 'SERIES' ? 'disabled' : ''}">
                                <label for="duration">Duration (minutes)</label>
                                <input type="number" id="duration" name="duration" min="1" 
                                       value="${content.duration}" class="form-control"
                                       ${content.type eq 'MOVIE' ? 'required' : ''}>
                                <small class="form-text text-muted">For movies only</small>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4" required class="form-control">${content.description}</textarea>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h2>Media</h2>
                        
                        <div class="form-group">
                            <label for="thumbnailFile">Thumbnail Image</label>
                            <div class="current-media">
                                <img src="${content.thumbnailUrl}" alt="Current Thumbnail" class="thumbnail-preview">
                                <p>Current thumbnail</p>
                            </div>
                            <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*" class="form-control-file">
                            <small class="form-text text-muted">Leave empty to keep current thumbnail</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="bannerFile">Banner Image</label>
                            <div class="current-media">
                                <img src="${content.bannerUrl}" alt="Current Banner" class="banner-preview">
                                <p>Current banner</p>
                            </div>
                            <input type="file" id="bannerFile" name="bannerFile" accept="image/*" class="form-control-file">
                            <small class="form-text text-muted">Leave empty to keep current banner</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="trailerUrl">Trailer URL</label>
                            <input type="url" id="trailerUrl" name="trailerUrl" value="${content.trailerUrl}" class="form-control" placeholder="https://">
                        </div>
                        
                        <div class="form-group" id="videoFileGroup" ${content.type eq 'SERIES' ? 'style="display: none;"' : ''}>
                            <label for="videoFile">Video File</label>
                            <c:if test="${not empty content.videoUrl}">
                                <div class="current-media">
                                    <p>Current video: ${content.videoUrl}</p>
                                </div>
                            </c:if>
                            <input type="file" id="videoFile" name="videoFile" accept="video/*" class="form-control-file">
                            <small class="form-text text-muted">Leave empty to keep current video</small>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h2>Additional Information</h2>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="language">Language</label>
                                <input type="text" id="language" name="language" value="${content.language}" class="form-control">
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="status">Status</label>
                                <select id="status" name="status" required class="form-control">
                                    <option value="ACTIVE" ${content.status eq 'ACTIVE' ? 'selected' : ''}>Active</option>
                                    <option value="INACTIVE" ${content.status eq 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                    <option value="COMING_SOON" ${content.status eq 'COMING_SOON' ? 'selected' : ''}>Coming Soon</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="cast">Cast (comma separated)</label>
                            <input type="text" id="cast" name="cast" value="${content.cast}" class="form-control" placeholder="Actor 1, Actor 2, Actor 3">
                        </div>
                        
                        <div class="form-group">
                            <label for="director">Director</label>
                            <input type="text" id="director" name="director" value="${content.director}" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="ageRating">Age Rating</label>
                            <select id="ageRating" name="ageRating" class="form-control">
                                <option value="G" ${content.ageRating eq 'G' ? 'selected' : ''}>G (General Audiences)</option>
                                <option value="PG" ${content.ageRating eq 'PG' ? 'selected' : ''}>PG (Parental Guidance Suggested)</option>
                                <option value="PG-13" ${content.ageRating eq 'PG-13' ? 'selected' : ''}>PG-13 (Parents Strongly Cautioned)</option>
                                <option value="R" ${content.ageRating eq 'R' ? 'selected' : ''}>R (Restricted)</option>
                                <option value="NC-17" ${content.ageRating eq 'NC-17' ? 'selected' : ''}>NC-17 (Adults Only)</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- TV Series Specific Section -->
                    <div class="form-section" id="seriesSection" ${content.type eq 'SERIES' ? '' : 'style="display: none;"'}>
                        <h2>TV Series Information</h2>
                        
                        <div class="form-group">
                            <label for="totalSeasons">Total Seasons</label>
                            <input type="number" id="totalSeasons" name="totalSeasons" min="1" value="${content.totalSeasons}" class="form-control">
                        </div>
                        
                        <div class="episodes-management">
                            <h3>Manage Episodes</h3>
                            <p>You can manage episodes for this series from the episodes management page.</p>
                            <a href="${pageContext.request.contextPath}/admin/manage-episodes.jsp?contentId=${content.contentId}" class="btn btn-secondary">
                                <i class="fas fa-film"></i> Manage Episodes
                            </a>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="reset" class="btn btn-secondary">Reset</button>
                        <button type="submit" class="btn btn-primary">Update Content</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
    <script>
        // Toggle between movie and TV series fields
        document.getElementById('contentType').addEventListener('change', function() {
            const contentType = this.value;
            const seriesSection = document.getElementById('seriesSection');
            const durationField = document.getElementById('duration');
            const durationGroup = durationField.parentElement;
            const videoFileGroup = document.getElementById('videoFileGroup');
            
            if (contentType === 'SERIES') {
                seriesSection.style.display = 'block';
                durationField.required = false;
                durationGroup.classList.add('disabled');
                videoFileGroup.style.display = 'none';
            } else if (contentType === 'MOVIE') {
                seriesSection.style.display = 'none';
                durationField.required = true;
                durationGroup.classList.remove('disabled');
                videoFileGroup.style.display = 'block';
            }
        });
    </script>
</body>
</html>