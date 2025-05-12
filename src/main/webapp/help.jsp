<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Center - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/help.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Help Center</h1>
            
            <div class="help-search">
                <form action="${pageContext.request.contextPath}/help/search" method="get">
                    <div class="search-container">
                        <input type="text" name="query" placeholder="Search for help topics..." class="search-input">
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="help-categories">
                <div class="help-category">
                    <div class="category-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h2>Account & Profiles</h2>
                    <ul class="help-topics">
                        <li><a href="#account-creation">Creating an account</a></li>
                        <li><a href="#profile-management">Managing profiles</a></li>
                        <li><a href="#password-reset">Resetting your password</a></li>
                        <li><a href="#account-security">Account security</a></li>
                    </ul>
                </div>
                
                <div class="help-category">
                    <div class="category-icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h2>Billing & Subscription</h2>
                    <ul class="help-topics">
                        <li><a href="#subscription-plans">Subscription plans</a></li>
                        <li><a href="#payment-methods">Payment methods</a></li>
                        <li><a href="#billing-issues">Billing issues</a></li>
                        <li><a href="#cancel-subscription">Canceling subscription</a></li>
                    </ul>
                </div>
                
                <div class="help-category">
                    <div class="category-icon">
                        <i class="fas fa-play-circle"></i>
                    </div>
                    <h2>Streaming & Playback</h2>
                    <ul class="help-topics">
                        <li><a href="#playback-issues">Playback issues</a></li>
                        <li><a href="#video-quality">Video quality settings</a></li>
                        <li><a href="#offline-viewing">Downloading for offline viewing</a></li>
                        <li><a href="#device-compatibility">Device compatibility</a></li>
                    </ul>
                </div>
                
                <div class="help-category">
                    <div class="category-icon">
                        <i class="fas fa-cog"></i>
                    </div>
                    <h2>Settings & Features</h2>
                    <ul class="help-topics">
                        <li><a href="#parental-controls">Parental controls</a></li>
                        <li><a href="#language-settings">Language settings</a></li>
                        <li><a href="#watchlist">Using My List</a></li>
                        <li><a href="#recommendations">Personalized recommendations</a></li>
                    </ul>
                </div>
            </div>
            
            <section id="account-creation" class="help-section">
                <h2>Creating an Account</h2>
                <div class="help-content">
                    <p>To create a new StreamFlix account:</p>
                    <ol>
                        <li>Visit the StreamFlix homepage and click "Sign Up"</li>
                        <li>Enter your email address and create a password</li>
                        <li>Select a subscription plan</li>
                        <li>Enter your payment information</li>
                        <li>Create your profile and start streaming!</li>
                    </ol>
                    <p>If you're having trouble creating an account, please <a href="${pageContext.request.contextPath}/contact.jsp">contact our support team</a>.</p>
                </div>
            </section>
            
            <section id="profile-management" class="help-section">
                <h2>Managing Profiles</h2>
                <div class="help-content">
                    <p>StreamFlix allows you to create up to 5 profiles per account. Each profile can have its own personalized recommendations, watchlist, and viewing history.</p>
                    <h3>To create a new profile:</h3>
                    <ol>
                        <li>Click on your profile icon in the top right corner</li>
                        <li>Select "Manage Profiles"</li>
                        <li>Click "Add Profile"</li>
                        <li>Enter a name and select an avatar</li>
                        <li>Click "Save"</li>
                    </ol>
                    <h3>To edit or delete a profile:</h3>
                    <ol>
                        <li>Click on your profile icon in the top right corner</li>
                        <li>Select "Manage Profiles"</li>
                        <li>Click the "Edit" or "Delete" button on the profile you want to modify</li>
                    </ol>
                </div>
            </section>
            
            <!-- More help sections would go here -->
            
            <div class="help-contact">
                <h2>Still Need Help?</h2>
                <p>If you couldn't find the answer you were looking for, our support team is here to help.</p>
                <div class="help-contact-options">
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-primary">Contact Us</a>
                    <a href="#" class="btn btn-secondary">Live Chat</a>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/help.js"></script>
</body>
</html>