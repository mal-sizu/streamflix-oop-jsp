<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:if test="${not empty profile}">
            Edit Profile - StreamFlix
        </c:if>
        <c:if test="${empty profile}">
            Add Profile - StreamFlix
        </c:if>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profiles.css">
</head>
<body class="profiles-page">
    <header>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
            </a>
        </div>
    </header>

    <main>
        <div class="profile-form-container">
            <h1>
                <c:if test="${not empty profile}">
                    Edit Profile
                </c:if>
                <c:if test="${empty profile}">
                    Add Profile
                </c:if>
            </h1>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    ${errorMessage}
                </div>
            </c:if>
            
            <div class="profile-form">
                <form action="${pageContext.request.contextPath}/profile/${not empty profile ? 'update' : 'add'}" method="post">
                    <c:if test="${not empty profile}">
                        <input type="hidden" name="profileId" value="${profile.profileId}">
                    </c:if>
                    
                    <div class="form-group profile-avatar-selector">
                        <div class="current-avatar">
                            <img src="${not empty profile ? profile.avatarUrl : pageContext.request.contextPath.concat('/images/avatars/default.jpg')}" 
                                alt="Profile Avatar" id="selectedAvatar">
                        </div>
                        
                        <div class="avatar-options">
                            <h3>Choose an avatar</h3>
                            <div class="avatar-grid">
                                <c:forEach var="i" begin="1" end="12">
                                    <div class="avatar-option">
                                        <img src="${pageContext.request.contextPath}/images/avatars/avatar${i}.jpg" 
                                            alt="Avatar ${i}" 
                                            onclick="selectAvatar('${pageContext.request.contextPath}/images/avatars/avatar${i}.jpg')">
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <input type="hidden" name="avatarUrl" id="avatarUrlInput" 
                            value="${not empty profile ? profile.avatarUrl : pageContext.request.contextPath.concat('/images/avatars/default.jpg')}">
                    </div>
                    
                    <div class="form-group">
                        <label for="profileName">Profile Name</label>
                        <input type="text" id="profileName" name="profileName" 
                            value="${not empty profile ? profile.profileName : ''}" maxlength="20" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="ageLimit">Age Limit</label>
                        <select id="ageLimit" name="ageLimit">
                            <option value="18" ${not empty profile && profile.ageLimit == 18 ? 'selected' : ''}>Adults (18+)</option>
                            <option value="16" ${not empty profile && profile.ageLimit == 16 ? 'selected' : ''}>Teens (16+)</option>
                            <option value="13" ${not empty profile && profile.ageLimit == 13 ? 'selected' : ''}>Older Children (13+)</option>
                            <option value="7" ${not empty profile && profile.ageLimit == 7 ? 'selected' : ''}>Children (7+)</option>
                            <option value="0" ${not empty profile && profile.ageLimit == 0 ? 'selected' : ''}>All Ages</option>
                        </select>
                    </div>
                    
                    <c:if test="${not empty profile}">
                        <div class="form-group form-checkbox">
                            <label>
                                <input type="checkbox" name="autoplay" checked> Autoplay next episode
                            </label>
                        </div>
                        
                        <div class="form-group form-checkbox">
                            <label>
                                <input type="checkbox" name="previewsound" checked> Play previews with sound
                            </label>
                        </div>
                    </c:if>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Save</button>
                        <a href="${pageContext.request.contextPath}/profile/manage" class="btn btn-secondary">Cancel</a>
                        
                        <c:if test="${not empty profile}">
                            <a href="${pageContext.request.contextPath}/profile/delete?id=${profile.profileId}" 
                                class="btn btn-danger" 
                                onclick="return confirm('Are you sure you want to delete this profile?');">
                                Delete Profile
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-content minimal">
            <p class="copyright">&copy; 2023 StreamFlix, Inc.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script>
        function selectAvatar(url) {
            document.getElementById('selectedAvatar').src = url;
            document.getElementById('avatarUrlInput').value = url;
            
            // Highlight selected avatar
            $('.avatar-option img').removeClass('selected');
            $(".avatar-option img[src='" + url + "']").addClass('selected');
        }
        
        $(document).ready(function() {
            // Highlight the currently selected avatar
            const currentAvatar = $('#avatarUrlInput').val();
            $(".avatar-option img[src='" + currentAvatar + "']").addClass('selected');
        });
    </script>
</body>
</html>