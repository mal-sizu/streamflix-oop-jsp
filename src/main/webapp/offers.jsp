<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Special Offers - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/offers.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Special Offers & Promotions</h1>
            
            <section class="offers-banner">
                <div class="banner-content">
                    <h2>Limited Time Offer</h2>
                    <p class="offer-description">Get 30% off on annual Premium subscription</p>
                    <p class="offer-expiry">Offer ends: <span class="countdown" data-end-date="2023-12-31">10 days</span></p>
                    <a href="${pageContext.request.contextPath}/subscription.jsp" class="btn btn-primary">Subscribe Now</a>
                </div>
            </section>
            
            <section class="offers-grid">
                <c:forEach var="offer" items="${currentOffers}">
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3>${offer.title}</h3>
                            <span class="offer-badge">${offer.discountPercentage}% OFF</span>
                        </div>
                        
                        <div class="offer-body">
                            <p>${offer.description}</p>
                            <div class="offer-details">
                                <div class="offer-price">
                                    <span class="original-price">$${offer.originalPrice}</span>
                                    <span class="discounted-price">$${offer.discountedPrice}</span>
                                </div>
                                <p class="offer-duration">${offer.duration} subscription</p>
                            </div>
                        </div>
                        
                        <div class="offer-footer">
                            <p class="offer-code">Use code: <strong>${offer.promoCode}</strong></p>
                            <p class="offer-expiry">Valid until: <fmt:formatDate value="${offer.expiryDate}" pattern="MMMM dd, yyyy" /></p>
                            <a href="${pageContext.request.contextPath}/subscription.jsp?promo=${offer.promoCode}" class="btn btn-secondary">Claim Offer</a>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Fallback static offers if no dynamic offers are available -->
                <c:if test="${empty currentOffers}">
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3>Annual Premium Plan</h3>
                            <span class="offer-badge">30% OFF</span>
                        </div>
                        
                        <div class="offer-body">
                            <p>Enjoy a full year of StreamFlix Premium with 4K streaming, unlimited devices, and offline downloads.</p>
                            <div class="offer-details">
                                <div class="offer-price">
                                    <span class="original-price">$180</span>
                                    <span class="discounted-price">$126</span>
                                </div>
                                <p class="offer-duration">12-month subscription</p>
                            </div>
                        </div>
                        
                        <div class="offer-footer">
                            <p class="offer-code">Use code: <strong>ANNUAL30</strong></p>
                            <p class="offer-expiry">Valid until: December 31, 2023</p>
                            <a href="${pageContext.request.contextPath}/subscription.jsp?promo=ANNUAL30" class="btn btn-secondary">Claim Offer</a>
                        </div>
                    </div>
                    
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3>Family Plan Bundle</h3>
                            <span class="offer-badge">25% OFF</span>
                        </div>
                        
                        <div class="offer-body">
                            <p>Perfect for families! Get Standard plan with up to 5 profiles and simultaneous streaming on 3 devices.</p>
                            <div class="offer-details">
                                <div class="offer-price">
                                    <span class="original-price">$120</span>
                                    <span class="discounted-price">$90</span>
                                </div>
                                <p class="offer-duration">6-month subscription</p>
                            </div>
                        </div>
                        
                        <div class="offer-footer">
                            <p class="offer-code">Use code: <strong>FAMILY25</strong></p>
                            <p class="offer-expiry">Valid until: November 30, 2023</p>
                            <a href="${pageContext.request.contextPath}/subscription.jsp?promo=FAMILY25" class="btn btn-secondary">Claim Offer</a>
                        </div>
                    </div>
                    
                    <div class="offer-card">
                        <div class="offer-header">
                            <h3>Student Special</h3>
                            <span class="offer-badge">50% OFF</span>
                        </div>
                        
                        <div class="offer-body">
                            <p>Special discount for students! Verify your student status and get half off on our Basic plan.</p>
                            <div class="offer-details">
                                <div class="offer-price">
                                    <span class="original-price">$60</span>
                                    <span class="discounted-price">$30</span>
                                </div>
                                <p class="offer-duration">3-month subscription</p>
                            </div>
                        </div>
                        
                        <div class="offer-footer">
                            <p class="offer-code">Use code: <strong>STUDENT50</strong></p>
                            <p class="offer-expiry">Valid until: January 15, 2024</p>
                            <a href="${pageContext.request.contextPath}/subscription.jsp?promo=STUDENT50" class="btn btn-secondary">Claim Offer</a>
                        </div>
                    </div>
                </c:if>
            </section>
            
            <section class="referral-program">
                <div class="referral-content">
                    <h2>Refer a Friend Program</h2>
                    <p>Invite your friends to StreamFlix and both of you will receive a free month of Premium subscription!</p>
                    
                    <div class="referral-steps">
                        <div class="referral-step">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <h3>Share Your Code</h3>
                                <p>Send your unique referral code to friends and family</p>
                            </div>
                        </div>
                        
                        <div class="referral-step">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <h3>Friend Subscribes</h3>
                                <p>They sign up using your referral code</p>
                            </div>
                        </div>
                        
                        <div class="referral-step">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <h3>Both Get Rewarded</h3>
                                <p>You both receive one month free Premium</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="referral-action">
                        <c:if test="${not empty user}">
                            <div class="referral-code">
                                <p>Your referral code:</p>
                                <div class="code-display">
                                    <span id="referralCode">${user.referralCode}</span>
                                    <button class="btn-copy" onclick="copyReferralCode()">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="share-buttons">
                                <button class="btn btn-social btn-email" onclick="shareByEmail()">
                                    <i class="fas fa-envelope"></i> Email
                                </button>
                                <button class="btn btn-social btn-facebook" onclick="shareOnFacebook()">
                                    <i class="fab fa-facebook-f"></i> Facebook
                                </button>
                                <button class="btn btn-social btn-twitter" onclick="shareOnTwitter()">
                                    <i class="fab fa-twitter"></i> Twitter
                                </button>
                                <button class="btn btn-social btn-whatsapp" onclick="shareOnWhatsapp()">
                                    <i class="fab fa-whatsapp"></i> WhatsApp
                                </button>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty user}">
                            <p>Sign in to get your referral code and start earning free months!</p>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Sign In</a>
                        </c:if>
                    </div>
                </div>
            </section>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        // Countdown timer for offer expiry
        function updateCountdown() {
            const countdownElements = document.querySelectorAll('.countdown');
            
            countdownElements.forEach(element => {
                const endDate = new Date(element.getAttribute('data-end-date'));
                const now = new Date();
                
                const timeDiff = endDate - now;
                
                if (timeDiff <= 0) {
                    element.textContent = 'Expired';
                    return;
                }
                
                const days = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
                element.textContent = days + ' days';
            });
        }
        
        // Copy referral code to clipboard
        function copyReferralCode() {
            const referralCode = document.getElementById('referralCode').textContent;
            navigator.clipboard.writeText(referralCode).then(() => {
                alert('Referral code copied to clipboard!');
            });
        }
        
        // Social sharing functions
        function shareByEmail() {
            const referralCode = document.getElementById('referralCode').textContent;
            const subject = 'Join me on StreamFlix!';
            const body = `I'm inviting you to join StreamFlix! Use my referral code ${referralCode} when you sign up and we'll both get a free month of Premium. Sign up here: https://streamflix.com/signup`;
            window.location.href = `mailto:?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
        }
        
        function shareOnFacebook() {
            const referralCode = document.getElementById('referralCode').textContent;
            const url = `https://streamflix.com/signup?ref=${referralCode}`;
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`, '_blank');
        }
        
        function shareOnTwitter() {
            const referralCode = document.getElementById('referralCode').textContent;
            const text = `Join me on StreamFlix! Use my referral code ${referralCode} when you sign up and we'll both get a free month of Premium!`;
            const url = 'https://streamflix.com/signup';
            window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`, '_blank');
        }
        
        function shareOnWhatsapp() {
            const referralCode = document.getElementById('referralCode').textContent;
            const text = `Join me on StreamFlix! Use my referral code ${referralCode} when you sign up and we'll both get a free month of Premium. Sign up here: https://streamflix.com/signup`;
            window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, '_blank');
        }
        
        // Initialize countdown on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateCountdown();
            // Update countdown daily
            setInterval(updateCountdown, 86400000);
        });
    </script>
</body>
</html>