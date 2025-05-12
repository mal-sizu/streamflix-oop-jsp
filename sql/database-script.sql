-- StreamFlix Database Script
-- SQL Server version

-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'streamflix')
BEGIN
    CREATE DATABASE streamflix;
    PRINT 'Database streamflix created successfully.';
END
ELSE
    PRINT 'Database streamflix already exists.';
GO

USE streamflix;
GO


-- Create Users table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
    CREATE TABLE Users (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        email VARCHAR(100) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        full_name VARCHAR(100) NOT NULL,
        phone_number VARCHAR(20),
        registration_date DATETIME DEFAULT GETDATE(),
        is_admin BIT DEFAULT 0,
        account_status VARCHAR(20) DEFAULT 'ACTIVE',
        last_login DATETIME
    );
    PRINT 'Table Users created successfully.';
END
GO

-- Create Profiles table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Profiles')
BEGIN
    CREATE TABLE Profiles (
        profile_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        profile_name VARCHAR(50) NOT NULL,
        avatar_path VARCHAR(255) DEFAULT '/images/avatars/default.jpg',
        is_kids_profile BIT DEFAULT 0,
        content_preferences VARCHAR(255),
        language_preference VARCHAR(20) DEFAULT 'English',
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );
    PRINT 'Table Profiles created successfully.';
END
GO

-- Create Content table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Content')
BEGIN
    CREATE TABLE Content (
        content_id INT IDENTITY(1,1) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        release_year INT,
        content_type VARCHAR(20) NOT NULL, -- MOVIE or SERIES
        genre VARCHAR(100),
        duration INT, -- in minutes (for movies)
        thumbnail_path VARCHAR(255),
        trailer_url VARCHAR(255),
        maturity_rating VARCHAR(10),
        director VARCHAR(100),
        cast TEXT,
        added_date DATETIME DEFAULT GETDATE(),
        is_featured BIT DEFAULT 0
    );
    PRINT 'Table Content created successfully.';
END
GO

-- Create Episodes table (for series)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Episodes')
BEGIN
    CREATE TABLE Episodes (
        episode_id INT IDENTITY(1,1) PRIMARY KEY,
        content_id INT NOT NULL,
        season_number INT NOT NULL,
        episode_number INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        duration INT NOT NULL, -- in minutes
        thumbnail_path VARCHAR(255),
        release_date DATE,
        FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE
    );
    PRINT 'Table Episodes created successfully.';
END
GO

-- Create Watchlist table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Watchlist')
BEGIN
    CREATE TABLE Watchlist (
        watchlist_id INT IDENTITY(1,1) PRIMARY KEY,
        profile_id INT NOT NULL,
        content_id INT NOT NULL,
        date_added DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE,
        FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE,
        CONSTRAINT UQ_Watchlist UNIQUE (profile_id, content_id)
    );
    PRINT 'Table Watchlist created successfully.';
END
GO

-- Create Ratings table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Ratings')
BEGIN
    CREATE TABLE Ratings (
        rating_id INT IDENTITY(1,1) PRIMARY KEY,
        profile_id INT NOT NULL,
        content_id INT NOT NULL,
        rating_value INT NOT NULL, -- 1-5 stars
        review TEXT,
        rating_date DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE,
        FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE,
        CONSTRAINT UQ_Rating UNIQUE (profile_id, content_id)
    );
    PRINT 'Table Ratings created successfully.';
END
GO

-- Create Subscriptions table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Subscriptions')
BEGIN
    CREATE TABLE Subscriptions (
        subscription_id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT NOT NULL,
        plan_name VARCHAR(50) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        billing_cycle VARCHAR(20) NOT NULL, -- MONTHLY, ANNUALLY
        start_date DATETIME NOT NULL,
        end_date DATETIME,
        status VARCHAR(20) DEFAULT 'ACTIVE',
        max_profiles INT DEFAULT 5,
        max_resolution VARCHAR(10) DEFAULT '1080p',
        FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
    );
    PRINT 'Table Subscriptions created successfully.';
END
GO

-- Create Payments table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Payments')
BEGIN
    CREATE TABLE Payments (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        subscription_id INT NOT NULL,
        amount DECIMAL(10,2) NOT NULL,
        payment_date DATETIME NOT NULL,
        payment_method VARCHAR(50),
        transaction_id VARCHAR(100),
        status VARCHAR(20),
        FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id) ON DELETE CASCADE
    );
    PRINT 'Table Payments created successfully.';
