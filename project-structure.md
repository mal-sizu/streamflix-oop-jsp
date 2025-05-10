# StreamFlix Project Structure

```
streamflix/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── streamflix/
│   │   │           ├── controller/             # Servlet controllers
│   │   │           │   ├── AdminServlet.java
│   │   │           │   ├── AuthServlet.java
│   │   │           │   ├── ContentServlet.java
│   │   │           │   ├── PaymentServlet.java
│   │   │           │   ├── PlayerServlet.java
│   │   │           │   ├── ProfileServlet.java
│   │   │           │   ├── RatingServlet.java
│   │   │           │   ├── RecommendationServlet.java
│   │   │           │   ├── SearchServlet.java
│   │   │           │   ├── SubscriptionServlet.java
│   │   │           │   └── WatchlistServlet.java
│   │   │           │
│   │   │           ├── dao/                   # Data Access Objects
│   │   │           │   ├── ContentDAO.java
│   │   │           │   ├── ContentDAOImpl.java
│   │   │           │   ├── EpisodeDAO.java
│   │   │           │   ├── EpisodeDAOImpl.java
│   │   │           │   ├── OfferDAO.java
│   │   │           │   ├── OfferDAOImpl.java
│   │   │           │   ├── PaymentDAO.java
│   │   │           │   ├── PaymentDAOImpl.java
│   │   │           │   ├── ProfileDAO.java
│   │   │           │   ├── ProfileDAOImpl.java
│   │   │           │   ├── RatingDAO.java
│   │   │           │   ├── RatingDAOImpl.java
│   │   │           │   ├── SubscriptionDAO.java
│   │   │           │   ├── SubscriptionDAOImpl.java
│   │   │           │   ├── UserDAO.java
│   │   │           │   ├── UserDAOImpl.java
│   │   │           │   ├── WatchlistDAO.java
│   │   │           │   └── WatchlistDAOImpl.java
│   │   │           │
│   │   │           ├── filter/                # Servlet filters
│   │   │           │   ├── AdminFilter.java
│   │   │           │   └── AuthenticationFilter.java
│   │   │           │
│   │   │           ├── model/                 # Model classes
│   │   │           │   ├── Content.java
│   │   │           │   ├── Episode.java
│   │   │           │   ├── Offer.java
│   │   │           │   ├── Payment.java
│   │   │           │   ├── Profile.java
│   │   │           │   ├── Rating.java
│   │   │           │   ├── Subscription.java
│   │   │           │   ├── User.java
│   │   │           │   └── Watchlist.java
│   │   │           │
│   │   │           └── util/                  # Utility classes
│   │   │               ├── DatabaseUtil.java
│   │   │               └── ValidationUtil.java
│   │   │
│   │   ├── resources/                        # Configuration files
│   │   │   └── log4j.properties
│   │   │
│   │   └── webapp/                           # Web resources
│   │       ├── css/                          # CSS stylesheets
│   │       │   ├── admin.css
│   │       │   ├── auth.css
│   │       │   ├── details.css
│   │       │   ├── home.css
│   │       │   ├── landing.css
│   │       │   ├── main.css
│   │       │   ├── player.css
│   │       │   ├── profiles.css
│   │       │   ├── search.css
│   │       │   └── watchlist.css
│   │       │
│   │       ├── images/                       # Image resources
│   │       │   ├── avatars/
│   │       │   │   ├── avatar1.jpg
│   │       │   │   ├── avatar2.jpg
│   │       │   │   ├── ...
│   │       │   │   └── default.jpg
│   │       │   │
│   │       │   ├── thumbnails/
│   │       │   │   ├── adventure_begins.jpg
│   │       │   │   ├── galaxy_quest.jpg
│   │       │   │   ├── love_paris.jpg
│   │       │   │   ├── midnight_mystery.jpg
│   │       │   │   └── tech_titans.jpg
│   │       │   │
│   │       │   ├── auth-bg.jpg
│   │       │   ├── feature-device.jpg
│   │       │   ├── feature-mobile.jpg
│   │       │   ├── feature-tv.jpg
│   │       │   ├── hero-banner.jpg
│   │       │   ├── landing-bg.jpg
│   │       │   └── streamflix-logo.png
│   │       │
│   │       ├── js/                           # JavaScript files
│   │       │   ├── admin.js
│   │       │   ├── auth.js
│   │       │   ├── home.js
│   │       │   ├── jquery-3.6.0.min.js
│   │       │   ├── landing.js
│   │       │   ├── main.js
│   │       │   ├── player.js
│   │       │   ├── profiles.js
│   │       │   └── search.js
│   │       │
│   │       ├── includes/                     # JSP includes
│   │       │   ├── footer.jsp
│   │       │   └── navbar.jsp
│   │       │
│   │       ├── admin/                        # Admin pages
│   │       │   ├── add-content.jsp
│   │       │   ├── edit-content.jsp
│   │       │   ├── manage-users.jsp
│   │       │   └── dashboard.jsp
│   │       │
│   │       ├── WEB-INF/                      # Web configuration
│   │       │   ├── lib/                      # External libraries
│   │       │   │   ├── jstl-1.2.jar
│   │       │   │   └── ... (other JAR files)
│   │       │   │
│   │       │   └── web.xml                   # Web deployment descriptor
│   │       │
│   │       ├── about.jsp
│   │       ├── admin-dashboard.jsp
│   │       ├── admin-login.jsp
│   │       ├── billing.jsp
│   │       ├── contact.jsp
│   │       ├── error.jsp
│   │       ├── forgot-password.jsp
│   │       ├── help.jsp
│   │       ├── home.jsp
│   │       ├── index.jsp
│   │       ├── login.jsp
│   │       ├── manage-content.jsp
│   │       ├── manage-profiles.jsp
│   │       ├── manage-users.jsp
│   │       ├── movie-details.jsp
│   │       ├── offers.jsp
│   │       ├── parental-controls.jsp
│   │       ├── pip-mode.jsp
│   │       ├── player.jsp
│   │       ├── privacy.jsp
│   │       ├── profile.jsp
│   │       ├── rate-review.jsp
│   │       ├── recommendations.jsp
│   │       ├── register.jsp
│   │       ├── results.jsp
│   │       ├── search.jsp
│   │       ├── subscription.jsp
│   │       ├── terms.jsp
│   │       ├── trending.jsp
│   │       ├── tv-series-details.jsp
│   │       └── watchlist.jsp
│   │
│   └── test/                                 # Test code
│       └── java/
│           └── com/
│               └── streamflix/
│                   ├── dao/                   # DAO tests
│                   │   ├── ContentDAOTest.java
│                   │   ├── ProfileDAOTest.java
│                   │   ├── UserDAOTest.java
│                   │   └── WatchlistDAOTest.java
│                   │
│                   └── controller/             # Controller tests
│                       ├── AuthServletTest.java
│                       └── ContentServletTest.java
│
├── pom.xml                                    # Maven configuration
├── README.md                                  # Project documentation
├── database-script.sql                        # Database setup script
└── .gitignore                                 # Git ignore file
```

