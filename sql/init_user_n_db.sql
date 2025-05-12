-- ------------------------------------------------------------------------------------
-- SQL Script to create a MySQL user 'cinephile' with access to the 'streamflix' database
-- ------------------------------------------------------------------------------------

-- Step 1: Create the database if it does not already exist.
-- This ensures the database is available before granting privileges.
CREATE DATABASE IF NOT EXISTS streamflix;

-- Step 2: Create a new MySQL user called 'cinephile' if it doesn't already exist.
-- The user is restricted to connect from 'localhost' only.
-- The IDENTIFIED BY clause sets the password for the user.
CREATE USER IF NOT EXISTS 'cinephile'@'localhost' IDENTIFIED BY 'streamflix2025!';

-- Step 3: Grant all privileges on the 'streamflix' database to the 'cinephile' user.
-- This includes SELECT, INSERT, UPDATE, DELETE, and other standard privileges.
GRANT ALL PRIVILEGES ON streamflix.* TO 'cinephile'@'localhost';

-- Step 4: Apply all privilege changes made above.
-- This ensures that the granted permissions take effect immediately.
FLUSH PRIVILEGES;

-- ------------------------------------------------------------------------------------
-- End of Script
-- ------------------------------------------------------------------------------------
