SET sql_mode = 'STRICT_ALL_TABLES';
-- Create a new database
CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;

-- User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
('11111111-1111-1111-1111-111111111111', 'Alice', 'Walker', 'alice@example.com', 'hash_pw_1', '1234567890', 'host'),
('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hash_pw_2', '0987654321', 'guest'),
('33333333-3333-3333-3333-333333333333', 'Charlie', 'Johnson', 'charlie@example.com', 'hash_pw_3', NULL, 'guest'),
('44444444-4444-4444-4444-444444444444', 'Diana', 'Lee', 'diana@example.com', 'hash_pw_4', '1122334455', 'host');

-- Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Cozy Cabin', 'A peaceful retreat in the woods.', 'Asheville, NC', 150.00),
('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '44444444-4444-4444-4444-444444444444', 'Beachfront Bungalow', 'Sunny and relaxing.', 'Malibu, CA', 300.00);

-- Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '2025-06-01', '2025-06-05', 600.00, 'confirmed'),
('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', '2025-07-10', '2025-07-15', 1500.00, 'pending');
-- Payment Table
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
('ccccccc1-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 600.00, 'credit_card');

INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
('eeeeeee1-eeee-eeee-eeee-eeeeeeeeeeee', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hi Alice, is the cabin available in early June?'),
('eeeeeee2-eeee-eeee-eeee-eeeeeeeeeeee', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Yes, it is! Feel free to book it.');
