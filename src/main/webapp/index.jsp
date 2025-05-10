<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamFlix - Your Ultimate Streaming Experience</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landing.css">
</head>
<body class="landing-page">
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/images/streamflix-logo.png" alt="StreamFlix">
        </div>
        <div class="header-right">
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">Sign In</a>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/home.jsp" class="btn btn-primary">Go to Home</a>
            </c:if>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="hero-content">
                <h1>Unlimited movies, TV shows, and more.</h1>
                <h2>Watch anywhere. Cancel anytime.</h2>
                <p>Ready to watch? Enter your email to create or restart your membership.</p>
                
                <div class="cta-form">
                    <form action="${pageContext.request.contextPath}/auth/register" method="get">
                        <input type="email" name="email" placeholder="Email address" required>
                        <button type="submit" class="btn btn-large">Get Started &rsaquo;</button>
                    </form>
                </div>
            </div>
        </section>

        <section class="features">
            <div class="feature">
                <div class="feature-text">
                    <h2>Enjoy on your TV.</h2>
                    <p>Watch on Smart TVs, PlayStation, Xbox, Chromecast, Apple TV, Blu-ray players, and more.</p>
                </div>
                <div class="feature-img">
                    <img src="${pageContext.request.contextPath}/images/feature-tv.jpg" alt="TV">
                </div>
            </div>

            <div class="feature">
                <div class="feature-img">
                    <img src="${pageContext.request.contextPath}/images/feature-mobile.jpg" alt="Mobile">
                </div>
                <div class="feature-text">
                    <h2>Download your shows to watch offline.</h2>
                    <p>Save your favorites easily and always have something to watch.</p>
                </div>
            </div>

            <div class="feature">
                <div class="feature-text">
                    <h2>Watch everywhere.</h2>
                    <p>Stream unlimited movies and TV shows on your phone, tablet, laptop, and TV.</p>
                </div>
                <div class="feature-img">
                    <img src="${pageContext.request.contextPath}/images/feature-device.jpg" alt="Device">
                </div>
            </div>
        </section>

        <section class="faq">
            <h2>Frequently Asked Questions</h2>
            
            <div class="accordion">
                <div class="accordion-item">
                    <button class="accordion-btn">What is StreamFlix?</button>
                    <div class="accordion-content">
                        <p>StreamFlix is a streaming service that offers a wide variety of award-winning TV shows, movies, anime, documentaries, and more on thousands of internet-connected devices.</p>
                        <p>You can watch as much as you want, whenever you want without a single commercial – all for one low monthly price.</p>
                    </div>
                </div>
                
                <div class="accordion-item">
                    <button class="accordion-btn">How much does StreamFlix cost?</button>
                    <div class="accordion-content">
                        <p>Watch StreamFlix on your smartphone, tablet, Smart TV, laptop, or streaming device, all for one fixed monthly fee. Plans range from $8.99 to $17.99 a month. No extra costs, no contracts.</p>
                    </div>
                </div>
                
                <div class="accordion-item">
                    <button class="accordion-btn">Where can I watch?</button>
                    <div class="accordion-content">
                        <p>Watch anywhere, anytime. Sign in with your StreamFlix account to watch instantly on the web at streamflix.com from your personal computer or on any internet-connected device that offers the StreamFlix app.</p>
                        <p>You can also download your favorite shows with the iOS, Android, or Windows 10 app. Use downloads to watch while you're on the go and without an internet connection.</p>
                    </div>
                </div>
                
                <div class="accordion-item">
                    <button class="accordion-btn">How do I cancel?</button>
                    <div class="accordion-content">
                        <p>StreamFlix is flexible. There are no pesky contracts and no commitments. You can easily cancel your account online in two clicks. There are no cancellation fees – start or stop your account anytime.</p>
                    </div>
                </div>
            </div>
            
            <div class="cta-form">
                <p>Ready to watch? Enter your email to create or restart your membership.</p>
                <form action="${pageContext.request.contextPath}/auth/register" method="get">
                    <input type="email" name="email" placeholder="Email address" required>
                    <button type="submit" class="btn btn-large">Get Started &rsaquo;</button>
                </form>
            </div>
        </section>
    </main>

    <footer>
        <div class="footer-content">
            <p>Questions? Call 1-800-STREAM-NOW</p>
            
            <div class="footer-links">
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/faq.jsp">FAQ</a>
                    <a href="${pageContext.request.contextPath}/investor-relations.jsp">Investor Relations</a>
                    <a href="${pageContext.request.contextPath}/privacy.jsp">Privacy</a>
                    <a href="${pageContext.request.contextPath}/speed-test.jsp">Speed Test</a>
                </div>
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/help.jsp">Help Center</a>
                    <a href="${pageContext.request.contextPath}/jobs.jsp">Jobs</a>
                    <a href="${pageContext.request.contextPath}/cookie-preferences.jsp">Cookie Preferences</a>
                    <a href="${pageContext.request.contextPath}/legal-notices.jsp">Legal Notices</a>
                </div>
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/account.jsp">Account</a>
                    <a href="${pageContext.request.contextPath}/ways-to-watch.jsp">Ways to Watch</a>
                    <a href="${pageContext.request.contextPath}/corporate-information.jsp">Corporate Information</a>
                    <a href="${pageContext.request.contextPath}/only-on-streamflix.jsp">Only on StreamFlix</a>
                </div>
                <div class="footer-col">
                    <a href="${pageContext.request.contextPath}/media-center.jsp">Media Center</a>
                    <a href="${pageContext.request.contextPath}/terms.jsp">Terms of Use</a>
                    <a href="${pageContext.request.contextPath}/contact-us.jsp">Contact Us</a>
                </div>
            </div>
            
            <p class="copyright">&copy; 2023 StreamFlix, Inc.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/landing.js"></script>
</body>
</html>
