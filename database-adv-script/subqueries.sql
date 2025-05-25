CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;

-- 1. PROPERTIES WITH AVERAGE RATING > 4.0 USING SUBQUERY
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    u.email AS host_email,
    p.created_at
FROM Property p
INNER JOIN User u ON p.host_id = u.user_id
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name;

-- 2. CORRELATED SUBQUERY: USERS WHO HAVE MADE MORE THAN 3 BOOKINGS
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;