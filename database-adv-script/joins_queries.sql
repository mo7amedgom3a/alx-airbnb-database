CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;

-- retrieve all bookings and the respective users who made those bookings.
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    u.email,
    u.phone_number,
    u.role
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- retrieve all properties and their reviews, including properties that have no reviews
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
ORDER BY p.created_at DESC, r.created_at DESC;

--  retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user. use left outter join
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
ORDER BY u.user_id, b.created_at DESC;
