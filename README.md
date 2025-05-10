# StreamFlix - Java EE Streaming Service Application

A full-stack Java EE web application for a streaming service, using JSP, Servlets, MySQL, and following the MVC architecture pattern.

## Overview

StreamFlix is a streaming service web application that allows users to browse movies and TV series, create personalized profiles, maintain watchlists, rate content, and stream media. The application is built using Java EE technologies and follows the MVC architecture pattern.

## Features

- **User Authentication**: Registration, login, and password reset
- **Profile Management**: Create and manage multiple user profiles with parental controls
- **Content Browsing**: Browse movies and TV series with filtering options
- **Search**: Search for content by title, description, genre, etc.
- **Watchlist**: Add/remove content to/from personalized watchlists
- **Ratings & Reviews**: Rate and review content
- **Media Player**: Stream movies and TV series episodes with playback controls
- **Admin Dashboard**: Manage users and content (for admin users)
- **Subscription Management**: View and manage subscription plans

## Technology Stack

- **Back-end**: Java Servlets, JSP
- **Database**: MySQL
- **Connection Pooling**: Apache DBCP2
- **Front-end**: HTML5, CSS3, JavaScript, jQuery
- **Password Hashing**: BCrypt
- **JSON Processing**: org.json
- **Testing**: JUnit, Mockito

## Project Structure

The project follows an MVC (Model-View-Controller) architecture:

- **Model**: Java beans representing data entities (User, Profile, Content, etc.)
- **View**: JSP pages for rendering UI
- **Controller**: Java Servlets handling HTTP requests and responses

## Database Schema

The application uses the following database tables:

- **users**: User account information
- **profiles**: User profiles for each account
- **content**: Movies and TV series metadata
- **episodes**: TV series episodes
- **watchlist**: User watchlist items
- **ratings**: User ratings and reviews
- **subscriptions**: User subscription information
- **payments**: Subscription payment history
- **offers**: Promotional offers for subscriptions

## Prerequisites

- JDK 11 or higher
- Apache Tomcat 9 or higher
- MySQL 8.0 or higher
- Maven 3.6 or higher
- Eclipse IDE (or any Java IDE of your choice)

## Setup Instructions

### Database Setup

1. Create a new MySQL database:
   ```sql
   CREATE DATABASE streamflix;
   ```

2. Create a database user:
   ```sql
   CREATE USER 'streamflix_user'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON streamflix.* TO 'streamflix_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. Run the database script from `database-script.sql` to create the tables and populate with sample data.

### Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/streamflix.git
   cd streamflix
   ```

2. Configure database connection in `src/main/java/com/streamflix/util/DatabaseUtil.java`:
   ```java
   ds.setUrl("jdbc:mysql://localhost:3306/streamflix?useSSL=false&serverTimezone=UTC");
   ds.setUsername("streamflix_user");
   ds.setPassword("password");
   ```

3. Build the project with Maven:
   ```bash
   mvn clean package
   ```

4. Deploy the generated WAR file to Tomcat:
   - Copy `target/streamflix.war` to Tomcat's `webapps` directory
   - Start Tomcat
   - Access the application at http://localhost:8080/streamflix

### Alternative Setup (Eclipse IDE)

1. Import the project as a Maven project in Eclipse
2. Configure Tomcat server in Eclipse
3. Run the project on the Tomcat server

## User Credentials

The database script includes sample user accounts:

- **Admin User**:
  - Email: admin@streamflix.com
  - Password: admin123

- **Regular Users**:
  - Email: john@example.com
  - Password: password123
  
  - Email: jane@example.com
  - Password: password123

## Implementation Details

### DAO (Data Access Object) Pattern

The application implements the DAO pattern to separate data access logic from business logic. Each entity has a corresponding DAO interface and implementation class.

### Authentication and Security

- Password hashing using BCrypt
- Session-based authentication
- Role-based access control (ADMIN, MEMBER)

### Responsive Design

The user interface is designed to be responsive and works well on various screen sizes, from mobile to desktop.

## Future Enhancements

- Implement real video streaming with adaptive bitrate
- Add social features (share, like, comment)
- Implement recommendation engine based on user preferences
- Add multi-language support
- Integrate real payment gateway

## License

This project is licensed under the MIT License - see the LICENSE file for details.
