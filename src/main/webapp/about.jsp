<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - StreamFlix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">
</head>
<body class="content-page">
    <jsp:include page="includes/navbar.jsp" />

    <main>
        <div class="container">
            <h1 class="page-title">About StreamFlix</h1>
            
            <section class="about-section">
                <div class="about-content">
                    <h2>Our Story</h2>
                    <p>StreamFlix was founded in 2023 with a simple mission: to bring high-quality entertainment to viewers around the world. We believe that great stories have the power to inspire, educate, and bring people together.</p>
                    
                    <p>Our platform offers a wide range of movies, TV shows, documentaries, and original content across various genres and languages. We're committed to providing an exceptional streaming experience with personalized recommendations and user-friendly features.</p>
                </div>
                
                <div class="about-image">
                    <img src="${pageContext.request.contextPath}/images/about/our-story.jpg" alt="StreamFlix Story">
                </div>
            </section>
            
            <section class="about-section reverse">
                <div class="about-content">
                    <h2>Our Mission</h2>
                    <p>At StreamFlix, we're on a mission to revolutionize how people discover and enjoy entertainment. We strive to:</p>
                    <ul>
                        <li>Provide diverse and inclusive content that represents all communities</li>
                        <li>Support talented filmmakers and creators from around the world</li>
                        <li>Deliver the best possible streaming experience with cutting-edge technology</li>
                        <li>Build a global community of entertainment enthusiasts</li>
                    </ul>
                </div>
                
                <div class="about-image">
                    <img src="${pageContext.request.contextPath}/images/about/our-mission.jpg" alt="StreamFlix Mission">
                </div>
            </section>
            
            <section class="about-section">
                <div class="about-content">
                    <h2>Our Team</h2>
                    <p>Behind StreamFlix is a diverse team of passionate individuals dedicated to creating the best streaming platform possible. Our team includes engineers, content curators, designers, and customer support specialists working together to bring you an exceptional entertainment experience.</p>
                </div>
                
                <div class="about-image">
                    <img src="${pageContext.request.contextPath}/images/about/our-team.jpg" alt="StreamFlix Team">
                </div>
            </section>
            
            <section class="contact-cta">
                <h2>Have Questions?</h2>
                <p>We'd love to hear from you! Visit our <a href="${pageContext.request.contextPath}/contact.jsp">Contact page</a> or check out our <a href="${pageContext.request.contextPath}/help.jsp">Help Center</a>.</p>
            </section>
        </div>
    </main>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>