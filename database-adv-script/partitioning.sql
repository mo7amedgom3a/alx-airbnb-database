-- Drop existing partitioned table if it exists
DROP TABLE IF EXISTS BookingPartitioned;

-- Create a partitioned version of the Booking table
CREATE TABLE BookingPartitioned (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36),
    user_id CHAR(36),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2),
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_start_date (start_date)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);
-- Query to fetch bookings for 2023
SELECT * FROM BookingPartitioned
WHERE start_date BETWEEN '2023-01-01' AND '2023-12-31';
