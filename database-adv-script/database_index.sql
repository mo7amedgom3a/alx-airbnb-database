USE `airbnb_clone`;

-- 3. CREATE OPTIMIZED INDEXES
-- ============================================================================

-- USER TABLE INDEXES
-- ============================================================================

-- Email lookup (login, unique user identification)
CREATE INDEX idx_user_email ON User(email);

-- Role-based queries (filter by user type)
CREATE INDEX idx_user_role ON User(role);

-- Date-based user registration queries
CREATE INDEX idx_user_created_at ON User(created_at);

-- Composite index for role + registration date queries
CREATE INDEX idx_user_role_created ON User(role, created_at);

-- show all indexes for User table
SHOW INDEX FROM User;

-- explain the query plan for a user lookup by email
EXPLAIN SELECT * FROM User WHERE email = 'juan14@example.org';
-- With analyze to get execution statistics
EXPLAIN ANALYZE SELECT * FROM User WHERE email = 'juan14@example.org';

-- PROPERTY TABLE INDEXES
-- ============================================================================

-- Host lookup (find properties by host)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Location-based searches
CREATE INDEX idx_property_location ON Property(location);

-- Price range filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Property creation date
CREATE INDEX idx_property_created_at ON Property(created_at);

-- Composite index for location + price searches (most common property search)
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Composite index for host properties with creation date
CREATE INDEX idx_property_host_created ON Property(host_id, created_at);

-- Analyze property queries
EXPLAIN ANALYZE SELECT * FROM Property WHERE location = 'New York' AND pricepernight < 200;
EXPLAIN ANALYZE SELECT * FROM Property WHERE host_id = 101;

-- BOOKING TABLE INDEXES
-- ============================================================================

-- Property bookings lookup
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- User bookings lookup
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Booking status filtering
CREATE INDEX idx_booking_status ON Booking(status);

-- Booking creation date
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Date range queries (availability checks)
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for date range overlap queries
CREATE INDEX idx_booking_date_range ON Booking(property_id, start_date, end_date);

-- Composite index for user booking history
CREATE INDEX idx_booking_user_status ON Booking(user_id, status, created_at);

-- Composite index for property booking analysis
CREATE INDEX idx_booking_property_status ON Booking(property_id, status, start_date);

-- Total price for revenue queries
CREATE INDEX idx_booking_total_price ON Booking(total_price);

-- Analyze booking queries
EXPLAIN ANALYZE SELECT * FROM Booking WHERE property_id = 42 AND start_date >= '2023-01-01' AND end_date <= '2023-01-15';
EXPLAIN ANALYZE SELECT * FROM Booking WHERE user_id = 123 AND status = 'confirmed';

-- REVIEW TABLE INDEXES
-- ============================================================================

-- Property reviews lookup
CREATE INDEX idx_review_property_id ON Review(property_id);

-- User reviews lookup
CREATE INDEX idx_review_user_id ON Review(user_id);

-- Rating-based queries
CREATE INDEX idx_review_rating ON Review(rating);

-- Review date queries
CREATE INDEX idx_review_created_at ON Review(created_at);

-- Composite index for property rating analysis
CREATE INDEX idx_review_property_rating ON Review(property_id, rating, created_at);

-- Analyze review queries
EXPLAIN ANALYZE SELECT * FROM Review WHERE property_id = 42 ORDER BY rating DESC;

-- PAYMENT TABLE INDEXES
-- ============================================================================

-- Booking payment lookup
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Payment method analysis
CREATE INDEX idx_payment_method ON Payment(payment_method);

-- Payment date queries
CREATE INDEX idx_payment_date ON Payment(payment_date);

-- Composite index for payment analysis
CREATE INDEX idx_payment_method_date ON Payment(payment_method, payment_date);

-- Analyze payment queries
EXPLAIN ANALYZE SELECT * FROM Payment WHERE payment_method = 'credit_card' AND payment_date > '2023-01-01';

-- MESSAGE TABLE INDEXES
-- ============================================================================

-- Sender messages lookup
CREATE INDEX idx_message_sender_id ON Message(sender_id);

-- Recipient messages lookup
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);

-- Message chronological ordering
CREATE INDEX idx_message_sent_at ON Message(sent_at);

-- Composite index for conversation threads
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- Analyze message queries
EXPLAIN ANALYZE SELECT * FROM Message WHERE sender_id = 42 AND recipient_id = 101 ORDER BY sent_at DESC;

-- ============================================================================
-- 4. SPECIALIZED INDEXES FOR COMMON QUERY PATTERNS
-- ============================================================================

-- Index for finding available properties in date range
CREATE INDEX idx_availability_check ON Booking(property_id, start_date, end_date, status);

-- Index for host revenue analysis
CREATE INDEX idx_host_revenue ON Property(host_id) 
    -- Note: This would be better as a covering index in some databases
    -- INCLUDE (name, pricepernight) -- PostgreSQL syntax
;

-- Index for popular properties (booking count analysis)
CREATE INDEX idx_popular_properties ON Booking(property_id, status, created_at);

-- Index for user activity analysis
CREATE INDEX idx_user_activity ON Booking(user_id, status, total_price, created_at);

-- Index for location-based property search with ratings
-- This would require a materialized view or denormalized data in production
-- CREATE INDEX idx_location_rating ON Property(location, /* avg_rating would go here */);

-- Analyze complex query patterns
EXPLAIN ANALYZE 
SELECT p.id, p.name, p.location, COUNT(b.id) as booking_count 
FROM Property p
JOIN Booking b ON p.id = b.property_id
WHERE b.status = 'confirmed' 
GROUP BY p.id
ORDER BY booking_count DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT * FROM Property p
WHERE p.location = 'Miami' 
AND p.id NOT IN (
    SELECT property_id FROM Booking 
    WHERE status = 'confirmed'
    AND ((start_date <= '2023-12-24' AND end_date >= '2023-12-20') 
    OR (start_date <= '2023-12-30' AND end_date >= '2023-12-24'))
);

-- ============================================================================
-- 5. MAINTENANCE COMMANDS
-- ============================================================================

-- Analyze tables to update statistics after creating indexes
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Booking;
ANALYZE TABLE Review;
ANALYZE TABLE Payment;
ANALYZE TABLE Message;