## Directory Structure Explanation

### Java Source Code (`src/main/java`)

The Java code follows a standard package structure with the main package `com.streamflix` and sub-packages for different types of components:

- **controller**: Contains servlet classes that handle HTTP requests and act as controllers in the MVC pattern.
- **dao**: Contains interfaces and implementations for data access objects that handle database operations.
- **filter**: Contains servlet filters for authentication and authorization.
- **model**: Contains Java beans that represent the data models.
- **util**: Contains utility classes for common operations like database connections.

### Web Resources (`src/main/webapp`)

- **css**: Contains CSS stylesheets for different parts of the application.
- **js**: Contains JavaScript files for client-side functionality.
- **images**: Contains image resources divided into sub-folders for avatars, thumbnails, etc.
- **includes**: Contains JSP fragments that are included in multiple pages.
- **admin**: Contains JSP pages for admin functionality.
- **WEB-INF**: Contains web configuration files and libraries.
  - **web.xml**: Deployment descriptor for the web application.
  - **lib**: External libraries used by the application.

### Root JSP Files

The root of the `webapp` directory contains the main JSP pages for the application, such as the landing page, login page, and content pages.

### Test Code (`src/test/java`)

The test directory mirrors the main Java source directory structure with test classes for DAO implementations and controllers.

### Project Configuration

- **pom.xml**: Maven project configuration file.
- **README.md**: Project documentation.
- **database-script.sql**: SQL script for setting up the database schema and initial data.

This structure follows Java EE best practices with a clear separation of concerns between different layers of the application (MVC pattern) and proper organization of web resources.
