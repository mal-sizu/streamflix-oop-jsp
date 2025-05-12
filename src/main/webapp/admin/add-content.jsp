<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Content - StreamFlix Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body class="admin-page">
    <jsp:include page="../includes/admin-navbar.jsp" />

    <div class="admin-container">
        <jsp:include page="../includes/admin-sidebar.jsp" />
        
        <main class="admin-content">
            <div class="admin-header">
                <h1>Add New Content</h1>
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
            
            <div class="content-form-container">
                <form action="${pageContext.request.contextPath}/admin/content/add" method="post" enctype="multipart/form-data" class="content-form">
                    <div class="form-section">
                        <h2>Basic Information</h2>
                        
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" required class="form-control">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="contentType">Content Type</label>
                                <select id="contentType" name="contentType" required class="form-control">
                                    <option value="">Select Type</option>
                                    <option value="MOVIE">Movie</option>
                                    <option value="SERIES">TV Series</option>
                                </select>
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="genre">Genre</label>
                                <select id="genre" name="genreId" required class="form-control">
                                    <option value="">Select Genre</option>
                                    <c:forEach var="genre" items="${genres}">
                                        <option value="${genre.id}">${genre.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="releaseDate">Release Date</label>
                                <input type="date" id="releaseDate" name="releaseDate" required class="form-control">
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="duration">Duration (minutes)</label>
                                <input type="number" id="duration" name="duration" min="1" class="form-control">
                                <small class="form-text text-muted">For movies only</small>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4" required class="form-control"></textarea>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h2>Media</h2>
                        
                        <div class="form-group">
                            <label for="thumbnailFile">Thumbnail Image</label>
                            <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*" class="form-control-file">
                        </div>
                        
                        <div class="form-group">
                            <label for="bannerFile">Banner Image</label>
                            <input type="file" id="bannerFile" name="bannerFile" accept="image/*" class="form-control-file">
                        </div>
                        
                        <div class="form-group" id="trailerUrlGroup">
                            <label for="trailerUrl">Trailer URL</label>
                            <input type="url" id="trailerUrl" name="trailerUrl" class="form-control" placeholder="https://">
                        </div>
                        
                        <div class="form-group" id="videoFileGroup">
                            <label for="videoFile">Video File</label>
                            <input type="file" id="videoFile" name="videoFile" accept="video/*" class="form-control-file">
                            <small class="form-text text-muted">For movies only</small>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <h2>Additional Information</h2>
                        
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="language">Language</label>
                                <input type="text" id="language" name="language" class="form-control">
                            </div>
                            
                            <div class="form-group col-6">
                                <label for="status">Status</label>
                                <select id="status" name="status" required class="form-control">
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                    <option value="COMING_SOON">Coming Soon</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="cast">Cast (comma separated)</label>
                            <input type="text" id="cast" name="cast" class="form-control" placeholder="Actor 1, Actor 2, Actor 3">
                        </div>
                        
                        <div class="form-group">
                            <label for="director">Director</label>
                            <input type="text" id="director" name="director" class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="ageRating">Age Rating</label>
                            <select id="ageRating" name="ageRating" class="form-control">
                                <option value="G">G (General Audiences)</option>
                                <option value="PG">PG (Parental Guidance Suggested)</option>
                                <option value="PG-13">PG-13 (Parents Strongly Cautioned)</option>
                                <option value="R">R (Restricted)</option>
                                <option value="NC-17">NC-17 (Adults Only)</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- TV Series Specific Section -->
                    <div class="form-section" id="seriesSection" style="display: none;">
                        <h2>TV Series Information</h2>
                        
                        <div class="form-group">
                            <label for="totalSeasons">Total Seasons</label>
                            <input type="number" id="totalSeasons" name="totalSeasons" min="1" class="form-control">
                        </div>
                        
                        <div id="episodesContainer">
                            <!-- Episodes will be added dynamically via JavaScript -->
                        </div>
                        
                        <button type="button" id="addSeasonBtn" class="btn btn-secondary">
                            <i class="fas fa-plus"></i> Add Season
                        </button>
                    </div>
                    
                    <div class="form-actions">
                        <button type="reset" class="btn btn-secondary">Reset</button>
                        <button type="submit" class="btn btn-primary">Save Content</button>
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
            const videoFileGroup = document.getElementById('videoFileGroup');
            
            if (contentType === 'SERIES') {
                seriesSection.style.display = 'block';
                durationField.required = false;
                durationField.parentElement.classList.add('disabled');
                videoFileGroup.style.display = 'none';
            } else if (contentType === 'MOVIE') {
                seriesSection.style.display = 'none';
                durationField.required = true;
                durationField.parentElement.classList.remove('disabled');
                videoFileGroup.style.display = 'block';
            }
        });
        
        // Add season button functionality
        document.getElementById('addSeasonBtn').addEventListener('click', function() {
            const totalSeasons = parseInt(document.getElementById('totalSeasons').value) || 0;
            if (totalSeasons <= 0) {
                alert('Please enter the total number of seasons first.');
                return;
            }
            
            const episodesContainer = document.getElementById('episodesContainer');
            episodesContainer.innerHTML = '';
            
            for (let i = 1; i <= totalSeasons; i++) {
                const seasonDiv = document.createElement('div');
                seasonDiv.className = 'season-container';
                seasonDiv.innerHTML = `
                    <h3>Season ${i}</h3>
                    <div class="form-group">
                        <label for="episodeCount${i}">Number of Episodes</label>
                        <input type="number" id="episodeCount${i}" name="episodeCount${i}" min="1" class="form-control episode-count" data-season="${i}">
                    </div>
                    <div id="episodeFields${i}" class="episode-fields"></div>
                `;
                
                episodesContainer.appendChild(seasonDiv);
            }
            
            // Add event listeners to episode count inputs
            document.querySelectorAll('.episode-count').forEach(input => {
                input.addEventListener('change', function() {
                    const season = this.getAttribute('data-season');
                    const episodeCount = parseInt(this.value) || 0;
                    const episodeFields = document.getElementById(`episodeFields${season}`);
                    
                    episodeFields.innerHTML = '';
                    
                    for (let j = 1; j <= episodeCount; j++) {
                        const episodeDiv = document.createElement('div');
                        episodeDiv.className = 'episode-container';
                        episodeDiv.innerHTML = `
                            <h4>Episode ${j}</h4>
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="episodeTitle${season}_${j}">Title</label>
                                    <input type="text" id="episodeTitle${season}_${j}" name="episodeTitle${season}_${j}" class="form-control">
                                </div>
                                <div class="form-group col-6">
                                    <label for="episodeDuration${season}_${j}">Duration (minutes)</label>
                                    <input type="number" id="episodeDuration${season}_${j}" name="episodeDuration${season}_${j}" min="1" class="form-control">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="episodeFile${season}_${j}">Video File</label>
                                <input type="file" id="episodeFile${season}_${j}" name="episodeFile${season}_${j}" accept="video/*" class="form-control-file">
                            </div>
                        `;
                        
                        episodeFields.appendChild(episodeDiv);
                    }
                });
            });
        });
    </script>
</body>
</html>