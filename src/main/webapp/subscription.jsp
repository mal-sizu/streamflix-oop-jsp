<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subscription Plans - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/subscription.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Subscription Plans</h1>
            
            <div class="subscription-container">
                <div class="plan-comparison">
                    <div class="plan-card basic">
                        <div class="plan-header">
                            <h2>Basic</h2>
                            <div class="plan-price">
                                <span class="price">$8.99</span>
                                <span class="period">per month</span>
                            </div>
                        </div>
                        <div class="plan-features">
                            <ul>
                                <li><i class="fas fa-check"></i> Watch on 1 device at a time</li>
                                <li><i class="fas fa-check"></i> Unlimited movies and TV shows</li>
                                <li><i class="fas fa-check"></i> SD quality (480p)</li>
                                <li><i class="fas fa-times"></i> HD quality not available</li>
                                <li><i class="fas fa-times"></i> Ultra HD not available</li>
                                <li><i class="fas fa-times"></i> No offline downloads</li>
                            </ul>
                        </div>
                        <div class="plan-action">
                            <a href="${pageContext.request.contextPath}/subscribe?plan=basic" class="btn btn-primary">Choose Plan</a>
                        </div>
                    </div>
                    
                    <div class="plan-card standard">
                        <div class="plan-header">
                            <h2>Standard</h2>
                            <div class="plan-price">
                                <span class="price">$13.99</span>
                                <span class="period">per month</span>
                            </div>
                            <div class="plan-badge">Most Popular</div>
                        </div>
                        <div class="plan-features">
                            <ul>
                                <li><i class="fas fa-check"></i> Watch on 2 devices at a time</li>
                                <li><i class="fas fa-check"></i> Unlimited movies and TV shows</li>
                                <li><i class="fas fa-check"></i> SD quality (480p)</li>
                                <li><i class="fas fa-check"></i> HD quality (1080p)</li>
                                <li><i class="fas fa-times"></i> Ultra HD not available</li>
                                <li><i class="fas fa-check"></i> Download on 2 devices</li>
                            </ul>
                        </div>
                        <div class="plan-action">
                            <a href="${pageContext.request.contextPath}/subscribe?plan=standard" class="btn btn-primary">Choose Plan</a>
                        </div>
                    </div>
                    
                    <div class="plan-card premium">
                        <div class="plan-header">
                            <h2>Premium</h2>
                            <div class="plan-price">
                                <span class="price">$17.99</span>
                                <span class="period">per month</span>
                            </div>
                        </div>
                        <div class="plan-features">
                            <ul>
                                <li><i class="fas fa-check"></i> Watch on 4 devices at a time</li>
                                <li><i class="fas fa-check"></i> Unlimited movies and TV shows</li>
                                <li><i class="fas fa-check"></i> SD quality (480p)</li>
                                <li><i class="fas fa-check"></i> HD quality (1080p)</li>
                                <li><i class="fas fa-check"></i> Ultra HD (4K) and HDR</li>
                                <li><i class="fas fa-check"></i> Download on 4 devices</li>
                            </ul>
                        </div>
                        <div class="plan-action">
                            <a href="${pageContext.request.contextPath}/subscribe?plan=premium" class="btn btn-primary">Choose Plan</a>
                        </div>
                    </div>
                </div>
                
                <div class="subscription-faq">
                    <h2>Frequently Asked Questions</h2>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFaq(this)">
                            <h3>When will I be charged?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Your subscription begins as soon as you sign up. You'll be charged the monthly fee at the beginning of your billing cycle. You can cancel anytime before your next billing date to avoid charges for the next month.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFaq(this)">
                            <h3>Can I change my plan later?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Yes, you can upgrade or downgrade your plan at any time. Changes to your subscription will take effect immediately. If you upgrade, you'll be charged the prorated difference for the remainder of your current billing cycle. If you downgrade, the new lower rate will apply to your next billing cycle.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFaq(this)">
                            <h3>What payment methods do you accept?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>We accept all major credit and debit cards, including Visa, MasterCard, American Express, and Discover. We also accept PayPal and gift cards issued by StreamFlix.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFaq(this)">
                            <h3>Can I cancel my subscription?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Yes, you can cancel your subscription at any time. After cancellation, you'll continue to have access to StreamFlix until the end of your current billing period. We don't offer refunds for partial billing periods.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" onclick="toggleFaq(this)">
                            <h3>What is HD and Ultra HD?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>HD (High Definition) refers to a video resolution of 1920x1080 pixels, commonly known as 1080p. Ultra HD (or 4K) offers four times the resolution of HD at 3840x2160 pixels. To stream in Ultra HD, you need a compatible device, a Premium subscription, and an internet connection speed of at least 25 megabits per second.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function toggleFaq(element) {
            const answer = element.nextElementSibling;
            const icon = element.querySelector('i');
            
            if (answer.style.maxHeight) {
                answer.style.maxHeight = null;
                icon.classList.remove('fa-chevron-up');
                icon.classList.add('fa-chevron-down');
            } else {
                answer.style.maxHeight = answer.scrollHeight + 'px';
                icon.classList.remove('fa-chevron-down');
                icon.classList.add('fa-chevron-up');
            }
        }
    </script>
</body>
</html>