CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;

-- 1. TOTAL BOOKINGS BY EACH USER (COUNT + GROUP BY)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email, u.role
ORDER BY total_bookings DESC, u.first_name;


-- 2. PROPERTY RANKINGS USING WINDOW FUNCTIONS
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(b.booking_id) AS total_bookings,
    -- Different ranking functions
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank_no_gaps
FROM Property p
INNER JOIN User u ON p.host_id = u.user_id
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.location, p.pricepernight, u.first_name, u.last_name
ORDER BY total_bookings DESC, p.name;