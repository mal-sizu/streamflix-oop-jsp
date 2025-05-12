# StreamFlix - Java EE Streaming Service Implementation

## Project Overview

We've created a comprehensive Java EE web application for a streaming service following the MVC architecture pattern. The application includes key components for user authentication, profile management, content browsing, search, watchlist management, content playback, and more.

## Implemented Components

### Database

- Created a MySQL database schema with tables for users, profiles, content, episodes, watchlist, ratings, subscriptions, payments, and offers.
- Included a sample script (`database-script.sql`) to set up and seed the database with initial data.

### Model Layer

- Created model classes (JavaBeans) for the entities in our system:
  - `User.java`: User account information
  - `Profile.java`: User profiles 
  - `Content.java`: Movies and TV series
  - `Episode.java`: Episodes for TV series
  - And more...

### Data Access Layer (DAO)

- Created DAO interfaces and implementations for database operations:
  - `UserDAO.java` and `UserDAOImpl.java`
  - `ContentDAO.java` and `ContentDAOImpl.java`
  - `ProfileDAO.java` and `ProfileDAOImpl.java`
  - `WatchlistDAO.java` and `WatchlistDAOImpl.java`
  - And more...

### Controller Layer

- Created servlet classes to handle HTTP requests:
  - `AuthServlet.java`: User authentication (login, register, password reset)
  - `ProfileServlet.java`: Profile management
  - `ContentServlet.java`: Content browsing and details
  - `PlayerServlet.java`: Video playback
  - `SearchServlet.java`: Content search
  - `WatchlistServlet.java`: Watchlist management
  - And more...

### View Layer

- Created JSP files for different pages:
  - `index.jsp`: Landing page
  - `login.jsp` and `register.jsp`: Authentication
  - `home.jsp`: User home with content recommendations
  - `movie-details.jsp` and `tv-series-details.jsp`: Content details
  - `player.jsp`: Video player
  - `watchlist.jsp`: User's watchlist
  - `search.jsp` and `results.jsp`: Search interface
  - `manage-profiles.jsp` and `profile.jsp`: Profile management
  - Common components: `navbar.jsp` and `footer.jsp`

### Utilities & Configuration

- Created utilities for database connections: `DatabaseUtil.java`
- Created configuration files:
  - `web.xml`: Servlet and filter mappings
  - `pom.xml`: Maven project configuration

### Filters

- `AuthenticationFilter.java`: Ensure user authentication
- `AdminFilter.java`: Restrict admin-only areas

### Frontend Assets

- Created CSS stylesheets:
  - `main.css`: Global styles
  - `landing.css`: Landing page styles
  - `auth.css`: Authentication pages styles
  - Other specific stylesheets
- Created JavaScript files:
  - `main.js`: Global functionality
  - Page-specific JavaScript

## Features

1. **User Authentication & Management**
   - User registration and login
   - Password reset functionality
   - Profile creation and management
   - Parental controls

2. **Content Management**
   - Browsing movies and TV series
   - Detailed content views
   - Episode listing for TV series
   - Content filtering by type, genre, language
   - Personalized recommendations

3. **Search Functionality**
   - Basic and advanced search
   - Search filters (type, genre, language)
   - Live search with AJAX
   - Search results display

4. **Watchlist Management**
   - Add/remove content to/from watchlist
   - View watchlist items
   - Filter watchlist by type, genre

5. **Video Playback**
   - Custom video player
   - Playback controls (play/pause, volume, fullscreen)
   - Episode selection for series
   - Picture-in-Picture mode
   - Resolution selection

6. **Ratings & Reviews**
   - Rate content (1-5 stars)
   - Write and read reviews
   - View average ratings and distribution

7. **Responsive Design**
   - Works on desktop, tablet, and mobile devices
   - Adaptive layouts for different screen sizes

8. **Admin Functionality**
   - User management
   - Content management
   - Subscription and payment tracking
   - Analytics dashboard

## Architecture

The application follows the MVC (Model-View-Controller) architecture pattern:

### Model
- Java beans representing data entities
- DAO interfaces and implementations for data access
- Business logic for different operations

### View
- JSP pages for UI rendering
- CSS for styling
- JavaScript for client-side interactivity

### Controller
- Servlets for handling HTTP requests/responses
- Filters for authentication and access control
- Session management

## Security Features

- Password hashing using BCrypt
- Session-based authentication
- Role-based access control (ADMIN, MEMBER)
- Input validation to prevent injection attacks
- Profile-specific access controls

## Database Design

- Relational database schema with appropriate foreign key relationships
- Connection pooling for efficient resource management
- Transaction management for data consistency

## Best Practices

- Separation of concerns with MVC architecture
- Adherence to Java EE design patterns
- Code reusability with common components
- Responsive and accessible UI design
- Error handling and user feedback
- Client-side validation combined with server-side validation

## Testing

- JUnit tests for DAO operations
- Integration tests for key workflows
- Sample data for testing different scenarios

## Deployment

- WAR file packaging for deployment to any Java EE container
- Configuration for Apache Tomcat 9+
- MySQL database setup script

## Conclusion

This StreamFlix application provides a comprehensive streaming service platform with all the essential features expected in a modern streaming application. It follows Java EE design patterns and best practices, making it maintainable, scalable, and secure. The application can be extended with additional features like social sharing, more advanced recommendation algorithms, and integrated payment processing.

## Getting Started

Follow the setup instructions in the README.md file to install and run the application. The sample database script includes test users and content for demonstration purposes.