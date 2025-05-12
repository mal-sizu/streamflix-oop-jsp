<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rate & Review - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rate-review.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Rate & Review</h1>
            
            <div class="review-container">
                <div class="content-info">
                    <c:if test="${not empty content}">
                        <div class="content-thumbnail">
                            <img src="${content.thumbnailUrl}" alt="${content.title}">
                        </div>
                        <div class="content-details">
                            <h2>${content.title}</h2>
                            <p class="content-year">${content.releaseYear}</p>
                            <p class="content-type">${content.type}</p>
                        </div>
                    </c:if>
                    <c:if test="${empty content}">
                        <div class="error-message">
                            <p>Content not found. Please return to the previous page and try again.</p>
                            <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">Go to Home</a>
                        </div>
                    </c:if>
                </div>
                
                <c:if test="${not empty content}">
                    <div class="review-form-container">
                        <h3>Share Your Thoughts</h3>
                        
                        <form action="${pageContext.request.contextPath}/review/submit" method="post" id="reviewForm">
                            <input type="hidden" name="contentId" value="${content.id}">
                            
                            <div class="rating-container">
                                <p>Your Rating:</p>
                                <div class="star-rating">
                                    <input type="radio" id="star5" name="rating" value="5" ${userReview.rating == 5 ? 'checked' : ''}>
                                    <label for="star5" title="5 stars"></label>
                                    <input type="radio" id="star4" name="rating" value="4" ${userReview.rating == 4 ? 'checked' : ''}>
                                    <label for="star4" title="4 stars"></label>
                                    <input type="radio" id="star3" name="rating" value="3" ${userReview.rating == 3 ? 'checked' : ''}>
                                    <label for="star3" title="3 stars"></label>
                                    <input type="radio" id="star2" name="rating" value="2" ${userReview.rating == 2 ? 'checked' : ''}>
                                    <label for="star2" title="2 stars"></label>
                                    <input type="radio" id="star1" name="rating" value="1" ${userReview.rating == 1 ? 'checked' : ''}>
                                    <label for="star1" title="1 star"></label>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="reviewTitle">Review Title:</label>
                                <input type="text" id="reviewTitle" name="title" value="${userReview.title}" maxlength="100" placeholder="Summarize your thoughts">
                            </div>
                            
                            <div class="form-group">
                                <label for="reviewContent">Your Review:</label>
                                <textarea id="reviewContent" name="content" rows="6" maxlength="2000" placeholder="What did you like or dislike? What would you recommend to other viewers?">${userReview.content}</textarea>
                                <div class="char-counter"><span id="charCount">0</span>/2000</div>
                            </div>
                            
                            <div class="form-group spoiler-checkbox">
                                <input type="checkbox" id="containsSpoilers" name="containsSpoilers" ${userReview.containsSpoilers ? 'checked' : ''}>
                                <label for="containsSpoilers">This review contains spoilers</label>
                            </div>
                            
                            <div class="form-actions">
                                <c:if test="${not empty userReview}">
                                    <button type="button" id="deleteReviewBtn" class="btn btn-danger">Delete Review</button>
                                </c:if>
                                <button type="submit" class="btn btn-primary">
                                    <c:choose>
                                        <c:when test="${not empty userReview}">Update Review</c:when>
                                        <c:otherwise>Submit Review</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="other-reviews">
                        <h3>Community Reviews</h3>
                        
                        <c:if test="${empty reviews}">
                            <p class="no-reviews">No reviews yet. Be the first to share your thoughts!</p>
                        </c:if>
                        
                        <c:if test="${not empty reviews}">
                            <div class="reviews-list">
                                <c:forEach items="${reviews}" var="review">
                                    <div class="review-card">
                                        <div class="review-header">
                                            <div class="reviewer-info">
                                                <span class="reviewer-name">${review.userName}</span>
                                                <span class="review-date">
                                                    <fmt:formatDate value="${review.createdAt}" pattern="MMMM d, yyyy" />
                                                </span>
                                            </div>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <i class="fas fa-star ${star <= review.rating ? 'filled' : ''}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        
                                        <h4 class="review-title">${review.title}</h4>
                                        
                                        <c:if test="${review.containsSpoilers}">
                                            <div class="spoiler-warning">
                                                <i class="fas fa-exclamation-triangle"></i>
                                                <span>This review contains spoilers</span>
                                                <button class="btn btn-small btn-outline" onclick="toggleSpoiler(this)">Show Anyway</button>
                                            </div>
                                            <div class="review-content spoiler hidden">${review.content}</div>
                                        </c:if>
                                        
                                        <c:if test="${!review.containsSpoilers}">
                                            <div class="review-content">${review.content}</div>
                                        </c:if>
                                        
                                        <div class="review-actions">
                                            <button class="btn-icon" onclick="likeReview(${review.id})">
                                                <i class="far fa-thumbs-up"></i>
                                                <span>${review.likesCount}</span>
                                            </button>
                                            <button class="btn-icon" onclick="dislikeReview(${review.id})">
                                                <i class="far fa-thumbs-down"></i>
                                                <span>${review.dislikesCount}</span>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Character counter for review textarea
        const reviewContent = document.getElementById('reviewContent');
        const charCount = document.getElementById('charCount');
        
        if (reviewContent && charCount) {
            // Initialize character count
            charCount.textContent = reviewContent.value.length;
            
            // Update character count on input
            reviewContent.addEventListener('input', function() {
                charCount.textContent = this.value.length;
            });
        }
        
        // Toggle spoiler content
        function toggleSpoiler(button) {
            const spoilerWarning = button.closest('.spoiler-warning');
            const spoilerContent = spoilerWarning.nextElementSibling;
            
            spoilerWarning.style.display = 'none';
            spoilerContent.classList.remove('hidden');
        }
        
        // Handle review deletion
        const deleteReviewBtn = document.getElementById('deleteReviewBtn');
        if (deleteReviewBtn) {
            deleteReviewBtn.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete your review? This action cannot be undone.')) {
                    const form = document.getElementById('reviewForm');
                    const deleteInput = document.createElement('input');
                    deleteInput.type = 'hidden';
                    deleteInput.name = 'action';
                    deleteInput.value = 'delete';
                    form.appendChild(deleteInput);
                    form.submit();
                }
            });
        }
        
        // Like/dislike review functions
        function likeReview(reviewId) {
            submitReviewFeedback(reviewId, 'like');
        }
        
        function dislikeReview(reviewId) {
            submitReviewFeedback(reviewId, 'dislike');
        }
        
        function submitReviewFeedback(reviewId, action) {
            fetch(`${pageContext.request.contextPath}/review/feedback`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `reviewId=${reviewId}&action=${action}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Refresh the page to show updated counts
                    location.reload();
                } else {
                    alert(data.message || 'An error occurred. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            });
        }
    </script>
</body>
</html>