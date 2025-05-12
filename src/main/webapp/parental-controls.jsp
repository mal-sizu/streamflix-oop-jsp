<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parental Controls - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parental-controls.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Parental Controls</h1>
            
            <div class="parental-controls-container">
                <div class="profile-selector">
                    <h2>Select Profile</h2>
                    <div class="profiles-list">
                        <c:forEach var="profile" items="${profiles}">
                            <div class="profile-item ${profile.profileId eq selectedProfile.profileId ? 'active' : ''}" 
                                 onclick="selectProfile(${profile.profileId})">
                                <div class="profile-avatar">
                                    <img src="${profile.avatarUrl}" alt="${profile.name}">
                                </div>
                                <div class="profile-name">${profile.name}</div>
                                <c:if test="${profile.hasParentalControls}">
                                    <div class="profile-badge">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="controls-settings">
                    <c:if test="${not empty selectedProfile}">
                        <h2>Parental Controls for ${selectedProfile.name}</h2>
                        
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
                        
                        <form action="${pageContext.request.contextPath}/profile/updateParentalControls" method="post" class="controls-form">
                            <input type="hidden" name="profileId" value="${selectedProfile.profileId}">
                            
                            <div class="form-group">
                                <label class="toggle-label">
                                    <span>Enable Parental Controls</span>
                                    <div class="toggle-switch">
                                        <input type="checkbox" id="enableControls" name="enableControls" 
                                               ${selectedProfile.hasParentalControls ? 'checked' : ''}>
                                        <span class="toggle-slider"></span>
                                    </div>
                                </label>
                            </div>
                            
                            <div id="controlsSettings" ${selectedProfile.hasParentalControls ? '' : 'style="display: none;"'}>
                                <div class="form-group">
                                    <label for="maturityLevel">Content Restriction Level</label>
                                    <select id="maturityLevel" name="maturityLevel" class="form-control">
                                        <option value="KIDS" ${selectedProfile.maturityLevel eq 'KIDS' ? 'selected' : ''}>Kids (G rated only)</option>
                                        <option value="FAMILY" ${selectedProfile.maturityLevel eq 'FAMILY' ? 'selected' : ''}>Family (PG rated)</option>
                                        <option value="TEEN" ${selectedProfile.maturityLevel eq 'TEEN' ? 'selected' : ''}>Teen (PG-13 rated)</option>
                                        <option value="MATURE" ${selectedProfile.maturityLevel eq 'MATURE' ? 'selected' : ''}>Mature (R rated)</option>
                                        <option value="ADULT" ${selectedProfile.maturityLevel eq 'ADULT' ? 'selected' : ''}>Adult (All content)</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="pin">PIN Code</label>
                                    <input type="password" id="pin" name="pin" maxlength="4" pattern="[0-9]{4}" 
                                           class="form-control" placeholder="4-digit PIN" required>
                                    <small class="form-text text-muted">Create a 4-digit PIN to protect these settings</small>
                                </div>
                                
                                <div class="form-group">
                                    <label for="confirmPin">Confirm PIN</label>
                                    <input type="password" id="confirmPin" name="confirmPin" maxlength="4" pattern="[0-9]{4}" 
                                           class="form-control" placeholder="Confirm 4-digit PIN" required>
                                </div>
                                
                                <div class="form-group">
                                    <label class="toggle-label">
                                        <span>Block Specific Titles</span>
                                        <div class="toggle-switch">
                                            <input type="checkbox" id="enableTitleBlocking" name="enableTitleBlocking" 
                                                   ${selectedProfile.hasTitleBlocking ? 'checked' : ''}>
                                            <span class="toggle-slider"></span>
                                        </div>
                                    </label>
                                </div>
                                
                                <div id="titleBlockingSettings" ${selectedProfile.hasTitleBlocking ? '' : 'style="display: none;"'}>
                                    <div class="blocked-titles">
                                        <h3>Blocked Titles</h3>
                                        
                                        <div class="search-titles">
                                            <input type="text" id="titleSearch" placeholder="Search for titles to block..." class="form-control">
                                            <button type="button" id="searchBtn" class="btn btn-secondary">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                        
                                        <div id="searchResults" class="search-results">
                                            <!-- Search results will be loaded here via JavaScript -->
                                        </div>
                                        
                                        <div class="blocked-titles-list">
                                            <c:if test="${empty selectedProfile.blockedTitles}">
                                                <p class="empty-message">No titles are currently blocked.</p>
                                            </c:if>
                                            
                                            <c:if test="${not empty selectedProfile.blockedTitles}">
                                                <ul>
                                                    <c:forEach var="title" items="${selectedProfile.blockedTitles}">
                                                        <li>
                                                            <div class="blocked-title-info">
                                                                <img src="${title.thumbnailUrl}" alt="${title.title}">
                                                                <span>${title.title}</span>
                                                            </div>
                                                            <button type="button" class="btn-remove" onclick="removeBlockedTitle(${title.contentId})">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                            <input type="hidden" name="blockedTitleIds" value="${title.contentId}">
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="toggle-label">
                                        <span>Time Limits</span>
                                        <div class="toggle-switch">
                                            <input type="checkbox" id="enableTimeLimit" name="enableTimeLimit" 
                                                   ${selectedProfile.hasTimeLimit ? 'checked' : ''}>
                                            <span class="toggle-slider"></span>
                                        </div>
                                    </label>
                                </div>
                                
                                <div id="timeLimitSettings" ${selectedProfile.hasTimeLimit ? '' : 'style="display: none;"'}>
                                    <div class="form-group">
                                        <label for="dailyLimit">Daily Viewing Limit (hours)</label>
                                        <input type="number" id="dailyLimit" name="dailyLimit" min="1" max="12" 
                                               value="${selectedProfile.dailyTimeLimit}" class="form-control">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>Viewing Schedule</label>
                                        <div class="time-range">
                                            <div class="time-input">
                                                <label for="startTime">From</label>
                                                <input type="time" id="startTime" name="startTime" 
                                                       value="${selectedProfile.viewingStartTime}" class="form-control">
                                            </div>
                                            <div class="time-input">
                                                <label for="endTime">To</label>
                                                <input type="time" id="endTime" name="endTime" 
                                                       value="${selectedProfile.viewingEndTime}" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">Save Settings</button>
                                <button type="reset" class="btn btn-secondary">Reset</button>
                            </div>
                        </form>
                    </c:if>
                    
                    <c:if test="${empty selectedProfile}">
                        <div class="no-profile-selected">
                            <p>Please select a profile to configure parental controls.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Toggle control settings visibility
        document.getElementById('enableControls').addEventListener('change', function() {
            const controlsSettings = document.getElementById('controlsSettings');
            controlsSettings.style.display = this.checked ? 'block' : 'none';
        });
        
        // Toggle title blocking settings visibility
        document.getElementById('enableTitleBlocking').addEventListener('change', function() {
            const titleBlockingSettings = document.getElementById('titleBlockingSettings');
            titleBlockingSettings.style.display = this.checked ? 'block' : 'none';
        });
        
        // Toggle time limit settings visibility
        document.getElementById('enableTimeLimit').addEventListener('change', function() {
            const timeLimitSettings = document.getElementById('timeLimitSettings');
            timeLimitSettings.style.display = this.checked ? 'block' : 'none';
        });
        
        // PIN validation
        document.querySelector('.controls-form').addEventListener('submit', function(e) {
            const pin = document.getElementById('pin').value;
            const confirmPin = document.getElementById('confirmPin').value;
            
            if (pin !== confirmPin) {
                e.preventDefault();
                alert('PINs do not match. Please try again.');
            }
        });
        
        // Select profile function
        function selectProfile(profileId) {
            window.location.href = '${pageContext.request.contextPath}/profile/parentalControls?profileId=' + profileId;
        }
        
        // Search for titles
        document.getElementById('searchBtn').addEventListener('click', function() {
            const searchQuery = document.getElementById('titleSearch').value.trim();
            
            if (searchQuery.length < 2) {
                alert('Please enter at least 2 characters to search.');
                return;
            }
            
            const searchResults = document.getElementById('searchResults');
            searchResults.innerHTML = '<p class="loading">Searching...</p>';
            
            // Fetch search results
            fetch('${pageContext.request.contextPath}/content/search?query=' + encodeURIComponent(searchQuery))
                .then(response => response.json())
                .then(data => {
                    searchResults.innerHTML = '';
                    
                    if (data.length === 0) {
                        searchResults.innerHTML = '<p class="no-results">No results found.</p>';
                        return;
                    }
                    
                    const resultsList = document.createElement('ul');
                    
                    data.forEach(content => {
                        const listItem = document.createElement('li');
                        listItem.innerHTML = `
                            <div class="search-result-info">
                                <img src="${content.thumbnailUrl}" alt="${content.title}">
                                <span>${content.title}</span>
                            </div>
                            <button type="button" class="btn-add" onclick="addBlockedTitle(${content.contentId}, '${content.title}', '${content.thumbnailUrl}')">
                                <i class="fas fa-plus"></i>
                            </button>
                        `;
                        resultsList.appendChild(listItem);
                    });
                    
                    searchResults.appendChild(resultsList);
                })
                .catch(error => {
                    searchResults.innerHTML = '<p class="error">Error searching for titles. Please try again.</p>';
                    console.error('Error searching for titles:', error);
                });
        });
        
        // Add blocked title
        function addBlockedTitle(contentId, title, thumbnailUrl) {
            const blockedTitlesList = document.querySelector('.blocked-titles-list');
            const emptyMessage = blockedTitlesList.querySelector('.empty-message');
            
            if (emptyMessage) {
                emptyMessage.remove();
            }
            
            let listElement = blockedTitlesList.querySelector('ul');
            
            if (!listElement) {
                listElement = document.createElement('ul');
                blockedTitlesList.appendChild(listElement);
            }
            
            // Check if title is already in the list
            const existingItems = listElement.querySelectorAll('input[type="hidden"]');
            for (let i = 0; i < existingItems.length; i++) {
                if (existingItems[i].value == contentId) {
                    alert('This title is already blocked.');
                    return;
                }
            }
            
            const listItem = document.createElement('li');
            listItem.innerHTML = `
                <div class="blocked-title-info">
                    <img src="${thumbnailUrl}" alt="${title}">
                    <span>${title}</span>
                </div>
                <button type="button" class="btn-remove" onclick="removeBlockedTitle(${contentId})">
                    <i class="fas fa-times"></i>
                </button>
                <input type="hidden" name="blockedTitleIds" value="${contentId}">
            `;
            
            listElement.appendChild(listItem);
        }
        
        // Remove blocked title
        function removeBlockedTitle(contentId) {
            const blockedTitlesList = document.querySelector('.blocked-titles-list');
            const listElement = blockedTitlesList.querySelector('ul');
            
            if (listElement) {
                const items = listElement.querySelectorAll('li');
                
                items.forEach(item => {
                    const hiddenInput = item.querySelector('input[type="hidden"]');
                    
                    if (hiddenInput && hiddenInput.value == contentId) {
                        item.remove();
                    }
                });
                
                // If no items left, show empty message
                if (listElement.children.length === 0) {
                    listElement.remove();
                    const emptyMessage = document.createElement('p');
                    emptyMessage.className = 'empty-message';
                    emptyMessage.textContent = 'No titles are currently blocked.';
                    blockedTitlesList.appendChild(emptyMessage);
                }
            }
        }
    </script>
</body>
</html>