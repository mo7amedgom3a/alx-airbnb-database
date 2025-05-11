-- Enable UUID support if needed (in application layer)
-- Set strict SQL mode for safer defaults
SET sql_mode = 'STRICT_ALL_TABLES';
-- Create a new database
CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;
-- USER TABLE
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (user_id),
    INDEX (email)
);

-- PROPERTY TABLE
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id),
    INDEX (property_id),
    INDEX (host_id)
);

-- BOOKING TABLE
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    INDEX (booking_id),
    INDEX (property_id),
    INDEX (user_id)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    INDEX (payment_id),
    INDEX (booking_id)
);

-- REVIEW TABLE
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    INDEX (review_id),
    INDEX (property_id),
    INDEX (user_id)
);

-- MESSAGE TABLE
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (recipient_id) REFERENCES User(user_id),
    INDEX (message_id),
    INDEX (sender_id),
    INDEX (recipient_id)
);

-- update the primary keys to be auto-incrementing UUIDs
ALTER TABLE User MODIFY user_id CHAR(36) NOT NULL DEFAULT (UUID());
ALTER TABLE Property MODIFY property_id CHAR(36) NOT NULL DEFAULT (UUID());
ALTER TABLE Booking MODIFY booking_id CHAR(36) NOT NULL DEFAULT (UUID());
ALTER TABLE Payment MODIFY payment_id CHAR(36) NOT NULL DEFAULT (UUID());
ALTER TABLE Review MODIFY review_id CHAR(36) NOT NULL DEFAULT (UUID());
ALTER TABLE Message MODIFY message_id CHAR(36) NOT NULL DEFAULT (UUID());