END
GO

-- Create Offers table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Offers')
BEGIN
    CREATE TABLE Offers (
        offer_id INT IDENTITY(1,1) PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        description TEXT,
        discount_percentage INT,
        valid_from DATETIME NOT NULL,
        valid_to DATETIME NOT NULL,
        promo_code VARCHAR(20),
        applicable_plan VARCHAR(50),
        is_active BIT DEFAULT 1
    );
    PRINT 'Table Offers created successfully.';
END
GO

-- Insert sample data for testing
-- Admin user
IF NOT EXISTS (SELECT * FROM Users WHERE email = 'admin@streamflix.com')
BEGIN
    INSERT INTO Users (email, password, full_name, is_admin)
    VALUES ('admin@streamflix.com', 'hashed_password_here', 'Admin User', 1);
    PRINT 'Admin user created.';
END
GO

-- Sample regular user
IF NOT EXISTS (SELECT * FROM Users WHERE email = 'user@example.com')
BEGIN
    INSERT INTO Users (email, password, full_name, phone_number)
    VALUES ('user@example.com', 'hashed_password_here', 'John Doe', '555-123-4567');
    
    DECLARE @user_id INT;
    SELECT @user_id = user_id FROM Users WHERE email = 'user@example.com';
    
    -- Create profiles for the user
    INSERT INTO Profiles (user_id, profile_name, is_kids_profile)
    VALUES (@user_id, 'John', 0);
    
    INSERT INTO Profiles (user_id, profile_name, is_kids_profile)
    VALUES (@user_id, 'Kids', 1);
    
    -- Create subscription for the user
    INSERT INTO Subscriptions (user_id, plan_name, price, billing_cycle, start_date, end_date)
    VALUES (@user_id, 'Premium', 15.99, 'MONTHLY', GETDATE(), DATEADD(MONTH, 1, GETDATE()));
    
    PRINT 'Sample user with profiles and subscription created.';
END
GO

-- Sample content
IF NOT EXISTS (SELECT * FROM Content WHERE title = 'The Adventure Begins')
BEGIN
    INSERT INTO Content (title, description, release_year, content_type, genre, duration, thumbnail_path, maturity_rating)
    VALUES ('The Adventure Begins', 'An epic journey through unknown lands.', 2023, 'MOVIE', 'Adventure', 120, '/images/thumbnails/adventure_begins.jpg', 'PG-13');
    PRINT 'Sample movie content created.';
END
GO

IF NOT EXISTS (SELECT * FROM Content WHERE title = 'Tech Titans')
BEGIN
    INSERT INTO Content (title, description, release_year, content_type, genre, thumbnail_path, maturity_rating)
    VALUES ('Tech Titans', 'A series about the rise of technology companies.', 2022, 'SERIES', 'Drama', '/images/thumbnails/tech_titans.jpg', 'TV-14');
    
    DECLARE @series_id INT;
    SELECT @series_id = content_id FROM Content WHERE title = 'Tech Titans';
    
    -- Add episodes for the series
    INSERT INTO Episodes (content_id, season_number, episode_number, title, description, duration, release_date)
    VALUES (@series_id, 1, 1, 'The Beginning', 'How it all started.', 45, '2022-01-15');
    
    INSERT INTO Episodes (content_id, season_number, episode_number, title, description, duration, release_date)
    VALUES (@series_id, 1, 2, 'Rising Stars', 'New competitors enter the market.', 42, '2022-01-22');
    
    PRINT 'Sample series content with episodes created.';
END
GO

-- Sample offers
IF NOT EXISTS (SELECT * FROM Offers WHERE title = 'Summer Special')
BEGIN
    INSERT INTO Offers (title, description, discount_percentage, valid_from, valid_to, promo_code, applicable_plan, is_active)
    VALUES ('Summer Special', 'Get 20% off on annual subscriptions this summer!', 20, '2023-06-01', '2023-08-31', 'SUMMER20', 'Premium', 1);
    PRINT 'Sample offer created.';
END
GO

PRINT 'Database setup completed successfully.';
GO