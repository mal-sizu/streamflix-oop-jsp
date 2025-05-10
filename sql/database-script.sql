-- StreamFlix Database Setup Script

-- Drop existing tables if they exist
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS watchlist;
DROP TABLE IF EXISTS episodes;
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS offers;
DROP TABLE IF EXISTS users;

-- Create tables
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'MEMBER') NOT NULL DEFAULT 'MEMBER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    profile_name VARCHAR(50) NOT NULL,
    avatar_url VARCHAR(255),
    age_limit INT DEFAULT 18,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('MOVIE', 'SERIES') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    genre VARCHAR(50),
    language VARCHAR(50),
    release_date DATE,
    thumbnail_url VARCHAR(255),
    media_url VARCHAR(255)
);

CREATE TABLE episodes (
    episode_id INT PRIMARY KEY AUTO_INCREMENT,
    series_id INT NOT NULL,
    season INT NOT NULL,
    episode_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    media_url VARCHAR(255),
    FOREIGN KEY (series_id) REFERENCES content(content_id) ON DELETE CASCADE
);

CREATE TABLE watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE
);

CREATE TABLE ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
    FOREIGN KEY (content_id) REFERENCES content(content_id) ON DELETE CASCADE
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    subscription_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    method VARCHAR(50) NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE
);

CREATE TABLE offers (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT,
    discount_percent INT NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

-- Insert sample data
-- Admin user (password: admin123)
INSERT INTO users (email, password_hash, name, role) VALUES
('admin@streamflix.com', '$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS', 'Admin User', 'ADMIN');

-- Regular users (password: password123)
INSERT INTO users (email, password_hash, name, role) VALUES
('john@example.com', '$2a$10$E3jR1z9KqM5WG.a9R0Jg1uS6L96AXCaEjz2o6AC9X1PJUDMqK7lGm', 'John Doe', 'MEMBER'),
('jane@example.com', '$2a$10$E3jR1z9KqM5WG.a9R0Jg1uS6L96AXCaEjz2o6AC9X1PJUDMqK7lGm', 'Jane Smith', 'MEMBER');

-- Profiles
INSERT INTO profiles (user_id, profile_name, avatar_url, age_limit) VALUES
(1, 'Admin', '/images/avatars/admin.jpg', 18),
(2, 'John', '/images/avatars/john.jpg', 18),
(2, 'John Jr', '/images/avatars/john_jr.jpg', 12),
(3, 'Jane', '/images/avatars/jane.jpg', 18);

-- Movies
INSERT INTO content (type, title, description, genre, language, release_date, thumbnail_url, media_url) VALUES
('MOVIE', 'The Adventure Begins', 'An epic tale of adventure and discovery', 'Adventure', 'English', '2023-01-15', '/images/thumbnails/adventure_begins.jpg', '/media/movies/adventure_begins.mp4'),
('MOVIE', 'Midnight Mystery', 'A thrilling detective story', 'Mystery', 'English', '2023-03-22', '/images/thumbnails/midnight_mystery.jpg', '/media/movies/midnight_mystery.mp4'),
('MOVIE', 'Love in Paris', 'A romantic story set in the city of love', 'Romance', 'French', '2022-12-10', '/images/thumbnails/love_paris.jpg', '/media/movies/love_paris.mp4');

-- Series
INSERT INTO content (type, title, description, genre, language, release_date, thumbnail_url, media_url) VALUES
('SERIES', 'Tech Titans', 'The rise and fall of tech companies', 'Drama', 'English', '2023-02-05', '/images/thumbnails/tech_titans.jpg', NULL),
('SERIES', 'Galaxy Quest', 'Space adventures in a distant galaxy', 'Sci-Fi', 'English', '2022-11-18', '/images/thumbnails/galaxy_quest.jpg', NULL);

-- Episodes
INSERT INTO episodes (series_id, season, episode_number, title, media_url) VALUES
(4, 1, 1, 'The Beginning', '/media/series/tech_titans/s01e01.mp4'),
(4, 1, 2, 'The Breakthrough', '/media/series/tech_titans/s01e02.mp4'),
(4, 1, 3, 'The Competition', '/media/series/tech_titans/s01e03.mp4'),
(5, 1, 1, 'New Worlds', '/media/series/galaxy_quest/s01e01.mp4'),
(5, 1, 2, 'First Contact', '/media/series/galaxy_quest/s01e02.mp4');

-- Watchlist
INSERT INTO watchlist (profile_id, content_id) VALUES
(2, 1),
(2, 4),
(3, 3),
(4, 2),
(4, 5);

-- Ratings
INSERT INTO ratings (profile_id, content_id, score, review_text) VALUES
(2, 1, 5, 'Absolutely loved it!'),
(2, 4, 4, 'Great story and characters'),
(4, 2, 5, 'Best mystery movie I\'ve seen this year'),
(4, 5, 3, 'Good but not great');

-- Subscriptions
INSERT INTO subscriptions (user_id, plan, start_date, end_date, status) VALUES
(2, 'Premium', '2023-01-01', '2024-01-01', 'ACTIVE'),
(3, 'Standard', '2023-02-15', '2024-02-15', 'ACTIVE');

-- Payments
INSERT INTO payments (subscription_id, amount, payment_date, method) VALUES
(1, 199.99, '2023-01-01', 'Credit Card'),
(2, 149.99, '2023-02-15', 'PayPal');

-- Offers
INSERT INTO offers (code, description, discount_percent, valid_from, valid_to) VALUES
('WELCOME25', 'Welcome discount for new users', 25, '2023-01-01', '2023-12-31'),
('SUMMER50', 'Summer special discount', 50, '2023-06-01', '2023-08-31');
