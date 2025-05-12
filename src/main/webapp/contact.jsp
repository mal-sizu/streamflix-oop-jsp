<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">Contact Us</h1>
            
            <div class="contact-container">
                <div class="contact-info">
                    <h2>Get in Touch</h2>
                    <p>We're here to help! If you have any questions, feedback, or concerns, please don't hesitate to reach out to us.</p>
                    
                    <div class="contact-methods">
                        <div class="contact-method">
                            <i class="fas fa-envelope"></i>
                            <h3>Email Us</h3>
                            <p>support@streamflix.com</p>
                            <p>For business inquiries: business@streamflix.com</p>
                        </div>
                        
                        <div class="contact-method">
                            <i class="fas fa-phone-alt"></i>
                            <h3>Call Us</h3>
                            <p>Customer Support: 1-800-STREAM-FX</p>
                            <p>Available 24/7</p>
                        </div>
                        
                        <div class="contact-method">
                            <i class="fas fa-map-marker-alt"></i>
                            <h3>Visit Us</h3>
                            <p>StreamFlix Headquarters</p>
                            <p>123 Entertainment Blvd</p>
                            <p>Los Angeles, CA 90001</p>
                        </div>
                    </div>
                    
                    <div class="social-links">
                        <h3>Connect With Us</h3>
                        <div class="social-icons">
                            <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="contact-form-container">
                    <h2>Send Us a Message</h2>
                    
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
                    
                    <form action="${pageContext.request.contextPath}/contact/submit" method="post" class="contact-form">
                        <div class="form-group">
                            <label for="name">Your Name</label>
                            <input type="text" id="name" name="name" required class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required class="form-control">
                        </div>
                        
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <select id="subject" name="subject" class="form-control">
                                <option value="General Inquiry">General Inquiry</option>
                                <option value="Technical Support">Technical Support</option>
                                <option value="Billing Question">Billing Question</option>
                                <option value="Content Request">Content Request</option>
                                <option value="Feedback">Feedback</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="message">Message</label>
                            <textarea id="message" name="message" rows="5" required class="form-control"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Send Message</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <section class="faq-section">
                <h2>Frequently Asked Questions</h2>
                
                <div class="faq-container">
                    <div class="faq-item">
                        <div class="faq-question">
                            <h3>How do I reset my password?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>You can reset your password by clicking on the "Forgot Password" link on the login page. We'll send you an email with instructions to reset your password.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <h3>How do I cancel my subscription?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>You can cancel your subscription by going to your Account Settings and selecting the "Subscription" tab. From there, click on "Cancel Subscription" and follow the prompts.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <h3>Why can't I play certain content?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>Some content may be restricted based on your subscription plan or geographical location. Make sure you have an active subscription and check if the content is available in your region.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <h3>How do I report a technical issue?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer">
                            <p>You can report technical issues through our contact form above or by emailing support@streamflix.com. Please include details about the issue, your device, and browser information to help us resolve it quickly.</p>
                        </div>
                    </div>
                </div>
                
                <div class="faq-more">
                    <p>For more answers to common questions, visit our <a href="${pageContext.request.contextPath}/help.jsp">Help Center</a>.</p>
                </div>
            </section>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/contact.js"></script>
</body>
</html>